defmodule Mazes.RectangularMaze do
  defstruct [:width, :height, :adjacency_matrix, :from, :to]

  @doc "Returns a rectangular maze with given size, either with all walls or no walls"
  def new(width, height, all_adjacent? \\ false) do
    vertices =
      Enum.reduce(1..width, [], fn x, acc ->
        Enum.reduce(1..height, acc, fn y, acc2 ->
          [{x, y} | acc2]
        end)
      end)

    adjacency_matrix =
      vertices
      |> Enum.map(fn {from_x, from_y} = from ->
        value =
          vertices
          |> Enum.filter(fn {x, y} ->
            {x, y} in [
              {from_x - 1, from_y},
              {from_x + 1, from_y},
              {from_x, from_y - 1},
              {from_x, from_y + 1}
            ]
          end)
          |> Enum.map(&{&1, all_adjacent?})
          |> Enum.into(%{})

        {from, value}
      end)
      |> Enum.into(%{})

    %__MODULE__{
      width: width,
      height: height,
      adjacency_matrix: adjacency_matrix
    }
  end

  def vertices(maze) do
    Map.keys(maze.adjacency_matrix)
    |> Enum.sort(fn {x1, y1}, {x2, y2} ->
      if y1 == y2 do
        x1 < x2
      else
        y1 < y2
      end
    end)
  end

  def north({x, y}), do: {x, y - 1}
  def south({x, y}), do: {x, y + 1}
  def east({x, y}), do: {x + 1, y}
  def west({x, y}), do: {x - 1, y}

  def outer_wall?(%__MODULE__{} = _maze, {1, _}, {0, _}), do: true
  def outer_wall?(%__MODULE__{} = _maze, {_, 1}, {_, 0}), do: true

  def outer_wall?(%__MODULE__{} = maze, {x1, y1}, {x2, y2}) do
    (maze.width == x1 && x2 == x1 + 1) ||
      (maze.height == y1 && y2 == y1 + 1)
  end

  def wall?(%__MODULE__{} = maze, from, to), do: !maze.adjacency_matrix[from][to]
  def put_wall(%__MODULE__{} = maze, from, to), do: set_adjacency(maze, from, to, false)
  def remove_wall(%__MODULE__{} = maze, from, to), do: set_adjacency(maze, from, to, true)

  @doc "Returns all neighboring vertices that do not have a wall between themselves and the given one"
  def adjacent_vertices(maze, from) do
    maze.adjacency_matrix[from]
    |> Enum.filter(fn {_, adjacency} -> adjacency end)
    |> Enum.map(fn {cell, _} -> cell end)
  end

  @doc "Returns all neighboring vertices regardless of whether there is a wall or not"
  def neighboring_vertices(maze, from) do
    maze.adjacency_matrix[from]
    |> Enum.map(fn {cell, _} -> cell end)
  end

  defp set_adjacency(maze, from, to, value) do
    adjacency_matrix =
      maze.adjacency_matrix
      |> put_in([from, to], value)
      |> put_in([to, from], value)

    %{maze | adjacency_matrix: adjacency_matrix}
  end

  @doc "Returns a list of vertices that are in the last or first column or row"
  def border_vertices(maze) do
    vertices = []

    vertices =
      Enum.reduce(1..maze.width, vertices, fn x, acc ->
        [{x, 1}, {x, maze.height} | acc]
      end)

    Enum.reduce(2..(maze.height - 1), vertices, fn y, acc ->
      [{1, y}, {maze.width, y} | acc]
    end)
  end

  @doc "Groups vertices by the number of adjacent vertices they have"
  def group_vertices_by_adjacent_count(maze) do
    vertices(maze)
    |> Enum.group_by(fn vertex ->
      length(adjacent_vertices(maze, vertex))
    end)
  end
end
