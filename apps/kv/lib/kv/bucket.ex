defmodule KV.Bucket do
  use Agent, restart: :temporary

  @doc """
      Crear estado inicial del agente, un mapa vacío
  """
  def start_link(_) do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
      Actualizar estado inicial del agente
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
      Actualizar estado anterior del agente
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  def delete(bucket, key) do
    Agent.get_and_update(bucket, fn dict ->
      Map.pop(dict, key)
    end)
  end

  def delete_client_server(bucket, key) do
    # puts client to sleep
    Process.sleep(1000)

    Agent.get_and_update(bucket, fn dict ->
      # puts server to sleep
      Process.sleep(1000)
      Map.pop(dict, key)
    end)
  end
end
