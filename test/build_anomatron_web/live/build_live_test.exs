defmodule BuildAnomatronWeb.BuildLiveTest do
  use BuildAnomatronWeb.ConnCase

  import Phoenix.LiveViewTest
  import BuildAnomatron.DashboardFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_build(_) do
    build = build_fixture()
    %{build: build}
  end

  describe "Index" do
    setup [:create_build]

    test "lists all builds", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/builds")

      assert html =~ "Listing Builds"
    end

    test "saves new build", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/builds")

      assert index_live |> element("a", "New Build") |> render_click() =~
               "New Build"

      assert_patch(index_live, ~p"/builds/new")

      assert index_live
             |> form("#build-form", build: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#build-form", build: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/builds")

      html = render(index_live)
      assert html =~ "Build created successfully"
    end

    test "updates build in listing", %{conn: conn, build: build} do
      {:ok, index_live, _html} = live(conn, ~p"/builds")

      assert index_live |> element("#builds-#{build.id} a", "Edit") |> render_click() =~
               "Edit Build"

      assert_patch(index_live, ~p"/builds/#{build}/edit")

      assert index_live
             |> form("#build-form", build: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#build-form", build: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/builds")

      html = render(index_live)
      assert html =~ "Build updated successfully"
    end

    test "deletes build in listing", %{conn: conn, build: build} do
      {:ok, index_live, _html} = live(conn, ~p"/builds")

      assert index_live |> element("#builds-#{build.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#builds-#{build.id}")
    end
  end

  describe "Show" do
    setup [:create_build]

    test "displays build", %{conn: conn, build: build} do
      {:ok, _show_live, html} = live(conn, ~p"/builds/#{build}")

      assert html =~ "Show Build"
    end

    test "updates build within modal", %{conn: conn, build: build} do
      {:ok, show_live, _html} = live(conn, ~p"/builds/#{build}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Build"

      assert_patch(show_live, ~p"/builds/#{build}/show/edit")

      assert show_live
             |> form("#build-form", build: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#build-form", build: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/builds/#{build}")

      html = render(show_live)
      assert html =~ "Build updated successfully"
    end
  end
end
