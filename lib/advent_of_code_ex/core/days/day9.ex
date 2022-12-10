defmodule AdventOfCodeEx.Core.Days.Day9 do
  def part_1(input) do
    input
    |> convert_input
    |> handle_commands
    |> Enum.uniq()
    |> Enum.count()
  end

  def part_2(input) do
    input
    |> convert_input
    |> handle_commands_2
    |> Enum.uniq()
    |> Enum.count()
  end

  def convert_input(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&line_to_command/1)
  end

  def line_to_command(line) do
    case Regex.named_captures(~r/(?<direction>[A-Z]) (?<length>[0-9]+)/, line) do
      %{"direction" => "R", "length" => length} -> {:right, String.to_integer(length)}
      %{"direction" => "L", "length" => length} -> {:left, String.to_integer(length)}
      %{"direction" => "U", "length" => length} -> {:up, String.to_integer(length)}
      %{"direction" => "D", "length" => length} -> {:down, String.to_integer(length)}
    end
  end

  def handle_commands(commands), do: handle_commands_rec({0, 0}, {0, 0}, [], commands)

  def handle_commands_rec(_, _, tail_history, []), do: tail_history

  def handle_commands_rec(position, tail_position, tail_history, [command | commands]) do
    {new_position, new_tail_position, new_tail_history} =
      handle_command(position, tail_position, command, tail_history)

    handle_commands_rec(new_position, new_tail_position, new_tail_history, commands)
  end

  def handle_command(position, tail_position, {_, 0}, tail_history),
    do: {position, tail_position, tail_history}

  def handle_command({x, y}, tail_pos, {direction, moves_left}, tail_history) do
    {new_position, new_tail_position} =
      case direction do
        :right -> {{x + 1, y}, calc_new_tail_pos({x + 1, y}, tail_pos)}
        :left -> {{x - 1, y}, calc_new_tail_pos({x - 1, y}, tail_pos)}
        :up -> {{x, y + 1}, calc_new_tail_pos({x, y + 1}, tail_pos)}
        :down -> {{x, y - 1}, calc_new_tail_pos({x, y - 1}, tail_pos)}
      end

    handle_command(new_position, new_tail_position, {direction, moves_left - 1}, [
      new_tail_position | tail_history
    ])
  end

  def calc_new_tail_pos({x, y}, {tx, ty} = tail_pos) do
    x_diff = abs(x - tx)
    y_diff = abs(y - ty)

    cond do
      x_diff <= 1 and y_diff <= 1 -> tail_pos
      x == tx -> {tx, div(y + ty, 2)}
      y == ty -> {div(x + tx, 2), ty}
      x_diff == 2 and y_diff == 2 -> {div(x + tx, 2), div(y + ty, 2)}
      x_diff == 2 -> {div(x + tx, 2), y}
      y_diff == 2 -> {x, div(y + ty, 2)}
      true -> raise "{#{x}, #{y}}, tail {#{tx}, #{ty}}"
    end
  end

  # Part 2
  def handle_commands_2(commands),
    do: handle_commands_rec_2({0, 0}, Enum.map(1..9, fn _ -> {0, 0} end), [], commands)

  def handle_commands_rec_2(_, _, tail_history, []), do: tail_history

  def handle_commands_rec_2(position, tail_positions, tail_history, [command | commands]) do
    {new_position, new_tail_positions, new_tail_history} =
      handle_command_part_2(position, tail_positions, command, tail_history)

    handle_commands_rec_2(new_position, new_tail_positions, new_tail_history, commands)
  end

  def handle_command_part_2(position, tail_positions, {_, 0}, tail_history),
    do: {position, tail_positions, tail_history}

  def handle_command_part_2({x, y}, tail_positions, {direction, moves_left}, tail_history) do
    new_head =
      case direction do
        :right -> {x + 1, y}
        :left -> {x - 1, y}
        :up -> {x, y + 1}
        :down -> {x, y - 1}
      end

    try do
      {last_tail_pos, [_head | tails]} =
        Enum.reduce(tail_positions, {new_head, []}, fn tail_pos, {last, new_tails} ->
          {calc_new_tail_pos(last, tail_pos), new_tails ++ [last]}
        end)

      handle_command_part_2(new_head, tails ++ [last_tail_pos], {direction, moves_left - 1}, [
        last_tail_pos | tail_history
      ])
    rescue
      e ->
        IO.inspect(e)

        raise "head #{x} #{y} tails #{inspect(tail_positions)} direction #{direction} moves_left #{moves_left}"
    end
  end
end
