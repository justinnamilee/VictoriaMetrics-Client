## no critic (Modules::RequireEndWithOne)
## no critic (Modules::RequireExplicitPackage)
#? critic is targetting .t files as .pm, too lazy to fix
use strict;
use warnings;
use Test::More;

BEGIN { use_ok(q[VictoriaMetrics::Client]) }

done_testing;

diag(qq(Testing VictoriaMetrics::Client $VictoriaMetrics::Client::VERSION, Perl $], $^X));
