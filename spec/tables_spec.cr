require "./spec_helper"

describe Tables do
  it "tracks the version number" do
    Tables::VERSION.blank?.should eq(false)
  end

  it "renders" do
    config = Tables::TableConfig.new
    config.headers = ["one", "two", "three"]

    table = Tables.render([["helo", ",", "world"]], config)
    table_lines = table.split("\n")
    table_lines[0].should eq("|one |two|three|")
    table_lines[1].should eq("|----|---|-----|")
    table_lines[2].should eq("|helo|,  |world|")
  end

  it "throws an exception in strict mode if row size is incorrect" do
    config = Tables::TableConfig.new
    config.headers = ["one", "two", "three"]

    # Too few elements in row
    begin
      Tables.render([["one", "two"]], config)
    rescue ex
      ex.message.should eq("Row has not the expected amount of elements")
    end

    # Too many elements in row
    begin
      Tables.render([["one", "two", "three", "four"]], config)
    rescue ex
      ex.message.should eq("Row has not the expected amount of elements")
    end

    # One correct row, followed by an incorrect one
    begin
      Tables.render([["one", "two", "three"], ["one", "two"]], config)
    rescue ex
      ex.message.should eq("Row has not the expected amount of elements")
    end
  end

  it "doesn't throw an exception with strict mode disabled if row size is incorrect" do
    config = Tables::TableConfig.new
    config.headers = ["one", "two", "three"]
    config.strict = false

    # Too few elements in row
    begin
      Tables.render([["one", "two"]], config).should be_truthy
    rescue ex
      ex.message.should be_falsey
    end

    # Too many elements in row
    begin
      Tables.render([["one", "two", "three", "four"]], config).should be_truthy
    rescue ex
      # Index out of bounds
      ex.message.should be_truthy
    end

    # One correct row, followed by an incorrect one
    begin
      Tables.render([["one", "two", "three"], ["one", "two"]], config).should be_truthy
    rescue ex
      ex.message.should be_falsey
    end
  end

  it "enforces separators in markdown mode" do
    config = Tables::TableConfig.new
    config.headers = ["one", "two", "three"]
    config.h_separator = "+"
    config.v_separator = "*"
    config.markdown = true

    table = Tables.render([["helo", ",", "world"]], config)
    table_lines = table.split("\n")
    table_lines[0].should eq("|one |two|three|")
    table_lines[1].should eq("|----|---|-----|")
    table_lines[2].should eq("|helo|,  |world|")
  end

  it "supports configurable separators" do
    config = Tables::TableConfig.new
    config.headers = ["one", "two", "three"]
    config.h_separator = "+"
    config.v_separator = "*"
    config.markdown = false

    table = Tables.render([["helo", ",", "world"]], config)
    table_lines = table.split("\n")
    table_lines[0].should eq("*one *two*three*")
    table_lines[1].should eq("*++++*+++*+++++*")
    table_lines[2].should eq("*helo*,  *world*")
  end
end
