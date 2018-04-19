defmodule TableFormatterTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Issues.TableFormatter, as: TF

  def simple_test_data do
    [
      %{ "a" => "foo", "b" => "bar", "c" => "baz", "d" => "qux"},
      %{ "a" => "one", "b" => "two", "c" => "three", "d" => "four"},
      %{ "a" => "green", "b" => "eggs", "c" => "and", "d" => "ham"}
    ]
  end

  def headers do
    ["a", "b", "d"]
  end

  test "split into columns" do
    columns = TF.split_into_columns(simple_test_data(), ["a", "b", "d"])

    assert length(columns) == length(headers())
    assert List.first(columns) == ["foo", "one", "green"]
    assert List.last(columns) == ["qux", "four", "ham"]
  end

  test "column widths" do
    widths = TF.split_into_columns(simple_test_data(), headers())
    |> TF.widths_of

    assert widths == [5, 4, 4]
  end

  test "column widths of mixed types" do
    assert TF.widths_of([["one", 1234]]) == [4]
  end

  test "generate format string for row" do
    assert TF.row_format_for([5, 7, 9]) == " ~-5s | ~-7s | ~-9s ~n"
    assert TF.row_format_for([3, 7, 11]) == " ~-3s | ~-7s | ~-11s ~n"
  end

  test "table view" do
    result = capture_io fn ->
      TF.print_table(simple_test_data(), headers())
    end

    assert result ==
      " a     | b    | d    \n" <>
      "-------+------+------\n" <>
      " foo   | bar  | qux  \n" <>
      " one   | two  | four \n" <>
      " green | eggs | ham  \n"
  end
end
