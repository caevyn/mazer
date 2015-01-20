defmodule Mazer do
  def init_maze(width, height) do
    #0..height-1 |> Enum.map(fn y -> Enum.map(0..width-1, fn x -> {x,y} end)  end) |> Enum.concat
    0..height-1 
      |> Enum.map(&(Enum.map(0..width-1, fn x -> %{x: x, y: &1, n: true, e: true, s: true, w: true, visited: false, in_path: false} end))) 
      |> Enum.concat
  end  
end