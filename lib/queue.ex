defmodule Queue do
  @fields ~w(list size name)a
  @enforce_keys ~w(name)a
  defstruct @fields

  def new(name, list \\ [])

  def new(name, []) do
    struct!(__MODULE__, name: name, list: [], size: 0)
  end

  def new(name, list) do
    struct!(__MODULE__, name: name, list: list, size: length(list))
  end

  def enqueue(%Queue{} = q, elems) when is_list(elems) do
    List.foldl(elems, q, &enq/2)
  end

  def enqueue(%Queue{} = q, elem) do
    enq(elem, q)
  end

  defp enq(elem, %Queue{list: xs, size: x} = q) do
    %{q | list: List.insert_at(xs, -1, elem), size: x + 1}
  end

  def dequeue(%Queue{} = q, n) do
    {elems, q} =
      Enum.reduce(1..n, {[], q}, fn
        _, {elems, state} ->
          {elem, state} = deq(state)
          {[elem | elems], state}
      end)

    {Enum.reverse(elems), q}
  end

  def dequeue(%Queue{} = q) do
    deq(q)
  end

  defp deq(%Queue{list: []} = q) do
    {nil, q}
  end

  defp deq(%Queue{list: xs, size: x} = q) do
    {hd(xs), %{q | list: tl(xs), size: x - 1}}
  end

  def size(%Queue{} = q) do
    q.size
  end

  def front(%Queue{} = q) do
    List.first(q.list)
  end

  def rear(%Queue{} = q) do
    List.last(q.list)
  end

  def flush(%Queue{} = q) do
    {q.list, new(q.name)}
  end

  def inspect(%Queue{} = q) do
    q.list
  end
end
