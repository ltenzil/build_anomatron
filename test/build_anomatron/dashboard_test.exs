defmodule BuildAnomatron.DashboardTest do
  use BuildAnomatron.DataCase

  alias BuildAnomatron.Dashboard

  describe "builds" do
    alias BuildAnomatron.Dashboard.Build

    import BuildAnomatron.DashboardFixtures

    @invalid_attrs %{}

    test "list_builds/0 returns all builds" do
      build = build_fixture()
      assert Dashboard.list_builds() == [build]
    end

    test "get_build!/1 returns the build with given id" do
      build = build_fixture()
      assert Dashboard.get_build!(build.id) == build
    end

    test "create_build/1 with valid data creates a build" do
      valid_attrs = %{}

      assert {:ok, %Build{} = build} = Dashboard.create_build(valid_attrs)
    end

    test "create_build/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dashboard.create_build(@invalid_attrs)
    end

    test "update_build/2 with valid data updates the build" do
      build = build_fixture()
      update_attrs = %{}

      assert {:ok, %Build{} = build} = Dashboard.update_build(build, update_attrs)
    end

    test "update_build/2 with invalid data returns error changeset" do
      build = build_fixture()
      assert {:error, %Ecto.Changeset{}} = Dashboard.update_build(build, @invalid_attrs)
      assert build == Dashboard.get_build!(build.id)
    end

    test "delete_build/1 deletes the build" do
      build = build_fixture()
      assert {:ok, %Build{}} = Dashboard.delete_build(build)
      assert_raise Ecto.NoResultsError, fn -> Dashboard.get_build!(build.id) end
    end

    test "change_build/1 returns a build changeset" do
      build = build_fixture()
      assert %Ecto.Changeset{} = Dashboard.change_build(build)
    end
  end
end
