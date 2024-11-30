# Placeholder for AsciiTables namespace
module AsciiTables
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  # Renders an ASCII table. Supports Markdown formatting.
  #
  # ```
  # config = AsciiTables::TableConfig.new
  # config.headers = ["one", "two", "three"]
  #
  # table = AsciiTables.render([["hello", ",", "world"]], config)
  #
  # puts table
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
        raise StrictError.new("Row hasn't the expected amount of elements.")
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
    header_out = "#{config.v_separator}#{" " * config.v_separator_whitespace}"
    separator_out = "#{config.v_separator}#{config.h_separator * config.v_separator_whitespace}"
    config.headers.each_with_index do |header, i|
      len = (cell_lengths[i] - header.size)

      # header title line
      header_out += "#{" " * config.v_separator_whitespace}"
      header_out += "#{header}"
      header_out += "#{" " * len}"
      header_out += "#{" " * config.v_separator_whitespace}"
      header_out += "#{config.v_separator}"

      # separator line
      separator_out += "#{config.h_separator * config.v_separator_whitespace}"
      separator_out += "#{config.h_separator * cell_lengths[i]}"
      separator_out += "#{config.h_separator * config.v_separator_whitespace}"
      separator_out += "#{config.v_separator}"
    end
    output += "#{header_out}\n"
    output += "#{separator_out}\n"

    # body
    data.each do |row|
      row_out = "#{config.v_separator}#{" " * config.v_separator_whitespace}"
      row.each_with_index do |cell, i|
        len = cell_lengths[i] - cell.size

        row_out += "#{" " * config.v_separator_whitespace}"
        row_out += "#{cell}"
        row_out += "#{" " * len}"
        row_out += "#{" " * config.v_separator_whitespace}"
        row_out += "#{config.v_separator}"
      end
      output += "#{row_out}\n"
    end

    output
    # /output
  end

  # Collection of configuration options for Tables.
  #
  # ```
  # config = AsciiTables::TableConfig.new
  # config.headers = ["one", "two", "three"]
  # config.h_separator = "+"
  # config.v_separator = "*"
  # config.v_separator_whitespace = 1
  # config.markdown = true
  # ```
  struct TableConfig
    property headers : Array(String)
    property markdown : Bool
    property h_separator : String
    property v_separator : String
    property v_separator_whitespace : UInt8
    property strict : Bool

    def initialize
      @headers = Array(String).new
      @markdown = true
      @h_separator = "-"
      @v_separator = "|"
      @v_separator_whitespace = 0
      @strict = true
    end
  end

  # Simple exception for strict mode.
  class StrictError < Exception
  end
end
