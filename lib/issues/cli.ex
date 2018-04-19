defmodule Issues.Cli do

  @default_count 4

  @moduledoc """
  Handle the command line parsing and
  dispatch to various functions that will eventually
  generate a table of the last _n_ issues of a GitHub project.
  """

  def run(argv) do
    parse_args(argv)
    |> process
  end

  @doc """
  `argv` can be `-h` or `--help`, which returns `:help`

  Otherwise, return a GitHub username, projectname and
  (optionally) the number of entries to format.

  Return a tuple of `{ user, project, count }`, or
  the atom `:help` if help was requested.
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv,
      switches: [help: :boolean],
      aliases: [h: :help])

    case parse do
      { [ help: true ], _, _ }
        -> :help

      { _, [user, project, count], _ }
        -> { user, project, String.to_integer(count) }

      { _, [user, project], _ }
        -> { user, project, @default_count }

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """

    System.halt(0)
  end

  def process({user, project, _count}) do
    Issues.GitHubIssues.fetch(user, project)
    |> decode_response
    |> sort_into_ascending_order
    |> Enum.take(4)
    |> format_into_columns
  end

  def decode_response({ :ok, body }), do: body

  def decode_response({ :error, body }) do
    { _, message } = List.keyfind(body, "message", 0)
    IO.puts "Error fetching from GitHub: #{message}"

    System.halt(2)
  end

  def sort_into_ascending_order(issues) do
    Enum.sort(issues, fn (a, b) ->
      Map.get(a, "created_at") <= Map.get(b, "created_at")
    end)
  end

  def format_into_columns(issues) do
    Issues.TableFormatter.print_table(issues, ["id", "created_at", "title"])
  end
end
