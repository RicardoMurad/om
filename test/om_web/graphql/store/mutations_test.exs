defmodule OmWeb.GraphQl.Schema.Store.Mutations do
  use OmWeb.ConnCase

  @create_order_mutation """
  mutation($input:OrderInput!) {
    createOrder(input: $input) {
      id
      balanceDue
      description
      total
      insertedAt
    }
  }
  """

  @valid_input %{
    total: 1_000,
    description: "This is a order"
  }

  describe "create_order" do
    test "it creates an order", %{conn: conn} do
      assert %{
               "data" => %{
                 "createOrder" => %{
                   "balanceDue" => 1000,
                   "description" => "This is a order",
                   "id" => result_id,
                   "insertedAt" => _,
                   "total" => 1000
                 }
               }
             } =
               run_graphql(conn,
                 query: @create_order_mutation,
                 variables: %{"input" => @valid_input}
               )

      assert result_id
    end

    test "it validates required fields", %{conn: conn} do
      assert %{
               "errors" => [
                 %{
                   "locations" => [%{"column" => 15, "line" => 2}],
                   "message" =>
                     "Argument \"input\" has invalid value $input.\nIn field \"total\": Expected type \"Int!\", found null.\nIn field \"description\": Expected type \"String!\", found null."
                 }
               ]
             } ==
               run_graphql(conn,
                 query: @create_order_mutation,
                 variables: %{"input" => %{}}
               )
    end
  end
end
