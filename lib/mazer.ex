defmodule Mazer do
  import Mazer.Random
  
  def init_cells(width, height) do
    for x <- 0..width-1, y <- 0..height-1, do: %{x: x, y: y, visited: false}    
  end

  def init_walls(width, height) do
    vert = for y <- 0..height, x <- 0..width, do: %{x: x, y: y, orientation: :vertical, open: false }  
    horz = for y <- 0..height, x <- 0..width, do: %{x: x, y: y, orientation: :horizontal, open: false }  
    horz ++ vert
  end

  def generate_maze(width, height) do
    cells = init_cells(width, height)
    walls = init_walls(width, height)
    start_cell = cells |> pick_random_cell
    visit(start_cell, %{cells: cells, walls: walls, height: height, width: width})
  end

  defp visit(cell = %{x: x, y: y}, maze) do
    seed_random
    index = maze.cells |> Enum.find_index(&(&1.x == x and &1.y == y))
    cell = %{cell | visited: true}
    maze = %{maze | cells: maze.cells |> Enum.to_list |> List.replace_at(index, cell)}
    neighbours = get_unvisited_neighbours(maze.cells, cell) |> Enum.shuffle
    neighbours |> Enum.reduce(maze, 
    	fn(n, acc) -> 
          neighbour = acc.cells |> Enum.find(&(&1.x == n.x and &1.y == n.y))	  
    	  do_visit(cell, neighbour, acc) 
    	end)
  end

  defp do_visit(cell, next_cell = %{visited: false}, maze) do
    walls = maze.walls |> remove_wall_between(cell, next_cell)
    visit(next_cell, %{maze | walls: walls})
  end

  defp do_visit(_, next_cell, maze) do
    visit(next_cell, maze)
  end
  
  defp remove_wall_between(walls, %{x: x, y: y1}, %{x: x, y: y2}) do
    wall = %{x: x, y: max(y1, y2), orientation: :horizontal, open: false}
    walls |> open_wall(wall)
  end

  defp remove_wall_between(walls, %{x: x1, y: y}, %{x: x2, y: y}) do
    wall = %{x: max(x1, x2), y: y, orientation: :vertical, open: false}
    walls |> open_wall(wall)
  end

  defp open_wall(walls, wall) do
    index = walls |> Enum.find_index(&(Map.equal?(wall, &1)))
    walls |> Enum.to_list |> List.replace_at(index, %{wall | :open => true})
  end

  defp pick_random_cell(cells) do
    seed_random
    cells |> Enum.shuffle |> Enum.at(0)
  end

  def get_unvisited_neighbours(cells, cell) do
    cells |> Enum.filter(&(is_unvisited_neighbour(cell, &1)))
  end

  defp is_unvisited_neighbour(%{:x => x, :y => cy }, %{:visited => false, :x => x, :y => y}) when y == cy + 1, do: true
  defp is_unvisited_neighbour(%{:x => x, :y => cy }, %{:visited => false, :x => x, :y => y}) when y == cy - 1, do: true
  defp is_unvisited_neighbour(%{:x => cx, :y => y }, %{:visited => false, :x => x, :y => y}) when x == cx + 1, do: true
  defp is_unvisited_neighbour(%{:x => cx, :y => y }, %{:visited => false, :x => x, :y => y}) when x == cx - 1, do: true
  defp is_unvisited_neighbour(_, _), do: false  
end