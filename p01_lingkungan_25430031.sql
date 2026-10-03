-- Praktikum Basis Data - Modul 1
-- NIM: 25430031
-- 3 Digit NIM: 031
-- Tema: Perpustakaan
-- Nama Database: perpus_031
-- Nama User Database: dev_031

CREATE DATABASE IF NOT EXISTS perpus_031;
USE perpus_031;

-- Pemeriksaan lingkungan
SELECT VERSION(), CURRENT_USER();
SELECT @@sql_mode;
SHOW DATABASES;