defmodule Om.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :integer
      add :applied_at, :naive_datetime
      add :note, :string

      add :payment_id, references(:payments, type: :uuid), null: false

      timestamps()
    end
  end
end
