require "./spec_helper"

describe Tables do
  # TODO: Write tests

  it "tracks the version number" do
    Tables::VERSION.blank?.should eq(false)
  end

  it "renders" do
    config = Tables::TableConfig.new
    config.headers = ["one", "two", "three"]
    Tables.render([["helo", ",", "world"]], config)
  end
end
