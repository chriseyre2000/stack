defmodule Stack.Server do
  @moduledoc """
  This is the solution to OTP-Servers-1 from Programming Elixir 1.3

  iex -S mix

  iex(1)> {:ok, pid} = GenServer.start_link Stack.Server, [5, "cat", 9]
  {:ok, #PID<0.119.0>}
  iex(2)> GenServer.call pid, :pop
  5
  iex(3)> GenServer.call pid, :pop
  "cat"
  iex(4)> GenServer.call pid, :pop
  9

"""
  use GenServer

# External API
  def start_link(stash_pid) do
    GenServer.start_link __MODULE__, stash_pid, name: __MODULE__
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(item) do
    GenServer.cast __MODULE__, {:push, item}
  end

  # Internal details
  def init(stash_pid) do
    current_list = Stack.Stash.get_value stash_pid
    {:ok, {current_list, stash_pid}}
  end

  def handle_call(:pop, _from, {stack, stash_pid}) do
    [head | tail] = stack
    {:reply, head, {tail, stash_pid}}
  end

  def handle_cast({:push, item}, {stack, stash_pid}) do
    {:noreply, {[item | stack], stash_pid}}
  end

  def terminate(reason, {stack, stash_pid}) do
    IO.puts "Reason #{inspect reason} State #{inspect stack}"
    Stack.Stash.save_value stash_pid, stack
  end

end