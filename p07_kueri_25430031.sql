-- ============================================================
-- p07_kueri_25430031.sql
-- Milestone Proyek 7 - Kueri satu tabel Perpustakaan Happy Reading
-- Nama : Deni Maulana Saputra    NIM : 25430031
-- Basis data : perpus_031 (data dari p06_data_25430031.sql)
-- Setiap kueri diberi komentar: kode KI, pertanyaan sehari-hari,
-- dan hasil yang diharapkan (dihitung dari isi p06_data sebelum dijalankan).
-- Semua kueri hanya SELECT, jadi aman dijalankan berulang kali.
--
-- PEMETAAN KUERI -> KEBUTUHAN INFORMASI (KI) DARI p02
--   KI-01  Q1                  (anggota aktif)
--   KI-02  Q2                  (buku yang stoknya tersedia)
--   KI-03  Q3                  (buku dengan stok paling sedikit)
--   KI-06  Q8 (sebagian)       (status denda; nama anggotanya butuh join)
--   Tambahan pendukung (bukan KI): Q4, Q5, Q6, Q7, Q9, Q10
--
-- KI YANG BELUM DAPAT DIJAWAB DENGAN SATU TABEL (dijawab Pertemuan 9-12):
--   KI-04  Buku yang sedang dipinjam
--          -> butuh peminjaman + detail_peminjaman + buku + pengembalian
--   KI-05  Anggota yang terlambat mengembalikan buku
--          -> butuh peminjaman + pengembalian + anggota (jatuh tempo ada di peminjaman)
--   KI-06  Denda anggota yang belum dibayar (lengkap dengan nama)
--          -> butuh denda + pengembalian + peminjaman + anggota
-- ============================================================

USE perpus_031;

-- ------------------------------------------------------------
-- Q1 | KI-01 | Siapa saja anggota yang berstatus Aktif?
-- Harapan: 6 baris -> AG001 sampai AG006 (AG007 dan AG008 Nonaktif tidak ikut)
-- ------------------------------------------------------------
SELECT no_anggota, nama_anggota, status_anggota
FROM anggota
WHERE status_anggota = 'Aktif'
ORDER BY no_anggota;

-- ------------------------------------------------------------
-- Q2 | KI-02 | Buku apa saja yang stoknya masih tersedia?
-- Harapan: 12 baris (semua buku). Stok terkecil 15 (BK007), terbesar 19.
--          Stok awal 20 dikurangi buku yang masih dipinjam (PM036-PM050).
-- ------------------------------------------------------------
SELECT kode_buku, judul_buku, stok_buku
FROM buku
WHERE stok_buku > 0
ORDER BY kode_buku;

-- ------------------------------------------------------------
-- Q3 | KI-03 | Tiga buku mana yang stoknya paling sedikit?
-- Harapan: 3 baris -> BK007 (15), BK001 (16), BK009 (16).
--          BK001 dan BK009 sama-sama 16, jadi diurutkan lagi menurut kode_buku.
-- ------------------------------------------------------------
SELECT kode_buku, judul_buku, stok_buku
FROM buku
ORDER BY stok_buku ASC, kode_buku ASC
LIMIT 3;

-- ------------------------------------------------------------
-- Q4 | BETWEEN | Buku apa saja yang terbit antara tahun 2015 dan 2020?
-- Harapan: 6 baris, urut tahun: BK006 (2016), BK012 (2017), BK003 (2018),
--          BK004 (2018), BK011 (2019), BK007 (2020). BETWEEN ikut menyertakan
--          batas 2015 dan 2020 (tidak ada buku terbit tepat 2015).
-- ------------------------------------------------------------
SELECT kode_buku, judul_buku, tahun_terbit
FROM buku
WHERE tahun_terbit BETWEEN 2015 AND 2020
ORDER BY tahun_terbit, kode_buku;

-- ------------------------------------------------------------
-- Q5 | IN | Peminjaman tanggal 5 Oktober 2026 yang dicatat oleh PT001 atau PT002?
-- Harapan: 4 baris -> PM001 (PT001), PM002 (PT002), PM006 (PT001), PM007 (PT002)
-- ------------------------------------------------------------
SELECT no_peminjaman, tgl_peminjaman, id_petugas, no_anggota
FROM peminjaman
WHERE id_petugas IN ('PT001', 'PT002')
  AND tgl_peminjaman = '2026-10-05'
ORDER BY no_peminjaman;

-- ------------------------------------------------------------
-- Q6 | LIKE + fungsi string CONCAT | Buku apa saja yang judulnya mengandung
--      kata "data", ditampilkan sebagai satu label "judul - pengarang"?
-- Harapan: 2 baris -> "Sistem Basis Data - Ramez Elmasri" (BK006) dan
--          "Algoritma dan Struktur Data - Rinaldi Munir" (BK011).
--          LIKE tidak membedakan huruf besar dan kecil pada data ini.
-- ------------------------------------------------------------
SELECT kode_buku,
       CONCAT(judul_buku, ' - ', pengarang) AS label_buku
FROM buku
WHERE judul_buku LIKE '%data%'
ORDER BY kode_buku;

-- ------------------------------------------------------------
-- Q7 | IS NULL | Anggota mana yang belum punya nomor HP?
-- Harapan: 0 baris. Kolom no_hp_anggota dibuat NOT NULL (wajib diisi menurut
--          kamus data), jadi tidak mungkin ada baris yang kosong. Hasil kosong
--          di sini justru membuktikan constraint NOT NULL bekerja.
-- ------------------------------------------------------------
SELECT no_anggota, nama_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;

-- ------------------------------------------------------------
-- Q8 | KI-06 (sebagian) + CASE | Bagaimana status pembayaran setiap denda?
-- Harapan: 8 baris. DN001, DN003, DN005, DN007 = "Sudah dibayar";
--          DN002, DN004, DN006, DN008 = "Menunggu pembayaran".
-- Catatan: nama anggota yang berutang belum bisa ditampilkan (butuh join).
-- ------------------------------------------------------------
SELECT id_denda, no_pengembalian, tarif_denda_harian, status_bayar,
       CASE status_bayar
            WHEN 'Lunas' THEN 'Sudah dibayar'
            ELSE 'Menunggu pembayaran'
       END AS keterangan
FROM denda
ORDER BY id_denda;

-- ------------------------------------------------------------
-- Q9 | Fungsi tanggal DATEDIFF | Berapa hari lama pinjam tiap peminjaman
--      (jatuh tempo dikurangi tanggal pinjam)? Tampilkan 5 teratas.
-- Harapan: 5 baris, semuanya 7 hari (batas maksimal AB-12):
--          PM001, PM003, PM005, PM006, PM007.
-- ------------------------------------------------------------
SELECT no_peminjaman, tgl_peminjaman, tgl_jatuh_tempo,
       DATEDIFF(tgl_jatuh_tempo, tgl_peminjaman) AS lama_pinjam_hari
FROM peminjaman
ORDER BY lama_pinjam_hari DESC, no_peminjaman ASC
LIMIT 5;

-- ------------------------------------------------------------
-- Q10 | DATE_FORMAT | Pengembalian apa saja yang dicatat petugas PT003,
--       dengan tanggal berformat Indonesia?
-- Harapan: 7 baris, urut tanggal: PG001 (09-10-2026), PG026 (09-10-2026),
--          PG011 (10-10-2026), PG031 (10-10-2026), PG021 (11-10-2026),
--          PG006 (12-10-2026), PG016 (16-10-2026).
-- ------------------------------------------------------------
SELECT no_pengembalian, no_peminjaman,
       DATE_FORMAT(tgl_pengembalian, '%d-%m-%Y') AS tgl_kembali
FROM pengembalian
WHERE id_petugas = 'PT003'
ORDER BY tgl_pengembalian, no_pengembalian;
