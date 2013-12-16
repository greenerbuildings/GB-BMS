package controllers

import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import views._
import models.WebEnvironment

/**
 * User: vdegeler
 * Date: 9/2/12
 * Time: 1:21 PM
 */
object ApplEnvironment extends Controller {
  def showEnvironment = Action{
    Ok(html.environment(WebEnvironment.getCurrent))
  }
}
