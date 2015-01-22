defmodule Mazer do
  def init_maze(width, height) do
    #0..height-1 |> Enum.map(fn y -> Enum.map(0..width-1, fn x -> {x,y} end)  end) |> Enum.concat
    0..height-1 
      |> Enum.map(&(Enum.map(0..width-1, fn x -> %{x: x, y: &1, n: true, e: true, s: true, w: true, visited: false, in_path: false} end))) 
      |> Enum.concat
  end

  def pick_random_cell(cells) do
    seed_random
    cells |> Enum.shuffle |> Enum.at(0)
  end

  def get_unvisited_neighbours(maze, cell) do
    maze |> Enum.filter(fn c -> is_unvisited_neighbour(cell, c) end)
  end

  defp is_unvisited_neighbour(%{:x => x, :y => cy }, %{:visited => false, :x => x, :y => y}) when y == cy + 1, do: true
  defp is_unvisited_neighbour(%{:x => x, :y => cy }, %{:visited => false, :x => x, :y => y}) when y == cy - 1, do: true
  defp is_unvisited_neighbour(%{:x => cx, :y => y }, %{:visited => false, :x => x, :y => y}) when x == cx + 1, do: true
  defp is_unvisited_neighbour(%{:x => cx, :y => y }, %{:visited => false, :x => x, :y => y}) when x == cx - 1, do: true
  defp is_unvisited_neighbour(_, _), do: false

  def seed_random do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(a,b,c)
  end
end 