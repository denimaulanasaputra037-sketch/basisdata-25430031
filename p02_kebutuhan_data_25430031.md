# Dokumen Kebutuhan Data - Perpustakaan Happy Reading 

## 1. Latar Belakang dan Aktivitas Organisasi

Perpustakaan Happy Reading melayani peminjaman buku bagi anggotanya. Anggota meminjam dan mengembalikan buku, petugas mencatat transaksi peminjaman dan pengembalian, dan kepala perpustakaan memantau laporan.

Masalah yang dihadapi saat ini adalah stok buku yang menipis dan keterlambatan pengembalian buku oleh anggota.
## 2. Aktor dan Proses Bisnis

| Kode  | Proses Bisnis               | Aktor                        | Pemicu                                   |
| ----- | --------------------------- | ---------------------------- | ---------------------------------------- |
| PB-01 | Pendaftaran Anggota         | Anggota, Petugas             | Calon anggota ingin mendaftar            |
| PB-02 | Pengelolaan Data Buku       | Petugas                      | Ada buku baru atau data buku berubah     |
| PB-03 | Peminjaman Buku             | Anggota, Petugas             | Anggota ingin meminjam buku              |
| PB-04 | Pengembalian Buku           | Anggota, Petugas             | Anggota mengembalikan buku               |
| PB-05 | Pembuatan Laporan           | Petugas, Kepala Perpustakaan | Laporan diperlukan (misalnya tiap bulan) |
| PB-06 | Pengelolaan Data Petugas    | Kepala Perpustakaan          | Petugas baru masuk atau berhenti         |
| PB-07 | Pengubahan Status Anggota   | Kepala Perpustakaan          | Keanggotaan perlu dinonaktifkan          |
| PB-08 | Pencatatan Pembayaran Denda | Anggota, Petugas             | Anggota membayar denda                   |
## 3. Dokumen Sumber yang Dianalisis

Dokumen sumber yang digunakan adalah formulir pendaftaran anggota perpustakaan. Formulir ini dibuat sebagai contoh untuk melihat data apa saja yang perlu disimpan dalam sistem.

### Contoh Formulir Pendaftaran Anggota

**FORMULIR PENDAFTARAN ANGGOTA PERPUSTAKAAN**

- No. Anggota : AG001
- NIM : 25433454
- Nama : Joni
- No. HP : 08123456789
- Status Anggota : Aktif
- Tanggal Daftar : 05-10-2026
- Petugas : Agus

### Pembedahan Dokumen Sumber

Dari formulir tersebut, data yang dibutuhkan adalah:

| No | Data           | Keterangan                        | Disimpan / Dihitung |
|----|----------------|-----------------------------------|---------------------|
| 1  | No. Anggota    | Identitas anggota                 | Disimpan            |
| 2  | NIM            | Nomor identitas mahasiswa         | Disimpan            |
| 3  | Nama           | Nama anggota                      | Disimpan            |
| 4  | No. HP         | Nomor telepon anggota             | Disimpan            |
| 5  | Status Anggota | Menunjukkan status anggota        | Disimpan            |
| 6  | Tanggal Daftar | Tanggal anggota terdaftar         | Disimpan            |
| 7  | Petugas        | Petugas yang mencatat pendaftaran | Disimpan            |

Data dari formulir tersebut digunakan sebagai dasar untuk menentukan entitas dan elemen data pada sistem perpustakaan.

## 4. Entitas Kandidat dan Elemen Data

| Entitas           | Elemen Data Utama | Sumber |
| ----------------- | ----------------- | ------ |
| Anggota           |     no_anggota, nim_anggota, nama_anggota, no_hp_anggota, status_anggota, tgl_daftar               |    Formulir pendaftaran anggota    |
| Petugas           |   id_petugas, nama_petugas                 |   Data kepegawaian     |
| Buku              |     kode_buku, judul_buku, pengarang, tahun_terbit, stok_buku              |  Daftar buku       |
| Peminjaman        |    no_peminjaman, tgl_peminjaman, tgl_jatuh_tempo, jumlah_buku (turunan)               |    Slip peminjaman    |
| Detail Peminjaman |        no_peminjaman, kode_buku            |       Slip peminjaman   |
| Pengembalian      |             no_pengembalian, tgl_pengembalian       |Slip pengembalian        |
| Denda             |            id_denda, hari_terlambat (turunan), tarif_denda_harian, jumlah_denda (turunan), status_bayar        |   Slip pengembalian      |


## 5. Aturan Bisnis

| Kode | Aturan Bisnis |
| --- | --- |
| AB-01 | Setiap anggota memiliki nomor anggota yang unik. |
| AB-02 | Setiap anggota hanya dapat terdaftar satu kali. |
| AB-03 | Hanya anggota aktif yang dapat melakukan peminjaman. |
| AB-04 | Setiap transaksi peminjaman harus dilakukan oleh anggota yang terdaftar. |
| AB-05 | Setiap transaksi peminjaman memiliki minimal satu buku. |
| AB-06 | Buku hanya dapat dipinjam jika stoknya lebih dari 0. |
| AB-07 | Setiap pengembalian harus mengacu pada transaksi peminjaman. |
| AB-08 | Keterlambatan pengembalian dikenakan denda Rp5.000 per hari. |
| AB-09 | Setiap transaksi peminjaman dan pengembalian dicatat oleh petugas. |
| AB-10 | Setiap buku harus memiliki kode buku yang jelas. |
| AB-11 | Satu transaksi peminjaman maksimal 7 buku. |
| AB-12 | Lama peminjaman maksimal 7 hari. | 
                     |
## 6. Kebutuhan Informasi

| Kode | Kebutuhan Informasi | Data yang diperlukan |
| --- | --- | --- |
| KI-01 | Daftar anggota yang berstatus aktif | no_anggota, nama_anggota, status_anggota |
| KI-02 | Daftar buku yang stoknya masih tersedia | kode_buku, judul_buku, stok_buku |
| KI-03 | Daftar buku dengan stok paling sedikit | kode_buku, judul_buku, stok_buku |
| KI-04 | Daftar buku yang sedang dipinjam | kode_buku, judul_buku, no_peminjaman, tgl_peminjaman |
| KI-05 | Daftar anggota yang terlambat mengembalikan buku | no_anggota, nama_anggota, tgl_jatuh_tempo, tgl_pengembalian, hari_terlambat |
| KI-06 | Daftar denda anggota yang belum dibayar | no_anggota, nama_anggota, jumlah_denda, status_bayar |

## 7. Matriks CRUD

Keterangan: C = Create, R = Read, U = Update, D = Delete.

| Proses Bisnis | Anggota | Petugas | Buku | Peminjaman | Detail Peminjaman | Pengembalian | Denda |
| --- | --- | --- | --- | --- | --- | --- | --- |
| PB-01 Pendaftaran Anggota | C | R | - | - | - | - | - |
| PB-02 Pengelolaan Data Buku | - | R | C/U/D | - | - | - | - |
| PB-03 Peminjaman Buku | R | R | R/U | C | C | - | - |
| PB-04 Pengembalian Buku | R | R | U | R/U | U | C | C |
| PB-05 Pembuatan Laporan | R | R | R | R | R | R | R |
| PB-06 Pengelolaan Data Petugas | - | C/U/D | - | - | - | - | - |
| PB-07 Pengubahan Status Anggota | R/U | - | - | - | - | - | - |
| PB-08 Pencatatan Pembayaran Denda | R | R | - | - | - | R | R/U |

## 8. Kamus Data

| No | Elemen Data | Arti | Contoh | Aturan | Penanggung Jawab |
| --- | --- | --- | --- | --- | --- |
| 1 | no_anggota | Nomor anggota | AG001 | Unik, format AG + 3 digit | Petugas |
| 2 | nim_anggota | NIM anggota | 25433454 | 8 digit angka | Petugas |
| 3 | nama_anggota | Nama anggota | Joni | Wajib diisi | Petugas |
| 4 | no_hp_anggota | Nomor HP anggota | 08123456789 | Angka, wajib diisi | Petugas |
| 5 | status_anggota | Status anggota | Aktif | Aktif atau Nonaktif | Petugas |
| 6 | tgl_daftar | Tanggal anggota terdaftar | 05-10-2026 | Format DD-MM-YYYY | Petugas |
| 7 | id_petugas | ID petugas | PT001 | Unik, format PT + 3 digit | Kepala Perpustakaan |
| 8 | nama_petugas | Nama petugas | Agus | Wajib diisi | Kepala Perpustakaan |
| 9 | kode_buku | Kode buku | BK001 | Unik, format BK + 3 digit | Petugas |
| 10 | judul_buku | Judul buku | Basis Data | Wajib diisi | Petugas |
| 11 | pengarang | Nama pengarang | Budi | Wajib diisi | Petugas |
| 12 | tahun_terbit | Tahun terbit buku | 2024 | 4 digit angka | Petugas |
| 13 | stok_buku | Jumlah buku tersedia | 5 | Bilangan bulat, tidak boleh kurang dari 0 | Petugas |
| 14 | no_peminjaman | Nomor transaksi peminjaman | PM001 | Unik, format PM + 3 digit | Petugas |
| 15 | tgl_peminjaman | Tanggal peminjaman | 05-10-2026 | Format DD-MM-YYYY | Petugas |
| 16 | tgl_jatuh_tempo | Batas pengembalian | 12-10-2026 | Maksimal 7 hari dari tgl_peminjaman | Petugas |
| 17 | jumlah_buku (turunan) | Jumlah buku yang dipinjam | 2 | Maksimal 7 | Petugas |
| 18 | no_pengembalian | Nomor transaksi pengembalian | PG001 | Unik, format PG + 3 digit | Petugas |
| 19 | tgl_pengembalian | Tanggal pengembalian | 13-10-2026 | Format DD-MM-YYYY | Petugas |
| 20 | hari_terlambat (turunan) | Jumlah hari keterlambatan | 1 | Tgl pengembalian dikurangi tgl jatuh tempo, tidak kurang dari 0 | Petugas |
| 21 | id_denda | ID denda | DN001 | Unik, format DN + 3 digit | Petugas |
| 22 | tarif_denda_harian | Tarif denda per hari | 5000 | Rp5.000 per hari | Petugas |
| 23 | jumlah_denda (turunan) | Besarnya denda | 5000 | Hari terlambat dikali tarif harian | Petugas |
| 24 | status_bayar | Status pembayaran denda | Belum Lunas | Lunas atau Belum Lunas | Petugas |

## 9. Kebutuhan Non-Fungsional Data

| Kode | Kebutuhan |
| --- | --- |
| NFR-01 | Data anggota hanya boleh diakses oleh petugas dan Kepala Perpustakaan. |
| NFR-02 | Data transaksi peminjaman dan pengembalian harus disimpan sebagai riwayat. |
| NFR-03 | Nomor transaksi peminjaman dan pengembalian harus unik; sistem menolak nomor yang sama bila dimasukkan dua kali. |
| NFR-04 | Data transaksi perpustakaan disimpan minimal selama 5 tahun. |
| NFR-05 | Sistem diperkirakan menangani sekitar 65 transaksi per hari. |

### Data Pribadi dan Hak Akses

| Data Pribadi | Yang Boleh Mengakses |
| --- | --- |
| Nama anggota | Petugas dan Kepala Perpustakaan |
| NIM anggota | Petugas dan Kepala Perpustakaan |
| Nomor HP anggota | Petugas dan Kepala Perpustakaan |
| Riwayat peminjaman | Petugas dan Kepala Perpustakaan |
### Parameter P

NIM = 25430031

2 digit terakhir NIM = 31

P = (31 mod 9) + 1

P = 4 + 1

**P = 5**

Berdasarkan nilai P = 5:

- Batas maksimal item per transaksi = P + 2 = **7 buku** (dipakai di AB-11)
- Denda harian = P ribu rupiah = **Rp5.000 per hari** (dipakai di AB-08)
- Perkiraan volume transaksi harian = 40 + (5 × P) = **65 transaksi** (dipakai di NFR-05)

## 10. Isu Kualitas Data
    
Beberapa masalah data yang mungkin terjadi adalah:

1. Data anggota bisa salah atau tidak lengkap.
2. Data stok buku bisa tidak sesuai dengan jumlah buku yang sebenarnya, sehingga stok terlihat menipis padahal buku masih ada.
3. Data peminjaman harus dicatat dengan benar agar riwayat transaksi tidak salah.
4. Data denda harus sesuai dengan keterlambatan pengembalian.
5. Tanggal pengembalian yang salah catat bisa membuat denda keterlambatan salah hitung.

