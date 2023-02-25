defmodule War.MixProject do
  use Mix.Project

  def project do
    [
      app: :war,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end
end
