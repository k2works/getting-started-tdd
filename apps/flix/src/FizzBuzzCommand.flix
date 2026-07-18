///
/// FizzBuzz の実行要求を表すコマンド。
/// タイプを保持し、数に対する処理を実行する。
///
enum FizzBuzzCommand {
    case ValueCommand(FizzBuzzType)  // 単一の値を生成する
    case ListCommand(FizzBuzzType)   // 1 から n までのリストを生成する
}

mod FizzBuzzCommand {
    ///
    /// コマンドを数 `n` に対して実行し、結果コレクションを返す。
    ///
    pub def execute(cmd: FizzBuzzCommand, n: Int32): FizzBuzzList = match cmd {
        case FizzBuzzCommand.ValueCommand(fbType) =>
            FizzBuzzList.FizzBuzzList(FizzBuzzValue.create(fbType, n) :: Nil)
        case FizzBuzzCommand.ListCommand(fbType) =>
            FizzBuzzList.create(n, fbType)
    }
}
