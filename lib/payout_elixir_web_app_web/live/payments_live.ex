defmodule PayoutElixirWebAppWeb.PaymentsLive do
  use PayoutElixirWebAppWeb, :live_view

  def mount(_params, _session, socket) do
     socket = assign(socket, number: 3)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Payments</h1>
    <span>
      <%= @number%>
    </span>
    <button phx-click="increment">+</button>
    """
  end

  def handle_event("increment", _, socket) do
    #number = socket.assigns.number + 1
    #assign(socket, number: number)
    socket = update(socket, :number, &(&1 + 1))
    {:noreply, socket}
  end
end
