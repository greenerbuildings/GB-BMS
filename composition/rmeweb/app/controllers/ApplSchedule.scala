package controllers

import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import views._
import models.WebJsonFile
import org.rugco.crc.{JsScheduledRule, RuleControlApi}

/**
 * User: vdegeler
 * Date: 8/30/12
 * Time: 2:54 PM
 */
object ApplSchedule extends Controller {

  val scheduleForm:Form[JsScheduledRule] = Form(
    mapping(
      "strRule" -> nonEmptyText,
      "start" -> nonEmptyText,
      "finish" -> nonEmptyText
    )(JsScheduledRule.apply)(JsScheduledRule.unapply)
  )

  def showSchedule = Action {
    val rls = RuleControlApi.getScheduledRules.toList
    Ok(html.schedule(rls,scheduleForm,jsonFileForm,""))
  }


  def newRule = Action { implicit request =>
    scheduleForm.bindFromRequest.fold(
      // Form has errors, redisplay it
      errors => BadRequest(html.schedule(RuleControlApi.getScheduledRules.toList,errors,jsonFileForm,"")),

      // We got a valid User value, display the summary
      nsr => {
        val (noErrors, strError) = RuleControlApi.createScheduledRuleUnparsed(nsr)
        if (noErrors) Redirect(routes.ApplSchedule.showSchedule())
        else BadRequest(html.schedule(RuleControlApi.getScheduledRules.toList,scheduleForm.fill(nsr),jsonFileForm,strError))
      }
    )
  }

  def deleteRule(rid:Int) = Action {
    RuleControlApi.removeRule(rid)
    Redirect(routes.ApplSchedule.showSchedule())
  }

  val jsonFileForm:Form[WebJsonFile] = Form(
    mapping(
      "filename" -> nonEmptyText
    )(WebJsonFile.apply)(WebJsonFile.unapply)
  )

  def jsonSaveOrLoad = Action { implicit request => {
    val body: AnyContent = request.body
    jsonFileForm.bindFromRequest.fold(
      errors => BadRequest(html.schedule(RuleControlApi.getScheduledRules.toList,scheduleForm,errors,"")),
      filename => {
        val fullfilename = "public/json/"+filename.filename
        if (body.toString.contains("btnSave")) {
          val pw = new java.io.PrintWriter(fullfilename)
          pw.println(RuleControlApi.getScheduledRules)
          pw.close
        } else if (body.toString.contains("btnLoad")) {
          val source = scala.io.Source.fromFile(fullfilename)
          val jsonString = source.mkString
          source.close ()
          RuleControlApi.createScheduledRulesFromJson(jsonString)
        }
        Redirect(routes.ApplSchedule.showSchedule())
      }
    )
  }
  }

}
