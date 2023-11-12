defmodule PayoutElixirWebApp.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :amount, :decimal
      add :description, :string, size: 40
      add :method, :string
      add :ispayed, :boolean, default: false

      timestamps(type: :utc_datetime)
    end
  end
end
