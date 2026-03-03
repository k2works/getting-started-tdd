#!/usr/bin/env scala-cli
// complexity.sc — Scala ソースの循環複雑度を計測するスクリプト
//
// 使い方: scala-cli scripts/complexity.sc -- [--threshold N] [path ...]
//
// 循環複雑度の計算ルール:
//   基本複雑度 = 1（メソッドごと）
//   +1: if, else if
//   +1: match/case の各分岐（ワイルドカード除く）
//   +1: while, for
//   +1: && , ||（短絡評価による分岐）
//   +1: try, catch

import java.io.File
import scala.io.Source
import scala.util.matching.Regex

case class FunctionComplexity(file: String, name: String, complexity: Int)

def countComplexity(lines: List[String]): Int =
  val branchPatterns = List(
    raw"\bif\b"            -> 1,
    raw"\belse\s+if\b"    -> 1,
    raw"\bwhile\b"        -> 1,
    raw"\bfor\b"          -> 1,
    raw"\btry\b"          -> 1,
    raw"\bcatch\b"        -> 1,
    raw"&&"               -> 1,
    raw"\|\|"             -> 1,
  )
  val casePattern = raw"\bcase\b(?!\s+class\b)(?!\s+object\b)".r

  var complexity = 0
  for line <- lines do
    val trimmed = line.trim
    if !trimmed.startsWith("//") && !trimmed.startsWith("*") then
      for (pattern, weight) <- branchPatterns do
        complexity += pattern.r.findAllIn(line).length * weight
      complexity += casePattern.findAllIn(line).length

  complexity

def extractMethods(file: File): List[FunctionComplexity] =
  val source = Source.fromFile(file)
  val allLines = try source.getLines().toList finally source.close()

  val defPattern = raw"\s*(?:def|val)\s+(\w+)".r
  var results = List.empty[FunctionComplexity]
  var currentMethod: Option[String] = None
  var methodLines = List.empty[String]
  var braceDepth = 0
  var methodStartDepth = 0

  def flushMethod(): Unit =
    currentMethod.foreach { name =>
      val cc = 1 + countComplexity(methodLines)
      results = results :+ FunctionComplexity(file.getPath, name, cc)
    }
    currentMethod = None
    methodLines = Nil

  for line <- allLines do
    val openBraces = line.count(_ == '{')
    val closeBraces = line.count(_ == '}')

    line match
      case defPattern(name) if currentMethod.isEmpty =>
        currentMethod = Some(name)
        methodStartDepth = braceDepth
        methodLines = List(line)
      case _ if currentMethod.isDefined =>
        methodLines = methodLines :+ line
      case _ => ()

    braceDepth += openBraces - closeBraces

    if currentMethod.isDefined && braceDepth <= methodStartDepth && methodLines.length > 1 then
      flushMethod()

  // Scala 3 インデントベース構文: メソッドが閉じていない場合
  flushMethod()
  results

def findScalaFiles(paths: List[String]): List[File] =
  def walk(f: File): List[File] =
    if f.isDirectory then f.listFiles().toList.flatMap(walk)
    else if f.getName.endsWith(".scala") then List(f)
    else Nil
  paths.flatMap(p => walk(new File(p)))

// メイン処理
val args = if _root_.scala.util.Properties.isWin then
  Array.empty[String]
else
  _root_.scala.sys.process.Process("echo").!!.trim.split(" ").filter(_.nonEmpty)

val defaultThreshold = 7
val defaultPaths = List("src")

val cliArgs = ScalaCliArgs(this.args.toList)

case class ScalaCliArgs(raw: List[String]):
  val thresholdIdx = raw.indexOf("--threshold")
  val threshold: Int = if thresholdIdx >= 0 && thresholdIdx + 1 < raw.length then
    raw(thresholdIdx + 1).toInt
  else defaultThreshold
  val paths: List[String] =
    val filtered = if thresholdIdx >= 0 then
      raw.take(thresholdIdx) ++ raw.drop(thresholdIdx + 2)
    else raw
    if filtered.isEmpty then defaultPaths else filtered

val files = findScalaFiles(cliArgs.paths)
val results = files.flatMap(extractMethods)
val violations = results.filter(_.complexity > cliArgs.threshold)

println(s"=== Scala 循環複雑度チェック (閾値: ${cliArgs.threshold}) ===")
println()

for r <- results.sortBy(-_.complexity) do
  val status = if r.complexity > cliArgs.threshold then "NG" else "OK"
  val fileName = new File(r.file).getName
  println(f"  $status%-2s ${r.name}%-40s (${fileName}%-20s) 複雑度: ${r.complexity}%d")

println()
println(s"関数数: ${results.length}, 違反: ${violations.length}")

if violations.nonEmpty then
  println()
  println("以下の関数が閾値を超えています:")
  for v <- violations do
    println(s"  - ${v.name} (${v.file}): 複雑度 ${v.complexity} > ${cliArgs.threshold}")
  sys.exit(1)
else
  println()
  println("OK すべての関数が複雑度閾値以内です。")
