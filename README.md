# ascii_tables

[![CI](https://github.com/frncsdrk/ascii_tables/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/frncsdrk/ascii_tables/actions/workflows/ci.yml)

Render ASCII tables.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     tables:
       github: frncsdrk/ascii_tables
   ```

2. Run `shards install`

## Usage

```crystal
require "ascii_tables"
```

Render tables with #render method.

```crystal
config = AsciiTables::TableConfig.new
config.headers = ["one", "two", "three"]

table = AsciiTables.render([["hello", ",", "world"]], config)

puts table
```

## Development

### Requirements

- Crystal installation
- `make` for convenience

### Setup

- `shards install`

## Contributing

1. Fork it (<https://github.com/your-github-user/tables/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [frncsdrk](https://github.com/frncsdrk) - creator and maintainer

## License

The Unlicense
