defmodule AdventOfCodeExTest do
  use ExUnit.Case
  doctest AdventOfCodeEx

  test "greets the world" do
    assert AdventOfCodeEx.hello() == :world
  end
end
