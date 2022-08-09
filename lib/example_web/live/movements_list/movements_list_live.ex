defmodule ExampleWeb.MovementsListLive do
  use ExampleWeb, :live_view

  alias Example.Accounting
  alias Example.Accounting.Movement
  alias Phoenix.LiveView.JS

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket = assign(socket, :movements, Accounting.list_movements())

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:movement_created, movement}, socket) do
    socket =
      socket
      |> assign(:movements, Accounting.list_movements())
      |> push_event("js-exec", %{
        to: ".movement-#{movement.id}",
        attr: "data-hide-form"
      })

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_info({:movement_updated, movement}, socket) do
    movements =
      Enum.map(socket.assigns.movements, &if(&1.id == movement.id, do: movement, else: &1))

    socket =
      socket
      |> assign(:movements, movements)
      |> push_event("js-exec", %{
        to: ".movement-#{movement.id}",
        attr: "data-hide-form"
      })

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="my-4">
      <button type="button"
              phx-click={show_form(%Movement{})}
              class="rounded px-3 py-2 bg-indigo-400 hover:bg-blue-600 text-white text-sm">
        Add new movement
      </button>
    </div>
    <div class="table w-full text-xs my-4">
      <div class="table-header-group">
        <div class="table-row">
          <div class="table-cell py-2 border-b text-left font-bold w-32">Date</div>
          <div class="table-cell py-2 border-b text-left font-bold">Description</div>
          <div class="table-cell py-2 border-b text-left font-bold w-32">Amount</div>
        </div>
      </div>
      <div class="table-row-group">
        <.live_component module={ExampleWeb.MovementsList.FormComponent}
                         id="create-movement-form"
                         movement={%Movement{}}
                         on_cancel={fn -> hide_form(%Movement{}) end} />
        <%= for movement <- @movements do %>
          <.movement_row movement={movement} />
          <.live_component module={ExampleWeb.MovementsList.FormComponent}
                          id={"movement-form-#{movement.id}"}
                          movement={movement}
                          on_cancel={fn -> hide_form(movement) end} />
        <% end %>
      </div>
    </div>
    """
  end

  defp movement_row(assigns) do
    ~H"""
    <div id={"movement-#{@movement.id}"}
         class={"movement movement-#{@movement.id} table-row cursor-pointer"}
         phx-click={show_form(@movement)}
         data-hide-form={hide_form(@movement)}>
      <div class="table-cell py-2 border-y"><%= @movement.date %></div>
      <div class="table-cell py-2 border-y"><%= @movement.description %></div>
      <div class="table-cell py-2 border-y"><%= @movement.amount %></div>
    </div>
    """
  end

  defp show_form(js \\ %JS{}, movement)

  defp show_form(js, %Movement{id: nil}) do
    js
    |> JS.hide(to: ".movement-form")
    |> JS.show(to: ".movement", display: "table-row")
    |> JS.show(
      to: ".create-movement-form",
      display: "table-row",
      transition: {"ease-in duration-150", "opacity-0", "opacity-100"},
      time: 150
    )
  end

  defp show_form(js, movement) do
    js
    |> JS.hide(to: ".movement-form")
    |> JS.show(to: ".movement", display: "table-row")
    |> JS.hide(to: ".movement-#{movement.id}")
    |> JS.show(
      to: ".movement-#{movement.id}-form",
      display: "table-row",
      transition: {"ease-in duration-150", "opacity-0", "opacity-100"},
      time: 150
    )
  end

  defp hide_form(js \\ %JS{}, movement)

  defp hide_form(js, %Movement{id: nil}) do
    JS.hide(js, to: ".movement-form")
  end

  defp hide_form(js, movement) do
    js
    |> JS.hide(to: ".movement-form")
    |> JS.show(
      to: ".movement-#{movement.id}",
      display: "table-row",
      transition: {"ease-in duration-150", "opacity-0", "opacity-100"},
      time: 150
    )
  end
end
