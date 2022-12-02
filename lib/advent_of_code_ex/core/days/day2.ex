defmodule AdventOfCodeEx.Core.Days.Day2 do
  import AdventOfCodeEx.Core.Helpers.Messages

  def part_1(input) do
    input
    |> find_score_from_rps
    |> answer(2, 1)
  end

  def part_2(input) do
    input
    |> find_score_from_part_2_rules
    |> answer(2, 2)
  end

  # part 1
  def find_score_from_rps(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&calc_round_score/1)
    |> Enum.sum
  end

  def calc_round_score(str) do
    str
    |> String.split
    |> convert_to_nums
    |> calc_score
  end

  def convert_to_nums([opp, mine]) do
    { convert_letter(opp), convert_letter(mine) }
  end

  def convert_letter(letter) do
    case letter do
      # rock
      "A" -> 1
      "X" -> 1
      # paper
      "B" -> 2
      "Y" -> 2
      # scissors
      "C" -> 3
      "Z" -> 3
    end
  end

  def calc_score({opp, mine}) do
    result = cond do
      opp == 1 and mine == 3 -> 0
      opp == 3 and mine == 1 -> 6
      opp > mine -> 0
      opp == mine -> 3
      opp < mine -> 6
    end
    mine + result
  end

  # part 2
  def find_score_from_part_2_rules(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&calc_round_score_part_2/1)
    |> Enum.sum
  end

  def calc_round_score_part_2(str) do
    str
    |> String.split
    |> convert_to_nums
    |> calc_score_part_2
  end

  def calc_score_part_2({opp, mine}) do
    case mine do
      1 -> lose_choice(opp) + 0
      2 -> opp + 3
      3 -> win_choice(opp) + 6
    end
  end

  def lose_choice(opp) do
    case opp do
      1 -> 3
      2 -> 1
      3 -> 2
    end
  end

  def win_choice(opp) do
    case opp do
      1 -> 2
      2 -> 3
      3 -> 1
    end
  end
end
