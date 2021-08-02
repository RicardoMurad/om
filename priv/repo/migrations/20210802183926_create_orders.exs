defmodule Om.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string, size: 100, null: false
      add :total, :integer, null: false
      add :balance_due, :integer, null: false

      timestamps()
    end
  end
end
