-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2023 at 08:08 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterit_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_carts`
--

CREATE TABLE `tbl_carts` (
  `cart_id` int(5) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_name` varchar(200) NOT NULL,
  `user_id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `reg_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_carts`
--

INSERT INTO `tbl_carts` (`cart_id`, `item_id`, `item_name`, `user_id`, `seller_id`, `reg_date`) VALUES
(1, 3, 'Adidas Yeezy 350', 20, 18, '2023-07-14 16:54:52.935384'),
(2, 6, 'Nike Dunk Low Panda', 20, 18, '2023-07-14 16:54:54.913867'),
(3, 2, 'Multicooker', 20, 18, '2023-07-14 16:54:57.124105');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_items`
--

CREATE TABLE `tbl_items` (
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `item_desc` varchar(255) NOT NULL,
  `item_type` varchar(255) NOT NULL,
  `item_interest` varchar(255) NOT NULL,
  `item_lat` varchar(50) NOT NULL,
  `item_long` varchar(50) NOT NULL,
  `item_state` varchar(255) NOT NULL,
  `item_locality` varchar(255) NOT NULL,
  `item_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `user_id`, `item_name`, `item_desc`, `item_type`, `item_interest`, `item_lat`, `item_long`, `item_state`, `item_locality`, `item_date`) VALUES
(15, 21, 'Multicooker', 'Perry Smith Multicooker, great condition', 'Electrical Appliances', 'Table Fan', '6.4502267', '100.4958833', 'Kedah', 'Changlun', '2023-07-20 11:31:29'),
(16, 21, 'Bicycle', 'BMX Bicycle, 8/10 Condition', 'Other', 'Other brand of bicycle', '6.4502267', '100.4958833', 'Kedah', 'Changlun', '2023-07-20 11:54:33'),
(17, 21, 'Shirt', 'Stussy Brand, Size Large Wear once', 'Clothing', 'Another design of Stussy', '6.4502267', '100.4958833', 'Kedah', 'Changlun', '2023-07-20 11:57:45'),
(18, 21, 'Paracetamol', '500mg of Panadol Actifast', 'Medicines', 'Coughing medicines', '6.4502267', '100.4958833', 'Kedah', 'Changlun', '2023-07-20 11:58:53'),
(25, 20, 'Nike Jordan ', 'Jumpman Black T-Shirt M size', 'Clothing', 'L Size', '6.4502267', '100.4958833', 'Kedah', 'Changlun', '2023-07-20 12:14:45'),
(26, 20, 'Yonex Kurenai 100zz', 'Great Condition, No scratches', 'Other', 'Astrox 99', '6.4502267', '100.4958833', 'Kedah', 'Changlun', '2023-07-20 12:16:54');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_order`
--

CREATE TABLE `tbl_order` (
  `buyer_id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `item_name` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_order`
--

INSERT INTO `tbl_order` (`buyer_id`, `seller_id`, `item_id`, `item_name`) VALUES
(21, 18, 11, 'Malaysian Snack'),
(21, 18, 24, 'Bowling ball'),
(21, 18, 23, 'OFF-WHITE UNC'),
(21, 18, 22, 'Travis Scott Phantom'),
(21, 18, 21, 'AJ1 Travis Scott Olive'),
(21, 18, 20, 'Adidas Yeezy 350'),
(18, 21, 13, 'Camera'),
(18, 21, 14, 'Shoes'),
(21, 18, 19, 'Snacks');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE `tbl_user` (
  `user_id` int(10) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(30) NOT NULL,
  `user_phone` varchar(12) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_otp` varchar(6) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_otp`, `user_datereg`) VALUES
(18, 'zhenseng01@gmail.com', 'acc1', '0162420019', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '22421', '2023-05-21 23:40:55.071114'),
(20, 'zhenseng02@gmail.com', 'zhenseng', '0124567891', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '16341', '2023-07-03 15:10:44.515524'),
(21, 'zhenseng01@gmail.com', 'ikuyazz', '0162420019', 'c9b359951c09c5d04de4f852746671ab2b2d0994', '16436', '2023-07-11 01:56:37.744587');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_name` (`user_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  MODIFY `cart_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=66;

--
-- AUTO_INCREMENT for table `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `user_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
