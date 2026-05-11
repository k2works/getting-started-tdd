ThisBuild / scalaVersion := "3.3.3"

lazy val verify = taskKey[Unit]("Run format check and tests")

lazy val root = (project in file("."))
  .settings(
    name := "fizzbuzz",
    version := "0.1.0",
    scalacOptions ++= Seq(
      "-deprecation",
      "-feature",
      "-unchecked",
      "-Xfatal-warnings"
    ),
    libraryDependencies += "org.scalatest" %% "scalatest" % "3.2.19" % Test,
    wartremoverErrors ++= Seq(
      Wart.Null,
      Wart.Var,
      Wart.Return
    ),
    verify := {
      (Compile / compile).value
      (Test / test).value
    }
  )
