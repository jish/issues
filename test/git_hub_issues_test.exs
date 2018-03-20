defmodule GitHubIssuesTest do
  use ExUnit.Case
  doctest Issues

  import Issues.GitHubIssues, only: [issues_url: 2, handle_response: 1]

  test "build a URL to request issues from a user and a project" do
    assert issues_url("phoenixframework", "phoenix") ==
      "https://api.github.com/repos/phoenixframework/phoenix/issues"
  end

  test "handle ok response" do
    assert handle_response({:ok, %{ status_code: 200, body: 'body' } }) ==
      { :ok, 'body'}
  end

  test "handle other response code" do
    assert handle_response({:ok, %{ status_code: 201, body: 'body' } }) ==
      { :error, 'body'}
  end

  test "handle error response" do
    assert handle_response({:error, %{ status_code: 500, body: 'body' } }) ==
      { :error, 'body'}
  end
end
