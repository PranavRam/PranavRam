defmodule PrWebsite do
  defmacro sigil_H({:<<>>, opts, [bin]}, _mods) do
    quote do
      _ = var!(assigns)
      unquote(EEx.compile_string(bin, opts))
    end
  end

  def base_path(config) do
    if config && config.base_path do
      String.trim_trailing(config.base_path, "/")
    else
      ""
    end
  end
end
