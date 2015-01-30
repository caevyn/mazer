defmodule Mazer do
  def init_cells(width, height) do
    #0..height-1 |> Enum.map(fn y -> Enum.map(0..width-1, fn x -> {x,y} end)  end) |> Enum.concat
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
    cell = cells |> pick_random_cell
    visit(cell, cells, walls)
  end
  
  def draw_ascii(walls) do
    {horizontal, vertical} = walls |> Enum.split_while(&(&1.orientation == :horizontal)) 
    h_rows = horizontal |> Enum.chunk_by(&(&1.y))
    v_rows = vertical |> Enum.chunk_by(&(&1.y))
    rows =  h_rows |> Enum.zip(v_rows)
    #IO.puts(inspect(rows))
    ascii_maze = rows |> Enum.reduce("", fn(x, acc) -> acc <> print_row(x) <> "\n" end)
    IO.puts(ascii_maze)
  end

  def print_row(row) do
    h = row |> elem(0)
    v = row |> elem(1)
    hs = h |> Enum.reduce("", fn(x, acc) -> acc <> print_cell(x) end)
    vs = v |> Enum.reduce("", fn(x, acc) -> acc <> print_cell(x) end)
    hs <> "\n" <> vs
  end

  def print_cell(%{:orientation => :vertical, :open => true, x: x, y: y}),    do: "    " #{x},#{y}"
  def print_cell(%{:orientation => :vertical, :open => false, x: x, y: y}),   do: "|   " #"|#{x},#{y}"
  def print_cell(%{:orientation => :horizontal, :open => true, x: x, y: y}),  do: "+   " #"+#{x},#{y}"
  def print_cell(%{:orientation => :horizontal, :open => false, x: x, y: y}), do: "+---"  #".#{x},#{y}"
  
  def visit(cell, cells, walls) when cell != nil do
    draw_ascii(walls)
    IO.puts(inspect(cell))

    seed_random
    cells = cells |> replace_list_item(cell, %{cell | visited: true})
    next_cell = get_unvisited_neighbours(cells, cell) |> Enum.shuffle |> Enum.at(0)
    IO.puts(inspect(next_cell))
    if next_cell != nil do
      walls = walls |> remove_wall_between(cell, next_cell)
    end
    visit(next_cell, cells, walls)
  end

  def visit(cell, cells, walls) do
    #backtrack?
    IO.puts('all visited?')
    %{cells: cells,walls: walls}
  end

  def remove_wall_between(walls, %{x: x1, y: y1}, %{x: x2, y: y2}) when x1 == x2 do
    wall = %{x: x1, y: max(y1, y2), orientation: :horizontal, open: false}
    IO.puts("#{inspect(wall)} h")
    walls |> open_wall(wall)
  end

  def remove_wall_between(walls, %{x: x1, y: y1}, %{x: x2, y: y2}) when y1 == y2 do
    wall = %{x: max(x1, x2), y: y1, orientation: :vertical, open: false}
    IO.puts("#{inspect(wall)} v")
    walls |> open_wall(wall)
  end

  def open_wall(walls, wall) do
    walls |> replace_list_item(wall, %{wall | :open => true})
  end

  def replace_list_item(items, old_item, new_item) do
    index = items |> Enum.find_index(&(Map.equal?(old_item, &1)))
    items |> Enum.to_list |> List.replace_at(index, new_item)
  end

  def pick_random_cell(cells) do
    seed_random
    cells |> Enum.shuffle |> Enum.at(0)
  end

  def get_unvisited_neighbours(maze, cell) do
    maze |> Enum.filter(&(is_unvisited_neighbour(cell, &1)))
  end

  defp is_unvisited_neighbour(%{:x => x, :y => cy }, %{:visited => false, :x => x, :y => y}) when y == cy + 1, do: true
  defp is_unvisited_neighbour(%{:x => x, :y => cy }, %{:visited => false, :x => x, :y => y}) when y == cy - 1, do: true
  defp is_unvisited_neighbour(%{:x => cx, :y => y }, %{:visited => false, :x => x, :y => y}) when x == cx + 1, do: true
  defp is_unvisited_neighbour(%{:x => cx, :y => y }, %{:visited => false, :x => x, :y => y}) when x == cx - 1, do: true
  defp is_unvisited_neighbour(_, _), do: false

  def seed_random do
    << a :: 32, b :: 32, c :: 32 >> = :crypto.rand_bytes(12)
    :random.seed(1,2,3)
  end
end 
