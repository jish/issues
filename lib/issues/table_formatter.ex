defmodule Issues.TableFormatter do
  def split_into_columns(items, keys) do
    Enum.map(keys, fn (key) ->
      Enum.map(items, fn (item) -> Map.get(item, key) end)
    end)
  end

  def widths_of(columns) do
    Enum.map(columns, fn column ->
      Enum.map(column, fn word -> get_length(word) end)
      |> Enum.max
    end)
  end

  defp get_length(value) when is_integer(value) do
    get_length Integer.to_string(value)
  end

  defp get_length(value) do
    String.length(value)
  end

  def row_format_for(column_widths) do
    row = Enum.map(column_widths, fn width -> " ~-#{width}s " end)
    |> Enum.join("|")

    String.slice(row, 0..-2) <> " ~n"
  end

  def print_table(data, keys) do
    column_widths = split_into_columns(data, keys)
      |> widths_of
    rows = extract_values(data, keys)
    row_format = row_format_for(column_widths)

    :io.format(row_format, keys)
    IO.puts separator(column_widths)

    Enum.each(rows, fn row ->
      :io.format(row_format, Enum.map(row, fn value -> to_s(value) end))
    end)
  end

  defp to_s(value) when is_integer(value) do
    Integer.to_string(value)
  end

  defp to_s(value) do
    value
  end

  defp separator(column_widths) do
    header = Enum.map(column_widths, fn width -> List.duplicate("-", width) end)
    |> Enum.join("-+-")

    "-#{header}-"
  end

  defp extract_values(items, keys) do
    Enum.map(items, fn item ->
      Enum.map(keys, fn key -> Map.get(item, key) end)
    end)
  end
end
