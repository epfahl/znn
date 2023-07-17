defmodule Znn do
  @moduledoc """

  ## Notes
  - Really should be configurable for compressor, to compare no compression vs zlib.
  - Precompute compression sizes.
  """

  use Znn.Types

  alias Znn.Helpers, as: H
  alias Znn.Predict, as: P

  @default_predict_options %{
    parallel_chunk_size: 100,
    knn_k: 10,
    vote_type: :majority
  }

  @spec predict(binary, list(item), keyword()) :: label
  def predict(text, training_set, options \\ []) do
    options_map = H.merge_options(options, @default_predict_options)
    P.predict(text, training_set, options_map)
  end
end
