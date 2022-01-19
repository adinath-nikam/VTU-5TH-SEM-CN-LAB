# Initialization
#Create a ns simulator
set ns [new Simulator] 

set nf [open tw1.nam w] 
$ns namtrace-all $nf 

set nd [open tw1.tr w] 
$ns trace-all $nd

proc finish { } {
global ns nf nd
$ns flush-trace 
close $nf
close $nd
exec nam tw1.nam &
exit 0
}

set n0 [$ns node] 
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail 
$ns duplex-link $n1 $n2 0.5Mb 10ms DropTail

$ns queue-limit $n1 $n2 5

set udp0 [new Agent/UDP] 
$ns attach-agent $n0 $udp0
set sink [new Agent/Null]
$ns attach-agent $n2 $sink
$ns connect $udp0 $sink

set cbr0 [new Application/Traffic/CBR] 
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

$ns at 0.2 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

$ns at 5.0 "finish"

$ns run
