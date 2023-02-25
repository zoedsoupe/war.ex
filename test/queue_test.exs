defmodule QueueTest do
  use ExUnit.Case

  describe "enqueue/2" do
    test "enqueue only 1 elem" do
      {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, 1)
      assert :ok = Queue.enqueue(pid, 2)
      assert :ok = Queue.enqueue(pid, 3)
    end

    test "enqueue many elements" do
      {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, [1, 2, 3])
    end
  end

  test "dequeue/1" do
    {:ok, pid} = Queue.start_link()

    assert :ok = Queue.enqueue(pid, [1, 2, 3])
    assert Queue.dequeue(pid) == 1
    assert Queue.dequeue(pid) == 2
    assert Queue.dequeue(pid) == 3
  end

  test "dequeue/2" do
    {:ok, pid} = Queue.start_link()

    assert :ok = Queue.enqueue(pid, [1, 2, 3])
    assert Queue.dequeue(pid, 3) == [1, 2, 3]
  end

  describe "size/1" do
    test "when empty" do
      {:ok, pid} = Queue.start_link()

      assert Queue.size(pid) == 0
    end

    test "when has one elem" do
      {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, 1)
      assert Queue.size(pid) == 1
    end

    test "when has many elems" do
      {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, [1, 2, 3])
      assert Queue.size(pid) == 3
    end
  end

  describe "front/1" do
    test "when empty" do
      {:ok, pid} = Queue.start_link()

      assert Queue.size(pid) == 0
      refute Queue.front(pid)
    end

    test "when has elems" do
      {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, [1, 2])
      assert Queue.size(pid) == 2
      assert Queue.front(pid) == 1
      assert Queue.size(pid) == 2
    end
  end

  test "flush/1" do
    {:ok, pid} = Queue.start_link()

    assert :ok = Queue.enqueue(pid, [1, 2, 3])
    assert Queue.size(pid) == 3
    assert Queue.flush(pid) == [3, 2, 1]
    assert Queue.size(pid) == 0
  end
end
