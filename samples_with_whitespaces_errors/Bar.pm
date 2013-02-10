package Bar; 

# In the sub tabs are used instead of spaces
sub double {
	my ($number) = @_;
	
	return 2*$number;
}

# In the sub there are spaces in the end of lines
sub triple {
    my ($number) = @_;    
    
    return 2*$number; 
}

# There is no \n in the last line
1; 