# **soal-shift-sisop-modul-1-D08-2021**

## **Soal 1**

Ryujin baru saja diterima sebagai IT support di perusahaan Bukapedia. Dia diberikan tugas untuk membuat laporan harian untuk aplikasi internal perusahaan, ticky. Terdapat 2 laporan yang harus dia buat, yaitu laporan daftar peringkat pesan error terbanyak yang dibuat oleh ticky dan laporan penggunaan user pada aplikasi ticky. Untuk membuat laporan tersebut, Ryujin harus melakukan beberapa hal berikut:

    a. Mengumpulkan informasi dari log aplikasi yang terdapat pada file syslog.log. Informasi yang diperlukan antara lain: jenis log (ERROR/INFO), pesan log, dan username pada setiap baris lognya. Karena Ryujin merasa kesulitan jika harus memeriksa satu per satu baris secara manual, dia menggunakan regex untuk mempermudah pekerjaannya. Bantulah Ryujin membuat regex tersebut.
    b. Kemudian, Ryujin harus menampilkan semua pesan error yang muncul beserta jumlah kemunculannya.
    c. Ryujin juga harus dapat menampilkan jumlah kemunculan log ERROR dan INFO untuk setiap user-nya. Setelah semua informasi yang diperlukan telah disiapkan, kini saatnya Ryujin menuliskan semua informasi tersebut ke dalam laporan dengan format file csv.
    d. Semua informasi yang didapatkan pada poin b dituliskan ke dalam file error_message.csv dengan header Error,Count yang kemudian diikuti oleh daftar pesan error dan jumlah kemunculannya diurutkan berdasarkan jumlah kemunculan pesan error dari yang terbanyak.
    e. Semua informasi yang didapatkan pada poin c dituliskan ke dalam file user_statistic.csv dengan header Username,INFO,ERROR diurutkan berdasarkan username secara ascending.

### **Penyelesaian**

```   
   FILE_LOG="/home/syamil/Downloads/syslog.log"
```

Awalnya, path dari syslog.log disimpan ke sebuah variable bernama `FILE_LOG`.

```
   regex='.+: (INFO|ERROR) (.+) \((.+)\)'   
```

Regex yang dipakai juga disimpan ke variable bernama `regex`. Regex ini akan berperan dan melakukan 3 hal, yaitu menyimpan tipe log, pesan, dan usernamenya.

```
   declare -A ERROR 
   declare -A USER_INFO
   declare -A USER_ERROR
```

setelah itu deklarasikan associative array, yang dimana 3 array ini bertugas untuk menyimpan jumlah error per jenisnya, jumlah error per username, dan jumlah info per username.

```
   while IFS= read -r line
   do
      ...
   done < "$FILE_LOG"
```

yang dilakukan pada looping `while` diatas yaitu program akan membaca `$file` baris per baris yang kemudian akan disimpan ke variable `$line`

```
   [[ $line =~ $regex ]]
```

String yang terdapat pada variabel `$line` kemudian diperiksa oleh `$regex`. Jika sesuai, program akan menyimpan string tersebut ke dalam variabel `BASH_REMATCH` bersama dengan string yang terbaca.

```
   if
	 [[ ${BASH_REMATCH[1]} == "ERROR" ]]
   then
	 ((ERROR['${BASH_REMATCH[2]}']++))
	 ((USER_ERROR['${BASH_REMATCH[3]}']++))
   else
	((USER_INFO['${BASH_REMATCH[3]}']++))
   fi
```

Kemudian tipe log yang tersimpan di index kedua `BASH_REMATCH` akan diperiksa. Bila bernilai `ERROR`, maka nilai elemen array `ERROR` yang mempunyai key pesan error yang tersimpan di index ketiga `BASH_REMATCH` dan nilai elemen array `USER_ERROR` yang mempunyai key username yang tersimpan di index keempat akan mengalami increment. Bila nilainya bukan ERROR atau berarti bernilai INFO, maka nilai elemen array userInfo yang mempunyai key username di-increment. Variable yang unset akan bernilai 0, sehingga tidak perlu melakukan pengecekan apakah key tersebut sudah terdapat pada array.

```
   for key in "${!ERROR[@]}"
   do
	printf "%s,%d\n" "$key" "${ERROR[$key]}"
   done | sort -rn -t, -k2 > error_message.csv
```

Pengulangan for diatas akan melakukan loop untuk setiap key di array `ERROR`. pada setiap loopnya, program akan menuliskan nilai dari `$key` dan `${ERROR[$key]}`. Setelah itu, program akan melakukan sort dan akan disimpan ke file `error_message.csv`. Option `-rn` bertujuan agar program akan melakukan penyortiran secara descending dan numerik, option `-t`, akan mengganti field separator menjadi koma dan option `-k` 2 berarti sort dilakukan berdasarkan field kedua.

```
   echo -e "Error,count\n$(cat error_message.csv)" > error_message.csv
```

Sama seperti sebelumna, kode program diatas akan membuat atau menimpa file `user_statistic.csv` dan menuliskan Username,INFO,ERROR.

```
   for key in "${!USER_ERROR[@]}" "${!USER_INFO[@]}"
   do
	printf "%s,%d,%d\n" "$key" "${USER_INFO[$key]}" "${USER_ERROR[$key]}"
   done | sort -u > user_statistic.csv
```

potongan kode diatas juga mirip seperti sebelumnya tetapi di kode ini akan melakukan loop untuk setiap key di 2 array, yaitu pada `USER_ERROR` dan `USER_INFO`, dan menuliskan nilai dari `$key`, `${userInfo[$key]}`, `${userErrors[$key]}`. Hal ini dilakukan agar bila ada username yang hanya mempunyai log bertipe _INFO_ atau _ERROR_ saja tetap akan tertulis. Kemudian hasil dari loop akan di-sort dan ditambahkan ke file `user_statistic.csv`. Karena username bisa saja mempunyai log _INFO_ dan _ERROR_ sehingga menghasilkan baris yang sama, maka perlu menambah option `-u` di sort untuk menghapus baris yang duplikat.

## **Soal 2**
Steven dan Manis mendirikan sebuah startup bernama “TokoShiSop”. Sedangkan kamu dan Clemong adalah karyawan pertama dari TokoShiSop. Setelah tiga tahun bekerja, Clemong diangkat menjadi manajer penjualan TokoShiSop, sedangkan kamu menjadi kepala gudang yang mengatur keluar masuknya barang.

Tiap tahunnya, TokoShiSop mengadakan Rapat Kerja yang membahas bagaimana hasil penjualan dan strategi kedepannya yang akan diterapkan. Kamu sudah sangat menyiapkan sangat matang untuk raker tahun ini. Tetapi tiba-tiba, Steven, Manis, dan Clemong meminta kamu untuk mencari beberapa kesimpulan dari data penjualan “Laporan-TokoShiSop.tsv”.

a. Steven ingin mengapresiasi kinerja karyawannya selama ini dengan mengetahui Row ID dan profit percentage terbesar (jika hasil profit percentage terbesar lebih dari 1, maka 	  ambil Row ID yang paling besar). Karena kamu bingung, Clemong memberikan definisi dari profit percentage, yaitu:
	```Profit Percentage = (Profit/Cost Price) 100```
   Cost Price didapatkan dari pengurangan Sales dengan Profit. (Quantity diabaikan).

b. Clemong memiliki rencana promosi di Albuquerque menggunakan metode MLM. Oleh karena itu, Clemong membutuhkan daftar nama customer pada transaksi tahun 2017 di Albuquerque.

c. TokoShiSop berfokus tiga segment customer, antara lain: Home Office, Customer, dan Corporate. Clemong ingin meningkatkan penjualan pada segmen customer yang paling            sedikit. Oleh karena itu, Clemong membutuhkan segment customer dan jumlah transaksinya yang paling sedikit.

d. TokoShiSop membagi wilayah bagian (region) penjualan menjadi empat bagian, antara lain: Central, East, South, dan West. Manis ingin mencari wilayah bagian (region) yang 
   memiliki total keuntungan (profit) paling sedikit dan total keuntungan wilayah tersebut.
Agar mudah dibaca oleh Manis, Clemong, dan Steven, (e) kamu diharapkan bisa membuat sebuah script yang akan menghasilkan file “hasil.txt” yang memiliki format sebagai berikut:

Transaksi terakhir dengan profit percentage terbesar yaitu *ID Transaksi* dengan persentase *Profit Percentage*%.

Daftar nama customer di Albuquerque pada tahun 2017 antara lain:
*Nama Customer1*
*Nama Customer2* dst

Tipe segmen customer yang penjualannya paling sedikit adalah *Tipe Segment* dengan *Total Transaksi* transaksi.

Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah *Nama Region* dengan total keuntungan *Total Keuntungan (Profit)*


### **Penyelesaian**
- 2.a
```shell
awk -F "\t" '
BEGIN  {max=0}
```
Dideklarasikan variabel ```max``` dengan value 0, yang digunakan untuk menyimpan Presentase Profit terbesar.
```shell
        if(NR>1) { 
                pp=$21/(($18-$21))*100 
                if(pp>=max){
                        max=pp; row=$1}
                }
        } 
```
Karena pada row 1 di dataset merupakan bagian header maka digunakan ```if(NR>1)``` untuk mengabaikan row pertama. Setelahnya pada setiap row diambil data pada kolom ke-18 dan ke-21 untuk perhitungan *Profit Percentage* yang disimpan pada variabel ```pp``` dengan operasi ```$21/(($18-$21))*100```. Jika hasil dari ```pp``` lebih besar dari ```max``` maka value ```max``` diganti dengan value ```pp``` pada row itu, dan value ```row``` diisi dengan ```$1``` yang merupakan Row ID.
```shell
END {printf("Transaksi terakhir dengan profit percentage terbesar yaitu %d dengan persentase %.2f%\n\n">
' Laporan-TokoShiSop.tsv >> hasil.txt
```
Diakhiri dengan printf sesuai dengan format, dimasukkan dalam file ```hasil.txt```

-2.b
```shell
awk -F "\t" '
BEGIN {printf "Daftar nama customer di Albuquerque pada tahun 2017 antara lain:\n"} 
$2~/2017/ && $10~/Albuquerque/ {nama[$7]++}
```
Pertama mencetak output sesuai format. Lalu melooping data, jika data pada kolom ke-2 adalah tahun 2017, dan data kolom ke-3 adalah **Albuquerque** maka diambil data pada kolom ke-7 dalam list ```nama```. 
```shell
END {
        for(i in nama){
                printf("%s\n",i)
        }
printf("\n")
}
' Laporan-TokoShiSop.tsv >> hasil.txt
```
Setelah selesai mengambil data, nama-nama yang tersimpan diprint dengan looping. Output dimasukkan ke file ```hasil.txt```.

-2.c
```shell
awk -F "\t" '
BEGIN {nho=0; ncu=0; nco=0; min=1000000} 
$8~/Home Office/{nho++} $8~/Consumer/{ncu++} $8~/Corporate/{nco++} 
```
Pertama dideklarasikan variabel ```nho``` untuk menyimpan jumlah segmen *Home Office*, ```ncu``` untuk menyimpan jumlah segmen *Consumer*, dan ```nco``` untuk menyimpan jumlah segmen *Corporate*, semua dengan nilai ```0```, dan variabel ```min``` untuk menyimpan value terkecil. Lalu looping untuk mengambil data pada kolom ke-8, setiap kata kunci yang didapat akan menambah value variabelnya masing-masing.
```shell
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
printf("Tipe segmen customer yang penjualannya paling sedikit adalah %s dengan %d transaksi.\n\n",seg,m)
}
' Laporan-TokoShiSop.tsv >> hasil.txt
```
Pada ```END``` diperiksa satu persatu value dari segmen, jika lebih kecil dari ```min``` maka akan diganti oleh segmen tersebut. Setelah itu diprint segmen yang terkecil beserta jumlahnya sesuai dengan format yang ditentukan. Output dimasukkan dalam file ```hasil.txt```.

-2.d
```shell
awk -F "\t" '
BEGIN {C=0; E=0; S=0; W=0; max=1000000}
$13~/Central/{C+=$21} $13~/East/{E+=$21} $13~/South/{S+=$21} $13~/West/{W+=$21}
```
Pertama dideklarasikan variabel ```C``` untuk menyimpan jumlah profit pada bagian *Central*, ```E``` untuk menyimpan jumlah profit pada bagian *East*, ```S``` untuk menyimpan jumlah profit pada bagian *South*, ```W``` untuk menyimpan jumlah profit pada bagian *West*, dan ```max``` untuk menyimpan profit terkecil.
```shell
END {
        if(C<max){
                max=C;
                Reg="Central";
        }
        else if(E<max){
                max=E;
                Reg="East";
        }
        else if(S<max){
                max=S;
                Reg="South";
        }
        else if(W<max){
                max=W;
                Reg="West";
        }
printf("Wilayah bagian (region) yang memiliki total keuntungan (profit) yang paling sedikit adalah %s dengan total keuntungan %.2f.\n",Reg,max)
}
' Laporan-TokoShiSop.tsv >> hasil.txt
```
Lalu dilihat satu-satu value variabel, jika lebih kecil dari ```max``` maka value ```max``` diganti dengan value variabel tadi. Terakhir diprint Region dengan profitnya sesuai format yang ditentukan, dimasukkan ke ```hasil.txt```.



## **Soal 3**


### **3a**
Membuat script untuk mengunduh 23 gambar dari "https://loremflickr.com/320/240/kitten" serta menyimpan log-nya ke file "Foto.log". Karena gambar yang diunduh acak, ada kemungkinan gambar yang sama terunduh lebih dari sekali, oleh karena itu kalian harus menghapus gambar yang sama (tidak perlu mengunduh gambar lagi untuk menggantinya). Kemudian menyimpan gambar-gambar tersebut dengan nama "Koleksi_XX" dengan nomor yang berurutan tanpa ada nomor yang hilang (contoh : Koleksi_01, Koleksi_02, ...)

### **Penyelesaian No 3a**

```   

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
   
```

Fungsi filenames() merupakan fungsi untuk mengubah nama Koleksi_1 s.d Koleksi_9 menjadi Koleksi_01 s.d Koleksi_09.

```   

filenames () {
if [ $1 -le 9 ]
then
        filename="Koleksi_0$1.jpg"
fi
}

```      

Perulangan dibawah ini merupakan perulangan untuk mengunduh 23 gambar kucing dari https://loremflickr.com/320/240/kitten dan mengubah namanya menjadi Koleksi_1 s.d Koleksi_23.

```   

for ((i=1; i<=23; i++))
do
        wget -a Foto.log https://loremflickr.com/320/240/kitten -O "Koleksi_$i.jpg"

   
```

Perulangan dibawah merupakan perulangan untuk membandingkan hasil unduhan. 

```   


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

```

Perulangan dibawah ini merupakan perulangan untuk mengubah nama Koleksi_1 s.d Koleksi_9 menjadi Koleksi_01 s.d Koleksi_09 dengan memanggil fungsi filenames.

```
for ((i=1; i<10; i=i+1))
do
	filenames "$i"
	if [ -f Koleksi_$i.jpg ]
	then
		mv Koleksi_$i.jpg $filename
	fi
done
   
```

### **3b**
Karena Kuuhaku malas untuk menjalankan script tersebut secara manual, ia juga meminta kalian untuk menjalankan script tersebut sehari sekali pada jam 8 malam untuk tanggal-tanggal tertentu setiap bulan, yaitu dari tanggal 1 tujuh hari sekali (1,8,...), serta dari tanggal 2 empat hari sekali(2,6,...). Supaya lebih rapi, gambar yang telah diunduh beserta log-nya, dipindahkan ke folder dengan nama tanggal unduhnya dengan format "DD-MM-YYYY" (contoh : "13-03-2023").

### **Penyelesaian No 3b**

```   
bash "/home/kali/Documents/Shift/soal3a.sh"
presentfile=$(date +"%d-%m-%Y")
mkdir "$presentfile"

mv Koleksi_* "./$presentfile/"
mv Foto.log "./$presentfile/"

```

Menjalankan script dari soal3a.sh dan kemudian membuat folder bernama tanggal unduhnya kemudian memindahkan seluruh file memiliki nama "Koleksi_" dan Foto.log diawalnya kedalam folder tersebut    

```   
0 20 1-31/7,2-31/4 * * bash "/home/kali/Documents/Shift/soal3b.sh"

```

Mengacu pada crontab diatas maka script akan dijalankan pada menti ke 0, script dijalankan ketika menit ke 0, pada jam 20 ( 8 malam ), mulai dari tanggal 1 hingga tanggal 31 setiap 7 hari dan mulai dari tanggal 2 hinggal tanggal 31 setiap 4 hari.

### **3c**
Agar kuuhaku tidak bosan dengan gambar anak kucing, ia juga memintamu untuk mengunduh gambar kelinci dari "https://loremflickr.com/320/240/bunny". Kuuhaku memintamu mengunduh gambar kucing dan kelinci secara bergantian (yang pertama bebas. contoh : tanggal 30 kucing > tanggal 31 kelinci > tanggal 1 kucing > ... ). Untuk membedakan folder yang berisi gambar kucing dan gambar kelinci, nama folder diberi awalan "Kucing_" atau "Kelinci_" (contoh : "Kucing_13-03-2023").

### **Penyelesaian No 3c**

```   
Kucing(){
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

    file=$(date +"%d-%m-%Y")
    mkdir "Kucing_$file"

    mv Koleksi_* "./Kucing_$file/"
    mv Foto.log "./Kucing_$file/"
}

Kelinci(){
    filenames () {
    if [ $1 -le 9 ]
    then
            filename="Koleksi_0$1.jpg"
    fi
    }

    for ((i=1; i<=23; i++))
    do
            wget -a Foto.log https://loremflickr.com/320/240/bunny -O "Koleksi_$i.jpg"
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

    file=$(date +"%d-%m-%Y")
    mkdir "Kelinci_$file"

    mv Koleksi_* "./Kelinci_$file/"
    mv Foto.log "./Kelinci_$file/"
}


Kucing
Kelinci



```

Script didapat dengan memodifikasi soal3a.sh dengan membagi nya menjadi dua fungsi yakni fungsi Kucing() dan fungsi Kelinci(). Serta menambahkan url untuk mengunduh gambar kelinci pada fungsi kelinci. disetiap fungsi terdapat fungsi untuk memindahkan Koleksi ke folder sesuai dengan kategorinya.

Namun script ini belum bisa mengunduh sesuai apa yang dimanta soal yakni mengunduh foto kucing hari ini dan mengunduh foto kelinci di keesokan hari dan seterusnya.

### **3d**
Untuk mengamankan koleksi Foto dari Steven, Kuuhaku memintamu untuk membuat script yang akan memindahkan seluruh folder ke zip yang diberi nama “Koleksi.zip” dan mengunci zip tersebut dengan password berupa tanggal saat ini dengan format "MMDDYYYY" (contoh : “03032003”).

### **Penyelesaian No 3d**

``` 
zip -P 'date+%m%d%Y' -r Koleksi.zip ./*

```
Begitu script dijalankan maka setiap file akan dipindahkan kedalam zip yang bernama Koleksi.zip dan akan diproteksi dengan password berupa tanggal file itu di-zip "MMDDYYYY" 


### **3e**
e.	Karena kuuhaku hanya bertemu Steven pada saat kuliah saja, yaitu setiap hari kecuali sabtu dan minggu, dari jam 7 pagi sampai 6 sore, ia memintamu untuk membuat koleksinya ter-zip saat kuliah saja, selain dari waktu yang disebutkan, ia ingin koleksinya ter-unzip dan tidak ada file zip sama sekali.

### **Penyelesaian No 3e**

``` 

0 7 * * 1-5 bash /home/kali/Documents/Shift/soal3d.sh
0 18 * * 1-5 unzip -P 'date+%m%d%Y' "Koleksi.zip"

```
Pada baris pertama cron untuk menjalankan script soal3d.sh agar setiap file akan dipindahkan kedalam zip yang bernama Koleksi.zip dan akan diproteksi dengan password berupa tanggal file itu di-zip "MMDDYYYY" Zip akan terbuka dengan menjalankan script soal 3d dan dijalankan pada menit 0, pada jam 7 pagi, pada hari pertama hingga hari kelima (senin - jumat).
Cron kedua akan melakukan unzip pada file zip Koleksi.zip pada menit 0, jam 18 (6 malam), pada hari pertama hingga hari kelima (senin-jumat).

