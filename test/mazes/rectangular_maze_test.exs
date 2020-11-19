defmodule Mazes.RectangularMazeTest do
  use ExUnit.Case
  alias Mazes.RectangularMaze

  describe "new" do
    test "generates an adjacency matrix with no adjacent vertices" do
      result = RectangularMaze.new(width: 2, height: 3)
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
      assert RectangularMaze.new(width: 2, height: 3, all_vertices_adjacent?: true).adjacency_matrix ==
               %{
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

  describe "center" do
    test "odd size" do
      maze = RectangularMaze.new(width: 5, height: 5)
      assert RectangularMaze.center(maze) == {3, 3}
    end

    test "even size" do
      maze = RectangularMaze.new(width: 4, height: 4)
      assert RectangularMaze.center(maze) == {2, 2}
    end
  end

  describe "outer_wall?" do
    test "checks if there is the outer wall between two vertices" do
      maze = RectangularMaze.new(width: 2, height: 3)
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
end
