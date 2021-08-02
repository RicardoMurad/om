defmodule OmWeb.GraphQl.Schema.Scalars do
  use Absinthe.Schema.Notation

  scalar :uuid4, name: "UUID4" do
    description("""
    The `UUID4` scalar type represents UUID4 compliant string data, represented as UTF-8
    character sequences. The UUID4 type is most often used to represent unique
    human-readable ID strings.
    """)

    serialize(&encode/1)
    parse(&decode/1)
  end

  @spec decode(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp decode(%Absinthe.Blueprint.Input.String{value: value}) do
    with {:ok, result} <- UUID.info(value),
         %{version: 4, uuid: uuid} <- Map.new(result) do
      {:ok, uuid}
    else
      _ -> :error
    end
  end

  defp decode(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp decode(_) do
    :error
  end

  defp encode(value), do: value
end
