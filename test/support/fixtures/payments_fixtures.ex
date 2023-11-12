defmodule PayoutElixirWebApp.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PayoutElixirWebApp.Payments` context.
  """

  @doc """
  Generate a payment.
  """
  def payment_fixture(attrs \\ %{}) do
    {:ok, payment} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        description: "some description",
        method: "some method"
      })
      |> PayoutElixirWebApp.Payments.create_payment()

    payment
  end
end
