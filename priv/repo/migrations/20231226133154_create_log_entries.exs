defmodule BuildAnomatron.Repo.Migrations.CreateLogEntries do
  use Ecto.Migration

  def change do
    create table(:log_entries) do

      add :status, :string
      add :job_url, :string
      add :build_id, references(:builds, on_delete: :delete_all)    
      add :job_name, :string
      add :log_level, :string
      add :job_number, :string
      add :user_name, :string
      add :console_url, :string
      add :error_count, :integer
      add :warning_count, :integer
      add :execution_time, :string
      add :estimated_duration, :string
      add :artifacts_count, :integer
      add :triggered_builds, :string
      add :error_stack_trace, :string
      add :triggered_build_count, :integer
      add :built_on, :string
      add :branch, :string
      add :job_timestamp, :string

      timestamps(type: :utc_datetime)
    end
  end
end
