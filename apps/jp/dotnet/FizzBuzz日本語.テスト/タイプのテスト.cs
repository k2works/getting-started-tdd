namespace FizzBuzz日本語.テスト;

using FizzBuzz日本語;
using static FizzBuzz日本語.タイプ;

public class タイプのテスト
{
    [Fact(DisplayName = "タイプ1は通常の変換をする")]
    public void タイプ1は通常の変換をする()
    {
        var 通常 = タイプ生成(1);
        Assert.Equal("Fizz", タイプ変換(通常, 3));
        Assert.Equal("通常", 通常.名前);
    }

    [Fact(DisplayName = "タイプ2は数字だけを返す")]
    public void タイプ2は数字だけを返す()
    {
        var 数字 = タイプ生成(2);
        Assert.Equal("3", タイプ変換(数字, 3));
        Assert.Equal("数字限定", 数字.名前);
    }

    [Fact(DisplayName = "タイプ3は15の倍数だけFizzBuzzを返す")]
    public void タイプ3は15の倍数だけFizzBuzzを返す()
    {
        Assert.Equal("FizzBuzz", タイプ変換(タイプ生成(3), 15));
    }

    [Fact(DisplayName = "タイプ3は3の倍数を数字で返す")]
    public void タイプ3は3の倍数を数字で返す()
    {
        Assert.Equal("3", タイプ変換(タイプ生成(3), 3));
    }

    [Fact(DisplayName = "存在しないタイプはエラーになる")]
    public void 存在しないタイプはエラーになる()
    {
        var 例外 = Assert.Throws<タイプ未定義例外>(() => タイプ生成(4));
        Assert.Equal("該当するタイプは存在しません: 4", 例外.Message);
    }

    [Fact(DisplayName = "列挙型 タイプ番号.FizzBuzz限定 からも生成できる")]
    public void 列挙型からも生成できる()
    {
        Assert.Equal("FizzBuzz限定", タイプ生成(タイプ番号.FizzBuzz限定).名前);
    }
}
