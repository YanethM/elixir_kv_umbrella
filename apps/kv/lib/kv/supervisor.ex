defmodule KV.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      # {KV.Registry, name: KV.Registry},
      # Supervisior tree
      # {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one}

      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one},
      {KV.Registry, name: KV.Registry}
    ]

    #Supervisor.init(children, strategy: :one_for_one)
    #el supervisor matará y reiniciará todos sus procesos secundarios cada vez que uno de ellos muera
    Supervisor.init(children, strategy: :one_for_all)

  end
end

# Testing commands (Not require test file)
# Iniciar el supervisor y enumerado sus hijos. Una vez que el supervisor comenzó, también comenzó a todos sus hijos.
# iex> KV.Registry.child_spec([])
# iex> {:ok, sup} = KV.Supervisor.start_link([])
# iex> Supervisor.which_children(sup)

# testing a bad input on call
# iex> [{_, registry, _, _}] = Supervisor.which_children(sup)
# iex> GenServer.call(registry, :bad_input)
# iex> Supervisor.which_children(sup)

# iex> i(KV.Registry)

# Later of adding the new children DynamicSupervisor
# iex> {:ok, bucket} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
# iex> KV.Bucket.put(bucket, "eggs", 3)
# iex> KV.Bucket.get(bucket, "eggs")
