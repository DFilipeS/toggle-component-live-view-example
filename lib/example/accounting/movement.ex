defmodule Example.Accounting.Movement do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movements" do
    field :amount, :integer
    field :date, :date
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(movement, attrs) do
    movement
    |> cast(attrs, [:date, :description, :amount])
    |> validate_required([:date, :description, :amount])
  end
end
