-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Oct 23, 2025 at 10:45 PM
-- Server version: 8.0.43-0ubuntu0.24.04.2
-- PHP Version: 8.4.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mirzabot`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id_admin` varchar(200) NOT NULL,
  `rule` varchar(200) DEFAULT NULL,
  `username` varchar(200) DEFAULT NULL,
  `password` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id_admin`, `rule`, `username`, `password`) VALUES
('2108443782', 'administrator', 'test', '0');

-- --------------------------------------------------------

--
-- Table structure for table `affiliates`
--

CREATE TABLE `affiliates` (
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `status_commission` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Discount` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `price_Discount` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `id_media` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `affiliatesstatus` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `affiliatespercentage` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `porsant_one_buy` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `affiliates`
--

INSERT INTO `affiliates` (`description`, `status_commission`, `Discount`, `price_Discount`, `id_media`, `affiliatesstatus`, `affiliatespercentage`, `porsant_one_buy`) VALUES
('none', 'oncommission', 'onDiscountaffiliates', NULL, 'none', 'offaffiliates', '0', 'off_buy_porsant');

-- --------------------------------------------------------

--
-- Table structure for table `app`
--

CREATE TABLE `app` (
  `id` int UNSIGNED NOT NULL,
  `name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `link` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `botsaz`
--

CREATE TABLE `botsaz` (
  `id` int UNSIGNED NOT NULL,
  `id_user` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `bot_token` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `admin_ids` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `hide_panel` json NOT NULL,
  `time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cancel_service`
--

CREATE TABLE `cancel_service` (
  `id` int UNSIGNED NOT NULL,
  `id_user` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `username` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `status` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `card_number`
--

CREATE TABLE `card_number` (
  `cardnumber` varchar(500) NOT NULL,
  `namecard` varchar(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` int UNSIGNED NOT NULL,
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `channels`
--

CREATE TABLE `channels` (
  `link` varchar(200) NOT NULL,
  `remark` varchar(200) DEFAULT NULL,
  `linkjoin` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `departman`
--

CREATE TABLE `departman` (
  `id` int UNSIGNED NOT NULL,
  `idsupport` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_departman` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Discount`
--

CREATE TABLE `Discount` (
  `id` int UNSIGNED NOT NULL,
  `code` varchar(2000) DEFAULT NULL,
  `price` varchar(200) DEFAULT NULL,
  `limituse` varchar(200) DEFAULT NULL,
  `limitused` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `DiscountSell`
--

CREATE TABLE `DiscountSell` (
  `id` int UNSIGNED NOT NULL,
  `codeDiscount` varchar(1000) NOT NULL,
  `price` varchar(200) NOT NULL,
  `limitDiscount` varchar(500) NOT NULL,
  `usedDiscount` varchar(500) NOT NULL,
  `usefirst` varchar(500) NOT NULL,
  `agent` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `time` varchar(100) DEFAULT NULL,
  `code_panel` varchar(100) DEFAULT NULL,
  `code_product` varchar(100) DEFAULT NULL,
  `useuser` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Giftcodeconsumed`
--

CREATE TABLE `Giftcodeconsumed` (
  `id` int UNSIGNED NOT NULL,
  `code` varchar(2000) DEFAULT NULL,
  `id_user` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `help`
--

CREATE TABLE `help` (
  `id` int UNSIGNED NOT NULL,
  `name_os` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Media_os` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `type_Media_os` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `Description_os` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `category` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `invoice`
--

CREATE TABLE `invoice` (
  `id_invoice` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `id_user` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `username` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL,
  `Service_location` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL,
  `time_sell` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL,
  `name_product` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL,
  `price_product` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL,
  `Volume` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL,
  `Service_time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `user_info` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `Status` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `note` varchar(700) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `notifctions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `time_cron` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `refral` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `bottype` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `uuid` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `invoice`
--

INSERT INTO `invoice` (`id_invoice`, `id_user`, `username`, `Service_location`, `time_sell`, `name_product`, `price_product`, `Volume`, `Service_time`, `user_info`, `Status`, `note`, `notifctions`, `time_cron`, `refral`, `bottype`, `uuid`) VALUES
('b99c6c3d', '0123456789', '0123456789_abd3', 'test', '1761148274', 'test', '45000', '30', '30', NULL, 'active', NULL, '{\"volume\":false,\"time\":false}', '1761257764', '0', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `logs_api`
--

CREATE TABLE `logs_api` (
  `id` int UNSIGNED NOT NULL,
  `header` json DEFAULT NULL,
  `data` json DEFAULT NULL,
  `ip` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `actions` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `manualsell`
--

CREATE TABLE `manualsell` (
  `id` int UNSIGNED NOT NULL,
  `codepanel` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `codeproduct` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `namerecord` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contentrecord` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `marzban_panel`
--

CREATE TABLE `marzban_panel` (
  `id` int UNSIGNED NOT NULL,
  `name_panel` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `url_panel` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `username_panel` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `password_panel` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `statusTest` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `linksubx` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `inboundid` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `MethodUsername` varchar(900) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `sublink` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `configManual` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `onholdstatus` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `datelogin` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `inbounds` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `proxies` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `on_hold_test` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `customvolume` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `subvip` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `changeloc` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `hide_user` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `status_extend` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `code_panel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `priceextravolume` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `pricecustomvolume` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `pricecustomtime` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `priceextratime` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `priceChangeloc` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `mainvolume` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `maxvolume` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `maintime` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `maxtime` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `val_usertest` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time_usertest` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `secret_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `inboundstatus` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `inbound_deactive` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `agent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `conecton` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Methodextend` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `namecustom` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `limit_panel` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `TestAccount` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `config` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `Payment_report`
--

CREATE TABLE `Payment_report` (
  `id` int UNSIGNED NOT NULL,
  `id_user` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `id_order` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `price` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `dec_not_confirmed` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Payment_Method` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `payment_Status` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `invoice` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `message_id` int DEFAULT NULL,
  `bottype` varchar(300) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `at_updated` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `id_invoice` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `PaySetting`
--

CREATE TABLE `PaySetting` (
  `NamePay` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `ValuePay` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `PaySetting`
--

INSERT INTO `PaySetting` (`NamePay`, `ValuePay`) VALUES
('CartDescription', '603700000000'),
('CartDirect', '@cart'),
('Cartstatus', 'oncard'),
('Cartstatuspv', 'offcardpv'),
('Exception_auto_cart', '{}'),
('apiiranpay', '0'),
('apinowpayment', '0'),
('apiternado', '0'),
('autoconfirmcart', 'offauto'),
('cardnumber', '603700000000'),
('cashbacknowpayment', '0'),
('chashbackaqaypardokht', '0'),
('chashbackcart', '0'),
('chashbackiranpay1', '0'),
('chashbackiranpay2', '0'),
('chashbackiranpay3', '0'),
('chashbackperfect', '0'),
('chashbackplisio', '0'),
('chashbackstar', '0'),
('chashbackzarinpal', '0'),
('checkpaycartfirst', 'offpayverify'),
('digistatus', 'offdigi'),
('helpaqayepardakht', '2'),
('helpcart', '2'),
('helpiranpay1', '2'),
('helpiranpay2', '2'),
('helpiranpay3', '2'),
('helpnowpayment', '2'),
('helpofflinearze', '2'),
('helpperfectmony', '2'),
('helpplisio', '2'),
('helpstar', '2'),
('helpzarinpal', '2'),
('marchent_floypay', '0'),
('marchent_tronseller', '0'),
('maxbalance', '{\"f\":\"1000000\",\"n\":\"1000000\",\"n2\":\"1000000\"}'),
('maxbalanceaqayepardakht', '1000000'),
('maxbalancecart', '1000000'),
('maxbalancedigitaltron', '1000000'),
('maxbalanceiranpay', '1000000'),
('maxbalanceiranpay1', '1000000'),
('maxbalanceiranpay2', '1000000'),
('maxbalancenowpayment', '1000000'),
('maxbalancepaynotverify', '1000000'),
('maxbalanceperfect', '1000000'),
('maxbalanceplisio', '1000000'),
('maxbalancestar', '1000000'),
('maxbalancezarinpal', '1000000'),
('merchant_id_aqayepardakht', '0'),
('merchant_zarinpal', '0'),
('minbalance', '{\"f\":\"20000\",\"n\":\"20000\",\"n2\":\"20000\"}'),
('minbalanceaqayepardakht', '20000'),
('minbalancecart', '20000'),
('minbalancedigitaltron', '20000'),
('minbalanceiranpay', '20000'),
('minbalanceiranpay1', '20000'),
('minbalanceiranpay2', '20000'),
('minbalancenowpayment', '20000'),
('minbalancepaynotverify', '20000'),
('minbalanceperfect', '20000'),
('minbalanceplisio', '20000'),
('minbalancestar', '20000'),
('minbalancezarinpal', '20000'),
('namecard', 'تنظیم نشده'),
('nowpaymentstatus', 'offnowpayment'),
('statusSwapWallet', 'offnSolutions'),
('statusaqayepardakht', 'offaqayepardakht'),
('statuscardautoconfirm', 'offautoconfirm'),
('statusiranpay3', 'oniranpay3'),
('statusnowpayment', '0'),
('statusstar', '0'),
('statustarnado', 'offternado'),
('urlpaymenttron', 'https://tronseller.storeddownloader.fun/api/GetOrderToken'),
('walletaddress', '0'),
('zarinpalstatus', 'offzarinpal');

-- --------------------------------------------------------

--
-- Table structure for table `product`
--

CREATE TABLE `product` (
  `id` int UNSIGNED NOT NULL,
  `code_product` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `name_product` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `price_product` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Volume_constraint` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Location` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Service_time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `Category` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `one_buy_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `inbounds` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `proxies` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `hide_panel` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin,
  `data_limit_reset` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `agent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `reagent_report`
--

CREATE TABLE `reagent_report` (
  `id` int UNSIGNED NOT NULL,
  `user_id` bigint NOT NULL,
  `get_gift` tinyint(1) NOT NULL,
  `time` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `reagent` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `Requestagent`
--

CREATE TABLE `Requestagent` (
  `id` varchar(500) NOT NULL,
  `username` varchar(500) NOT NULL,
  `time` varchar(500) NOT NULL,
  `Description` varchar(500) NOT NULL,
  `status` varchar(500) NOT NULL,
  `type` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_other`
--

CREATE TABLE `service_other` (
  `id` int UNSIGNED NOT NULL,
  `id_user` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `username` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `output` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `setting`
--

CREATE TABLE `setting` (
  `Bot_Status` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `roll_Status` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `get_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `iran_number` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NotUser` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Channel_Report` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `limit_usertest_all` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `affiliatesstatus` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `affiliatespercentage` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `removedayc` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `showcard` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `numbercount` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statusnewuser` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statusagentrequest` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statuscategory` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statusterffh` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `volumewarn` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `inlinebtnmain` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verifystart` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_support` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statusnamecustom` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statuscategorygenral` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statussupportpv` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `agentreqprice` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `bulkbuy` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `on_hold_day` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cronvolumere` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verifybucodeuser` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `scorestatus` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Lottery_prize` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `wheelـluck` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wheelـluck_price` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `btn_status_extned` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `daywarn` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `categoryhelp` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `linkappstatus` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `iplogin` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wheelagent` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Lotteryagent` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `languageen` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `languageru` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statusfirstwheel` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `statuslimitchangeloc` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Debtsettlement` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Dice` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `keyboardmain` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `statusnoteforf` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `statuscopycart` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `timeauto_not_verify` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status_keyboard_config` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cron_status` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `limitnumber` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `setting`
--

INSERT INTO `setting` (`Bot_Status`, `roll_Status`, `get_number`, `iran_number`, `NotUser`, `Channel_Report`, `limit_usertest_all`, `affiliatesstatus`, `affiliatespercentage`, `removedayc`, `showcard`, `numbercount`, `statusnewuser`, `statusagentrequest`, `statuscategory`, `statusterffh`, `volumewarn`, `inlinebtnmain`, `verifystart`, `id_support`, `statusnamecustom`, `statuscategorygenral`, `statussupportpv`, `agentreqprice`, `bulkbuy`, `on_hold_day`, `cronvolumere`, `verifybucodeuser`, `scorestatus`, `Lottery_prize`, `wheelـluck`, `wheelـluck_price`, `btn_status_extned`, `daywarn`, `categoryhelp`, `linkappstatus`, `iplogin`, `wheelagent`, `Lotteryagent`, `languageen`, `languageru`, `statusfirstwheel`, `statuslimitchangeloc`, `Debtsettlement`, `Dice`, `keyboardmain`, `statusnoteforf`, `statuscopycart`, `timeauto_not_verify`, `status_keyboard_config`, `cron_status`, `limitnumber`) VALUES
('botstatuson', 'rolleon', 'onAuthenticationphone', 'onAuthenticationiran', 'onnotuser', NULL, '1', 'onaffiliates', '0', '0', '1', '0', 'onnewuser', 'onrequestagent', 'offcategory', NULL, '2', 'offinline', 'offverify', 'tlgrmv2', 'onnamecustom', 'offcategorys', 'offpvsupport', '0', 'onbulk', '4', '5', 'offverify', '1', '{\"one\":\"0\",\"tow\":\"0\",\"theree\":\"0\"}', '1', '0', NULL, '2', '1', '1', '62.60.217.66', '1', '0', '0', '0', '1', '1', '0', '1', '{\"keyboard\":[[{\"text\":\"text_sell\"},{\"text\":\"text_extend\"}],[{\"text\":\"text_usertest\"},{\"text\":\"text_wheel_luck\"}],[{\"text\":\"text_Purchased_services\"},{\"text\":\"accountwallet\"}],[{\"text\":\"text_affiliates\"},{\"text\":\"text_Tariff_list\"}],[{\"text\":\"text_support\"},{\"text\":\"text_help\"}]]}', '1', '0', '4', '1', '{\"day\":false,\"volume\":true,\"remove\":true,\"remove_volume\":true,\"test\":false,\"on_hold\":true,\"uptime_node\":false,\"uptime_panel\":false}', '{\"free\":100,\"all\":100}');

-- --------------------------------------------------------

--
-- Table structure for table `shopSetting`
--

CREATE TABLE `shopSetting` (
  `Namevalue` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `shopSetting`
--

INSERT INTO `shopSetting` (`Namevalue`, `value`) VALUES
('backserviecstatus', 'on'),
('chashbackextend', '0'),
('chashbackextend_agent', '{\"n\":0,\"n2\":0}'),
('configshow', 'onconfig'),
('customtimepricef', '4000'),
('customtimepricen', '4000'),
('customtimepricen2', '4000'),
('customvolmef', '4000'),
('customvolmen', '4000'),
('customvolmen2', '4000'),
('minbalancebuybulk', '0'),
('statuschangeservice', 'onstatus'),
('statusdirectpabuy', 'ondirectbuy'),
('statusdisorder', 'offdisorder'),
('statusextra', 'onextra'),
('statusshowprice', 'onshowprice'),
('statustimeextra', 'ontimeextraa');

-- --------------------------------------------------------

--
-- Table structure for table `support_message`
--

CREATE TABLE `support_message` (
  `id` int UNSIGNED NOT NULL,
  `Tracking` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `idsupport` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `iduser` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name_departman` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `result` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('Answered','Pending','Unseen','Customerresponse','close') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `textbot`
--

CREATE TABLE `textbot` (
  `id_text` varchar(600) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

--
-- Dumping data for table `textbot`
--

INSERT INTO `textbot` (`id_text`, `text`) VALUES
('accountwallet', '🏦 کیف پول + شارژ'),
('aqayepardakht', '🔵 درگاه آقای پرداخت'),
('carttocart', '💳 کارت به کارت'),
('crontest', 'با سلام خدمت شما کاربر گرامی \nسرویس تست شما با نام کاربری {username} به پایان رسیده است\nامیدواریم تجربه‌ی خوبی از آسودگی و سرعت سرویستون داشته باشین. در صورتی که از سرویس‌ تست خودتون راضی بودین، میتونید سرویس اختصاصی خودتون رو تهیه کنید و از داشتن اینترنت آزاد با نهایت کیفیت لذت ببرید😉🔥\n🛍 برای تهیه سرویس با کیفیت می توانید از دکمه زیر استفاده نمایید'),
('iranpay1', '💸 درگاه  پرداخت ریالی'),
('iranpay2', '💸 درگاه  پرداخت ریالی دوم'),
('iranpay3', '💸 درگاه  پرداخت ریالی سوم'),
('mowpayment', '💸 پرداخت با ارز دیجیتال'),
('text_Account_op', '🎛 حساب کاربری'),
('text_Add_Balance', '💰 افزایش موجودی'),
('text_Discount', '🎁 کد هدیه'),
('text_Purchased_services', '🛍 سرویس های من'),
('text_Tariff_list', '💰 تعرفه اشتراک ها'),
('text_account', '👨🏻‍💻 مشخصات کاربری'),
('text_affiliates', '👥 زیر مجموعه گیری'),
('text_bot_off', '❌ ربات خاموش است، لطفا دقایقی دیگر مراجعه کنید'),
('text_cart', 'برای افزایش موجودی، مبلغ <code>{price}</code>  تومان  را به شماره‌ی حساب زیر واریز کنید 👇🏻\n        \n        ==================== \n        <code>{card_number}</code>\n        {name_card}\n        ====================\n\n❌ این تراکنش به مدت یک ساعت اعتبار دارد پس از آن امکان پرداخت این تراکنش امکان ندارد.        \n‼مبلغ باید همان مبلغی که در بالا ذکر شده واریز نمایید.\n‼️امکان برداشت وجه از کیف پول نیست.\n‼️مسئولیت واریز اشتباهی با شماست.\n🔝بعد از پرداخت  دکمه پرداخت کردم را زده سپس تصویر رسید را ارسال نمایید\n💵بعد از تایید پرداختتون توسط ادمین کیف پول شما شارژ خواهد شد و در صورتی که سفارشی داشته باشین انجام خواهد شد'),
('text_cart_auto', 'برای تایید فوری لطفا دقیقاً مبلغ زیر واریز شود. در غیر این صورت تایید پرداخت شما ممکن است با تاخیر مواجه شود.⚠️\n            برای افزایش موجودی، مبلغ <code>{price}</code>  ریال  را به شماره‌ی حساب زیر واریز کنید 👇🏻\n\n        ==================== \n        <code>{card_number}</code>\n        {name_card}\n        ====================\n        \n💰دقیقا مبلغی را که در بالا ذکر شده واریز نمایید تا بصورت آنی تایید شود.\n‼️امکان برداشت وجه از کیف پول نیست.\n🔝لزومی به ارسال رسید نیست، اما در صورتی که بعد از گذشت مدتی واریز شما تایید نشد، عکس رسید خود را ارسال کنید.'),
('text_channel', '   \n        ⚠️ کاربر گرامی؛ شما عضو چنل ما نیستید\nاز طریق دکمه زیر وارد کانال شده و عضو شوید\nپس از عضویت دکمه بررسی عضویت را کلیک کنید'),
('text_dec_Tariff_list', 'not set'),
('text_dec_fq', ' \n 💡 سوالات متداول ⁉️\n\n1️⃣ فیلترشکن شما آیپی ثابته؟ میتونم برای صرافی های ارز دیجیتال استفاده کنم؟\n\n✅ به دلیل وضعیت نت و محدودیت های کشور سرویس ما مناسب ترید نیست و فقط لوکیشن‌ ثابته.\n\n2️⃣ اگه قبل از منقضی شدن اکانت، تمدیدش کنم روزهای باقی مانده می سوزد؟\n\n✅ خیر، روزهای باقیمونده اکانت موقع تمدید حساب میشن و اگه مثلا 5 روز قبل از منقضی شدن اکانت 1 ماهه خودتون اون رو تمدید کنید 5 روز باقیمونده + 30 روز تمدید میشه.\n\n3️⃣ اگه به یک اکانت بیشتر از حد مجاز متصل شیم چه اتفاقی میافته؟\n\n✅ در این صورت حجم سرویس شما زود تمام خواهد شد.\n\n4️⃣ فیلترشکن شما از چه نوعیه؟\n\n✅ فیلترشکن های ما v2ray است و پروتکل‌های مختلفی رو ساپورت میکنیم تا حتی تو دورانی که اینترنت اختلال داره بدون مشکل و افت سرعت بتونید از سرویستون استفاده کنید.\n\n5️⃣ فیلترشکن از کدوم کشور است؟\n\n✅ سرور فیلترشکن ما از کشور  آلمان است\n\n6️⃣ چطور باید از این فیلترشکن استفاده کنم؟\n\n✅ برای آموزش استفاده از برنامه، روی دکمه «📚 آموزش» بزنید.\n\n7️⃣ فیلترشکن وصل نمیشه، چیکار کنم؟\n\n✅ به همراه یک عکس از پیغام خطایی که میگیرید به پشتیبانی مراجعه کنید.\n\n8️⃣ فیلترشکن شما تضمینی هست که همیشه مواقع متصل بشه؟\n\n✅ به دلیل قابل پیش‌بینی نبودن وضعیت نت کشور، امکان دادن تضمین نیست فقط می‌تونیم تضمین کنیم که تمام تلاشمون رو برای ارائه سرویس هر چه بهتر انجام بدیم.\n\n9️⃣ امکان بازگشت وجه دارید؟\n\n✅ امکان بازگشت وجه در صورت حل نشدن مشکل از سمت ما وجود دارد.\n\n💡 در صورتی که جواب سوالتون رو نگرفتید میتونید به «پشتیبانی» مراجعه کنید.'),
('text_extend', '♻️ تمدید سرویس'),
('text_fq', '❓ سوالات متداول'),
('text_help', '📚 آموزش'),
('text_pishinvoice', '📇 پیش فاکتور شما:\n👤 نام کاربری:  {username}\n🔐 نام سرویس: {name_product}\n📆 مدت اعتبار: {Service_time} روز\n💶 قیمت:  {price} تومان\n👥 حجم اکانت: {Volume} گیگ\n🗒 یادداشت محصول : {note}\n💵 موجودی کیف پول شما : {userBalance}\n          \n💰 سفارش شما آماده پرداخت است'),
('text_request_agent_dec', '📌 توضیحات خود را برای ثبت درخواست نمایندگی ارسال نمایید.'),
('text_roll', '♨️ قوانین استفاده از خدمات ما\n\n1- به اطلاعیه هایی که داخل کانال گذاشته می شود حتما توجه کنید.\n2- در صورتی که اطلاعیه ای در مورد قطعی در کانال گذاشته نشده به اکانت پشتیبانی پیام دهید\n3- سرویس ها را از طریق پیامک ارسال نکنید برای ارسال پیامک می توانید از طریق ایمیل ارسال کنید.'),
('text_sell', '🔐 خرید اشتراک'),
('text_star_telegram', '💫 Star Telegram'),
('text_start', 'سلام خوش آمدید🌹'),
('text_support', '☎️ پشتیبانی'),
('text_usertest', '🔑 اکانت تست'),
('text_wgdashboard', '✅ سرویس با موفقیت ایجاد شد\n\n👤 نام کاربری سرویس : {username}\n🌿 نام سرویس:  {name_service}\n‏🇺🇳 لوکیشن: {location}\n⏳ مدت زمان: {day}  روز\n🗜 حجم سرویس:  {volume} گیگابایت\n\n🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید'),
('text_wheel_luck', '🎲 گردونه شانس'),
('textafterpay', '✅ سرویس با موفقیت ایجاد شد\n\n👤 نام کاربری سرویس : {username}\n🌿 نام سرویس:  {name_service}\n‏🇺🇳 لوکیشن: {location}\n⏳ مدت زمان: {day}  روز\n🗜 حجم سرویس:  {volume} گیگابایت\n\nلینک اتصال:\n{config}\n{links}\n🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید'),
('textafterpayibsng', '✅ سرویس با موفقیت ایجاد شد\n\n👤 نام کاربری سرویس : {username}\n🔑 رمز عبور سرویس :  <code>{password}</code>\n🌿 نام سرویس:  {name_service}\n‏🇺🇳 لوکیشن: {location}\n⏳ مدت زمان: {day}  روز\n🗜 حجم سرویس:  {volume} گیگابایت\n\n🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید'),
('textaftertext', '✅ سرویس با موفقیت ایجاد شد\n\n👤 نام کاربری سرویس : {username}\n🌿 نام سرویس:  {name_service}\n‏🇺🇳 لوکیشن: {location}\n⏳ مدت زمان: {day}  ساعت\n🗜 حجم سرویس:  {volume} مگابایت\n\nلینک اتصال:\n{config}\n🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید'),
('textmanual', '✅ سرویس با موفقیت ایجاد شد\n\n👤 نام کاربری سرویس : {username}\n🌿 نام سرویس:  {name_service}\n‏🇺🇳 لوکیشن: {location}\n\n اطلاعات سرویس :\n{config}\n🧑‍🦯 شما میتوانید شیوه اتصال را  با فشردن دکمه زیر و انتخاب سیستم عامل خود را دریافت کنید'),
('textnowpayment', '💵 پرداخت ارزی 1'),
('textnowpaymenttron', '💵 واریز رمزارز ترون'),
('textpanelagent', '👨‍💻 پنل نمایندگی'),
('textpaymentnotverify', 'درگاه ریالی'),
('textrequestagent', '👨‍💻 درخواست نمایندگی'),
('textselectlocation', '📌 موقعیت سرویس را انتخاب نمایید.'),
('textsnowpayment', '💸 پرداخت با ارز دیجیتال'),
('zarinpal', '🟡 زرین پال');

-- --------------------------------------------------------

--
-- Table structure for table `topicid`
--

CREATE TABLE `topicid` (
  `report` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `idreport` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `topicid`
--

INSERT INTO `topicid` (`report`, `idreport`) VALUES
('backupfile', '164'),
('buyreport', '166'),
('errorreport', '170'),
('otherreport', '169'),
('otherservice', '167'),
('paymentreport', '171'),
('porsantreport', '161'),
('reportcron', '163'),
('reportnight', '162'),
('reporttest', '168');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `limit_usertest` int NOT NULL,
  `roll_Status` tinyint(1) NOT NULL,
  `username` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Processing_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Processing_value_one` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Processing_value_tow` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Processing_value_four` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `step` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description_blocking` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `number` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Balance` int NOT NULL,
  `User_Status` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pagenumber` int NOT NULL,
  `message_count` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_message_time` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `agent` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `affiliatescount` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `affiliates` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `namecustom` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `number_username` varchar(300) COLLATE utf8mb4_unicode_ci NOT NULL,
  `register` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `verify` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cardpayment` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codeInvitation` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `pricediscount` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `maxbuyagent` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `joinchannel` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `checkstatus` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `bottype` text COLLATE utf8mb4_unicode_ci,
  `score` int DEFAULT '0',
  `limitchangeloc` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '0',
  `status_cron` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '1',
  `expire` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `limit_usertest`, `roll_Status`, `username`, `Processing_value`, `Processing_value_one`, `Processing_value_tow`, `Processing_value_four`, `step`, `description_blocking`, `number`, `Balance`, `User_Status`, `pagenumber`, `message_count`, `last_message_time`, `agent`, `affiliatescount`, `affiliates`, `namecustom`, `number_username`, `register`, `verify`, `cardpayment`, `codeInvitation`, `pricediscount`, `maxbuyagent`, `joinchannel`, `checkstatus`, `bottype`, `score`, `limitchangeloc`, `status_cron`, `expire`, `token`) VALUES
('2121442182', 1, 0, 'test', '0', '0', '0', '0', 'home', NULL, 'none', 0, 'Active', 1, '1', '1761259337', 'f', '0', '0', 'none', '100', '1761259276', '1', '1', 'c2e8d3662be8', '0', '0', '0', '0', NULL, 0, '0', '1', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `wheel_list`
--

CREATE TABLE `wheel_list` (
  `id` int UNSIGNED NOT NULL,
  `id_user` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `wheel_code` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `price` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `wheel_list`
--

INSERT INTO `wheel_list` (`id`, `id_user`, `time`, `first_name`, `wheel_code`, `price`) VALUES
(2, '1255663277', '2025/10/24 01:52:50', 'm', '4', '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indexes for table `app`
--
ALTER TABLE `app`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `botsaz`
--
ALTER TABLE `botsaz`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cancel_service`
--
ALTER TABLE `cancel_service`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `card_number`
--
ALTER TABLE `card_number`
  ADD PRIMARY KEY (`cardnumber`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `departman`
--
ALTER TABLE `departman`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Discount`
--
ALTER TABLE `Discount`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `DiscountSell`
--
ALTER TABLE `DiscountSell`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Giftcodeconsumed`
--
ALTER TABLE `Giftcodeconsumed`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `help`
--
ALTER TABLE `help`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`id_invoice`);

--
-- Indexes for table `logs_api`
--
ALTER TABLE `logs_api`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `manualsell`
--
ALTER TABLE `manualsell`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `marzban_panel`
--
ALTER TABLE `marzban_panel`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `Payment_report`
--
ALTER TABLE `Payment_report`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `PaySetting`
--
ALTER TABLE `PaySetting`
  ADD PRIMARY KEY (`NamePay`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reagent_report`
--
ALTER TABLE `reagent_report`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`);

--
-- Indexes for table `Requestagent`
--
ALTER TABLE `Requestagent`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `service_other`
--
ALTER TABLE `service_other`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `shopSetting`
--
ALTER TABLE `shopSetting`
  ADD PRIMARY KEY (`Namevalue`);

--
-- Indexes for table `support_message`
--
ALTER TABLE `support_message`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `textbot`
--
ALTER TABLE `textbot`
  ADD PRIMARY KEY (`id_text`);

--
-- Indexes for table `topicid`
--
ALTER TABLE `topicid`
  ADD PRIMARY KEY (`report`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `wheel_list`
--
ALTER TABLE `wheel_list`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `app`
--
ALTER TABLE `app`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `botsaz`
--
ALTER TABLE `botsaz`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cancel_service`
--
ALTER TABLE `cancel_service`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departman`
--
ALTER TABLE `departman`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Discount`
--
ALTER TABLE `Discount`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `DiscountSell`
--
ALTER TABLE `DiscountSell`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Giftcodeconsumed`
--
ALTER TABLE `Giftcodeconsumed`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `help`
--
ALTER TABLE `help`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `logs_api`
--
ALTER TABLE `logs_api`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `manualsell`
--
ALTER TABLE `manualsell`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `marzban_panel`
--
ALTER TABLE `marzban_panel`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `Payment_report`
--
ALTER TABLE `Payment_report`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `reagent_report`
--
ALTER TABLE `reagent_report`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `service_other`
--
ALTER TABLE `service_other`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `support_message`
--
ALTER TABLE `support_message`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `wheel_list`
--
ALTER TABLE `wheel_list`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
