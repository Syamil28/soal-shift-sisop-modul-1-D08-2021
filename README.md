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

Regex yang dipakai juga disimpan ke variable bernama `regex`. Regex ini akan berperan dan melakukan 3 hal, yaitu tipe log, pesan, dan usernamenya.

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
   


