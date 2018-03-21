defmodule GitHubIssuesTest do
  use ExUnit.Case
  doctest Issues

  import Issues.GitHubIssues, only: [issues_url: 2, handle_response: 1]

  test "build a URL to request issues from a user and a project" do
    assert issues_url("phoenixframework", "phoenix") ==
      "https://api.github.com/repos/phoenixframework/phoenix/issues"
  end

  test "handle ok response" do
    assert handle_response(
      {:ok, %{ status_code: 200, body: ~s({ "foo": "bar" }) } }) ==
      {:ok, %{ "foo" => "bar" }}
  end

  test "handle other response code" do
    assert handle_response(
      {:ok, %{ status_code: 201, body: ~s({ "status": "created" }) } }) ==
      {:error, %{ "status" => "created" }}
  end

  test "handle error response" do
    assert handle_response(
      {:error, %{ status_code: 500, body: ~s({ "error": "server error"}) } }) ==
      {:error, %{ "error" => "server error" }}
  end
end
