defmodule MazesWeb.PageView do
  use MazesWeb, :view

  alias Mazes.{Settings, MazeColors}

  # doesn't matter that much because the svg is responsive
  def max_svg_width, do: 1000

  def padding, do: 20

  def square_size(maze),
    do: Integer.floor_div(max_svg_width(), Enum.max([maze.width, maze.height]))

  def vertex_fill(maze, vertex, solution, show_solution, colors, show_colors, hue) do
    fill =
      cond do
        vertex == maze.from ->
          "lightgray"

        vertex == maze.to ->
          "gray"

        show_solution && vertex in solution ->
          MazeColors.solution_color(hue)

        show_colors && colors ->
          MazeColors.color(colors.distances[vertex], colors.max_distance, hue)

        true ->
          "white"
      end

    if fill, do: "style=\"fill: #{fill}\""
  end

  def line_style(maze) do
    stroke_width =
      case Enum.max([maze.width, maze.height]) do
        n when n <= 64 -> 3
        n when n <= 128 -> 2
        n when n <= 256 -> 1
      end

    "stroke: black; stroke-width: #{stroke_width}; stroke-linecap: round;"
  end

  def opts_for_shape_select() do
    labels = %{
      "rectangle" => "Rectangle",
      "rectangle-with-mask" => "Rectangle with a mask"
    }

    Enum.map(Settings.shapes(), &Map.merge(&1, %{label: labels[&1.slug]}))
  end

  def opts_for_algorithm_select do
    labels = %{
      "algorithm-aldous-broder" => "Aldous-Broder (unbiased)",
      "algorithm-wilsons" => "Wilson's (unbiased)",
      "algorithm-hunt-and-kill" => "Hunt and Kill (biased)",
      "algorithm-recursive-backtracker" => "Recursive Backtracker (biased)",
      "algorithm-binary-tree" => "Binary Tree (biased)",
      "algorithm-sidewinder" => "Sidewinder (biased)"
    }

    Enum.map(Settings.algorithms(), &Map.merge(&1, %{label: labels[&1.slug]}))
  end

  def opts_for_entrance_exit_strategy_select do
    labels = %{
      "entrance-exit-hardest" => "Longest path",
      "entrance-exit-random" => "Random",
      "entrance-exit-nil" => "None"
    }

    Enum.map(Settings.entrance_exit_strategies(), &Map.merge(&1, %{label: labels[&1.slug]}))
  end

  def opts_for_mask_select() do
    [
      %{path: "/images/maze_patterns/heart.png", label: "Heart", slug: "heart"},
      %{path: "/images/maze_patterns/amazing.png", label: "A*maze*ing!", slug: "amazing"}
    ]
  end

  def algorithm_disabled?(shape, algorithm) do
    if algorithm in Settings.algorithms_per_shape()[shape] do
      ""
    else
      "disabled"
    end
  end
end
