defmodule Example.Repo.Migrations.CreateMovements do
  use Ecto.Migration

  def change do
    create table(:movements) do
      add :date, :date
      add :description, :text
      add :amount, :integer

      timestamps()
    end
  end
end
