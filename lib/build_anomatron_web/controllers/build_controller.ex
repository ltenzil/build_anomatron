defmodule BuildAnomatronWeb.BuildController do
  use BuildAnomatronWeb, :controller

  alias BuildAnomatron.Jenkins
  alias BuildAnomatron.Jenkins.Build

  def index(conn, _params) do
    builds = Jenkins.list_builds()
    render(conn, :index, builds: builds)
  end

  def new(conn, _params) do
    changeset = Jenkins.change_build(%Build{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"build" => build_params}) do
    case Jenkins.create_build(build_params) do
      {:ok, build} ->
        conn
        |> put_flash(:info, "Build created successfully.")
        |> redirect(to: ~p"/builds/#{build}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    build = Jenkins.get_build!(id)
    render(conn, :show, build: build)
  end

  def edit(conn, %{"id" => id}) do
    build = Jenkins.get_build!(id)
    changeset = Jenkins.change_build(build)
    render(conn, :edit, build: build, changeset: changeset)
  end

  def update(conn, %{"id" => id, "build" => build_params}) do
    build = Jenkins.get_build!(id)

    case Jenkins.update_build(build, build_params) do
      {:ok, build} ->
        conn
        |> put_flash(:info, "Build updated successfully.")
        |> redirect(to: ~p"/builds/#{build}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, build: build, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    build = Jenkins.get_build!(id)
    {:ok, _build} = Jenkins.delete_build(build)

    conn
    |> put_flash(:info, "Build deleted successfully.")
    |> redirect(to: ~p"/builds")
  end
end
