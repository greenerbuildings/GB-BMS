package controllers

import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import views._
import org.rugco.crc._
import models.WebCfdResponse

/**
 * User: vdegeler
 * Date: 9/2/12
 * Time: 5:01 PM
 */
object ApplChangeVar extends Controller {
  def showChangeVarPage = Action {
    val vars = RuleControlApi.getVariables
    val sensors =        vars.filter(v => !v.controllable && v.domain.range == "").toList.sortBy(s => (s.siname+s.name))
    val rangesensors =   vars.filter(v => !v.controllable && v.domain.range != "").toList.sortBy(s => (s.siname+s.name))
    val actuators =      vars.filter(v =>  v.controllable && v.domain.range == "").toList.sortBy(s => (s.siname+s.name))
    val rangeactuators = vars.filter(v =>  v.controllable && v.domain.range != "").toList.sortBy(s => (s.siname+s.name))
    Ok(html.changevar(sensors,rangesensors,actuators,rangeactuators,cfdResponseForm))
  }

  def changeVariable(siname:String, varname:String, statename:String) = Action { implicit request => {
    val body: String = request.body.toString
    val event = if (body.contains("xerror")) "error" else if (body.contains("xuser")) "user_feedback" else "update"
    request.body.asFormUrlEncoded match {
      case Some(res) => {
        if (res.contains("state")) {
          val state = res("state").head
          RuleControlApi.updateVariable(event,siname,varname,state)
        }
        else RuleControlApi.updateVariable(event,siname,varname,statename)
      }
      case None => {}
    }
    Redirect(routes.ApplChangeVar.showChangeVarPage)
  }}

  val cfdResponseForm:Form[WebCfdResponse] = Form(
    mapping(
      "id" -> number,
      "time" -> nonEmptyText
    )(WebCfdResponse.apply)(WebCfdResponse.unapply)
  )

  def cfdResponse = Action { implicit request =>
    cfdResponseForm.bindFromRequest.fold(
      errors => Redirect(routes.ApplChangeVar.showChangeVarPage),
      nv => {
        RuleControlApi.cfdResponse(nv.id,nv.time)
        Redirect(routes.ApplChangeVar.showChangeVarPage)
      }
    )
  }

}
