defmodule AdventOfCodeEx.Core.Days.Day1 do
  alias AdventOfCodeEx.Core.Helpers.Messages

  def part_1(input) do
    input
    |> find_greatest_sum_of_calories()
    |> Messages.answer(1, 1)
  end

  def part_2(input) do
    input
    |> find_sum_of_3_greatest_sums_of_calories()
    |> Messages.answer(1, 2)
  end

  def find_greatest_sum_of_calories(input) do
    input
    |> String.split("\r\n\r\n")
    |> Enum.map(&(sum_calories_of_all_meals(&1)))
    |> Enum.max()
  end

  def sum_calories_of_all_meals(elf_meals) do
    elf_meals
    |> String.split
    |> Enum.map(&(String.to_integer(&1)))
    |> Enum.sum
  end

  def find_sum_of_3_greatest_sums_of_calories(input) do
    input
    |> String.split("\r\n\r\n")
    |> Enum.map(&(sum_calories_of_all_meals(&1)))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum
  end
end
