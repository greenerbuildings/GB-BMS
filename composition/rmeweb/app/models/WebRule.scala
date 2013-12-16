package models

import org.rugco.crc.JsRule

/**
 * User: vdegeler
 * Date: 8/31/12
 * Time: 11:38 AM
 */
case class WebRule(strRule:String) {
  var rid:Int = -1
  var cnfForm:String = ""
  var splitRules:Set[String] = Set()
  val toJs:JsRule = {
    JsRule(rid,strRule,cnfForm,splitRules)
  }
}

object WebRule {
  def create(jsRule:JsRule):WebRule = {
    val wr = WebRule(jsRule.strrule)
    wr.cnfForm = jsRule.cnfForm
    wr.rid = jsRule.rid
    wr.splitRules = jsRule.splitRules
    wr
  }

  def create(jsRules:Set[JsRule]):List[WebRule] = {
    jsRules.map(jr => WebRule.create(jr)).toList.sortBy(r => r.strRule)
  }

  val empty = WebRule("")
}