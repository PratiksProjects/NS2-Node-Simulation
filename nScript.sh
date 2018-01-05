for i in {1..10}
  do
    echo "On error percentage $i"
    for j in {1..20}
      do
	echo "ns part1-old.tcl $i-$j.tr $i $j" | bash
        echo "java ECE4607 $i-$j.tr" | bash
	echo "rm -rf $i-$j.tr" | bash
    done
done
