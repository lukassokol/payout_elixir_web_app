defmodule PayoutElixirWebAppWeb.Router do
  use PayoutElixirWebAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PayoutElixirWebAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PayoutElixirWebAppWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/payments", PaymentLive.Index, :index
    live "/payments/new", PaymentLive.Index, :new
    live "/payments/:id/edit", PaymentLive.Index, :edit

    live "/payments/:id", PaymentLive.Show, :show
    live "/payments/:id/show/edit", PaymentLive.Show, :edit
    live "/payments/:id/show/pay", PaymentLive.Show, :pay
  end

  # Other scopes may use custom stacks.
  # scope "/api", PayoutElixirWebAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:payout_elixir_web_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PayoutElixirWebAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
