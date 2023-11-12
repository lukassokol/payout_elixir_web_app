defmodule PayoutElixirWebAppWeb.PaymentLive.Show do
  use PayoutElixirWebAppWeb, :live_view
  alias PayoutElixirWebApp.Payments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  @spec handle_params(map(), any(), %{
          :assigns => atom() | %{:live_action => :edit | :show, optional(any()) => any()},
          optional(any()) => any()
        }) :: {:noreply, map()}
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:payment, Payments.get_payment!(id))}
  end

  #defp apply_action(socket, :pay, %{"id" => id}) do

  #end

  defp page_title(:show), do: "Show Payment"
  defp page_title(:edit), do: "Edit Payment"

  @impl true
  def handle_event("pay", %{"id" => id}, socket) do
    Payments.do_payment(id)
    {:noreply, socket}
  end
end
