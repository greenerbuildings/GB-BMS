package controllers

import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import views._
import models.{WebJsonFile, WebRule}
import org.rugco.crc.RuleControlApi
import scalax.io._

/**
 * User: vdegeler
 * Date: 8/30/12
 * Time: 2:54 PM
 */
object ApplRule extends Controller {

  val ruleForm:Form[WebRule] = Form(
    mapping(
      "strRule" -> nonEmptyText
    )(WebRule.apply)(WebRule.unapply)
  )

  def showRules = Action {
    val rls = WebRule.create(RuleControlApi.getRules)
    Ok(html.rules(rls,ruleForm,jsonFileForm,""))
  }


  def newRule = Action { implicit request =>
    ruleForm.bindFromRequest.fold(
      // Form has errors, redisplay it
      errors => BadRequest(html.rules(WebRule.create(RuleControlApi.getRules),errors,jsonFileForm,"")),

      // We got a valid User value, display the summary
      newWebRule => {
        val (noErrors, strError) = RuleControlApi.createRuleUnparsed(newWebRule.strRule)
        if (noErrors) Redirect(routes.ApplRule.showRules())
        else BadRequest(html.rules(WebRule.create(RuleControlApi.getRules),ruleForm.fill(newWebRule),jsonFileForm,strError))
      }
    )
  }

  def deleteRule(rid:Int) = Action {
    RuleControlApi.removeRule(rid)
    Redirect(routes.ApplRule.showRules())
  }

  val jsonFileForm:Form[WebJsonFile] = Form(
    mapping(
      "filename" -> nonEmptyText
    )(WebJsonFile.apply)(WebJsonFile.unapply)
  )

  def jsonSaveOrLoad = Action { implicit request => {
    val body: AnyContent = request.body
    jsonFileForm.bindFromRequest.fold(
      errors => BadRequest(html.rules(WebRule.create(RuleControlApi.getRules),ruleForm,errors,"")),
      filename => {
        val fullfilename = "public/json/"+filename.filename
        if (body.toString.contains("btnSave")) {
          val pw = new java.io.PrintWriter(fullfilename)
          pw.println(RuleControlApi.getRulesJsonString)
          pw.close
        } else if (body.toString.contains("btnLoad")) {
          val source = scala.io.Source.fromFile(fullfilename)
          val jsonString = source.mkString
          source.close ()
          RuleControlApi.createRulesFromJson(jsonString)
        }
        Redirect(routes.ApplRule.showRules())
      }
    )
  }
  }

}
