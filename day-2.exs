# AOC 2022 - Day 2
# https://adventofcode.com/2022/day/2

# Owner Code: ownerproof-3178624-1697803670-15280481dc07

# ?> elixir day-2.exs

defmodule Day2.Part1 do
  def mapping(value) when value in ["A", "X"], do: :rock
  def mapping(value) when value in ["B", "Y"], do: :paper
  def mapping(value) when value in ["C", "Z"], do: :scissors

  def shape_score(:rock), do: 1
  def shape_score(:paper), do: 2
  def shape_score(:scissors), do: 3

  def outcome_score(:win), do: 6
  def outcome_score(:tie), do: 3
  def outcome_score(:lose), do: 0

  def play(:rock, :rock), do: :tie
  def play(:rock, :paper), do: :win
  def play(:rock, :scissors), do: :lose

  def play(:paper, :rock), do: :lose
  def play(:paper, :paper), do: :tie
  def play(:paper, :scissors), do: :win

  def play(:scissors, :rock), do: :win
  def play(:scissors, :paper), do: :lose
  def play(:scissors, :scissors), do: :tie

  def run(input_file) do
    input_file
    |> File.stream!()
    |> Enum.reduce(0, fn round, total ->
      [opponent, self] = round |> String.trim() |> String.split(" ") |> Enum.map(&mapping/1)
      outcome = play(opponent, self)
      
      total + shape_score(self) + outcome_score(outcome)
    end)
  end
end

defmodule Day2.Part2 do
  def mapping(value) when value in ["A"], do: :rock
  def mapping(value) when value in ["B"], do: :paper
  def mapping(value) when value in ["C"], do: :scissors

  def outcome_mapping(value) when value in ["X"], do: :lose
  def outcome_mapping(value) when value in ["Y"], do: :tie
  def outcome_mapping(value) when value in ["Z"], do: :win

  def shape_score(:rock), do: 1
  def shape_score(:paper), do: 2
  def shape_score(:scissors), do: 3

  def outcome_score(:win), do: 6
  def outcome_score(:tie), do: 3
  def outcome_score(:lose), do: 0

  def play(:rock, :tie), do: :rock
  def play(:rock, :win), do: :paper
  def play(:rock, :lose), do: :scissors

  def play(:paper, :lose), do: :rock
  def play(:paper, :tie), do: :paper
  def play(:paper, :win), do: :scissors

  def play(:scissors, :win), do: :rock
  def play(:scissors, :lose), do: :paper
  def play(:scissors, :tie), do: :scissors

  def run(input_file) do
    input_file
    |> File.stream!()
    |> Enum.reduce(0, fn round, total ->
      [opponent, outcome] = round |> String.trim() |> String.split(" ")
      opponent = mapping(opponent)
      outcome = outcome_mapping(outcome)
      
      self = play(opponent, outcome)
      
      total + shape_score(self) + outcome_score(outcome)
    end)
  end
end

Day2.Part1.run("inputs/day-2.txt") |> IO.inspect(label: "part-1 score")
Day2.Part2.run("inputs/day-2.txt") |> IO.inspect(label: "part-2 score")
