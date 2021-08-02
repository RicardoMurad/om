defmodule Om.Store.Order do
  use Ecto.Schema
  import Ecto.Changeset

  alias Om.Store.Payment

  @min_amount 0
  @max_amount 10_000_000

  @min_description 5
  @max_description 100

  @fields [:description, :total, :balance_due]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :description, :string
    field :balance_due, :integer
    field :total, :integer

    has_many :payments, Payment

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_number(:total,
      greater_than: @min_amount,
      less_than_or_equal_to: @max_amount
    )
    |> validate_number(:balance_due,
      greater_than: @min_amount,
      less_than_or_equal_to: @max_amount
    )
    |> validate_length(:description,
      min: @min_description,
      max: @max_description
    )
  end
end
