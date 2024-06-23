package Log_line;

use strict;
use warnings;

sub new
{
	my $class = shift;
	my $self  = {};
	
	bless($self, $class);
	
	$self->_init;
	
	return $self;
}

sub _init
{
	my $self = shift;
	
	$self->{LINE}    = '';
	$self->{ITEM}    = [];
	$self->{CREATED} = '';
	$self->{INT_ID}  = '';
	$self->{STR}     = '';
	$self->{FLAG}    = '';
	$self->{ADDRESS} = '';
	$self->{ID}      = '';
}

sub set
{
	my $self = shift;
	my $line = shift;
	
	$self->{LINE} = $self->_trim($line);
	
	$self->_set_item;
	$self->_set_created;
	$self->_set_int_id;
	$self->_set_str;
	$self->_set_flag;
	$self->_set_address;
	$self->_set_id;
}

sub _trim
{
	my $self = shift;	
	my $str  = shift;	
	
	$str =~ s/^\s+//;
	$str =~ s/\s+$//;
	
	return $str;
}

sub _set_item
{
	my $self = shift;
	
	$self->{ITEM} = [split(" ", $self->{LINE})];
}

sub _set_created
{
	my $self = shift;
	
	$self->{CREATED} = "$self->{ITEM}->[0] $self->{ITEM}->[1]";
}

sub _set_int_id
{
	my $self = shift;
	
	$self->{INT_ID} = $self->{ITEM}->[2];
}

sub _set_str
{
	my $self = shift;
	
	$self->{STR} = (split(" ", $self->{LINE}, 3))[2];
}

sub _set_flag
{
	my $self = shift;
	
	$self->{FLAG} = $self->{ITEM}->[3];
}

sub _set_address
{
	my $self    = shift;	
	my $address = $self->{ITEM}->[4];
	
	if(!defined($address))
	{
		$address = '';
	}
	if(!($address =~ /^[A-Z0-9._%+-]+@[A-Z0-9-]+.+.[A-Z]{2,4}$/i))
	{
		$address = '';
	}
		
	$self->{ADDRESS} = $address;
}

sub _set_id
{
	my $self = shift;	
			
	my $id = '';	
	for my $item (@{$self->{ITEM}})
	{
		if($item =~ /id\=/)
		{
			$id = (split("=", $item))[1];
		}
	}
	
	$self->{ID} = $id;
}

sub get
{
	my $self = shift;
	my $str  = shift;
	
	return $self->{uc($str)};
}

return 1;
