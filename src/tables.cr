# Placeholder for Table namespace
module Tables
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  # TODO: Rename to `ascii-tables`

  # Renders an ASCII table. Supports Markdown formatting.
  #
  # ```crystal
  # config = Tables::TableConfig.new
  # config.headers = ["one", "two", "three"]
  #
  # table = Tables.render([["hello", ",", "world"]], config)
  # ```
  def self.render(data : Array(Array(String)), config : TableConfig = TableConfig.new) : String
    # prepare
    prev_row_size = config.headers.size
    cell_lengths = Array(Int32).new
    config.headers.each do |header|
      cell_lengths.push header.size
    end
    data.each do |row|
      if config.strict && prev_row_size != nil && prev_row_size != row.size
        raise StrictError.new("Row has not the expected amount of elements")
      end

      row.each_with_index do |v, i|
        unless cell_lengths[i]?
          cell_lengths[i] = v.size
        end
        if v.size > cell_lengths[i]
          cell_lengths[i] = v.size
        end
      end

      prev_row_size = row.size
    end
    # /prepare

    # output
    if config.markdown
      config.h_separator = "-"
      config.v_separator = "|"
    end

    output = ""
    # header
    header_out = "#{config.v_separator}"
    separator_out = "#{config.v_separator}"
    config.headers.each_with_index do |header, i|
      len = cell_lengths[i] - header.size
      header_out += "#{header}#{" " * len}#{config.v_separator}"
      separator_out += "#{config.h_separator * cell_lengths[i]}#{config.v_separator}"
    end
    output += "#{header_out}\n"
    output += "#{separator_out}\n"

    # body
    data.each do |row|
      row_out = "#{config.v_separator}"
      row.each_with_index do |cell, i|
        len = cell_lengths[i] - cell.size
        row_out += "#{cell}#{" " * len}#{config.v_separator}"
      end
      output += "#{row_out}\n"
    end

    output
    # /output
  end

  # Collection of configuration options for Tables.
  #
  # ```crystal
  # config = Tables::TableConfig.new
  # config.headers = ["one", "two", "three"]
  # config.h_separator = "+"
  # config.v_separator = "*"
  # config.markdown = true
  # ```
  struct TableConfig
    property headers : Array(String)
    property? markdown : Bool
    property h_separator : String
    property v_separator : String
    property? strict : Bool

    def initialize
      @headers = Array(String).new
      @markdown = true
      @h_separator = "-"
      @v_separator = "|"
      @strict = true
    end
  end

  # Simple exception for strict mode.
  class StrictError < Exception
  end
end
