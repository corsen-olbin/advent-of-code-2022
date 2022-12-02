defmodule AdventOfCodeEx.Core.Helpers.Map2D do
  def get(map, row_key, column_key) do
    case Map.get(map, row_key) do
      nil -> nil
      x -> Map.get(x, column_key)
    end
  end

  def delete(map, {row_key, column_key}) do
      new_map = Map.update(
        map,
        row_key,
        %{},
        fn x -> Map.delete(x, column_key) end
      )

      # clean up row if it's empty
      if map_size(Map.get(new_map, row_key)) == 0 do
        Map.delete(new_map, row_key)
      else
        new_map
      end
  end
end
