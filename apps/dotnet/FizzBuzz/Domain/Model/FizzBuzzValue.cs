namespace FizzBuzz.Domain.Model;

public sealed class FizzBuzzValue : IEquatable<FizzBuzzValue>
{
    public int Number { get; }
    public string Value { get; }

    public FizzBuzzValue(int number, string value)
    {
        Number = number;
        Value = value;
    }

    public override string ToString() => $"{Number}:{Value}";

    public bool Equals(FizzBuzzValue? other)
    {
        if (other is null) return false;
        if (ReferenceEquals(this, other)) return true;
        return Number == other.Number && Value == other.Value;
    }

    public override bool Equals(object? obj) => Equals(obj as FizzBuzzValue);

    public override int GetHashCode() => HashCode.Combine(Number, Value);
}
