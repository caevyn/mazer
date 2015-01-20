defmodule MazerTest do
  use ExUnit.Case

  test "4 by 5 maze has 4 columns and 5 rows" do
    maze = Mazer.init_maze(4,5)
    assert maze |> Enum.count == 20
    assert maze |> Enum.count(&(&1[:x] == 1)) == 5
    assert maze |> Enum.count(&(&1[:y] == 1)) == 4
  end
end
