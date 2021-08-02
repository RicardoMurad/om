defmodule Om.Repo do
  use Ecto.Repo,
    otp_app: :om,
    adapter: Ecto.Adapters.Postgres
end
