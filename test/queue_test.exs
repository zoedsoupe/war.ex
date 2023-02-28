defmodule QueueTest do
  use ExUnit.Case

  describe "enqueue/2" do
    test "enqueue only 1 elem" do
      assert {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, 1)
      assert :ok = Queue.enqueue(pid, 2)
      assert :ok = Queue.enqueue(pid, 3)
      assert Queue.size(pid) == 3

      assert Queue.dequeue(pid) == 1
      assert Queue.dequeue(pid) == 2
      assert Queue.dequeue(pid) == 3
      assert Queue.size(pid) == 0
    end

    test "enqueue many elements" do
      assert {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, [1, 2, 3])
      assert Queue.size(pid) == 3

      assert Queue.dequeue(pid) == 1
      assert Queue.dequeue(pid) == 2
      assert Queue.dequeue(pid) == 3
      assert Queue.size(pid) == 0
    end

    test "enqueue returns correct order" do
      assert {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, [1])
      assert Queue.size(pid) == 1

      assert :ok = Queue.enqueue(pid, [2])
      assert Queue.size(pid) == 2

      assert :ok = Queue.enqueue(pid, [3])
      assert Queue.size(pid) == 3
      assert [1, 2, 3] = Queue.dequeue(pid, 3)
      assert Queue.size(pid) == 0

      assert :ok = Queue.enqueue(pid, [1])
      assert Queue.size(pid) == 1
      assert :ok = Queue.enqueue(pid, [2, 3])
      assert Queue.size(pid) == 3
      assert [1, 2, 3] = Queue.dequeue(pid, 3)
      assert Queue.size(pid) == 0
    end
  end

  test "dequeue/1" do
    assert {:ok, pid} = Queue.start_link()

    assert :ok = Queue.enqueue(pid, [1, 2, 3])

    assert 1 = Queue.dequeue(pid)
    assert 2 = Queue.dequeue(pid)
    assert 3 = Queue.dequeue(pid)
    refute Queue.dequeue(pid)
  end

  test "dequeue/2" do
    assert {:ok, pid} = Queue.start_link()

    assert :ok = Queue.enqueue(pid, [1, 2, 3])

    assert [1, 2, 3] = Queue.dequeue(pid, 3)
  end

  describe "size/1" do
    test "when empty" do
      assert {:ok, pid} = Queue.start_link()
      assert Queue.size(pid) == 0
    end

    test "when has one elem" do
      assert {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, 1)
      assert Queue.size(pid) == 1
    end

    test "when has many elems" do
      assert {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, [1, 2, 3])
      assert Queue.size(pid) == 3
    end
  end

  describe "front/1" do
    test "when empty" do
      assert {:ok, pid} = Queue.start_link()

      assert Queue.size(pid) == 0
      refute Queue.front(pid)
    end

    test "when has elems" do
      assert {:ok, pid} = Queue.start_link()

      assert :ok = Queue.enqueue(pid, [1, 2])

      assert Queue.size(pid) == 2
      assert Queue.front(pid) == 1
      assert Queue.size(pid) == 2
    end
  end
end
