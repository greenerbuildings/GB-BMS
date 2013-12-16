package controllers

import play.api.mvc._
import play.api.data._
import play.api.data.Forms._

import views._
import org.rugco.crc._
import models.{WebJsonFile, WebVariable}
import scalax.io._

/**
 * User: vdegeler
 * Date: 8/29/12
 * Time: 4:23 PM
 */
object ApplVariable extends Controller {
  val changevars = true

  val variableForm:Form[WebVariable] = Form(
    mapping(
      "siname" -> nonEmptyText,
      "name" -> nonEmptyText,
      "location" -> nonEmptyText,
      "controllable" -> boolean,
      "slow" -> boolean,
      "states" -> nonEmptyText,
      "datatype" -> nonEmptyText,
      "range" -> text
  )(WebVariable.apply)(WebVariable.unapply)
  )

  def variables = Action {
    val vars = WebVariable.create(RuleControlApi.getVariables)
    Ok(html.variables(vars,variableForm,jsonFileForm,changevars))
  }

  def newVariable = Action { implicit request =>
    variableForm.bindFromRequest.fold(
      // Form has errors, redisplay it
      errors => BadRequest(html.variables(WebVariable.create(RuleControlApi.getVariables),errors,jsonFileForm,changevars)),

      // We got a valid User value, display the summary
      nv => {
        RuleControlApi.createVariableUnparsed(nv.siname,nv.name,nv.location,nv.controllable,nv.states,nv.datatype,nv.slow,nv.range)
        Redirect(routes.ApplVariable.variables)
      }
    )
  }

  def deleteVariable(siname:String, varname:String) = Action {
    //WebVariable.delete(siname, varname)
    RuleControlApi.removeVariable(siname, varname)
    Redirect(routes.ApplVariable.variables)
  }

  val jsonFileForm:Form[WebJsonFile] = Form(
    mapping(
      "filename" -> nonEmptyText
    )(WebJsonFile.apply)(WebJsonFile.unapply)
  )

  def jsonSaveOrLoad = Action { implicit request => {
    val body: AnyContent = request.body
    jsonFileForm.bindFromRequest.fold(
      errors => BadRequest(html.variables(WebVariable.create(RuleControlApi.getVariables),variableForm,errors,changevars)),
      filename => {
        val fullfilename = "public/json/"+filename.filename
        if (body.toString.contains("btnSave")) {
          val pw = new java.io.PrintWriter(fullfilename)
          pw.println(RuleControlApi.getVariablesJsonString)
          pw.close
        } else if (body.toString.contains("btnLoad")) {
          val source = scala.io.Source.fromFile(fullfilename)
          val jsonString = source.mkString
          source.close ()
          RuleControlApi.createVariablesFromJson(jsonString)
        }
        Redirect(routes.ApplVariable.variables)
      }
    )
  }
  }
}
