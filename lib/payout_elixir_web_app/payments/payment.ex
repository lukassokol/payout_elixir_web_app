defmodule PayoutElixirWebApp.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payments" do
    field :description, :string
    field :amount, :decimal
    field :method, :string
    field :ispaid, :boolean

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :description, :method])
    |> validate_required([:amount, :description, :method])
  end
end
