namespace FizzBuzzTest;

using FizzBuzz.Domain.Model;

public class FizzBuzzListTest
{
    [Fact]
    public void 空のリストを作成できる()
    {
        var list = new FizzBuzzList();

        Assert.Equal(0, list.Count);
    }

    [Fact]
    public void 値を追加できる()
    {
        var list = new FizzBuzzList();
        var newList = list.Add(new FizzBuzzValue(1, "1"));

        Assert.Equal(1, newList.Count);
        Assert.Equal(0, list.Count);
    }

    [Fact]
    public void 文字列リストに変換できる()
    {
        var list = new FizzBuzzList(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz"),
            new FizzBuzzValue(5, "Buzz")
        });

        var strings = list.ToStringValues();

        Assert.Equal(new List<string> { "1", "Fizz", "Buzz" }, strings);
    }

    [Fact]
    public void フィルタリングできる()
    {
        var list = new FizzBuzzList(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz"),
            new FizzBuzzValue(5, "Buzz"),
            new FizzBuzzValue(15, "FizzBuzz")
        });

        var filtered = list.Filter(v => v.Value == "Fizz");

        Assert.Equal(1, filtered.Count);
        Assert.Equal("Fizz", filtered.Get(0).Value);
    }

    [Fact]
    public void 最初の一致する値を取得できる()
    {
        var list = new FizzBuzzList(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz"),
            new FizzBuzzValue(6, "Fizz")
        });

        var found = list.FindFirst(v => v.Value == "Fizz");

        Assert.NotNull(found);
        Assert.Equal(3, found!.Number);
    }

    [Fact]
    public void 一致する値がない場合はnullを返す()
    {
        var list = new FizzBuzzList(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(2, "2")
        });

        var found = list.FindFirst(v => v.Value == "Fizz");

        Assert.Null(found);
    }

    [Fact]
    public void 値ごとにカウントできる()
    {
        var list = new FizzBuzzList(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz"),
            new FizzBuzzValue(6, "Fizz"),
            new FizzBuzzValue(5, "Buzz")
        });

        var counts = list.CountByValue();

        Assert.Equal(1, counts["1"]);
        Assert.Equal(2, counts["Fizz"]);
        Assert.Equal(1, counts["Buzz"]);
    }

    [Fact]
    public void AddRangeで複数の値を追加できる()
    {
        var list = new FizzBuzzList();
        var newList = list.AddRange(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(2, "2")
        });

        Assert.Equal(2, newList.Count);
        Assert.Equal(0, list.Count);
    }

    [Fact]
    public void 同じ内容のリストは等しい()
    {
        var list1 = new FizzBuzzList(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz")
        });

        var list2 = new FizzBuzzList(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(3, "Fizz")
        });

        Assert.Equal(list1, list2);
    }
}
