defmodule Issues.GitHubIssues do
  require Logger

  @github_url Application.get_env(:issues, :github_url)
  @user_agent [{ "User-agent", "Elixir Issues 0.1" }]

  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project #{project}"

    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({ :ok, %{ status_code: 200, body: body } }) do
    Logger.info "Successful response"
    Logger.debug fn -> inspect(body) end

    { :ok, Poison.Parser.parse!(body) }
  end

  def handle_response({ :ok, %{ status_code: status_code, body: body } }) do
    Logger.error "Error status #{status_code} returned"
    { :error, Poison.Parser.parse!(body) }
  end

  def handle_response({ :error, %{ status_code: status_code, body: body } }) do
    Logger.error "Error receiving response\n#{status_code}\n#{body}"
    { :error, Poison.Parser.parse!(body) }
  end
end
