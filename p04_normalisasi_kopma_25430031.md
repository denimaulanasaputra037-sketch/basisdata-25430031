# P04 Normalisasi Kopma

- Nama : Deni Maulaa Saputra
- NIM  : 25430031
- Modul: 4 - Normalisasi dan Skema Relasional

## 1. Anomali pada spreadsheet lama

| Jenis | Bukti dari Gambar 4.1 |
|---|---|
| Ubah | Anggota yang sama ditulis "Budi S." (PJ-0142) dan "Budi Santoso" (PJ-0150); pemasok ditulis "CV Sumber ATK" dan "CV. Sumber A.T.K"; harga Pulpen Gel 0.5 berbeda (4000 dan 4500) |
| Sisip | Barang baru tidak bisa dicatat sebelum ada penjualannya |
| Hapus | Menghapus nota PJ-0143 ikut menghilangkan info pemasok UD Segar |

## 2. UNF

Satu nota menyimpan grup berulang barang (di dalam tanda `{ }`).

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
  no_anggota, nama_anggota,
  { kode_barang, nama_barang, qty_detail_penjualan,
    harga_satuan_detail_penjualan, subtotal_detail_penjualan },
  jumlah_penjualan, diskon_penjualan, total_penjualan)
```

## 3. 1NF

Grup berulang dihilangkan: satu baris untuk setiap barang di setiap nota.
Kunci primer menjadi komposit (no_nota_penjualan, kode_barang).

```
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas,
  nama_petugas, no_anggota, nama_anggota, nama_barang,
  qty_detail_penjualan, harga_satuan_detail_penjualan,
  subtotal_detail_penjualan, jumlah_penjualan, diskon_penjualan,
  total_penjualan)
```

## 4. Dependensi fungsional

Diturunkan dari aturan bisnis (Modul 2), bukan dari contoh data.

| Kode | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota | AB-01 |
| FD2 | kode_petugas -> nama_petugas | satu kode petugas hanya satu nama |
| FD3 | no_anggota -> nama_anggota | AB-05 |
| FD4 | kode_barang -> nama_barang | satu kode barang hanya satu nama |
| FD5 | (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan | turunan |

### Titik Analisis 1

FD5 menempatkan `harga_satuan_detail_penjualan` pada kunci
(no_nota_penjualan, kode_barang) karena AB-04 menyatakan harga yang dipakai
pada nota disimpan per baris dan tidak berubah walaupun harga barang kemudian
naik. Jadi harga ditentukan oleh pasangan nota dan barang, bukan oleh barang
saja. Karena itu `kode_barang -> harga_satuan_detail_penjualan` salah untuk
Kopma.

Jika harga dipindah ke tabel barang, setiap kenaikan harga akan mengubah harga
pada semua nota lama yang memuat barang itu. Nota lama dan laporan omzet tahun
lalu akan dihitung ulang dengan harga baru, sehingga angkanya tidak lagi sama
dengan uang yang benar-benar diterima saat itu.

## 5. Menuju 2NF

Kunci komposit relasi 1NF adalah (no_nota_penjualan, kode_barang). Atribut yang
hanya bergantung pada sebagian kunci:

- FD1: tgl_penjualan, kode_petugas, no_anggota hanya bergantung pada
  no_nota_penjualan.
- FD4: nama_barang hanya bergantung pada kode_barang.

Keduanya dipisah menjadi relasi sendiri:

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
  no_anggota, nama_anggota)
BARANG (kode_barang, nama_barang)
DETAIL_PENJUALAN (no_nota_penjualan*, kode_barang*, qty_detail_penjualan,
  harga_satuan_detail_penjualan)
```

## 6. Menuju 3NF

Di relasi PENJUALAN terdapat dua rantai ketergantungan transitif:

- no_nota_penjualan -> kode_petugas -> nama_petugas
- no_nota_penjualan -> no_anggota -> nama_anggota

Petugas dan anggota dipisah menjadi relasi sendiri:

```
PENJUALAN (no_nota_penjualan, tgl_penjualan, kode_petugas*, no_anggota*,
  bayar_penjualan)
PETUGAS (kode_petugas, nama_petugas, peran_petugas)
ANGGOTA (no_anggota, nim_anggota, nama_anggota, prodi_anggota,
  no_hp_anggota, status_anggota, tgl_daftar_anggota)
```

## 7. Keputusan nilai turunan

| Nilai | Keputusan | Alasan |
|---|---|---|
| subtotal_detail_penjualan | tidak disimpan | dapat dihitung dari qty x harga_satuan_detail_penjualan |
| jumlah_penjualan | tidak disimpan | dapat dihitung dari jumlah seluruh subtotal pada detail |
| total_penjualan | tidak disimpan | dapat dihitung dari jumlah_penjualan dikurangi diskon 5% untuk anggota aktif (AB-02) |

Dengan tidak menyimpannya di tabel operasional, nilai-nilai ini tidak mungkin
tidak konsisten dengan data detailnya.

### Titik Analisis 2

Di tabel operasional, total dapat berubah mengikuti data dasarnya (detail,
status anggota, aturan diskon). Jika total disimpan di sana, ia bisa tidak
sinkron dengan detailnya. Karena itu total dihitung setiap kali dibutuhkan.

Tabel arsip penjualan lain sifatnya. Arsip adalah potret historis yang tidak
boleh berubah. Total yang sudah tercatat harus tetap sama walaupun harga
barang, status anggota, atau aturan diskon kemudian berubah. Jadi menyimpan
total di arsip tidak melanggar prinsip normalisasi; yang berbeda adalah
tujuannya: data operasional dihitung agar konsisten, data arsip disimpan agar
tidak berubah.

## 8. Mencocokkan dengan skema kanonik Kopma

Hasil di atas dibandingkan dengan Tabel 4.2 di buku.

| Tabel | Kunci primer | Kunci unik | Kunci tamu |
|---|---|---|---|
| petugas | id_petugas | kode_petugas | - |
| anggota | id_anggota | no_anggota, nim_anggota | - |
| barang | id_barang | kode_barang | - |
| pemasok | id_pemasok | - | - |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh NULL) |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang |
| pembelian | id_pembelian | - | id_pemasok |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang |

Perbedaan utama dengan hasil normalisasi manual: kunci primer memakai kunci
pengganti (surrogate key) `id_*`, sedangkan kode alami seperti
`no_nota_penjualan`, `kode_barang`, dan `kode_petugas` menjadi kunci unik.
`id_anggota` di penjualan boleh NULL karena penjualan boleh tanpa anggota
(AB-02).

## 9. Pemeriksaan BCNF

Pemeriksaan dilakukan dengan kunci alami juga, karena kunci pengganti tidak
menghapus dependensi fungsional.

| Tabel | Penentu (determinan) | Kunci kandidat? | Hasil |
|---|---|---|---|
| petugas | id_petugas, kode_petugas | ya | BCNF |
| anggota | id_anggota, no_anggota, nim_anggota | ya | BCNF |
| barang | id_barang, kode_barang | ya | BCNF |
| pemasok | id_pemasok | ya | BCNF |
| penjualan | id_penjualan, no_nota_penjualan | ya | BCNF |
| detail_penjualan | (id_penjualan, id_barang) | ya | BCNF |
| pembelian | id_pembelian | ya | BCNF |
| detail_pembelian | (id_pembelian, id_barang) | ya | BCNF |

Tidak ada penentu yang bukan kunci kandidat, jadi seluruh tabel memenuhi BCNF.

### Titik Analisis 3

Informasi "barang ini dipasok oleh siapa" disimpan lewat tabel pembelian dan
detail_pembelian: pembelian memuat id_pemasok, dan detail_pembelian
menghubungkan pembelian dengan barang.

Keuntungannya dibanding menyimpan satu nama pemasok di tabel barang:

- satu barang dapat dipasok oleh beberapa pemasok dari waktu ke waktu, dan
  riwayatnya tercatat;
- nama pemasok disimpan sekali di tabel pemasok, sehingga ejaan tidak berubah-
  ubah (anomali ubah);
- pemasok baru dapat dicatat tanpa menunggu ada barangnya (anomali sisip);
- menghapus barang atau nota tidak menghilangkan data pemasok (anomali hapus).

## 10. Ringkasan tahapan

| Tahap | Masalah yang dihilangkan | Hasil |
|---|---|---|
| UNF -> 1NF | grup berulang barang per nota | satu baris per barang per nota |
| 1NF -> 2NF | FD1 dan FD4 bergantung pada sebagian kunci | penjualan, barang, detail_penjualan |
| 2NF -> 3NF | rantai no_nota -> kode_petugas -> nama_petugas dan no_nota -> no_anggota -> nama_anggota | petugas dan anggota dipisah |
| Nilai turunan | subtotal, jumlah, total | tidak disimpan, dihitung |
| Skema kanonik | - | 8 tabel dengan kunci pengganti id_* |

## 11. Latihan E

### E.1 Beberapa nomor telepon per pemasok

Jika satu sel menyimpan banyak nomor, atau dibuat kolom telepon1, telepon2,
dan seterusnya, itu melanggar 1NF (nilai tidak atomik / grup berulang).
Solusinya relasi baru:

```
PEMASOK (id_pemasok, nama_pemasok, alamat_pemasok)
PEMASOK_TELEPON (id_pemasok*, no_telepon_pemasok)
-- kunci primer PEMASOK_TELEPON: (id_pemasok, no_telepon_pemasok)
```

Satu pemasok dapat memiliki nol atau banyak nomor telepon.

### E.2 Contoh pelanggaran 3NF dan anomali ubahnya

Misalkan nama_anggota disimpan di tabel penjualan (tabel `penjualan_buruk`):

| no_nota_penjualan | no_anggota | nama_anggota |
|---|---|---|
| PJ-2609-0142 | A-0457 | Budi S. |
| PJ-2609-0150 | A-0457 | Budi S. |

Terdapat rantai no_nota_penjualan -> no_anggota -> nama_anggota, sehingga
nama_anggota bergantung secara transitif pada kunci. Ini melanggar 3NF.

Kueri ubah yang memperlihatkan anomalinya:

```sql
UPDATE penjualan_buruk
SET nama_anggota = 'Budi Santoso'
WHERE no_nota_penjualan = 'PJ-2609-0150';
```

Setelah kueri ini, anggota A-0457 tercatat dengan dua nama ("Budi S." di nota
0142 dan "Budi Santoso" di nota 0150). FD3 (no_anggota -> nama_anggota)
dilanggar. Jika nama disimpan hanya di tabel anggota, cukup satu baris yang
diubah dan tidak ada ketidakkonsistenan.