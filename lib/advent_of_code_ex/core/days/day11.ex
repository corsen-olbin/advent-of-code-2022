defmodule AdventOfCodeEx.Core.Days.Day11 do
  def part_1(input) do
    input
    |> convert_input
    |> IO.inspect()
    |> simulate_monkeys(20, true)
    |> Enum.map(fn mon -> mon.inspect_num end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(fn x, acc -> x * acc end)
  end

  def part_2(input) do
    input
    |> convert_input
    |> IO.inspect()
    |> simulate_monkeys(1000, false)
    |> Enum.map(fn mon -> mon.inspect_num end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.reduce(fn x, acc -> x * acc end)
  end

  def convert_input(input) do
    input
    |> String.split("\r\n\r\n")
    |> Enum.map(fn i -> String.split(i, "\r\n") |> then(&regex/1) end)
  end

  def regex([monkey_num, starting_items, operation, test, if_true, if_false]) do
    num =
      String.trim_leading(monkey_num, "Monkey ")
      |> String.trim_trailing(":")
      |> String.to_integer()

    starting_nums =
      String.trim_leading(starting_items, "  Starting items: ")
      |> String.split(", ")
      |> Enum.map(&String.to_integer/1)

    parsed_op =
      Regex.named_captures(
        ~r/  Operation: new = (?<right>[a-z0-9]+) (?<operator>[*+]) (?<left>[a-z0-9]+)/,
        operation
      )

    parsed_test = String.trim_leading(test, "  Test: divisible by ") |> String.to_integer()

    true_monkey =
      String.trim_leading(if_true, "    If true: throw to monkey ") |> String.to_integer()

    false_monkey =
      String.trim_leading(if_false, "    If false: throw to monkey ") |> String.to_integer()

    %{
      num: num,
      items: starting_nums,
      operation: parsed_op,
      test: parsed_test,
      true_monkey: true_monkey,
      false_monkey: false_monkey
    }
  end

  def simulate_monkeys(monkeys, turns, worry?), do: simulate_monkeys_rec(0, monkeys, turns, worry?)

  def simulate_monkeys_rec(_, monkeys, 0, _worry?), do: monkeys

  def simulate_monkeys_rec(index, all_monkeys, turns, worry?) do
    case Enum.at(all_monkeys, index) do
      nil ->
        # IO.inspect(turns, label: "turns")
        simulate_monkeys_rec(0, all_monkeys, turns - 1, worry?)

      current ->
        new_monkeys = simulate_monkey(current, all_monkeys, worry?)
        simulate_monkeys_rec(index + 1, new_monkeys, turns, worry?)
    end
  end

  def simulate_monkey(current, all_monkeys, worry?) do
    inspect_items(current, current.items, all_monkeys, worry?)
  end

  def inspect_items(monkey, [], all_monkeys, _) do
    List.update_at(all_monkeys, monkey.num, fn mon -> Map.put(mon, :items, []) end)
  end

  def inspect_items(monkey, [item | items], all_monkeys, worry?) do
    new_monkeys = inspect_item(monkey, item, all_monkeys, worry?)

    inspect_items(monkey, items, new_monkeys, worry?)
  end

  def inspect_item(monkey, item, all_monkeys, worry?) do
    new_item = operation(monkey.operation, item)
    bored_item = if worry? do
      div(new_item, 3)
    else
      if new_item < 1000, do: new_item, else: div(new_item, 100) + rem(new_item, 100)
    end

    new_monkeys =
      if rem(bored_item, monkey.test) == 0 do
        # IO.inspect("item #{bored_item}: #{monkey.num} -> #{monkey.true_monkey}")

        List.update_at(all_monkeys, monkey.true_monkey, fn mon ->
          Map.update!(mon, :items, fn items -> items ++ [bored_item] end)
        end)
      else
        # IO.inspect("item #{bored_item}: #{monkey.num} -> #{monkey.false_monkey}")

        List.update_at(all_monkeys, monkey.false_monkey, fn mon ->
          Map.update!(mon, :items, fn items -> items ++ [bored_item] end)
        end)
      end

    List.update_at(new_monkeys, monkey.num, fn mon ->
      Map.update(mon, :inspect_num, 1, &(&1 + 1))
    end)
  end

  def operation(operation, item) do
    left = if operation["left"] == "old", do: item, else: String.to_integer(operation["left"])
    right = if operation["right"] == "old", do: item, else: String.to_integer(operation["right"])

    case operation["operator"] do
      "*" -> left * right
      "+" -> left + right
    end
  end
end
