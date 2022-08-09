defmodule ExampleWeb.MovementsList.FormComponent do
  use ExampleWeb, :live_component

  alias Example.Accounting
  alias Example.Accounting.Movement

  @impl Phoenix.LiveComponent
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:changeset, Accounting.change_movement(assigns.movement))

    {:ok, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("validate", %{"movement" => params}, socket) do
    changeset =
      socket.assigns.movement
      |> Accounting.change_movement(params)
      |> Map.put(:action, :validate)

    socket = assign(socket, :changeset, changeset)
    {:noreply, socket}
  end

  @impl Phoenix.LiveComponent
  def handle_event("save", %{"movement" => params}, socket) do
    case socket.assigns.movement do
      %Movement{id: nil} -> create_movement(socket, params)
      %Movement{} -> update_movement(socket, params)
    end
  end

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div class="contents">
      <.form let={f} for={@changeset} phx-target={@myself} phx-change="validate" phx-submit="save" as="movement" class="contents">
        <div class={"movement-form #{get_form_class(@movement)} hidden"}>
          <div class="table-cell py-2 pr-1">
            <%= date_input f, :date, class: "rounded w-full text-xs mb-1" %>
            <%= error_tag f, :date, class: "text-xs text-red-500" %>
          </div>
          <div class="table-cell py-2 px-1">
            <%= text_input f, :description, class: "rounded w-full text-xs mb-1" %>
            <%= error_tag f, :description, class: "text-xs text-red-500" %>
          </div>
          <div class="table-cell py-2 pl-1">
            <%= number_input f, :amount, class: "rounded w-full text-xs mb-1" %>
            <%= error_tag f, :amount, class: "text-xs text-red-500" %>
          </div>
        </div>
        <div class={"movement-form #{get_form_class(@movement)} hidden"}>
          <div class="table-cell pb-2 border-b"></div>
          <div class="table-cell pb-2 border-b"></div>
          <div class="table-cell pb-2 border-b text-right">
            <button type="button" phx-click={@on_cancel.()} class="px-2 py-1 mr-2">Cancel</button>
            <button type="submit" class="rounded px-2 py-1 bg-indigo-400 hover:bg-blue-600 text-white">Save</button>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  defp create_movement(socket, params) do
    case Accounting.create_movement(params) do
      {:ok, movement} ->
        socket = assign(socket, :changeset, Accounting.change_movement(%Movement{}))
        send(self(), {:movement_created, movement})
        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :changeset, changeset)
        {:noreply, socket}
    end
  end

  defp update_movement(socket, params) do
    case Accounting.update_movement(socket.assigns.movement, params) do
      {:ok, movement} ->
        send(self(), {:movement_updated, movement})
        {:noreply, socket}

      {:error, changeset} ->
        socket = assign(socket, :changeset, changeset)
        {:noreply, socket}
    end
  end

  defp get_form_class(%Movement{id: nil}), do: "create-movement-form"
  defp get_form_class(%Movement{id: id}), do: "movement-#{id}-form"
end
