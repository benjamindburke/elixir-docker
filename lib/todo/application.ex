# Todo Application [kernel, supervisor]
# This module initializes and supervises all Todo services on behalf of its clients
defmodule Todo.Application do
  use Application

  def start(_, _) do
    topologies = [
      default: [
        strategy: Cluster.Strategy.Kubernetes.DNS,
        config: [
          service: "todo-app-svc-headless",
          application_name: "todo"
        ]
      ]
    ]
    children = [
      {Cluster.Supervisor, [topologies, [name: Todo.ClusterSupervisor]]},
      Todo.Metrics,
      Todo.Database,
      Todo.Cache,
      Todo.WebCache,
      Todo.Web
    ]
    Supervisor.start_link(children, strategy: :one_for_one, name: Todo.System)
  end
end
