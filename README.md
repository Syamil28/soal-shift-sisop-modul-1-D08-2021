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
