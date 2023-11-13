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

  defp page_title(:show), do: "Show Payment"
  defp page_title(:edit), do: "Edit Payment"

  @impl true
  def handle_event("pay", %{"id" => id}, socket) do
    Payments.do_payment(id)
    {:noreply, socket |> put_flash(:info, "Payment updated successfully")}
  end

  @impl true
  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <.header>
      <b>Invoice <%= @payment.id %></b>
      <:subtitle>This is a invoice record from your database.</:subtitle>
      <:actions>
        <.link patch={~p"/payments/#{@payment}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit invoice</.button>
        </.link>

        <.link
          :if={!@payment.ispayed}
          phx-click={JS.push("pay", value: %{id: @payment.id})}
          data-confirm={"You will pay #{@payment.amount}€"}>
          <.button>Pay payment</.button>
        </.link>
      </:actions>

    </.header>

    <.list>
      <:item title="Amount"><%= @payment.amount %></:item>
      <:item title="Description"><%= @payment.description %></:item>
      <:item title="Method"><%= @payment.method %></:item>
      <:item title="Payed"><%= @payment.ispayed %></:item>
    </.list>

    <.back navigate={~p"/payments"}>Back to invoices</.back>

    <.modal :if={@live_action == :edit} id="payment-modal" show on_cancel={JS.patch(~p"/payments/#{@payment}")}>
      <.live_component
        module={PayoutElixirWebAppWeb.PaymentLive.FormComponent}
        id={@payment.id}
        title={@page_title}
        action={@live_action}
        payment={@payment}
        patch={~p"/payments/#{@payment}"}
      />
    </.modal>
    """
  end
end
