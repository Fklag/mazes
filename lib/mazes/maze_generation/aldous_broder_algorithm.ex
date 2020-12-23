defmodule Mazes.MazeGeneration.AldousBroderAlgorithm do
  @behaviour Mazes.MazeGeneration.Algorithm
  alias Mazes.Maze

  @impl true
  def supported_maze_types do
    [
      Mazes.RectangularMaze,
      Mazes.RectangularMazeWithMask,
      Mazes.CircularMaze,
      Mazes.HexagonalMaze,
      Mazes.TriangularMaze
    ]
  end

  @impl true
  def generate(opts, module \\ Mazes.RectangularMaze) do
    maze = module.new(opts)
    all_vertices = Maze.vertices(maze)

    visited =
      all_vertices
      |> Enum.map(&{&1, false})
      |> Enum.into(%{})

    start = Enum.random(all_vertices)

    visited = Map.put(visited, start, true)
    remaining = length(all_vertices) - 1

    do_generate(module, maze, start, visited, remaining)
  end

  defp do_generate(_, maze, _, _, 0) do
    maze
  end

  defp do_generate(module, maze, current_vertex, visited, remaining) do
    random_neighbor =
      maze
      |> Maze.neighboring_vertices(current_vertex)
      |> Enum.random()

    if visited[random_neighbor] do
      do_generate(module, maze, random_neighbor, visited, remaining)
    else
      maze = Maze.remove_wall(maze, current_vertex, random_neighbor)
      visited = Map.put(visited, random_neighbor, true)
      do_generate(module, maze, random_neighbor, visited, remaining - 1)
    end
  end
end
