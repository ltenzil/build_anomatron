defmodule BuildAnomatron.Jenkins.Build do
  use Ecto.Schema
  import Ecto.Changeset

  schema "builds" do
    field :job_name, :string
    field :number, :integer
    field :job_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(build, attrs) do
    build
    |> cast(attrs, [:job_name, :number, :job_url])
    |> validate_required([:job_name, :number])
    |> unique_constraint(:number, name: :builds_job_name_number_index,  message: "This is already recorded!")
  end
end
