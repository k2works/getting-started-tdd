lazy val root = (project in file("."))
  .settings(
    name := "fizzbuzz-jp",
    version := "0.1.0",
    scalaVersion := "3.3.4",
    libraryDependencies ++= Seq(
      "org.scalatest" %% "scalatest" % "3.2.18" % Test
    ),
    scalacOptions ++= Seq(
      "-deprecation",
      "-feature",
      "-unchecked",
      "-Xfatal-warnings"
    )
  )
