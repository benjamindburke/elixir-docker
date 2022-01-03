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
      Todo.System
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
