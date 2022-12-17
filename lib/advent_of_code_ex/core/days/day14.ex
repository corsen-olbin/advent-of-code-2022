defmodule AdventOfCodeEx.Core.Days.Day14 do
  alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn str -> String.split(str, " -> ") end)
    |> convert_inputs(%{}, 0)
    |> IO.inspect()

    :unimplemented
  end

  def part_2(_input) do
    :unimplemented
  end

  def convert_inputs([], acc, max_y), do: { acc, max_y }
  def convert_inputs([wall | walls], acc, max_y) do
    { wall_map, max_y } =
      wall
      |> Enum.map(fn point ->
        String.split(point, ",")
        |> then(fn [x, y] -> {String.to_integer(x), String.to_integer(y)} end)
      end)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce({acc, max_y}, fn [coord1, coord2], a -> add_line_to_map(a, coord1, coord2) end)

    convert_inputs(walls, wall_map, max_y)
  end

  def add_line_to_map(map, {x1, y1}, {x2, y2}) do
    for x <- x1..x2, y <- y1..y2, reduce: map do
      {acc, max_y} -> { Map2D.put(acc, x, y, "#"), max(max_y, max(y1, y2)) }
    end
  end
end
