defmodule AdventOfCodeEx.Core.Days.Day11 do

  def part_1(input) do
    input
    |> convert_input
    |> IO.inspect
  end

  def part_2(_input) do
    :unimplemented
  end

  def convert_input(input) do
    input
    |> String.split("\r\n\r\n")
    |> Enum.map(fn i -> String.split(i, "\r\n") |> then(&regex/1) end)
  end

  def regex([monkey_num, starting_items, operation, test, if_true, if_false]) do
    num = String.trim_leading(monkey_num, "Monkey ") |> String.trim_trailing(":") |> String.to_integer
    starting_nums = String.trim_leading(starting_items, "  Starting items: ") |> String.split(", ") |> Enum.map(&String.to_integer/1)
    parsed_op = Regex.named_captures(~r/  Operation: new = (?<ro>[a-z0-9]+) (?<operator>[*+]) (?<lo>[a-z0-9]+)/, operation)
    parsed_test = String.trim_leading(test, "  Test: divisible by ") |> String.to_integer
    true_monkey = String.trim_leading(if_true, "    If true: throw to monkey ") |> String.to_integer
    false_monkey = String.trim_leading(if_false, "    If false: throw to monkey ") |> String.to_integer

    %{num: num, items: starting_nums, operation: parsed_op, test: parsed_test, true_monkey: true_monkey, false_monkey: false_monkey}
  end
end
