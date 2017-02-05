defmodule Helpers.Compose do
  def compose(f, g), do: fn(x) -> f.(g.(x)) end

  def multicompose(fs) when is_list(fs) do
    List.foldl(fs, fn(x) -> x end, &compose/2)
  end
end
