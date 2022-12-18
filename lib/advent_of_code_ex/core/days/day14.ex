defmodule AdventOfCodeEx.Core.Days.Day14 do
  alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn str -> String.split(str, " -> ") end)
    |> convert_inputs(%{}, 0)
    |> drop_sand_grains(0)
  end

  def part_2(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn str -> String.split(str, " -> ") end)
    |> convert_inputs(%{}, 0)
    |> drop_sand_grains_part2(0)
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

  def drop_sand_grains({wall_map, max_y}, sand_count) do
    case drop_sand_grain(wall_map, {500, 0}, max_y) do
      :done -> sand_count
      new_map when is_map(new_map) -> drop_sand_grains({new_map, max_y}, sand_count + 1)
    end
  end

  def drop_sand_grain(wall_map, {i, j} = _sand_coords, max_y) do
    cond do
      j + 1 > max_y -> :done
      Map2D.get(wall_map, i, j + 1) == nil -> drop_sand_grain(wall_map, {i, j + 1}, max_y)
      Map2D.get(wall_map, i - 1, j + 1) == nil -> drop_sand_grain(wall_map, {i - 1, j + 1}, max_y)
      Map2D.get(wall_map, i + 1, j + 1) == nil -> drop_sand_grain(wall_map, {i + 1, j + 1}, max_y)
      true -> Map2D.put(wall_map, i, j, "o")
    end
  end

  # part 2
  def drop_sand_grains_part2({wall_map, max_y}, sand_count) do
    case drop_sand_grain_part2(wall_map, {500, 0}, max_y) do
      :done -> sand_count
      new_map when is_map(new_map) -> drop_sand_grains_part2({new_map, max_y}, sand_count + 1)
    end
  end

  def drop_sand_grain_part2(wall_map, {i, j} = _sand_coords, max_y) do
    cond do
      j + 1 == max_y + 2 -> Map2D.put(wall_map, i, j, "o")
      Map2D.get(wall_map, i, j + 1) == nil -> drop_sand_grain_part2(wall_map, {i, j + 1}, max_y)
      Map2D.get(wall_map, i - 1, j + 1) == nil -> drop_sand_grain_part2(wall_map, {i - 1, j + 1}, max_y)
      Map2D.get(wall_map, i + 1, j + 1) == nil -> drop_sand_grain_part2(wall_map, {i + 1, j + 1}, max_y)
      Map2D.get(wall_map, 500, 0) == "o" -> :done
      true -> Map2D.put(wall_map, i, j, "o")
    end
  end
end
