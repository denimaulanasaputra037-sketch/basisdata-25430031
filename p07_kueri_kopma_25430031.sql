-- ============================================================
-- p07_kueri_kopma_25430031.sql
-- Praktikum Basis Data - Pertemuan 7 (SELECT dan fungsi skalar)
-- Nama : Deni Maulana Saputra    NIM : 25430031
-- Basis data : kopma_031 (data dari p06_data_kopma_25430031.sql)
-- Setiap kueri diberi komentar: pertanyaan, hasil yang diharapkan.
-- Semua kueri hanya SELECT, jadi aman dijalankan berulang kali.
-- ============================================================

USE kopma_031;

-- ------------------------------------------------------------
-- Q1 | KI-03 | Barang apa yang perlu dipesan ulang?
-- Harapan: 1 baris -> MKN-001 Roti Cokelat, stok 4, minimum 10, kurang 6
-- ------------------------------------------------------------
SELECT kode_barang, nama_barang, stok_barang, stok_min_barang,
       stok_min_barang - stok_barang AS kurang
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY kurang DESC;

-- ------------------------------------------------------------
-- Q2 | Penyaringan IN | Barang apa saja yang berkategori ATK atau minuman?
-- Harapan: 4 baris -> ATK-001, ATK-002, MNM-001, MNM-002
-- ------------------------------------------------------------
SELECT kode_barang, nama_barang, kategori_barang, harga_jual_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'minuman')
ORDER BY kode_barang;

-- ------------------------------------------------------------
-- Q3 | Penyaringan BETWEEN | Nota apa saja pada 24 dan 25 September 2026?
-- Harapan: 3 baris -> PJ-2609-0142, PJ-2609-0143, PJ-2609-0150
-- Catatan: tgl_penjualan bertipe DATETIME, jadi batas akhir ditulis
--          sampai 23:59:59 agar nota sore hari tetap ikut.
-- ------------------------------------------------------------
SELECT no_nota_penjualan, tgl_penjualan, bayar_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-09-24 00:00:00' AND '2026-09-25 23:59:59'
ORDER BY tgl_penjualan;

-- ------------------------------------------------------------
-- Q4 | Penyaringan IS NULL | Anggota mana yang belum punya nomor HP?
-- Harapan: 1 baris -> A-0459 Eko Prasetyo
-- ------------------------------------------------------------
SELECT no_anggota, nama_anggota, status_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;

-- ------------------------------------------------------------
-- Q5 | String, tanggal, kondisional | Anggota yang namanya mengandung huruf "a",
--      dengan label mudah dibaca, tanggal format Indonesia, dan keterangan diskon.
-- Harapan: 5 baris, urut dari pendaftar terbaru: A-0459, A-0458, A-0457,
--          A-0313, A-0312. A-0459 menampilkan hp "-". Aktif = "Diskon 5%".
-- Catatan: alias tanggal dibuat BERBEDA dari nama kolom (tgl_daftar_fmt),
--          kalau sama, ORDER BY akan mengurutkan teks "dd-mm-yyyy", bukan tanggal.
-- ------------------------------------------------------------
SELECT CONCAT(nama_anggota, ' (', no_anggota, ')')        AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y')        AS tgl_daftar_fmt,
       IFNULL(no_hp_anggota, '-')                         AS hp,
       CASE status_anggota WHEN 'aktif' THEN 'Diskon 5%'
                           ELSE 'Tanpa diskon' END        AS keterangan
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;

-- ------------------------------------------------------------
-- Q6 | Fungsi tanggal | Sudah berapa hari tiap anggota mendaftar,
--      dan termasuk anggota "baru" (< 180 hari) atau "lama"?
-- Harapan: 5 baris. Tiga anggota 2026 berstatus "baru",
--          dua anggota 2024 berstatus "lama" (angka hari bergantung tanggal hari ini).
-- ------------------------------------------------------------
SELECT no_anggota, nama_anggota, tgl_daftar_anggota,
       DATEDIFF(CURDATE(), tgl_daftar_anggota) AS lama_hari,
       IF(DATEDIFF(CURDATE(), tgl_daftar_anggota) < 180, 'baru', 'lama') AS kategori
FROM anggota
ORDER BY tgl_daftar_anggota DESC;

-- ------------------------------------------------------------
-- Q7 | Perhitungan per baris | Apa saja isi nota PJ-2609-0142 dan berapa subtotalnya?
-- Harapan: 3 baris dengan subtotal 12000, 13000, dan 4000 (jumlah manual 29000,
--          cocok dengan nota di Modul 2; bayar 30000)
-- Catatan: id nota diambil lewat subkueri dari kode alaminya.
-- ------------------------------------------------------------
SELECT id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
       qty_detail_penjualan * harga_satuan_detail_penjualan AS subtotal
FROM detail_penjualan
WHERE id_penjualan = (SELECT id_penjualan FROM penjualan
                      WHERE no_nota_penjualan = 'PJ-2609-0142')
ORDER BY id_barang;

-- ------------------------------------------------------------
-- Latihan E.1 | Nama barang huruf kapital dan harga format "Rp4.000"
-- Harapan: 6 baris, contoh "PULPEN GEL 0.5" dengan "Rp4.000"
-- ------------------------------------------------------------
SELECT UPPER(nama_barang) AS nama_barang,
       CONCAT('Rp', FORMAT(harga_jual_barang, 0, 'id_ID')) AS harga
FROM barang
ORDER BY kode_barang;

-- ------------------------------------------------------------
-- Latihan E.2 | Kesalahan semantik: OR tanpa tanda kurung
-- Maksud: barang kategori ATK atau minuman yang stoknya di bawah 40 (harusnya 1 baris).
-- (a) SALAH, tetap berjalan tanpa galat dan hasilnya 3 baris (bukan 1),
--     karena AND dievaluasi lebih dulu dari OR sehingga SEMUA barang ATK
--     ikut tampil walaupun stoknya jauh di atas 40.
-- ------------------------------------------------------------
SELECT kode_barang, nama_barang, kategori_barang, stok_barang
FROM barang
WHERE kategori_barang = 'ATK' OR kategori_barang = 'minuman' AND stok_barang < 40
ORDER BY kode_barang;

-- (b) BENAR dengan tanda kurung. Harapan: 1 baris (MNM-002 Teh Botol, stok 36).
SELECT kode_barang, nama_barang, kategori_barang, stok_barang
FROM barang
WHERE (kategori_barang = 'ATK' OR kategori_barang = 'minuman') AND stok_barang < 40
ORDER BY kode_barang;
