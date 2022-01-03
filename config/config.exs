import Config

config :todo, :database, pool_size: 3, folder: "./persist"
config :todo, :cache, pool_size: 3
config :todo, port: 5454
config :todo, todo_item_expiry: :timer.minutes(1)

config :datapio_cluster,
  service_name: [env: "TODO_SERVICE_NAME", default: nil],
  app_name: [env: "TODO_APP_NAME", default: "todo"],
  cache_tables: [
    some_set: [:id, :attr1, :attr2],
    some_other_set: [:id, :attr]
  ]

import_config "#{config_env()}.exs"
