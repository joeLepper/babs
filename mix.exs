defmodule BarbaraBennettBot.Mixfile do
  use Mix.Project

  def project, do: [
    app: :barbara_bennett_bot,
    version: "0.1.0",
    elixir: "~> 1.4",
    build_embedded: Mix.env == :prod,
    start_permanent: Mix.env == :prod,
    deps: deps()
  ]

  def application, do: [
    extra_applications: [:logger],
  ]

  defp deps, do: [
      {:cowboy, "~> 1.0.0"},
      {:faust, "~> 0.1.0"},
      {:floki, "~> 0.17.0"},
      {:httpoison, "~> 0.11.1"},
      {:plug, "~> 1.0"},
    ]
end
