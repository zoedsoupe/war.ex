defmodule QueueTest do
  use ExUnit.Case

  describe "enqueue/2" do
    test "enqueue only 1 elem" do
      assert %Queue{} = q = Queue.new()

      q = Queue.enqueue(q, 1)
      q = Queue.enqueue(q, 2)
      q = Queue.enqueue(q, 3)

      assert Queue.size(q) == 3
      assert Queue.inspect(q) == [1, 2, 3]
    end

    test "enqueue many elements" do
      assert %Queue{} = q = Queue.new()

      q = Queue.enqueue(q, [1, 2, 3])

      assert Queue.size(q) == 3
      assert Queue.inspect(q) == [1, 2, 3]
    end

    test "enqueue returns correct order" do
      assert %Queue{} = q = Queue.new()

      assert q = Queue.enqueue(q, [1])
      assert Queue.size(q) == 1

      assert q = Queue.enqueue(q, [2])
      assert Queue.size(q) == 2

      assert q = Queue.enqueue(q, [3])
      assert Queue.size(q) == 3
      assert {[1, 2, 3], q} = Queue.flush(q)
      assert Queue.size(q) == 0

      assert q = Queue.enqueue(q, [1])
      assert Queue.size(q) == 1
      assert q = Queue.enqueue(q, [2, 3])
      assert Queue.size(q) == 3
      assert {[1, 2, 3], q} = Queue.flush(q)
      assert Queue.size(q) == 0
    end
  end

  test "dequeue/1" do
    assert %Queue{} = q = Queue.new()

    q = Queue.enqueue(q, [1, 2, 3])

    assert {1, q} = Queue.dequeue(q)
    assert {2, q} = Queue.dequeue(q)
    assert {3, q} = Queue.dequeue(q)
    assert {nil, _q} = Queue.dequeue(q)
  end

  test "dequeue/2" do
    assert %Queue{} = q = Queue.new()

    q = Queue.enqueue(q, [1, 2, 3])

    assert {[1, 2, 3], _} = Queue.dequeue(q, 3)
  end

  describe "size/1" do
    test "when empty" do
      assert %Queue{} = q = Queue.new()
      assert Queue.size(q) == 0
    end

    test "when has one elem" do
      assert %Queue{} = q = Queue.new()

      q = Queue.enqueue(q, 1)

      assert Queue.size(q) == 1
    end

    test "when has many elems" do
      assert %Queue{} = q = Queue.new()

      q = Queue.enqueue(q, [1, 2, 3])

      assert Queue.size(q) == 3
    end
  end

  describe "front/1" do
    test "when empty" do
      assert %Queue{} = q = Queue.new()

      assert Queue.size(q) == 0
      refute Queue.front(q)
    end

    test "when has elems" do
      assert %Queue{} = q = Queue.new()

      q = Queue.enqueue(q, [1, 2])

      assert Queue.size(q) == 2
      assert Queue.front(q) == 1
      assert Queue.size(q) == 2
    end
  end

  test "flush/1" do
    assert %Queue{} = q = Queue.new()

    q = Queue.enqueue(q, [1, 2, 3])

    assert Queue.size(q) == 3
    assert {[1, 2, 3], q} = Queue.flush(q)
    assert Queue.size(q) == 0
  end
end
