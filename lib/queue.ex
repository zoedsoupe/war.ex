defmodule Queue do
  use GenServer

  @intial_state %{
    size: 0,
    queue: []
  }

  # Client - Public and high level API

  def start_link do
    GenServer.start_link(__MODULE__, @intial_state)
  end

  def enqueue(pid, elems) do
    GenServer.cast(pid, {:enqueue, elems})
  end

  def dequeue(pid) do
    GenServer.call(pid, :dequeue)
  end

  def dequeue(pid, many) do
    GenServer.call(pid, {:dequeue, many})
  end

  def size(pid) do
    GenServer.call(pid, :size)
  end

  def front(pid) do
    GenServer.call(pid, :front)
  end

  def rear(pid) do
    GenServer.call(pid, :rear)
  end

  def flush(pid) do
    GenServer.call(pid, :flush)
  end

  # Server - Public but internal API
  # handle_cast - handle the demand asynchronously
  # handle_call - handle the demand eagerly

  @impl true
  def init(init) do
    {:ok, init}
  end

  @impl true
  def handle_call(:size, _from, state) do
    {:reply, state.size, state}
  end

  def handle_call(:front, _from, state) do
    %{queue: xs} = state

    case xs do
      [] -> {:reply, nil, state}
      [x | _] -> {:reply, x, state}
    end
  end

  def handle_call(:rear, _from, state) do
    %{queue: xs} = state

    case xs do
      [] -> {:reply, nil, state}
      xs -> {:reply, List.last(xs), state}
    end
  end

  def handle_call(:flush, _from, state) do
    {elems, state} = deq_many(state, state.size)

    {:reply, elems, state}
  end

  def handle_call(:dequeue, _from, state) do
    {elem, state} = deq(state)

    {:reply, elem, state}
  end

  def handle_call({:dequeue, many}, _from, state) do
    {elems, state} = deq_many(state, many)

    {:reply, Enum.reverse(elems), state}
  end

  defp deq_many(state, n) do
    Enum.reduce(1..n, {[], state}, fn
      _, {elems, state} ->
        {elem, state} = deq(state)

        {[elem | elems], state}
    end)
  end

  defp deq(state) do
    %{queue: xs, size: size} = state

    case xs do
      [] -> {nil, state}
      [x | xs] -> {x, %{state | queue: xs, size: size - 1}}
    end
  end

  @impl true
  def handle_cast({:enqueue, elems}, state) when is_list(elems) do
    %{queue: xs, size: x} = state

    xs = List.foldr(elems, xs, &[&1 | &2])

    {:noreply, %{state | size: x + length(elems), queue: xs}}
  end

  def handle_cast({:enqueue, elem}, state) do
    %{queue: xs, size: x} = state

    {:noreply, %{state | size: x + 1, queue: Enum.reverse([elem | xs])}}
  end
end
