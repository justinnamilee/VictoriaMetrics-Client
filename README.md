# VictoriaMetrics::Client

Simple Perl client for the VictoriaMetrics HTTP API and getting data back.

## Requirements

* Perl 5.14+
* Modules:

  * HTTP::Tiny
  * URI
  * URI::Escape
  * JSON::PP

## Installation

Copy `VictoriaMetrics/Client.pm` into your Perl library path or include it with `use lib`.  Maybe it'll be on CPAN someday.

## Usage
```perl
use VictoriaMetrics::Client;

my $vm = VictoriaMetrics::Client->new(
    url => 'http://localhost:8428',
);

die "Unable to connect\n" unless $vm->connect;
```

## Constructor

```perl
my $vm = VictoriaMetrics::Client->new(
    url     => 'http://localhost:8428',
    timeout => 30,                  # optional
    headers => {                    # optional
        Authorization => 'Bearer <token>',
    },
);
```

### Parameters

| Name      | Required | Description                                                |
| --------- | -------- | ---------------------------------------------------------- |
| `url`     | Yes      | Base VictoriaMetrics URL. Must be `http://` or `https://`. |
| `timeout` | No       | HTTP timeout in seconds. Default: `30`.                    |
| `headers` | No       | Default HTTP headers passed to `HTTP::Tiny`.               |

## Methods

### connect

Checks connectivity using the `/health` endpoint.

```perl
$vm->connect or die "Connection failed";
```

Returns true on success, `undef` on failure.

### query

Executes an instant query against `/api/v1/query`.

```perl
my $res = $vm->query('up');

my $res = $vm->query(
    'node_cpu_seconds_total',
    time => time,
);
```

Additional arguments are appended as URL query parameters.

Returns:

* Decoded Perl data structure for JSON responses.
* Raw response body for non-JSON responses.
* `undef` on failure.

### url

Builds an endpoint URL. _You shouldn't need this, but it's there._

```perl
my $url = $vm->url(
    'query',
    query => 'up',
    time  => time,
);
```

This is primarily an internal helper and normally does not need to be called directly.

## Supported Endpoints

| Route    | Endpoint        |
| -------- | --------------- |
| `health` | `/health`       |
| `query`  | `/api/v1/query` |

`query_range` is reserved but not yet implemented.

## Error Handling

Errors are reported using `Carp::carp`, and methods return `undef` on failure.

## Example

```perl
use VictoriaMetrics::Client;
use Data::Dumper;

my $vm = VictoriaMetrics::Client->new(
    url => 'http://localhost:8428',
);

die "Connection failed\n" unless $vm->connect;

my $data = $vm->query('up')
    or die "Query failed\n";

print Dumper($data);
```

## License

See `LICENSE` file.
