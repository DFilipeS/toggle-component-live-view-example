# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Example.Repo.insert!(%Example.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Enum.each(0..9, fn _ ->
  Example.Accounting.create_movement(%{
    date: Date.add(Date.utc_today(), Enum.random(0..-100)),
    description:
      Enum.random(["Food", "Technology", "Rent", "Transportation", "Pharmacy", "Clothing", "Pets"]),
    amount: Enum.random(100..10000)
  })
end)
