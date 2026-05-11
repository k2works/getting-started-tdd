ThisBuild / scalaVersion := "3.3.3"

lazy val root = (project in file("."))
  .settings(
    name := "fizzbuzz",
    libraryDependencies += "org.scalatest" %% "scalatest" % "3.2.19" % Test
  )
