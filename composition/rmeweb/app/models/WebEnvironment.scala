package models

import org.rugco.crc.{RuleControlApi, JsRmeRule, JsVariable}

/**
 * User: vdegeler
 * Date: 10/20/12
 * Time: 2:30 PM
 */
case class WebEnvironment(sensors:List[JsVariable], senserrors:List[JsVariable],
                          actuators:List[JsVariable], acterrors:List[JsVariable], actuser:List[JsVariable],
                          unsat:List[JsRmeRule], active:List[JsRmeRule], inactive:List[JsRmeRule]) {}

object WebEnvironment {
  def getCurrent:WebEnvironment = {
    val vars = RuleControlApi.getVariables

    def filterVars(vars:Set[JsVariable],f:JsVariable => Boolean):List[JsVariable] =
      vars.filter(v => f(v)).toList.sortBy(s => (s.siname+s.name))

    val senserrors = filterVars(vars,(v => !v.controllable && v.blocked.contains("error")))
    val sensors = filterVars(vars,(v => !v.controllable && !senserrors.contains(v)))
    val acterrors = filterVars(vars,(v => v.controllable && v.blocked.contains("error")))
    val actuser = filterVars(vars,(v => v.controllable && v.blocked.contains("user_feedback") && !acterrors.contains(v)))
    val actuators = filterVars(vars,(v => v.controllable && !acterrors.contains(v) && !actuser.contains(v)))

    val rmeRules = RuleControlApi.getRmeRules
    val unsat = rmeRules.filter(r => r.isActive && !r.isSatisfied).toList.sortBy(r => r.strRule)
    val active = rmeRules.filter(r => r.isActive && r.isSatisfied).toList.sortBy(r => r.strRule)
    val inactive = rmeRules.filter(r => !r.isActive).toList.sortBy(r => r.strRule)
    new WebEnvironment(sensors,senserrors,actuators,acterrors,actuser,unsat,active,inactive)
  }
}