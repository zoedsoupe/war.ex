defmodule Queue do
  use GenServer

  @init %{
    list: [],
    size: 0
  }

  # Client - Public API

  def start_link do
    GenServer.start_link(__MODULE__, @init)
  end

  def init(init) do
    {:ok, init}
  end

  def enqueue(pid, elem) do
    GenServer.cast(pid, {:enqueue, elem})
  end

  def dequeue(pid) do
    GenServer.call(pid, :dequeue)
  end

  def dequeue(pid, n) do
    GenServer.call(pid, {:dequeue, n})
  end

  def front(pid) do
    GenServer.call(pid, :front)
  end

  def size(pid) do
    GenServer.call(pid, :size)
  end

  # Server

  def handle_call(:front, _from, state) do
    {:reply, List.first(state.list), state}
  end

  def handle_call(:size, _from, state) do
    {:reply, state.size, state}
  end

  def handle_call(:dequeue, _from, state) do
    {x, state} = deq(state)
    {:reply, x, state}
  end

  def handle_call({:dequeue, n}, _from, state) do
    {elems, state} =
      Enum.reduce(1..n, {[], state}, fn
        _, {elems, q} ->
          {elem, q} = deq(q)
          {[elem | elems], q}
      end)

    {:reply, Enum.reverse(elems), state}
  end

  defp deq(%{list: []} = q) do
    {nil, q}
  end

  defp deq(%{list: xs, size: x} = q) do
    {hd(xs), %{q | list: tl(xs), size: x - 1}}
  end

  def handle_cast({:enqueue, elems}, state) when is_list(elems) do
    {:noreply, List.foldl(elems, state, &enq/2)}
  end

  def handle_cast({:enqueue, elem}, state) do
    {:noreply, enq(elem, state)}
  end

  defp enq(elem, %{list: xs, size: x} = q) do
    %{q | list: List.insert_at(xs, -1, elem), size: x + 1}
  end
end
