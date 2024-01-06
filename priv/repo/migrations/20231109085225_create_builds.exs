defmodule BuildAnomatron.Repo.Migrations.CreateBuilds do
  use Ecto.Migration

  def change do
    create table(:builds) do
      add :number, :integer, index: true
      add :job_name, :string, index: true
      add :job_url, :string
      

      timestamps(type: :utc_datetime)
    end
    create_if_not_exists(unique_index(:builds, [:number, :job_name], name: :builds_job_name_number_index))
  end
end
