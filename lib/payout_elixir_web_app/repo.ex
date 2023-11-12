defmodule PayoutElixirWebApp.Repo do
  use Ecto.Repo,
    otp_app: :payout_elixir_web_app,
    adapter: Ecto.Adapters.Postgres
end
