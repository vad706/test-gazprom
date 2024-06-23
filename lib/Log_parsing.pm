package Log_parsing;

use strict;
use warnings;

sub new
{
	my $class = shift;
	my $param = {@_};
	
	my $self = {};
	
	$self->{LOG}       = $param->{-log};
	$self->{FH}        = undef;
	$self->{LOG_LINE}  = Log_line->new;
	$self->{LINE}      = '';
	$self->{ATTRIBUTE} = '';
	
	bless($self, $class);
	
	$self->_init;
	
	return $self;
}

sub _init
{
	my $self = shift;
	
	open($self->{FH}, "<", $self->{LOG});
}

sub next
{
	my $self = shift;
	
	return $self->{LINE} = readline($self->{FH}); 
}

sub set_log_line
{
	my $self = shift;
	
	$self->{LOG_LINE}->set($self->{LINE});	
	
	my $flag = $self->{LOG_LINE}->get('flag');
	if($flag eq '<=')
	{
		$self->{ATTRIBUTE} = 'message';
	}
	else
	{
		$self->{ATTRIBUTE} = 'log';
	}
}

sub is_table_message
{
	my $self = shift;
	
	return $self->{ATTRIBUTE} eq 'message';
}

sub set_table_message
{
	my $self  = shift;
	my $param = shift;
	
	$param->{created} = $self->{LOG_LINE}->get('created');
	$param->{id}      = $self->{LOG_LINE}->get('id');
	$param->{int_id}  = $self->{LOG_LINE}->get('int_id');
	$param->{str}     = $self->{LOG_LINE}->get('str');
}

sub set_table_log
{
	my $self  = shift;
	my $param = shift;
	
	$param->{created} = $self->{LOG_LINE}->get('created');
	$param->{int_id}  = $self->{LOG_LINE}->get('int_id');
	$param->{str}     = $self->{LOG_LINE}->get('str');
	$param->{address} = $self->{LOG_LINE}->get('address');
}

sub close
{
	my $self = shift;
	
	close($self->{FH});
}

return 1;
