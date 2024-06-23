use strict;
use warnings;

use DBI;

use lib "../lib";
use Log_line;
use Log_parsing;
use Data_store;

main();

sub main
{
	my $lp = Log_parsing->new(-log => '../log_contents/out');
	my $ds = Data_store->new;
	
	my $message = {};
	my $log     = {};
	while($lp->next)
	{
		$lp->set_log_line;
		if($lp->is_table_message)
		{
			$lp->set_table_message($message);
			$ds->insert_to_message($message);
		}
		else
		{
			$lp->set_table_log($log);
			$ds->insert_to_log($log);
		}
	}
	
	$lp->close;
	$ds->close;
}
