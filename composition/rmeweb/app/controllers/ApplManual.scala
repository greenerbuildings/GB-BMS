package controllers

import play.api.mvc.{Controller, Action}
import views.html
import org.rugco.crc.RuleControlApi

/**
 * User: vdegeler
 * Date: 12/8/12
 * Time: 2:39 PM
 */
object ApplManual extends Controller {
  def index = Action {
    Ok(html.manual())
  }

  def manualAction =  Action { implicit request => {
    request.body.asFormUrlEncoded match {
      case Some(res) => {
        if (res.contains("unblock")) RuleControlApi.manualAction("unblock")
        if (res.contains("recheck")) RuleControlApi.manualAction("recheck")
        if (res.contains("reread")) RuleControlApi.manualAction("reread")
        if (res.contains("saverules")) RuleControlApi.manualAction("saverules")
      }
      case None => {}
    }
    Ok(html.manual())
  }}
}
