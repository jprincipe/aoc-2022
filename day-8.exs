# AOC 2022 - Day 8
# https://adventofcode.com/2022/day/8

# Owner Code: ownerproof-3178624-1697803670-15280481dc07

# ?> elixir day-8.exs

defmodule Day8.Part1 do
  def visible_trees(trees) do
    columns = Enum.count(trees)
    rows = trees |> Enum.at(0) |> Enum.count()
    edge_count = (columns * 2) + (rows * 2) - 4

    Enum.reduce(1..columns - 2, edge_count, fn y, acc ->
      Enum.reduce(1..rows - 2, acc, fn x, acc -> 
        if visible?(trees, {x, y}), do: acc + 1, else: acc
      end)
    end)
  end

  def visible?(trees, {x, y}) do
    height = trees |> Enum.at(y) |> Enum.at(x)
    
    visible_left?(trees, {x, y}, height) 
    || visible_right?(trees, {x, y}, height) 
    || visible_top?(trees, {x, y}, height)
    || visible_bottom?(trees, {x, y}, height)
  end
  
  def visible_left?(trees, {x, y}, height) do
    trees
    |> Enum.at(y)
    |> Enum.slice(0..(x - 1))
    |> Enum.map(&(&1 < height))
    |> Enum.all?()
  end
  
  def visible_right?(trees, {x, y}, height) do
    trees
    |> Enum.at(y)
    |> Enum.slice(x + 1..-1)
    |> Enum.map(&(&1 < height))
    |> Enum.all?()
  end
  
  def visible_top?(trees, {x, y}, height) do
    trees
    |> Enum.map(&Enum.at(&1, x))
    |> Enum.slice(0..(y - 1))
    |> Enum.map(&(&1 < height))
    |> Enum.all?()
  end
  
  def visible_bottom?(trees, {x, y}, height) do
    trees
    |> Enum.map(&Enum.at(&1, x))
    |> Enum.slice(y + 1..-1)
    |> Enum.map(&(&1 < height))
    |> Enum.all?()
  end

  def parse_row(row), do: row |> String.trim() |> String.codepoints() |> Enum.map(&String.to_integer/1)

  def run(input_file) do 
    input_file 
    |> File.stream!()
    |> Enum.map(&parse_row/1)
    |> visible_trees()
  end
end

defmodule Day8.Part2 do
  def find_build_spot(trees) do
    columns = Enum.count(trees)
    rows = trees |> Enum.at(0) |> Enum.count()

    Enum.reduce(1..columns - 2, 0, fn y, high_score ->
      Enum.reduce(1..rows - 2, high_score, fn x, high_score -> 
        max(high_score, calc_scenic_score(trees, {x, y}))
      end)
    end)
  end

  def calc_scenic_score(trees, {x, y}) do
    height = trees |> Enum.at(y) |> Enum.at(x)
    
    [
      Enum.max([1, calc_top(trees, {x, y}, height)]),
      Enum.max([1, calc_left(trees, {x, y}, height)]),
      Enum.max([1, calc_right(trees, {x, y}, height)]),
      Enum.max([1, calc_bottom(trees, {x, y}, height)])
    ]
    |> Enum.reduce(1, fn score, total -> score * total end)
  end
  
  def calc_left(trees, {x, y}, height) do
    trees
    |> Enum.at(y)
    |> Enum.slice(0..(x - 1))
    |> Enum.reverse()
    |> calc_score(height)
  end
  
  def calc_right(trees, {x, y}, height) do
    trees
    |> Enum.at(y)
    |> Enum.slice(x + 1..-1)
    |> calc_score(height)
  end
  
  def calc_top(trees, {x, y}, height) do
    trees
    |> Enum.map(&Enum.at(&1, x))
    |> Enum.slice(0..(y - 1))
    |> Enum.reverse()
    |> calc_score(height)
  end
  
  def calc_bottom(trees, {x, y}, height) do
    trees
    |> Enum.map(&Enum.at(&1, x))
    |> Enum.slice(y + 1..-1)
    |> calc_score(height)
  end

  def calc_score(neighbors, height) do
    Enum.reduce_while(neighbors, 0, fn value, score ->
      if value < height do
        {:cont, score + 1} 
      else
        {:halt, score + 1}
      end
    end)
  end

  def parse_row(row), do: row |> String.trim() |> String.codepoints() |> Enum.map(&String.to_integer/1)

  def run(input_file) do 
    input_file 
    |> File.stream!()
    |> Enum.map(&parse_row/1)
    |> find_build_spot()
  end
end

Day8.Part1.run("inputs/day-8.txt") |> IO.inspect(label: "part-1 result")
Day8.Part2.run("inputs/day-8.txt") |> IO.inspect(label: "part-2 result")
