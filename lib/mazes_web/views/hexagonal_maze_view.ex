defmodule MazesWeb.HexagonalMazeView do
  use MazesWeb, :view

  import MazesWeb.MazeHelper
  alias Mazes.Maze

  def hex_radius(maze) do
    max_width = max_svg_width() - 2 * svg_padding()
    max_height = max_svg_width() - 2 * svg_padding()
    r1 = trunc(max_width / (0.5 + maze.width * 1.5))
    r2 = trunc(max_height / (1 + maze.height * 2))
    Enum.min([r1, r2])
  end

  def hex_height(maze) do
    2 * hex_radius(maze) * :math.sin(:math.pi() / 3)
  end

  def alpha() do
    :math.pi() / 3
  end

  def svg_width(maze) do
    2 * svg_padding() + hex_radius(maze) * (0.5 + maze.width * 1.5)
  end

  def svg_height(maze) do
    2 * svg_padding() + hex_height(maze) / 2 * (1 + maze.height * 2)
  end

  def hex_center(maze, {x, y}) do
    r = hex_radius(maze)
    h = hex_height(maze)
    cx = r + 1.5 * r * (x - 1) + svg_padding()

    cy =
      if Integer.mod(x, 2) == 1 do
        h / 2 * (1 + (y - 1) * 2) + svg_padding()
      else
        h / 2 * (2 + (y - 1) * 2) + svg_padding()
      end

    {cx, cy}
  end

  def hex(maze, vertex, settings, colors) do
    r = hex_radius(maze)
    hex_center = hex_center(maze, vertex)

    hex_points =
      Enum.map(0..5, fn n ->
        move_coordinate_by_radius_and_angle(hex_center, r, alpha() / 2 + n * alpha())
      end)

    {path_start_x, path_start_y} = List.last(hex_points)
    path_lines = Enum.map(hex_points, fn {x, y} -> "L #{x} #{y}" end) |> Enum.join(" ")
    d = "M #{path_start_x} #{path_start_y} #{path_lines}"

    content_tag(:path, "",
      d: d,
      style:
        "fill: #{
          vertex_color(
            maze,
            vertex,
            colors,
            settings.show_colors,
            settings.hue,
            settings.saturation
          )
        }",
      stroke:
        vertex_color(
          maze,
          vertex,
          colors,
          settings.show_colors,
          settings.hue,
          settings.saturation
        )
    )
  end

  def wall(maze, vertex, n) do
    r = hex_radius(maze)
    hex_center = hex_center(maze, vertex)

    {path_start_x, path_start_y} =
      move_coordinate_by_radius_and_angle(hex_center, r, alpha() / 2 + n * alpha())

    {path_end_x, path_end_y} =
      move_coordinate_by_radius_and_angle(hex_center, r, alpha() / 2 + (n + 1) * alpha())

    d = "M #{path_start_x} #{path_start_y} L #{path_end_x} #{path_end_y}"

    content_tag(:path, "",
      d: d,
      fill: "transparent",
      style: line_style(maze)
    )
  end
end
