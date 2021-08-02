# Om - Order manager

## How to run

### Requirements

```
- Elixir 1.12.0 (compiled with Erlang/OTP 24) (Others versions may work)
- Docker 
``` 

1 - Start a postgres instance 

```shell 
docker run -d -p 5432:5432 postgres:10.4
```

2 - Run Ecto Migrations 

```shell 
mix ecto.reset
```

3 - Start server 

```shell 
iex -S mix phx.server
```


### How to test

The playground is avaliable in: http://localhost:4000/graphiql  
The api endpoint is: http://localhost:4000/graphql

### Some not implented features and optimizations

- Pagination
- Dataloader