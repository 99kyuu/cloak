defmodule Cloak.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :cloak,
      version:         _version(),
      elixir:          "~> 1.10",
      build_embedded:  false,
      start_permanent: Mix.env == :prod,
      elixirc_paths:   _elixirc_paths(Mix.env),
      aliases:         _aliases(),
      deps:            _deps(),
      description:     "Shadowsocks Server",
      releases: [
        cloak: [ cookie: "CHANGEME" ]
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      extra_applications: [:logger],
      mod: {Cloak.Application, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp _deps do
    [
      { :salty,             "~> 0.1.3", hex: :libsalty },
      { :hkdf,              "~> 0.1"    },
      { :jason,             "~> 1.1"    },
      { :confex,            "~> 3.4"    },
      { :yaml_elixir,       "~> 2.0"    },
      { :ranch,             "~> 2.0"    },
      { :gen_state_machine, "~> 2.0"    },
      { :tortoise,          "~> 0.9"    },
      { :observer_cli, "~> 1.5",        only: [:dev]  },
      { :dialyxir,     "~> 1.0.0-rc.6", only: [:dev], runtime: false }
    ]
  end

  defp _aliases do
    [
      release: "release --overwrite",
      test: "test --no-start"
    ]
  end

  defp _elixirc_paths(:test), do: ["lib", "test/support"]
  defp _elixirc_paths(_), do: ["lib", "web"]

  defp _version() do
    String.trim( File.read!("VERSION") ) <> "+" <> _git_sha()
  end

  defp _git_sha() do
    {result, _exit_code} = System.cmd("git", ["rev-parse", "HEAD"])
    String.slice(result, 0, 5)
  end
end
