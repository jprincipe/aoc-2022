# AOC 2022 - Day 5
# https://adventofcode.com/2022/day/5

# Owner Code: ownerproof-3178624-1697803670-15280481dc07

# ?> elixir day-5.exs

defmodule Day5 do
  def parse_line(line, {:stack, stacks}, _part) do
    if String.trim(line) == "" do
      {:moves, build_stacks(stacks)}
    else
      {:stack, [parse_row(line) | stacks]}
    end
  end

  def parse_line(line, {:moves, stacks}, part) do
    {:moves, line |> parse_move() |> perform_move(stacks, part)}
  end

  def parse_move(move) do
    parts = String.split(move, " ")
    count = Enum.at(parts, 1) |> String.trim() |> String.to_integer()
    from = Enum.at(parts, 3) |> String.trim()
    to = Enum.at(parts, 5) |> String.trim()

    {count, from, to}
  end

  def perform_move({count, from, to}, stack, :part1) do
    from_stack = Map.get(stack, from)
    to_stack = Map.get(stack, to)

    {from_stack, to_stack} =
      Enum.reduce(1..count, {from_stack, to_stack}, fn _, {from_stack, to_stack} ->
        {item, from_stack} = List.pop_at(from_stack, -1)
        to_stack = to_stack ++ [item]

        {from_stack, to_stack}
      end)

    stack
    |> Map.put(from, from_stack)
    |> Map.put(to, to_stack)
  end

  def perform_move({count, from, to}, stack, :part2) do
    from_stack = Map.get(stack, from)
    to_stack = Map.get(stack, to)

    {from_stack, items} =
      Enum.reduce(1..count, {from_stack, []}, fn _, {from_stack, items} ->
        {item, from_stack} = List.pop_at(from_stack, -1)
        
        {from_stack, items ++ [item]}
      end)

    stack
    |> Map.put(from, from_stack)
    |> Map.put(to, to_stack ++ Enum.reverse(items))
  end

  def parse_row(row) do
    row 
    |> String.codepoints()
    |> Enum.chunk_every(4)
    |> Enum.map(&parse_crate/1)
  end

  def parse_crate(crate) do
    case Enum.at(crate, 1) do
      " " -> nil
      value -> value
    end
  end

  def build_stacks([keys | rows]) do
    keys
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {key, index}, map ->
      stack = build_stack(rows, index)
      
      Map.put(map, key, stack)
    end)
  end

  def build_stack(rows, index) do
    rows
    |> Enum.map(&Enum.at(&1, index))
    |> Enum.reject(&is_nil/1)
  end

  def run(input_file, part) do
    input_file
    |> File.stream!()
    |> Enum.reduce({:stack, []}, fn line, acc -> parse_line(line, acc, part) end)
    |> elem(1)
    |> Enum.map(fn {_k, v}-> Enum.at(v, -1) end)
    |> Enum.join()
  end
end

Day5.run("inputs/day-5.txt", :part1) |> IO.inspect(label: "part-1 result")
Day5.run("inputs/day-5.txt", :part2) |> IO.inspect(label: "part-2 result")
