defmodule AdventOfCodeEx.Core.Days.Day4 do
  def part_1(input) do
    input
    |> String.split("\r\n")
    |> Enum.count(fn x -> do_pairs_overlap?(x, &is_either_pair_fit_in_other?/1) end)
  end

  def part_2(input) do
    input
    |> String.split("\r\n")
    |> Enum.count(fn x -> do_pairs_overlap?(x, &do_pairs_overlap_at_all?/1) end)
  end

  # part 1
  def do_pairs_overlap?(string, over_lap_check?) do
    Regex.named_captures(~r/(?<r1>[0-9]+)-(?<r2>[0-9]+),(?<s1>[0-9]+)-(?<s2>[0-9]+)/, string)
    |> over_lap_check?.()
  end

  def is_either_pair_fit_in_other?(%{"r1" => r1, "r2" => r2, "s1" => s1, "s2" => s2}) do
    r1_int = String.to_integer(r1)
    r2_int = String.to_integer(r2)
    s1_int = String.to_integer(s1)
    s2_int = String.to_integer(s2)

    range1 = r1_int..r2_int
    range2 = s1_int..s2_int

    (r1_int in range2 and r2_int in range2) or
      (s1_int in range1 and s2_int in range1)
  end

  def do_pairs_overlap_at_all?(%{"r1" => r1, "r2" => r2, "s1" => s1, "s2" => s2}) do
    r1_int = String.to_integer(r1)
    r2_int = String.to_integer(r2)
    s1_int = String.to_integer(s1)
    s2_int = String.to_integer(s2)

    range1 = r1_int..r2_int
    range2 = s1_int..s2_int

    r1_int in range2 or
      r2_int in range2 or
      s1_int in range1 or
      s2_int in range1
  end
end
