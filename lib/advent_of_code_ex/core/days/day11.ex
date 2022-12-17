defmodule AdventOfCodeEx.Core.Days.Day11 do

  def part_1(input) do
    input
    |> convert_input
  end

  def part_2(_input) do
    :unimplemented
  end

  def convert_input(input) do
    input
    |> String.split("\r\n")
  end
end
