defmodule AdventOfCodeExManagerTest do
  use ExUnit.Case
  alias AdventOfCodeEx.Boundary.AdventOfCodeManager

  test "Day 1 part 1" do
    assert AdventOfCodeManager.run_code({1, 1}, true) == 24000
  end

  test "Day 1 part 2" do
    assert AdventOfCodeManager.run_code({1, 2}, true) == 45000
  end
end
