defmodule BuildAnomatronWeb.LogEntryController do
  use BuildAnomatronWeb, :controller

  alias BuildAnomatron.LogAnalysis
  alias BuildAnomatron.LogAnalysis.LogEntry

  def index(conn, _params) do
    builds = LogAnalysis.list_log_entries()
    render(conn, :index, builds: builds)
  end

  # def show(conn, %{"id" => id}) do
  #   build = LogEntry.get_log_entry!(id)
  #   render(conn, :show, build: build)
  # end
end
