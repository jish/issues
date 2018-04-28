# Issues

Fetch a list of Issues from a GitHub project.
Pass in the username and the project name and the issues will be printed to the
screen.

## Running

To look up issues for a specifig project run:

    $ mix run -e 'Issues.Cli.run(["elixir-lang", "elixir"])'

     id        | created_at           | title
    -----------+----------------------+-------------------------------------------------------------------------------------
     264042653 | 2017-10-09T22:18:14Z | ExUnit diff of two lists is confusing when head is missing
     267255992 | 2017-10-20T17:57:30Z | Revisit strictness of Access module #6515
     270597969 | 2017-11-02T10:12:37Z | Mix.Config needs a function for importing configs reliably in umbrella applications
     275203044 | 2017-11-19T23:25:35Z | Consider requiring all calls to logger to pass a function
