defmodule Om.Factory do
  alias Om.Store.Order
  alias Om.Repo

  def build(:order) do
    %Order{
      total: 1000,
      balance_due: 1000,
      description: "Factory order"
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
