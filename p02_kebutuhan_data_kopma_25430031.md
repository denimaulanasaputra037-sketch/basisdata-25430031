# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

## 1. Latar Belakang dan Aktivitas Organisasi

Koperasi Mahasiswa Sejahtera (Kopma) adalah koperasi fiktif yang menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembelinya bisa anggota atau umum. Mahasiswa yang ingin menjadi anggota mendaftar dengan NIM, nama, program studi, dan nomor HP, lalu mendapat nomor anggota berformat A-xxxx. Anggota aktif mendapat diskon 5% untuk setiap nota.

Tiga kasir bekerja bergantian per sif. Kasir mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok, dan bila stok suatu barang di bawah batas minimum, ia membuat pesanan pembelian ke pemasok. Ketika barang datang, stok bertambah sesuai faktur pemasok. Setiap awal bulan, ketua koperasi menerima laporan omzet, barang terlaris, barang dengan stok menipis, dan anggota paling aktif.

Masalah yang disampaikan saat wawancara:

- Ketua: harga barang sering naik, sehingga bingung saat melihat nota lama.
- Petugas gudang: kadang stok di buku catatan menjadi minus.
- Kasir: anggota sering lupa membawa kartu, jadi dicari lewat NIM.

## 2. Aktor dan Proses Bisnis

| Kode | Proses Bisnis | Aktor | Pemicu |
| --- | --- | --- | --- |
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |

## 3. Dokumen Sumber yang Dianalisis

Dokumen sumber yang dianalisis adalah **nota penjualan** Kopma dengan nomor PJ-2609-0142 (Gambar 2.5 di buku). Isi nota:

- No. Nota: PJ-2609-0142
- Tanggal: 24-09-2026 10:15
- Kasir: Rina (K03)
- Anggota: A-0457 / Budi S.
- Barang:
  - Pulpen Gel 0.5, qty 3, harga 4.000, subtotal 12.000
  - Buku Tulis 58, qty 2, harga 6.500, subtotal 13.000
  - Air Mineral 600, qty 1, harga 4.000, subtotal 4.000
- Jumlah 29.000; diskon anggota 5% 1.450; total 27.550; bayar tunai 30.000; kembali 2.450

Pembedahan isian nota:

| Isian pada Nota | Jenis | Keterangan |
| --- | --- | --- |
| No. Nota, tanggal-jam | Disimpan | Identitas transaksi |
| Kasir, anggota | Disimpan | Relasi ke Petugas dan Anggota |
| Barang, qty, harga | Disimpan | Harga disimpan saat transaksi (AB-04) |
| Subtotal per baris | Turunan | qty dikali harga |
| Jumlah, diskon, total | Turunan | Dihitung dari subtotal dan status anggota |
| Bayar tunai | Disimpan | Data pembayaran |
| Kembali | Turunan | Bayar dikurangi total |

## 4. Entitas Kandidat dan Elemen Data

| Entitas Kandidat | Elemen Data Utama | Sumber |
| --- | --- | --- |
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

## 5. Aturan Bisnis

| Kode | Aturan Bisnis |
| --- | --- |
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |

## 6. Kebutuhan Informasi

| Kode | Kebutuhan Informasi | Data yang Diperlukan |
| --- | --- | --- |
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
| --- | --- | --- | --- | --- | --- | --- |
| PB-01 Daftar anggota | C | | | | | |
| PB-02 Catat penjualan | R | R, U | C | C | | |
| PB-03 Pesan ke pemasok | | R | | | R | C |
| PB-04 Terima barang | | U | | | R | U |
| PB-05 Laporan bulanan | R | R | R | R | | R |

## 8. Kamus Data Awal

| Elemen | Arti | Contoh | Aturan | Penanggung Jawab |
| --- | --- | --- | --- | --- |
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat ≥ 0 (rupiah) | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat ≥ 0 (AB-03) | Petugas gudang |

## 9. Kebutuhan Non-Fungsional Data

| Kode | Kebutuhan |
| --- | --- |
| NFR-01 | Sistem diperkirakan menangani sekitar 150 nota per hari. |
| NFR-02 | Data transaksi disimpan minimal lima tahun. |
| NFR-03 | Nomor HP anggota bersifat data pribadi dan hanya boleh dilihat oleh ketua. |

## 10. Isu Kualitas Data yang Diantisipasi

1. Harga barang bisa berubah, sehingga nota lama tidak dapat dicek bila harga hanya disimpan di data barang (keluhan ketua koperasi).
2. Stok di buku catatan bisa bernilai minus, sehingga tidak sesuai dengan jumlah barang yang sebenarnya (keluhan petugas gudang).
3. Anggota dicari lewat NIM saat kartu terlupa, sehingga NIM yang salah atau ganda bisa menyebabkan anggota salah dikenali (keluhan kasir).