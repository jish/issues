defmodule CliTest do
  use ExUnit.Case
  doctest Issues

  import Issues.Cli, only: [
    parse_args: 1,
    decode_response: 1,
    sort_into_ascending_order: 1
  ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "14"]) == { "user", "project", 14 }
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == { "user", "project", 4 }
  end

  test "decoding a successful response" do
    assert decode_response({:ok, %{ "foo" => "bar" }}) == %{ "foo" => "bar" }
  end

  test "sort into ascending order" do
    assert sort_into_ascending_order(fake_created_at_list([2, 1])) == [
      %{ "created_at" => 1, "other_key" => "other_value" },
      %{ "created_at" => 2, "other_key" => "other_value" }
    ]
  end

  defp fake_created_at_list(values) do
    for value <- values,
    do: %{ "created_at" => value, "other_key" => "other_value" }
  end
end
