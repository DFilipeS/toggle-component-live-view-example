defmodule Example.AccountingTest do
  use Example.DataCase

  alias Example.Accounting

  describe "movements" do
    alias Example.Accounting.Movement

    import Example.AccountingFixtures

    @invalid_attrs %{amount: nil, date: nil, description: nil}

    test "list_movements/0 returns all movements" do
      movement = movement_fixture()
      assert Accounting.list_movements() == [movement]
    end

    test "get_movement!/1 returns the movement with given id" do
      movement = movement_fixture()
      assert Accounting.get_movement!(movement.id) == movement
    end

    test "create_movement/1 with valid data creates a movement" do
      valid_attrs = %{amount: 42, date: ~D[2022-07-31], description: "some description"}

      assert {:ok, %Movement{} = movement} = Accounting.create_movement(valid_attrs)
      assert movement.amount == 42
      assert movement.date == ~D[2022-07-31]
      assert movement.description == "some description"
    end

    test "create_movement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounting.create_movement(@invalid_attrs)
    end

    test "update_movement/2 with valid data updates the movement" do
      movement = movement_fixture()
      update_attrs = %{amount: 43, date: ~D[2022-08-01], description: "some updated description"}

      assert {:ok, %Movement{} = movement} = Accounting.update_movement(movement, update_attrs)
      assert movement.amount == 43
      assert movement.date == ~D[2022-08-01]
      assert movement.description == "some updated description"
    end

    test "update_movement/2 with invalid data returns error changeset" do
      movement = movement_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounting.update_movement(movement, @invalid_attrs)
      assert movement == Accounting.get_movement!(movement.id)
    end

    test "delete_movement/1 deletes the movement" do
      movement = movement_fixture()
      assert {:ok, %Movement{}} = Accounting.delete_movement(movement)
      assert_raise Ecto.NoResultsError, fn -> Accounting.get_movement!(movement.id) end
    end

    test "change_movement/1 returns a movement changeset" do
      movement = movement_fixture()
      assert %Ecto.Changeset{} = Accounting.change_movement(movement)
    end
  end
end
