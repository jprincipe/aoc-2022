# AOC 2022 - Day 4
# https://adventofcode.com/2022/day/4

# Owner Code: ownerproof-3178624-1697803670-15280481dc07

# ?> elixir day-4.exs

defmodule Day4.Part1 do
  def sections(value) do
    [s, e] = value |> String.split("-") |> Enum.map(&String.to_integer/1)
    
    s..e |> Enum.to_list() |> MapSet.new()
  end

  def subset?(section1, section2), do: MapSet.subset?(section1, section2) || MapSet.subset?(section2, section1)

  def run(input_file) do
    input_file
    |> File.stream!()
    |> Enum.reduce(0, fn pairing, count ->
      [assign1, assign2] = pairing |> String.trim() |> String.split(",")
      section1 = sections(assign1)
      section2 = sections(assign2)
      
      if subset?(section1, section2), do: (count + 1), else: count
    end)
  end
end

defmodule Day4.Part2 do
  def sections(value) do
    [s, e] = value |> String.split("-") |> Enum.map(&String.to_integer/1)
    
    s..e |> Enum.to_list() |> MapSet.new()
  end

  def overlap?(section1, section2) do
    MapSet.intersection(section1, section2)
    |> MapSet.to_list()
    |> Enum.empty?()
    |> Kernel.not()
  end

  def run(input_file) do
    input_file
    |> File.stream!()
    |> Enum.reduce(0, fn pairing, count ->
      [assign1, assign2] = pairing |> String.trim() |> String.split(",")
      section1 = sections(assign1)
      section2 = sections(assign2)
      
      if overlap?(section1, section2), do: (count + 1), else: count
    end)
  end
end

Day4.Part1.run("inputs/day-4.txt") |> IO.inspect(label: "part-1 score")
Day4.Part2.run("inputs/day-4.txt") |> IO.inspect(label: "part-2 score")
