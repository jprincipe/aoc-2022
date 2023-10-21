# AOC 2022 - Day 6
# https://adventofcode.com/2022/day/6

# Owner Code: ownerproof-3178624-1697803670-15280481dc07

# ?> elixir day-6.exs

defmodule Day6 do
  def find_marker(data, marker_length) do
    Enum.reduce_while(1..String.length(data), :unused, fn index, _acc ->
      if marker?(data, index, marker_length) do 
        {:halt, index}
      else
        {:cont, index}
      end
    end)
  end

  def marker?(data, index, marker_length) do
    data 
    |> sample(index, marker_length) 
    |> String.graphemes() 
    |> Enum.uniq() 
    |> Enum.count() 
    |> Kernel.==(marker_length)
  end

  def sample(data, index, length), do: String.slice(data , max(0, index - length)..(index - 1))

  def run(input_file, marker_length) do 
    input_file 
    |> File.read!() 
    |> String.trim() 
    |> find_marker(marker_length)
  end
end

Day6.run("inputs/day-6.txt", 4) |> IO.inspect(label: "part-1 result")
Day6.run("inputs/day-6.txt", 14) |> IO.inspect(label: "part-2 result")
