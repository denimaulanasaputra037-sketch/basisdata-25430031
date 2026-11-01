-- ============================================================
-- p06_data_kopma_25430031.sql
-- Praktikum Basis Data - Pertemuan 6 (DML)
-- Nama : Deni Maulana Saputra    NIM : 25430031
-- Basis data : kopma_031 (MariaDB 10.4.32, XAMPP 8.2.12)
--
-- CARA MENJALANKAN (urutan wajib):
--   1. Jalankan p05_ddl_kopma_25430031.sql  (membangun ulang tabel kosong)
--   2. Jalankan skrip ini                   (mengisi data sampel)
-- Hasilnya selalu sama karena DDL menghapus tabel lama lebih dulu.
--
-- Kunci tamu diisi lewat KODE ALAMI (kode_petugas, no_anggota, kode_barang,
-- no_nota_penjualan) dengan INSERT ... SELECT, bukan menebak nilai id.
-- ============================================================

USE kopma_031;

-- ------------------------------------------------------------
-- 1. Data induk (tanpa kunci tamu)
-- ------------------------------------------------------------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01', 'Dimas',       'kasir'),
  ('K02', 'Sari',        'kasir'),
  ('K03', 'Rina',        'kasir'),
  ('G01', 'Joko',        'gudang'),
  ('P01', 'Ketua Kopma', 'ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang,
                    harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001', 'Pulpen Gel 0.5',  'ATK',     4000, 120, 20),
  ('ATK-002', 'Buku Tulis 58',   'ATK',     6500,  80, 20),
  ('MNM-001', 'Air Mineral 600', 'minuman', 4000,  48, 24),
  ('MNM-002', 'Teh Botol 350',   'minuman', 5000,  36, 24),
  ('MKN-001', 'Roti Cokelat',    'makanan', 5000,   6, 10),
  ('MKN-002', 'Wafer Cokelat',   'makanan', 3500,  30, 12);

-- Anggota: 3 aktif + 2 nonaktif yang mendaftar sebelum 2025 (bahan Latihan E.1)
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota,
                     no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0457', '2543004571', 'Budi Santoso',    'Teknik Informatika', '081234560457', 'aktif',    '2026-08-17'),
  ('A-0458', '2543004581', 'Citra Lestari',   'Sistem Informasi',   '081234560458', 'aktif',    '2026-08-18'),
  ('A-0459', '2543004591', 'Eko Prasetyo',    'Manajemen',          '081234560459', 'aktif',    '2026-08-20'),
  ('A-0312', '2443003121', 'Fitri Handayani', 'Akuntansi',          '081234560312', 'nonaktif', '2024-09-05'),
  ('A-0313', '2443003131', 'Gunawan Wibowo',  'Teknik Informatika', '081234560313', 'nonaktif', '2024-09-06');

INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('CV Sumber ATK',            '0721-555-0101', 'Jl. Kartini No. 12, Bandar Lampung'),
  ('UD Segar Makmur',          '0721-555-0202', 'Jl. Pemuda No. 5, Metro'),
  ('PT Tirta Jaya Distribusi', '0725-555-0303', 'Jl. Ahmad Yani No. 40, Metro');

-- ------------------------------------------------------------
-- 2. Nota penjualan (kepala nota)
--    id_petugas dan id_anggota diambil dari kode alami
-- ------------------------------------------------------------
-- Nota contoh Modul 2 (dua catatan: anggota aktif, 3 baris barang)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0142', '2026-09-24 10:15:00', p.id_petugas, a.id_anggota, 30000
FROM petugas p, anggota a WHERE p.kode_petugas = 'K03' AND a.no_anggota = 'A-0457';

-- Nota pembeli umum (tanpa anggota -> id_anggota NULL, AB-02)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0143', '2026-09-24 11:40:00', p.id_petugas, NULL, 10000
FROM petugas p WHERE p.kode_petugas = 'K03';

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2609-0150', '2026-09-25 09:05:00', p.id_petugas, a.id_anggota, 10000
FROM petugas p, anggota a WHERE p.kode_petugas = 'K01' AND a.no_anggota = 'A-0458';

-- Nota lama milik anggota nonaktif A-0313 (dipakai Latihan E.1: tidak boleh ikut terhapus)
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
SELECT 'PJ-2503-0007', '2025-03-10 14:20:00', p.id_petugas, a.id_anggota, 6000
FROM petugas p, anggota a WHERE p.kode_petugas = 'K02' AND a.no_anggota = 'A-0313';

-- ------------------------------------------------------------
-- 3. Detail penjualan: harga satuan DISALIN dari harga jual saat itu (AB-04)
-- ------------------------------------------------------------
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 3, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'ATK-001';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'ATK-002';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0142' AND b.kode_barang = 'MNM-001';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 2, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0143' AND b.kode_barang = 'MKN-001';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0150' AND b.kode_barang = 'ATK-001';

INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, b.harga_jual_barang
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2609-0150' AND b.kode_barang = 'MNM-001';

-- Nota lama 2025: harga buku tulis saat itu Rp6.000 (bukan harga sekarang) -> bukti AB-04
INSERT INTO detail_penjualan (id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT p.id_penjualan, b.id_barang, 1, 6000
FROM penjualan p, barang b WHERE p.no_nota_penjualan = 'PJ-2503-0007' AND b.kode_barang = 'ATK-002';

-- ------------------------------------------------------------
-- 4. Kurangi stok sesuai penjualan 24-25 September 2026
--    (WHERE memakai kode_barang yang berindeks UNIQUE -> lolos mode aman)
-- ------------------------------------------------------------
UPDATE barang SET stok_barang = stok_barang - 4 WHERE kode_barang = 'ATK-001';  -- 3 + 1
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'ATK-002';
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MNM-001';  -- 1 + 1
UPDATE barang SET stok_barang = stok_barang - 2 WHERE kode_barang = 'MKN-001';

-- ------------------------------------------------------------
-- 5. Pembelian dari pemasok (stok roti di bawah minimum -> dipesan, AB-06)
-- ------------------------------------------------------------
INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, id_pemasok, status_pembelian)
SELECT 'FK-0925-01', '2026-09-20', s.id_pemasok, 'diterima'
FROM pemasok s WHERE s.nama_pemasok = 'CV Sumber ATK';

INSERT INTO pembelian (no_faktur_pembelian, tgl_pembelian, id_pemasok, status_pembelian)
SELECT 'FK-1002-07', '2026-10-02', s.id_pemasok, 'dipesan'
FROM pemasok s WHERE s.nama_pemasok = 'UD Segar Makmur';

INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT p.id_pembelian, b.id_barang, 100, 2800
FROM pembelian p, barang b WHERE p.no_faktur_pembelian = 'FK-0925-01' AND b.kode_barang = 'ATK-001';

INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT p.id_pembelian, b.id_barang, 50, 4800
FROM pembelian p, barang b WHERE p.no_faktur_pembelian = 'FK-0925-01' AND b.kode_barang = 'ATK-002';

INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT p.id_pembelian, b.id_barang, 24, 3600
FROM pembelian p, barang b WHERE p.no_faktur_pembelian = 'FK-1002-07' AND b.kode_barang = 'MKN-001';

INSERT INTO detail_pembelian (id_pembelian, id_barang, qty_detail_pembelian, harga_beli_detail_pembelian)
SELECT p.id_pembelian, b.id_barang, 30, 2500
FROM pembelian p, barang b WHERE p.no_faktur_pembelian = 'FK-1002-07' AND b.kode_barang = 'MKN-002';

-- ------------------------------------------------------------
-- 6. Pemeriksaan: jumlah baris per tabel
-- ------------------------------------------------------------
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'barang', COUNT(*) FROM barang
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok
UNION ALL SELECT 'penjualan', COUNT(*) FROM penjualan
UNION ALL SELECT 'detail_penjualan', COUNT(*) FROM detail_penjualan
UNION ALL SELECT 'pembelian', COUNT(*) FROM pembelian
UNION ALL SELECT 'detail_pembelian', COUNT(*) FROM detail_pembelian;
