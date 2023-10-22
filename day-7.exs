# AOC 2022 - Day 7
# https://adventofcode.com/2022/day/7

# Owner Code: ownerproof-3178624-1697803670-15280481dc07

# ?> elixir day-7.exs

defmodule Day7.Part1 do
  def process_file(fs, path, file) do
    [size, _] = file |> String.trim() |> String.split(" ")
    size = String.to_integer(size)

    Enum.map(fs, fn {k, v} ->
      if String.starts_with?(path, k) do
        {k, v + size}
      else
        {k, v}
      end
    end)
  end

  def run(input_file) do 
    input_file 
    |> File.stream!()
    |> Enum.reduce({[{"/", 0}], "/"}, fn line, {fs, current_path} ->
      case String.trim(line) do
        "$ cd /" -> {fs, "/"}
        "$ cd " <> path -> {fs, Path.join(current_path, path) |> Path.expand()}
        "$ ls" -> {fs, current_path}
        "dir " <> dir -> {fs ++ [{Path.join(current_path, dir), 0}], current_path}
        file -> {process_file(fs, current_path, file), current_path}
      end
    end)
    |> elem(0)
    |> Enum.filter(fn {_path, size} -> size <= 100_000 end)
    |> Enum.reduce(0, fn {_path, size}, total -> total + size end)
  end
end

defmodule Day7.Part2 do
  def process_file(fs, path, file) do
    [size, _] = file |> String.trim() |> String.split(" ")
    size = String.to_integer(size)

    Enum.map(fs, fn {k, v} ->
      if String.starts_with?(path, k) do
        {k, v + size}
      else
        {k, v}
      end
    end)
  end

  def find_dirs(fs) do
    total_space = 70_000_000
    required_space = 30_000_000
    used_space = fs |> Enum.find(&elem(&1, 0) == "/") |> elem(1)
    available_space = total_space - used_space
    delta_space = required_space - available_space

    fs
    |> Enum.reject(&elem(&1, 1) < delta_space)
    |> Enum.sort_by(&elem(&1, 1))
    |> List.first()
    |> elem(1)
  end

  def run(input_file) do 
    input_file 
    |> File.stream!()
    |> Enum.reduce({[{"/", 0}], "/"}, fn line, {fs, current_path} ->
      case String.trim(line) do
        "$ cd /" -> {fs, "/"}
        "$ cd " <> path -> {fs, Path.join(current_path, path) |> Path.expand()}
        "$ ls" -> {fs, current_path}
        "dir " <> dir -> {fs ++ [{Path.join(current_path, dir), 0}], current_path}
        file -> {process_file(fs, current_path, file), current_path}
      end
    end)
    |> elem(0)
    |> find_dirs()
  end
end

Day7.Part1.run("inputs/day-7.txt") |> IO.inspect(label: "part-1 result")
Day7.Part2.run("inputs/day-7.txt") |> IO.inspect(label: "part-2 result")
