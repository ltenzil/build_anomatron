defmodule BuildAnomatron.LogAnalysisTest do
  use BuildAnomatron.DataCase

  alias BuildAnomatron.LogAnalysis

  describe "log_entries" do
    alias BuildAnomatron.LogAnalysis.LogEntry

    import BuildAnomatron.LogAnalysisFixtures

    @invalid_attrs %{}

    test "list_log_entries/0 returns all log_entries" do
      log_entry = log_entry_fixture()
      assert LogAnalysis.list_log_entries() == [log_entry]
    end

    test "get_log_entry!/1 returns the log_entry with given id" do
      log_entry = log_entry_fixture()
      assert LogAnalysis.get_log_entry!(log_entry.id) == log_entry
    end

    test "create_log_entry/1 with valid data creates a log_entry" do
      valid_attrs = %{}

      assert {:ok, %LogEntry{} = log_entry} = LogAnalysis.create_log_entry(valid_attrs)
    end

    test "create_log_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LogAnalysis.create_log_entry(@invalid_attrs)
    end

    test "update_log_entry/2 with valid data updates the log_entry" do
      log_entry = log_entry_fixture()
      update_attrs = %{}

      assert {:ok, %LogEntry{} = log_entry} = LogAnalysis.update_log_entry(log_entry, update_attrs)
    end

    test "update_log_entry/2 with invalid data returns error changeset" do
      log_entry = log_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = LogAnalysis.update_log_entry(log_entry, @invalid_attrs)
      assert log_entry == LogAnalysis.get_log_entry!(log_entry.id)
    end

    test "delete_log_entry/1 deletes the log_entry" do
      log_entry = log_entry_fixture()
      assert {:ok, %LogEntry{}} = LogAnalysis.delete_log_entry(log_entry)
      assert_raise Ecto.NoResultsError, fn -> LogAnalysis.get_log_entry!(log_entry.id) end
    end

    test "change_log_entry/1 returns a log_entry changeset" do
      log_entry = log_entry_fixture()
      assert %Ecto.Changeset{} = LogAnalysis.change_log_entry(log_entry)
    end
  end
end
