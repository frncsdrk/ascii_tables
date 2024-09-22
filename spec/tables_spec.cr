require "./spec_helper"

describe Tables do
  # TODO: Write tests

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
    puts table
  end
end
