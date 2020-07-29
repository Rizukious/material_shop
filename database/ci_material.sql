-- phpMyAdmin SQL Dump
-- version 4.9.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 27, 2020 at 05:07 PM
-- Server version: 10.4.8-MariaDB
-- PHP Version: 7.3.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ci_material`
--

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `kdBarang` char(8) NOT NULL,
  `idKategori` int(11) NOT NULL,
  `namaBarang` varchar(64) NOT NULL,
  `harga` int(11) NOT NULL,
  `stok` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`kdBarang`, `idKategori`, `namaBarang`, `harga`, `stok`) VALUES
('B2000001', 6, 'Pasir - Pick Up', 1000000, 10),
('B2000002', 7, 'Keramik Mulia 40x40', 50000, 20),
('B2000003', 6, 'Bata Merah Press Besar', 1000, 2000),
('B2000004', 1, 'Semen Tiga Roda 50kg', 50000, 50),
('B2000005', 3, 'Sekop Pasir', 50000, 12);

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `idKategori` int(11) NOT NULL,
  `namaKategori` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`idKategori`, `namaKategori`) VALUES
(1, 'Semen'),
(3, 'Alat'),
(5, 'Atap'),
(6, 'Material'),
(7, 'Keramik');

-- --------------------------------------------------------

--
-- Table structure for table `keranjang`
--

CREATE TABLE `keranjang` (
  `noItem` int(11) NOT NULL,
  `kdBarang` char(10) NOT NULL,
  `idUser` char(4) NOT NULL,
  `qty` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `keranjang`
--
DELIMITER $$
CREATE TRIGGER `after_update_stok` AFTER UPDATE ON `keranjang` FOR EACH ROW UPDATE barang SET stok = stok - NEW.qty WHERE barang.kdBarang = NEW.kdBarang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_update_stok` BEFORE UPDATE ON `keranjang` FOR EACH ROW UPDATE barang SET stok = stok + OLD.qty WHERE barang.kdBarang = OLD.kdBarang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `kurangi_stok` AFTER INSERT ON `keranjang` FOR EACH ROW UPDATE barang SET stok = stok - NEW.qty WHERE barang.kdBarang = NEW.kdBarang
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `reset_stok` BEFORE DELETE ON `keranjang` FOR EACH ROW UPDATE barang SET stok = stok + OLD.qty WHERE barang.kdBarang = OLD.kdBarang
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `idTransaksi` char(10) NOT NULL,
  `tanggal` date NOT NULL,
  `idUser` char(4) NOT NULL,
  `namaPelanggan` varchar(64) NOT NULL,
  `alamatPelanggan` varchar(128) NOT NULL,
  `totalHarga` int(11) NOT NULL,
  `uangBayar` int(11) NOT NULL,
  `kembalian` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`idTransaksi`, `tanggal`, `idUser`, `namaPelanggan`, `alamatPelanggan`, `totalHarga`, `uangBayar`, `kembalian`) VALUES
('T200627001', '2020-06-27', 'U001', 'Umum', '-', 150000, 200000, 50000);

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_detail`
--

CREATE TABLE `transaksi_detail` (
  `idTransaksi` char(10) NOT NULL,
  `kdBarang` char(8) NOT NULL,
  `qty` int(11) NOT NULL,
  `subtotal` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transaksi_detail`
--

INSERT INTO `transaksi_detail` (`idTransaksi`, `kdBarang`, `qty`, `subtotal`) VALUES
('T200627001', 'B2000005', 3, 150000);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `idUser` char(4) NOT NULL,
  `username` varchar(15) NOT NULL,
  `password` varchar(128) NOT NULL,
  `level` enum('administrator','petugas','kepala toko') NOT NULL,
  `nama` varchar(64) NOT NULL,
  `noTelp` varchar(20) NOT NULL,
  `foto` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`idUser`, `username`, `password`, `level`, `nama`, `noTelp`, `foto`) VALUES
('U001', 'admin', '$2y$10$R/ZJxF0U31Uq4IXhfMVE6OSG1h2efszpNiZP1RjRI9ifShCAU//Cy', 'administrator', 'Super Admin', '081212830909', 'c1b9b51347a0f82814a433282c601311.png'),
('U002', 'ridwan', '$2y$10$DsERQdSB3e/AOuedIbv6Qe7cnqTu/ELEiazh9iFsCmkDvDnkx//n2', 'petugas', 'Ahmad Ridwan', '082271928019', '9735431a87f0e36271eda24b531652a6.png'),
('U003', 'tencho', '$2y$10$PxZMMMcgGEh0PrEBygP4aunhXiG7qT1D6y9Ha3ccC5lG2CbjAVJem', 'kepala toko', 'Tencho dono', '081231231231', '012b28c1016f5ee71db387b85d6ccec2.png');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`kdBarang`),
  ADD KEY `idKategori` (`idKategori`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`idKategori`);

--
-- Indexes for table `keranjang`
--
ALTER TABLE `keranjang`
  ADD PRIMARY KEY (`noItem`),
  ADD KEY `kdBarang` (`kdBarang`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`idTransaksi`),
  ADD KEY `idUser` (`idUser`);

--
-- Indexes for table `transaksi_detail`
--
ALTER TABLE `transaksi_detail`
  ADD KEY `idTransaksi` (`idTransaksi`),
  ADD KEY `kdBarang` (`kdBarang`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`idUser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `idKategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `barang_ibfk_1` FOREIGN KEY (`idKategori`) REFERENCES `kategori` (`idKategori`);

--
-- Constraints for table `keranjang`
--
ALTER TABLE `keranjang`
  ADD CONSTRAINT `keranjang_ibfk_1` FOREIGN KEY (`kdBarang`) REFERENCES `barang` (`kdBarang`);

--
-- Constraints for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`idUser`) REFERENCES `user` (`idUser`);

--
-- Constraints for table `transaksi_detail`
--
ALTER TABLE `transaksi_detail`
  ADD CONSTRAINT `transaksi_detail_ibfk_2` FOREIGN KEY (`kdBarang`) REFERENCES `barang` (`kdBarang`),
  ADD CONSTRAINT `transaksi_detail_ibfk_3` FOREIGN KEY (`idTransaksi`) REFERENCES `transaksi` (`idTransaksi`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
