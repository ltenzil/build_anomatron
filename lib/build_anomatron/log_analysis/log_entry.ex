defmodule BuildAnomatron.LogAnalysis.LogEntry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "log_entries" do

    field :status, :string
    field :job_url, :string
    belongs_to :build, BuildAnomatron.Jenkins.Build
    field :job_name, :string
    field :log_level, :string
    field :job_number, :string
    field :user_name, :string
    field :console_url, :string
    field :error_count, :integer
    field :warning_count, :integer
    field :execution_time, :string
    field :estimated_duration, :string
    field :artifacts_count, :integer
    field :triggered_builds, :string
    field :error_stack_trace, :string
    field :triggered_build_count, :integer
    field :built_on, :string
    field :job_timestamp, :string


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(log_entry, attrs) do
    log_entry
    |> cast(attrs, [:status, :job_url, :build_id, :job_name, :log_level, :job_number, 
                    :user_name, :console_url, :error_count, :warning_count, :execution_time, 
                    :estimated_duration, :artifacts_count, :triggered_builds, :error_stack_trace, 
                    :triggered_build_count, :built_on, :job_timestamp])
    |> validate_required([:build_id])
  end

  # job_view_url = "https://rdkjenkins-nightly.stb.r53.xcal.tv/jenkins/view/1-Nightly-Builds/api/json"
  # {:ok, {_, job_view_data} } = BuildAnomatron.BaseApi.get_json job_view_url

  # jobs = job_view_data["jobs"]
  # builds_data =[]
  # Enum.map(jobs, fn(job) -> 
  #   job_url  = job["url"] <> "api/json"
  #   job_name = job["name"]
  #   IO.inspect("Running job: #{job_name}")
  #   case BuildAnomatron.BaseApi.get_json job_url do
  #   {:error, {_, _}} -> false
  #   {:ok, {_, job_json_data} } ->
  #     builds_data = Enum.map(job_json_data["builds"], fn(build) ->
  #       %{ job_name: job_name, number: build["number"], job_url: build["url"] }
  #     end)

  #     Enum.map(builds_data, fn(build) ->
  #       BuildAnomatron.Jenkins.create_build(build)
  #     end)
  #   end
  # end)


  # ######
  # job_url = "https://rdkjenkins-nightly.stb.r53.xcal.tv/jenkins/view/1-Nightly-Builds/job/HISENSE-V2-Yocto-Nightly/api/json"

  # {:ok, {_, job_json_data} } = BuildAnomatron.BaseApi.get_json job_url

  # job_name = job_json_data["displayName"]
  # builds_data = Enum.map(job_json_data["builds"], fn(build) ->
  #   %{ job_name: job_name, number: build["number"], job_url: build["url"] }
  # end)

  # Enum.map(builds_data, fn(build) ->
  #   BuildAnomatron.Jenkins.create_build(build)
  # end)
end
