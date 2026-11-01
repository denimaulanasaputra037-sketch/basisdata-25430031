-- ============================================================
-- p06_data_25430031.sql
-- Milestone Proyek 6 - Data sampel Perpustakaan Happy Reading
-- Nama : Deni Maulana Saputra    NIM : 25430031
-- Basis data : perpus_031 (MariaDB 10.4.32, XAMPP 8.2.12)
-- Parameter P = 5  ->  transaksi utama (peminjaman) minimal 10 x P = 50 baris
-- Cara pakai: jalankan p05_ddl_25430031.sql dulu (membangun ulang tabel
-- kosong), lalu jalankan skrip ini. Hasilnya selalu sama.
-- Urutan isi: INDUK dulu (petugas, buku, anggota), lalu ANAK.
-- ============================================================

USE perpus_031;

-- 1. Petugas (5 baris)
INSERT INTO petugas (id_petugas, nama_petugas) VALUES
  ('PT001', 'Dewi Lestari'),
  ('PT002', 'Rizky Pratama'),
  ('PT003', 'Maya Anggraini'),
  ('PT004', 'Fajar Nugroho'),
  ('PT005', 'Siti Aisyah');

-- 2. Buku (12 baris, stok awal 20 per judul; stok disesuaikan di bagian 8)
INSERT INTO buku (kode_buku, judul_buku, pengarang, tahun_terbit, stok_buku) VALUES
  ('BK001', 'Laskar Pelangi', 'Andrea Hirata', 2005, 20),
  ('BK002', 'Bumi Manusia', 'Pramoedya Ananta Toer', 1980, 20),
  ('BK003', 'Filosofi Teras', 'Henry Manampiring', 2018, 20),
  ('BK004', 'Atomic Habits', 'James Clear', 2018, 20),
  ('BK005', 'Sapiens', 'Yuval Noah Harari', 2011, 20),
  ('BK006', 'Sistem Basis Data', 'Ramez Elmasri', 2016, 20),
  ('BK007', 'Dasar Pemrograman Python', 'Budi Raharjo', 2020, 20),
  ('BK008', 'Pengantar Statistika', 'Ronald E. Walpole', 2012, 20),
  ('BK009', 'Negeri 5 Menara', 'Ahmad Fuadi', 2009, 20),
  ('BK010', 'Cantik Itu Luka', 'Eka Kurniawan', 2002, 20),
  ('BK011', 'Algoritma dan Struktur Data', 'Rinaldi Munir', 2019, 20),
  ('BK012', 'Laut Bercerita', 'Leila S. Chudori', 2017, 20);

-- 3. Anggota (8 baris, 6 Aktif dan 2 Nonaktif)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, no_hp_anggota, status_anggota, tgl_daftar, id_petugas_daftar) VALUES
  ('AG001', '25421007', 'Nabila Safitri', '081234560101', 'Aktif', '2026-08-17', 'PT001'),
  ('AG002', '25421015', 'Ilham Ramadhan', '081234560102', 'Aktif', '2026-08-17', 'PT001'),
  ('AG003', '25421023', 'Putri Wulandari', '081234560103', 'Aktif', '2026-08-24', 'PT002'),
  ('AG004', '25421031', 'Bagas Saputro', '081234560104', 'Aktif', '2026-08-24', 'PT002'),
  ('AG005', '25421048', 'Citra Maharani', '081234560105', 'Aktif', '2026-09-01', 'PT003'),
  ('AG006', '25421056', 'Yoga Prasetyo', '081234560106', 'Aktif', '2026-09-01', 'PT003'),
  ('AG007', '25421064', 'Dinda Kartika', '081234560107', 'Nonaktif', '2026-08-17', 'PT001'),
  ('AG008', '25421072', 'Reza Firmansyah', '081234560108', 'Nonaktif', '2026-08-24', 'PT002');

-- 4. Peminjaman (50 baris, 6 tanggal: 5, 6, 7, 8, 9, dan 12 Oktober 2026)
-- Hanya anggota Aktif yang meminjam (AB-03).
INSERT INTO peminjaman (no_peminjaman, tgl_peminjaman, tgl_jatuh_tempo, id_petugas, no_anggota) VALUES
  ('PM001', '2026-10-05', '2026-10-12', 'PT001', 'AG001'),
  ('PM002', '2026-10-05', '2026-10-10', 'PT002', 'AG002'),
  ('PM003', '2026-10-05', '2026-10-12', 'PT003', 'AG003'),
  ('PM004', '2026-10-05', '2026-10-10', 'PT004', 'AG004'),
  ('PM005', '2026-10-05', '2026-10-12', 'PT005', 'AG005'),
  ('PM006', '2026-10-05', '2026-10-12', 'PT001', 'AG006'),
  ('PM007', '2026-10-05', '2026-10-12', 'PT002', 'AG001'),
  ('PM008', '2026-10-05', '2026-10-12', 'PT003', 'AG002'),
  ('PM009', '2026-10-05', '2026-10-08', 'PT004', 'AG003'),
  ('PM010', '2026-10-06', '2026-10-13', 'PT005', 'AG004'),
  ('PM011', '2026-10-06', '2026-10-13', 'PT001', 'AG005'),
  ('PM012', '2026-10-06', '2026-10-13', 'PT002', 'AG006'),
  ('PM013', '2026-10-06', '2026-10-13', 'PT003', 'AG001'),
  ('PM014', '2026-10-06', '2026-10-13', 'PT004', 'AG002'),
  ('PM015', '2026-10-06', '2026-10-13', 'PT005', 'AG003'),
  ('PM016', '2026-10-06', '2026-10-13', 'PT001', 'AG004'),
  ('PM017', '2026-10-06', '2026-10-09', 'PT002', 'AG005'),
  ('PM018', '2026-10-06', '2026-10-11', 'PT003', 'AG006'),
  ('PM019', '2026-10-07', '2026-10-10', 'PT004', 'AG001'),
  ('PM020', '2026-10-07', '2026-10-12', 'PT005', 'AG002'),
  ('PM021', '2026-10-07', '2026-10-14', 'PT001', 'AG003'),
  ('PM022', '2026-10-07', '2026-10-10', 'PT002', 'AG004'),
  ('PM023', '2026-10-07', '2026-10-14', 'PT003', 'AG005'),
  ('PM024', '2026-10-07', '2026-10-14', 'PT004', 'AG006'),
  ('PM025', '2026-10-07', '2026-10-14', 'PT005', 'AG001'),
  ('PM026', '2026-10-07', '2026-10-12', 'PT001', 'AG002'),
  ('PM027', '2026-10-07', '2026-10-14', 'PT002', 'AG003'),
  ('PM028', '2026-10-08', '2026-10-15', 'PT003', 'AG004'),
  ('PM029', '2026-10-08', '2026-10-15', 'PT004', 'AG005'),
  ('PM030', '2026-10-08', '2026-10-15', 'PT005', 'AG006'),
  ('PM031', '2026-10-08', '2026-10-13', 'PT001', 'AG001'),
  ('PM032', '2026-10-08', '2026-10-15', 'PT002', 'AG002'),
  ('PM033', '2026-10-08', '2026-10-11', 'PT003', 'AG003'),
  ('PM034', '2026-10-08', '2026-10-15', 'PT004', 'AG004'),
  ('PM035', '2026-10-08', '2026-10-15', 'PT005', 'AG005'),
  ('PM036', '2026-10-09', '2026-10-16', 'PT001', 'AG006'),
  ('PM037', '2026-10-09', '2026-10-14', 'PT002', 'AG001'),
  ('PM038', '2026-10-09', '2026-10-12', 'PT003', 'AG002'),
  ('PM039', '2026-10-09', '2026-10-12', 'PT004', 'AG003'),
  ('PM040', '2026-10-09', '2026-10-16', 'PT005', 'AG004'),
  ('PM041', '2026-10-09', '2026-10-16', 'PT001', 'AG005'),
  ('PM042', '2026-10-09', '2026-10-16', 'PT002', 'AG006'),
  ('PM043', '2026-10-09', '2026-10-16', 'PT003', 'AG001'),
  ('PM044', '2026-10-12', '2026-10-19', 'PT004', 'AG002'),
  ('PM045', '2026-10-12', '2026-10-19', 'PT005', 'AG003'),
  ('PM046', '2026-10-12', '2026-10-19', 'PT001', 'AG004'),
  ('PM047', '2026-10-12', '2026-10-17', 'PT002', 'AG005'),
  ('PM048', '2026-10-12', '2026-10-19', 'PT003', 'AG006'),
  ('PM049', '2026-10-12', '2026-10-19', 'PT004', 'AG001'),
  ('PM050', '2026-10-12', '2026-10-15', 'PT005', 'AG002');

-- 5. Detail peminjaman (99 baris, 1 sampai 3 buku per peminjaman)
INSERT INTO detail_peminjaman (no_peminjaman, kode_buku, kondisi_keluar) VALUES
  ('PM001', 'BK011', 'Baik'),
  ('PM001', 'BK004', 'Baik'),
  ('PM001', 'BK012', 'Baik'),
  ('PM002', 'BK008', 'Baik'),
  ('PM002', 'BK001', 'Baik'),
  ('PM003', 'BK008', 'Baik'),
  ('PM003', 'BK011', 'Baik'),
  ('PM003', 'BK006', 'Baik'),
  ('PM004', 'BK003', 'Baik'),
  ('PM004', 'BK009', 'Baik'),
  ('PM005', 'BK002', 'Baik'),
  ('PM005', 'BK003', 'Baik'),
  ('PM006', 'BK012', 'Baik'),
  ('PM006', 'BK002', 'Baik'),
  ('PM007', 'BK011', 'Baik'),
  ('PM007', 'BK004', 'Baik'),
  ('PM008', 'BK008', 'Baik'),
  ('PM008', 'BK007', 'Baik'),
  ('PM009', 'BK005', 'Baik'),
  ('PM010', 'BK004', 'Baik'),
  ('PM011', 'BK012', 'Baik'),
  ('PM011', 'BK003', 'Baik'),
  ('PM012', 'BK006', 'Baik'),
  ('PM012', 'BK010', 'Baik'),
  ('PM013', 'BK008', 'Baik'),
  ('PM014', 'BK001', 'Baik'),
  ('PM014', 'BK005', 'Baik'),
  ('PM014', 'BK008', 'Baik'),
  ('PM015', 'BK002', 'Baik'),
  ('PM016', 'BK008', 'Baik'),
  ('PM016', 'BK003', 'Baik'),
  ('PM017', 'BK010', 'Baik'),
  ('PM018', 'BK005', 'Baik'),
  ('PM018', 'BK003', 'Baik'),
  ('PM019', 'BK004', 'Baik'),
  ('PM019', 'BK009', 'Baik'),
  ('PM019', 'BK012', 'Baik'),
  ('PM020', 'BK006', 'Baik'),
  ('PM020', 'BK003', 'Baik'),
  ('PM020', 'BK012', 'Baik'),
  ('PM021', 'BK012', 'Baik'),
  ('PM021', 'BK007', 'Baik'),
  ('PM022', 'BK012', 'Baik'),
  ('PM023', 'BK004', 'Baik'),
  ('PM023', 'BK007', 'Baik'),
  ('PM024', 'BK009', 'Baik'),
  ('PM024', 'BK010', 'Baik'),
  ('PM025', 'BK001', 'Baik'),
  ('PM026', 'BK005', 'Baik'),
  ('PM026', 'BK009', 'Baik'),
  ('PM027', 'BK004', 'Rusak ringan'),
  ('PM027', 'BK007', 'Baik'),
  ('PM028', 'BK004', 'Baik'),
  ('PM028', 'BK012', 'Baik'),
  ('PM029', 'BK002', 'Rusak ringan'),
  ('PM029', 'BK004', 'Baik'),
  ('PM030', 'BK008', 'Baik'),
  ('PM030', 'BK012', 'Baik'),
  ('PM030', 'BK005', 'Rusak ringan'),
  ('PM031', 'BK005', 'Baik'),
  ('PM031', 'BK008', 'Baik'),
  ('PM032', 'BK007', 'Baik'),
  ('PM032', 'BK005', 'Baik'),
  ('PM033', 'BK010', 'Baik'),
  ('PM033', 'BK005', 'Baik'),
  ('PM034', 'BK004', 'Baik'),
  ('PM034', 'BK010', 'Baik'),
  ('PM035', 'BK002', 'Baik'),
  ('PM035', 'BK011', 'Baik'),
  ('PM036', 'BK009', 'Baik'),
  ('PM036', 'BK008', 'Baik'),
  ('PM037', 'BK005', 'Baik'),
  ('PM037', 'BK007', 'Baik'),
  ('PM038', 'BK007', 'Baik'),
  ('PM038', 'BK001', 'Baik'),
  ('PM039', 'BK001', 'Baik'),
  ('PM039', 'BK007', 'Baik'),
  ('PM040', 'BK009', 'Rusak ringan'),
  ('PM041', 'BK012', 'Baik'),
  ('PM041', 'BK008', 'Baik'),
  ('PM042', 'BK005', 'Baik'),
  ('PM043', 'BK007', 'Baik'),
  ('PM044', 'BK009', 'Rusak ringan'),
  ('PM044', 'BK003', 'Baik'),
  ('PM044', 'BK002', 'Baik'),
  ('PM045', 'BK008', 'Baik'),
  ('PM045', 'BK011', 'Baik'),
  ('PM045', 'BK001', 'Baik'),
  ('PM046', 'BK004', 'Baik'),
  ('PM046', 'BK003', 'Baik'),
  ('PM047', 'BK001', 'Baik'),
  ('PM047', 'BK010', 'Baik'),
  ('PM048', 'BK004', 'Baik'),
  ('PM048', 'BK007', 'Baik'),
  ('PM048', 'BK012', 'Baik'),
  ('PM049', 'BK012', 'Baik'),
  ('PM050', 'BK003', 'Baik'),
  ('PM050', 'BK009', 'Baik'),
  ('PM050', 'BK006', 'Baik');

-- 6. Pengembalian (35 baris; PM036 sampai PM050 masih dipinjam)
INSERT INTO pengembalian (no_pengembalian, tgl_pengembalian, no_peminjaman, id_petugas) VALUES
  ('PG001', '2026-10-09', 'PM001', 'PT003'),
  ('PG002', '2026-10-06', 'PM002', 'PT004'),
  ('PG003', '2026-10-07', 'PM003', 'PT005'),
  ('PG004', '2026-10-18', 'PM004', 'PT001'),
  ('PG005', '2026-10-08', 'PM005', 'PT002'),
  ('PG006', '2026-10-12', 'PM006', 'PT003'),
  ('PG007', '2026-10-11', 'PM007', 'PT004'),
  ('PG008', '2026-10-14', 'PM008', 'PT005'),
  ('PG009', '2026-10-06', 'PM009', 'PT001'),
  ('PG010', '2026-10-12', 'PM010', 'PT002'),
  ('PG011', '2026-10-10', 'PM011', 'PT003'),
  ('PG012', '2026-10-18', 'PM012', 'PT004'),
  ('PG013', '2026-10-08', 'PM013', 'PT005'),
  ('PG014', '2026-10-09', 'PM014', 'PT001'),
  ('PG015', '2026-10-09', 'PM015', 'PT002'),
  ('PG016', '2026-10-16', 'PM016', 'PT003'),
  ('PG017', '2026-10-08', 'PM017', 'PT004'),
  ('PG018', '2026-10-09', 'PM018', 'PT005'),
  ('PG019', '2026-10-09', 'PM019', 'PT001'),
  ('PG020', '2026-10-20', 'PM020', 'PT002'),
  ('PG021', '2026-10-11', 'PM021', 'PT003'),
  ('PG022', '2026-10-10', 'PM022', 'PT004'),
  ('PG023', '2026-10-11', 'PM023', 'PT005'),
  ('PG024', '2026-10-17', 'PM024', 'PT001'),
  ('PG025', '2026-10-08', 'PM025', 'PT002'),
  ('PG026', '2026-10-09', 'PM026', 'PT003'),
  ('PG027', '2026-10-13', 'PM027', 'PT004'),
  ('PG028', '2026-10-17', 'PM028', 'PT005'),
  ('PG029', '2026-10-11', 'PM029', 'PT001'),
  ('PG030', '2026-10-15', 'PM030', 'PT002'),
  ('PG031', '2026-10-10', 'PM031', 'PT003'),
  ('PG032', '2026-10-16', 'PM032', 'PT004'),
  ('PG033', '2026-10-09', 'PM033', 'PT005'),
  ('PG034', '2026-10-14', 'PM034', 'PT001'),
  ('PG035', '2026-10-15', 'PM035', 'PT002');

-- 7. Denda (8 baris, hanya untuk pengembalian yang terlambat; tarif Rp5.000 per hari)
INSERT INTO denda (id_denda, no_pengembalian, tarif_denda_harian, status_bayar) VALUES
  ('DN001', 'PG004', 5000, 'Lunas'),
  ('DN002', 'PG008', 5000, 'Belum Lunas'),
  ('DN003', 'PG012', 5000, 'Lunas'),
  ('DN004', 'PG016', 5000, 'Belum Lunas'),
  ('DN005', 'PG020', 5000, 'Lunas'),
  ('DN006', 'PG024', 5000, 'Belum Lunas'),
  ('DN007', 'PG028', 5000, 'Lunas'),
  ('DN008', 'PG032', 5000, 'Belum Lunas');

-- 8. Sesuaikan stok: stok awal dikurangi buku yang masih dipinjam (AB-06)
UPDATE buku b
SET stok_buku = stok_buku - (
  SELECT COUNT(*) FROM detail_peminjaman d
  WHERE d.kode_buku = b.kode_buku
    AND d.no_peminjaman NOT IN (SELECT no_peminjaman FROM pengembalian))
WHERE b.kode_buku LIKE 'BK%';

-- 9. Pemeriksaan: jumlah baris per tabel
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'buku', COUNT(*) FROM buku
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'peminjaman', COUNT(*) FROM peminjaman
UNION ALL SELECT 'detail_peminjaman', COUNT(*) FROM detail_peminjaman
UNION ALL SELECT 'pengembalian', COUNT(*) FROM pengembalian
UNION ALL SELECT 'denda', COUNT(*) FROM denda;

-- 10. Pemeriksaan: peminjaman tersebar pada beberapa tanggal
SELECT tgl_peminjaman, COUNT(*) AS jumlah_nota
FROM peminjaman GROUP BY tgl_peminjaman ORDER BY tgl_peminjaman;
