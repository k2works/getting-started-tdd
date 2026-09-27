package フィズバズ

/** 題材 D: 変換結果（成功または失敗）。 */
enum 変換結果:
  case 成功(値: String)
  case 失敗(エラー: String)

/** 0 以下なら失敗、それ以外は FizzBuzz 変換の結果を成功として返す。 */
def 安全変換(数: Int): 変換結果 =
  if 数 <= 0 then 変換結果.失敗(s"正の数を指定してください: $数")
  else 変換結果.成功(FizzBuzz変換(数))
