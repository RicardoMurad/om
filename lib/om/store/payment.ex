defmodule Om.Store.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  alias On.Store.Order

  @required_fields [:amount, :applied_at]
  @fields @required_fields ++ [:note]

  @max_note_size 100

  @min_amount 0
  @max_amount 10_000_000

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "payments" do
    field :amount, :integer
    field :applied_at, :naive_datetime
    field :note, :string, default: ""

    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
    |> validate_length(:note,
      max: @max_note_size
    )
    |> validate_number(:amount,
      greater_than_or_equal_to: @min_amount,
      less_than_or_equal_to: @max_amount
    )
  end
end
