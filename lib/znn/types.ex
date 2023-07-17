defmodule Znn.Types do
  defmacro __using__(_) do
    quote do
      @type label :: binary | atom
      @type item :: map
    end
  end
end
