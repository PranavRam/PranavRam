import Config

config :tableau, :config, url: "https://pranavram.github.io/PranavRam"
config :tableau, :config, base_path: "/PranavRam"
config :tableau, Tableau.PostExtension, future: false, dir: ["_posts"]
config :tableau, Tableau.PageExtension, dir: ["_pages"]
