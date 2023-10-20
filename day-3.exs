# AOC 2022 - Day 3
# https://adventofcode.com/2022/day/3

# Owner Code: ownerproof-3178624-1697803670-15280481dc07

# ?> elixir day-3.exs

defmodule Day3.Part1 do
  def find_shared_item({compartment1, compartment2}) do
    MapSet.intersection(
      MapSet.new(compartment1),
      MapSet.new(compartment2)
    )
    |> MapSet.to_list()
    |> List.first()
  end

  # convert character to ascii code
  def priority(item) when is_bitstring(item), do: :binary.first(item) |> priority()

  # ascii code for 'A' is 65 and 'Z' is 90.  The offset for the puzzles values is 38
  def priority(item) when item >= 65 and item <= 90, do: item - 38

  # ascii code for 'a' is 97 and 'z' is 122.  The offset for the puzzles values is 96
  def priority(item) when item >= 97 and item <= 122, do: item - 96

  def run(input_file) do
    input_file
    |> File.stream!()
    |> Enum.reduce(0, fn rucksack, total ->
      contents = rucksack |> String.trim() |> String.graphemes()
      midpoint = contents |> length() |> Kernel./(2) |> round()
      
      contents
      |> Enum.split(midpoint)
      |> find_shared_item()
      |> priority()
      |> Kernel.+(total)
    end)
  end
end

defmodule Day3.Part2 do
  def find_badge([rucksack1, rucksack2, rucksack3]) do
    rucksack1
    |> MapSet.new()
    |> MapSet.intersection(MapSet.new(rucksack2))
    |> MapSet.intersection(MapSet.new(rucksack3))
    |> MapSet.to_list()
    |> List.first()
  end

  # convert character to ascii code
  def priority(item) when is_bitstring(item), do: :binary.first(item) |> priority()

  # ascii code for 'A' is 65 and 'Z' is 90.  The offset for the puzzles values is 38
  def priority(item) when item >= 65 and item <= 90, do: item - 38

  # ascii code for 'a' is 97 and 'z' is 122.  The offset for the puzzles values is 96
  def priority(item) when item >= 97 and item <= 122, do: item - 96

  def run(input_file) do
    input_file
    |> File.stream!()
    |> Enum.chunk_every(3)
    |> Enum.map(fn group ->
      Enum.map(group, & &1 |> String.trim() |> String.graphemes())
    end)
    |> Enum.reduce(0, fn rucksacks, total ->
      rucksacks
      |> find_badge()
      |> priority()
      |> Kernel.+(total)
    end)
  end
end

Day3.Part1.run("inputs/day-3.txt") |> IO.inspect(label: "part-1 score")
Day3.Part2.run("inputs/day-3.txt") |> IO.inspect(label: "part-2 score")
