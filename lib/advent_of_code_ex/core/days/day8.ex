defmodule AdventOfCodeEx.Core.Days.Day8 do
  alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    input
    |> convert_input_to_map
    |> mark_trees_visible
    |> Map2D.count(fn {visible?, _} -> visible? end)
  end

  def part_2(input) do
    input
    |> convert_input_to_map
    |> find_highest_scenic_score
  end

  # Part 1
  def convert_input_to_map(input) do
    input
    # lines
    |> String.split()
    |> add_to_map
  end

  def add_to_map(lines) do
    add_to_map_rec(%{}, lines, 0)
  end

  def add_to_map_rec(acc, [], _x), do: acc

  def add_to_map_rec(acc, [line | lines], x) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {v, i}, a -> Map2D.put(a, x, i, {false, String.to_integer(v)}) end)
    |> add_to_map_rec(lines, x + 1)
  end

  def mark_trees_visible(tree_map) do
    max_x_index = Enum.count(tree_map) - 1
    max_y_index = Enum.count(tree_map[0]) - 1

    mark_trees_visible_rec(tree_map, 0, 0, max_x_index, max_y_index)
  end

  def mark_trees_visible_rec(tree_map, x, _y, max_x, _max_y) when x > max_x, do: tree_map

  def mark_trees_visible_rec(tree_map, x, y, max_x, max_y) when y > max_y,
    do: mark_trees_visible_rec(tree_map, x + 1, 0, max_x, max_y)

  def mark_trees_visible_rec(tree_map, x, y, max_x, max_y) do
    case is_visible?(tree_map, x, y, max_x, max_y) do
      true ->
        mark_trees_visible_rec(
          Map2D.update(tree_map, x, y, nil, fn {_, v} -> {true, v} end),
          x,
          y + 1,
          max_x,
          max_y
        )

      false ->
        mark_trees_visible_rec(tree_map, x, y + 1, max_x, max_y)
    end
  end

  def is_visible?(tree_map, x, y, max_x, max_y) do
    value = elem(tree_map[x][y], 1)

    cond do
      all_lesser_in_direction?(tree_map, {x, y}, {max_x, max_y}, value, fn {i, j} ->
        {i - 1, j}
      end) ->
        true

      all_lesser_in_direction?(tree_map, {x, y}, {max_x, max_y}, value, fn {i, j} ->
        {i + 1, j}
      end) ->
        true

      all_lesser_in_direction?(tree_map, {x, y}, {max_x, max_y}, value, fn {i, j} ->
        {i, j - 1}
      end) ->
        true

      all_lesser_in_direction?(tree_map, {x, y}, {max_x, max_y}, value, fn {i, j} ->
        {i, j + 1}
      end) ->
        true

      true ->
        false
    end
  end

  def all_lesser_in_direction?(
        tree_map,
        coord,
        {max_x, max_y} = max_coords,
        initial_value,
        change_func
      ) do
    {new_x, new_y} = change_func.(coord)

    cond do
      new_x < 0 or new_x > max_x ->
        true

      new_y < 0 or new_y > max_y ->
        true

      elem(tree_map[new_x][new_y], 1) >= initial_value ->
        false

      true ->
        all_lesser_in_direction?(tree_map, {new_x, new_y}, max_coords, initial_value, change_func)
    end
  end

  # Part 2
  def find_highest_scenic_score(tree_map) do
    max_x_index = Enum.count(tree_map) - 1
    max_y_index = Enum.count(tree_map[0]) - 1

    find_highest_scenic_score_rec(tree_map, 0, 0, max_x_index, max_y_index, 0)
  end

  def find_highest_scenic_score_rec(_tree_map, x, _y, max_x, _max_y, current_max) when x > max_x,
    do: current_max

  def find_highest_scenic_score_rec(tree_map, x, y, max_x, max_y, current_max) when y > max_y,
    do: find_highest_scenic_score_rec(tree_map, x + 1, 0, max_x, max_y, current_max)

  def find_highest_scenic_score_rec(tree_map, x, y, max_x, max_y, current_max) do
    scenic_score = calc_scenic_score(tree_map, x, y, max_x, max_y)

    find_highest_scenic_score_rec(
      tree_map,
      x,
      y + 1,
      max_x,
      max_y,
      max(scenic_score, current_max)
    )
  end

  def calc_scenic_score(tree_map, x, y, max_x, max_y) do
    value = elem(tree_map[x][y], 1)

    up =
      num_trees_visible_in_direction(
        tree_map,
        {x, y},
        {max_x, max_y},
        value,
        fn {i, j} -> {i - 1, j} end,
        0
      )

    down =
      num_trees_visible_in_direction(
        tree_map,
        {x, y},
        {max_x, max_y},
        value,
        fn {i, j} -> {i + 1, j} end,
        0
      )

    left =
      num_trees_visible_in_direction(
        tree_map,
        {x, y},
        {max_x, max_y},
        value,
        fn {i, j} -> {i, j - 1} end,
        0
      )

    right =
      num_trees_visible_in_direction(
        tree_map,
        {x, y},
        {max_x, max_y},
        value,
        fn {i, j} -> {i, j + 1} end,
        0
      )

    up * down * left * right
  end

  def num_trees_visible_in_direction(
        tree_map,
        coord,
        {max_x, max_y} = max_coords,
        initial_value,
        change_func,
        num_of_trees
      ) do
    {new_x, new_y} = change_func.(coord)

    cond do
      new_x < 0 or new_x > max_x ->
        num_of_trees

      new_y < 0 or new_y > max_y ->
        num_of_trees

      elem(tree_map[new_x][new_y], 1) >= initial_value ->
        num_of_trees + 1

      true ->
        num_trees_visible_in_direction(
          tree_map,
          {new_x, new_y},
          max_coords,
          initial_value,
          change_func,
          num_of_trees + 1
        )
    end
  end
end
