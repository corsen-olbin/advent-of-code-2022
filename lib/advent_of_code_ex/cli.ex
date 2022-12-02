defmodule AdventOfCodeEx.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to
  return the answer for the given Advent of Code Day/Part
  """
  alias AdventOfCodeEx.Boundary.AdventOfCodeManager

  @default_part 1

  @spec main(any) :: no_return
  def main(argv) do
    parse_args(argv)
    |> process()
  end

  @spec process(any) :: no_return
  def process(:help) do
    IO.puts("""
    usage: advent_of_code_ex <day> [ part | #{@default_part} ]
    """)

    System.stop(0)
  end

  def process({day, part, example}) do
    AdventOfCodeManager.run(day, part, example)
    System.stop(0)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a day, and (optionally)
  a part to return the answer for.
  Return a tuple of `{ day, part }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv,
      switches: [help: :boolean, example: :boolean],
      aliases: [h: :help, e: :example]
    )
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([day, part, use_example]) do
    {String.to_integer(day), String.to_integer(part), use_example}
  end

  def args_to_internal_representation([day, part]) do
    {String.to_integer(day), String.to_integer(part), false}
  end

  def args_to_internal_representation([day]) do
    {String.to_integer(day), @default_part, false}
  end

  # bad arg or --help
  def args_to_internal_representation(_) do
    :help
  end
end
