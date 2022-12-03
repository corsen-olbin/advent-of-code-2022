defmodule AdventOfCodeEx.Core.Days.Day3 do

  def part_1(input) do
    input
    |> String.split()
    |> Enum.map(&calc_priority/1)
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> String.split()
    |> Enum.chunk_every(3)
    |> Enum.map(&calc_priority_part_2/1)
    |> Enum.sum()
  end

  def calc_priority(item_string) do
    item_string
    |> String.split_at(div(String.length(item_string), 2))
    |> find_priority_letter
    |> convert_to_int_value
  end

  def find_priority_letter({first, second}) do
    first
    |> String.to_charlist()
    |> Enum.find(fn x -> Enum.any?(String.to_charlist(second), &(&1 == x)) end)
  end

  def convert_to_int_value(char) do
    case Enum.find_index(?a..?z, fn x -> x == char end) do
      nil -> Enum.find_index(?A..?Z, fn x -> x == char end) + 27
      x -> x + 1
    end
  end

  # part 2
  def calc_priority_part_2(group) do
    group
    |> find_priority_letter_part2
    |> convert_to_int_value
  end

  def find_priority_letter_part2([first, second, third|_]) do
    first
    |> String.to_charlist()
    |> Enum.find(fn x ->
      Enum.any?(String.to_charlist(second), &(&1 == x)) and
        Enum.any?(String.to_charlist(third), &(&1 == x))
    end)
  end
end
