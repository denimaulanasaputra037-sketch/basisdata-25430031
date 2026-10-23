-- ============================================================
-- p05_ddl_25430031.sql
-- Milestone Proyek 5 - DDL Perpustakaan Happy Reading
-- Nama : Deni Maulana Saputra    NIM : 25430031
-- Basis data : perpus_031 (MariaDB 10.4.32, XAMPP 8.2.12)
-- Skema 3NF dari p04_normalisasi_25430031.md (7 tabel)
-- Komentar AB-xx / NFR-xx merujuk p02_kebutuhan_data_25430031.md
-- Parameter P = 5  ->  maks. 7 buku per transaksi (AB-11),
--                      denda Rp5.000 per hari (AB-08)
-- Skrip dapat dijalankan ulang dari basis data kosong.
-- ============================================================

USE perpus_031;

-- ------------------------------------------------------------
-- 1. Hapus tabel lama: ANAK dulu, baru INDUK
-- ------------------------------------------------------------
DROP TABLE IF EXISTS denda;
DROP TABLE IF EXISTS pengembalian;
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS petugas;

-- ------------------------------------------------------------
-- 2. Tabel induk
-- ------------------------------------------------------------
CREATE TABLE petugas (
  id_petugas   CHAR(5)      NOT NULL,                    -- PT001
  nama_petugas VARCHAR(100) NOT NULL,
  CONSTRAINT pk_petugas PRIMARY KEY (id_petugas),
  CONSTRAINT ck_petugas_id CHECK (id_petugas REGEXP '^PT[0-9]{3}$')   -- kamus data no. 7
) ENGINE=InnoDB;

CREATE TABLE buku (
  kode_buku    CHAR(5)      NOT NULL,                    -- BK001, AB-10
  judul_buku   VARCHAR(150) NOT NULL,
  pengarang    VARCHAR(100) NOT NULL,
  tahun_terbit YEAR         NOT NULL,                    -- 4 digit
  stok_buku    INT          NOT NULL DEFAULT 0,
  CONSTRAINT pk_buku PRIMARY KEY (kode_buku),
  CONSTRAINT ck_buku_kode CHECK (kode_buku REGEXP '^BK[0-9]{3}$'),    -- AB-10
  CONSTRAINT ck_buku_stok CHECK (stok_buku >= 0)                      -- kamus data no. 13
) ENGINE=InnoDB;

CREATE TABLE anggota (
  no_anggota        CHAR(5)      NOT NULL,               -- AG001, AB-01
  nim_anggota       CHAR(8)      NOT NULL,               -- 8 digit angka
  nama_anggota      VARCHAR(100) NOT NULL,
  no_hp_anggota     VARCHAR(15)  NOT NULL,               -- data pribadi (NFR-01)
  status_anggota    ENUM('Aktif','Nonaktif') NOT NULL DEFAULT 'Aktif',
  tgl_daftar        DATE         NOT NULL,
  id_petugas_daftar CHAR(5)      NOT NULL,               -- petugas pencatat pendaftaran (PB-01)
  CONSTRAINT pk_anggota PRIMARY KEY (no_anggota),
  CONSTRAINT uq_anggota_nim UNIQUE KEY (nim_anggota),                 -- AB-02
  CONSTRAINT ck_anggota_no  CHECK (no_anggota REGEXP '^AG[0-9]{3}$'),     -- AB-01
  CONSTRAINT ck_anggota_nim CHECK (nim_anggota REGEXP '^[0-9]{8}$'),
  CONSTRAINT ck_anggota_hp  CHECK (no_hp_anggota REGEXP '^[0-9]+$'),
  CONSTRAINT fk_anggota_petugas FOREIGN KEY (id_petugas_daftar)
    REFERENCES petugas (id_petugas)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 3. Tabel transaksi
--    Semua kunci tamu memakai ON DELETE RESTRICT (bawaan): riwayat
--    transaksi harus tetap tersimpan (NFR-02, NFR-04).
-- ------------------------------------------------------------
CREATE TABLE peminjaman (
  no_peminjaman   CHAR(5) NOT NULL,                      -- PM001
  tgl_peminjaman  DATE    NOT NULL,
  tgl_jatuh_tempo DATE    NOT NULL,
  id_petugas      CHAR(5) NOT NULL,                      -- AB-09
  no_anggota      CHAR(5) NOT NULL,                      -- AB-04
  CONSTRAINT pk_peminjaman PRIMARY KEY (no_peminjaman),
  CONSTRAINT ck_peminjaman_no CHECK (no_peminjaman REGEXP '^PM[0-9]{3}$'),   -- NFR-03
  -- AB-12: lama peminjaman maksimal 7 hari (dan tidak mundur)
  CONSTRAINT ck_peminjaman_tempo CHECK (
    tgl_jatuh_tempo >= tgl_peminjaman
    AND tgl_jatuh_tempo <= DATE_ADD(tgl_peminjaman, INTERVAL 7 DAY)),
  CONSTRAINT fk_peminjaman_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas),
  CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (no_anggota)
    REFERENCES anggota (no_anggota)
) ENGINE=InnoDB;

CREATE TABLE detail_peminjaman (
  no_peminjaman  CHAR(5) NOT NULL,
  kode_buku      CHAR(5) NOT NULL,
  kondisi_keluar ENUM('Baik','Rusak ringan') NOT NULL,   -- AB-13
  CONSTRAINT pk_detail_peminjaman PRIMARY KEY (no_peminjaman, kode_buku),
  CONSTRAINT fk_detail_peminjaman FOREIGN KEY (no_peminjaman)
    REFERENCES peminjaman (no_peminjaman),
  CONSTRAINT fk_detail_buku FOREIGN KEY (kode_buku)
    REFERENCES buku (kode_buku)
) ENGINE=InnoDB;

CREATE TABLE pengembalian (
  no_pengembalian  CHAR(5) NOT NULL,                     -- PG001
  tgl_pengembalian DATE    NOT NULL,
  no_peminjaman    CHAR(5) NOT NULL,                     -- AB-07
  id_petugas       CHAR(5) NOT NULL,                     -- AB-09
  CONSTRAINT pk_pengembalian PRIMARY KEY (no_pengembalian),
  CONSTRAINT uq_pengembalian_pinjam UNIQUE KEY (no_peminjaman),      -- satu peminjaman, satu pengembalian
  CONSTRAINT ck_pengembalian_no CHECK (no_pengembalian REGEXP '^PG[0-9]{3}$'),   -- NFR-03
  CONSTRAINT fk_pengembalian_peminjaman FOREIGN KEY (no_peminjaman)
    REFERENCES peminjaman (no_peminjaman),
  CONSTRAINT fk_pengembalian_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas)
) ENGINE=InnoDB;

CREATE TABLE denda (
  id_denda           CHAR(5)       NOT NULL,             -- DN001
  no_pengembalian    CHAR(5)       NOT NULL,
  tarif_denda_harian DECIMAL(10,2) NOT NULL DEFAULT 5000, -- AB-08, P = 5
  status_bayar       ENUM('Lunas','Belum Lunas') NOT NULL DEFAULT 'Belum Lunas',
  CONSTRAINT pk_denda PRIMARY KEY (id_denda),
  CONSTRAINT uq_denda_pengembalian UNIQUE KEY (no_pengembalian),     -- paling banyak satu denda
  CONSTRAINT ck_denda_id CHECK (id_denda REGEXP '^DN[0-9]{3}$'),
  CONSTRAINT ck_denda_tarif CHECK (tarif_denda_harian > 0),          -- AB-08
  CONSTRAINT fk_denda_pengembalian FOREIGN KEY (no_pengembalian)
    REFERENCES pengembalian (no_pengembalian)
) ENGINE=InnoDB;

-- ------------------------------------------------------------
-- 4. Aturan bisnis yang TIDAK dapat dijaga constraint
--    (melibatkan banyak baris atau tabel lain; diselesaikan di Modul 14)
--    AB-03  Hanya anggota berstatus Aktif yang boleh meminjam
--    AB-05  Satu peminjaman minimal satu buku
--    AB-06  Buku hanya dapat dipinjam jika stok > 0 (dan stok dikurangi)
--    AB-11  Satu peminjaman maksimal 7 buku (P + 2)  -> jumlah baris detail
--    AB-07  tgl_pengembalian tidak boleh sebelum tgl_peminjaman (lintas tabel)
-- ------------------------------------------------------------

SHOW TABLES;
