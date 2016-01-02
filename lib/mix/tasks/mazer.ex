defmodule Mix.Tasks.Mazer do
  use Mix.Task
  
  def run([x,y]) do
    IO.puts("#{x}X#{y} Maze\n")
	[x,y] = [String.to_integer(x), String.to_integer(y)]
	maze = Mazer.generate_maze(x,y)
    AsciiPrinter.draw_ascii(maze)
  end
  
  def run([x]) do
    run([x,x])
  end
  
  def run(_) do
    IO.puts("Run with mix Mazer X Y to generate different size\n")
    run(["10","10"])
  end
end