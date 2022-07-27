-- phpMyAdmin SQL Dump
-- version 5.1.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 26, 2022 at 08:34 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 7.4.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `nethush`
--

-- --------------------------------------------------------

--
-- Table structure for table `apartments`
--

CREATE TABLE `apartments` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `citizenid` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `apartments`
--

INSERT INTO `apartments` (`id`, `name`, `type`, `label`, `citizenid`) VALUES
(1, 'apartment18376', 'apartment1', 'Integrity Way 8376', 'LHP12548'),
(2, 'apartment18271', 'apartment1', 'Integrity Way 8271', 'TUC83121');

-- --------------------------------------------------------

--
-- Table structure for table `api_tokens`
--

CREATE TABLE `api_tokens` (
  `token` varchar(255) NOT NULL,
  `purpose` varchar(255) DEFAULT NULL,
  `time` int(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE `bans` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `license` varchar(50) DEFAULT NULL,
  `discord` varchar(50) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `expire` int(11) DEFAULT NULL,
  `bannedby` varchar(255) NOT NULL DEFAULT 'LeBanhammer'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `billing`
--

CREATE TABLE `billing` (
  `id` int(11) NOT NULL,
  `senderIBAN` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `senderName` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `targetIBAN` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `amount` int(11) NOT NULL,
  `neZaman` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `durum` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT 'Beklemede'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `crypto`
--

CREATE TABLE `crypto` (
  `#` int(11) NOT NULL,
  `crypto` varchar(50) NOT NULL DEFAULT 'qbit',
  `worth` int(11) NOT NULL DEFAULT 0,
  `history` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `crypto_transactions`
--

CREATE TABLE `crypto_transactions` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `dealers`
--

CREATE TABLE `dealers` (
  `#` int(11) NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `coords` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `time` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `createdby` varchar(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `dealership_balance`
--

CREATE TABLE `dealership_balance` (
  `id` int(11) UNSIGNED NOT NULL,
  `dealership_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `name` varchar(50) NOT NULL,
  `amount` int(11) UNSIGNED NOT NULL,
  `type` bit(1) NOT NULL COMMENT '0 = income | 1 = expense',
  `isbuy` bit(1) NOT NULL,
  `date` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `dealership_balance`
--

INSERT INTO `dealership_balance` (`id`, `dealership_id`, `user_id`, `description`, `name`, `amount`, `type`, `isbuy`, `date`) VALUES
(21, 'dealer_1', 'TUC83121', 'Vehicle purchased: Nissan Skyline R34 Animated', 'NeThush', 2000000, b'0', b'1', 1658549308);

-- --------------------------------------------------------

--
-- Table structure for table `dealership_hired_players`
--

CREATE TABLE `dealership_hired_players` (
  `dealership_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `profile_img` varchar(255) NOT NULL DEFAULT 'https://amar.amr.org.br/packages/trustir/exclusiva/img/user_placeholder.png',
  `banner_img` varchar(255) NOT NULL DEFAULT 'https://www.bossecurity.com/wp-content/uploads/2018/10/night-time-drive-bys-1024x683.jpg',
  `name` varchar(50) NOT NULL,
  `jobs_done` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `timer` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `dealership_owner`
--

CREATE TABLE `dealership_owner` (
  `dealership_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `profile_img` varchar(255) NOT NULL DEFAULT 'https://amar.amr.org.br/packages/trustir/exclusiva/img/user_placeholder.png',
  `banner_img` varchar(255) NOT NULL DEFAULT 'https://www.bossecurity.com/wp-content/uploads/2018/10/night-time-drive-bys-1024x683.jpg',
  `stock` text NOT NULL,
  `stock_prices` longtext NOT NULL,
  `stock_sold` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `money` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `total_money_spent` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `total_money_earned` int(11) UNSIGNED NOT NULL DEFAULT 0,
  `timer` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `dealership_requests`
--

CREATE TABLE `dealership_requests` (
  `id` int(11) NOT NULL,
  `dealership_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `vehicle` varchar(50) NOT NULL,
  `plate` varchar(50) NOT NULL,
  `request_type` int(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = sell reques t| 1 = buy request',
  `name` varchar(50) NOT NULL,
  `price` int(11) UNSIGNED NOT NULL,
  `status` int(2) UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 = waiting | 1 = in progress | 2 = finished | 3 = cancelled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `dealership_stock`
--

CREATE TABLE `dealership_stock` (
  `vehicle` varchar(100) NOT NULL,
  `amount` int(11) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `dpkeybinds`
--

CREATE TABLE `dpkeybinds` (
  `id` varchar(50) DEFAULT NULL,
  `keybind1` varchar(50) DEFAULT 'num4',
  `emote1` varchar(255) DEFAULT '',
  `keybind2` varchar(50) DEFAULT 'num5',
  `emote2` varchar(255) DEFAULT '',
  `keybind3` varchar(50) DEFAULT 'num6',
  `emote3` varchar(255) DEFAULT '',
  `keybind4` varchar(50) DEFAULT 'num7',
  `emote4` varchar(255) DEFAULT '',
  `keybind5` varchar(50) DEFAULT 'num8',
  `emote5` varchar(255) DEFAULT '',
  `keybind6` varchar(50) DEFAULT 'num9',
  `emote6` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `dpkeybinds`
--

INSERT INTO `dpkeybinds` (`id`, `keybind1`, `emote1`, `keybind2`, `emote2`, `keybind3`, `emote3`, `keybind4`, `emote4`, `keybind5`, `emote5`, `keybind6`, `emote6`) VALUES
('steam:110000147388a80', 'num4', '', 'num5', '', 'num6', '', 'num7', '', 'num8', '', 'num9', '');

-- --------------------------------------------------------

--
-- Table structure for table `fine_types`
--

CREATE TABLE `fine_types` (
  `id` int(11) NOT NULL,
  `label` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `jailtime` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Table structure for table `gangs`
--

CREATE TABLE `gangs` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `grades` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gangs_members`
--

CREATE TABLE `gangs_members` (
  `index` int(11) NOT NULL,
  `gang` longtext NOT NULL DEFAULT '0',
  `grade` longtext NOT NULL DEFAULT '0',
  `cid` longtext NOT NULL DEFAULT '0',
  `char` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gangs_money`
--

CREATE TABLE `gangs_money` (
  `index` int(11) NOT NULL,
  `gang` longtext DEFAULT NULL,
  `amount` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gang_territoriums`
--

CREATE TABLE `gang_territoriums` (
  `id` int(11) NOT NULL,
  `gang` varchar(50) DEFAULT NULL,
  `points` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gas_station_balance`
--

CREATE TABLE `gas_station_balance` (
  `id` int(10) UNSIGNED NOT NULL,
  `gas_station_id` varchar(50) NOT NULL,
  `income` bit(1) NOT NULL,
  `title` varchar(255) NOT NULL,
  `amount` int(10) UNSIGNED NOT NULL,
  `date` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gas_station_business`
--

CREATE TABLE `gas_station_business` (
  `gas_station_id` varchar(50) NOT NULL DEFAULT '',
  `user_id` varchar(50) NOT NULL,
  `stock` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `price` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `stock_upgrade` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `truck_upgrade` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `relationship_upgrade` tinyint(3) UNSIGNED NOT NULL DEFAULT 0,
  `money` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `total_money_earned` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `total_money_spent` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `gas_bought` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `gas_sold` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `distance_traveled` double UNSIGNED NOT NULL DEFAULT 0,
  `total_visits` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `customers` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `timer` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gas_station_jobs`
--

CREATE TABLE `gas_station_jobs` (
  `id` int(10) UNSIGNED NOT NULL,
  `gas_station_id` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(50) NOT NULL,
  `reward` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `amount` int(11) NOT NULL DEFAULT 0,
  `progress` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `gloveboxitems`
--

CREATE TABLE `gloveboxitems` (
  `id` int(11) NOT NULL,
  `plate` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `info` text DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `slot` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `gloveboxitemsnew`
--

CREATE TABLE `gloveboxitemsnew` (
  `id` int(11) NOT NULL,
  `plate` varchar(255) DEFAULT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `gloveboxitemsnew`
--

INSERT INTO `gloveboxitemsnew` (`id`, `plate`, `items`) VALUES
(1, '4GL861TD', '[null,{\"type\":\"item\",\"name\":\"stickynote\",\"slot\":2,\"info\":[],\"image\":\"stickynote.png\",\"unique\":true,\"weight\":0,\"useable\":false,\"label\":\"Sticky note\",\"amount\":1}]'),
(2, '3QZ086KD', '[]'),
(3, '2EV691PB', '[]'),
(4, '60NDR234', '[]'),
(5, '63LVW497', '[]'),
(6, '49HPH622', '[{\"name\":\"key-c\",\"amount\":1,\"unique\":true,\"slot\":1,\"image\":\"key-c.png\",\"useable\":true,\"type\":\"item\",\"label\":\"Key C\",\"info\":[],\"weight\":1000}]'),
(7, '85WOR799', '[]'),
(8, '06OTN181', '[{\"type\":\"weapon\",\"amount\":1,\"useable\":false,\"name\":\"weapon_microsmg\",\"slot\":1,\"weight\":2200,\"label\":\"Micro SMG\",\"unique\":true,\"image\":\"microsmg.png\",\"info\":{\"quality\":82.14999999999933,\"ammo\":140,\"serie\":\"00tJk0dd603MsaG\"}}]'),
(9, 'NETHUSH ', '[]'),
(10, '2IR563PH', '[]'),
(11, '84EMM957', '[]'),
(12, 'RVX1207M', '[]');

-- --------------------------------------------------------

--
-- Table structure for table `houselocations`
--

CREATE TABLE `houselocations` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `coords` text DEFAULT NULL,
  `owned` tinyint(2) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tier` tinyint(2) DEFAULT NULL,
  `garage` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `house_plants`
--

CREATE TABLE `house_plants` (
  `id` int(11) NOT NULL,
  `building` varchar(50) DEFAULT NULL,
  `stage` varchar(50) DEFAULT 'stage-a',
  `sort` varchar(50) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `food` int(11) DEFAULT 100,
  `health` int(11) DEFAULT 100,
  `progress` int(11) DEFAULT 0,
  `coords` text DEFAULT NULL,
  `plantid` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `grades` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `lapraces`
--

CREATE TABLE `lapraces` (
  `id` int(11) NOT NULL,
  `name` varchar(50) DEFAULT NULL,
  `checkpoints` text DEFAULT NULL,
  `records` text DEFAULT NULL,
  `creator` varchar(50) DEFAULT NULL,
  `distance` int(11) DEFAULT NULL,
  `raceid` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `mdt_reports`
--

CREATE TABLE `mdt_reports` (
  `id` int(11) NOT NULL,
  `char_id` varchar(48) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `incident` longtext DEFAULT NULL,
  `charges` longtext DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `jailtime` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `mdt_warrants`
--

CREATE TABLE `mdt_warrants` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `char_id` varchar(48) DEFAULT NULL,
  `report_id` int(11) DEFAULT NULL,
  `report_title` varchar(255) DEFAULT NULL,
  `charges` longtext DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `expire` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `moneysafes`
--

CREATE TABLE `moneysafes` (
  `id` int(11) NOT NULL,
  `safe` varchar(50) NOT NULL DEFAULT '0',
  `money` int(11) NOT NULL DEFAULT 0,
  `transactions` text NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `nethush_cardelivery`
--

CREATE TABLE `nethush_cardelivery` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `price` int(100) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `occasion_vehicles`
--

CREATE TABLE `occasion_vehicles` (
  `id` int(11) NOT NULL,
  `seller` varchar(50) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mods` text DEFAULT NULL,
  `occasionid` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `okokbanking_societies`
--

CREATE TABLE `okokbanking_societies` (
  `society` varchar(255) DEFAULT NULL,
  `society_name` varchar(255) DEFAULT NULL,
  `value` int(50) DEFAULT NULL,
  `iban` varchar(255) NOT NULL,
  `is_withdrawing` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `okokbanking_transactions`
--

CREATE TABLE `okokbanking_transactions` (
  `id` int(11) NOT NULL,
  `receiver_identifier` varchar(255) NOT NULL,
  `receiver_name` varchar(255) NOT NULL,
  `sender_identifier` varchar(255) NOT NULL,
  `sender_name` varchar(255) NOT NULL,
  `date` varchar(255) NOT NULL,
  `value` int(50) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `okokbanking_transactions`
--

INSERT INTO `okokbanking_transactions` (`id`, `receiver_identifier`, `receiver_name`, `sender_identifier`, `sender_name`, `date`, `value`, `type`) VALUES
(1, 'bank', 'Bank Account', 'LHP12548', 'Nethush Fivver', '2022-05-31 18:53:15', 12, 'deposit'),
(2, 'bank', 'Bank Account', 'LHP12548', 'Nethush Fivver', '2022-05-31 18:53:20', 12, 'deposit'),
(3, 'bank', 'Bank Account', 'TUC83121', 'Nethush Guru', '2022-07-19 05:57:12', 100, 'deposit'),
(4, 'TUC83121', 'Nethush Guru', 'bank', 'Bank Account', '2022-07-19 05:57:16', 1000, 'withdraw');

-- --------------------------------------------------------

--
-- Table structure for table `osmplaytime`
--

CREATE TABLE `osmplaytime` (
  `steam` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `mins` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `osmplaytime`
--

INSERT INTO `osmplaytime` (`steam`, `name`, `mins`) VALUES
('steam:110000147388a80', 'kingofnethush', 1352);

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `permission` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `steam`, `license`, `permission`) VALUES
(1, 'kingofnethush', 'steam:110000147388a80', 'license:e777df82ca4c6700ce04bd8107d27685cb2ba2c1', 'god');

-- --------------------------------------------------------

--
-- Table structure for table `phone_invoices`
--

CREATE TABLE `phone_invoices` (
  `#` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `invoiceid` varchar(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `phone_messages`
--

CREATE TABLE `phone_messages` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `phone_tweets`
--

CREATE TABLE `phone_tweets` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `playerammo`
--

CREATE TABLE `playerammo` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `ammo` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `playeritems`
--

CREATE TABLE `playeritems` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE `players` (
  `#` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `cid` int(11) DEFAULT NULL,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` text NOT NULL,
  `charinfo` text DEFAULT NULL,
  `job` text NOT NULL,
  `gang` text DEFAULT NULL,
  `position` text NOT NULL,
  `tattoos` longtext DEFAULT NULL,
  `metadata` text NOT NULL,
  `inventory` longtext DEFAULT NULL,
  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `pending_finance` int(255) DEFAULT 0,
  `iban` varchar(255) DEFAULT NULL,
  `pincode` int(50) DEFAULT NULL,
  `photo` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `players`
--

INSERT INTO `players` (`#`, `citizenid`, `cid`, `steam`, `license`, `name`, `money`, `charinfo`, `job`, `gang`, `position`, `tattoos`, `metadata`, `inventory`, `last_updated`, `pending_finance`, `iban`, `pincode`, `photo`) VALUES
(1, 'LHP12548', 1, 'steam:110000147388a80', 'license:e777df82ca4c6700ce04bd8107d27685cb2ba2c1', 'NeThush', '{\"crypto\":0,\"cash\":10000331317.0,\"bank\":59998893044}', '{\"firstname\":\"Nethush\",\"cid\":\"1\",\"nationality\":\"USA\",\"account\":\"NL09QBUS6847315278\",\"phone\":\"0699058702\",\"backstory\":\"placeholder backstory\",\"lastname\":\"Fivver\",\"gender\":0,\"birthdate\":\"1999-02-01\"}', '{\"grade\":6,\"onduty\":true,\"gradelabel\":\"Commander\",\"label\":\"Police\",\"payment\":48000,\"name\":\"police\"}', '{\"label\":\"Geen Gang\",\"name\":\"geen\"}', '{\"a\":162.0531005859375,\"z\":44.91984176635742,\"y\":-345.3460693359375,\"x\":271.92535400390627}', NULL, '{\"thirst\":89.2,\"inventorydisabled\":false,\"scraprep\":0,\"visrep\":0,\"fitbit\":[],\"armor\":0,\"ovrep\":0,\"geduldrep\":0,\"lockpickrep\":0,\"injail\":0,\"hunger\":89.8,\"attachmentcraftingrep\":0,\"craftingrep\":3,\"currentapartment\":\"apartment18376\",\"walletid\":\"QB-77623155\",\"phone\":[],\"phonedata\":{\"SerialNumber\":35538736,\"InstalledApps\":[]},\"commandbinds\":[],\"ishandcuffed\":false,\"jobrep\":{\"hotdog\":0,\"taxi\":0,\"trucker\":0,\"tow\":0},\"jailitems\":[],\"stress\":39,\"licences\":{\"business\":false,\"driver\":true},\"dealerrep\":0,\"inside\":{\"apartment\":[]},\"bloodtype\":\"O+\",\"inlaststand\":false,\"hackrep\":0,\"fingerprint\":\"gs969i84MFB5066\",\"tracker\":false,\"plantagerep\":0,\"criminalrecord\":{\"hasRecord\":false},\"status\":[],\"callsign\":\"NO CALLSIGN\",\"isdead\":false}', '[{\"amount\":1,\"slot\":1,\"type\":\"weapon\",\"name\":\"weapon_smg\",\"info\":{\"quality\":100.0,\"serie\":\"95oFU6vk652lTct\",\"ammo\":1}},{\"amount\":7,\"slot\":2,\"type\":\"item\",\"name\":\"advancedlockpick\",\"info\":[]},{\"amount\":1,\"slot\":3,\"type\":\"item\",\"name\":\"yellow-card\",\"info\":\"\"},{\"amount\":7,\"slot\":4,\"type\":\"item\",\"name\":\"electronickit\",\"info\":{\"ammo\":0}},{\"amount\":2,\"slot\":5,\"type\":\"item\",\"name\":\"coke-bag\",\"info\":\"\"},{\"amount\":1,\"slot\":6,\"type\":\"item\",\"name\":\"driver_license\",\"info\":{\"firstname\":\"Nethush\",\"type\":\"A1-A2-A | AM-B | C1-C-CE\",\"lastname\":\"Fivver\",\"birthdate\":\"1999-02-01\"}},{\"amount\":1,\"slot\":7,\"type\":\"weapon\",\"name\":\"weapon_minismg\",\"info\":{\"quality\":79.59999999999924,\"serie\":\"76kfO6QA102roFw\",\"ammo\":183}},{\"amount\":1,\"slot\":8,\"type\":\"item\",\"name\":\"markedbills\",\"info\":{\"worth\":10055}},{\"amount\":70,\"slot\":9,\"type\":\"item\",\"name\":\"metalscrap\",\"info\":[]},{\"amount\":3,\"slot\":10,\"type\":\"item\",\"name\":\"joint\",\"info\":[]},{\"amount\":8,\"slot\":11,\"type\":\"item\",\"name\":\"plastic\",\"info\":[]},{\"amount\":1,\"slot\":12,\"type\":\"item\",\"name\":\"green-card\",\"info\":[]},{\"amount\":1,\"slot\":13,\"type\":\"item\",\"name\":\"markedbills\",\"info\":{\"worth\":7346}},{\"amount\":7,\"slot\":14,\"type\":\"item\",\"name\":\"10kgoldchain\",\"info\":\"\"},{\"amount\":1,\"slot\":15,\"type\":\"item\",\"name\":\"phone\",\"info\":[]},{\"amount\":1,\"slot\":16,\"type\":\"item\",\"name\":\"lockpick\",\"info\":[]},{\"amount\":1,\"slot\":17,\"type\":\"item\",\"name\":\"lighter\",\"info\":[]},{\"amount\":1,\"slot\":18,\"type\":\"item\",\"name\":\"markedbills\",\"info\":{\"worth\":4282}},{\"amount\":1,\"slot\":19,\"type\":\"item\",\"name\":\"diving_gear\",\"info\":\"\"},{\"amount\":504.0,\"slot\":20,\"type\":\"item\",\"name\":\"money-roll\",\"info\":[]},{\"amount\":1,\"slot\":21,\"type\":\"item\",\"name\":\"markedbills\",\"info\":{\"worth\":4723}},{\"amount\":2,\"slot\":22,\"type\":\"item\",\"name\":\"drill\",\"info\":[]},{\"amount\":1,\"slot\":23,\"type\":\"weapon\",\"name\":\"weapon_sawnoffshotgun\",\"info\":{\"quality\":99.24999999999996,\"serie\":\"30nRM6QH340fdrr\",\"ammo\":0}},{\"amount\":20,\"slot\":26,\"type\":\"item\",\"name\":\"joint\",\"info\":[]},{\"amount\":1,\"slot\":41,\"type\":\"item\",\"name\":\"advancedscrewdriver\",\"info\":[]}]', '2022-07-23 03:20:09', 0, 'ID733642', NULL, ''),
(2, 'TUC83121', 2, 'steam:110000147388a80', 'license:e777df82ca4c6700ce04bd8107d27685cb2ba2c1', 'NeThush', '{\"crypto\":0,\"cash\":980462252.0,\"bank\":3989650034836332457}', '{\"firstname\":\"Nethush\",\"cid\":\"2\",\"nationality\":\"sri\",\"account\":\"NL03QBUS2149507763\",\"birthdate\":\"2211-12-12\",\"lastname\":\"Guru\",\"backstory\":\"placeholder backstory\",\"gender\":0,\"phone\":\"0692618815\"}', '{\"grade\":2,\"onduty\":false,\"gradelabel\":\"Boss\",\"label\":\"Garage\",\"payment\":20000,\"name\":\"mechanic\"}', '{\"label\":\"Geen Gang\",\"name\":\"geen\"}', '{\"a\":56.80377960205078,\"z\":-12.56189632415771,\"y\":1605.2529296875,\"x\":-3358.5146484375}', '[{\"Count\":1,\"nameHash\":\"MP_MP_Biker_Tat_002_F\",\"collection\":\"mpbiker_overlays\"},{\"Count\":1,\"nameHash\":\"MP_MP_Stunt_tat_023_F\",\"collection\":\"mpstunt_overlays\"},{\"Count\":1,\"nameHash\":\"MP_MP_Biker_Tat_004_F\",\"collection\":\"mpbiker_overlays\"},{\"Count\":1,\"nameHash\":\"MP_Buis_F_Chest_001\",\"collection\":\"mpbusiness_overlays\"},{\"Count\":1,\"nameHash\":\"MP_MP_Biker_Tat_047_F\",\"collection\":\"mpbiker_overlays\"},{\"Count\":1,\"nameHash\":\"MP_Christmas2017_Tattoo_012_F\",\"collection\":\"mpchristmas2017_overlays\"}]', '{\"thirst\":100,\"tracker\":false,\"scraprep\":0,\"visrep\":0,\"fitbit\":[],\"armor\":100,\"ovrep\":0,\"geduldrep\":0,\"licences\":{\"business\":false,\"driver\":true},\"injail\":0,\"hunger\":100,\"attachmentcraftingrep\":0,\"craftingrep\":0,\"currentapartment\":\"apartment18271\",\"walletid\":\"QB-72482638\",\"phone\":[],\"status\":[],\"commandbinds\":[],\"ishandcuffed\":false,\"jobrep\":{\"tow\":0,\"taxi\":0,\"hotdog\":0,\"trucker\":0},\"jailitems\":[],\"stress\":43,\"hackrep\":0,\"callsign\":\"NO CALLSIGN\",\"isdead\":true,\"bloodtype\":\"O+\",\"phonedata\":{\"InstalledApps\":[],\"SerialNumber\":49376085},\"plantagerep\":0,\"fingerprint\":\"ai906S82rrp9416\",\"inventorydisabled\":false,\"lockpickrep\":0,\"criminalrecord\":{\"hasRecord\":false},\"inlaststand\":false,\"inside\":{\"apartment\":[]},\"dealerrep\":0}', '[{\"amount\":89,\"slot\":1,\"type\":\"item\",\"name\":\"nitrous\",\"info\":[]},{\"amount\":1,\"slot\":2,\"type\":\"weapon\",\"name\":\"weapon_pistol\",\"info\":{\"quality\":100.0,\"serie\":\"09XfD6iz504zCnc\",\"ammo\":0}},{\"amount\":1,\"slot\":3,\"type\":\"weapon\",\"name\":\"weapon_carbinerifle\",\"info\":{\"quality\":100.0,\"serie\":\"93hxJ5Ma814LTSy\",\"ammo\":0}},{\"amount\":1,\"slot\":4,\"type\":\"weapon\",\"name\":\"weapon_rpg\",\"info\":{\"quality\":80.34999999999926,\"serie\":\"49jca5Tq928CbZA\",\"ammo\":0}},{\"amount\":1,\"slot\":5,\"type\":\"item\",\"name\":\"driver_license\",\"info\":{\"firstname\":\"Nethush\",\"type\":\"A1-A2-A | AM-B | C1-C-CE\",\"lastname\":\"Guru\",\"birthdate\":\"2211-12-12\"}},{\"amount\":1,\"slot\":6,\"type\":\"item\",\"name\":\"skateboard\",\"info\":[]},{\"amount\":21,\"slot\":7,\"type\":\"item\",\"name\":\"rifle_ammo\",\"info\":[]},{\"amount\":5,\"slot\":8,\"type\":\"item\",\"name\":\"bcdrone\",\"info\":[]},{\"amount\":1,\"slot\":9,\"type\":\"item\",\"name\":\"phone\",\"info\":[]},{\"amount\":1,\"slot\":10,\"type\":\"weapon\",\"name\":\"weapon_minismg\",\"info\":{\"serie\":\"58HXL3Sy309JKkK\",\"quality\":100.0}},{\"amount\":1,\"slot\":11,\"type\":\"item\",\"name\":\"radio\",\"info\":[]},{\"amount\":1,\"slot\":12,\"type\":\"item\",\"name\":\"water_bottle\",\"info\":[]},{\"amount\":2,\"slot\":13,\"type\":\"item\",\"name\":\"joint\",\"info\":[]},{\"amount\":49,\"slot\":14,\"type\":\"item\",\"name\":\"empty_evidence_bag\",\"info\":[]},{\"amount\":1,\"slot\":15,\"type\":\"item\",\"name\":\"markedbills\",\"info\":{\"worth\":397}},{\"amount\":1,\"slot\":16,\"type\":\"weapon\",\"name\":\"weapon_flashlight\",\"info\":{\"quality\":100.0,\"serie\":\"17Add6ET285GZTY\",\"ammo\":0}},{\"amount\":1,\"slot\":17,\"type\":\"item\",\"name\":\"phone\",\"info\":[]},{\"amount\":1,\"slot\":18,\"type\":\"item\",\"name\":\"id_card\",\"info\":{\"citizenid\":\"TUC83121\",\"nationality\":\"sri\",\"lastname\":\"Guru\",\"firstname\":\"Nethush\",\"gender\":0,\"birthdate\":\"2211-12-12\"}},{\"amount\":1,\"slot\":19,\"type\":\"item\",\"name\":\"empty_evidence_bag\",\"info\":[]},{\"amount\":1,\"slot\":20,\"type\":\"item\",\"name\":\"handcuffs\",\"info\":[]},{\"amount\":1,\"slot\":21,\"type\":\"item\",\"name\":\"police_stormram\",\"info\":[]},{\"amount\":10,\"slot\":22,\"type\":\"weapon\",\"name\":\"weapon_carbinerifle\",\"info\":{\"quality\":100.0,\"serie\":\"25vRn8MF622MhDz\",\"ammo\":5}},{\"amount\":1,\"slot\":23,\"type\":\"weapon\",\"name\":\"weapon_petrolcan\",\"info\":{\"quality\":0,\"serie\":\"59Hnw0qt965tBqw\",\"ammo\":3999}},{\"amount\":1,\"slot\":24,\"type\":\"item\",\"name\":\"markedbills\",\"info\":{\"worth\":10031}},{\"amount\":1,\"slot\":25,\"type\":\"item\",\"name\":\"markedbills\",\"info\":{\"worth\":976}},{\"amount\":50,\"slot\":27,\"type\":\"item\",\"name\":\"goldchain\",\"info\":\"\"},{\"amount\":1,\"slot\":29,\"type\":\"item\",\"name\":\"lockpick\",\"info\":[]}]', '2022-07-23 04:25:22', 0, 'ID924591', NULL, 'adad');

-- --------------------------------------------------------

--
-- Table structure for table `playerskins`
--

CREATE TABLE `playerskins` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(255) NOT NULL,
  `model` varchar(255) NOT NULL,
  `skin` text NOT NULL,
  `active` tinyint(2) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `playerskins`
--

INSERT INTO `playerskins` (`id`, `citizenid`, `model`, `skin`, `active`) VALUES
(2, 'LHP12548', '1885233650', '{\"ear\":{\"texture\":0,\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1},\"lipstick\":{\"texture\":1,\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1},\"watch\":{\"texture\":0,\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1},\"accessory\":{\"texture\":0,\"item\":0,\"defaultTexture\":0,\"defaultItem\":0},\"blush\":{\"texture\":1,\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1},\"eyebrows\":{\"texture\":1,\"item\":0,\"defaultTexture\":1,\"defaultItem\":-1},\"arms\":{\"texture\":0,\"item\":0,\"defaultTexture\":0,\"defaultItem\":0},\"hair\":{\"texture\":0,\"item\":48,\"defaultTexture\":0,\"defaultItem\":0},\"face\":{\"texture\":0,\"item\":7,\"defaultTexture\":0,\"defaultItem\":0},\"mask\":{\"texture\":0,\"item\":54,\"defaultTexture\":0,\"defaultItem\":0},\"glass\":{\"texture\":0,\"item\":12,\"defaultTexture\":0,\"defaultItem\":0},\"pants\":{\"texture\":0,\"item\":24,\"defaultTexture\":0,\"defaultItem\":0},\"beard\":{\"texture\":1,\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1},\"ageing\":{\"texture\":0,\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1},\"makeup\":{\"texture\":1,\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1},\"t-shirt\":{\"texture\":0,\"item\":10,\"defaultTexture\":0,\"defaultItem\":1},\"vest\":{\"texture\":0,\"item\":0,\"defaultTexture\":0,\"defaultItem\":0},\"decals\":{\"texture\":0,\"item\":0,\"defaultTexture\":0,\"defaultItem\":0},\"torso2\":{\"texture\":0,\"item\":116,\"defaultTexture\":0,\"defaultItem\":0},\"shoes\":{\"texture\":0,\"item\":19,\"defaultTexture\":0,\"defaultItem\":1},\"hat\":{\"texture\":0,\"item\":26,\"defaultTexture\":0,\"defaultItem\":-1},\"bag\":{\"texture\":0,\"item\":0,\"defaultTexture\":0,\"defaultItem\":0},\"bracelet\":{\"texture\":0,\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1}}', 1),
(19, 'TUC83121', '1885233650', '{\"shoes\":{\"defaultTexture\":0,\"item\":109,\"texture\":0,\"defaultItem\":1},\"hat\":{\"defaultTexture\":0,\"item\":133,\"texture\":0,\"defaultItem\":-1},\"blush\":{\"defaultTexture\":1,\"item\":-1,\"texture\":1,\"defaultItem\":-1},\"glass\":{\"defaultTexture\":0,\"item\":19,\"texture\":0,\"defaultItem\":0},\"torso2\":{\"defaultTexture\":0,\"item\":51,\"texture\":0,\"defaultItem\":0},\"hair\":{\"defaultTexture\":0,\"item\":52,\"texture\":0,\"defaultItem\":0},\"beard\":{\"defaultTexture\":1,\"item\":-1,\"texture\":1,\"defaultItem\":-1},\"pants\":{\"defaultTexture\":0,\"item\":24,\"texture\":0,\"defaultItem\":0},\"lipstick\":{\"defaultTexture\":1,\"item\":10,\"texture\":1,\"defaultItem\":-1},\"face\":{\"defaultTexture\":0,\"item\":7,\"texture\":0,\"defaultItem\":0},\"t-shirt\":{\"defaultTexture\":0,\"item\":72,\"texture\":0,\"defaultItem\":1},\"vest\":{\"defaultTexture\":0,\"item\":50,\"texture\":0,\"defaultItem\":0},\"ear\":{\"defaultTexture\":0,\"item\":1,\"texture\":0,\"defaultItem\":-1},\"bracelet\":{\"defaultTexture\":0,\"item\":-1,\"texture\":0,\"defaultItem\":-1},\"watch\":{\"defaultTexture\":0,\"item\":-1,\"texture\":0,\"defaultItem\":-1},\"bag\":{\"defaultTexture\":0,\"item\":0,\"texture\":0,\"defaultItem\":0},\"accessory\":{\"defaultTexture\":0,\"item\":1,\"texture\":0,\"defaultItem\":0},\"eyebrows\":{\"defaultTexture\":1,\"item\":-1,\"texture\":1,\"defaultItem\":-1},\"makeup\":{\"defaultTexture\":1,\"item\":14,\"texture\":1,\"defaultItem\":-1},\"arms\":{\"defaultTexture\":0,\"item\":115,\"texture\":0,\"defaultItem\":0},\"ageing\":{\"defaultTexture\":0,\"item\":-1,\"texture\":0,\"defaultItem\":-1},\"mask\":{\"defaultTexture\":0,\"item\":163,\"texture\":5,\"defaultItem\":0},\"decals\":{\"defaultTexture\":0,\"item\":73,\"texture\":0,\"defaultItem\":0}}', 1);

-- --------------------------------------------------------

--
-- Table structure for table `player_boats`
--

CREATE TABLE `player_boats` (
  `#` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `boathouse` varchar(50) DEFAULT NULL,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `state` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `player_contacts`
--

CREATE TABLE `player_contacts` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `player_houses`
--

CREATE TABLE `player_houses` (
  `id` int(255) NOT NULL,
  `house` varchar(50) NOT NULL,
  `identifier` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `keyholders` text DEFAULT NULL,
  `decorations` text DEFAULT NULL,
  `stash` text DEFAULT NULL,
  `outfit` text DEFAULT NULL,
  `logout` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `player_mails`
--

CREATE TABLE `player_mails` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `player_outfits`
--

CREATE TABLE `player_outfits` (
  `id` int(11) NOT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `outfitname` varchar(50) NOT NULL,
  `model` varchar(50) DEFAULT NULL,
  `skin` text DEFAULT NULL,
  `outfitId` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `player_outfits`
--

INSERT INTO `player_outfits` (`id`, `citizenid`, `outfitname`, `model`, `skin`, `outfitId`) VALUES
(1, 'TUC83121', 'Po', '1885233650', '{\"vest\":{\"item\":50,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"bag\":{\"item\":0,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"ear\":{\"item\":1,\"defaultItem\":-1,\"texture\":0,\"defaultTexture\":0},\"decals\":{\"item\":73,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"t-shirt\":{\"item\":72,\"defaultItem\":1,\"texture\":0,\"defaultTexture\":0},\"eyebrows\":{\"item\":-1,\"defaultItem\":-1,\"texture\":1,\"defaultTexture\":1},\"pants\":{\"item\":24,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"arms\":{\"item\":115,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"bracelet\":{\"item\":-1,\"defaultItem\":-1,\"texture\":0,\"defaultTexture\":0},\"watch\":{\"item\":-1,\"defaultItem\":-1,\"texture\":0,\"defaultTexture\":0},\"hat\":{\"item\":133,\"defaultItem\":-1,\"texture\":0,\"defaultTexture\":0},\"beard\":{\"item\":-1,\"defaultItem\":-1,\"texture\":1,\"defaultTexture\":1},\"accessory\":{\"item\":1,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"hair\":{\"item\":52,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"face\":{\"item\":7,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"ageing\":{\"item\":-1,\"defaultItem\":-1,\"texture\":0,\"defaultTexture\":0},\"glass\":{\"item\":19,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"mask\":{\"item\":163,\"defaultItem\":0,\"texture\":5,\"defaultTexture\":0},\"torso2\":{\"item\":51,\"defaultItem\":0,\"texture\":0,\"defaultTexture\":0},\"lipstick\":{\"item\":10,\"defaultItem\":-1,\"texture\":1,\"defaultTexture\":1},\"makeup\":{\"item\":14,\"defaultItem\":-1,\"texture\":1,\"defaultTexture\":1},\"shoes\":{\"item\":109,\"defaultItem\":1,\"texture\":0,\"defaultTexture\":0},\"blush\":{\"item\":-1,\"defaultItem\":-1,\"texture\":1,\"defaultTexture\":1}}', 'outfit-4-4313'),
(2, 'TUC83121', 'se', '1885233650', '{\"mask\":{\"item\":163,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":5},\"glass\":{\"item\":12,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":11},\"pants\":{\"item\":33,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"accessory\":{\"item\":1,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"face\":{\"item\":7,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"lipstick\":{\"item\":10,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"bracelet\":{\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0},\"arms\":{\"item\":116,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"shoes\":{\"item\":25,\"defaultTexture\":0,\"defaultItem\":1,\"texture\":0},\"makeup\":{\"item\":14,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"hair\":{\"item\":52,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"torso2\":{\"item\":94,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"eyebrows\":{\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"ear\":{\"item\":1,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0},\"beard\":{\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"hat\":{\"item\":36,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":4},\"blush\":{\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"vest\":{\"item\":50,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":1},\"watch\":{\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0},\"ageing\":{\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0},\"decals\":{\"item\":0,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"bag\":{\"item\":0,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"t-shirt\":{\"item\":164,\"defaultTexture\":0,\"defaultItem\":1,\"texture\":0}}', 'outfit-4-4313'),
(3, 'TUC83121', 'ses', '1885233650', '{\"mask\":{\"item\":163,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"glass\":{\"item\":12,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":11},\"pants\":{\"item\":65,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"accessory\":{\"item\":0,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"face\":{\"item\":7,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"lipstick\":{\"item\":10,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"bracelet\":{\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0},\"arms\":{\"item\":143,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"shoes\":{\"item\":77,\"defaultTexture\":0,\"defaultItem\":1,\"texture\":0},\"makeup\":{\"item\":14,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"hair\":{\"item\":52,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"torso2\":{\"item\":46,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"eyebrows\":{\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"ear\":{\"item\":1,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0},\"beard\":{\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"hat\":{\"item\":36,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":3},\"blush\":{\"item\":-1,\"defaultTexture\":1,\"defaultItem\":-1,\"texture\":1},\"vest\":{\"item\":0,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":1},\"watch\":{\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0},\"ageing\":{\"item\":-1,\"defaultTexture\":0,\"defaultItem\":-1,\"texture\":0},\"decals\":{\"item\":0,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"bag\":{\"item\":0,\"defaultTexture\":0,\"defaultItem\":0,\"texture\":0},\"t-shirt\":{\"item\":52,\"defaultTexture\":0,\"defaultItem\":1,\"texture\":0}}', 'outfit-1-8935');

-- --------------------------------------------------------

--
-- Table structure for table `player_vehicles`
--

CREATE TABLE `player_vehicles` (
  `#` int(11) NOT NULL,
  `steam` varchar(50) DEFAULT NULL,
  `citizenid` varchar(50) DEFAULT NULL,
  `vehicle` varchar(50) DEFAULT NULL,
  `hash` varchar(50) DEFAULT NULL,
  `mods` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `plate` varchar(50) NOT NULL,
  `fakeplate` varchar(50) DEFAULT NULL,
  `garage` varchar(50) DEFAULT NULL,
  `fuel` int(11) DEFAULT 100,
  `engine` float DEFAULT 1000,
  `body` float DEFAULT 1000,
  `state` int(11) DEFAULT 1,
  `depotprice` int(11) NOT NULL DEFAULT 0,
  `drivingdistance` int(50) DEFAULT NULL,
  `status` text DEFAULT NULL,
  `stater` varchar(50) CHARACTER SET latin1 COLLATE latin1_spanish_ci DEFAULT NULL,
  `metadata` mediumtext CHARACTER SET latin1 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `player_vehicles`
--

INSERT INTO `player_vehicles` (`#`, `steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `fakeplate`, `garage`, `fuel`, `engine`, `body`, `state`, `depotprice`, `drivingdistance`, `status`, `stater`, `metadata`) VALUES
(23, 'steam:110000147388a80', 'WIE04494', 'senna', '-433961724', '{\"modEngineBlock\":-1,\"modBackWheels\":-1,\"modFrame\":-1,\"modSteeringWheel\":-1,\"plate\":\"60NDR234\",\"modTrunk\":-1,\"modBrakes\":-1,\"modAirFilter\":-1,\"health\":1000,\"modExhaust\":-1,\"extras\":[],\"modSuspension\":-1,\"modFrontBumper\":-1,\"modTrimA\":-1,\"modCustomTyres\":false,\"neonColor\":[255,0,255],\"modHorns\":-1,\"modDashboard\":-1,\"modGrille\":-1,\"wheelColor\":156,\"modWindows\":-1,\"modRearBumper\":-1,\"modTurbo\":false,\"modRightFender\":-1,\"modSideSkirt\":-1,\"color2Custom\":[51,51,51],\"modPlateHolder\":-1,\"wheels\":7,\"modTank\":-1,\"modVanityPlate\":-1,\"modFender\":-1,\"modSpoilers\":-1,\"modAerials\":-1,\"dirtLevel\":0.00000308794733,\"modSmokeEnabled\":false,\"modStruts\":-1,\"color1Custom\":[51,51,51],\"modHood\":-1,\"color2\":8,\"windowTint\":-1,\"modLivery\":-1,\"plateIndex\":0,\"color1\":8,\"modEngine\":-1,\"modXenon\":255,\"modTransmission\":-1,\"modFrontWheels\":-1,\"modTrimB\":-1,\"modDoorSpeaker\":-1,\"tyreSmokeColor\":[255,255,255],\"modOrnaments\":-1,\"modArchCover\":-1,\"modAPlate\":-1,\"modShifterLeavers\":-1,\"modSpeakers\":-1,\"neonEnabled\":[false,false,false,false],\"modRoof\":-1,\"modDial\":-1,\"modSeats\":-1,\"pearlescentColor\":134,\"modArmor\":-1,\"model\":-433961724,\"modHydrolic\":-1}', '60NDR234', NULL, 'Pillbox Parking', 100, 1000, 1000, 1, 0, 73, NULL, 'in', '{\"Body\":1000.0,\"Engine\":1000.0,\"Fuel\":0}'),
(24, 'steam:110000147388a80', 'WIE04494', 'GT2RS', '-302443788', '{\"modRoof\":-1,\"modSteeringWheel\":-1,\"modHorns\":-1,\"modSmokeEnabled\":false,\"modTrimA\":-1,\"modSideSkirt\":-1,\"modArmor\":-1,\"color1Custom\":[15,15,15],\"modRightFender\":-1,\"modFrame\":-1,\"plate\":\"63LVW497\",\"color2\":1,\"color2Custom\":[15,15,15],\"modPlateHolder\":-1,\"modRearBumper\":-1,\"modGrille\":-1,\"model\":-302443788,\"extras\":[],\"modAirFilter\":-1,\"modDial\":-1,\"dirtLevel\":1.00000023841857,\"wheelColor\":1,\"modDoorSpeaker\":-1,\"modSpoilers\":-1,\"neonEnabled\":[false,false,false,false],\"modOrnaments\":-1,\"windowTint\":-1,\"modTrimB\":-1,\"modEngine\":-1,\"modCustomTyres\":false,\"modFrontWheels\":-1,\"modTrunk\":-1,\"pearlescentColor\":1,\"neonColor\":[255,0,255],\"health\":1000,\"modEngineBlock\":-1,\"plateIndex\":0,\"color1\":1,\"modFrontBumper\":-1,\"modArchCover\":-1,\"modFender\":-1,\"modHood\":-1,\"modTurbo\":false,\"modAerials\":-1,\"tyreSmokeColor\":[255,255,255],\"modStruts\":-1,\"modSuspension\":-1,\"modSpeakers\":-1,\"modVanityPlate\":-1,\"modSeats\":-1,\"modExhaust\":-1,\"modBackWheels\":-1,\"modDashboard\":-1,\"modBrakes\":-1,\"modTransmission\":-1,\"modAPlate\":-1,\"modXenon\":255,\"modShifterLeavers\":-1,\"modTank\":-1,\"wheels\":7,\"modHydrolic\":-1,\"modWindows\":-1,\"modLivery\":-1}', '63LVW497', NULL, 'Legion Parking', 100, 1000, 1000, 1, 0, 55, NULL, 'out', '{\"Body\":1000.0,\"Engine\":1000.0,\"Fuel\":0}'),
(25, 'steam:110000147388a80', 'WIE04494', 'btype3', '-602287871', '{\"modRightFender\":-1,\"neonEnabled\":[false,false,false,false],\"modOrnaments\":-1,\"modFrontBumper\":-1,\"modSeats\":-1,\"modTrunk\":-1,\"modDashboard\":-1,\"modFrame\":-1,\"modEngine\":-1,\"windowTint\":-1,\"modDial\":-1,\"modPlateHolder\":-1,\"wheels\":2,\"neonColor\":[255,0,255],\"modFrontWheels\":-1,\"dirtLevel\":3.00000047683715,\"modSpeakers\":-1,\"modGrille\":-1,\"modTrimA\":-1,\"pearlescentColor\":0,\"modXenon\":255,\"modSideSkirt\":-1,\"modAerials\":-1,\"color1\":5,\"modDoorSpeaker\":-1,\"health\":1000,\"modTransmission\":-1,\"modHood\":-1,\"plate\":\"87OBD877\",\"color2Custom\":[28,30,33],\"modTrimB\":-1,\"modVanityPlate\":-1,\"modCustomTyres\":false,\"modShifterLeavers\":-1,\"modEngineBlock\":-1,\"tyreSmokeColor\":[255,255,255],\"modWindows\":-1,\"plateIndex\":1,\"wheelColor\":156,\"modHorns\":-1,\"modRearBumper\":-1,\"modSpoilers\":-1,\"modAirFilter\":-1,\"modFender\":-1,\"modLivery\":-1,\"color2\":2,\"modSteeringWheel\":-1,\"modBrakes\":-1,\"model\":-602287871,\"modArmor\":-1,\"modRoof\":-1,\"modSuspension\":-1,\"modTurbo\":false,\"modSmokeEnabled\":false,\"extras\":[],\"modStruts\":-1,\"modExhaust\":-1,\"modTank\":-1,\"color1Custom\":[119,124,135],\"modArchCover\":-1,\"modAPlate\":-1,\"modBackWheels\":-1,\"modHydrolic\":-1}', '87OBD877', NULL, 'Pillbox Parking', 100, 1000, 1000, 1, 900, 21, NULL, 'in', '{\"Body\":1000.0,\"Engine\":1000.0,\"Fuel\":0}'),
(26, 'steam:110000147388a80', 'WIE04494', 'btype3', '-602287871', '{\"modRightFender\":-1,\"neonEnabled\":[false,false,false,false],\"modOrnaments\":-1,\"modFrontBumper\":-1,\"modSeats\":-1,\"modTrunk\":-1,\"modDashboard\":-1,\"modFrame\":-1,\"modEngine\":-1,\"windowTint\":-1,\"modDial\":-1,\"modPlateHolder\":-1,\"wheels\":2,\"neonColor\":[255,0,255],\"modFrontWheels\":-1,\"dirtLevel\":6.00000810623168,\"modSpeakers\":-1,\"modGrille\":-1,\"modTrimA\":-1,\"pearlescentColor\":0,\"modXenon\":255,\"modSideSkirt\":-1,\"modAerials\":-1,\"color1\":5,\"modDoorSpeaker\":-1,\"health\":1000,\"modTransmission\":-1,\"modHood\":-1,\"plate\":\"23QKQ259\",\"color2Custom\":[28,30,33],\"modTrimB\":-1,\"modVanityPlate\":-1,\"modCustomTyres\":false,\"modShifterLeavers\":-1,\"modEngineBlock\":-1,\"tyreSmokeColor\":[255,255,255],\"modWindows\":-1,\"plateIndex\":1,\"wheelColor\":156,\"modHorns\":-1,\"modRearBumper\":-1,\"modSpoilers\":-1,\"modAirFilter\":-1,\"modFender\":-1,\"modLivery\":-1,\"color2\":2,\"modSteeringWheel\":-1,\"modBrakes\":-1,\"model\":-602287871,\"modArmor\":-1,\"modRoof\":-1,\"modSuspension\":-1,\"modTurbo\":false,\"modSmokeEnabled\":false,\"extras\":[],\"modStruts\":-1,\"modExhaust\":-1,\"modTank\":-1,\"color1Custom\":[119,124,135],\"modArchCover\":-1,\"modAPlate\":-1,\"modBackWheels\":-1,\"modHydrolic\":-1}', '23QKQ259', NULL, NULL, 100, 1000, 1000, 1, 0, 20, NULL, NULL, NULL),
(27, 'steam:110000147388a80', 'WIE04494', 'foxct', '-221557333', '{\"modBrakes\":-1,\"modSpeakers\":-1,\"plate\":\"85GIR213\",\"modTrimB\":-1,\"modFrame\":-1,\"model\":-221557333,\"modDial\":-1,\"modSideSkirt\":-1,\"modHorns\":-1,\"modTank\":-1,\"modFender\":-1,\"modGrille\":-1,\"modSpoilers\":-1,\"modHood\":-1,\"tyreSmokeColor\":[255,255,255],\"modLivery\":-1,\"modAPlate\":-1,\"modTransmission\":-1,\"color2\":112,\"modPlateHolder\":-1,\"modFrontWheels\":-1,\"modXenon\":255,\"color2Custom\":[179,185,201],\"dirtLevel\":8.00023174285888,\"modSeats\":-1,\"color1Custom\":[179,185,201],\"modRightFender\":-1,\"modVanityPlate\":-1,\"modBackWheels\":-1,\"modAerials\":-1,\"modSmokeEnabled\":false,\"color1\":112,\"modArchCover\":-1,\"neonEnabled\":[false,false,false,false],\"modCustomTyres\":false,\"modAirFilter\":-1,\"modDoorSpeaker\":-1,\"modExhaust\":-1,\"modStruts\":-1,\"modTrimA\":-1,\"modArmor\":-1,\"modHydrolic\":-1,\"plateIndex\":4,\"extras\":[],\"modShifterLeavers\":-1,\"health\":1000,\"modRoof\":-1,\"windowTint\":-1,\"pearlescentColor\":156,\"modEngine\":-1,\"modOrnaments\":-1,\"modTrunk\":-1,\"neonColor\":[255,0,255],\"modEngineBlock\":-1,\"wheels\":3,\"modDashboard\":-1,\"modTurbo\":false,\"modSteeringWheel\":-1,\"modSuspension\":-1,\"modWindows\":-1,\"wheelColor\":1,\"modFrontBumper\":-1,\"modRearBumper\":-1}', '85GIR213', NULL, 'Legion Parking', 100, 1000, 1000, 1, 0, 289, NULL, 'out', '{\"Engine\":1000.0,\"Fuel\":0,\"Body\":1000.0}'),
(28, 'steam:110000147388a80', 'WIE04494', 'senna', '-433961724', '{\"modLivery\":-1,\"modAerials\":-1,\"plate\":\"89VML774\",\"modStruts\":-1,\"plateIndex\":3,\"neonEnabled\":[false,false,false,false],\"wheels\":7,\"modHood\":-1,\"modFrame\":-1,\"pearlescentColor\":134,\"modSpoilers\":-1,\"model\":-433961724,\"neonColor\":[255,0,255],\"modEngineBlock\":-1,\"modWindows\":-1,\"modTank\":-1,\"modSeats\":-1,\"wheelColor\":156,\"modDial\":-1,\"modCustomTyres\":false,\"modRightFender\":-1,\"modTrimB\":-1,\"modBrakes\":-1,\"modRearBumper\":-1,\"dirtLevel\":6.00000238418579,\"tyreSmokeColor\":[255,255,255],\"color2Custom\":[51,51,51],\"modRoof\":-1,\"modVanityPlate\":-1,\"modAPlate\":-1,\"modTransmission\":-1,\"modDoorSpeaker\":-1,\"modBackWheels\":-1,\"windowTint\":-1,\"modArmor\":-1,\"modSpeakers\":-1,\"modSteeringWheel\":-1,\"modTrimA\":-1,\"color2\":8,\"modTrunk\":-1,\"modExhaust\":-1,\"modFrontWheels\":-1,\"modSmokeEnabled\":false,\"modOrnaments\":-1,\"modPlateHolder\":-1,\"extras\":[],\"color1Custom\":[51,51,51],\"modFrontBumper\":-1,\"modTurbo\":false,\"color1\":8,\"modSideSkirt\":-1,\"modXenon\":255,\"modArchCover\":-1,\"modAirFilter\":-1,\"modFender\":-1,\"modGrille\":-1,\"modEngine\":-1,\"modHorns\":-1,\"modShifterLeavers\":-1,\"health\":1000,\"modSuspension\":-1,\"modDashboard\":-1,\"modHydrolic\":-1}', '89VML774', NULL, NULL, 100, 1000, 1000, 1, 0, NULL, NULL, NULL, NULL),
(29, 'steam:110000147388a80', 'WIE04494', 'senna', '-433961724', '{\"modLivery\":-1,\"modAerials\":-1,\"plate\":\"21QDX301\",\"modStruts\":-1,\"plateIndex\":1,\"neonEnabled\":[false,false,false,false],\"wheels\":7,\"modHood\":-1,\"modFrame\":-1,\"pearlescentColor\":0,\"modSpoilers\":-1,\"model\":-433961724,\"neonColor\":[255,0,255],\"modEngineBlock\":-1,\"modWindows\":-1,\"modTank\":-1,\"modSeats\":-1,\"wheelColor\":156,\"modDial\":-1,\"modCustomTyres\":false,\"modRightFender\":-1,\"modTrimB\":-1,\"modBrakes\":-1,\"modRearBumper\":-1,\"dirtLevel\":4.0000033378601,\"tyreSmokeColor\":[255,255,255],\"color2Custom\":[51,51,51],\"modRoof\":-1,\"modVanityPlate\":-1,\"modAPlate\":-1,\"modTransmission\":-1,\"modDoorSpeaker\":-1,\"modBackWheels\":-1,\"windowTint\":-1,\"modArmor\":-1,\"modSpeakers\":-1,\"modSteeringWheel\":-1,\"modTrimA\":-1,\"color2\":8,\"modTrunk\":-1,\"modExhaust\":-1,\"modFrontWheels\":-1,\"modSmokeEnabled\":false,\"modOrnaments\":-1,\"modPlateHolder\":-1,\"extras\":[],\"color1Custom\":[194,102,16],\"modFrontBumper\":-1,\"modTurbo\":false,\"color1\":138,\"modSideSkirt\":-1,\"modXenon\":255,\"modArchCover\":-1,\"modAirFilter\":-1,\"modFender\":-1,\"modGrille\":-1,\"modEngine\":-1,\"modHorns\":-1,\"modShifterLeavers\":-1,\"health\":1000,\"modSuspension\":-1,\"modDashboard\":-1,\"modHydrolic\":-1}', '21QDX301', NULL, NULL, 100, 1000, 1000, 1, 1000, 407750, NULL, NULL, NULL),
(30, 'steam:110000147388a80', 'WIE04494', 'GT2RS', '-302443788', '{\"modDoorSpeaker\":-1,\"wheelColor\":1,\"wheels\":7,\"tyreSmokeColor\":[255,255,255],\"modRightFender\":-1,\"neonEnabled\":[false,false,false,false],\"modTrimA\":-1,\"color2\":1,\"modTrunk\":-1,\"modHorns\":-1,\"modWindows\":-1,\"pearlescentColor\":1,\"windowTint\":-1,\"modRoof\":-1,\"plate\":\"69NON072\",\"modVanityPlate\":-1,\"modLivery\":-1,\"modDial\":-1,\"modEngine\":-1,\"modArmor\":-1,\"extras\":[],\"modArchCover\":-1,\"modAerials\":-1,\"modStruts\":-1,\"modPlateHolder\":-1,\"modBrakes\":-1,\"modBackWheels\":-1,\"modCustomTyres\":false,\"modSeats\":-1,\"modSmokeEnabled\":false,\"modEngineBlock\":-1,\"modSideSkirt\":-1,\"modTransmission\":-1,\"modRearBumper\":-1,\"modFrame\":-1,\"modTrimB\":-1,\"modSpeakers\":-1,\"color1Custom\":[15,15,15],\"model\":-302443788,\"modShifterLeavers\":-1,\"modSuspension\":-1,\"modAPlate\":-1,\"modTurbo\":false,\"modHydrolic\":-1,\"modTank\":-1,\"modOrnaments\":-1,\"modFender\":-1,\"modFrontBumper\":-1,\"neonColor\":[255,0,255],\"modFrontWheels\":-1,\"modXenon\":255,\"plateIndex\":0,\"modGrille\":-1,\"health\":1000,\"modHood\":-1,\"modSteeringWheel\":-1,\"color2Custom\":[15,15,15],\"modSpoilers\":-1,\"modAirFilter\":-1,\"dirtLevel\":2.00191307067871,\"modExhaust\":-1,\"modDashboard\":-1,\"color1\":1}', '69NON072', NULL, NULL, 100, 1000, 1000, 1, 0, NULL, NULL, NULL, NULL),
(31, 'steam:110000147388a80', 'WIE04494', 'laferrari17', '1421669475', '{\"modSmokeEnabled\":1,\"color2Custom\":[8,8,8],\"modEngine\":3,\"modRoof\":-1,\"modXenon\":255,\"modStruts\":-1,\"modFrame\":-1,\"modAPlate\":-1,\"modHydrolic\":-1,\"modFender\":-1,\"color2Type\":6,\"modFrontBumper\":-1,\"tyreSmokeColor\":[255,0,0],\"color1Custom\":[191,0,0],\"modSeats\":-1,\"modBrakes\":2,\"modEngineBlock\":-1,\"modExhaust\":-1,\"engineHealth\":1000.0,\"modGrille\":-1,\"modDial\":-1,\"modLivery\":-1,\"color1Type\":6,\"neonColor\":[159,0,0],\"modOrnaments\":-1,\"model\":1421669475,\"wheels\":0,\"color1\":0,\"modTrunk\":-1,\"dirtLevel\":97.33290100097656,\"modAerials\":-1,\"windowTint\":-1,\"wheelColor\":156,\"plate\":\"0MI448NS\",\"modSpeakers\":-1,\"modShifterLeavers\":-1,\"modSpoilers\":-1,\"extras\":[],\"modSuspension\":3,\"modArmor\":4,\"modSteeringWheel\":-1,\"modPlateHolder\":-1,\"pearlescentColor\":43,\"plateIndex\":3,\"modArchCover\":-1,\"modHorns\":-1,\"modHood\":-1,\"modRearBumper\":-1,\"modSideSkirt\":-1,\"neonEnabled\":[1,1,1,1],\"modTrimA\":-1,\"modAirFilter\":-1,\"modDashboard\":-1,\"modTurbo\":1,\"fuelLevel\":97.33290100097656,\"modBackWheels\":-1,\"livery\":-1,\"modWindows\":-1,\"modRightFender\":-1,\"modFrontWheels\":-1,\"modTrimB\":-1,\"modVanityPlate\":-1,\"bodyHealth\":1000.0,\"modTransmission\":2,\"modTank\":-1,\"color2\":0,\"modDoorSpeaker\":-1}', '0MI448NS', NULL, NULL, 100, 1000, 1000, 1, 0, 12563, NULL, NULL, NULL),
(32, 'steam:110000147388a80', 'LHP12548', 'btype3', '-602287871', '{\"modDoorSpeaker\":-1,\"modTurbo\":false,\"modHorns\":-1,\"pearlescentColor\":0,\"modWindows\":-1,\"modShifterLeavers\":-1,\"modSeats\":-1,\"modXenon\":255,\"dirtLevel\":2.00000286102294,\"modAerials\":-1,\"modDashboard\":-1,\"modTrimA\":-1,\"plateIndex\":0,\"modArmor\":-1,\"modRightFender\":-1,\"modGrille\":-1,\"modArchCover\":-1,\"modTrimB\":-1,\"modExhaust\":-1,\"color1Custom\":[119,124,135],\"modHydrolic\":-1,\"modSpoilers\":-1,\"modSpeakers\":-1,\"modHood\":-1,\"wheels\":2,\"modBrakes\":-1,\"modEngineBlock\":-1,\"modLivery\":-1,\"modFrame\":-1,\"tyreSmokeColor\":[255,255,255],\"modFrontBumper\":-1,\"modSuspension\":-1,\"modSideSkirt\":-1,\"wheelColor\":156,\"modVanityPlate\":-1,\"modSmokeEnabled\":false,\"modTrunk\":-1,\"modAPlate\":-1,\"modTransmission\":-1,\"modSteeringWheel\":-1,\"model\":-602287871,\"modRoof\":-1,\"modStruts\":-1,\"modDial\":-1,\"color2Custom\":[28,30,33],\"modOrnaments\":-1,\"modFender\":-1,\"modRearBumper\":-1,\"extras\":[],\"modCustomTyres\":false,\"health\":1000,\"windowTint\":-1,\"plate\":\"85WOR799\",\"color1\":5,\"neonEnabled\":[false,false,false,false],\"modAirFilter\":-1,\"modPlateHolder\":-1,\"modTank\":-1,\"color2\":2,\"modEngine\":-1,\"modBackWheels\":-1,\"neonColor\":[255,0,255],\"modFrontWheels\":-1}', '85WOR799', NULL, 'motelgarage', 98, 1000, 1000, 1, 0, 1581, NULL, 'out', '{\"Body\":1000.0,\"Fuel\":0,\"Engine\":1000.0}'),
(33, 'steam:110000147388a80', 'LHP12548', 'nero', '1034187331', '{\"modHydrolic\":-1,\"wheels\":7,\"modSeats\":-1,\"modFrontBumper\":-1,\"plateIndex\":0,\"modHorns\":-1,\"neonEnabled\":[false,false,false,false],\"modRearBumper\":-1,\"modHood\":-1,\"modTrimB\":-1,\"modRoof\":-1,\"modTrimA\":-1,\"modSideSkirt\":-1,\"neonColor\":[255,0,255],\"tyreSmokeColor\":[255,255,255],\"color2Custom\":[0,85,196],\"modFrame\":-1,\"modDashboard\":-1,\"extras\":[],\"wheelColor\":112,\"modEngine\":-1,\"plate\":\"49QFM144\",\"modGrille\":-1,\"modSpoilers\":-1,\"modEngineBlock\":-1,\"modVanityPlate\":-1,\"color1Custom\":[179,185,201],\"modFrontWheels\":-1,\"modDoorSpeaker\":-1,\"modArchCover\":-1,\"modTank\":-1,\"modSteeringWheel\":-1,\"modOrnaments\":-1,\"windowTint\":-1,\"health\":1000,\"modAPlate\":-1,\"color2\":70,\"modExhaust\":-1,\"modBrakes\":-1,\"modBackWheels\":-1,\"modTransmission\":-1,\"modDial\":-1,\"modSpeakers\":-1,\"modPlateHolder\":-1,\"modLivery\":-1,\"modTurbo\":false,\"modXenon\":255,\"modRightFender\":-1,\"modStruts\":-1,\"modSuspension\":-1,\"pearlescentColor\":18,\"modAerials\":-1,\"model\":1034187331,\"modSmokeEnabled\":false,\"modShifterLeavers\":-1,\"modFender\":-1,\"color1\":112,\"dirtLevel\":3.01742553710937,\"modTrunk\":-1,\"modCustomTyres\":false,\"modAirFilter\":-1,\"modWindows\":-1,\"modArmor\":-1}', '49QFM144', NULL, 'Pillbox Parking', 100, 1000, 1000, 1, 0, 377724, NULL, 'out', '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":0}'),
(34, 'steam:110000147388a80', 'LHP12548', 'prototipo', '2123327359', '{}', '0MN711UJ', NULL, NULL, 100, 1000, 1000, 1, 0, 2426, NULL, NULL, NULL),
(36, 'steam:110000147388a80', 'TUC83121', 'jes21', '1227057313', '{\"modBackWheels\":-1,\"modPlateHolder\":-1,\"modAerials\":-1,\"color1\":0,\"modSpoilers\":-1,\"engineHealth\":1000.0,\"modTrimB\":-1,\"modBrakes\":2,\"dirtLevel\":64.87000274658203,\"modWindows\":-1,\"livery\":-1,\"modVanityPlate\":-1,\"wheels\":0,\"modArmor\":4,\"modHorns\":-1,\"modStruts\":-1,\"modHydrolic\":-1,\"modFender\":-1,\"modSideSkirt\":-1,\"modFrontBumper\":-1,\"color2\":0,\"modTransmission\":2,\"modRoof\":-1,\"modDial\":-1,\"modAPlate\":-1,\"model\":1227057313,\"bodyHealth\":1000.0,\"modSuspension\":3,\"color1Type\":1,\"color2Type\":6,\"modOrnaments\":-1,\"modExhaust\":-1,\"modTrunk\":-1,\"modDoorSpeaker\":-1,\"fuelLevel\":64.87000274658203,\"neonEnabled\":[false,false,false,false],\"modSeats\":-1,\"modFrontWheels\":-1,\"modFrame\":-1,\"modRightFender\":-1,\"modSpeakers\":-1,\"modRearBumper\":-1,\"color2Custom\":[0,191,120],\"wheelColor\":123,\"neonColor\":[255,0,255],\"plate\":\"06OTN181\",\"plateIndex\":5,\"modEngine\":3,\"modArchCover\":-1,\"extras\":{\"2\":1,\"9\":1,\"1\":1,\"7\":false},\"modGrille\":-1,\"color1Custom\":[231,88,88],\"modShifterLeavers\":-1,\"modAirFilter\":-1,\"modXenon\":12,\"modLivery\":-1,\"modTank\":-1,\"modSmokeEnabled\":1,\"modEngineBlock\":-1,\"pearlescentColor\":55,\"modTurbo\":1,\"modHood\":-1,\"windowTint\":3,\"modTrimA\":-1,\"modDashboard\":-1,\"modSteeringWheel\":-1,\"tyreSmokeColor\":[241,46,46]}', '06OTN181', NULL, 'motelgarage', 61, 1.04, 984, 1, 0, 2146, NULL, NULL, NULL),
(37, 'steam:110000147388a80', 'TUC83121', 'amgone', '1766614807', '{\"extras\":[],\"color1Custom\":[64,0,0],\"modBrakes\":2,\"color2\":2,\"model\":1766614807,\"modBackWheels\":-1,\"modArchCover\":-1,\"neonEnabled\":[false,false,false,false],\"modExhaust\":-1,\"health\":961,\"plateIndex\":3,\"dirtLevel\":0.3603763282299,\"color1\":2,\"pearlescentColor\":134,\"modShifterLeavers\":-1,\"modEngine\":3,\"modWindows\":-1,\"modPlateHolder\":-1,\"plate\":\"43CTU755\",\"modEngineBlock\":-1,\"modDoorSpeaker\":-1,\"modTrunk\":-1,\"modSpoilers\":-1,\"modRoof\":-1,\"tyreSmokeColor\":[255,255,255],\"modSteeringWheel\":-1,\"modAirFilter\":-1,\"modHorns\":-1,\"modTank\":-1,\"modTurbo\":1,\"modLivery\":-1,\"color2Custom\":[28,30,33],\"modStruts\":-1,\"modArmor\":-1,\"modXenon\":255,\"modCustomTyres\":false,\"modFrontWheels\":-1,\"modRearBumper\":-1,\"modFender\":0,\"modSpeakers\":-1,\"windowTint\":-1,\"modSeats\":-1,\"wheelColor\":156,\"modFrontBumper\":-1,\"modTransmission\":2,\"modDashboard\":-1,\"modSmokeEnabled\":1,\"modFrame\":-1,\"neonColor\":[255,0,255],\"modTrimA\":-1,\"modOrnaments\":-1,\"modHood\":-1,\"modVanityPlate\":-1,\"modDial\":-1,\"modGrille\":-1,\"modAerials\":-1,\"modSuspension\":-1,\"modTrimB\":-1,\"modSideSkirt\":-1,\"modHydrolic\":-1,\"wheels\":7,\"modRightFender\":-1,\"modAPlate\":-1}', '43CTU755', NULL, 'motelgarage', 100, 1000, 1000, 1, 0, 227595, NULL, NULL, NULL),
(38, 'steam:110000147388a80', 'TUC83121', 'gcmlamboultimae', '214886145', '{\"extras\":[],\"color1Custom\":[225,163,126],\"modBrakes\":2,\"color2\":120,\"model\":214886145,\"modBackWheels\":-1,\"modArchCover\":-1,\"neonEnabled\":[false,false,false,false],\"modExhaust\":-1,\"health\":1000,\"plateIndex\":4,\"dirtLevel\":2.21985530853271,\"color1\":117,\"pearlescentColor\":44,\"modShifterLeavers\":-1,\"modEngine\":3,\"modWindows\":-1,\"modPlateHolder\":-1,\"plate\":\"84EMM957\",\"modEngineBlock\":-1,\"modDoorSpeaker\":-1,\"modTrunk\":-1,\"modSpoilers\":-1,\"modRoof\":-1,\"tyreSmokeColor\":[255,255,255],\"modSteeringWheel\":-1,\"modAirFilter\":-1,\"modHorns\":-1,\"modTank\":-1,\"modTurbo\":1,\"modLivery\":-1,\"color2Custom\":[0,96,60],\"modStruts\":-1,\"modArmor\":4,\"modXenon\":255,\"modCustomTyres\":false,\"modFrontWheels\":-1,\"modRearBumper\":-1,\"modFender\":-1,\"modSpeakers\":-1,\"windowTint\":-1,\"modSeats\":-1,\"wheelColor\":8,\"modFrontBumper\":-1,\"modTransmission\":2,\"modDashboard\":-1,\"modSmokeEnabled\":1,\"modFrame\":-1,\"neonColor\":[255,0,255],\"modTrimA\":-1,\"modOrnaments\":-1,\"modHood\":-1,\"modVanityPlate\":-1,\"modDial\":-1,\"modGrille\":-1,\"modAerials\":-1,\"modSuspension\":3,\"modTrimB\":-1,\"modSideSkirt\":-1,\"modHydrolic\":-1,\"wheels\":0,\"modRightFender\":-1,\"modAPlate\":-1}', '84EMM957', NULL, 'motelgarage', 63, 967, 994, 1, 0, 17389, NULL, 'out', '{\"Body\":1000.0,\"Engine\":1000.0,\"Fuel\":0}'),
(39, 'steam:110000147388a80', 'TUC83121', 'AmgGtrLight', '-448744104', '{\"modBackWheels\":-1,\"modPlateHolder\":-1,\"modAerials\":-1,\"color1\":6,\"modSpoilers\":-1,\"engineHealth\":1000.0,\"modTrimB\":-1,\"modBrakes\":2,\"dirtLevel\":65.0,\"modWindows\":-1,\"livery\":0,\"modVanityPlate\":-1,\"wheels\":0,\"modArmor\":4,\"modHorns\":44,\"modStruts\":-1,\"modHydrolic\":-1,\"modFender\":-1,\"modSideSkirt\":-1,\"modFrontBumper\":-1,\"color2\":6,\"modTransmission\":2,\"modRoof\":-1,\"modDial\":-1,\"modAPlate\":-1,\"model\":-448744104,\"bodyHealth\":1000.0,\"modSuspension\":3,\"color1Type\":6,\"color2Type\":6,\"modOrnaments\":-1,\"modExhaust\":-1,\"modTrunk\":-1,\"modDoorSpeaker\":-1,\"fuelLevel\":65.0,\"neonEnabled\":[false,false,false,false],\"modSeats\":-1,\"modFrontWheels\":-1,\"modFrame\":-1,\"modRightFender\":-1,\"modSpeakers\":-1,\"modRearBumper\":-1,\"color2Custom\":[81,84,89],\"wheelColor\":156,\"neonColor\":[255,0,255],\"plate\":\"61YKH416\",\"plateIndex\":0,\"modEngine\":3,\"modArchCover\":-1,\"extras\":{\"1\":1},\"modGrille\":-1,\"color1Custom\":[221,225,189],\"modShifterLeavers\":-1,\"modAirFilter\":-1,\"modXenon\":255,\"modLivery\":-1,\"modTank\":-1,\"modSmokeEnabled\":1,\"modEngineBlock\":-1,\"pearlescentColor\":50,\"modTurbo\":1,\"modHood\":-1,\"windowTint\":-1,\"modTrimA\":-1,\"modDashboard\":-1,\"modSteeringWheel\":-1,\"tyreSmokeColor\":[255,255,255]}', '61YKH416', NULL, 'motelgarage', 61, 996, 996, 0, 0, 18141, NULL, NULL, NULL),
(40, 'steam:110000147388a80', 'TUC83121', 'ben17', '-2049278303', '{\"extras\":[],\"color1Custom\":[231,88,88],\"modBrakes\":2,\"color2\":2,\"model\":-2049278303,\"modBackWheels\":-1,\"modArchCover\":-1,\"neonEnabled\":[false,false,false,false],\"modExhaust\":-1,\"health\":1000,\"plateIndex\":0,\"dirtLevel\":3.22527265548706,\"color1\":120,\"pearlescentColor\":0,\"modShifterLeavers\":-1,\"modEngine\":3,\"modWindows\":-1,\"modPlateHolder\":-1,\"plate\":\"89YYJ853\",\"modEngineBlock\":-1,\"modDoorSpeaker\":-1,\"modTrunk\":-1,\"modSpoilers\":-1,\"modRoof\":-1,\"tyreSmokeColor\":[255,255,255],\"modSteeringWheel\":-1,\"modAirFilter\":-1,\"modHorns\":-1,\"modTank\":-1,\"modTurbo\":1,\"modLivery\":-1,\"color2Custom\":[46,241,95],\"modStruts\":-1,\"modArmor\":4,\"modXenon\":5,\"modCustomTyres\":false,\"modFrontWheels\":-1,\"modRearBumper\":-1,\"modFender\":-1,\"modSpeakers\":-1,\"windowTint\":2,\"modSeats\":-1,\"wheelColor\":156,\"modFrontBumper\":-1,\"modTransmission\":2,\"modDashboard\":-1,\"modSmokeEnabled\":1,\"modFrame\":-1,\"neonColor\":[255,0,255],\"modTrimA\":-1,\"modOrnaments\":-1,\"modHood\":-1,\"modVanityPlate\":-1,\"modDial\":-1,\"modGrille\":-1,\"modAerials\":-1,\"modSuspension\":3,\"modTrimB\":-1,\"modSideSkirt\":-1,\"modHydrolic\":-1,\"wheels\":0,\"modRightFender\":-1,\"modAPlate\":-1}', '89YYJ853', NULL, 'motelgarage', 100, 1000, 1000, 0, 0, 2627, NULL, NULL, NULL),
(48, 'steam:110000147388a80', 'TUC83121', 'deluxo', NULL, '{\"tankHealth\":1000.0,\"modDial\":-1,\"modFrame\":-1,\"modTrimB\":-1,\"modVanityPlate\":-1,\"modSpoilers\":-1,\"modSideSkirt\":-1,\"fuelLevel\":65.0,\"modLivery\":-1,\"modDoorSpeaker\":-1,\"modEngine\":-1,\"wheels\":1,\"modRoof\":-1,\"modXenon\":false,\"modFender\":-1,\"modGrille\":-1,\"color1\":15,\"modPlateHolder\":-1,\"neonColor\":[255,0,255],\"modSteeringWheel\":-1,\"modAPlate\":-1,\"neonEnabled\":[false,false,false,false],\"modDashboard\":-1,\"modBackWheels\":-1,\"modWindows\":-1,\"modHorns\":-1,\"modTurbo\":false,\"modTransmission\":-1,\"modArmor\":-1,\"modRightFender\":-1,\"modFrontBumper\":-1,\"windowTint\":-1,\"modTrunk\":-1,\"model\":1483171323,\"wheelColor\":15,\"modBrakes\":-1,\"modSpeakers\":-1,\"modHydrolic\":-1,\"modSeats\":-1,\"modStruts\":-1,\"modArchCover\":-1,\"tyreSmokeColor\":[255,255,255],\"bodyHealth\":1000.0,\"modRearBumper\":-1,\"modAirFilter\":-1,\"xenonColor\":255,\"extras\":{\"1\":true},\"modSmokeEnabled\":false,\"modSuspension\":-1,\"modFrontWheels\":-1,\"modOrnaments\":-1,\"modHood\":-1,\"modTrimA\":-1,\"modShifterLeavers\":-1,\"color2\":70,\"modExhaust\":-1,\"modAerials\":-1,\"modTank\":-1,\"plateIndex\":0,\"engineHealth\":1000.0,\"plate\":\"MCAW79AZ\",\"modEngineBlock\":-1,\"dirtLevel\":0.0,\"pearlescentColor\":15}', 'MCAW79AZ', NULL, 'mechanic', 100, 1000, 1000, 1, 0, 194102, NULL, NULL, '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":100.0}'),
(49, 'steam:110000147388a80', 'TUC83121', 'bmx', NULL, '{\"tankHealth\":1000.0,\"modDial\":-1,\"modFrame\":-1,\"modTrimB\":-1,\"modVanityPlate\":-1,\"modSpoilers\":-1,\"modSideSkirt\":-1,\"fuelLevel\":0.0,\"modLivery\":-1,\"modDoorSpeaker\":-1,\"modEngine\":-1,\"wheels\":6,\"modRoof\":-1,\"modXenon\":false,\"modFender\":-1,\"modGrille\":-1,\"color1\":7,\"modPlateHolder\":-1,\"neonColor\":[255,0,255],\"modSteeringWheel\":-1,\"modAPlate\":-1,\"neonEnabled\":[false,false,false,false],\"modDashboard\":-1,\"modBackWheels\":-1,\"modWindows\":-1,\"modHorns\":-1,\"modTurbo\":false,\"modTransmission\":-1,\"modArmor\":-1,\"modRightFender\":-1,\"modFrontBumper\":-1,\"windowTint\":-1,\"modTrunk\":-1,\"model\":1131912276,\"wheelColor\":156,\"modBrakes\":-1,\"modSpeakers\":-1,\"modHydrolic\":-1,\"modSeats\":-1,\"modStruts\":-1,\"modArchCover\":-1,\"tyreSmokeColor\":[255,255,255],\"bodyHealth\":1000.0,\"modRearBumper\":-1,\"modAirFilter\":-1,\"xenonColor\":255,\"extras\":[],\"modSmokeEnabled\":false,\"modSuspension\":-1,\"modFrontWheels\":-1,\"modOrnaments\":-1,\"modHood\":-1,\"modTrimA\":-1,\"modShifterLeavers\":-1,\"color2\":0,\"modExhaust\":-1,\"modAerials\":-1,\"modTank\":-1,\"plateIndex\":4,\"engineHealth\":1000.0,\"plate\":\"XDDU912Y\",\"modEngineBlock\":-1,\"dirtLevel\":2.0,\"pearlescentColor\":111}', 'XDDU912Y', NULL, 'Legion Parking', 100, 1000, 1000, 1, 0, 61, NULL, NULL, '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":100.0}'),
(50, 'steam:110000147388a80', 'TUC83121', 'bcps', NULL, '{\"modTurbo\":false,\"modFrontBumper\":-1,\"modArchCover\":-1,\"fuelLevel\":65.0,\"engineHealth\":1000.0,\"bodyHealth\":1000.0,\"tyreSmokeColor\":[255,255,255],\"modEngineBlock\":-1,\"modLivery\":-1,\"modTrunk\":-1,\"modExhaust\":-1,\"plateIndex\":0,\"modRightFender\":-1,\"modSpeakers\":-1,\"modDial\":-1,\"modShifterLeavers\":-1,\"modSuspension\":-1,\"modSteeringWheel\":-1,\"windowTint\":-1,\"modOrnaments\":-1,\"modAPlate\":-1,\"modGrille\":-1,\"modXenon\":false,\"modTransmission\":-1,\"modSideSkirt\":-1,\"neonEnabled\":[false,false,false,false],\"modSmokeEnabled\":false,\"modAirFilter\":-1,\"modFrame\":-1,\"modBrakes\":-1,\"wheels\":0,\"neonColor\":[255,0,255],\"modFrontWheels\":-1,\"extras\":{\"1\":true,\"2\":false},\"color1\":63,\"tankHealth\":1000.0,\"dirtLevel\":0.0,\"modStruts\":-1,\"modArmor\":-1,\"xenonColor\":255,\"plate\":\"YGM0253N\",\"modHydrolic\":-1,\"modBackWheels\":-1,\"modAerials\":-1,\"modSpoilers\":-1,\"modHorns\":-1,\"modVanityPlate\":-1,\"modRoof\":-1,\"modTrimB\":-1,\"color2\":63,\"modWindows\":-1,\"modFender\":-1,\"modPlateHolder\":-1,\"modSeats\":-1,\"modTank\":-1,\"modRearBumper\":-1,\"modDoorSpeaker\":-1,\"modEngine\":-1,\"pearlescentColor\":5,\"modDashboard\":-1,\"modHood\":-1,\"model\":1601332792,\"modTrimA\":-1,\"wheelColor\":156}', 'YGM0253N', NULL, 'Legion Parking', 100, 1000, 1000, 1, 0, 757450, NULL, NULL, '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":100.0}'),
(51, 'steam:110000147388a80', 'TUC83121', 'GT2RS', NULL, '{\"modEngineBlock\":-1,\"fuelLevel\":53.78092956542969,\"modBackWheels\":-1,\"dirtLevel\":53.78092956542969,\"modFrontBumper\":-1,\"modHorns\":44,\"color1Custom\":[0,191,191],\"modSmokeEnabled\":1,\"modTrimA\":-1,\"modSpeakers\":-1,\"modSuspension\":3,\"modAirFilter\":-1,\"modVanityPlate\":-1,\"tyreSmokeColor\":[16,0,128],\"modRightFender\":-1,\"wheelColor\":1,\"modAerials\":-1,\"modTrunk\":-1,\"color2\":1,\"color2Custom\":[24,0,191],\"wheels\":7,\"modFrame\":-1,\"modArchCover\":-1,\"modAPlate\":-1,\"extras\":[],\"modSpoilers\":-1,\"modHydrolic\":-1,\"modFrontWheels\":-1,\"modRearBumper\":-1,\"engineHealth\":972.270263671875,\"modExhaust\":-1,\"plate\":\"XZGK908O\",\"modShifterLeavers\":-1,\"modLivery\":-1,\"modTransmission\":2,\"modSideSkirt\":-1,\"neonColor\":[255,0,255],\"modOrnaments\":-1,\"modHood\":-1,\"modStruts\":-1,\"windowTint\":0,\"modDial\":-1,\"plateIndex\":0,\"color1Type\":4,\"modSteeringWheel\":-1,\"modTurbo\":1,\"modPlateHolder\":-1,\"modEngine\":3,\"color2Type\":6,\"pearlescentColor\":79,\"bodyHealth\":972.270263671875,\"modTank\":-1,\"modArmor\":-1,\"modXenon\":12,\"modDashboard\":-1,\"modDoorSpeaker\":-1,\"modTrimB\":-1,\"model\":-302443788,\"livery\":-1,\"modBrakes\":2,\"modSeats\":-1,\"modGrille\":-1,\"color1\":117,\"modWindows\":-1,\"modFender\":-1,\"neonEnabled\":[false,false,false,false],\"modRoof\":-1}', 'XZGK908O', NULL, 'mechanic', 100, 1000, 1000, 0, 0, 3484, NULL, NULL, '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":100.0}'),
(52, 'steam:110000147388a80', 'TUC83121', 'bcps', NULL, '{\"modWindows\":-1,\"modArmor\":-1,\"modTransmission\":-1,\"bodyHealth\":1000.0,\"wheelColor\":156,\"modFrame\":-1,\"modHydrolic\":-1,\"modRoof\":-1,\"plate\":\"MKN444FX\",\"tyreSmokeColor\":[255,255,255],\"modEngine\":-1,\"modRearBumper\":-1,\"dirtLevel\":0.0,\"tankHealth\":1000.0,\"modFender\":-1,\"modArchCover\":-1,\"modFrontBumper\":-1,\"modDial\":-1,\"modOrnaments\":-1,\"modBrakes\":-1,\"modHood\":-1,\"modExhaust\":-1,\"plateIndex\":0,\"modPlateHolder\":-1,\"model\":1601332792,\"modAerials\":-1,\"modSmokeEnabled\":false,\"modGrille\":-1,\"modSpoilers\":-1,\"wheels\":0,\"neonEnabled\":[false,false,false,false],\"modAPlate\":-1,\"color2\":63,\"modStruts\":-1,\"windowTint\":-1,\"modSuspension\":-1,\"engineHealth\":1000.0,\"modLivery\":-1,\"modFrontWheels\":-1,\"color1\":63,\"modRightFender\":-1,\"fuelLevel\":65.0,\"extras\":{\"2\":false,\"1\":false},\"modHorns\":-1,\"modSideSkirt\":-1,\"modTrunk\":-1,\"modSeats\":-1,\"modTrimA\":-1,\"modTank\":-1,\"modTurbo\":false,\"modAirFilter\":-1,\"xenonColor\":255,\"modEngineBlock\":-1,\"modVanityPlate\":-1,\"pearlescentColor\":5,\"modDashboard\":-1,\"modBackWheels\":-1,\"modSpeakers\":-1,\"modXenon\":false,\"neonColor\":[255,0,255],\"modDoorSpeaker\":-1,\"modShifterLeavers\":-1,\"modTrimB\":-1,\"modSteeringWheel\":-1}', 'MKN444FX', NULL, 'mechanic', 100, 1000, 1000, 1, 0, 435932, NULL, NULL, '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":100.0}'),
(53, 'steam:110000147388a80', 'TUC83121', 'lbdy01', NULL, '{\"modDial\":-1,\"fuelLevel\":65.0,\"color2\":134,\"modTrimA\":-1,\"modSuspension\":-1,\"neonEnabled\":[false,false,false,false],\"modEngine\":-1,\"modHydrolic\":-1,\"modStruts\":-1,\"modBackWheels\":-1,\"modDoorSpeaker\":-1,\"modSpoilers\":-1,\"modFrontBumper\":-1,\"modTrunk\":-1,\"modFrame\":-1,\"modRoof\":-1,\"modArmor\":-1,\"modGrille\":-1,\"modSeats\":-1,\"modPlateHolder\":-1,\"pearlescentColor\":111,\"modLivery\":0,\"modBrakes\":-1,\"modRightFender\":-1,\"neonColor\":[255,0,255],\"wheels\":7,\"modFrontWheels\":-1,\"modArchCover\":-1,\"modTransmission\":-1,\"modDashboard\":-1,\"modSmokeEnabled\":false,\"modTrimB\":-1,\"extras\":[],\"modSteeringWheel\":-1,\"modShifterLeavers\":-1,\"modTank\":-1,\"modSpeakers\":-1,\"plateIndex\":0,\"modTurbo\":false,\"modHorns\":-1,\"modAPlate\":-1,\"modFender\":-1,\"modAerials\":-1,\"modVanityPlate\":-1,\"modHood\":-1,\"modEngineBlock\":-1,\"plate\":\"CYC169GJ\",\"dirtLevel\":1.0,\"modSideSkirt\":-1,\"color1\":117,\"bodyHealth\":1000.0,\"tankHealth\":1000.0,\"xenonColor\":255,\"windowTint\":-1,\"tyreSmokeColor\":[255,255,255],\"wheelColor\":132,\"engineHealth\":1000.0,\"modAirFilter\":-1,\"modExhaust\":-1,\"modOrnaments\":-1,\"model\":143958958,\"modXenon\":false,\"modRearBumper\":-1,\"modWindows\":-1}', 'CYC169GJ', NULL, 'motelgarage', 100, 1000, 1000, 1, 0, 962841, NULL, NULL, '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":100.0}'),
(54, 'steam:110000147388a80', 'TUC83121', 'g632021', '-880511284', '{\"health\":1000,\"modTank\":-1,\"modTrunk\":-1,\"modAPlate\":-1,\"color2Custom\":[255,0,0],\"modSteeringWheel\":-1,\"color1\":117,\"modExhaust\":-1,\"modSideSkirt\":-1,\"modGrille\":-1,\"extras\":[],\"modXenon\":12,\"modHorns\":-1,\"pearlescentColor\":139,\"modRoof\":-1,\"model\":-880511284,\"modOrnaments\":-1,\"modSuspension\":3,\"modVanityPlate\":-1,\"modBrakes\":2,\"tyreSmokeColor\":[153,153,153],\"modStruts\":-1,\"modFrontWheels\":-1,\"modSpeakers\":-1,\"modFrame\":-1,\"modPlateHolder\":-1,\"plateIndex\":5,\"neonEnabled\":[false,false,false,false],\"windowTint\":4,\"modLivery\":-1,\"modTrimB\":-1,\"modHood\":-1,\"modDashboard\":-1,\"modAirFilter\":-1,\"modSpoilers\":-1,\"modDial\":-1,\"modCustomTyres\":false,\"wheelColor\":156,\"modFrontBumper\":-1,\"modTransmission\":2,\"modDoorSpeaker\":-1,\"plate\":\"80LNQ519\",\"modWindows\":-1,\"color1Custom\":[102,102,102],\"dirtLevel\":0.00425554625689,\"modRightFender\":-1,\"modTurbo\":1,\"modSmokeEnabled\":1,\"modArmor\":4,\"modSeats\":-1,\"modBackWheels\":-1,\"modHydrolic\":-1,\"color2\":120,\"modRearBumper\":-1,\"modArchCover\":-1,\"modEngine\":3,\"modFender\":-1,\"modAerials\":-1,\"neonColor\":[255,0,255],\"modEngineBlock\":-1,\"wheels\":0,\"modTrimA\":-1,\"modShifterLeavers\":-1}', '80LNQ519', NULL, NULL, 100, 1000, 1000, 0, 0, 88, NULL, NULL, NULL),
(55, 'steam:110000147388a80', 'TUC83121', 'murus', NULL, '{\"modDial\":-1,\"fuelLevel\":65.0,\"color2\":0,\"modTrimA\":-1,\"modSuspension\":-1,\"neonEnabled\":[false,false,false,false],\"modEngine\":-1,\"modHydrolic\":-1,\"modStruts\":-1,\"modBackWheels\":-1,\"modDoorSpeaker\":-1,\"modSpoilers\":-1,\"modFrontBumper\":-1,\"modTrunk\":-1,\"modFrame\":-1,\"modRoof\":-1,\"modArmor\":-1,\"modGrille\":-1,\"modSeats\":-1,\"modPlateHolder\":-1,\"pearlescentColor\":111,\"modLivery\":-1,\"modBrakes\":-1,\"modRightFender\":-1,\"neonColor\":[255,0,255],\"wheels\":0,\"modFrontWheels\":-1,\"modArchCover\":-1,\"modTransmission\":-1,\"modDashboard\":-1,\"modSmokeEnabled\":false,\"modTrimB\":-1,\"extras\":{\"12\":false,\"10\":false,\"3\":false},\"modSteeringWheel\":-1,\"modShifterLeavers\":-1,\"modTank\":-1,\"modSpeakers\":-1,\"plateIndex\":0,\"modTurbo\":false,\"modHorns\":-1,\"modAPlate\":-1,\"modFender\":-1,\"modAerials\":-1,\"modVanityPlate\":-1,\"modHood\":-1,\"modEngineBlock\":-1,\"plate\":\"GZY466TT\",\"dirtLevel\":0.0,\"modSideSkirt\":-1,\"color1\":6,\"bodyHealth\":1000.0,\"tankHealth\":1000.0,\"xenonColor\":255,\"windowTint\":-1,\"tyreSmokeColor\":[255,255,255],\"wheelColor\":156,\"engineHealth\":1000.0,\"modAirFilter\":-1,\"modExhaust\":-1,\"modOrnaments\":-1,\"model\":-1104226424,\"modXenon\":false,\"modRearBumper\":-1,\"modWindows\":-1}', 'GZY466TT', NULL, 'Legion Parking', 100, 1000, 1000, 0, 0, 130, NULL, NULL, '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":100.0}'),
(56, 'steam:110000147388a80', 'TUC83121', '992Cabriolet4s', NULL, '{\"modHorns\":45,\"color2\":31,\"modTrunk\":-1,\"modSmokeEnabled\":1,\"modBrakes\":2,\"modGrille\":-1,\"modRearBumper\":-1,\"modEngineBlock\":-1,\"modRightFender\":-1,\"modDoorSpeaker\":-1,\"modShifterLeavers\":-1,\"modAPlate\":-1,\"modRoof\":-1,\"livery\":-1,\"modWindows\":-1,\"modSteeringWheel\":-1,\"modSpeakers\":-1,\"modFender\":-1,\"modXenon\":12,\"color1Custom\":[170,170,170],\"modPlateHolder\":-1,\"modArmor\":4,\"pearlescentColor\":83,\"modTransmission\":2,\"wheelColor\":47,\"modAerials\":-1,\"modSpoilers\":-1,\"modTrimA\":-1,\"fuelLevel\":63.55696105957031,\"plateIndex\":5,\"modStruts\":-1,\"wheels\":7,\"neonColor\":[238,238,238],\"modLivery\":-1,\"modBackWheels\":-1,\"modVanityPlate\":-1,\"color1Type\":4,\"bodyHealth\":1000.0,\"modDial\":-1,\"modTurbo\":1,\"engineHealth\":1000.0,\"modExhaust\":-1,\"modOrnaments\":-1,\"color2Type\":6,\"modTrimB\":-1,\"modDashboard\":-1,\"windowTint\":3,\"modEngine\":3,\"modAirFilter\":-1,\"modTank\":-1,\"tyreSmokeColor\":[255,0,0],\"modHydrolic\":-1,\"modSeats\":-1,\"modSuspension\":3,\"extras\":{\"1\":1},\"color2Custom\":[187,187,187],\"plate\":\"RVX1207M\",\"modHood\":-1,\"modFrontWheels\":-1,\"modFrontBumper\":-1,\"model\":813738234,\"modArchCover\":-1,\"dirtLevel\":63.55696105957031,\"neonEnabled\":[1,1,1,1],\"modFrame\":-1,\"color1\":117,\"modSideSkirt\":-1}', 'RVX1207M', NULL, 'Vespucci Parking', 100, 1000, 1000, 0, 0, 26, NULL, 'out', '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":100}'),
(57, 'steam:110000147388a80', 'TUC83121', 'p90d', '-1672062838', '{\"modRearBumper\":-1,\"wheels\":0,\"neonColor\":[255,0,0],\"modDoorSpeaker\":-1,\"modFender\":-1,\"color2\":117,\"windowTint\":4,\"modFrontWheels\":-1,\"color1\":117,\"modWindows\":-1,\"modLivery\":-1,\"modTank\":-1,\"modTrunk\":-1,\"model\":-1672062838,\"modSideSkirt\":-1,\"modHorns\":25,\"pearlescentColor\":89,\"modTrimA\":-1,\"modSpoilers\":-1,\"engineHealth\":1000.0,\"plate\":\"83LST522\",\"livery\":-1,\"modXenon\":8,\"modBrakes\":2,\"fuelLevel\":0.0,\"modPlateHolder\":-1,\"plateIndex\":4,\"modSmokeEnabled\":1,\"modBackWheels\":-1,\"modDial\":-1,\"modVanityPlate\":-1,\"color2Custom\":[255,191,0],\"dirtLevel\":0.0,\"modHood\":-1,\"modSpeakers\":-1,\"modGrille\":-1,\"modDashboard\":-1,\"modAirFilter\":-1,\"modSteeringWheel\":-1,\"modFrontBumper\":-1,\"modOrnaments\":-1,\"modHydrolic\":-1,\"modEngine\":3,\"color2Type\":4,\"modArchCover\":-1,\"modRoof\":-1,\"modShifterLeavers\":-1,\"modArmor\":4,\"color1Custom\":[221,221,221],\"neonEnabled\":[1,1,1,1],\"modTurbo\":1,\"modSeats\":-1,\"modAerials\":-1,\"modFrame\":-1,\"modTrimB\":-1,\"modAPlate\":-1,\"modTransmission\":2,\"tyreSmokeColor\":[255,0,0],\"bodyHealth\":1000.0,\"modRightFender\":-1,\"color1Type\":4,\"modStruts\":-1,\"modExhaust\":-1,\"modEngineBlock\":-1,\"wheelColor\":30,\"extras\":{\"4\":1,\"5\":1,\"11\":1,\"7\":false,\"10\":1,\"1\":1,\"6\":1,\"3\":1},\"modSuspension\":3}', '83LST522', NULL, NULL, 100, 1000, 1000, 0, 0, 705200, NULL, NULL, NULL),
(58, 'steam:110000147388a80', 'TUC83121', 'skyline', NULL, '{\"modRearBumper\":-1,\"wheels\":0,\"neonColor\":[32,255,0],\"modDoorSpeaker\":-1,\"modFender\":-1,\"color2\":8,\"windowTint\":2,\"modFrontWheels\":-1,\"color1\":8,\"modWindows\":-1,\"modLivery\":-1,\"modTank\":-1,\"modTrunk\":-1,\"model\":2117711508,\"modSideSkirt\":-1,\"modHorns\":22,\"pearlescentColor\":134,\"modTrimA\":-1,\"modSpoilers\":0,\"engineHealth\":1000.0,\"plate\":\"OFY976SU\",\"livery\":-1,\"modXenon\":4,\"modBrakes\":2,\"fuelLevel\":53.23995590209961,\"modPlateHolder\":-1,\"plateIndex\":3,\"modSmokeEnabled\":1,\"modBackWheels\":-1,\"modDial\":-1,\"modVanityPlate\":-1,\"color2Custom\":[51,51,51],\"dirtLevel\":53.23995590209961,\"modHood\":-1,\"modSpeakers\":-1,\"modGrille\":-1,\"modDashboard\":-1,\"modAirFilter\":-1,\"modSteeringWheel\":-1,\"modFrontBumper\":1,\"modOrnaments\":-1,\"modHydrolic\":-1,\"modEngine\":3,\"color2Type\":6,\"modArchCover\":-1,\"modRoof\":-1,\"modShifterLeavers\":-1,\"modArmor\":4,\"color1Custom\":[51,51,51],\"neonEnabled\":[1,1,1,1],\"modTurbo\":1,\"modSeats\":-1,\"modAerials\":-1,\"modFrame\":-1,\"modTrimB\":-1,\"modAPlate\":-1,\"modTransmission\":2,\"tyreSmokeColor\":[231,141,88],\"bodyHealth\":1000.0,\"modRightFender\":-1,\"color1Type\":6,\"modStruts\":-1,\"modExhaust\":-1,\"modEngineBlock\":-1,\"wheelColor\":63,\"extras\":[],\"modSuspension\":3}', 'OFY976SU', NULL, 'Legion Parking', 100, 1000, 1000, 0, 0, 16591, NULL, NULL, '{\"Engine\":1000.0,\"Body\":1000.0,\"Fuel\":100.0}');

-- --------------------------------------------------------

--
-- Table structure for table `player_warns`
--

CREATE TABLE `player_warns` (
  `#` int(11) NOT NULL,
  `senderIdentifier` varchar(50) DEFAULT NULL,
  `targetIdentifier` varchar(50) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `warnId` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `queue`
--

CREATE TABLE `queue` (
  `id` int(11) NOT NULL,
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `priority` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `rc_cardelivery`
--

CREATE TABLE `rc_cardelivery` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `price` int(100) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `sprays`
--

CREATE TABLE `sprays` (
  `id` int(11) NOT NULL,
  `x` float(8,4) NOT NULL,
  `y` float(8,4) NOT NULL,
  `z` float(8,4) NOT NULL,
  `rx` float(8,4) NOT NULL,
  `ry` float(8,4) NOT NULL,
  `rz` float(8,4) NOT NULL,
  `scale` float(8,4) NOT NULL,
  `text` varchar(32) NOT NULL,
  `font` varchar(32) NOT NULL,
  `color` int(3) NOT NULL,
  `interior` int(3) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `stashitems`
--

CREATE TABLE `stashitems` (
  `id` int(11) NOT NULL,
  `stash` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text NOT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `stashitemsnew`
--

CREATE TABLE `stashitemsnew` (
  `id` int(11) NOT NULL,
  `stash` varchar(255) NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `stashitemsnew`
--

INSERT INTO `stashitemsnew` (`id`, `stash`, `items`) VALUES
(1, 'tas_29261', '[]'),
(2, 'apartment18376', '[{\"amount\":1,\"unique\":false,\"type\":\"item\",\"name\":\"electronickit\",\"useable\":true,\"image\":\"electronickit.png\",\"slot\":1,\"label\":\"Electronic Kit\",\"info\":[],\"weight\":100},{\"amount\":1,\"unique\":false,\"type\":\"item\",\"name\":\"c4\",\"useable\":true,\"image\":\"c4.png\",\"slot\":2,\"label\":\"c4\",\"info\":[],\"weight\":0},{\"amount\":1,\"unique\":false,\"type\":\"item\",\"name\":\"empty_weed_bag\",\"useable\":true,\"image\":\"weed-empty-bag.png\",\"slot\":3,\"label\":\"Empty Weed Bag\",\"info\":[],\"weight\":0},{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"key-b\",\"useable\":true,\"image\":\"key-b.png\",\"slot\":4,\"label\":\"Key B\",\"info\":[],\"weight\":1000},{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"key-c\",\"useable\":true,\"image\":\"key-c.png\",\"slot\":5,\"label\":\"Key C\",\"info\":[],\"weight\":1000},null,{\"amount\":2,\"unique\":false,\"type\":\"item\",\"name\":\"weed_bag\",\"useable\":true,\"image\":\"weed_bag.png\",\"slot\":7,\"label\":\"Weed bag\",\"info\":[],\"weight\":0},{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"key-a\",\"useable\":true,\"image\":\"key-a.png\",\"slot\":8,\"label\":\"Key A\",\"info\":[],\"weight\":1000},null,null,{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"markedbills\",\"useable\":false,\"image\":\"markedbills.png\",\"slot\":11,\"label\":\"Marked Money\",\"info\":{\"worth\":2623},\"weight\":1000},{\"amount\":5,\"unique\":false,\"type\":\"item\",\"name\":\"goldbar\",\"useable\":false,\"image\":\"goldbar.png\",\"slot\":12,\"label\":\"Gold Bar\",\"info\":\"\",\"weight\":7000},{\"amount\":8,\"unique\":false,\"type\":\"item\",\"name\":\"rolex\",\"useable\":false,\"image\":\"rolex_watch.png\",\"slot\":13,\"label\":\"Golden Watch\",\"info\":\"\",\"weight\":1500},{\"amount\":3,\"unique\":false,\"type\":\"item\",\"name\":\"diamond_ring\",\"useable\":false,\"image\":\"diamond_ring.png\",\"slot\":14,\"label\":\"Diamond Ring\",\"info\":\"\",\"weight\":1500},null,{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"markedbills\",\"useable\":false,\"image\":\"markedbills.png\",\"slot\":16,\"label\":\"Marked Money\",\"info\":{\"worth\":2414},\"weight\":1000},null,{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"radio\",\"useable\":true,\"image\":\"radio.png\",\"slot\":18,\"label\":\"Radio\",\"info\":[],\"weight\":2000},null,{\"amount\":7,\"unique\":false,\"type\":\"item\",\"name\":\"10kgoldchain\",\"useable\":false,\"image\":\"10kgoldchain.png\",\"slot\":20,\"label\":\"10k Gold Chain\",\"info\":\"\",\"weight\":2000},{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"markedbills\",\"useable\":false,\"image\":\"markedbills.png\",\"slot\":21,\"label\":\"Marked Money\",\"info\":{\"worth\":6152},\"weight\":1000},{\"amount\":3,\"unique\":false,\"type\":\"item\",\"name\":\"toolkit\",\"useable\":false,\"image\":\"toolkit.png\",\"slot\":22,\"label\":\"Toolkit\",\"info\":[],\"weight\":450},{\"amount\":1,\"unique\":true,\"type\":\"weapon\",\"name\":\"weapon_microsmg\",\"useable\":false,\"image\":\"microsmg.png\",\"slot\":23,\"label\":\"Micro SMG\",\"info\":{\"ammo\":192,\"quality\":90.39999999999964,\"attachments\":[{\"label\":\"Extended Clip\",\"component\":\"COMPONENT_MICROSMG_CLIP_02\"},{\"label\":\"Flashlight\",\"component\":\"COMPONENT_AT_PI_FLSH\"}],\"serie\":\"58ZQk7Im613qvoZ\"},\"weight\":2200},{\"amount\":5,\"unique\":false,\"type\":\"item\",\"name\":\"rolex\",\"useable\":false,\"image\":\"rolex_watch.png\",\"slot\":24,\"label\":\"Golden Watch\",\"info\":\"\",\"weight\":1500},null,null,{\"amount\":20,\"unique\":false,\"type\":\"item\",\"name\":\"bottle_acid\",\"useable\":true,\"image\":\"bottle_acid.png\",\"slot\":27,\"label\":\"Bottle Acid\",\"info\":[],\"weight\":0},{\"amount\":10,\"unique\":false,\"type\":\"item\",\"name\":\"empty_weed_bag\",\"useable\":true,\"image\":\"weed-empty-bag.png\",\"slot\":28,\"label\":\"Empty Weed Bag\",\"info\":[],\"weight\":0},{\"amount\":8,\"unique\":false,\"type\":\"item\",\"name\":\"hydrochloric_bottle\",\"useable\":true,\"image\":\"hydrochloric_bottle.png\",\"slot\":29,\"label\":\"hydrochloric_bottle\",\"info\":[],\"weight\":0},{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"markedbills\",\"useable\":false,\"image\":\"markedbills.png\",\"slot\":30,\"label\":\"Marked Money\",\"info\":{\"worth\":16444},\"weight\":1000},{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"markedbills\",\"useable\":false,\"image\":\"markedbills.png\",\"slot\":31,\"label\":\"Marked Money\",\"info\":{\"worth\":15805},\"weight\":1000},{\"amount\":2,\"unique\":false,\"type\":\"item\",\"name\":\"hydrochloric\",\"useable\":true,\"image\":\"hydrochloric.png\",\"slot\":32,\"label\":\"hydrochloric\",\"info\":\"\",\"weight\":0},{\"amount\":1,\"unique\":true,\"type\":\"item\",\"name\":\"markedbills\",\"useable\":false,\"image\":\"markedbills.png\",\"slot\":33,\"label\":\"Marked Money\",\"info\":{\"worth\":2622},\"weight\":1000},{\"amount\":1,\"unique\":false,\"type\":\"item\",\"name\":\"meth-ingredient-1\",\"useable\":false,\"image\":\"meth-ingredient-1.png\",\"slot\":34,\"label\":\"Meth Ingredient\",\"info\":[],\"weight\":2500},{\"amount\":10,\"unique\":false,\"type\":\"item\",\"name\":\"weed_nutrition\",\"useable\":true,\"image\":\"weed_nutrition.png\",\"slot\":35,\"label\":\"Plant Fertilizer\",\"info\":[],\"weight\":2000},{\"amount\":10,\"unique\":false,\"type\":\"item\",\"name\":\"empty_plastic_bag\",\"useable\":true,\"image\":\"empty-plastic-bag.png\",\"slot\":36,\"label\":\"Empty Ziploc baggies\",\"info\":[],\"weight\":100}]'),
(3, 'policestash_TUC83121', '[]'),
(4, 'apartment18271', '[]');

-- --------------------------------------------------------

--
-- Table structure for table `trunkitems`
--

CREATE TABLE `trunkitems` (
  `id` int(11) NOT NULL,
  `plate` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `info` text NOT NULL,
  `type` varchar(255) NOT NULL,
  `slot` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `trunkitemsnew`
--

CREATE TABLE `trunkitemsnew` (
  `id` int(11) NOT NULL,
  `plate` varchar(255) NOT NULL,
  `items` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `trunkitemsnew`
--

INSERT INTO `trunkitemsnew` (`id`, `plate`, `items`) VALUES
(1, '49HPH622', '[{\"name\":\"weapon_smg\",\"amount\":1,\"unique\":true,\"slot\":1,\"image\":\"WEAPON_SMG.png\",\"useable\":false,\"type\":\"weapon\",\"label\":\"SMG\",\"info\":{\"quality\":100.0,\"serie\":\"29yfQ6pL084QbXt\"},\"weight\":3000}]'),
(2, 'XZGK908O', '[]'),
(3, '89YYJ853', '[]');

-- --------------------------------------------------------

--
-- Table structure for table `user_convictions`
--

CREATE TABLE `user_convictions` (
  `id` int(11) NOT NULL,
  `char_id` varchar(48) DEFAULT NULL,
  `offense` varchar(255) DEFAULT NULL,
  `count` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `user_mdt`
--

CREATE TABLE `user_mdt` (
  `id` int(11) NOT NULL,
  `char_id` varchar(48) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `mugshot_url` varchar(255) DEFAULT NULL,
  `fingerprint` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `whitelist`
--

CREATE TABLE `whitelist` (
  `steam` varchar(255) NOT NULL,
  `license` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `apartments`
--
ALTER TABLE `apartments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `name` (`name`);

--
-- Indexes for table `api_tokens`
--
ALTER TABLE `api_tokens`
  ADD PRIMARY KEY (`token`);

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `steam` (`steam`),
  ADD KEY `license` (`license`),
  ADD KEY `discord` (`discord`),
  ADD KEY `ip` (`ip`);

--
-- Indexes for table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `crypto`
--
ALTER TABLE `crypto`
  ADD PRIMARY KEY (`#`);

--
-- Indexes for table `crypto_transactions`
--
ALTER TABLE `crypto_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `dealers`
--
ALTER TABLE `dealers`
  ADD PRIMARY KEY (`#`);

--
-- Indexes for table `dealership_balance`
--
ALTER TABLE `dealership_balance`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `dealership_hired_players`
--
ALTER TABLE `dealership_hired_players`
  ADD PRIMARY KEY (`dealership_id`,`user_id`) USING BTREE;

--
-- Indexes for table `dealership_owner`
--
ALTER TABLE `dealership_owner`
  ADD PRIMARY KEY (`dealership_id`) USING BTREE;

--
-- Indexes for table `dealership_requests`
--
ALTER TABLE `dealership_requests`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `request` (`user_id`,`vehicle`,`request_type`,`plate`) USING BTREE;

--
-- Indexes for table `dealership_stock`
--
ALTER TABLE `dealership_stock`
  ADD PRIMARY KEY (`vehicle`) USING BTREE;

--
-- Indexes for table `fine_types`
--
ALTER TABLE `fine_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gangs`
--
ALTER TABLE `gangs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gangs_members`
--
ALTER TABLE `gangs_members`
  ADD PRIMARY KEY (`index`) USING BTREE;

--
-- Indexes for table `gangs_money`
--
ALTER TABLE `gangs_money`
  ADD PRIMARY KEY (`index`) USING BTREE;

--
-- Indexes for table `gang_territoriums`
--
ALTER TABLE `gang_territoriums`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gas_station_balance`
--
ALTER TABLE `gas_station_balance`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `gas_station_business`
--
ALTER TABLE `gas_station_business`
  ADD PRIMARY KEY (`gas_station_id`) USING BTREE;

--
-- Indexes for table `gas_station_jobs`
--
ALTER TABLE `gas_station_jobs`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Indexes for table `gloveboxitems`
--
ALTER TABLE `gloveboxitems`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `gloveboxitemsnew`
--
ALTER TABLE `gloveboxitemsnew`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plate` (`plate`);

--
-- Indexes for table `houselocations`
--
ALTER TABLE `houselocations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `name` (`name`);

--
-- Indexes for table `house_plants`
--
ALTER TABLE `house_plants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `building` (`building`),
  ADD KEY `plantid` (`plantid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lapraces`
--
ALTER TABLE `lapraces`
  ADD PRIMARY KEY (`id`),
  ADD KEY `raceid` (`raceid`);

--
-- Indexes for table `mdt_reports`
--
ALTER TABLE `mdt_reports`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `mdt_warrants`
--
ALTER TABLE `mdt_warrants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `moneysafes`
--
ALTER TABLE `moneysafes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `nethush_cardelivery`
--
ALTER TABLE `nethush_cardelivery`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `occasion_vehicles`
--
ALTER TABLE `occasion_vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `occasionId` (`occasionid`);

--
-- Indexes for table `okokbanking_transactions`
--
ALTER TABLE `okokbanking_transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `steam` (`steam`);

--
-- Indexes for table `phone_invoices`
--
ALTER TABLE `phone_invoices`
  ADD PRIMARY KEY (`#`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `phone_messages`
--
ALTER TABLE `phone_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `number` (`number`);

--
-- Indexes for table `phone_tweets`
--
ALTER TABLE `phone_tweets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `playerammo`
--
ALTER TABLE `playerammo`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `playeritems`
--
ALTER TABLE `playeritems`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`#`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `last_updated` (`last_updated`),
  ADD KEY `steam` (`steam`);

--
-- Indexes for table `playerskins`
--
ALTER TABLE `playerskins`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `active` (`active`);

--
-- Indexes for table `player_boats`
--
ALTER TABLE `player_boats`
  ADD PRIMARY KEY (`#`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `player_contacts`
--
ALTER TABLE `player_contacts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `player_houses`
--
ALTER TABLE `player_houses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `house` (`house`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `identifier` (`identifier`);

--
-- Indexes for table `player_mails`
--
ALTER TABLE `player_mails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`);

--
-- Indexes for table `player_outfits`
--
ALTER TABLE `player_outfits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `outfitId` (`outfitId`);

--
-- Indexes for table `player_vehicles`
--
ALTER TABLE `player_vehicles`
  ADD PRIMARY KEY (`#`),
  ADD KEY `plate` (`plate`),
  ADD KEY `citizenid` (`citizenid`),
  ADD KEY `steam` (`steam`);

--
-- Indexes for table `player_warns`
--
ALTER TABLE `player_warns`
  ADD PRIMARY KEY (`#`);

--
-- Indexes for table `queue`
--
ALTER TABLE `queue`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rc_cardelivery`
--
ALTER TABLE `rc_cardelivery`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `sprays`
--
ALTER TABLE `sprays`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stashitems`
--
ALTER TABLE `stashitems`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stashitemsnew`
--
ALTER TABLE `stashitemsnew`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stash` (`stash`);

--
-- Indexes for table `trunkitems`
--
ALTER TABLE `trunkitems`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `trunkitemsnew`
--
ALTER TABLE `trunkitemsnew`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plate` (`plate`);

--
-- Indexes for table `user_convictions`
--
ALTER TABLE `user_convictions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_mdt`
--
ALTER TABLE `user_mdt`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `whitelist`
--
ALTER TABLE `whitelist`
  ADD PRIMARY KEY (`steam`),
  ADD UNIQUE KEY `identifier` (`license`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `apartments`
--
ALTER TABLE `apartments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `billing`
--
ALTER TABLE `billing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crypto`
--
ALTER TABLE `crypto`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `crypto_transactions`
--
ALTER TABLE `crypto_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dealers`
--
ALTER TABLE `dealers`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `dealership_balance`
--
ALTER TABLE `dealership_balance`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `dealership_requests`
--
ALTER TABLE `dealership_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `gangs`
--
ALTER TABLE `gangs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gangs_members`
--
ALTER TABLE `gangs_members`
  MODIFY `index` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gangs_money`
--
ALTER TABLE `gangs_money`
  MODIFY `index` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gang_territoriums`
--
ALTER TABLE `gang_territoriums`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gas_station_balance`
--
ALTER TABLE `gas_station_balance`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `gas_station_jobs`
--
ALTER TABLE `gas_station_jobs`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gloveboxitems`
--
ALTER TABLE `gloveboxitems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `gloveboxitemsnew`
--
ALTER TABLE `gloveboxitemsnew`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `houselocations`
--
ALTER TABLE `houselocations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `house_plants`
--
ALTER TABLE `house_plants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lapraces`
--
ALTER TABLE `lapraces`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mdt_reports`
--
ALTER TABLE `mdt_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `mdt_warrants`
--
ALTER TABLE `mdt_warrants`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `moneysafes`
--
ALTER TABLE `moneysafes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `nethush_cardelivery`
--
ALTER TABLE `nethush_cardelivery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `occasion_vehicles`
--
ALTER TABLE `occasion_vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `okokbanking_transactions`
--
ALTER TABLE `okokbanking_transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `phone_invoices`
--
ALTER TABLE `phone_invoices`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `phone_messages`
--
ALTER TABLE `phone_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `phone_tweets`
--
ALTER TABLE `phone_tweets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `playerammo`
--
ALTER TABLE `playerammo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `playeritems`
--
ALTER TABLE `playeritems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `players`
--
ALTER TABLE `players`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `playerskins`
--
ALTER TABLE `playerskins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `player_boats`
--
ALTER TABLE `player_boats`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_contacts`
--
ALTER TABLE `player_contacts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_houses`
--
ALTER TABLE `player_houses`
  MODIFY `id` int(255) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_mails`
--
ALTER TABLE `player_mails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `player_outfits`
--
ALTER TABLE `player_outfits`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `player_vehicles`
--
ALTER TABLE `player_vehicles`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `player_warns`
--
ALTER TABLE `player_warns`
  MODIFY `#` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `queue`
--
ALTER TABLE `queue`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rc_cardelivery`
--
ALTER TABLE `rc_cardelivery`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `sprays`
--
ALTER TABLE `sprays`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stashitems`
--
ALTER TABLE `stashitems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stashitemsnew`
--
ALTER TABLE `stashitemsnew`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `trunkitems`
--
ALTER TABLE `trunkitems`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `trunkitemsnew`
--
ALTER TABLE `trunkitemsnew`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `user_convictions`
--
ALTER TABLE `user_convictions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_mdt`
--
ALTER TABLE `user_mdt`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
