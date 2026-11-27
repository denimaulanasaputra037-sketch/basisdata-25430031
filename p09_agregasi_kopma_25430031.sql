-- ============================================================
-- p09_agregasi_kopma_25430031.sql
-- Praktikum Basis Data - Pertemuan 9 (Fungsi agregat dan GROUP BY)
-- Nama : Deni Maulana Saputra    NIM : 25430031
-- Basis data : kopma_031 (data dari kopma_data_lanjutan_25430031.sql)
-- Catatan data: berkas kopma_data_lanjutan.sql dari dosen tidak tersedia,
--   jadi data lanjutan dibuat sendiri dengan angka kunci yang sama seperti
--   contoh di buku (75 nota; September 39 nota Rp691.000; Oktober 36 nota
--   Rp507.500).
-- Semua kueri dijalankan dengan ONLY_FULL_GROUP_BY aktif (baris SET di bawah).
-- Semua kueri hanya SELECT, jadi aman dijalankan berulang kali.
-- ============================================================

USE kopma_031;
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

-- ------------------------------------------------------------
-- Q1 | Total satu nota (pertanyaan yang tertunda dari Pertemuan 7)
-- Harapan: 1 baris -> PJ-2609-0001 = 18500
--          (1 x 4000 + 1 x 6500 + 2 x 4000; dibayar 20000, kembalian 1500)
-- ------------------------------------------------------------
SELECT p.no_nota_penjualan,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS jumlah
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.no_nota_penjualan = 'PJ-2609-0001'
GROUP BY p.id_penjualan, p.no_nota_penjualan;

-- ------------------------------------------------------------
-- Titik Analisis 1 | JANGAN dijalankan bersama berkas ini (sengaja galat).
-- Jalankan sendiri di tab SQL, dengan dua baris SET di atas, untuk foto galat.
-- Harapan: ERROR 1055, karena p.no_nota_penjualan ada di SELECT tetapi tidak
--          ada di GROUP BY (MariaDB tidak menebak bahwa satu id = satu nomor nota).
-- ------------------------------------------------------------
-- SELECT p.no_nota_penjualan,
--        SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS jumlah
-- FROM penjualan p
-- JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
-- WHERE p.no_nota_penjualan = 'PJ-2609-0001'
-- GROUP BY p.id_penjualan;

-- ------------------------------------------------------------
-- Q2 | KI-01 | Omzet harian minggu pertama September 2026 dengan baris total
-- Harapan: satu baris per tanggal yang ada nota (mulai 2026-09-02), lalu satu
--          baris terakhir bertanggal NULL. Baris NULL itu adalah total:
--          jumlah nota dan omzetnya sama dengan penjumlahan baris-baris di atasnya.
-- ------------------------------------------------------------
SELECT DATE(p.tgl_penjualan) AS tanggal,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-01' AND p.tgl_penjualan < '2026-09-08'
GROUP BY DATE(p.tgl_penjualan) WITH ROLLUP;

-- ------------------------------------------------------------
-- Q3 | KI-01 | Omzet bulanan dengan baris total
-- Harapan: 3 baris -> 2026-09: 39 nota, 691000
--                     2026-10: 36 nota, 507500
--                     NULL (total): 75 nota, 1198500
-- ------------------------------------------------------------
SELECT DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
GROUP BY DATE_FORMAT(p.tgl_penjualan, '%Y-%m') WITH ROLLUP;

-- ------------------------------------------------------------
-- Q4 | Titik Analisis 2 | COUNT(*) dibandingkan COUNT(DISTINCT) pada September
-- Harapan: 1 baris -> baris_detail 89, nota 39.
--          COUNT(*) menghitung baris hasil JOIN (satu nota punya banyak detail),
--          COUNT(DISTINCT p.id_penjualan) menghitung nota yang sebenarnya.
-- ------------------------------------------------------------
SELECT COUNT(*) AS baris_detail,
       COUNT(DISTINCT p.id_penjualan) AS nota
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-01' AND p.tgl_penjualan < '2026-10-01';

-- ------------------------------------------------------------
-- Q5 | HAVING | Kasir yang melayani lebih dari 20 nota
-- Harapan: 2 baris -> K01 Dimas (24 nota) dan K03 Rina (33 nota).
--          K02 Sari (18 nota) tersaring HAVING.
-- ------------------------------------------------------------
SELECT pt.kode_petugas, pt.nama_petugas, COUNT(*) AS nota
FROM penjualan p
JOIN petugas pt ON pt.id_petugas = p.id_petugas
GROUP BY pt.id_petugas, pt.kode_petugas, pt.nama_petugas
HAVING COUNT(*) > 20;

-- ------------------------------------------------------------
-- Q6 | HAVING | Barang yang total qty terjualnya kurang dari 10
-- Harapan: 2 baris -> Penggaris 30 cm (ATK-005) dan Mi Instan Cup (MKN-003)
-- ------------------------------------------------------------
SELECT b.kode_barang, b.nama_barang, SUM(d.qty_detail_penjualan) AS total_qty
FROM barang b
JOIN detail_penjualan d ON d.id_barang = b.id_barang
GROUP BY b.id_barang, b.kode_barang, b.nama_barang
HAVING SUM(d.qty_detail_penjualan) < 10
ORDER BY total_qty;

-- ------------------------------------------------------------
-- Q7 | Titik Analisis 3 | Rata-rata belanja per nota untuk anggota saja
-- Syarat "anggota saja" ditulis di WHERE (bukan HAVING), karena ia menyaring
-- BARIS nota sebelum dikelompokkan. HAVING hanya untuk menyaring hasil agregat.
-- Harapan: 1 baris berisi satu angka rata-rata. Nota pembeli umum
--          (id_anggota NULL) tidak ikut dihitung.
-- ------------------------------------------------------------
SELECT AVG(t.total) AS rata_rata_belanja_per_nota
FROM (SELECT p.id_penjualan,
             SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS total
      FROM penjualan p
      JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
      WHERE p.id_anggota IS NOT NULL
      GROUP BY p.id_penjualan) t;

-- ------------------------------------------------------------
-- Latihan E.1 | AB-02 | Total nota dengan diskon 5% untuk anggota aktif,
--               dibandingkan dengan bayar_penjualan; tampilkan nota yang
--               kembaliannya lebih dari Rp4.000
-- Harapan: setiap baris memenuhi kembalian = bayar_penjualan - total_bayar,
--          dan kembalian di atas 4000. Anggota aktif memakai total_bayar =
--          subtotal x 0,95 (dibulatkan), selain itu total_bayar = subtotal.
-- ------------------------------------------------------------
SELECT no_nota_penjualan, status_anggota, subtotal, total_bayar,
       bayar_penjualan, bayar_penjualan - total_bayar AS kembalian
FROM (SELECT p.no_nota_penjualan, a.status_anggota, p.bayar_penjualan,
             SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS subtotal,
             CASE WHEN a.status_anggota = 'aktif'
                  THEN ROUND(SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) * 0.95)
                  ELSE SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan)
             END AS total_bayar
      FROM penjualan p
      JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
      LEFT JOIN anggota a ON a.id_anggota = p.id_anggota
      GROUP BY p.id_penjualan, p.no_nota_penjualan, a.status_anggota, p.bayar_penjualan) t
WHERE bayar_penjualan - total_bayar > 4000
ORDER BY kembalian DESC, no_nota_penjualan;

-- ------------------------------------------------------------
-- Latihan E.2 | Omzet per kategori barang per bulan dengan WITH ROLLUP
-- Harapan: untuk tiap bulan ada baris per kategori (ATK, makanan, minuman),
--          diikuti satu baris dengan kategori NULL = subtotal bulan itu
--          (2026-09 = 691000, 2026-10 = 507500). Baris terakhir dengan bulan
--          NULL dan kategori NULL = total keseluruhan 1198500.
-- ------------------------------------------------------------
SELECT DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan,
       b.kategori_barang,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
JOIN barang b ON b.id_barang = d.id_barang
GROUP BY DATE_FORMAT(p.tgl_penjualan, '%Y-%m'), b.kategori_barang WITH ROLLUP;
