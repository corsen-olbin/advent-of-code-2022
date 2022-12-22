defmodule AdventOfCodeEx.Core.Days.Day12 do
  alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    input_map =
      input
      |> convert_input_to_map

    values = dijkstra(input_map, 0)

    {x, y} = Map2D.find_index(input_map, &(&1 == 27))
    values[x][y]
  end

  def part_2(input) do
    input_map = convert_input_to_map(input)

    values = dijkstra(input_map, 27)

    a_list = Map2D.find_all_indices(input_map, &(&1 <= 1))
    a_values = for {x, y} <- a_list, do: Map2D.get(values, x, y)
    Enum.min(a_values)
  end

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
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {v, i}, a -> Map2D.put(a, x, i, convert_to_num(v)) end)
    |> add_to_map_rec(lines, x + 1)
  end

  def convert_to_num(char) do
    case char do
      ?S -> 0
      ?E -> 27
      character -> Enum.find_index(?a..?z, fn elem -> elem == character end) + 1
    end
  end

  def dijkstra(map, starting_value) do
    xm = Enum.count(map) - 1
    ym = Enum.count(map[0]) - 1

    {starting_x, starting_y} = Map2D.find_index(map, &(&1 == starting_value))

    distances =
      for i <- 0..xm,
          j <- 0..ym,
          reduce: %{} do
        acc -> Map2D.put(acc, i, j, 1_000_000)
      end
      |> Map2D.put(starting_x, starting_y, 0)

    starting_queue = IO.inspect([{starting_x, starting_y}])

    dijkstra_rec(map, distances, starting_queue, {xm, ym})
  end

  def dijkstra_rec(_, distances, [], _), do: distances

  def dijkstra_rec(map, distances, queue, maxes) do
    point =
      Enum.min(queue, fn {x1, y1}, {x2, y2} ->
        Map2D.get(distances, x1, y1) <= Map2D.get(distances, x2, y2)
      end)

    neighbors = find_neighbors(point, maxes, distances, map)

    new_distances =
      neighbors
      |> Enum.reduce(distances, fn neighbor, acc -> update_distance(map, acc, point, neighbor) end)

    new_queue = List.delete(queue, point)
    dijkstra_rec(map, new_distances, new_queue ++ neighbors, maxes)
  end

  def update_distance(_map, distances, {x, y}, {nx, ny}) do
    tempDistance = distances[x][y] + 1

    if tempDistance < distances[nx][ny] do
      Map2D.put(distances, nx, ny, tempDistance)
    else
      distances
    end
  end

  def find_neighbors({x, y}, maxes, distances, map) do
    []
    |> add_neighbor({x + 1, y}, maxes, distances, map, {x, y})
    |> add_neighbor({x - 1, y}, maxes, distances, map, {x, y})
    |> add_neighbor({x, y + 1}, maxes, distances, map, {x, y})
    |> add_neighbor({x, y - 1}, maxes, distances, map, {x, y})
  end

  def add_neighbor(list, {x, y}, {x_max, y_max}, distances, map, {check_x, check_y}) do
    # flip to map[x][y] - map[check_x][check_y] <= 1 for part 1
    if x > -1 and x <= x_max and y > -1 and y <= y_max and distances[x][y] == 1_000_000 and
         map[check_x][check_y] - map[x][y] <= 1 do
      [{x, y} | list]
    else
      list
    end
  end
end
