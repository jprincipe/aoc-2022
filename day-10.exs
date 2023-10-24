# AOC 2022 - Day 10
# https://adventofcode.com/2022/day/10

# Owner Code: ownerproof-3178624-1697803670-15280481dc07

# ?> elixir day-10.exs

defmodule Day10.Part1 do
  def reading?(cycle), do: 0 == cycle |> Kernel.-(20) |> Kernel.rem(40)
  
  def cycle({cycle, register, readings}) do
    if reading?(cycle) do
      {cycle, register, [register * cycle | readings]}
    else
      {cycle, register, readings}
    end
  end

  def exec("noop", {cycle, register, readings}), do: cycle({cycle + 1, register, readings})

  def exec("addx " <> value, {cycle, register, readings}) do
    amount = String.to_integer(value)

    {cycle, register, readings} = cycle({cycle + 1, register, readings})
    
    cycle({cycle + 1, register + amount, readings})
  end

  def run(input_file) do 
    input_file
    |> File.stream!()
    |> Enum.reduce({1, 1, []}, fn op, acc -> op |> String.trim() |> exec(acc) end)
    |> elem(2)
    |> Enum.sum()
  end
end

defmodule Day10.Part2 do
  def cycle({cycle, register}) do
    if Enum.member?([register - 1, register, register + 1], rem(cycle - 1, 40)) do
      IO.write("#")
    else
      IO.write(".")
    end

    if rem(cycle, 40) == 0, do: IO.write("\n")

    {cycle + 1, register}
  end
  
  def exec("noop", {cycle, register}), do: cycle({cycle, register})

  def exec("addx " <> value, {cycle, register}) do
    {cycle, register} = {cycle, register} |> cycle() |> cycle()

    {cycle, register + String.to_integer(value)}
  end

  def run(input_file) do 
    input_file
    |> File.stream!()
    |> Enum.reduce({1, 1}, fn op, acc -> op |> String.trim() |> exec(acc) end)

    nil
  end
end

Day10.Part1.run("inputs/day-10.txt") |> IO.inspect(label: "part-1 result")
Day10.Part2.run("inputs/day-10.txt") |> IO.inspect(label: "part-2 result")
