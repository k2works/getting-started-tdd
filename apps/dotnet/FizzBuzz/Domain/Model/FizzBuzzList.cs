namespace FizzBuzz.Domain.Model;

public sealed class FizzBuzzList : IEquatable<FizzBuzzList>
{
    private readonly List<FizzBuzzValue> _values;

    public IReadOnlyList<FizzBuzzValue> Values => _values.AsReadOnly();

    public FizzBuzzList()
    {
        _values = new List<FizzBuzzValue>();
    }

    public FizzBuzzList(List<FizzBuzzValue> values)
    {
        _values = new List<FizzBuzzValue>(values);
    }

    public FizzBuzzValue Get(int index) => _values[index];

    public int Count => _values.Count;

    public FizzBuzzList Add(FizzBuzzValue value)
    {
        var newValues = new List<FizzBuzzValue>(_values) { value };
        return new FizzBuzzList(newValues);
    }

    public FizzBuzzList AddRange(IEnumerable<FizzBuzzValue> values)
    {
        var newValues = new List<FizzBuzzValue>(_values);
        newValues.AddRange(values);
        return new FizzBuzzList(newValues);
    }

    public FizzBuzzList Filter(Func<FizzBuzzValue, bool> predicate)
    {
        return new FizzBuzzList(_values.Where(predicate).ToList());
    }

    public FizzBuzzValue? FindFirst(Func<FizzBuzzValue, bool> predicate)
    {
        return _values.FirstOrDefault(predicate);
    }

    public List<string> ToStringValues()
    {
        return _values.Select(v => v.Value).ToList();
    }

    public Dictionary<string, int> CountByValue()
    {
        return _values
            .GroupBy(v => v.Value)
            .ToDictionary(g => g.Key, g => g.Count());
    }

    public override string ToString()
    {
        return string.Join(", ", _values.Select(v => v.ToString()));
    }

    public bool Equals(FizzBuzzList? other)
    {
        if (other is null) return false;
        if (ReferenceEquals(this, other)) return true;
        return _values.SequenceEqual(other._values);
    }

    public override bool Equals(object? obj) => Equals(obj as FizzBuzzList);

    public override int GetHashCode()
    {
        var hash = new HashCode();
        foreach (var value in _values)
            hash.Add(value);
        return hash.ToHashCode();
    }
}
