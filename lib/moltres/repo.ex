defmodule Moltres.Repo do
  use Ecto.Repo,
    otp_app: :moltres,
    adapter: Ecto.Adapters.Postgres
end
