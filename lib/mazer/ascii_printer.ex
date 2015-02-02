defmodule AsciiPrinter do
  def draw_ascii(%{walls: walls, width: width, height: height}) do
    {horizontal, vertical} = walls |> Enum.split_while(&(&1.orientation == :horizontal)) 
    h_rows = horizontal |> Enum.chunk_by(&(&1.y))
    v_rows = vertical |> Enum.chunk_by(&(&1.y))
    rows =  h_rows |> Enum.zip(v_rows)
    ascii_maze = rows |> Enum.reduce("", fn(x, acc) -> acc <> print_row(x, width, height) <> "\n" end)
    IO.puts(ascii_maze)
  end

  defp print_row(row, width, height) do
    {h,v} = row
    hs = h |> Enum.reduce("", fn(x, acc) -> acc <> print_cell(x, width, height) end)
    vs = v |> Enum.reduce("", fn(x, acc) -> acc <> print_cell(x, width, height) end)
    hs <> "\n" <> vs
  end

  defp print_cell(%{:orientation => :vertical, :open => true}, _, _),          do: "    "
  defp print_cell(%{:orientation => :vertical, :open => false, y: y}, _, y),   do: ""
  defp print_cell(%{:orientation => :vertical, :open => false}, _, _),         do: "|   "
  defp print_cell(%{:orientation => :horizontal, :open => true}, _, _),        do: "+   "
  defp print_cell(%{:orientation => :horizontal, :open => false, x: x}, x, _), do: "+"
  defp print_cell(%{:orientation => :horizontal, :open => false}, _, _),       do: "+---"
end