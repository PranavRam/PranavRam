defmodule PrWebsite.MixProject do
  use Mix.Project

  def project do
    [
      app: :pr_website,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      compilers: Mix.compilers(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
  [
  {:tableau, "~> 0.26"},
  {:mdex_mermaid, "~> 0.1"},
      {:yaml_elixir, "~> 2.9"}

  # {:dep_from_hexpm, "~> 0.3.0"},
    # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  ]
end

  defp aliases do
  [
  build: ["pr_website.gen.tags", "tableau.build"],
  "tableau.build": ["pr_website.gen.tags", "tableau.build"],
  post: ["pr_website.gen.post"],
    tags: ["pr_website.gen.tags"]
  ]
end
end
