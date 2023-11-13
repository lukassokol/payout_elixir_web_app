defmodule PayoutElixirWebAppWeb.PaymentLive.Index do
  use PayoutElixirWebAppWeb, :live_view

  alias PayoutElixirWebApp.Payments
  alias PayoutElixirWebApp.Payments.Payment

  @impl true
  def mount(_params, _session, socket) do
    payments = Payments.list_payments()
    {:ok, stream(socket, :payments, payments, reset: true) }
  end

  @impl true
  @spec handle_params(any(), any(), %{
          :assigns => atom() | %{:live_action => :edit | :index | :new, optional(any()) => any()},
          optional(any()) => any()
        }) :: {:noreply, map()}
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Payment")
    |> assign(:payment, Payments.get_payment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Payment")
    |> assign(:payment, %Payment{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Payments")
    |> assign(:payment, nil)
  end

  @impl true
  def handle_info({PayoutElixirWebAppWeb.PaymentLive.FormComponent, {:saved, payment}}, socket) do
    {:noreply, stream_insert(socket, :payments, payment)}
  end

  @impl true
  @spec handle_event(<<_::48>>, map(), Phoenix.LiveView.Socket.t()) :: {:noreply, map()}
  def handle_event("delete", %{"id" => id}, socket) do
    payment = Payments.get_payment!(id)
    {:ok, _} = Payments.delete_payment(payment)

    {:noreply, stream_delete(socket, :payments, payment)}
  end

  @impl true
  def handle_event("show_payed", _params, socket) do
    {:noreply, stream(socket, :payments, Payments.list_payed_payments(), reset: true)}
  end

  @impl true
  def handle_event("show_unpayed", _params, socket) do
    {:noreply, stream(socket, :payments, Payments.list_unpayed_payments(), reset: true)}
  end

  @impl true
  def handle_event("show_all", _params, socket) do
    {:noreply, stream(socket, :payments, Payments.list_payments(), reset: true)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      <b>Payments</b>
      <:actions>
        <.link
          phx-click={JS.push("show_all")}>
          <.button>Show all</.button>
        </.link>

        <.link
          phx-click={JS.push("show_payed")}>
          <.button >Show payed</.button>
        </.link>

        <.link
          phx-click={JS.push("show_unpayed")}>
          <.button >Show unpayed</.button>
        </.link>

        <.link patch={~p"/payments/new"}>
          <.button>New Payment</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="payments"
      rows={@streams.payments}
      row_click={fn {_id, payment} -> JS.navigate(~p"/payments/#{payment}") end}
    >

      <:col :let={{_id, payment}} label="Amount"><%= payment.amount %></:col>
      <:col :let={{_id, payment}} label="Description"><%= payment.description %></:col>
      <:col :let={{_id, payment}} label="Method"><%= payment.method %></:col>
      <:col :let={{_id, payment}} label="Payed"><%= payment.ispayed %></:col>

      <:action :let={{_id, payment}}>
        <div class="sr-only">
          <.link navigate={~p"/payments/#{payment}"}>Show</.link>
        </div>
        <.link patch={~p"/payments/#{payment}/edit"} >Edit</.link>
      </:action>
      <:action :let={{id, payment}}>
        <.link
          phx-click={JS.push("delete", value: %{id: payment.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
          style="color: red"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal :if={@live_action in [:new, :edit]} id="payment-modal" show on_cancel={JS.patch(~p"/payments")}>
      <.live_component
        module={PayoutElixirWebAppWeb.PaymentLive.FormComponent}
        id={@payment.id || :new}
        title={@page_title}
        action={@live_action}
        payment={@payment}
        patch={~p"/payments"}
      />
    </.modal>
    """
  end
end
