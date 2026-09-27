package フィズバズ;

/** 題材 D: 変換結果（成功または失敗）。 */
public sealed interface 変換結果 {

    /**
     * 成功。
     *
     * @param 値 変換した値
     */
    record 成功(String 値) implements 変換結果 {
    }

    /**
     * 失敗。
     *
     * @param エラー エラーメッセージ
     */
    record 失敗(String エラー) implements 変換結果 {
    }
}
