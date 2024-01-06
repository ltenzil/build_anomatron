defmodule BuildAnomatronWeb.BuildControllerTest do
  use BuildAnomatronWeb.ConnCase

  import BuildAnomatron.JenkinsFixtures

  @create_attrs %{job_name: "some job_name", number: 42, status: "some status"}
  @update_attrs %{job_name: "some updated job_name", number: 43, status: "some updated status"}
  @invalid_attrs %{job_name: nil, number: nil, status: nil}

  describe "index" do
    test "lists all builds", %{conn: conn} do
      conn = get(conn, ~p"/builds")
      assert html_response(conn, 200) =~ "Listing Builds"
    end
  end

  describe "new build" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/builds/new")
      assert html_response(conn, 200) =~ "New Build"
    end
  end

  describe "create build" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/builds", build: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/builds/#{id}"

      conn = get(conn, ~p"/builds/#{id}")
      assert html_response(conn, 200) =~ "Build #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/builds", build: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Build"
    end
  end

  describe "edit build" do
    setup [:create_build]

    test "renders form for editing chosen build", %{conn: conn, build: build} do
      conn = get(conn, ~p"/builds/#{build}/edit")
      assert html_response(conn, 200) =~ "Edit Build"
    end
  end

  describe "update build" do
    setup [:create_build]

    test "redirects when data is valid", %{conn: conn, build: build} do
      conn = put(conn, ~p"/builds/#{build}", build: @update_attrs)
      assert redirected_to(conn) == ~p"/builds/#{build}"

      conn = get(conn, ~p"/builds/#{build}")
      assert html_response(conn, 200) =~ "some updated job_name"
    end

    test "renders errors when data is invalid", %{conn: conn, build: build} do
      conn = put(conn, ~p"/builds/#{build}", build: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Build"
    end
  end

  describe "delete build" do
    setup [:create_build]

    test "deletes chosen build", %{conn: conn, build: build} do
      conn = delete(conn, ~p"/builds/#{build}")
      assert redirected_to(conn) == ~p"/builds"

      assert_error_sent 404, fn ->
        get(conn, ~p"/builds/#{build}")
      end
    end
  end

  defp create_build(_) do
    build = build_fixture()
    %{build: build}
  end
end
