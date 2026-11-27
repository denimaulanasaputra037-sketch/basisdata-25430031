-- ============================================================
-- p09_agregasi_25430031.sql
-- Milestone Proyek 9 - Laporan ringkasan Perpustakaan Happy Reading
-- Nama : Deni Maulana Saputra    NIM : 25430031
-- Basis data : perpus_031 (data dari p06_data_25430031.sql, P = 5)
-- Setiap laporan diberi komentar: kode KI, pertanyaan sehari-hari, dan hasil
-- yang diharapkan (dihitung dari isi p06_data sebelum dijalankan).
-- Semua kueri dijalankan dengan ONLY_FULL_GROUP_BY aktif (baris SET di bawah)
-- dan tiap laporan memiliki minimal tiga kelompok.
-- Semua kueri hanya SELECT, jadi aman dijalankan berulang kali.
--
-- PEMETAAN LAPORAN -> KEBUTUHAN INFORMASI (KI) DARI p02
--   KI-01  R5  (peminjaman per anggota aktif)
--   KI-02  R4  (stok buku per dasawarsa terbit; juga mendukung KI-03)
--   KI-04  R1  (buku yang sedang dipinjam per judul)
--   KI-05  R2  (anggota yang terlambat, memakai HAVING)
--   KI-06  R3  (denda belum lunas per anggota, memakai WITH ROLLUP)
--   Pendukung  R6 (peminjaman per tanggal, memakai WITH ROLLUP)
-- Laporan memakai JOIN sederhana; pembahasan JOIN lengkap ada di Modul 10.
-- ============================================================

USE perpus_031;
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

-- ------------------------------------------------------------
-- R1 | KI-04 | Berapa eksemplar tiap judul yang sedang dipinjam
--      (peminjaman yang belum punya pengembalian)?
-- Harapan: 12 baris, jumlah seluruhnya 30. Urut dari terbanyak:
--          BK007 = 5, BK001 = 4, BK009 = 4, BK003 = 3, BK008 = 3, BK012 = 3,
--          BK004 = 2, BK005 = 2, lalu BK002, BK006, BK010, BK011 masing-masing 1.
--          Tiap angka sama dengan 20 - stok_buku (stok awal 20 dikurangi
--          buku yang sedang keluar).
-- ------------------------------------------------------------
SELECT b.kode_buku, b.judul_buku, COUNT(*) AS sedang_dipinjam
FROM detail_peminjaman d
JOIN buku b ON b.kode_buku = d.kode_buku
JOIN peminjaman p ON p.no_peminjaman = d.no_peminjaman
LEFT JOIN pengembalian g ON g.no_peminjaman = p.no_peminjaman
WHERE g.no_peminjaman IS NULL
GROUP BY b.kode_buku, b.judul_buku
ORDER BY sedang_dipinjam DESC, b.kode_buku;

-- ------------------------------------------------------------
-- R2 | KI-05 | HAVING | Anggota mana yang terlambat mengembalikan buku
--      sedikitnya dua kali?
-- Harapan: 3 baris -> AG002 Ilham Ramadhan (3 kali), AG004 Bagas Saputro (3 kali),
--          AG006 Yoga Prasetyo (2 kali). Jumlahnya 8, sama dengan jumlah denda.
--          Terlambat = tgl_pengembalian setelah tgl_jatuh_tempo.
-- ------------------------------------------------------------
SELECT a.no_anggota, a.nama_anggota, COUNT(*) AS kali_terlambat
FROM pengembalian g
JOIN peminjaman p ON p.no_peminjaman = g.no_peminjaman
JOIN anggota a ON a.no_anggota = p.no_anggota
WHERE g.tgl_pengembalian > p.tgl_jatuh_tempo
GROUP BY a.no_anggota, a.nama_anggota
HAVING COUNT(*) >= 2
ORDER BY kali_terlambat DESC, a.no_anggota;

-- ------------------------------------------------------------
-- R3 | KI-06 | WITH ROLLUP | Berapa denda yang belum dibayar tiap anggota,
--      dan berapa totalnya? Denda = hari terlambat x tarif harian (Rp5.000).
-- Harapan: 4 baris -> AG002: 2 denda, 15000 (2 hari + 1 hari)
--                     AG004: 1 denda, 15000 (3 hari)
--                     AG006: 1 denda, 15000 (3 hari)
--                     TOTAL: 4 denda, 45000
-- ------------------------------------------------------------
SELECT IFNULL(a.no_anggota, 'TOTAL') AS no_anggota,
       COUNT(*) AS denda_belum_lunas,
       SUM(DATEDIFF(g.tgl_pengembalian, p.tgl_jatuh_tempo) * d.tarif_denda_harian) AS total_rupiah
FROM denda d
JOIN pengembalian g ON g.no_pengembalian = d.no_pengembalian
JOIN peminjaman p ON p.no_peminjaman = g.no_peminjaman
JOIN anggota a ON a.no_anggota = p.no_anggota
WHERE d.status_bayar = 'Belum Lunas'
GROUP BY a.no_anggota WITH ROLLUP;

-- ------------------------------------------------------------
-- R4 | KI-02 dan KI-03 | Berapa judul dan total stok buku pada tiap
--      dasawarsa terbit?
-- Harapan: 4 baris -> 1980: 1 judul, stok 19
--                     2000: 3 judul, stok 51
--                     2010: 7 judul, stok 125
--                     2020: 1 judul, stok 15
--          Jumlah judul 12, jumlah stok 210 (240 dikurangi 30 buku yang sedang dipinjam).
-- ------------------------------------------------------------
SELECT FLOOR(tahun_terbit / 10) * 10 AS dasawarsa,
       COUNT(*) AS judul,
       SUM(stok_buku) AS total_stok
FROM buku
GROUP BY FLOOR(tahun_terbit / 10) * 10
ORDER BY dasawarsa;

-- ------------------------------------------------------------
-- R5 | KI-01 | Berapa kali tiap anggota Aktif meminjam?
-- Harapan: 6 baris, jumlahnya 50 -> AG001 = 9, AG002 = 9, AG003 = 8,
--          AG004 = 8, AG005 = 8, AG006 = 8. Anggota Nonaktif (AG007, AG008)
--          tidak muncul karena tidak pernah meminjam.
-- ------------------------------------------------------------
SELECT a.no_anggota, a.nama_anggota, COUNT(*) AS jumlah_peminjaman
FROM peminjaman p
JOIN anggota a ON a.no_anggota = p.no_anggota
WHERE a.status_anggota = 'Aktif'
GROUP BY a.no_anggota, a.nama_anggota
ORDER BY jumlah_peminjaman DESC, a.no_anggota;

-- ------------------------------------------------------------
-- R6 | Pendukung | WITH ROLLUP | Berapa peminjaman setiap hari, dan totalnya?
-- Harapan: 7 baris -> 2026-10-05: 9, 2026-10-06: 9, 2026-10-07: 9,
--          2026-10-08: 8, 2026-10-09: 8, 2026-10-12: 7,
--          lalu baris bertanggal NULL = total 50.
-- ------------------------------------------------------------
SELECT tgl_peminjaman, COUNT(*) AS jumlah_peminjaman
FROM peminjaman
GROUP BY tgl_peminjaman WITH ROLLUP;
