package VictoriaMetrics::Client;


use strict;
use Carp;


use URI;
use HTTP::Tiny;
use JSON::PP qw(decode_json);
use URI::Escape qw(uri_escape_utf8);


my %URL = (
  health => '%s/health',
  query  => '%s/api/v1/query',
  range  => '%s/api/v1/query_range'
);


###
# constructor

sub new {
  my ($class, %conf) = @_;

  my $self = undef;

  if (URI->new($conf{url})->scheme =~ qr[^https?$]i)
  {
    $self = bless {
      url  => $conf{url} =~ s{/$}{}r,
      http => HTTP::Tiny->new(
        timeout => $conf{timeout} // 30,
        default_headers => $conf{headers} // {},
      ),
    }, $class;
  }
  else
  {
    carp __PACKAGE__ . qq[: url is required to be valid http/s url\n];
  }

  return ($self);
}


###
# methods

sub connect {
    my ($self) = @_;

    my $success = undef;
    my $res = $self->{http}->get($self->url(q[health]));

    if ($res->{success})
    {
      $success = 1;
    }
    else
    {
      carp __PACKAGE__ . qq[: connection failed: $res->{status} $res->{reason}\n];
    }

    return ($success);
}

sub query {
    my ($self, $query, %args) = @_;

    my $data = undef;

    if (length($query))
    {
      my $url = $self->url(q[query], query => $query, %args);
      my $res = $self->{http}->get($url);

      if ($res->{success})
      {
        $data = $res->{headers}{'content-type'} =~ m[application/json]i
          ? decode_json($res->{content})
          : $res->{content};
      }
      else
      {
        carp __PACKAGE__ . qq[: request failed: $res->{status} $res->{reason}\n$res->{content}\n]
      }
    }
    else
    {
      carp __PACKAGE__ . qq[: query is required\n]
    }

    return ($data);
}

# TODO: Implment sub range{}

sub url {
  my ($self, $route, %extra) = @_;

  my $url = undef;
  
  if (exists($URL{$route}))
  {
    $url = sprintf($URL{$route}, $self->{url});

    if (%extra) {
      $url .= q[?] . join(q[&], map { join(q[=], map { uri_escape_utf8($_) } ($_, $extra{$_})) } keys %extra);
   }
  }
  else
  {
    carp __PACKAGE__ . qq[: unknown url type '$route'\n];
  }

  return ($url);
}


__PACKAGE__
