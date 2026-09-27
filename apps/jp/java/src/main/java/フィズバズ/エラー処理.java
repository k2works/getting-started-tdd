package フィズバズ;

/** 題材 D: 例外を投げずに結果を返す変換。 */
public final class エラー処理 {

    private エラー処理() {
    }

    /** 0 以下なら失敗、それ以外は FizzBuzz 変換の結果を成功として返す。 */
    public static 変換結果 安全変換(int 数) {
        if (数 <= 0) {
            return new 変換結果.失敗("正の数を指定してください: " + 数);
        }
        return new 変換結果.成功(FizzBuzz.FizzBuzz変換(数));
    }
}
