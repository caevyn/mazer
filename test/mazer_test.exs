defmodule MazerTest do
  use ExUnit.Case

  test "4 by 5 maze has 4 columns and 5 rows" do
    maze = Mazer.init_cells(4,5)
    assert maze |> Enum.count == 20
    assert maze |> Enum.count(&(&1[:x] == 1)) == 5
    assert maze |> Enum.count(&(&1[:y] == 1)) == 4
  end


  test "Get a random cell returns a cell" do
    maze = Mazer.init_cells(4,5)
    1..5 |> Enum.each(fn _ -> 
      cell = Mazer.pick_random_cell(maze)
      assert cell[:x] < 4
      assert cell[:y] < 5
    end)
  end

  test "get_unvisited_neighbours returns 2 neighbours in new maze in top corner" do
    maze = Mazer.init_cells(4,5)
    neighbours = Mazer.get_unvisited_neighbours(maze, Enum.at(maze, 0))
    assert neighbours |> Enum.count == 2
  end

  test "get_unvisited_neighbours returns 3 neighbours in new maze on top edge when not a corner" do
    maze = Mazer.init_cells(4,5)
    neighbours = Mazer.get_unvisited_neighbours(maze, Enum.at(maze, 1)) 
    assert neighbours |> Enum.count == 3
  end

  test "get_unvisited_neighbours returns 4 neighbours in new maze when not on edge or corner" do
    maze = Mazer.init_cells(4,5)
    neighbours = Mazer.get_unvisited_neighbours(maze, Enum.at(maze, 6))
    assert neighbours |> Enum.count == 4
  end

  test "Generated maze has all cells visited" do
   #maze = Mazer.generate_maze(8,8)
   # assert maze.cells |> Enum.all?(&(&1.visited))
   # Mazer.draw_ascii(maze.walls)
  end
  
  test "draw" do
    maze = Mazer.generate_maze(9,9)
    Mazer.draw_ascii(maze.walls)
  end


end
