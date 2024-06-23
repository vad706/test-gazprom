package Data_store;

use strict;
use warnings;

sub new
{
	my $class = shift;
		
	my $self = {};
	
	$self->{DSN} = "dbi:mysql:database=gazprom;host=localhost;port=3306";
	$self->{DBH} = undef;
		
	bless($self, $class);
	
	$self->_init;
	
	return $self;
}

sub _init
{
	my $self = shift;
	
	$self->{DBH} = DBI->connect($self->{DSN}, 'username', 'password', {RaiseError => 1, PrintError => 1, AutoCommit => 0});
	
	$self->{DBH}->begin_work;
	
	$self->{STH_TL} = undef;
	$self->{STH_SR} = undef;
	
	$self->{STH_MESSAGE} = $self->{DBH}->prepare("INSERT INTO message VALUES (?, ?, ?, ?, ?)");
	$self->{STH_LOG}     = $self->{DBH}->prepare("INSERT INTO log VALUES (?, ?, ?, ?)");
}

sub insert_to_message
{
	my $self  = shift;
	my $param = shift;
	
	$self->{STH_MESSAGE}->bind_param(1, $param->{created});
	$self->{STH_MESSAGE}->bind_param(2, $param->{id});
	$self->{STH_MESSAGE}->bind_param(3, $param->{int_id});
	$self->{STH_MESSAGE}->bind_param(4, $param->{str});
	$self->{STH_MESSAGE}->bind_param(5, undef);
	
	$self->{STH_MESSAGE}->execute;
}

sub insert_to_log
{
	my $self  = shift;
	my $param = shift;
	
	$self->{STH_LOG}->bind_param(1, $param->{created});
	$self->{STH_LOG}->bind_param(2, $param->{int_id});
	$self->{STH_LOG}->bind_param(3, $param->{str});
	$self->{STH_LOG}->bind_param(4, $param->{address});
	
	$self->{STH_LOG}->execute;
}

sub get_total_lines
{
	my $self  = shift;
	my $param = shift;
	
	$self->{STH_TL} = $self->{DBH}->prepare("
		SELECT count(*) AS total_lines FROM message WHERE str LIKE ?
		UNION ALL
		SELECT count(*) AS total_lines FROM log WHERE str LIKE ?
	");
	$self->{STH_TL}->bind_param(1, "%$param%");
	$self->{STH_TL}->bind_param(2, "%$param%");
	$self->{STH_TL}->execute;
	
	my $array = $self->{STH_TL}->fetchall_arrayref({});
	
	return $array->[0]->{total_lines} + $array->[1]->{total_lines};
}

sub get_search_result
{
	my $self  = shift;
	my $param = shift;
	
	$self->{STH_SR} = $self->{DBH}->prepare("
		SELECT created, str FROM message WHERE str LIKE ?
		UNION ALL
		SELECT created, str FROM log WHERE str LIKE ?
		ORDER BY created
		LIMIT 100
	");
	$self->{STH_SR}->bind_param(1, "%$param%");
	$self->{STH_SR}->bind_param(2, "%$param%");
	$self->{STH_SR}->execute;
	
	return $self->{STH_SR}->fetchall_arrayref({});
}

sub close
{
	my $self = shift;
	
	$self->{DBH}->commit;	
	$self->{DBH}->disconnect;
}

return 1;
