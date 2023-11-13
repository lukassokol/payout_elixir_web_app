defmodule PayoutElixirWebApp.Repo.Migrations.FixNaming do
  use Ecto.Migration

  def change do
    rename table(:payments), :ispayed, to: :ispaid
  end
end
