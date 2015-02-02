defmodule MazerTest do
  use ExUnit.Case

  test "4 by 5 maze has 4 columns and 5 rows" do
    maze = Mazer.init_cells(4,5)
    assert maze |> Enum.count == 20
    assert maze |> Enum.count(&(&1[:x] == 1)) == 5
    assert maze |> Enum.count(&(&1[:y] == 1)) == 4
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
   maze = Mazer.generate_maze(8,8)
   assert maze.cells |> Enum.all?(&(&1.visited))
  end
  
  test "draw 5x5" do
    maze = Mazer.generate_maze(5,5)
    IO.puts("\n")
    AsciiPrinter.draw_ascii(maze)
  end

  test "draw 9x9" do
    maze = Mazer.generate_maze(9,9)
    IO.puts("\n")
    AsciiPrinter.draw_ascii(maze)
  end

  test "draw 14x14" do
    maze = Mazer.generate_maze(14,14)
    IO.puts("\n")
    AsciiPrinter.draw_ascii(maze)
  end

  test "draw 20x60" do
    maze = Mazer.generate_maze(20,60)
    IO.puts("\n")
    AsciiPrinter.draw_ascii(maze)
  end


end
