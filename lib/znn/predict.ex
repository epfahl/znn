defmodule Znn.Predict do
  @moduledoc """
  Generate kNN label predictions using the Normalized Compression Distance.
  """

  use Znn.Types

  @spec predict(binary, list(item), map) :: label
  def predict(text, training_set, %{
        parallel_chunk_size: chunk_size,
        knn_k: k,
        vote_type: vt
      }) do
    closest_labels =
      training_set
      |> Znn.PEnum.pmap(
        fn %{label: label_train, text: text_train} ->
          {ncd(text, text_train), label_train}
        end,
        chunk_size: chunk_size,
        ordered: false
      )
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.take(k)
      |> Enum.map(&elem(&1, 1))

    vote(vt, closest_labels)
  end

  @spec ncd(binary, binary) :: float
  defp ncd(text_x, text_y) do
    cx = compressed_size(text_x)
    cy = compressed_size(text_y)
    cxy = concat_binaries(text_x, text_y) |> compressed_size()

    (cxy - min(cx, cy)) / max(cx, cy)
  end

  @spec concat_binaries(binary, binary) :: binary
  defp concat_binaries(x, y), do: x <> " " <> y

  @spec compressed_size(binary, (binary -> binary)) :: non_neg_integer
  def compressed_size(text, compressor_fn \\ &:zlib.compress/1) do
    text |> compressor_fn.() |> byte_size()
  end

  @spec vote(atom, list(label)) :: label
  defp vote(:majority, labels) do
    labels
    |> Enum.frequencies()
    |> Enum.max_by(fn {_label, count} -> count end)
    |> elem(0)
  end
end
