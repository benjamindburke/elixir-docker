defmodule Todo.MixProject do
  use Mix.Project

  def project do
    [
      app: :todo,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [release: :prod]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :runtime_tools,
        :datapio_cluster
      ],
      mod: {Todo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poolboy, "~> 1.5"},
      {:plug_cowboy, "~> 2.5"},
      {:plug, "~> 1.12"},
      {:distillery, "~> 2.1"},
      {:libcluster, "~> 3.2"},
      {
        :datapio_cluster,
        github: "datapio/opencore",
        ref: "main",
        sparse: "apps/datapio_cluster"
      }
    ]
  end
end
