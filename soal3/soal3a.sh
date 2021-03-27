#!/bin/bash

filenames () {
if [ $1 -le 9 ]
then
        filename="Koleksi_0$1.jpg"
fi
}

for ((i=1; i<=23; i++))
do
        wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_$i.jpg"
        for ((j=1; j<i; j++))
        do
		    check=$(cmp Koleksi_$i.jpg Koleksi_$j.jpg)
		    dif=$?
		    if [ $dif -eq 0 ]	      	
            then
                rm Koleksi_$i.jpg
			    i=$(($i-1))
                break
            fi
        done
done

for ((i=1; i<10; i=i+1))
do
	filenames "$i"
	if [ -f Koleksi_$i.jpg ]
	then
		mv Koleksi_$i.jpg $filename
	fi
done


