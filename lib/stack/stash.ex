defmodule Stack.Stash do
  use GenServer

  def start_link(current_list) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, current_list)
  end

  def save_value(pid, new_list) do
    GenServer.cast pid, {:set_value, new_list}
  end

  def get_value(pid) do
    GenServer.call pid,  :get_value
  end

  def handle_call(:get_value, _from, current_list) do
     {:reply, current_list, current_list}
  end

  def handle_cast({:set_value, replacement_list}, _current_value) do
     {:noreply, replacement_list}
  end
  
end