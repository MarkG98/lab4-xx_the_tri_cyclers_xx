# Load numbers
addi $t0,$zero,30
addi $t1,$zero,2
addi $t2,$zero,20
addi $t3,$zero,10

# Test Subtract
sub $s0,$t0,$t1 #s0 = 30 - 2
sub $s1,$t0,$t2 #s1 = 30 - 20
sub $s2,$t2,$t1 #s2 = 20 - 2

# Test xori
xori $s3,$t2,21 # s3 = 20^21
xori $s4,$t3,5 #s4 = 10^5
xori $s5,$t2,10 #s5 = 20^10 
