package models

import org.rugco.crc.JsVariable

/**
 * User: vdegeler
 * Date: 8/29/12
 * Time: 8:31 PM
 */
case class WebVariable(siname:String, name:String, location:String, controllable:Boolean, slow:Boolean,
                       states:String, datatype:String, range:String = "") {
}

object WebVariable {
  def create(jsVar:JsVariable):WebVariable = {
    WebVariable(jsVar.siname,jsVar.name,jsVar.location,jsVar.controllable,jsVar.slow,
      if (jsVar.domain.states.isEmpty) "" else jsVar.domain.states.map(st => st.name).reduce((a,b)=> a+"; "+b),
      jsVar.domain.datatype, jsVar.domain.range)
  }

  def create(jsVars:Set[JsVariable]):List[WebVariable] = {
    jsVars.map(jv => WebVariable.create(jv)).toList.sortBy(s => (s.siname+s.name))
  }
}
