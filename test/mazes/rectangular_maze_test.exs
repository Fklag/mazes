defmodule Mazes.RectangularMazeTest do
  use ExUnit.Case
  alias Mazes.RectangularMaze

  describe "new" do
    test "generates an adjacency matrix with no adjacent vertices" do
      result = RectangularMaze.new(2, 3)
      assert result.width == 2
      assert result.height == 3

      assert result.adjacency_matrix == %{
               {1, 1} => %{
                 {1, 2} => false,
                 {2, 1} => false
               },
               {1, 2} => %{
                 {1, 1} => false,
                 {1, 3} => false,
                 {2, 2} => false
               },
               {1, 3} => %{
                 {1, 2} => false,
                 {2, 3} => false
               },
               {2, 1} => %{
                 {1, 1} => false,
                 {2, 2} => false
               },
               {2, 2} => %{
                 {1, 2} => false,
                 {2, 1} => false,
                 {2, 3} => false
               },
               {2, 3} => %{
                 {1, 3} => false,
                 {2, 2} => false
               }
             }
    end

    test "generates an adjacency matrix with all vertices adjacent" do
      assert RectangularMaze.new(2, 3, true).adjacency_matrix == %{
               {1, 1} => %{
                 {1, 2} => true,
                 {2, 1} => true
               },
               {1, 2} => %{
                 {1, 1} => true,
                 {1, 3} => true,
                 {2, 2} => true
               },
               {1, 3} => %{
                 {1, 2} => true,
                 {2, 3} => true
               },
               {2, 1} => %{
                 {1, 1} => true,
                 {2, 2} => true
               },
               {2, 2} => %{
                 {1, 2} => true,
                 {2, 1} => true,
                 {2, 3} => true
               },
               {2, 3} => %{
                 {1, 3} => true,
                 {2, 2} => true
               }
             }
    end
  end

  describe "vertices" do
    test "returns sorted from left to right, top to bottom" do
      maze = RectangularMaze.new(4, 4)

      assert RectangularMaze.vertices(maze) == [
               {1, 1},
               {2, 1},
               {3, 1},
               {4, 1},
               {1, 2},
               {2, 2},
               {3, 2},
               {4, 2},
               {1, 3},
               {2, 3},
               {3, 3},
               {4, 3},
               {1, 4},
               {2, 4},
               {3, 4},
               {4, 4}
             ]
    end
  end

  describe "outer_wall?" do
    test "checks if there is the outer wall between two vertices" do
      maze = RectangularMaze.new(2, 3)
      assert RectangularMaze.outer_wall?(maze, {1, 1}, {0, 1}) == true
      assert RectangularMaze.outer_wall?(maze, {1, 2}, {0, 2}) == true
      assert RectangularMaze.outer_wall?(maze, {1, 3}, {0, 3}) == true

      assert RectangularMaze.outer_wall?(maze, {1, 1}, {2, 1}) == false
      assert RectangularMaze.outer_wall?(maze, {1, 2}, {2, 2}) == false
      assert RectangularMaze.outer_wall?(maze, {1, 3}, {2, 3}) == false

      assert RectangularMaze.outer_wall?(maze, {2, 1}, {3, 1}) == true
      assert RectangularMaze.outer_wall?(maze, {2, 2}, {3, 2}) == true
      assert RectangularMaze.outer_wall?(maze, {2, 3}, {3, 3}) == true

      assert RectangularMaze.outer_wall?(maze, {2, 1}, {1, 1}) == false
      assert RectangularMaze.outer_wall?(maze, {2, 2}, {1, 2}) == false
      assert RectangularMaze.outer_wall?(maze, {2, 3}, {1, 3}) == false

      assert RectangularMaze.outer_wall?(maze, {1, 1}, {1, 2}) == false
      assert RectangularMaze.outer_wall?(maze, {2, 1}, {2, 2}) == false

      assert RectangularMaze.outer_wall?(maze, {1, 1}, {1, 0}) == true
      assert RectangularMaze.outer_wall?(maze, {2, 1}, {2, 0}) == true

      assert RectangularMaze.outer_wall?(maze, {1, 3}, {1, 2}) == false
      assert RectangularMaze.outer_wall?(maze, {2, 3}, {2, 2}) == false

      assert RectangularMaze.outer_wall?(maze, {1, 3}, {1, 4}) == true
      assert RectangularMaze.outer_wall?(maze, {2, 3}, {2, 4}) == true
    end
  end

  describe "wall?" do
    test "outer wall counts as a wall" do
      maze = RectangularMaze.new(2, 3)
      assert RectangularMaze.wall?(maze, {1, 1}, {0, 1}) == true
      assert RectangularMaze.wall?(maze, {1, 2}, {0, 2}) == true
      assert RectangularMaze.wall?(maze, {1, 3}, {0, 3}) == true

      assert RectangularMaze.wall?(maze, {2, 1}, {3, 1}) == true
      assert RectangularMaze.wall?(maze, {2, 2}, {3, 2}) == true
      assert RectangularMaze.wall?(maze, {2, 3}, {3, 3}) == true

      assert RectangularMaze.wall?(maze, {1, 1}, {1, 0}) == true
      assert RectangularMaze.wall?(maze, {2, 1}, {2, 0}) == true

      assert RectangularMaze.wall?(maze, {1, 3}, {1, 4}) == true
      assert RectangularMaze.wall?(maze, {2, 3}, {2, 4}) == true
    end

    test "checks if there's a wall between two vertices" do
      maze = RectangularMaze.new(2, 3)
      assert RectangularMaze.wall?(maze, {1, 3}, {2, 3}) == true
      maze = RectangularMaze.remove_wall(maze, {1, 3}, {2, 3})
      assert RectangularMaze.wall?(maze, {1, 3}, {2, 3}) == false
      maze = RectangularMaze.put_wall(maze, {1, 3}, {2, 3})
      assert RectangularMaze.wall?(maze, {1, 3}, {2, 3}) == true
    end
  end

  describe "adjacent_vertices" do
    test "returns direct neighbors not separated by a wall" do
      maze = RectangularMaze.new(2, 3)
      assert RectangularMaze.adjacent_vertices(maze, {1, 3}) == []
      maze = RectangularMaze.remove_wall(maze, {1, 3}, {2, 3})
      assert RectangularMaze.adjacent_vertices(maze, {1, 3}) == [{2, 3}]
      maze = RectangularMaze.remove_wall(maze, {1, 3}, {1, 2})
      assert RectangularMaze.adjacent_vertices(maze, {1, 3}) == [{1, 2}, {2, 3}]
      maze = RectangularMaze.put_wall(maze, {1, 3}, {2, 3})
      assert RectangularMaze.adjacent_vertices(maze, {1, 3}) == [{1, 2}]
    end

    test "when no walls" do
      maze = RectangularMaze.new(3, 3, true)
      assert RectangularMaze.adjacent_vertices(maze, {1, 1}) == [{1, 2}, {2, 1}]
      assert RectangularMaze.adjacent_vertices(maze, {2, 2}) == [{1, 2}, {2, 1}, {2, 3}, {3, 2}]
      assert RectangularMaze.adjacent_vertices(maze, {3, 3}) == [{2, 3}, {3, 2}]
    end
  end

  describe "dead_ends" do
    test "returns the list of vertices with just one adjacent vertex" do
      maze =
        RectangularMaze.new(3, 3, true)
        |> RectangularMaze.put_wall({1, 1}, {1, 2})
        |> RectangularMaze.put_wall({2, 1}, {2, 2})
        |> RectangularMaze.put_wall({1, 2}, {1, 3})
        |> RectangularMaze.put_wall({2, 2}, {2, 3})

      assert RectangularMaze.dead_ends(maze) == [{1, 1}, {1, 2}, {1, 3}]
    end
  end
end
