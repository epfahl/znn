defmodule Znn.Helpers do
  @spec merge_options(keyword(), map) :: map
  def merge_options(options, defaults_map) do
    Map.merge(defaults_map, Enum.into(options, %{}))
  end
end
