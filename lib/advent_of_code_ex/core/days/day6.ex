defmodule AdventOfCodeEx.Core.Days.Day6 do

  def part_1(input) do
    input
    |> String.graphemes
    |> find_start_of_packet_index
  end

  def part_2(input) do
    input
    |> String.graphemes
    |> find_start_of_message_index
  end

  # Part 1
  def find_start_of_packet_index([a, b, c | tail]) do
    find_start_of_packet_index_rec(a, b, c, tail, 4)
  end

  def find_start_of_packet_index_rec(_a, _b, _c, [], _index), do: raise "hit end of list, no start of packet"
  def find_start_of_packet_index_rec(a, a, c, [d | tail], index), do: find_start_of_packet_index_rec(a, c, d, tail, index + 1)
  def find_start_of_packet_index_rec(a, b, a, [d | tail], index), do: find_start_of_packet_index_rec(b, a, d, tail, index + 1)
  def find_start_of_packet_index_rec(a, b, c, [a | tail], index), do: find_start_of_packet_index_rec(b, c, a, tail, index + 1)
  def find_start_of_packet_index_rec(_a, b, b, [d | tail], index), do: find_start_of_packet_index_rec(b, b, d, tail, index + 1)
  def find_start_of_packet_index_rec(_a, b, c, [b | tail], index), do: find_start_of_packet_index_rec(b, c, b, tail, index + 1)
  def find_start_of_packet_index_rec(_a, b, c, [c | tail], index), do: find_start_of_packet_index_rec(b, c, c, tail, index + 1)
  def find_start_of_packet_index_rec(_a, _b, _c, [_d | _tail], index), do: index

  # Part 2
  def find_start_of_message_index(list) do
    {hopefully_unique, tail} = Enum.split(list, 14)
    find_start_of_message_index_rec(hopefully_unique, tail, 14)
  end

  def find_start_of_message_index_rec(_, [], _index), do: raise "hit end of list, no start of message"
  def find_start_of_message_index_rec([_discard | move_on] = to_check, [head | tail], index) do
    case (to_check |> Enum.uniq |> Enum.count) < 14 do
      true -> find_start_of_message_index_rec(move_on ++ [head], tail, index + 1)
      _ -> index
    end
  end
end
