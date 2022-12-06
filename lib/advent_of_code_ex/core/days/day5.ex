defmodule AdventOfCodeEx.Core.Days.Day5 do
  def part_1(input) do
    {starting_state, actions} = split_input(input)

    coded_state = convert_starting_state(starting_state)
    coded_actions = convert_actions(actions)

    find_heads_of_stacks(coded_state, coded_actions, &process_move/4)
  end

  def part_2(input) do
    {starting_state, actions} = split_input(input)

    coded_state = convert_starting_state(starting_state)
    coded_actions = convert_actions(actions)

    find_heads_of_stacks(coded_state, coded_actions, &process_move_part2/4)
  end

  def split_input(input) do
    [starting_state, actions | _] = String.split(input, "\r\n\r\n")
    {starting_state, actions}
  end

  def convert_starting_state(starting_state) do
    lines = String.split(starting_state, "\r\n")
    [bottom | rest] = Enum.reverse(lines)

    starting_acc =
      Enum.reduce(String.split(bottom), %{}, fn x, acc ->
        Map.put(acc, String.to_integer(x), [])
      end)

    add_line_to_state(starting_acc, rest)
  end

  def add_line_to_state(acc, []), do: acc

  def add_line_to_state(acc, [line | rest]) do
    new_acc =
      line
      |> String.graphemes()
      |> Enum.chunk_every(3, 4)
      |> Enum.map(fn x -> Enum.at(x, 1) end)
      |> Enum.with_index(1)
      |> Enum.filter(fn {x, _} -> x != " " end)
      |> Enum.reduce(acc, fn {x, i}, a -> Map.update!(a, i, fn stack -> [x | stack] end) end)

    add_line_to_state(new_acc, rest)
  end

  def convert_actions(actions) do
    actions
    |> String.split("\r\n")
    |> Enum.map(fn action -> Regex.named_captures(~r/move (?<amount>[0-9]+) from (?<from>[0-9]+) to (?<to>[0-9]+)/, action) end)
    |> Enum.map(fn %{"amount" => amount, "from" => from, "to" => to} -> {String.to_integer(amount), String.to_integer(from), String.to_integer(to)} end)
  end

  def find_heads_of_stacks(starting_state, actions, process_move_fn) do
    starting_state
    |> process_moves(actions, process_move_fn)
    |> Enum.map(fn {i, [head|_]} -> {i, head} end)
    |> Enum.sort(fn {i, _}, {i2, _} -> i < i2 end)
    |> Enum.map(fn {_, letter} -> letter end)
    |> Enum.join()
  end

  def process_moves(state, [], _), do: state
  def process_moves(state, [{amount, from, to} | rest], process_move_fn) do
    new_state = process_move_fn.(state, amount, from, to)
    process_moves(new_state, rest, process_move_fn)
  end

  def process_move(state, amount, from, to) do
    {moving, new_from} = Enum.split(state[from], amount)
    state
    |> Map.update!(from, fn _ -> new_from end)
    |> Map.update!(to, fn stack -> Enum.reverse(moving) ++ stack end)
  end

  def process_move_part2(state, amount, from, to) do
    {moving, new_from} = Enum.split(state[from], amount)
    state
    |> Map.update!(from, fn _ -> new_from end)
    |> Map.update!(to, fn stack -> moving ++ stack end)
  end
end
