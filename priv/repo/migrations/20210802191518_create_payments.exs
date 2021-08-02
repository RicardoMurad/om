defmodule Om.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :amount, :integer
      add :note, :string

      add :order_id, references(:orders, type: :uuid), null: false

      timestamps()
    end
  end
end
