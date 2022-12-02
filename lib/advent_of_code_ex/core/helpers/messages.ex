defmodule AdventOfCodeEx.Core.Helpers.Messages do
  def unimplemented(day, part) do
    {:unimplemented, "D#{day}p#{part} is unimplemented"}
  end

  def answer(answer, day, part) do
    {:answer, "D#{day}p#{part} answer: #{answer}"}
  end
end
