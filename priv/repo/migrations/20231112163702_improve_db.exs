defmodule PayoutElixirWebApp.Repo.Migrations.ImproveDb do
  use Ecto.Migration

  def change do
    alter table(:payments) do
      modify :description, :string, size: 40, default: "Nothing"
      modify :ispayed, :boolean, default: false
    end
  end
end
