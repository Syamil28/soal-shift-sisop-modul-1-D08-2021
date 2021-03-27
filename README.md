# soal-shift-sisop-modul-1-D08-2021

## 2
- 2.a
```shell
awk -F "\t" '
BEGIN  {max=0} {
        if(NR>1) { 
                pp=$21/(($18-$21))*100 
                if(pp>=max){
                        max=pp; row=$1}
                }
        } 
```
Pada bagian awal dideklarasikan variabel ```max``` dengan value 0, yang digunakan untuk menyimpan Presentase Profit terbesar.
```shell
END {printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%\n\n">
' Laporan-TokoShiSop.tsv >> hasil.txt
```
