#!perl.exe -w
use strict;
use warnings;

use DBI;
use CGI;
use HTML::Template;

use lib "../lib";
use Data_store;

main();

sub main
{
	my $cgi = CGI->new;
	my $ds  = Data_store->new;
	
	my $text  = $cgi->param('search-input');
	my $total = $ds->get_total_lines($text);
		
	if($total > 100)
	{
		send_message($cgi, $total);
	}
	else
	{
		my $data = $ds->get_search_result($text);
		send_response($cgi, $data);
	}
	
	$ds->close;
}

sub send_message
{
	my $cgi   = shift;
	my $total = shift;
	
	my $tmpl = HTML::Template->new(filename => '../template/search_message.tmpl.html');	
	$tmpl->param(TOTAL => $total);
	
	print $cgi->header(-type => 'text/html', -charset => 'UTF-8');
	print $tmpl->output;
}

sub send_response
{
	my $cgi  = shift;
	my $data = shift;
	
	my $tmpl = HTML::Template->new(filename => '../template/search_records.tmpl.html');	
	$tmpl->param(LOG_INFO => $data);
	
	print $cgi->header(-type => 'text/html', -charset => 'UTF-8');
	print $tmpl->output;
}
