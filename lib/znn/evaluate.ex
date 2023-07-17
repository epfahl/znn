defmodule Znn.Evaluate do
  @moduledoc """
  Utilities for evaluating prediction performance of `Znn`.
  """

  use Znn.Types
  alias Znn.Helpers, as: H

  @default_init_options %{
    limit_count: 10_000,
    training_fraction: 0.9
  }

  @spec init(list(item), keyword()) :: {list(item), list(item)}
  def init(data, options \\ []) do
    %{
      limit_count: limit_count,
      training_fraction: training_fraction
    } = H.merge_options(options, @default_init_options)

    data
    |> Enum.take(limit_count)
    |> split_fraction(training_fraction)
  end

  @doc """
  Given test and training sets, return the predictive accuracy as

  (number of matches) / (number of test items)
  """
  @spec accuracy(list(item), (binary -> label)) :: float()
  def accuracy(test_set, predict_fn) do
    n_match =
      test_set
      |> Enum.reduce(0, fn %{label: label, text: text}, acc ->
        if label == predict_fn.(text), do: acc + 1, else: acc
      end)

    n_match / length(test_set)
  end

  @spec split_fraction(list, float) :: {list, list}
  defp split_fraction(data, fraction) do
    Enum.split(data, floor(fraction * length(data)))
  end
end
