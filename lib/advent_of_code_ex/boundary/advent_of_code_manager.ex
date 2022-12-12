defmodule AdventOfCodeEx.Boundary.AdventOfCodeManager do
  alias AdventOfCodeEx.Core.Days

  @spec run(1..25, 1 | 2, true | false) :: :ok
  def run(day, part, use_example \\ false) do
    run_code({day, part}, use_example)
    |> handle_result({day, part})
  end

  def run_code({day, _} = day_part, use_example) do
    import_file(day, use_example)
    |> run_day_part(day_part)
  end

  def run_day_part(txt_input, day_part) do
    case day_part do
      { 1, 1 } -> Days.Day1.part_1(txt_input)
      { 1, 2 } -> Days.Day1.part_2(txt_input)
      { 2, 1 } -> Days.Day2.part_1(txt_input)
      { 2, 2 } -> Days.Day2.part_2(txt_input)
      { 3, 1 } -> Days.Day3.part_1(txt_input)
      { 3, 2 } -> Days.Day3.part_2(txt_input)
      { 4, 1 } -> Days.Day4.part_1(txt_input)
      { 4, 2 } -> Days.Day4.part_2(txt_input)
      { 5, 1 } -> Days.Day5.part_1(txt_input)
      { 5, 2 } -> Days.Day5.part_2(txt_input)
      { 6, 1 } -> Days.Day6.part_1(txt_input)
      { 6, 2 } -> Days.Day6.part_2(txt_input)
      { 7, 1 } -> Days.Day7.part_1(txt_input)
      { 7, 2 } -> Days.Day7.part_2(txt_input)
      { 8, 1 } -> Days.Day8.part_1(txt_input)
      { 8, 2 } -> Days.Day8.part_2(txt_input)
      { 9, 1 } -> Days.Day9.part_1(txt_input)
      { 9, 2 } ->  Days.Day9.part_2(txt_input)
      { 10, 1 } -> Days.Day10.part_1(txt_input)
      { 10, 2 } -> Days.Day10.part_2(txt_input)
      { 11, 1 } -> Days.Day11.part_1(txt_input)
      { 11, 2 } -> Days.Day11.part_2(txt_input)
      { 12, 1 } -> Days.Day12.part_1(txt_input)
      { 12, 2 } -> Days.Day12.part_2(txt_input)
      { 13, 1 } -> Days.Day13.part_1(txt_input)
      { 13, 2 } -> Days.Day13.part_2(txt_input)
      { 14, 1 } -> Days.Day14.part_1(txt_input)
      { 14, 2 } -> Days.Day14.part_2(txt_input)
      { 15, 1 } -> Days.Day15.part_1(txt_input)
      { 15, 2 } -> Days.Day15.part_2(txt_input)
      { 16, 1 } -> Days.Day16.part_1(txt_input)
      { 16, 2 } -> Days.Day16.part_2(txt_input)
      { 17, 1 } -> Days.Day17.part_1(txt_input)
      { 17, 2 } -> Days.Day17.part_2(txt_input)
      { 18, 1 } -> Days.Day18.part_1(txt_input)
      { 18, 2 } -> Days.Day18.part_2(txt_input)
      { 19, 1 } -> Days.Day19.part_1(txt_input)
      { 19, 2 } -> Days.Day19.part_2(txt_input)
      { 20, 1 } -> Days.Day20.part_1(txt_input)
      { 20, 2 } -> Days.Day20.part_2(txt_input)
      { 21, 1 } -> Days.Day21.part_1(txt_input)
      { 21, 2 } -> Days.Day21.part_2(txt_input)
      { 22, 1 } -> Days.Day22.part_1(txt_input)
      { 22, 2 } -> Days.Day22.part_2(txt_input)
      { 23, 1 } -> Days.Day23.part_1(txt_input)
      { 23, 2 } -> Days.Day23.part_2(txt_input)
      { 24, 1 } -> Days.Day24.part_1(txt_input)
      { 24, 2 } -> Days.Day24.part_2(txt_input)
      { 25, 1 } -> Days.Day25.part_1(txt_input)
      { 25, 2 } -> Days.Day25.part_2(txt_input)
      _ -> raise " Day/part combo not implemented"
    end
  end

  def handle_result(:unimplemented, {day, part}) do
    IO.puts("D#{day}p#{part} is unimplemented")
  end

  def handle_result(answer, {day, part}) do
    IO.puts("D#{day}p#{part} answer: #{inspect(answer)}")
  end

  defp import_file(day, use_example) do
    file_name = if use_example do
      "./lib/advent_of_code_ex/inputs/example_inputs/day#{day}example.txt"
    else
      "./lib/advent_of_code_ex/inputs/puzzle_inputs/day#{day}.txt"
    end

    case File.read(file_name) do
      {:ok, body} -> body
      {:error, reason} -> raise :file.format_error(reason)
    end
  end
end
