defmodule Mazes.MazeGeneration.AldousBroderAlgorithmTest do
  alias Mazes.MazeGeneration.AldousBroderAlgorithm
  alias Mazes.MazeDistances

  use ExUnit.Case

  test "finishes" do
    assert AldousBroderAlgorithm.generate(3, 3)
  end

  test "produces a maze that can be solved" do
    maze = AldousBroderAlgorithm.generate(10, 10)
    assert MazeDistances.shortest_path(maze, {1, 1}, {10, 10})
  end
end
