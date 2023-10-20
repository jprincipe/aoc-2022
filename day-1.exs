# AOC 2022 - Day 1
# https://adventofcode.com/2022/day/1

# Owner Code: ownerproof-3178624-1697803670-15280481dc07

# ?> elixir day-1.exs

defmodule Day1 do
  def part1(input_file) do
    input_file
    |> File.stream!()
    |> Enum.reduce({0, 0}, fn line, {leader, count} ->
      with {value, _} <- Integer.parse(line) do
        {leader, count + value}
      else
        :error -> if count > leader, do: {count, 0}, else: {leader, 0}
      end
    end)
  end

  def part2(input_file) do
    input_file
    |> File.stream!()
    |> Enum.reduce({[0, 0, 0], 0}, fn line, {leaders, count} ->
      with :error <- Integer.parse(line) do
        if count > Enum.at(leaders, -1) do
          {leaders |> List.replace_at(-1, count) |> Enum.sort() |> Enum.reverse(), 0}
        else
          {leaders, 0}
        end
      else
        {value, _} -> {leaders, count + value}
      end
    end)
  end
end

{leader, _} = Day1.part1("inputs/day-1.txt")
IO.inspect(leader, label: "part 1")

{leaders, _} = Day1.part2("inputs/day-1.txt")
leaders |> Enum.sum() |> IO.inspect(label: "part 2")
