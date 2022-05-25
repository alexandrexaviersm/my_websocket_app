defmodule MyWebsocketApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy,
       scheme: :http, plug: MyWebsocketApp.Router, options: [dispatch: dispatch(), port: 4001]},
      {Registry, keys: :duplicate, name: Registry.MyWebsocketApp}
    ]

    opts = [strategy: :one_for_one, name: MyWebsocketApp.Application]
    Supervisor.start_link(children, opts)
  end

  defp dispatch do
    [
      {:_,
       [
         {"/ws/[...]", MyWebsocketApp.SocketHandler, []},
         {:_, Plug.Cowboy.Handler, {MyWebsocketApp.Router, []}}
       ]}
    ]
  end
end
