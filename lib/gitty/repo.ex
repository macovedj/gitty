defmodule Gitty.Repo do
  use Ecto.Repo,
    otp_app: :gitty,
    adapter: Ecto.Adapters.Postgres
end
