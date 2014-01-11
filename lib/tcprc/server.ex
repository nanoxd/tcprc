defmodule Tcprc.Server do
  use GenServer.Behaviour

  defrecord State, port: nil, lsock: nil, request_count: 0

  @doc "Starts the server"
  def start_link(port) do
    # Delegate to gen_server passing in current module
    # ARG will be passed to init
    :gen_server.start_link({ :local, :tcprc }, __MODULE__, port, ARG, [])
  end

  def start_link() do
    start_link 1055
  end

  @doc "Stops the server"
  def stop() do
    :gen_server.cast(:tcprc, :stop)
  end

  @doc "Initialize our server"
  def init(ARG) do
  end

  @doc "Implement multiple times with a different pattern with sync messages"
  def handle_call(:message, from, state) do
  end

  @doc "Implement multiple times with a different pattern with async messages"
  def handle_cast(:message, state) do
  end

  @doc "Handle the server stop message"
  def handle_cast(:stop, state) do
    { :noreply, state }
  end

  @doc "Implement this to handle out of band messages"
  def handle_info(:message, state) do
  end

  @doc "Return number of messages responded to"
  def get_count() do
    :gen_server.call(:tcprc, :get_count)
  end

end
