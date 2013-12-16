import sbt._
import Keys._
import play.Project._

object ApplicationBuild extends Build {

  val appName         = "rmeweb"
  val appVersion      = "1.2.1.3"

  val appDependencies = Seq(
    // Add your project dependencies here,
    jdbc,
    anorm,
      //"org.rugco" % "server"      % "1.4.1"
      "org.rugco" % "crc"      % "1.2.1.3.0"
  )


  val main = play.Project(appName, appVersion, appDependencies).settings(
    // Add your own project settings here      
      resolvers += "rug.release" at "http://sm4all-project.eu/nexus/content/repositories/rug.release",
      resolvers += "rug.snaphot" at "http://sm4all-project.eu/nexus/content/repositories/rug.snapshot",
      //      resolvers += "thirdparty"  at "http://sm4all-project.eu/nexus/content/repositories/thirdparty",
      resolvers += "spray.repo"  at "http://repo.spray.io"
  )

}
