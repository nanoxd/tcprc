defmodule Tcprc.Server do
  use GenServer.Behaviour

  defrecord State, port: nil, lsock: nil, request_count: 0

  @doc "Starts the server"
  def start_link(port) do
    # Delegate to gen_server passing in current module
    # ARG will be passed to init
    :gen_server.start_link({ :local, :tcprc }, __MODULE__, port, [])
  end

  def start_link() do
    start_link 1055
  end

  @doc "Return number of messages responded to"
  def get_count() do
    :gen_server.call(:tcprc, :get_count)
  end

  @doc "Stops the server"
  def stop() do
    :gen_server.cast(:tcprc, :stop)
  end

  @doc "Initialize our server"
  def init(port) do
    { :ok, lsock } = :gen_tcp.listen(port, [{ :active, true }])
    { :ok, State.new(lsock: lsock, port: port), 0 }
  end

  @doc "Implement multiple times with a different pattern with sync messages"
  def handle_call(:get_count, _from, state) do
    { :reply, { :ok, state.request_count }, state }
  end

  @doc "Handle the server stop message"
  def handle_cast(:stop, state) do
    { :noreply, state }
  end

  @doc "Implement this to handle out of band messages"
  def handle_info({ :tcp, socket, raw_data }, state) do
    do_rpc socket, raw_data
    { :noreply, state.update_request_count(fn(x) -> x + 1 end) }
  end

  def handle_info(:timeout, state = State[lsock: lsock]) do
    { :ok, _sock } = :gen_tcp.accept lsock
    { :noreply, state }
  end

  def do_rpc(socket, raw_data) do
    try do
      result = Code.eval_string(raw_data)
      :gen_tcp.send(socket, :io_lib.fwrite("~p~n", [result]))
    catch
      error -> :gen_tcp.send(socket, :io_lib.fwrite("~p~n", [error]))
    end
  end

end
