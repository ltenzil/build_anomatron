defmodule BuildAnomatron.JenkinsTest do
  use BuildAnomatron.DataCase

  alias BuildAnomatron.Jenkins

  describe "builds" do
    alias BuildAnomatron.Jenkins.Build

    import BuildAnomatron.JenkinsFixtures

    @invalid_attrs %{job_name: nil, number: nil, status: nil}

    test "list_builds/0 returns all builds" do
      build = build_fixture()
      assert Jenkins.list_builds() == [build]
    end

    test "get_build!/1 returns the build with given id" do
      build = build_fixture()
      assert Jenkins.get_build!(build.id) == build
    end

    test "create_build/1 with valid data creates a build" do
      valid_attrs = %{job_name: "some job_name", number: 42, status: "some status"}

      assert {:ok, %Build{} = build} = Jenkins.create_build(valid_attrs)
      assert build.job_name == "some job_name"
      assert build.number == 42
      assert build.status == "some status"
    end

    test "create_build/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jenkins.create_build(@invalid_attrs)
    end

    test "update_build/2 with valid data updates the build" do
      build = build_fixture()
      update_attrs = %{job_name: "some updated job_name", number: 43, status: "some updated status"}

      assert {:ok, %Build{} = build} = Jenkins.update_build(build, update_attrs)
      assert build.job_name == "some updated job_name"
      assert build.number == 43
      assert build.status == "some updated status"
    end

    test "update_build/2 with invalid data returns error changeset" do
      build = build_fixture()
      assert {:error, %Ecto.Changeset{}} = Jenkins.update_build(build, @invalid_attrs)
      assert build == Jenkins.get_build!(build.id)
    end

    test "delete_build/1 deletes the build" do
      build = build_fixture()
      assert {:ok, %Build{}} = Jenkins.delete_build(build)
      assert_raise Ecto.NoResultsError, fn -> Jenkins.get_build!(build.id) end
    end

    test "change_build/1 returns a build changeset" do
      build = build_fixture()
      assert %Ecto.Changeset{} = Jenkins.change_build(build)
    end
  end
end
