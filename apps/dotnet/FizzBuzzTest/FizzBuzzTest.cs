namespace FizzBuzzTest;

using FizzBuzz;
using FizzBuzz.Application;
using FizzBuzz.Domain.Model;
using FizzBuzz.Domain.Type;

public class FizzBuzzRunnerTest
{
    [Fact]
    public void 数を文字列にして返す_1を渡したら文字列1を返す()
    {
        Assert.Equal("1", FizzBuzzRunner.Generate(1));
    }

    [Fact]
    public void 数を文字列にして返す_2を渡したら文字列2を返す()
    {
        Assert.Equal("2", FizzBuzzRunner.Generate(2));
    }

    [Fact]
    public void 三の倍数のときはFizzを返す_3を渡したらFizzを返す()
    {
        Assert.Equal("Fizz", FizzBuzzRunner.Generate(3));
    }

    [Fact]
    public void 五の倍数のときはBuzzを返す_5を渡したらBuzzを返す()
    {
        Assert.Equal("Buzz", FizzBuzzRunner.Generate(5));
    }

    [Fact]
    public void 三と五の倍数のときはFizzBuzzを返す_15を渡したらFizzBuzzを返す()
    {
        Assert.Equal("FizzBuzz", FizzBuzzRunner.Generate(15));
    }

    [Fact]
    public void 一から百までのリストを生成する()
    {
        var list = FizzBuzzRunner.GenerateList(100);
        Assert.Equal(100, list.Count);
        Assert.Equal("1", list[0]);
        Assert.Equal("Fizz", list[2]);
        Assert.Equal("Buzz", list[4]);
        Assert.Equal("FizzBuzz", list[14]);
    }
}

public class FizzBuzzValueTest
{
    [Fact]
    public void 値を保持する()
    {
        var value = new FizzBuzzValue(1, "1");
        Assert.Equal(1, value.Number);
        Assert.Equal("1", value.Value);
    }

    [Fact]
    public void Fizz値を保持する()
    {
        var value = new FizzBuzzValue(3, "Fizz");
        Assert.Equal(3, value.Number);
        Assert.Equal("Fizz", value.Value);
    }

    [Fact]
    public void 同じ値のオブジェクトは等しい()
    {
        var value1 = new FizzBuzzValue(1, "1");
        var value2 = new FizzBuzzValue(1, "1");
        Assert.Equal(value1, value2);
    }

    [Fact]
    public void 異なる値のオブジェクトは等しくない()
    {
        var value1 = new FizzBuzzValue(1, "1");
        var value2 = new FizzBuzzValue(2, "2");
        Assert.NotEqual(value1, value2);
    }

    [Fact]
    public void ToStringはNumber_Colon_Value形式()
    {
        var value = new FizzBuzzValue(3, "Fizz");
        Assert.Equal("3:Fizz", value.ToString());
    }

    [Fact]
    public void GetHashCodeは同じ値で同じ()
    {
        var value1 = new FizzBuzzValue(1, "1");
        var value2 = new FizzBuzzValue(1, "1");
        Assert.Equal(value1.GetHashCode(), value2.GetHashCode());
    }
}

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
        Assert.Equal(0, list.Count); // 元のリストは変更されない
    }

    [Fact]
    public void インデックスで値を取得できる()
    {
        var list = new FizzBuzzList(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(2, "2"),
            new FizzBuzzValue(3, "Fizz")
        });
        Assert.Equal(new FizzBuzzValue(1, "1"), list.Get(0));
        Assert.Equal(new FizzBuzzValue(3, "Fizz"), list.Get(2));
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
        Assert.Equal(3, found.Number);
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
    public void 値ごとにカウントできる()
    {
        var list = new FizzBuzzList(new List<FizzBuzzValue>
        {
            new FizzBuzzValue(1, "1"),
            new FizzBuzzValue(2, "2"),
            new FizzBuzzValue(3, "Fizz"),
            new FizzBuzzValue(6, "Fizz"),
            new FizzBuzzValue(5, "Buzz")
        });
        var counts = list.CountByValue();
        Assert.Equal(1, counts["1"]);
        Assert.Equal(1, counts["2"]);
        Assert.Equal(2, counts["Fizz"]);
        Assert.Equal(1, counts["Buzz"]);
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
    }
}

public class FizzBuzzType01Test
{
    private readonly IFizzBuzzType _type = new FizzBuzzType01();

    [Fact]
    public void 数を文字列にして返す()
    {
        Assert.Equal("1", _type.Generate(1).Value);
    }

    [Fact]
    public void 三の倍数のときはFizzを返す()
    {
        Assert.Equal("Fizz", _type.Generate(3).Value);
    }

    [Fact]
    public void 五の倍数のときはBuzzを返す()
    {
        Assert.Equal("Buzz", _type.Generate(5).Value);
    }

    [Fact]
    public void 三と五の倍数のときはFizzBuzzを返す()
    {
        Assert.Equal("FizzBuzz", _type.Generate(15).Value);
    }
}

public class FizzBuzzType02Test
{
    private readonly IFizzBuzzType _type = new FizzBuzzType02();

    [Fact]
    public void 常に数値を文字列にして返す()
    {
        Assert.Equal("1", _type.Generate(1).Value);
        Assert.Equal("3", _type.Generate(3).Value);
        Assert.Equal("5", _type.Generate(5).Value);
        Assert.Equal("15", _type.Generate(15).Value);
    }
}

public class FizzBuzzType03Test
{
    private readonly IFizzBuzzType _type = new FizzBuzzType03();

    [Fact]
    public void 十五の倍数のときはFizzBuzzを返す()
    {
        Assert.Equal("FizzBuzz", _type.Generate(15).Value);
        Assert.Equal("FizzBuzz", _type.Generate(30).Value);
    }

    [Fact]
    public void 十五の倍数以外は数値を文字列にして返す()
    {
        Assert.Equal("1", _type.Generate(1).Value);
        Assert.Equal("3", _type.Generate(3).Value);
        Assert.Equal("5", _type.Generate(5).Value);
    }
}

public class FizzBuzzTypeFactoryTest
{
    [Fact]
    public void タイプ1を生成できる()
    {
        var type = FizzBuzzTypeFactory.Create(1);
        Assert.IsType<FizzBuzzType01>(type);
    }

    [Fact]
    public void タイプ2を生成できる()
    {
        var type = FizzBuzzTypeFactory.Create(2);
        Assert.IsType<FizzBuzzType02>(type);
    }

    [Fact]
    public void タイプ3を生成できる()
    {
        var type = FizzBuzzTypeFactory.Create(3);
        Assert.IsType<FizzBuzzType03>(type);
    }

    [Fact]
    public void 不正なタイプは例外を投げる()
    {
        Assert.Throws<ArgumentException>(() => FizzBuzzTypeFactory.Create(0));
    }

    [Fact]
    public void Enumで生成できる()
    {
        var type = FizzBuzzTypeFactory.Create(FizzBuzzTypeName.Standard);
        Assert.IsType<FizzBuzzType01>(type);
    }

    [Fact]
    public void Enumで数値のみタイプを生成できる()
    {
        var type = FizzBuzzTypeFactory.Create(FizzBuzzTypeName.NumberOnly);
        Assert.IsType<FizzBuzzType02>(type);
    }
}

public class FizzBuzzCommandTest
{
    [Fact]
    public void ValueCommandで単一値を取得できる()
    {
        var command = new FizzBuzzValueCommand(FizzBuzzTypeFactory.Create(FizzBuzzTypeName.Standard));
        var result = command.ExecuteValue(3);
        Assert.Equal("Fizz", result.Value);
    }

    [Fact]
    public void ListCommandでリストを生成できる()
    {
        var command = new FizzBuzzListCommand(FizzBuzzTypeFactory.Create(FizzBuzzTypeName.Standard));
        var result = command.ExecuteList(100);
        Assert.Equal(100, result.Count);
    }
}
