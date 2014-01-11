defmodule Tcprc.Server do
  use GenServer.Behaviour

  @doc "Starts the server"
  def start_link() do
    # Delegate to gen_server passing in current module
    # ARG will be passed to init
    :gen_server.start_link({ :local, :NAME }, __MODULE__, ARG, [])
  end

  @doc "Stops the server"
  def stop() do
    :gen_server.cast(:NAME, :stop)
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
  

end