# Dokumen Kebutuhan Data - Perpustakaan

## 1. Latar Belakang dan Aktivitas Organisasi

Perpustakaan digunakan untuk mengelola data anggota, buku, peminjaman, pengembalian, dan denda. Sistem ini membantu petugas dalam mencatat data dan melihat informasi yang dibutuhkan.

## 2. Aktor dan Proses Bisnis

| Kode  | Proses Bisnis         | Aktor                        |
| ----- | --------------------- | ---------------------------- |
| PB-01 | Pendaftaran Anggota   | Anggota, Petugas             |
| PB-02 | Pengelolaan Data Buku | Petugas                      |
| PB-03 | Peminjaman Buku       | Anggota, Petugas             |
| PB-04 | Pengembalian Buku     | Anggota, Petugas             |
| PB-05 | Pembuatan Laporan     | Petugas, Kepala Perpustakaan |
## 3. Dokumen Sumber yang Dianalisis

Dokumen sumber yang digunakan adalah formulir pendaftaran anggota perpustakaan. Formulir ini digunakan untuk mencatat data anggota seperti nomor anggota, NIM, nama, nomor HP, dan status anggota.

## 4. Entitas Kandidat dan Elemen Data

Kandidat entitas yang digunakan:

* Anggota
* Petugas
* Buku
* Peminjaman
* Detail Peminjaman
* Pengembalian
* Denda
## 5. Aturan Bisnis

| Kode  | Aturan Bisnis                                                            |
| ----- | ------------------------------------------------------------------------ |
| AB-01 | Setiap anggota memiliki nomor anggota yang unik.                         |
| AB-02 | Setiap anggota hanya dapat terdaftar satu kali.                          |
| AB-03 | Hanya anggota aktif yang dapat melakukan peminjaman.                     |
| AB-04 | Setiap transaksi peminjaman harus dilakukan oleh anggota yang terdaftar. |
| AB-05 | Setiap transaksi peminjaman memiliki minimal satu buku.                  |
| AB-06 | Buku yang sedang dipinjam tidak dapat dipinjam oleh anggota lain.        |
| AB-07 | Setiap pengembalian harus mengacu pada transaksi peminjaman.             |
| AB-08 | Anggota yang terlambat mengembalikan buku dikenakan denda.               |
| AB-09 | Setiap transaksi peminjaman dan pengembalian dicatat oleh petugas.       |
| AB-10 | Data buku harus memiliki identitas buku yang jelas.                      |
## 6. Kebutuhan Informasi

| Kode  | Kebutuhan Informasi                                  |
| ----- | ---------------------------------------------------- |
| KI-01 | Informasi data anggota aktif.                        |
| KI-02 | Informasi buku yang tersedia.                        |
| KI-03 | Informasi buku yang sedang dipinjam.                 |
| KI-04 | Informasi anggota yang terlambat mengembalikan buku. |
| KI-05 | Informasi denda anggota.                             |
## 7. Matriks CRUD

Keterangan: C = Create, R = Read, U = Update, D = Delete.

| Proses Bisnis               | Anggota | Petugas | Buku  | Peminjaman | Detail Peminjaman | Pengembalian | Denda |
| --------------------------- | ------- | ------- | ----- | ---------- | ----------------- | ------------ | ----- |
| PB-01 Pendaftaran Anggota   | C       | R       | -     | -          | -                 | -            | -     |
| PB-02 Pengelolaan Data Buku | -       | R       | C/U/D | -          | -                 | -            | -     |
| PB-03 Peminjaman Buku       | R       | R       | R/U   | C          | C                 | -            | -     |
| PB-04 Pengembalian Buku     | R       | R       | U     | R/U        | U                 | C            | C     |
| PB-05 Pembuatan Laporan     | R       | R       | R     | R          | R                 | R            | R     |
## 8. Kamus Data

| No | Elemen Data        | Keterangan                 | Contoh      | Penanggung Jawab |
| -- | ------------------ | -------------------------- | ----------- | ---------------- |
| 1  | `no_anggota`       | Nomor anggota              | AG001       | Petugas          |
| 2  | `nim_anggota`      | NIM anggota                | 25430031    | Petugas          |
| 3  | `nama_anggota`     | Nama anggota               | Deni        | Petugas          |
| 4  | `no_hp_anggota`    | Nomor HP anggota           | 08123456789 | Petugas          |
| 5  | `status_anggota`   | Status anggota             | Aktif       | Petugas          |
| 6  | `id_petugas`       | ID petugas                 | PT001       | Admin            |
| 7  | `nama_petugas`     | Nama petugas               | Andi        | Admin            |
| 8  | `kode_buku`        | Kode buku                  | BK001       | Petugas          |
| 9  | `judul_buku`       | Judul buku                 | Basis Data  | Petugas          |
| 10 | `pengarang`        | Nama pengarang             | Budi        | Petugas          |
| 11 | `tahun_terbit`     | Tahun terbit buku          | 2024        | Petugas          |
| 12 | `stok_buku`        | Jumlah buku tersedia       | 5           | Petugas          |
| 13 | `no_peminjaman`    | Nomor transaksi peminjaman | PM001       | Petugas          |
| 14 | `tgl_peminjaman`   | Tanggal peminjaman         | 05-10-2026  | Petugas          |
| 15 | `tgl_jatuh_tempo`  | Batas pengembalian         | 12-10-2026  | Petugas          |
| 16 | `jumlah_buku`      | Jumlah buku yang dipinjam  | 2           | Petugas          |
| 17 | `tgl_pengembalian` | Tanggal pengembalian       | 13-10-2026  | Petugas          |
| 18 | `hari_terlambat`   | Jumlah hari keterlambatan  | 1           | Petugas          |
| 19 | `id_denda`         | ID denda                   | DN001       | Petugas          |
| 20 | `jumlah_denda`     | Besarnya denda             | 5000        | Petugas          |
## 8. Kamus Data

| No | Elemen Data        | Keterangan                 | Contoh      | Penanggung Jawab |
| -- | ------------------ | -------------------------- | ----------- | ---------------- |
| 1  | `no_anggota`       | Nomor anggota              | AG001       | Petugas          |
| 2  | `nim_anggota`      | NIM anggota                | 25430031    | Petugas          |
| 3  | `nama_anggota`     | Nama anggota               | Deni        | Petugas          |
| 4  | `no_hp_anggota`    | Nomor HP anggota           | 08123456789 | Petugas          |
| 5  | `status_anggota`   | Status anggota             | Aktif       | Petugas          |
| 6  | `id_petugas`       | ID petugas                 | PT001       | Admin            |
| 7  | `nama_petugas`     | Nama petugas               | Andi        | Admin            |
| 8  | `kode_buku`        | Kode buku                  | BK001       | Petugas          |
| 9  | `judul_buku`       | Judul buku                 | Basis Data  | Petugas          |
| 10 | `pengarang`        | Nama pengarang             | Budi        | Petugas          |
| 11 | `tahun_terbit`     | Tahun terbit buku          | 2024        | Petugas          |
| 12 | `stok_buku`        | Jumlah buku tersedia       | 5           | Petugas          |
| 13 | `no_peminjaman`    | Nomor transaksi peminjaman | PM001       | Petugas          |
| 14 | `tgl_peminjaman`   | Tanggal peminjaman         | 05-10-2026  | Petugas          |
| 15 | `tgl_jatuh_tempo`  | Batas pengembalian         | 12-10-2026  | Petugas          |
| 16 | `jumlah_buku`      | Jumlah buku yang dipinjam  | 2           | Petugas          |
| 17 | `tgl_pengembalian` | Tanggal pengembalian       | 13-10-2026  | Petugas          |
| 18 | `hari_terlambat`   | Jumlah hari keterlambatan  | 1           | Petugas          |
| 19 | `id_denda`         | ID denda                   | DN001       | Petugas          |
| 20 | `jumlah_denda`     | Besarnya denda             | 5000        | Petugas          |
## 10. Isu Kualitas Data

Beberapa masalah data yang mungkin terjadi adalah:

1. Data anggota bisa salah atau tidak lengkap.
2. Data buku bisa memiliki jumlah stok yang tidak sesuai.
3. Data peminjaman harus dicatat dengan benar agar riwayat transaksi tidak salah.
4. Data denda harus sesuai dengan keterlambatan pengembalian.
## 11. Analisis dan Perbaikan Kebutuhan

### 11.1 Analisis Penyimpanan Data Transaksi

Menurut saya, data transaksi perlu disimpan karena bisa menjadi riwayat dari transaksi yang sudah dilakukan. Jadi, kita masih bisa melihat transaksi yang pernah terjadi sebelumnya.

### 11.2 Analisis Penyimpanan Data Hasil Perhitungan

Menurut saya, data tersebut perlu disimpan karena bisa digunakan sebagai riwayat. Jadi, data yang sudah ada sebelumnya tetap bisa dilihat.

### 11.3 Analisis Matriks CRUD

Menurut saya, kalau ada data yang belum mempunyai C, berarti belum ada proses untuk menambahkan data tersebut. Jadi, perlu dibuat proses untuk menambahkan data tersebut.

### 11.4 Perbaikan Kebutuhan yang Masih Umum

1. **Data anggota harus aman**  
   Diubah menjadi: Data anggota hanya boleh diakses oleh petugas dan admin.

2. **Sistem harus cepat mencari buku**  
   Diubah menjadi: Sistem dapat menampilkan data buku yang dicari pengguna dalam waktu maksimal 3 detik.

3. **Laporan stok harus akurat**  
   Diubah menjadi: Jumlah stok pada laporan harus sama dengan jumlah buku yang tersedia di sistem.