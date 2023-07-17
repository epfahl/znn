defmodule Znn.PEnum do
  @module """
  Utilities for parallel processing of enumerables.
  """

  @doc """
  A parallel `map` implementation that uses `Stream.chunk_every` to batch/chunk
  the input enumerable and `Task.async_stream` to process multiple chunks
  concurrently.

  ## Options

    - `:chunk_size` - size of the enumerable chunk that is processed in
      a separate `Task`.

    The remaining options are the same as those for `Task.async_stream`.
  """
  @spec pmap(Enum.t(), (any() -> any()), keyword()) :: list()
  def pmap(enum, mapper, options \\ []) do
    {chunk_size, options} = Keyword.pop(options, :chunk_size, 1)

    enum
    |> Stream.chunk_every(chunk_size)
    |> Task.async_stream(fn batch -> Enum.map(batch, mapper) end, options)
    |> Enum.reduce([], fn {:ok, result}, acc -> [result | acc] end)
    |> Enum.flat_map(& &1)
  end
end
