package controllers

import views.html
import play.api.mvc._

object Application extends Controller {
  
  def index = Action {
    //Redirect(routes.ApplVariable.variables)
    Ok(html.help())
  }
  
}