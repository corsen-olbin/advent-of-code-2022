defmodule AdventOfCodeEx.Core.Days.Day10 do
  alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&convert_input/1)
    |> calc_signal_strengths([20, 60, 100, 140, 180, 220])
    |> Enum.sum()
  end

  def part_2(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(&convert_input/1)
    |> draw_picture
    |> format_output
  end

  def convert_input(line) do
    case Regex.named_captures(
           ~r/(?<command>[a-zA-Z0-9\/]+) *(?<add_value>[a-zA-Z0-9-\/.]*)/,
           line
         ) do
      %{"command" => "addx", "add_value" => value} -> {:addx, String.to_integer(value)}
      %{"command" => "noop"} -> {:noop}
      _ -> raise "you forgot a command"
    end
  end

  def calc_signal_strengths(commands, cycles_to_capture) do
    calc_signal_strengths_rec(commands, 1, 1, cycles_to_capture, [])
  end

  def calc_signal_strengths_rec([], _, _, _, signal_strengths), do: signal_strengths
  def calc_signal_strengths_rec(_, _, _, [], signal_strengths), do: signal_strengths

  def calc_signal_strengths_rec(
        [command | commands],
        cycle,
        register,
        [cycle_to_capture | cycles_to_capture] = cycles,
        signal_strengths
      ) do
    {new_cycle, new_register} = calc_new_cycle_and_register(command, cycle, register)

    {new_cycles_to_capture, new_signal_strengths} =
      cond do
        new_cycle < cycle_to_capture ->
          {cycles, signal_strengths}

        new_cycle == cycle_to_capture ->
          {cycles_to_capture, [cycle_to_capture * new_register | signal_strengths]}

        new_cycle > cycle_to_capture ->
          {cycles_to_capture, [cycle_to_capture * register | signal_strengths]}
      end

    calc_signal_strengths_rec(
      commands,
      new_cycle,
      new_register,
      new_cycles_to_capture,
      new_signal_strengths
    )
  end

  def calc_new_cycle_and_register(command, cycle, register) do
    case command do
      {:addx, value} -> {cycle + 2, register + value}
      {:noop} -> {cycle + 1, register}
    end
  end

  # Part 2
  def draw_picture(commands) do
    draw_picture_rec(commands, 1, 1, %{})
  end

  def draw_picture_rec([], _, _, picture), do: picture

  def draw_picture_rec([command | commands], cycle, register, picture) do
    {x, y} = {div(cycle - 1, 40), rem(cycle - 1, 40)}
    {new_cycle, new_register} = calc_new_cycle_and_register(command, cycle, register)

    new_picture =
      cond do
        y >= register - 1 and y <= register + 1 -> Map2D.put(picture, x, y, "#")
        true -> Map2D.put(picture, x, y, ".")
      end

    {x2, y2} = {div(new_cycle - 2, 40), rem(new_cycle - 2, 40)}

    new_picture_2 =
      cond do
        y2 >= register - 1 and y2 <= register + 1 -> Map2D.put(new_picture, x2, y2, "#")
        true -> Map2D.put(new_picture, x2, y2, ".")
      end

    draw_picture_rec(commands, new_cycle, new_register, new_picture_2)
  end

  def format_output(picture) do
    x_range = 0..(Enum.count(picture) - 1)
    y_range = 0..(Enum.count(picture[0]) - 1)

    Enum.map(x_range, fn x ->
      Enum.map(y_range, fn y -> IO.write(Map2D.get(picture, x, y)) end)
      IO.write("\r\n")
    end)
    0
  end
end
