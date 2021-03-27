#!/bin/bash

awk -F "\t" '
BEGIN  {max=0} {
        if(NR>1) { 
                pp=$21/(($18-$21))*100 
                if(pp>=max){
                        max=pp; row=$1}
                }
        } 
END {printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%\n\n",row,max)}
' Laporan-TokoShiSop.tsv >> hasil.txt

awk -F "\t" '
BEGIN {printf "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:\n"} 
$2~/2017/ && $10~/Albuquerque/ {nama[$7]++}
END {
        for(i in nama){
                printf("%s\n",i)
        }
printf("\n")
}
' Laporan-TokoShiSop.tsv >> hasil.txt

awk -F "\t" '
BEGIN {nho=0; ncu=0; nco=0; min=1000000} 
$8~/Home Office/{nho++} $8~/Consumer/{ncu++} $8~/Corporate/{nco++} 
END {
        if(nho<min){
                min=nho;
                seg="Home Office";
        }
        else if(ncu<min){
                min=ncu;
                seg="Consumer";
        }
        else if(nco<min){
                min=nco;
                seg="Corporate";
        }
printf("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n\n",seg,min)
}
' Laporan-TokoShiSop.tsv >> hasil.txt

awk -F "\t" '
BEGIN {C=0; E=0; S=0; W=0; max=0}
$13~/Central/{C+=$21} $13~/East/{E+=$21} $13~/South/{S+=$21} $13~/West/{W+=$21} 
END {
        if(C>max){
                max=C;
                Reg="Central";
        }
        else if(E>max){
                max=E;
                Reg="East";
        }
        else if(S>max){
                max=S;
                Reg="South";
        }
        else if(W>max){
                max=W;
                Reg="West";
        }
printf("Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.2f.\n\n",Reg,max)
}
' Laporan-TokoShiSop.tsv >> hasil.txt
