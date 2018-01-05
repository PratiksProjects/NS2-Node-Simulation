#Create a simulator object

set ns [new Simulator]
set fname [lindex $argv 0]
set err [lindex $argv 1]
set sd [lindex $argv 2]
set outfile1  [open  "newrenocwnd1"  w]
set outfile2  [open  "newrenocwnd2"  w]

# seed the default RNG
 global defaultRNG
 $defaultRNG seed $sd

#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

set tf [open $fname w]
$ns trace-all $tf
#Define a 'finish' procedure
proc finish {} {
        global ns nf tf
        $ns flush-trace
	#Close the trace file
        close $nf
	#Execute nam on the trace file
	close $tf
        #exec nam out.nam &
        exit 0
}

#Create the nodes
set s1 [$ns node]
set s2 [$ns node]
set r1 [$ns node]
set r2 [$ns node]
set r3 [$ns node]
set d1 [$ns node]
set d2 [$ns node]

#add node labels
$s1 label "s1"
$s2 label "s2"
$r1 label "r1"
$r2 label "r2"
$r3 label "r3"
$d1 label "d1"
$d2 label "d2"

#Create a duplex link between the nodes
$ns duplex-link $s1 $r1 20Mb 2ms DropTail
$ns duplex-link $s2 $r1 10Mb 5ms DropTail
$ns duplex-link $r1 $r2 20Mb 40ms DropTail
$ns duplex-link $r2 $r3 10Mb 45ms DropTail
$ns duplex-link $r3 $d1 20Mb 3ms DropTail
$ns duplex-link $r3 $d2 10Mb 5ms DropTail

#Create a TCP agent and attach it to node n0
set tcp0 [new Agent/TCP/Newreno]
$tcp0 set fid_ 1
$ns attach-agent $s1 $tcp0
set sink [new Agent/TCPSink]
#set sink [new Agent/TCPSink/Sack1]
$ns attach-agent $d1 $sink
$ns connect $tcp0 $sink

# Create a FTP traffic source and attach it to tcp0
set ftp0 [new Application/FTP]
$ftp0 set type_ FTP
$ftp0 set packetSize_ 1500
$ftp0 set interval_ 0.005
$ftp0 attach-agent $tcp0

#Create a TCP agent and attach it to node n0
set tcp1 [new Agent/TCP/Newreno]
$tcp1 set fid_ 1
$ns attach-agent $s2 $tcp1
set sink [new Agent/TCPSink]
#set sink [new Agent/TCPSink/Sack1]
$ns attach-agent $d2 $sink
$ns connect $tcp1 $sink

# Create a FTP traffic source and attach it to tcp0
set ftp1 [new Application/FTP]
$ftp1 set type_ FTP
$ftp1 set packetSize_ 1500
$ftp1 set interval_ 0.005
$ftp1 attach-agent $tcp1

# Create a uniform distribution random variable
#set loss_random_variable [new RandomVariable/Uniform]
#$loss_random_variable set min_ 0
#$loss_random_variable set max_ 1000

# Create a loss module for the first link
#set loss_module0 [new ErrorModel]
#$loss_module0 drop-target [new Agent/Null]
#$loss_module0 set rate_ $err
#$loss_module0 ranvar $loss_random_variable
#$ns lossmodel $loss_module0 $r1 $r2

#Schedule events for the FTP agent
$ns at 0.0 "$ftp0 start"
$ns at 0.0 "$ftp1 start"
$ns  at  0.0  "plotWindow $tcp0  $outfile1"
$ns  at  0.0  "plotWindow $tcp1  $outfile2"
#stop after 100 seconds
$ns at 100.0 "$ftp0 stop"
$ns at 100.0 "$ftp1 stop"
#Call the finish procedure after 100 seconds of simulation time
$ns at 100.0 "finish"
#Run the simulation
proc plotWindow {tcpSource outfile} {
     global ns

     set now [$ns now]
     set cwnd [$tcpSource set cwnd_]

  ###Print TIME CWND   for  gnuplot to plot progressing on CWND
     puts  $outfile  "$cwnd"

     $ns at [expr $now+0.1] "plotWindow $tcpSource  $outfile"
  }

$ns run
