# Placeholder for Table namespace
module Tables
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

  # TODO: Implement configurable separators (output)
  # TODO: Implement strict mode (check number of items per line)
  # TODO: Implement markdown notation
  # TODO: Put your code here

  # TODO: Write docs
  def self.render(data : Array(Array(String)), config : TableConfig = TableConfig.new) : String
    # prepare
    prev_row_size = nil
    cell_lengths = Array(Int32).new
    config.headers.each do |header|
      cell_lengths.push header.size
    end
    data.each do |row|
      if config.strict && prev_row_size != nil && prev_row_size != row.size
        # throw error in strict mode
      end

      new_row = row.sort_by { |item| item.size }
      puts new_row
      puts row

      row.each_with_index do |v, i|
        unless cell_lengths[i]?
          cell_lengths[i] = v.size
        end
        if v.size > cell_lengths[i]
          cell_lengths[i] = v.size
        end
      end
    end
    puts "cell lengths:", cell_lengths
    # /prepare

    # output
    output = ""
    # header
    header_out = "#{config.separator}"
    separator_out = "#{config.separator}"
    config.headers.each_with_index do |header, i|
      len = cell_lengths[i] - header.size
      header_out += "#{header}#{" " * len}#{config.separator}"
      separator_out += "#{"-" * cell_lengths[i]}#{config.separator}"
    end
    output += "#{header_out}\n"
    output += "#{separator_out}\n"

    # body
    data.each do |row|
      row_out = "#{config.separator}"
      row.each_with_index do |cell, i|
      len = cell_lengths[i] - cell.size
        row_out += "#{cell}#{" " * len}#{config.separator}"
      end
      output += "#{row_out}\n"
    end

    output
    # /output
  end

  struct TableConfig
    property headers : Array(String)
    property markdown : Bool
    property separator : String
    property strict : Bool

    def initialize
      @headers = Array(String).new
      @markdown = false
      @separator = "|"
      @strict = true
    end
  end
end
