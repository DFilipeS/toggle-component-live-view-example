defmodule Example.AccountingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Example.Accounting` context.
  """

  @doc """
  Generate a movement.
  """
  def movement_fixture(attrs \\ %{}) do
    {:ok, movement} =
      attrs
      |> Enum.into(%{
        amount: 42,
        date: ~D[2022-07-31],
        description: "some description"
      })
      |> Example.Accounting.create_movement()

    movement
  end
end
