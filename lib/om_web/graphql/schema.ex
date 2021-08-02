defmodule OmWeb.GraphQl.Schema do
  use Absinthe.Schema

  import_types(__MODULE__.Scalars)
  import_types(__MODULE__.Store.Types)
  import_types(__MODULE__.Store.Queries)
  import_types(__MODULE__.Store.Mutations)

  query do
    import_fields(:store_queries)
  end

  mutation do
    import_fields(:store_mutations)
  end
end
