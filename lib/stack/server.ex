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
  def start_link(state) do
    GenServer.start_link __MODULE__, state, name: __MODULE__
  end

  def pop do
    GenServer.call __MODULE__, :pop
  end

  def push(item) do
    GenServer.cast __MODULE__, {:push, item}
  end

# Implementation
  def handle_call(:pop, _from, stack) do
    [head | tail] = stack
    {:reply, head, tail}
  end

  def handle_cast({:push, item}, stack) do
    {:noreply, [item | stack]}
  end

  def terminate(reason, state) do
    IO.puts "Reason #{inspect reason} State #{inspect state}"
    {:bye}
  end

end