-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 02, 2025 at 08:11 AM
-- Server version: 10.11.10-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u248812433_appointment`
--

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `country_id` int(10) UNSIGNED DEFAULT NULL,
  `house_no` text DEFAULT NULL,
  `address_line` longtext DEFAULT NULL,
  `city` text DEFAULT NULL,
  `state` text DEFAULT NULL,
  `pin_code` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `user_id`, `country_id`, `house_no`, `address_line`, `city`, `state`, `pin_code`, `created_at`, `updated_at`) VALUES
(1, 1, 13, '44', 'sdfs', 'sdf', 'sdfs', 342342, '2025-04-16 05:53:14', '2025-05-01 21:56:53'),
(3, 3, 13, '17', 'Adarsh Nagar', 'Wollongong', 'Adarsh Nagar', 2563, '2025-04-23 09:23:47', '2025-04-23 09:23:47'),
(4, 4, NULL, '45', 'welcome street', 'sydney', 'welcome street', 11220, '2025-04-23 09:28:12', '2025-04-23 09:29:48'),
(5, 5, 13, '45', 'main', 'Sydney', 'main', 11220, '2025-04-23 09:37:17', '2025-04-23 09:46:56');

-- --------------------------------------------------------

--
-- Table structure for table `advertisement_banners`
--

CREATE TABLE `advertisement_banners` (
  `id` int(10) UNSIGNED NOT NULL,
  `position` varchar(191) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `status` enum('active','inactive','expire') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `start_date_time` datetime DEFAULT NULL,
  `end_date_time` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `advertisement_banners`
--

INSERT INTO `advertisement_banners` (`id`, `position`, `image`, `status`, `created_at`, `updated_at`, `start_date_time`, `end_date_time`) VALUES
(1, 'after categories', '7f0992e3f0806cd7847241159d1aa160.png', 'active', '2025-04-16 22:34:57', '2025-04-16 22:35:55', '2025-04-16 18:00:00', '2025-04-30 13:59:00'),
(2, 'after categories', '689ac81d50bed3d67e24488ef7a208b7.png', 'active', '2025-04-16 22:36:39', '2025-04-16 22:36:39', '2025-04-16 18:00:00', '2025-04-30 13:59:00');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` int(10) UNSIGNED NOT NULL,
  `deal_id` int(10) UNSIGNED DEFAULT NULL,
  `deal_quantity` double DEFAULT NULL,
  `coupon_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `date_time` datetime NOT NULL,
  `status` enum('pending','approved','in progress','completed','canceled') NOT NULL DEFAULT 'pending',
  `booking_type` enum('online','offline') NOT NULL DEFAULT 'offline',
  `payment_gateway` varchar(191) NOT NULL,
  `original_amount` double(8,2) NOT NULL,
  `product_amount` double(8,2) DEFAULT NULL,
  `discount` double(8,2) NOT NULL,
  `coupon_discount` double DEFAULT NULL,
  `discount_percent` double NOT NULL,
  `tax_name` varchar(191) DEFAULT NULL,
  `tax_percent` double(8,2) DEFAULT NULL,
  `tax_amount` double(8,2) DEFAULT NULL,
  `amount_to_pay` double(8,2) NOT NULL,
  `payment_status` enum('pending','completed','partial_payment') DEFAULT NULL,
  `source` varchar(191) NOT NULL DEFAULT 'pos',
  `additional_notes` text DEFAULT NULL,
  `notify_at` timestamp NULL DEFAULT NULL,
  `event_id` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `bookings`
--

INSERT INTO `bookings` (`id`, `deal_id`, `deal_quantity`, `coupon_id`, `user_id`, `date_time`, `status`, `booking_type`, `payment_gateway`, `original_amount`, `product_amount`, `discount`, `coupon_discount`, `discount_percent`, `tax_name`, `tax_percent`, `tax_amount`, `amount_to_pay`, `payment_status`, `source`, `additional_notes`, `notify_at`, `event_id`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, 1, 3, '2025-04-25 04:00:00', 'pending', 'offline', 'cash', 70.00, NULL, 0.00, 10, 0, '[null]', 18.00, 12.60, 72.60, 'pending', 'online', 'patch issue', NULL, NULL, '2025-04-23 09:23:48', '2025-04-23 09:23:48'),
(3, NULL, NULL, NULL, 5, '2025-04-24 05:30:00', 'completed', 'offline', 'cash', 70.00, 0.00, 0.00, NULL, 0, '[null]', 18.00, 12.60, 82.60, 'completed', 'online', NULL, NULL, NULL, '2025-04-23 09:46:56', '2025-04-23 10:09:46'),
(4, NULL, NULL, NULL, 1, '2025-05-08 02:30:00', 'pending', 'offline', 'cash', 70.00, NULL, 0.00, NULL, 0, '[null]', 18.00, 12.60, 82.60, 'pending', 'online', 'sdfzsd fdsf sdf', NULL, NULL, '2025-05-01 21:56:53', '2025-05-01 21:56:53');

-- --------------------------------------------------------

--
-- Table structure for table `booking_items`
--

CREATE TABLE `booking_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `booking_id` int(10) UNSIGNED NOT NULL,
  `business_service_id` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `quantity` tinyint(4) NOT NULL,
  `unit_price` double NOT NULL,
  `amount` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `booking_items`
--

INSERT INTO `booking_items` (`id`, `booking_id`, `business_service_id`, `product_id`, `quantity`, `unit_price`, `amount`, `created_at`, `updated_at`) VALUES
(5, 3, 5, NULL, 1, 70, 70, NULL, NULL),
(6, 4, 5, NULL, 1, 70, 70, '2025-05-01 21:56:53', '2025-05-01 21:56:53');

-- --------------------------------------------------------

--
-- Table structure for table `booking_notifactions`
--

CREATE TABLE `booking_notifactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `duration` int(11) NOT NULL DEFAULT 1,
  `duration_type` enum('minutes','hours','days','weeks') NOT NULL DEFAULT 'minutes',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_times`
--

CREATE TABLE `booking_times` (
  `id` int(10) UNSIGNED NOT NULL,
  `location_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `day` varchar(191) NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `multiple_booking` enum('yes','no') NOT NULL DEFAULT 'yes',
  `max_booking` int(11) NOT NULL DEFAULT 0,
  `max_booking_per_day` int(11) NOT NULL,
  `max_booking_per_slot` int(11) NOT NULL,
  `status` enum('enabled','disabled') NOT NULL DEFAULT 'enabled',
  `slot_duration` int(11) NOT NULL DEFAULT 30,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `booking_times`
--

INSERT INTO `booking_times` (`id`, `location_id`, `day`, `start_time`, `end_time`, `multiple_booking`, `max_booking`, `max_booking_per_day`, `max_booking_per_slot`, `status`, `slot_duration`, `created_at`, `updated_at`) VALUES
(22, 2, 'monday', '23:00:00', '08:00:00', 'yes', 0, 0, 0, 'enabled', 30, NULL, NULL),
(23, 2, 'tuesday', '23:00:00', '08:00:00', 'yes', 0, 0, 0, 'enabled', 30, NULL, NULL),
(24, 2, 'wednesday', '23:00:00', '08:00:00', 'yes', 0, 0, 0, 'enabled', 30, NULL, NULL),
(25, 2, 'thursday', '23:00:00', '08:00:00', 'yes', 0, 0, 0, 'enabled', 30, NULL, NULL),
(26, 2, 'friday', '23:00:00', '08:00:00', 'yes', 0, 0, 0, 'enabled', 30, NULL, NULL),
(27, 2, 'saturday', '23:00:00', '08:00:00', 'yes', 0, 0, 0, 'enabled', 30, NULL, NULL),
(28, 2, 'sunday', '23:00:00', '08:00:00', 'yes', 0, 0, 0, 'enabled', 30, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `booking_user`
--

CREATE TABLE `booking_user` (
  `booking_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `booking_user`
--

INSERT INTO `booking_user` (`booking_id`, `user_id`) VALUES
(3, 4),
(4, 4);

-- --------------------------------------------------------

--
-- Table structure for table `business_services`
--

CREATE TABLE `business_services` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) DEFAULT NULL,
  `description` text NOT NULL,
  `price` double(8,2) NOT NULL,
  `time` double(8,2) NOT NULL,
  `time_type` varchar(191) NOT NULL,
  `discount` double(8,2) NOT NULL,
  `discount_type` enum('percent','fixed') NOT NULL,
  `category_id` int(10) UNSIGNED DEFAULT NULL,
  `location_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `image` text DEFAULT NULL,
  `default_image` varchar(191) DEFAULT NULL,
  `status` enum('active','deactive') NOT NULL DEFAULT 'active',
  `service_type` enum('online','offline') NOT NULL DEFAULT 'offline',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `business_services`
--

INSERT INTO `business_services` (`id`, `name`, `slug`, `description`, `price`, `time`, `time_type`, `discount`, `discount_type`, `category_id`, `location_id`, `image`, `default_image`, `status`, `service_type`, `created_at`, `updated_at`) VALUES
(5, 'Initial Consultation', 'initial-consultation', '<p>Initial consultation</p>', 70.00, 30.00, 'minutes', 0.00, 'percent', 6, 2, NULL, NULL, 'active', 'offline', '2025-04-16 23:39:03', '2025-04-16 23:54:04'),
(6, 'Initial Consultation', 'initial-consultation-gm', '<p>Initial Consultation</p>', 300.00, 15.00, 'minutes', 10.00, 'percent', 3, 2, NULL, NULL, 'active', 'offline', '2025-04-16 23:52:25', '2025-04-16 23:54:42'),
(7, 'Initial Consultation', 'initial-consultation-dental', '<p>initial consultation</p>', 100.00, 60.00, 'minutes', 0.00, 'percent', 9, 2, NULL, NULL, 'active', 'offline', '2025-04-17 00:24:04', '2025-04-17 00:24:04');

-- --------------------------------------------------------

--
-- Table structure for table `business_service_user`
--

CREATE TABLE `business_service_user` (
  `business_service_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `business_service_user`
--

INSERT INTO `business_service_user` (`business_service_id`, `user_id`) VALUES
(5, 4),
(6, 4),
(7, 4);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `slug` varchar(191) DEFAULT NULL,
  `image` varchar(191) DEFAULT NULL,
  `status` enum('active','deactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `slug`, `image`, `status`, `created_at`, `updated_at`) VALUES
(3, 'General Medicine', 'general-medicine', NULL, 'active', '2025-04-16 23:27:56', '2025-04-16 23:27:56'),
(4, 'Ayurvedic', 'ayurvedic', NULL, 'active', '2025-04-16 23:36:47', '2025-04-16 23:36:47'),
(5, 'Physiotherapy', 'physiotherapy', NULL, 'active', '2025-04-16 23:37:08', '2025-04-16 23:37:08'),
(6, 'Chiropracter', 'chiropracter', NULL, 'active', '2025-04-16 23:37:33', '2025-04-16 23:37:33'),
(7, 'Optomologist', 'optomologist', NULL, 'active', '2025-04-16 23:38:49', '2025-04-16 23:38:49'),
(8, 'Nutritionist Consultant', 'nutritionist-consultant', NULL, 'active', '2025-04-16 23:39:05', '2025-04-16 23:39:05'),
(9, 'Dental Care', 'dental-care', NULL, 'active', '2025-04-16 23:50:34', '2025-04-16 23:50:34'),
(10, 'Wellness & Fitness', 'wellness-&-fitness', NULL, 'active', '2025-04-16 23:50:49', '2025-04-16 23:50:49');

-- --------------------------------------------------------

--
-- Table structure for table `company_settings`
--

CREATE TABLE `company_settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `company_name` varchar(191) NOT NULL,
  `company_email` varchar(191) NOT NULL,
  `company_phone` varchar(191) NOT NULL,
  `logo` varchar(191) DEFAULT NULL,
  `address` text NOT NULL,
  `date_format` varchar(191) NOT NULL DEFAULT 'Y-m-d',
  `time_format` varchar(191) NOT NULL DEFAULT 'h:i A',
  `website` varchar(191) NOT NULL,
  `timezone` varchar(191) NOT NULL,
  `locale` varchar(191) NOT NULL,
  `latitude` decimal(10,8) NOT NULL,
  `longitude` decimal(11,8) NOT NULL,
  `currency_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `purchase_code` varchar(100) DEFAULT NULL,
  `supported_until` timestamp NULL DEFAULT NULL,
  `multi_task_user` varchar(191) DEFAULT NULL,
  `booking_per_day` varchar(191) DEFAULT NULL,
  `employee_selection` enum('enabled','disabled') NOT NULL DEFAULT 'disabled',
  `disable_slot` enum('enabled','disabled') NOT NULL DEFAULT 'disabled',
  `booking_time_type` enum('sum','avg','max','min') NOT NULL,
  `get_started_title` text DEFAULT NULL,
  `get_started_note` text DEFAULT NULL,
  `cron_status` enum('active','deactive') NOT NULL DEFAULT 'deactive',
  `hide_cron_message` tinyint(1) NOT NULL DEFAULT 0,
  `last_cron_run` timestamp NOT NULL DEFAULT current_timestamp(),
  `duration` int(11) NOT NULL DEFAULT 1,
  `duration_type` enum('minutes','hours','days','weeks') NOT NULL DEFAULT 'minutes',
  `google_calendar` enum('active','deactive') NOT NULL DEFAULT 'deactive',
  `google_client_id` text DEFAULT NULL,
  `google_client_secret` text DEFAULT NULL,
  `google_id` varchar(191) DEFAULT NULL,
  `name` varchar(191) DEFAULT NULL,
  `token` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `company_settings`
--

INSERT INTO `company_settings` (`id`, `company_name`, `company_email`, `company_phone`, `logo`, `address`, `date_format`, `time_format`, `website`, `timezone`, `locale`, `latitude`, `longitude`, `currency_id`, `created_at`, `updated_at`, `purchase_code`, `supported_until`, `multi_task_user`, `booking_per_day`, `employee_selection`, `disable_slot`, `booking_time_type`, `get_started_title`, `get_started_note`, `cron_status`, `hide_cron_message`, `last_cron_run`, `duration`, `duration_type`, `google_calendar`, `google_client_id`, `google_client_secret`, `google_id`, `name`, `token`) VALUES
(1, 'SchedMate', 'company@example.com', '1234512345', '9780bf2313df2476008f93412356b458.png', 'Welcome Zone, Sydney, India', 'Y-m-d', 'h:i A', 'https://azure-zebra-384245.hostingersite.com/', 'Australia/Sydney', 'en', 26.91243360, 75.78727090, 1, NULL, '2025-04-23 10:17:33', NULL, NULL, NULL, '0', '', '', 'sum', 'This is Twest', 'Welcome to this section, Welcome to this sectionWelcome to this sectionWelcome to this sectionWelcome to this sectionWelcome to this section', 'deactive', 0, '2025-04-14 14:06:54', 1, 'minutes', 'deactive', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` int(10) UNSIGNED NOT NULL,
  `iso` char(2) NOT NULL,
  `name` varchar(80) NOT NULL,
  `nicename` varchar(80) NOT NULL,
  `iso3` char(3) DEFAULT NULL,
  `numcode` smallint(6) DEFAULT NULL,
  `phonecode` int(11) NOT NULL,
  `capital` varchar(191) DEFAULT NULL COMMENT 'Country capital',
  `currency` varchar(191) DEFAULT NULL COMMENT 'Country currency Code',
  `currency_symbol` varchar(191) DEFAULT NULL COMMENT 'Country currency Symbol',
  `currency_value` double(8,2) DEFAULT 0.00 COMMENT 'Base currency value in USD',
  `tld` varchar(191) DEFAULT NULL COMMENT 'Country top level domain',
  `native_name` varchar(191) DEFAULT NULL COMMENT 'Native name of the country',
  `region` varchar(191) DEFAULT NULL,
  `subregion` varchar(191) DEFAULT NULL,
  `latitude` varchar(191) DEFAULT NULL,
  `longitude` varchar(191) DEFAULT NULL,
  `emojiU` varchar(191) DEFAULT NULL COMMENT 'Emoji unicode',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `iso`, `name`, `nicename`, `iso3`, `numcode`, `phonecode`, `capital`, `currency`, `currency_symbol`, `currency_value`, `tld`, `native_name`, `region`, `subregion`, `latitude`, `longitude`, `emojiU`, `created_at`, `updated_at`) VALUES
(1, 'AF', 'AFGHANISTAN', 'Afghanistan', 'AFG', 4, 93, 'Kabul', 'AFN', '؋', 0.00, '.af', 'افغانستان', 'Asia', 'Southern Asia', '33.00000000', '65.00000000', 'U+1F1E6 U+1F1EB', NULL, '2025-04-14 14:06:55'),
(2, 'AL', 'ALBANIA', 'Albania', 'ALB', 8, 355, 'Tirana', 'ALL', 'Lek', 0.00, '.al', 'Shqipëria', 'Europe', 'Southern Europe', '41.00000000', '20.00000000', 'U+1F1E6 U+1F1F1', NULL, '2025-04-14 14:06:55'),
(3, 'DZ', 'ALGERIA', 'Algeria', 'DZA', 12, 213, 'Algiers', 'DZD', 'دج', 0.00, '.dz', 'الجزائر', 'Africa', 'Northern Africa', '28.00000000', '3.00000000', 'U+1F1E9 U+1F1FF', NULL, '2025-04-14 14:06:55'),
(4, 'AS', 'AMERICAN SAMOA', 'American Samoa', 'ASM', 16, 1684, 'Pago Pago', 'USD', '$', 0.00, '.as', 'American Samoa', 'Oceania', 'Polynesia', '-14.33333333', '-170.00000000', 'U+1F1E6 U+1F1F8', NULL, '2025-04-14 14:06:55'),
(5, 'AD', 'ANDORRA', 'Andorra', 'AND', 20, 376, 'Andorra la Vella', 'EUR', '€', 0.00, '.ad', 'Andorra', 'Europe', 'Southern Europe', '42.50000000', '1.50000000', 'U+1F1E6 U+1F1E9', NULL, '2025-04-14 14:06:55'),
(6, 'AO', 'ANGOLA', 'Angola', 'AGO', 24, 244, 'Luanda', 'AOA', 'Kz', 0.00, '.ao', 'Angola', 'Africa', 'Middle Africa', '-12.50000000', '18.50000000', 'U+1F1E6 U+1F1F4', NULL, '2025-04-14 14:06:55'),
(7, 'AI', 'ANGUILLA', 'Anguilla', 'AIA', 660, 1264, 'The Valley', 'XCD', '$', 0.00, '.ai', 'Anguilla', 'Americas', 'Caribbean', '18.25000000', '-63.16666666', 'U+1F1E6 U+1F1EE', NULL, '2025-04-14 14:06:55'),
(8, 'AQ', 'ANTARCTICA', 'Antarctica', NULL, NULL, 0, '', 'AAD', '$', 0.00, '.aq', 'Antarctica', 'Polar', '', '-74.65000000', '4.48000000', 'U+1F1E6 U+1F1F6', NULL, '2025-04-14 14:06:55'),
(9, 'AG', 'ANTIGUA AND BARBUDA', 'Antigua and Barbuda', 'ATG', 28, 1268, 'St. John\'s', 'XCD', '$', 0.00, '.ag', 'Antigua and Barbuda', 'Americas', 'Caribbean', '17.05000000', '-61.80000000', 'U+1F1E6 U+1F1EC', NULL, '2025-04-14 14:06:55'),
(10, 'AR', 'ARGENTINA', 'Argentina', 'ARG', 32, 54, 'Buenos Aires', 'ARS', '$', 0.00, '.ar', 'Argentina', 'Americas', 'South America', '-34.00000000', '-64.00000000', 'U+1F1E6 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(11, 'AM', 'ARMENIA', 'Armenia', 'ARM', 51, 374, 'Yerevan', 'AMD', '֏', 0.00, '.am', 'Հայաստան', 'Asia', 'Western Asia', '40.00000000', '45.00000000', 'U+1F1E6 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(12, 'AW', 'ARUBA', 'Aruba', 'ABW', 533, 297, 'Oranjestad', 'AWG', 'ƒ', 0.00, '.aw', 'Aruba', 'Americas', 'Caribbean', '12.50000000', '-69.96666666', 'U+1F1E6 U+1F1FC', NULL, '2025-04-14 14:06:55'),
(13, 'AU', 'AUSTRALIA', 'Australia', 'AUS', 36, 61, 'Canberra', 'AUD', '$', 0.00, '.au', 'Australia', 'Oceania', 'Australia and New Zealand', '-27.00000000', '133.00000000', 'U+1F1E6 U+1F1FA', NULL, '2025-04-14 14:06:55'),
(14, 'AT', 'AUSTRIA', 'Austria', 'AUT', 40, 43, 'Vienna', 'EUR', '€', 0.00, '.at', 'Österreich', 'Europe', 'Western Europe', '47.33333333', '13.33333333', 'U+1F1E6 U+1F1F9', NULL, '2025-04-14 14:06:55'),
(15, 'AZ', 'AZERBAIJAN', 'Azerbaijan', 'AZE', 31, 994, 'Baku', 'AZN', 'm', 0.00, '.az', 'Azərbaycan', 'Asia', 'Western Asia', '40.50000000', '47.50000000', 'U+1F1E6 U+1F1FF', NULL, '2025-04-14 14:06:55'),
(16, 'BS', 'BAHAMAS', 'Bahamas', 'BHS', 44, 1242, 'Nassau', 'BSD', 'B$', 0.00, '.bs', 'Bahamas', 'Americas', 'Caribbean', '24.25000000', '-76.00000000', 'U+1F1E7 U+1F1F8', NULL, '2025-04-14 14:06:55'),
(17, 'BH', 'BAHRAIN', 'Bahrain', 'BHR', 48, 973, 'Manama', 'BHD', '.د.ب', 0.00, '.bh', '‏البحرين', 'Asia', 'Western Asia', '26.00000000', '50.55000000', 'U+1F1E7 U+1F1ED', NULL, '2025-04-14 14:06:55'),
(18, 'BD', 'BANGLADESH', 'Bangladesh', 'BGD', 50, 880, 'Dhaka', 'BDT', '৳', 0.00, '.bd', 'Bangladesh', 'Asia', 'Southern Asia', '24.00000000', '90.00000000', 'U+1F1E7 U+1F1E9', NULL, '2025-04-14 14:06:55'),
(19, 'BB', 'BARBADOS', 'Barbados', 'BRB', 52, 1246, 'Bridgetown', 'BBD', 'Bds$', 0.00, '.bb', 'Barbados', 'Americas', 'Caribbean', '13.16666666', '-59.53333333', 'U+1F1E7 U+1F1E7', NULL, '2025-04-14 14:06:55'),
(20, 'BY', 'BELARUS', 'Belarus', 'BLR', 112, 375, 'Minsk', 'BYN', 'Br', 0.00, '.by', 'Белару́сь', 'Europe', 'Eastern Europe', '53.00000000', '28.00000000', 'U+1F1E7 U+1F1FE', NULL, '2025-04-14 14:06:55'),
(21, 'BE', 'BELGIUM', 'Belgium', 'BEL', 56, 32, 'Brussels', 'EUR', '€', 0.00, '.be', 'België', 'Europe', 'Western Europe', '50.83333333', '4.00000000', 'U+1F1E7 U+1F1EA', NULL, '2025-04-14 14:06:55'),
(22, 'BZ', 'BELIZE', 'Belize', 'BLZ', 84, 501, 'Belmopan', 'BZD', '$', 0.00, '.bz', 'Belize', 'Americas', 'Central America', '17.25000000', '-88.75000000', 'U+1F1E7 U+1F1FF', NULL, '2025-04-14 14:06:55'),
(23, 'BJ', 'BENIN', 'Benin', 'BEN', 204, 229, 'Porto-Novo', 'XOF', 'CFA', 0.00, '.bj', 'Bénin', 'Africa', 'Western Africa', '9.50000000', '2.25000000', 'U+1F1E7 U+1F1EF', NULL, '2025-04-14 14:06:55'),
(24, 'BM', 'BERMUDA', 'Bermuda', 'BMU', 60, 1441, 'Hamilton', 'BMD', '$', 0.00, '.bm', 'Bermuda', 'Americas', 'Northern America', '32.33333333', '-64.75000000', 'U+1F1E7 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(25, 'BT', 'BHUTAN', 'Bhutan', 'BTN', 64, 975, 'Thimphu', 'BTN', 'Nu.', 0.00, '.bt', 'ʼbrug-yul', 'Asia', 'Southern Asia', '27.50000000', '90.50000000', 'U+1F1E7 U+1F1F9', NULL, '2025-04-14 14:06:55'),
(26, 'BO', 'BOLIVIA', 'Bolivia', 'BOL', 68, 591, 'Sucre', 'BOB', 'Bs.', 0.00, '.bo', 'Bolivia', 'Americas', 'South America', '-17.00000000', '-65.00000000', 'U+1F1E7 U+1F1F4', NULL, '2025-04-14 14:06:55'),
(27, 'BA', 'BOSNIA AND HERZEGOVINA', 'Bosnia and Herzegovina', 'BIH', 70, 387, 'Sarajevo', 'BAM', 'KM', 0.00, '.ba', 'Bosna i Hercegovina', 'Europe', 'Southern Europe', '44.00000000', '18.00000000', 'U+1F1E7 U+1F1E6', NULL, '2025-04-14 14:06:55'),
(28, 'BW', 'BOTSWANA', 'Botswana', 'BWA', 72, 267, 'Gaborone', 'BWP', 'P', 0.00, '.bw', 'Botswana', 'Africa', 'Southern Africa', '-22.00000000', '24.00000000', 'U+1F1E7 U+1F1FC', NULL, '2025-04-14 14:06:55'),
(29, 'BV', 'BOUVET ISLAND', 'Bouvet Island', NULL, NULL, 0, '', 'NOK', 'kr', 0.00, '.bv', 'Bouvetøya', '', '', '-54.43333333', '3.40000000', 'U+1F1E7 U+1F1FB', NULL, '2025-04-14 14:06:55'),
(30, 'BR', 'BRAZIL', 'Brazil', 'BRA', 76, 55, 'Brasilia', 'BRL', 'R$', 0.00, '.br', 'Brasil', 'Americas', 'South America', '-10.00000000', '-55.00000000', 'U+1F1E7 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(31, 'IO', 'BRITISH INDIAN OCEAN TERRITORY', 'British Indian Ocean Territory', NULL, NULL, 246, 'Diego Garcia', 'USD', '$', 0.00, '.io', 'British Indian Ocean Territory', 'Africa', 'Eastern Africa', '-6.00000000', '71.50000000', 'U+1F1EE U+1F1F4', NULL, '2025-04-14 14:06:55'),
(32, 'BN', 'BRUNEI DARUSSALAM', 'Brunei Darussalam', 'BRN', 96, 673, 'Bandar Seri Begawan', 'BND', 'B$', 0.00, '.bn', 'Negara Brunei Darussalam', 'Asia', 'South-Eastern Asia', '4.50000000', '114.66666666', 'U+1F1E7 U+1F1F3', NULL, '2025-04-14 14:06:55'),
(33, 'BG', 'BULGARIA', 'Bulgaria', 'BGR', 100, 359, 'Sofia', 'BGN', 'Лв.', 0.00, '.bg', 'България', 'Europe', 'Eastern Europe', '43.00000000', '25.00000000', 'U+1F1E7 U+1F1EC', NULL, '2025-04-14 14:06:55'),
(34, 'BF', 'BURKINA FASO', 'Burkina Faso', 'BFA', 854, 226, 'Ouagadougou', 'XOF', 'CFA', 0.00, '.bf', 'Burkina Faso', 'Africa', 'Western Africa', '13.00000000', '-2.00000000', 'U+1F1E7 U+1F1EB', NULL, '2025-04-14 14:06:55'),
(35, 'BI', 'BURUNDI', 'Burundi', 'BDI', 108, 257, 'Bujumbura', 'BIF', 'FBu', 0.00, '.bi', 'Burundi', 'Africa', 'Eastern Africa', '-3.50000000', '30.00000000', 'U+1F1E7 U+1F1EE', NULL, '2025-04-14 14:06:55'),
(36, 'KH', 'CAMBODIA', 'Cambodia', 'KHM', 116, 855, 'Phnom Penh', 'KHR', 'KHR', 0.00, '.kh', 'Kâmpŭchéa', 'Asia', 'South-Eastern Asia', '13.00000000', '105.00000000', 'U+1F1F0 U+1F1ED', NULL, '2025-04-14 14:06:55'),
(37, 'CM', 'CAMEROON', 'Cameroon', 'CMR', 120, 237, 'Yaounde', 'XAF', 'FCFA', 0.00, '.cm', 'Cameroon', 'Africa', 'Middle Africa', '6.00000000', '12.00000000', 'U+1F1E8 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(38, 'CA', 'CANADA', 'Canada', 'CAN', 124, 1, 'Ottawa', 'CAD', '$', 0.00, '.ca', 'Canada', 'Americas', 'Northern America', '60.00000000', '-95.00000000', 'U+1F1E8 U+1F1E6', NULL, '2025-04-14 14:06:55'),
(39, 'CV', 'CAPE VERDE', 'Cape Verde', 'CPV', 132, 238, 'Praia', 'CVE', '$', 0.00, '.cv', 'Cabo Verde', 'Africa', 'Western Africa', '16.00000000', '-24.00000000', 'U+1F1E8 U+1F1FB', NULL, '2025-04-14 14:06:55'),
(40, 'KY', 'CAYMAN ISLANDS', 'Cayman Islands', 'CYM', 136, 1345, 'George Town', 'KYD', '$', 0.00, '.ky', 'Cayman Islands', 'Americas', 'Caribbean', '19.50000000', '-80.50000000', 'U+1F1F0 U+1F1FE', NULL, '2025-04-14 14:06:55'),
(41, 'CF', 'CENTRAL AFRICAN REPUBLIC', 'Central African Republic', 'CAF', 140, 236, 'Bangui', 'XAF', 'FCFA', 0.00, '.cf', 'Ködörösêse tî Bêafrîka', 'Africa', 'Middle Africa', '7.00000000', '21.00000000', 'U+1F1E8 U+1F1EB', NULL, '2025-04-14 14:06:55'),
(42, 'TD', 'CHAD', 'Chad', 'TCD', 148, 235, 'N\'Djamena', 'XAF', 'FCFA', 0.00, '.td', 'Tchad', 'Africa', 'Middle Africa', '15.00000000', '19.00000000', 'U+1F1F9 U+1F1E9', NULL, '2025-04-14 14:06:55'),
(43, 'CL', 'CHILE', 'Chile', 'CHL', 152, 56, 'Santiago', 'CLP', '$', 0.00, '.cl', 'Chile', 'Americas', 'South America', '-30.00000000', '-71.00000000', 'U+1F1E8 U+1F1F1', NULL, '2025-04-14 14:06:55'),
(44, 'CN', 'CHINA', 'China', 'CHN', 156, 86, 'Beijing', 'CNY', '¥', 0.00, '.cn', '中国', 'Asia', 'Eastern Asia', '35.00000000', '105.00000000', 'U+1F1E8 U+1F1F3', NULL, '2025-04-14 14:06:55'),
(45, 'CX', 'CHRISTMAS ISLAND', 'Christmas Island', NULL, NULL, 61, 'Flying Fish Cove', 'AUD', '$', 0.00, '.cx', 'Christmas Island', 'Oceania', 'Australia and New Zealand', '-10.50000000', '105.66666666', 'U+1F1E8 U+1F1FD', NULL, '2025-04-14 14:06:55'),
(46, 'CC', 'COCOS (KEELING) ISLANDS', 'Cocos (Keeling) Islands', NULL, NULL, 672, 'West Island', 'AUD', '$', 0.00, '.cc', 'Cocos (Keeling) Islands', 'Oceania', 'Australia and New Zealand', '-12.50000000', '96.83333333', 'U+1F1E8 U+1F1E8', NULL, '2025-04-14 14:06:55'),
(47, 'CO', 'COLOMBIA', 'Colombia', 'COL', 170, 57, 'Bogota', 'COP', '$', 0.00, '.co', 'Colombia', 'Americas', 'South America', '4.00000000', '-72.00000000', 'U+1F1E8 U+1F1F4', NULL, '2025-04-14 14:06:55'),
(48, 'KM', 'COMOROS', 'Comoros', 'COM', 174, 269, 'Moroni', 'KMF', 'CF', 0.00, '.km', 'Komori', 'Africa', 'Eastern Africa', '-12.16666666', '44.25000000', 'U+1F1F0 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(49, 'CG', 'CONGO', 'Congo', 'COG', 178, 242, 'Brazzaville', 'XAF', 'FC', 0.00, '.cg', 'République du Congo', 'Africa', 'Middle Africa', '-1.00000000', '15.00000000', 'U+1F1E8 U+1F1EC', NULL, '2025-04-14 14:06:55'),
(50, 'CD', 'CONGO, THE DEMOCRATIC REPUBLIC OF THE', 'Congo, the Democratic Republic of the', 'COD', 180, 242, 'Kinshasa', 'CDF', 'FC', 0.00, '.cd', 'République démocratique du Congo', 'Africa', 'Middle Africa', '0.00000000', '25.00000000', 'U+1F1E8 U+1F1E9', NULL, '2025-04-14 14:06:55'),
(51, 'CK', 'COOK ISLANDS', 'Cook Islands', 'COK', 184, 682, 'Avarua', 'NZD', '$', 0.00, '.ck', 'Cook Islands', 'Oceania', 'Polynesia', '-21.23333333', '-159.76666666', 'U+1F1E8 U+1F1F0', NULL, '2025-04-14 14:06:55'),
(52, 'CR', 'COSTA RICA', 'Costa Rica', 'CRI', 188, 506, 'San Jose', 'CRC', '₡', 0.00, '.cr', 'Costa Rica', 'Americas', 'Central America', '10.00000000', '-84.00000000', 'U+1F1E8 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(53, 'CI', 'COTE D\'IVOIRE', 'Cote D\'Ivoire', 'CIV', 384, 225, 'Yamoussoukro', 'XOF', 'CFA', 0.00, '.ci', NULL, 'Africa', 'Western Africa', '8.00000000', '-5.00000000', 'U+1F1E8 U+1F1EE', NULL, '2025-04-14 14:06:55'),
(54, 'HR', 'CROATIA', 'Croatia', 'HRV', 191, 385, 'Zagreb', 'HRK', 'kn', 0.00, '.hr', 'Hrvatska', 'Europe', 'Southern Europe', '45.16666666', '15.50000000', 'U+1F1ED U+1F1F7', NULL, '2025-04-14 14:06:55'),
(55, 'CU', 'CUBA', 'Cuba', 'CUB', 192, 53, 'Havana', 'CUP', '$', 0.00, '.cu', 'Cuba', 'Americas', 'Caribbean', '21.50000000', '-80.00000000', 'U+1F1E8 U+1F1FA', NULL, '2025-04-14 14:06:55'),
(56, 'CY', 'CYPRUS', 'Cyprus', 'CYP', 196, 357, 'Nicosia', 'EUR', '€', 0.00, '.cy', 'Κύπρος', 'Europe', 'Southern Europe', '35.00000000', '33.00000000', 'U+1F1E8 U+1F1FE', NULL, '2025-04-14 14:06:55'),
(57, 'CZ', 'CZECH REPUBLIC', 'Czech Republic', 'CZE', 203, 420, 'Prague', 'CZK', 'Kč', 0.00, '.cz', 'Česká republika', 'Europe', 'Eastern Europe', '49.75000000', '15.50000000', 'U+1F1E8 U+1F1FF', NULL, '2025-04-14 14:06:55'),
(58, 'DK', 'DENMARK', 'Denmark', 'DNK', 208, 45, 'Copenhagen', 'DKK', 'Kr.', 0.00, '.dk', 'Danmark', 'Europe', 'Northern Europe', '56.00000000', '10.00000000', 'U+1F1E9 U+1F1F0', NULL, '2025-04-14 14:06:55'),
(59, 'DJ', 'DJIBOUTI', 'Djibouti', 'DJI', 262, 253, 'Djibouti', 'DJF', 'Fdj', 0.00, '.dj', 'Djibouti', 'Africa', 'Eastern Africa', '11.50000000', '43.00000000', 'U+1F1E9 U+1F1EF', NULL, '2025-04-14 14:06:55'),
(60, 'DM', 'DOMINICA', 'Dominica', 'DMA', 212, 1767, 'Roseau', 'XCD', '$', 0.00, '.dm', 'Dominica', 'Americas', 'Caribbean', '15.41666666', '-61.33333333', 'U+1F1E9 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(61, 'DO', 'DOMINICAN REPUBLIC', 'Dominican Republic', 'DOM', 214, 1809, 'Santo Domingo', 'DOP', '$', 0.00, '.do', 'República Dominicana', 'Americas', 'Caribbean', '19.00000000', '-70.66666666', 'U+1F1E9 U+1F1F4', NULL, '2025-04-14 14:06:55'),
(62, 'EC', 'ECUADOR', 'Ecuador', 'ECU', 218, 593, 'Quito', 'USD', '$', 0.00, '.ec', 'Ecuador', 'Americas', 'South America', '-2.00000000', '-77.50000000', 'U+1F1EA U+1F1E8', NULL, '2025-04-14 14:06:55'),
(63, 'EG', 'EGYPT', 'Egypt', 'EGY', 818, 20, 'Cairo', 'EGP', 'ج.م', 0.00, '.eg', 'مصر‎', 'Africa', 'Northern Africa', '27.00000000', '30.00000000', 'U+1F1EA U+1F1EC', NULL, '2025-04-14 14:06:55'),
(64, 'SV', 'EL SALVADOR', 'El Salvador', 'SLV', 222, 503, 'San Salvador', 'USD', '$', 0.00, '.sv', 'El Salvador', 'Americas', 'Central America', '13.83333333', '-88.91666666', 'U+1F1F8 U+1F1FB', NULL, '2025-04-14 14:06:55'),
(65, 'GQ', 'EQUATORIAL GUINEA', 'Equatorial Guinea', 'GNQ', 226, 240, 'Malabo', 'XAF', 'FCFA', 0.00, '.gq', 'Guinea Ecuatorial', 'Africa', 'Middle Africa', '2.00000000', '10.00000000', 'U+1F1EC U+1F1F6', NULL, '2025-04-14 14:06:55'),
(66, 'ER', 'ERITREA', 'Eritrea', 'ERI', 232, 291, 'Asmara', 'ERN', 'Nfk', 0.00, '.er', 'ኤርትራ', 'Africa', 'Eastern Africa', '15.00000000', '39.00000000', 'U+1F1EA U+1F1F7', NULL, '2025-04-14 14:06:55'),
(67, 'EE', 'ESTONIA', 'Estonia', 'EST', 233, 372, 'Tallinn', 'EUR', '€', 0.00, '.ee', 'Eesti', 'Europe', 'Northern Europe', '59.00000000', '26.00000000', 'U+1F1EA U+1F1EA', NULL, '2025-04-14 14:06:55'),
(68, 'ET', 'ETHIOPIA', 'Ethiopia', 'ETH', 231, 251, 'Addis Ababa', 'ETB', 'Nkf', 0.00, '.et', 'ኢትዮጵያ', 'Africa', 'Eastern Africa', '8.00000000', '38.00000000', 'U+1F1EA U+1F1F9', NULL, '2025-04-14 14:06:55'),
(69, 'FK', 'FALKLAND ISLANDS (MALVINAS)', 'Falkland Islands (Malvinas)', 'FLK', 238, 500, 'Stanley', 'FKP', '£', 0.00, '.fk', 'Falkland Islands', 'Americas', 'South America', '-51.75000000', '-59.00000000', 'U+1F1EB U+1F1F0', NULL, '2025-04-14 14:06:55'),
(70, 'FO', 'FAROE ISLANDS', 'Faroe Islands', 'FRO', 234, 298, 'Torshavn', 'DKK', 'Kr.', 0.00, '.fo', 'Føroyar', 'Europe', 'Northern Europe', '62.00000000', '-7.00000000', 'U+1F1EB U+1F1F4', NULL, '2025-04-14 14:06:55'),
(71, 'FJ', 'FIJI', 'Fiji', 'FJI', 242, 679, 'Suva', 'FJD', 'FJ$', 0.00, '.fj', 'Fiji', 'Oceania', 'Melanesia', '-18.00000000', '175.00000000', 'U+1F1EB U+1F1EF', NULL, '2025-04-14 14:06:55'),
(72, 'FI', 'FINLAND', 'Finland', 'FIN', 246, 358, 'Helsinki', 'EUR', '€', 0.00, '.fi', 'Suomi', 'Europe', 'Northern Europe', '64.00000000', '26.00000000', 'U+1F1EB U+1F1EE', NULL, '2025-04-14 14:06:55'),
(73, 'FR', 'FRANCE', 'France', 'FRA', 250, 33, 'Paris', 'EUR', '€', 0.00, '.fr', 'France', 'Europe', 'Western Europe', '46.00000000', '2.00000000', 'U+1F1EB U+1F1F7', NULL, '2025-04-14 14:06:55'),
(74, 'GF', 'FRENCH GUIANA', 'French Guiana', 'GUF', 254, 594, 'Cayenne', 'EUR', '€', 0.00, '.gf', 'Guyane française', 'Americas', 'South America', '4.00000000', '-53.00000000', 'U+1F1EC U+1F1EB', NULL, '2025-04-14 14:06:55'),
(75, 'PF', 'FRENCH POLYNESIA', 'French Polynesia', 'PYF', 258, 689, 'Papeete', 'XPF', '₣', 0.00, '.pf', 'Polynésie française', 'Oceania', 'Polynesia', '-15.00000000', '-140.00000000', 'U+1F1F5 U+1F1EB', NULL, '2025-04-14 14:06:55'),
(76, 'TF', 'FRENCH SOUTHERN TERRITORIES', 'French Southern Territories', NULL, NULL, 0, 'Port-aux-Francais', 'EUR', '€', 0.00, '.tf', 'Territoire des Terres australes et antarctiques fr', 'Africa', 'Southern Africa', '-49.25000000', '69.16700000', 'U+1F1F9 U+1F1EB', NULL, '2025-04-14 14:06:55'),
(77, 'GA', 'GABON', 'Gabon', 'GAB', 266, 241, 'Libreville', 'XAF', 'FCFA', 0.00, '.ga', 'Gabon', 'Africa', 'Middle Africa', '-1.00000000', '11.75000000', 'U+1F1EC U+1F1E6', NULL, '2025-04-14 14:06:55'),
(78, 'GM', 'GAMBIA', 'Gambia', 'GMB', 270, 220, 'Banjul', 'GMD', 'D', 0.00, '.gm', 'Gambia', 'Africa', 'Western Africa', '13.46666666', '-16.56666666', 'U+1F1EC U+1F1F2', NULL, '2025-04-14 14:06:55'),
(79, 'GE', 'GEORGIA', 'Georgia', 'GEO', 268, 995, 'Tbilisi', 'GEL', 'ლ', 0.00, '.ge', 'საქართველო', 'Asia', 'Western Asia', '42.00000000', '43.50000000', 'U+1F1EC U+1F1EA', NULL, '2025-04-14 14:06:55'),
(80, 'DE', 'GERMANY', 'Germany', 'DEU', 276, 49, 'Berlin', 'EUR', '€', 0.00, '.de', 'Deutschland', 'Europe', 'Western Europe', '51.00000000', '9.00000000', 'U+1F1E9 U+1F1EA', NULL, '2025-04-14 14:06:55'),
(81, 'GH', 'GHANA', 'Ghana', 'GHA', 288, 233, 'Accra', 'GHS', 'GH₵', 0.00, '.gh', 'Ghana', 'Africa', 'Western Africa', '8.00000000', '-2.00000000', 'U+1F1EC U+1F1ED', NULL, '2025-04-14 14:06:55'),
(82, 'GI', 'GIBRALTAR', 'Gibraltar', 'GIB', 292, 350, 'Gibraltar', 'GIP', '£', 0.00, '.gi', 'Gibraltar', 'Europe', 'Southern Europe', '36.13333333', '-5.35000000', 'U+1F1EC U+1F1EE', NULL, '2025-04-14 14:06:55'),
(83, 'GR', 'GREECE', 'Greece', 'GRC', 300, 30, 'Athens', 'EUR', '€', 0.00, '.gr', 'Ελλάδα', 'Europe', 'Southern Europe', '39.00000000', '22.00000000', 'U+1F1EC U+1F1F7', NULL, '2025-04-14 14:06:55'),
(84, 'GL', 'GREENLAND', 'Greenland', 'GRL', 304, 299, 'Nuuk', 'DKK', 'Kr.', 0.00, '.gl', 'Kalaallit Nunaat', 'Americas', 'Northern America', '72.00000000', '-40.00000000', 'U+1F1EC U+1F1F1', NULL, '2025-04-14 14:06:55'),
(85, 'GD', 'GRENADA', 'Grenada', 'GRD', 308, 1473, 'St. George\'s', 'XCD', '$', 0.00, '.gd', 'Grenada', 'Americas', 'Caribbean', '12.11666666', '-61.66666666', 'U+1F1EC U+1F1E9', NULL, '2025-04-14 14:06:55'),
(86, 'GP', 'GUADELOUPE', 'Guadeloupe', 'GLP', 312, 590, 'Basse-Terre', 'EUR', '€', 0.00, '.gp', 'Guadeloupe', 'Americas', 'Caribbean', '16.25000000', '-61.58333300', 'U+1F1EC U+1F1F5', NULL, '2025-04-14 14:06:55'),
(87, 'GU', 'GUAM', 'Guam', 'GUM', 316, 1671, 'Hagatna', 'USD', '$', 0.00, '.gu', 'Guam', 'Oceania', 'Micronesia', '13.46666666', '144.78333333', 'U+1F1EC U+1F1FA', NULL, '2025-04-14 14:06:55'),
(88, 'GT', 'GUATEMALA', 'Guatemala', 'GTM', 320, 502, 'Guatemala City', 'GTQ', 'Q', 0.00, '.gt', 'Guatemala', 'Americas', 'Central America', '15.50000000', '-90.25000000', 'U+1F1EC U+1F1F9', NULL, '2025-04-14 14:06:55'),
(89, 'GN', 'GUINEA', 'Guinea', 'GIN', 324, 224, 'Conakry', 'GNF', 'FG', 0.00, '.gn', 'Guinée', 'Africa', 'Western Africa', '11.00000000', '-10.00000000', 'U+1F1EC U+1F1F3', NULL, '2025-04-14 14:06:55'),
(90, 'GW', 'GUINEA-BISSAU', 'Guinea-Bissau', 'GNB', 624, 245, 'Bissau', 'XOF', 'CFA', 0.00, '.gw', 'Guiné-Bissau', 'Africa', 'Western Africa', '12.00000000', '-15.00000000', 'U+1F1EC U+1F1FC', NULL, '2025-04-14 14:06:55'),
(91, 'GY', 'GUYANA', 'Guyana', 'GUY', 328, 592, 'Georgetown', 'GYD', '$', 0.00, '.gy', 'Guyana', 'Americas', 'South America', '5.00000000', '-59.00000000', 'U+1F1EC U+1F1FE', NULL, '2025-04-14 14:06:55'),
(92, 'HT', 'HAITI', 'Haiti', 'HTI', 332, 509, 'Port-au-Prince', 'HTG', 'G', 0.00, '.ht', 'Haïti', 'Americas', 'Caribbean', '19.00000000', '-72.41666666', 'U+1F1ED U+1F1F9', NULL, '2025-04-14 14:06:55'),
(93, 'HM', 'HEARD ISLAND AND MCDONALD ISLANDS', 'Heard Island and Mcdonald Islands', NULL, NULL, 0, '', 'AUD', '$', 0.00, '.hm', 'Heard Island and McDonald Islands', '', '', '-53.10000000', '72.51666666', 'U+1F1ED U+1F1F2', NULL, '2025-04-14 14:06:55'),
(94, 'VA', 'HOLY SEE (VATICAN CITY STATE)', 'Holy See (Vatican City State)', 'VAT', 336, 39, 'Vatican City', 'EUR', '€', 0.00, '.va', 'Vaticano', 'Europe', 'Southern Europe', '41.90000000', '12.45000000', 'U+1F1FB U+1F1E6', NULL, '2025-04-14 14:06:55'),
(95, 'HN', 'HONDURAS', 'Honduras', 'HND', 340, 504, 'Tegucigalpa', 'HNL', 'L', 0.00, '.hn', 'Honduras', 'Americas', 'Central America', '15.00000000', '-86.50000000', 'U+1F1ED U+1F1F3', NULL, '2025-04-14 14:06:55'),
(96, 'HK', 'HONG KONG', 'Hong Kong', 'HKG', 344, 852, 'Hong Kong', 'HKD', '$', 0.00, '.hk', '香港', 'Asia', 'Eastern Asia', '22.25000000', '114.16666666', 'U+1F1ED U+1F1F0', NULL, '2025-04-14 14:06:55'),
(97, 'HU', 'HUNGARY', 'Hungary', 'HUN', 348, 36, 'Budapest', 'HUF', 'Ft', 0.00, '.hu', 'Magyarország', 'Europe', 'Eastern Europe', '47.00000000', '20.00000000', 'U+1F1ED U+1F1FA', NULL, '2025-04-14 14:06:55'),
(98, 'IS', 'ICELAND', 'Iceland', 'ISL', 352, 354, 'Reykjavik', 'ISK', 'kr', 0.00, '.is', 'Ísland', 'Europe', 'Northern Europe', '65.00000000', '-18.00000000', 'U+1F1EE U+1F1F8', NULL, '2025-04-14 14:06:55'),
(99, 'IN', 'INDIA', 'India', 'IND', 356, 91, 'New Delhi', 'INR', '₹', 0.00, '.in', 'भारत', 'Asia', 'Southern Asia', '20.00000000', '77.00000000', 'U+1F1EE U+1F1F3', NULL, '2025-04-14 14:06:55'),
(100, 'ID', 'INDONESIA', 'Indonesia', 'IDN', 360, 62, 'Jakarta', 'IDR', 'Rp', 0.00, '.id', 'Indonesia', 'Asia', 'South-Eastern Asia', '-5.00000000', '120.00000000', 'U+1F1EE U+1F1E9', NULL, '2025-04-14 14:06:55'),
(101, 'IR', 'IRAN, ISLAMIC REPUBLIC OF', 'Iran, Islamic Republic of', 'IRN', 364, 98, 'Tehran', 'IRR', '﷼', 0.00, '.ir', 'ایران', 'Asia', 'Southern Asia', '32.00000000', '53.00000000', 'U+1F1EE U+1F1F7', NULL, '2025-04-14 14:06:55'),
(102, 'IQ', 'IRAQ', 'Iraq', 'IRQ', 368, 964, 'Baghdad', 'IQD', 'د.ع', 0.00, '.iq', 'العراق', 'Asia', 'Western Asia', '33.00000000', '44.00000000', 'U+1F1EE U+1F1F6', NULL, '2025-04-14 14:06:55'),
(103, 'IE', 'IRELAND', 'Ireland', 'IRL', 372, 353, 'Dublin', 'EUR', '€', 0.00, '.ie', 'Éire', 'Europe', 'Northern Europe', '53.00000000', '-8.00000000', 'U+1F1EE U+1F1EA', NULL, '2025-04-14 14:06:55'),
(104, 'IL', 'ISRAEL', 'Israel', 'ISR', 376, 972, 'Jerusalem', 'ILS', '₪', 0.00, '.il', 'יִשְׂרָאֵל', 'Asia', 'Western Asia', '31.50000000', '34.75000000', 'U+1F1EE U+1F1F1', NULL, '2025-04-14 14:06:55'),
(105, 'IT', 'ITALY', 'Italy', 'ITA', 380, 39, 'Rome', 'EUR', '€', 0.00, '.it', 'Italia', 'Europe', 'Southern Europe', '42.83333333', '12.83333333', 'U+1F1EE U+1F1F9', NULL, '2025-04-14 14:06:55'),
(106, 'JM', 'JAMAICA', 'Jamaica', 'JAM', 388, 1876, 'Kingston', 'JMD', 'J$', 0.00, '.jm', 'Jamaica', 'Americas', 'Caribbean', '18.25000000', '-77.50000000', 'U+1F1EF U+1F1F2', NULL, '2025-04-14 14:06:55'),
(107, 'JP', 'JAPAN', 'Japan', 'JPN', 392, 81, 'Tokyo', 'JPY', '¥', 0.00, '.jp', '日本', 'Asia', 'Eastern Asia', '36.00000000', '138.00000000', 'U+1F1EF U+1F1F5', NULL, '2025-04-14 14:06:55'),
(108, 'JO', 'JORDAN', 'Jordan', 'JOR', 400, 962, 'Amman', 'JOD', 'ا.د', 0.00, '.jo', 'الأردن', 'Asia', 'Western Asia', '31.00000000', '36.00000000', 'U+1F1EF U+1F1F4', NULL, '2025-04-14 14:06:55'),
(109, 'KZ', 'KAZAKHSTAN', 'Kazakhstan', 'KAZ', 398, 7, 'Astana', 'KZT', 'лв', 0.00, '.kz', 'Қазақстан', 'Asia', 'Central Asia', '48.00000000', '68.00000000', 'U+1F1F0 U+1F1FF', NULL, '2025-04-14 14:06:55'),
(110, 'KE', 'KENYA', 'Kenya', 'KEN', 404, 254, 'Nairobi', 'KES', 'KSh', 0.00, '.ke', 'Kenya', 'Africa', 'Eastern Africa', '1.00000000', '38.00000000', 'U+1F1F0 U+1F1EA', NULL, '2025-04-14 14:06:55'),
(111, 'KI', 'KIRIBATI', 'Kiribati', 'KIR', 296, 686, 'Tarawa', 'AUD', '$', 0.00, '.ki', 'Kiribati', 'Oceania', 'Micronesia', '1.41666666', '173.00000000', 'U+1F1F0 U+1F1EE', NULL, '2025-04-14 14:06:55'),
(112, 'KP', 'KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC OF', 'Korea, Democratic People\'s Republic of', 'PRK', 408, 850, 'Pyongyang', 'KPW', '₩', 0.00, '.kp', '북한', 'Asia', 'Eastern Asia', '40.00000000', '127.00000000', 'U+1F1F0 U+1F1F5', NULL, '2025-04-14 14:06:55'),
(113, 'KR', 'KOREA, REPUBLIC OF', 'Korea, Republic of', 'KOR', 410, 82, 'Seoul', 'KRW', '₩', 0.00, '.kr', '대한민국', 'Asia', 'Eastern Asia', '37.00000000', '127.50000000', 'U+1F1F0 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(114, 'KW', 'KUWAIT', 'Kuwait', 'KWT', 414, 965, 'Kuwait City', 'KWD', 'ك.د', 0.00, '.kw', 'الكويت', 'Asia', 'Western Asia', '29.50000000', '45.75000000', 'U+1F1F0 U+1F1FC', NULL, '2025-04-14 14:06:55'),
(115, 'KG', 'KYRGYZSTAN', 'Kyrgyzstan', 'KGZ', 417, 996, 'Bishkek', 'KGS', 'лв', 0.00, '.kg', 'Кыргызстан', 'Asia', 'Central Asia', '41.00000000', '75.00000000', 'U+1F1F0 U+1F1EC', NULL, '2025-04-14 14:06:55'),
(116, 'LA', 'LAO PEOPLE\'S DEMOCRATIC REPUBLIC', 'Lao People\'s Democratic Republic', 'LAO', 418, 856, 'Vientiane', 'LAK', '₭', 0.00, '.la', 'ສປປລາວ', 'Asia', 'South-Eastern Asia', '18.00000000', '105.00000000', 'U+1F1F1 U+1F1E6', NULL, '2025-04-14 14:06:55'),
(117, 'LV', 'LATVIA', 'Latvia', 'LVA', 428, 371, 'Riga', 'EUR', '€', 0.00, '.lv', 'Latvija', 'Europe', 'Northern Europe', '57.00000000', '25.00000000', 'U+1F1F1 U+1F1FB', NULL, '2025-04-14 14:06:55'),
(118, 'LB', 'LEBANON', 'Lebanon', 'LBN', 422, 961, 'Beirut', 'LBP', '£', 0.00, '.lb', 'لبنان', 'Asia', 'Western Asia', '33.83333333', '35.83333333', 'U+1F1F1 U+1F1E7', NULL, '2025-04-14 14:06:55'),
(119, 'LS', 'LESOTHO', 'Lesotho', 'LSO', 426, 266, 'Maseru', 'LSL', 'L', 0.00, '.ls', 'Lesotho', 'Africa', 'Southern Africa', '-29.50000000', '28.50000000', 'U+1F1F1 U+1F1F8', NULL, '2025-04-14 14:06:55'),
(120, 'LR', 'LIBERIA', 'Liberia', 'LBR', 430, 231, 'Monrovia', 'LRD', '$', 0.00, '.lr', 'Liberia', 'Africa', 'Western Africa', '6.50000000', '-9.50000000', 'U+1F1F1 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(121, 'LY', 'LIBYAN ARAB JAMAHIRIYA', 'Libyan Arab Jamahiriya', 'LBY', 434, 218, 'Tripolis', 'LYD', 'د.ل', 0.00, '.ly', '‏ليبيا', 'Africa', 'Northern Africa', '25.00000000', '17.00000000', 'U+1F1F1 U+1F1FE', NULL, '2025-04-14 14:06:55'),
(122, 'LI', 'LIECHTENSTEIN', 'Liechtenstein', 'LIE', 438, 423, 'Vaduz', 'CHF', 'CHf', 0.00, '.li', 'Liechtenstein', 'Europe', 'Western Europe', '47.26666666', '9.53333333', 'U+1F1F1 U+1F1EE', NULL, '2025-04-14 14:06:55'),
(123, 'LT', 'LITHUANIA', 'Lithuania', 'LTU', 440, 370, 'Vilnius', 'EUR', '€', 0.00, '.lt', 'Lietuva', 'Europe', 'Northern Europe', '56.00000000', '24.00000000', 'U+1F1F1 U+1F1F9', NULL, '2025-04-14 14:06:55'),
(124, 'LU', 'LUXEMBOURG', 'Luxembourg', 'LUX', 442, 352, 'Luxembourg', 'EUR', '€', 0.00, '.lu', 'Luxembourg', 'Europe', 'Western Europe', '49.75000000', '6.16666666', 'U+1F1F1 U+1F1FA', NULL, '2025-04-14 14:06:55'),
(125, 'MO', 'MACAO', 'Macao', 'MAC', 446, 853, 'Macao', 'MOP', '$', 0.00, '.mo', '澳門', 'Asia', 'Eastern Asia', '22.16666666', '113.55000000', 'U+1F1F2 U+1F1F4', NULL, '2025-04-14 14:06:55'),
(126, 'MK', 'MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF', 'Macedonia, the Former Yugoslav Republic of', 'MKD', 807, 389, 'Skopje', 'MKD', 'ден', 0.00, '.mk', 'Северна Македонија', 'Europe', 'Southern Europe', '41.83333333', '22.00000000', 'U+1F1F2 U+1F1F0', NULL, '2025-04-14 14:06:55'),
(127, 'MG', 'MADAGASCAR', 'Madagascar', 'MDG', 450, 261, 'Antananarivo', 'MGA', 'Ar', 0.00, '.mg', 'Madagasikara', 'Africa', 'Eastern Africa', '-20.00000000', '47.00000000', 'U+1F1F2 U+1F1EC', NULL, '2025-04-14 14:06:55'),
(128, 'MW', 'MALAWI', 'Malawi', 'MWI', 454, 265, 'Lilongwe', 'MWK', 'MK', 0.00, '.mw', 'Malawi', 'Africa', 'Eastern Africa', '-13.50000000', '34.00000000', 'U+1F1F2 U+1F1FC', NULL, '2025-04-14 14:06:55'),
(129, 'MY', 'MALAYSIA', 'Malaysia', 'MYS', 458, 60, 'Kuala Lumpur', 'MYR', 'RM', 0.00, '.my', 'Malaysia', 'Asia', 'South-Eastern Asia', '2.50000000', '112.50000000', 'U+1F1F2 U+1F1FE', NULL, '2025-04-14 14:06:55'),
(130, 'MV', 'MALDIVES', 'Maldives', 'MDV', 462, 960, 'Male', 'MVR', 'Rf', 0.00, '.mv', 'Maldives', 'Asia', 'Southern Asia', '3.25000000', '73.00000000', 'U+1F1F2 U+1F1FB', NULL, '2025-04-14 14:06:55'),
(131, 'ML', 'MALI', 'Mali', 'MLI', 466, 223, 'Bamako', 'XOF', 'CFA', 0.00, '.ml', 'Mali', 'Africa', 'Western Africa', '17.00000000', '-4.00000000', 'U+1F1F2 U+1F1F1', NULL, '2025-04-14 14:06:55'),
(132, 'MT', 'MALTA', 'Malta', 'MLT', 470, 356, 'Valletta', 'EUR', '€', 0.00, '.mt', 'Malta', 'Europe', 'Southern Europe', '35.83333333', '14.58333333', 'U+1F1F2 U+1F1F9', NULL, '2025-04-14 14:06:55'),
(133, 'MH', 'MARSHALL ISLANDS', 'Marshall Islands', 'MHL', 584, 692, 'Majuro', 'USD', '$', 0.00, '.mh', 'M̧ajeļ', 'Oceania', 'Micronesia', '9.00000000', '168.00000000', 'U+1F1F2 U+1F1ED', NULL, '2025-04-14 14:06:55'),
(134, 'MQ', 'MARTINIQUE', 'Martinique', 'MTQ', 474, 596, 'Fort-de-France', 'EUR', '€', 0.00, '.mq', 'Martinique', 'Americas', 'Caribbean', '14.66666700', '-61.00000000', 'U+1F1F2 U+1F1F6', NULL, '2025-04-14 14:06:55'),
(135, 'MR', 'MAURITANIA', 'Mauritania', 'MRT', 478, 222, 'Nouakchott', 'MRO', 'MRU', 0.00, '.mr', 'موريتانيا', 'Africa', 'Western Africa', '20.00000000', '-12.00000000', 'U+1F1F2 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(136, 'MU', 'MAURITIUS', 'Mauritius', 'MUS', 480, 230, 'Port Louis', 'MUR', '₨', 0.00, '.mu', 'Maurice', 'Africa', 'Eastern Africa', '-20.28333333', '57.55000000', 'U+1F1F2 U+1F1FA', NULL, '2025-04-14 14:06:55'),
(137, 'YT', 'MAYOTTE', 'Mayotte', NULL, NULL, 269, 'Mamoudzou', 'EUR', '€', 0.00, '.yt', 'Mayotte', 'Africa', 'Eastern Africa', '-12.83333333', '45.16666666', 'U+1F1FE U+1F1F9', NULL, '2025-04-14 14:06:55'),
(138, 'MX', 'MEXICO', 'Mexico', 'MEX', 484, 52, 'Mexico City', 'MXN', '$', 0.00, '.mx', 'México', 'Americas', 'Central America', '23.00000000', '-102.00000000', 'U+1F1F2 U+1F1FD', NULL, '2025-04-14 14:06:55'),
(139, 'FM', 'MICRONESIA, FEDERATED STATES OF', 'Micronesia, Federated States of', 'FSM', 583, 691, 'Palikir', 'USD', '$', 0.00, '.fm', 'Micronesia', 'Oceania', 'Micronesia', '6.91666666', '158.25000000', 'U+1F1EB U+1F1F2', NULL, '2025-04-14 14:06:55'),
(140, 'MD', 'MOLDOVA, REPUBLIC OF', 'Moldova, Republic of', 'MDA', 498, 373, 'Chisinau', 'MDL', 'L', 0.00, '.md', 'Moldova', 'Europe', 'Eastern Europe', '47.00000000', '29.00000000', 'U+1F1F2 U+1F1E9', NULL, '2025-04-14 14:06:55'),
(141, 'MC', 'MONACO', 'Monaco', 'MCO', 492, 377, 'Monaco', 'EUR', '€', 0.00, '.mc', 'Monaco', 'Europe', 'Western Europe', '43.73333333', '7.40000000', 'U+1F1F2 U+1F1E8', NULL, '2025-04-14 14:06:55'),
(142, 'MN', 'MONGOLIA', 'Mongolia', 'MNG', 496, 976, 'Ulan Bator', 'MNT', '₮', 0.00, '.mn', 'Монгол улс', 'Asia', 'Eastern Asia', '46.00000000', '105.00000000', 'U+1F1F2 U+1F1F3', NULL, '2025-04-14 14:06:55'),
(143, 'MS', 'MONTSERRAT', 'Montserrat', 'MSR', 500, 1664, 'Plymouth', 'XCD', '$', 0.00, '.ms', 'Montserrat', 'Americas', 'Caribbean', '16.75000000', '-62.20000000', 'U+1F1F2 U+1F1F8', NULL, '2025-04-14 14:06:55'),
(144, 'MA', 'MOROCCO', 'Morocco', 'MAR', 504, 212, 'Rabat', 'MAD', 'DH', 0.00, '.ma', 'المغرب', 'Africa', 'Northern Africa', '32.00000000', '-5.00000000', 'U+1F1F2 U+1F1E6', NULL, '2025-04-14 14:06:55'),
(145, 'MZ', 'MOZAMBIQUE', 'Mozambique', 'MOZ', 508, 258, 'Maputo', 'MZN', 'MT', 0.00, '.mz', 'Moçambique', 'Africa', 'Eastern Africa', '-18.25000000', '35.00000000', 'U+1F1F2 U+1F1FF', NULL, '2025-04-14 14:06:55'),
(146, 'MM', 'MYANMAR', 'Myanmar', 'MMR', 104, 95, 'Nay Pyi Taw', 'MMK', 'K', 0.00, '.mm', 'မြန်မာ', 'Asia', 'South-Eastern Asia', '22.00000000', '98.00000000', 'U+1F1F2 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(147, 'NA', 'NAMIBIA', 'Namibia', 'NAM', 516, 264, 'Windhoek', 'NAD', '$', 0.00, '.na', 'Namibia', 'Africa', 'Southern Africa', '-22.00000000', '17.00000000', 'U+1F1F3 U+1F1E6', NULL, '2025-04-14 14:06:55'),
(148, 'NR', 'NAURU', 'Nauru', 'NRU', 520, 674, 'Yaren', 'AUD', '$', 0.00, '.nr', 'Nauru', 'Oceania', 'Micronesia', '-0.53333333', '166.91666666', 'U+1F1F3 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(149, 'NP', 'NEPAL', 'Nepal', 'NPL', 524, 977, 'Kathmandu', 'NPR', '₨', 0.00, '.np', 'नपल', 'Asia', 'Southern Asia', '28.00000000', '84.00000000', 'U+1F1F3 U+1F1F5', NULL, '2025-04-14 14:06:55'),
(150, 'NL', 'NETHERLANDS', 'Netherlands', 'NLD', 528, 31, 'Amsterdam', 'EUR', '€', 0.00, '.nl', 'Nederland', 'Europe', 'Western Europe', '52.50000000', '5.75000000', 'U+1F1F3 U+1F1F1', NULL, '2025-04-14 14:06:55'),
(151, 'AN', 'NETHERLANDS ANTILLES', 'Netherlands Antilles', 'ANT', 530, 599, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(152, 'NC', 'NEW CALEDONIA', 'New Caledonia', 'NCL', 540, 687, 'Noumea', 'XPF', '₣', 0.00, '.nc', 'Nouvelle-Calédonie', 'Oceania', 'Melanesia', '-21.50000000', '165.50000000', 'U+1F1F3 U+1F1E8', NULL, '2025-04-14 14:06:55'),
(153, 'NZ', 'NEW ZEALAND', 'New Zealand', 'NZL', 554, 64, 'Wellington', 'NZD', '$', 0.00, '.nz', 'New Zealand', 'Oceania', 'Australia and New Zealand', '-41.00000000', '174.00000000', 'U+1F1F3 U+1F1FF', NULL, '2025-04-14 14:06:55'),
(154, 'NI', 'NICARAGUA', 'Nicaragua', 'NIC', 558, 505, 'Managua', 'NIO', 'C$', 0.00, '.ni', 'Nicaragua', 'Americas', 'Central America', '13.00000000', '-85.00000000', 'U+1F1F3 U+1F1EE', NULL, '2025-04-14 14:06:55'),
(155, 'NE', 'NIGER', 'Niger', 'NER', 562, 227, 'Niamey', 'XOF', 'CFA', 0.00, '.ne', 'Niger', 'Africa', 'Western Africa', '16.00000000', '8.00000000', 'U+1F1F3 U+1F1EA', NULL, '2025-04-14 14:06:55'),
(156, 'NG', 'NIGERIA', 'Nigeria', 'NGA', 566, 234, 'Abuja', 'NGN', '₦', 0.00, '.ng', 'Nigeria', 'Africa', 'Western Africa', '10.00000000', '8.00000000', 'U+1F1F3 U+1F1EC', NULL, '2025-04-14 14:06:55'),
(157, 'NU', 'NIUE', 'Niue', 'NIU', 570, 683, 'Alofi', 'NZD', '$', 0.00, '.nu', 'Niuē', 'Oceania', 'Polynesia', '-19.03333333', '-169.86666666', 'U+1F1F3 U+1F1FA', NULL, '2025-04-14 14:06:55'),
(158, 'NF', 'NORFOLK ISLAND', 'Norfolk Island', 'NFK', 574, 672, 'Kingston', 'AUD', '$', 0.00, '.nf', 'Norfolk Island', 'Oceania', 'Australia and New Zealand', '-29.03333333', '167.95000000', 'U+1F1F3 U+1F1EB', NULL, '2025-04-14 14:06:55'),
(159, 'MP', 'NORTHERN MARIANA ISLANDS', 'Northern Mariana Islands', 'MNP', 580, 1670, 'Saipan', 'USD', '$', 0.00, '.mp', 'Northern Mariana Islands', 'Oceania', 'Micronesia', '15.20000000', '145.75000000', 'U+1F1F2 U+1F1F5', NULL, '2025-04-14 14:06:55'),
(160, 'NO', 'NORWAY', 'Norway', 'NOR', 578, 47, 'Oslo', 'NOK', 'kr', 0.00, '.no', 'Norge', 'Europe', 'Northern Europe', '62.00000000', '10.00000000', 'U+1F1F3 U+1F1F4', NULL, '2025-04-14 14:06:55'),
(161, 'OM', 'OMAN', 'Oman', 'OMN', 512, 968, 'Muscat', 'OMR', '.ع.ر', 0.00, '.om', 'عمان', 'Asia', 'Western Asia', '21.00000000', '57.00000000', 'U+1F1F4 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(162, 'PK', 'PAKISTAN', 'Pakistan', 'PAK', 586, 92, 'Islamabad', 'PKR', '₨', 0.00, '.pk', 'Pakistan', 'Asia', 'Southern Asia', '30.00000000', '70.00000000', 'U+1F1F5 U+1F1F0', NULL, '2025-04-14 14:06:55'),
(163, 'PW', 'PALAU', 'Palau', 'PLW', 585, 680, 'Melekeok', 'USD', '$', 0.00, '.pw', 'Palau', 'Oceania', 'Micronesia', '7.50000000', '134.50000000', 'U+1F1F5 U+1F1FC', NULL, '2025-04-14 14:06:55'),
(164, 'PS', 'PALESTINIAN TERRITORY, OCCUPIED', 'Palestinian Territory, Occupied', NULL, NULL, 970, 'East Jerusalem', 'ILS', '₪', 0.00, '.ps', 'فلسطين', 'Asia', 'Western Asia', '31.90000000', '35.20000000', 'U+1F1F5 U+1F1F8', NULL, '2025-04-14 14:06:55'),
(165, 'PA', 'PANAMA', 'Panama', 'PAN', 591, 507, 'Panama City', 'PAB', 'B/.', 0.00, '.pa', 'Panamá', 'Americas', 'Central America', '9.00000000', '-80.00000000', 'U+1F1F5 U+1F1E6', NULL, '2025-04-14 14:06:55'),
(166, 'PG', 'PAPUA NEW GUINEA', 'Papua New Guinea', 'PNG', 598, 675, 'Port Moresby', 'PGK', 'K', 0.00, '.pg', 'Papua Niugini', 'Oceania', 'Melanesia', '-6.00000000', '147.00000000', 'U+1F1F5 U+1F1EC', NULL, '2025-04-14 14:06:55'),
(167, 'PY', 'PARAGUAY', 'Paraguay', 'PRY', 600, 595, 'Asuncion', 'PYG', '₲', 0.00, '.py', 'Paraguay', 'Americas', 'South America', '-23.00000000', '-58.00000000', 'U+1F1F5 U+1F1FE', NULL, '2025-04-14 14:06:55'),
(168, 'PE', 'PERU', 'Peru', 'PER', 604, 51, 'Lima', 'PEN', 'S/.', 0.00, '.pe', 'Perú', 'Americas', 'South America', '-10.00000000', '-76.00000000', 'U+1F1F5 U+1F1EA', NULL, '2025-04-14 14:06:55'),
(169, 'PH', 'PHILIPPINES', 'Philippines', 'PHL', 608, 63, 'Manila', 'PHP', '₱', 0.00, '.ph', 'Pilipinas', 'Asia', 'South-Eastern Asia', '13.00000000', '122.00000000', 'U+1F1F5 U+1F1ED', NULL, '2025-04-14 14:06:55'),
(170, 'PN', 'PITCAIRN', 'Pitcairn', 'PCN', 612, 0, 'Adamstown', 'NZD', '$', 0.00, '.pn', 'Pitcairn Islands', 'Oceania', 'Polynesia', '-25.06666666', '-130.10000000', 'U+1F1F5 U+1F1F3', NULL, '2025-04-14 14:06:55'),
(171, 'PL', 'POLAND', 'Poland', 'POL', 616, 48, 'Warsaw', 'PLN', 'zł', 0.00, '.pl', 'Polska', 'Europe', 'Eastern Europe', '52.00000000', '20.00000000', 'U+1F1F5 U+1F1F1', NULL, '2025-04-14 14:06:55'),
(172, 'PT', 'PORTUGAL', 'Portugal', 'PRT', 620, 351, 'Lisbon', 'EUR', '€', 0.00, '.pt', 'Portugal', 'Europe', 'Southern Europe', '39.50000000', '-8.00000000', 'U+1F1F5 U+1F1F9', NULL, '2025-04-14 14:06:55'),
(173, 'PR', 'PUERTO RICO', 'Puerto Rico', 'PRI', 630, 1787, 'San Juan', 'USD', '$', 0.00, '.pr', 'Puerto Rico', 'Americas', 'Caribbean', '18.25000000', '-66.50000000', 'U+1F1F5 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(174, 'QA', 'QATAR', 'Qatar', 'QAT', 634, 974, 'Doha', 'QAR', 'ق.ر', 0.00, '.qa', 'قطر', 'Asia', 'Western Asia', '25.50000000', '51.25000000', 'U+1F1F6 U+1F1E6', NULL, '2025-04-14 14:06:55'),
(175, 'RE', 'REUNION', 'Reunion', 'REU', 638, 262, 'Saint-Denis', 'EUR', '€', 0.00, '.re', 'La Réunion', 'Africa', 'Eastern Africa', '-21.15000000', '55.50000000', 'U+1F1F7 U+1F1EA', NULL, '2025-04-14 14:06:55'),
(176, 'RO', 'ROMANIA', 'Romania', 'ROM', 642, 40, 'Bucharest', 'RON', 'lei', 0.00, '.ro', 'România', 'Europe', 'Eastern Europe', '46.00000000', '25.00000000', 'U+1F1F7 U+1F1F4', NULL, '2025-04-14 14:06:55'),
(177, 'RU', 'RUSSIAN FEDERATION', 'Russian Federation', 'RUS', 643, 70, 'Moscow', 'RUB', '₽', 0.00, '.ru', 'Россия', 'Europe', 'Eastern Europe', '60.00000000', '100.00000000', 'U+1F1F7 U+1F1FA', NULL, '2025-04-14 14:06:55'),
(178, 'RW', 'RWANDA', 'Rwanda', 'RWA', 646, 250, 'Kigali', 'RWF', 'FRw', 0.00, '.rw', 'Rwanda', 'Africa', 'Eastern Africa', '-2.00000000', '30.00000000', 'U+1F1F7 U+1F1FC', NULL, '2025-04-14 14:06:55'),
(179, 'SH', 'SAINT HELENA', 'Saint Helena', 'SHN', 654, 290, 'Jamestown', 'SHP', '£', 0.00, '.sh', 'Saint Helena', 'Africa', 'Western Africa', '-15.95000000', '-5.70000000', 'U+1F1F8 U+1F1ED', NULL, '2025-04-14 14:06:55'),
(180, 'KN', 'SAINT KITTS AND NEVIS', 'Saint Kitts and Nevis', 'KNA', 659, 1869, 'Basseterre', 'XCD', '$', 0.00, '.kn', 'Saint Kitts and Nevis', 'Americas', 'Caribbean', '17.33333333', '-62.75000000', 'U+1F1F0 U+1F1F3', NULL, '2025-04-14 14:06:55'),
(181, 'LC', 'SAINT LUCIA', 'Saint Lucia', 'LCA', 662, 1758, 'Castries', 'XCD', '$', 0.00, '.lc', 'Saint Lucia', 'Americas', 'Caribbean', '13.88333333', '-60.96666666', 'U+1F1F1 U+1F1E8', NULL, '2025-04-14 14:06:55'),
(182, 'PM', 'SAINT PIERRE AND MIQUELON', 'Saint Pierre and Miquelon', 'SPM', 666, 508, 'Saint-Pierre', 'EUR', '€', 0.00, '.pm', 'Saint-Pierre-et-Miquelon', 'Americas', 'Northern America', '46.83333333', '-56.33333333', 'U+1F1F5 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(183, 'VC', 'SAINT VINCENT AND THE GRENADINES', 'Saint Vincent and the Grenadines', 'VCT', 670, 1784, 'Kingstown', 'XCD', '$', 0.00, '.vc', 'Saint Vincent and the Grenadines', 'Americas', 'Caribbean', '13.25000000', '-61.20000000', 'U+1F1FB U+1F1E8', NULL, '2025-04-14 14:06:55'),
(184, 'WS', 'SAMOA', 'Samoa', 'WSM', 882, 684, 'Apia', 'WST', 'SAT', 0.00, '.ws', 'Samoa', 'Oceania', 'Polynesia', '-13.58333333', '-172.33333333', 'U+1F1FC U+1F1F8', NULL, '2025-04-14 14:06:55'),
(185, 'SM', 'SAN MARINO', 'San Marino', 'SMR', 674, 378, 'San Marino', 'EUR', '€', 0.00, '.sm', 'San Marino', 'Europe', 'Southern Europe', '43.76666666', '12.41666666', 'U+1F1F8 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(186, 'ST', 'SAO TOME AND PRINCIPE', 'Sao Tome and Principe', 'STP', 678, 239, 'Sao Tome', 'STD', 'Db', 0.00, '.st', 'São Tomé e Príncipe', 'Africa', 'Middle Africa', '1.00000000', '7.00000000', 'U+1F1F8 U+1F1F9', NULL, '2025-04-14 14:06:55'),
(187, 'SA', 'SAUDI ARABIA', 'Saudi Arabia', 'SAU', 682, 966, 'Riyadh', 'SAR', '﷼', 0.00, '.sa', 'العربية السعودية', 'Asia', 'Western Asia', '25.00000000', '45.00000000', 'U+1F1F8 U+1F1E6', NULL, '2025-04-14 14:06:55'),
(188, 'SN', 'SENEGAL', 'Senegal', 'SEN', 686, 221, 'Dakar', 'XOF', 'CFA', 0.00, '.sn', 'Sénégal', 'Africa', 'Western Africa', '14.00000000', '-14.00000000', 'U+1F1F8 U+1F1F3', NULL, '2025-04-14 14:06:55'),
(189, 'CS', 'SERBIA AND MONTENEGRO', 'Serbia and Montenegro', NULL, NULL, 381, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(190, 'SC', 'SEYCHELLES', 'Seychelles', 'SYC', 690, 248, 'Victoria', 'SCR', 'SRe', 0.00, '.sc', 'Seychelles', 'Africa', 'Eastern Africa', '-4.58333333', '55.66666666', 'U+1F1F8 U+1F1E8', NULL, '2025-04-14 14:06:55'),
(191, 'SL', 'SIERRA LEONE', 'Sierra Leone', 'SLE', 694, 232, 'Freetown', 'SLL', 'Le', 0.00, '.sl', 'Sierra Leone', 'Africa', 'Western Africa', '8.50000000', '-11.50000000', 'U+1F1F8 U+1F1F1', NULL, '2025-04-14 14:06:55'),
(192, 'SG', 'SINGAPORE', 'Singapore', 'SGP', 702, 65, 'Singapur', 'SGD', '$', 0.00, '.sg', 'Singapore', 'Asia', 'South-Eastern Asia', '1.36666666', '103.80000000', 'U+1F1F8 U+1F1EC', NULL, '2025-04-14 14:06:55'),
(193, 'SK', 'SLOVAKIA', 'Slovakia', 'SVK', 703, 421, 'Bratislava', 'EUR', '€', 0.00, '.sk', 'Slovensko', 'Europe', 'Eastern Europe', '48.66666666', '19.50000000', 'U+1F1F8 U+1F1F0', NULL, '2025-04-14 14:06:55'),
(194, 'SI', 'SLOVENIA', 'Slovenia', 'SVN', 705, 386, 'Ljubljana', 'EUR', '€', 0.00, '.si', 'Slovenija', 'Europe', 'Southern Europe', '46.11666666', '14.81666666', 'U+1F1F8 U+1F1EE', NULL, '2025-04-14 14:06:55'),
(195, 'SB', 'SOLOMON ISLANDS', 'Solomon Islands', 'SLB', 90, 677, 'Honiara', 'SBD', 'Si$', 0.00, '.sb', 'Solomon Islands', 'Oceania', 'Melanesia', '-8.00000000', '159.00000000', 'U+1F1F8 U+1F1E7', NULL, '2025-04-14 14:06:55'),
(196, 'SO', 'SOMALIA', 'Somalia', 'SOM', 706, 252, 'Mogadishu', 'SOS', 'Sh.so.', 0.00, '.so', 'Soomaaliya', 'Africa', 'Eastern Africa', '10.00000000', '49.00000000', 'U+1F1F8 U+1F1F4', NULL, '2025-04-14 14:06:55'),
(197, 'ZA', 'SOUTH AFRICA', 'South Africa', 'ZAF', 710, 27, 'Pretoria', 'ZAR', 'R', 0.00, '.za', 'South Africa', 'Africa', 'Southern Africa', '-29.00000000', '24.00000000', 'U+1F1FF U+1F1E6', NULL, '2025-04-14 14:06:55'),
(198, 'GS', 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS', 'South Georgia and the South Sandwich Islands', NULL, NULL, 0, 'Grytviken', 'GBP', '£', 0.00, '.gs', 'South Georgia', 'Americas', 'South America', '-54.50000000', '-37.00000000', 'U+1F1EC U+1F1F8', NULL, '2025-04-14 14:06:55'),
(199, 'ES', 'SPAIN', 'Spain', 'ESP', 724, 34, 'Madrid', 'EUR', '€', 0.00, '.es', 'España', 'Europe', 'Southern Europe', '40.00000000', '-4.00000000', 'U+1F1EA U+1F1F8', NULL, '2025-04-14 14:06:55'),
(200, 'LK', 'SRI LANKA', 'Sri Lanka', 'LKA', 144, 94, 'Colombo', 'LKR', 'Rs', 0.00, '.lk', 'śrī laṃkāva', 'Asia', 'Southern Asia', '7.00000000', '81.00000000', 'U+1F1F1 U+1F1F0', NULL, '2025-04-14 14:06:55'),
(201, 'SD', 'SUDAN', 'Sudan', 'SDN', 736, 249, 'Khartoum', 'SDG', '.س.ج', 0.00, '.sd', 'السودان', 'Africa', 'Northern Africa', '15.00000000', '30.00000000', 'U+1F1F8 U+1F1E9', NULL, '2025-04-14 14:06:55'),
(202, 'SR', 'SURINAME', 'Suriname', 'SUR', 740, 597, 'Paramaribo', 'SRD', '$', 0.00, '.sr', 'Suriname', 'Americas', 'South America', '4.00000000', '-56.00000000', 'U+1F1F8 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(203, 'SJ', 'SVALBARD AND JAN MAYEN', 'Svalbard and Jan Mayen', 'SJM', 744, 47, 'Longyearbyen', 'NOK', 'kr', 0.00, '.sj', 'Svalbard og Jan Mayen', 'Europe', 'Northern Europe', '78.00000000', '20.00000000', 'U+1F1F8 U+1F1EF', NULL, '2025-04-14 14:06:55'),
(204, 'SZ', 'SWAZILAND', 'Swaziland', 'SWZ', 748, 268, 'Mbabane', 'SZL', 'E', 0.00, '.sz', 'Swaziland', 'Africa', 'Southern Africa', '-26.50000000', '31.50000000', 'U+1F1F8 U+1F1FF', NULL, '2025-04-14 14:06:55'),
(205, 'SE', 'SWEDEN', 'Sweden', 'SWE', 752, 46, 'Stockholm', 'SEK', 'kr', 0.00, '.se', 'Sverige', 'Europe', 'Northern Europe', '62.00000000', '15.00000000', 'U+1F1F8 U+1F1EA', NULL, '2025-04-14 14:06:55'),
(206, 'CH', 'SWITZERLAND', 'Switzerland', 'CHE', 756, 41, 'Bern', 'CHF', 'CHf', 0.00, '.ch', 'Schweiz', 'Europe', 'Western Europe', '47.00000000', '8.00000000', 'U+1F1E8 U+1F1ED', NULL, '2025-04-14 14:06:55'),
(207, 'SY', 'SYRIAN ARAB REPUBLIC', 'Syrian Arab Republic', 'SYR', 760, 963, 'Damascus', 'SYP', 'LS', 0.00, '.sy', 'سوريا', 'Asia', 'Western Asia', '35.00000000', '38.00000000', 'U+1F1F8 U+1F1FE', NULL, '2025-04-14 14:06:55'),
(208, 'TW', 'TAIWAN, PROVINCE OF CHINA', 'Taiwan, Province of China', 'TWN', 158, 886, 'Taipei', 'TWD', '$', 0.00, '.tw', '臺灣', 'Asia', 'Eastern Asia', '23.50000000', '121.00000000', 'U+1F1F9 U+1F1FC', NULL, '2025-04-14 14:06:55'),
(209, 'TJ', 'TAJIKISTAN', 'Tajikistan', 'TJK', 762, 992, 'Dushanbe', 'TJS', 'SM', 0.00, '.tj', 'Тоҷикистон', 'Asia', 'Central Asia', '39.00000000', '71.00000000', 'U+1F1F9 U+1F1EF', NULL, '2025-04-14 14:06:55'),
(210, 'TZ', 'TANZANIA, UNITED REPUBLIC OF', 'Tanzania, United Republic of', 'TZA', 834, 255, 'Dodoma', 'TZS', 'TSh', 0.00, '.tz', 'Tanzania', 'Africa', 'Eastern Africa', '-6.00000000', '35.00000000', 'U+1F1F9 U+1F1FF', NULL, '2025-04-14 14:06:55'),
(211, 'TH', 'THAILAND', 'Thailand', 'THA', 764, 66, 'Bangkok', 'THB', '฿', 0.00, '.th', 'ประเทศไทย', 'Asia', 'South-Eastern Asia', '15.00000000', '100.00000000', 'U+1F1F9 U+1F1ED', NULL, '2025-04-14 14:06:55'),
(212, 'TL', 'TIMOR-LESTE', 'Timor-Leste', NULL, NULL, 670, 'Dili', 'USD', '$', 0.00, '.tl', 'Timor-Leste', 'Asia', 'South-Eastern Asia', '-8.83333333', '125.91666666', 'U+1F1F9 U+1F1F1', NULL, '2025-04-14 14:06:55'),
(213, 'TG', 'TOGO', 'Togo', 'TGO', 768, 228, 'Lome', 'XOF', 'CFA', 0.00, '.tg', 'Togo', 'Africa', 'Western Africa', '8.00000000', '1.16666666', 'U+1F1F9 U+1F1EC', NULL, '2025-04-14 14:06:55'),
(214, 'TK', 'TOKELAU', 'Tokelau', 'TKL', 772, 690, '', 'NZD', '$', 0.00, '.tk', 'Tokelau', 'Oceania', 'Polynesia', '-9.00000000', '-172.00000000', 'U+1F1F9 U+1F1F0', NULL, '2025-04-14 14:06:55'),
(215, 'TO', 'TONGA', 'Tonga', 'TON', 776, 676, 'Nuku\'alofa', 'TOP', '$', 0.00, '.to', 'Tonga', 'Oceania', 'Polynesia', '-20.00000000', '-175.00000000', 'U+1F1F9 U+1F1F4', NULL, '2025-04-14 14:06:55'),
(216, 'TT', 'TRINIDAD AND TOBAGO', 'Trinidad and Tobago', 'TTO', 780, 1868, 'Port of Spain', 'TTD', '$', 0.00, '.tt', 'Trinidad and Tobago', 'Americas', 'Caribbean', '11.00000000', '-61.00000000', 'U+1F1F9 U+1F1F9', NULL, '2025-04-14 14:06:55'),
(217, 'TN', 'TUNISIA', 'Tunisia', 'TUN', 788, 216, 'Tunis', 'TND', 'ت.د', 0.00, '.tn', 'تونس', 'Africa', 'Northern Africa', '34.00000000', '9.00000000', 'U+1F1F9 U+1F1F3', NULL, '2025-04-14 14:06:55'),
(218, 'TR', 'TURKEY', 'Turkey', 'TUR', 792, 90, 'Ankara', 'TRY', '₺', 0.00, '.tr', 'Türkiye', 'Asia', 'Western Asia', '39.00000000', '35.00000000', 'U+1F1F9 U+1F1F7', NULL, '2025-04-14 14:06:55'),
(219, 'TM', 'TURKMENISTAN', 'Turkmenistan', 'TKM', 795, 7370, 'Ashgabat', 'TMT', 'T', 0.00, '.tm', 'Türkmenistan', 'Asia', 'Central Asia', '40.00000000', '60.00000000', 'U+1F1F9 U+1F1F2', NULL, '2025-04-14 14:06:55'),
(220, 'TC', 'TURKS AND CAICOS ISLANDS', 'Turks and Caicos Islands', 'TCA', 796, 1649, 'Cockburn Town', 'USD', '$', 0.00, '.tc', 'Turks and Caicos Islands', 'Americas', 'Caribbean', '21.75000000', '-71.58333333', 'U+1F1F9 U+1F1E8', NULL, '2025-04-14 14:06:55'),
(221, 'TV', 'TUVALU', 'Tuvalu', 'TUV', 798, 688, 'Funafuti', 'AUD', '$', 0.00, '.tv', 'Tuvalu', 'Oceania', 'Polynesia', '-8.00000000', '178.00000000', 'U+1F1F9 U+1F1FB', NULL, '2025-04-14 14:06:55'),
(222, 'UG', 'UGANDA', 'Uganda', 'UGA', 800, 256, 'Kampala', 'UGX', 'USh', 0.00, '.ug', 'Uganda', 'Africa', 'Eastern Africa', '1.00000000', '32.00000000', 'U+1F1FA U+1F1EC', NULL, '2025-04-14 14:06:55'),
(223, 'UA', 'UKRAINE', 'Ukraine', 'UKR', 804, 380, 'Kiev', 'UAH', '₴', 0.00, '.ua', 'Україна', 'Europe', 'Eastern Europe', '49.00000000', '32.00000000', 'U+1F1FA U+1F1E6', NULL, '2025-04-14 14:06:55'),
(224, 'AE', 'UNITED ARAB EMIRATES', 'United Arab Emirates', 'ARE', 784, 971, 'Abu Dhabi', 'AED', 'إ.د', 0.00, '.ae', 'دولة الإمارات العربية المتحدة', 'Asia', 'Western Asia', '24.00000000', '54.00000000', 'U+1F1E6 U+1F1EA', NULL, '2025-04-14 14:06:55'),
(225, 'GB', 'UNITED KINGDOM', 'United Kingdom', 'GBR', 826, 44, 'London', 'GBP', '£', 0.00, '.uk', 'United Kingdom', 'Europe', 'Northern Europe', '54.00000000', '-2.00000000', 'U+1F1EC U+1F1E7', NULL, '2025-04-14 14:06:55'),
(226, 'US', 'UNITED STATES', 'United States', 'USA', 840, 1, 'Washington', 'USD', '$', 0.00, '.us', 'United States', 'Americas', 'Northern America', '38.00000000', '-97.00000000', 'U+1F1FA U+1F1F8', NULL, '2025-04-14 14:06:55'),
(227, 'UM', 'UNITED STATES MINOR OUTLYING ISLANDS', 'United States Minor Outlying Islands', NULL, NULL, 1, '', 'USD', '$', 0.00, '.us', 'United States Minor Outlying Islands', 'Americas', 'Northern America', '0.00000000', '0.00000000', 'U+1F1FA U+1F1F2', NULL, '2025-04-14 14:06:55'),
(228, 'UY', 'URUGUAY', 'Uruguay', 'URY', 858, 598, 'Montevideo', 'UYU', '$', 0.00, '.uy', 'Uruguay', 'Americas', 'South America', '-33.00000000', '-56.00000000', 'U+1F1FA U+1F1FE', NULL, '2025-04-14 14:06:55'),
(229, 'UZ', 'UZBEKISTAN', 'Uzbekistan', 'UZB', 860, 998, 'Tashkent', 'UZS', 'лв', 0.00, '.uz', 'O‘zbekiston', 'Asia', 'Central Asia', '41.00000000', '64.00000000', 'U+1F1FA U+1F1FF', NULL, '2025-04-14 14:06:55'),
(230, 'VU', 'VANUATU', 'Vanuatu', 'VUT', 548, 678, 'Port Vila', 'VUV', 'VT', 0.00, '.vu', 'Vanuatu', 'Oceania', 'Melanesia', '-16.00000000', '167.00000000', 'U+1F1FB U+1F1FA', NULL, '2025-04-14 14:06:55'),
(231, 'VE', 'VENEZUELA', 'Venezuela', 'VEN', 862, 58, 'Caracas', 'VEF', 'Bs', 0.00, '.ve', 'Venezuela', 'Americas', 'South America', '8.00000000', '-66.00000000', 'U+1F1FB U+1F1EA', NULL, '2025-04-14 14:06:56'),
(232, 'VN', 'VIET NAM', 'Viet Nam', 'VNM', 704, 84, 'Hanoi', 'VND', '₫', 0.00, '.vn', 'Việt Nam', 'Asia', 'South-Eastern Asia', '16.16666666', '107.83333333', 'U+1F1FB U+1F1F3', NULL, '2025-04-14 14:06:56');
INSERT INTO `countries` (`id`, `iso`, `name`, `nicename`, `iso3`, `numcode`, `phonecode`, `capital`, `currency`, `currency_symbol`, `currency_value`, `tld`, `native_name`, `region`, `subregion`, `latitude`, `longitude`, `emojiU`, `created_at`, `updated_at`) VALUES
(233, 'VG', 'VIRGIN ISLANDS, BRITISH', 'Virgin Islands, British', 'VGB', 92, 1284, 'Road Town', 'USD', '$', 0.00, '.vg', 'British Virgin Islands', 'Americas', 'Caribbean', '18.43138300', '-64.62305000', 'U+1F1FB U+1F1EC', NULL, '2025-04-14 14:06:56'),
(234, 'VI', 'VIRGIN ISLANDS, U.S.', 'Virgin Islands, U.s.', 'VIR', 850, 1340, 'Charlotte Amalie', 'USD', '$', 0.00, '.vi', 'United States Virgin Islands', 'Americas', 'Caribbean', '18.34000000', '-64.93000000', 'U+1F1FB U+1F1EE', NULL, '2025-04-14 14:06:56'),
(235, 'WF', 'WALLIS AND FUTUNA', 'Wallis and Futuna', 'WLF', 876, 681, 'Mata Utu', 'XPF', '₣', 0.00, '.wf', 'Wallis et Futuna', 'Oceania', 'Polynesia', '-13.30000000', '-176.20000000', 'U+1F1FC U+1F1EB', NULL, '2025-04-14 14:06:56'),
(236, 'EH', 'WESTERN SAHARA', 'Western Sahara', 'ESH', 732, 212, 'El-Aaiun', 'MAD', 'MAD', 0.00, '.eh', 'الصحراء الغربية', 'Africa', 'Northern Africa', '24.50000000', '-13.00000000', 'U+1F1EA U+1F1ED', NULL, '2025-04-14 14:06:56'),
(237, 'YE', 'YEMEN', 'Yemen', 'YEM', 887, 967, 'Sanaa', 'YER', '﷼', 0.00, '.ye', 'اليَمَن', 'Asia', 'Western Asia', '15.00000000', '48.00000000', 'U+1F1FE U+1F1EA', NULL, '2025-04-14 14:06:56'),
(238, 'ZM', 'ZAMBIA', 'Zambia', 'ZMB', 894, 260, 'Lusaka', 'ZMW', 'ZK', 0.00, '.zm', 'Zambia', 'Africa', 'Eastern Africa', '-15.00000000', '30.00000000', 'U+1F1FF U+1F1F2', NULL, '2025-04-14 14:06:56'),
(239, 'ZW', 'ZIMBABWE', 'Zimbabwe', 'ZWE', 716, 263, 'Harare', 'ZWL', '$', 0.00, '.zw', 'Zimbabwe', 'Africa', 'Eastern Africa', '-20.00000000', '30.00000000', 'U+1F1FF U+1F1FC', NULL, '2025-04-14 14:06:56'),
(240, 'RS', 'SERBIA', 'Serbia', 'SRB', 688, 381, 'Belgrade', 'RSD', 'din', 0.00, '.rs', 'Србија', 'Europe', 'Southern Europe', '44.00000000', '21.00000000', 'U+1F1F7 U+1F1F8', NULL, '2025-04-14 14:06:55'),
(241, 'AP', 'ASIA PACIFIC REGION', 'Asia / Pacific Region', '0', 0, 0, NULL, NULL, NULL, 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(242, 'ME', 'MONTENEGRO', 'Montenegro', 'MNE', 499, 382, 'Podgorica', 'EUR', '€', 0.00, '.me', 'Црна Гора', 'Europe', 'Southern Europe', '42.50000000', '19.30000000', 'U+1F1F2 U+1F1EA', NULL, '2025-04-14 14:06:55'),
(243, 'AX', 'ALAND ISLANDS', 'Aland Islands', 'ALA', 248, 358, 'Mariehamn', 'EUR', '€', 0.00, '.ax', 'Åland', 'Europe', 'Northern Europe', '60.11666700', '19.90000000', 'U+1F1E6 U+1F1FD', NULL, '2025-04-14 14:06:55'),
(244, 'BQ', 'BONAIRE, SINT EUSTATIUS AND SABA', 'Bonaire, Sint Eustatius and Saba', 'BES', 535, 599, 'Kralendijk', 'USD', '$', 0.00, '.an', 'Caribisch Nederland', 'Americas', 'Caribbean', '12.15000000', '-68.26666700', 'U+1F1E7 U+1F1F6', NULL, '2025-04-14 14:06:55'),
(245, 'CW', 'CURACAO', 'Curacao', 'CUW', 531, 599, 'Willemstad', 'ANG', 'ƒ', 0.00, '.cw', 'Curaçao', 'Americas', 'Caribbean', '12.11666700', '-68.93333300', 'U+1F1E8 U+1F1FC', NULL, '2025-04-14 14:06:55'),
(246, 'GG', 'GUERNSEY', 'Guernsey', 'GGY', 831, 44, 'St Peter Port', 'GBP', '£', 0.00, '.gg', 'Guernsey', 'Europe', 'Northern Europe', '49.46666666', '-2.58333333', 'U+1F1EC U+1F1EC', NULL, '2025-04-14 14:06:55'),
(247, 'IM', 'ISLE OF MAN', 'Isle of Man', 'IMN', 833, 44, 'Douglas, Isle of Man', 'GBP', '£', 0.00, '.im', 'Isle of Man', 'Europe', 'Northern Europe', '54.25000000', '-4.50000000', 'U+1F1EE U+1F1F2', NULL, '2025-04-14 14:06:55'),
(248, 'JE', 'JERSEY', 'Jersey', 'JEY', 832, 44, 'Saint Helier', 'GBP', '£', 0.00, '.je', 'Jersey', 'Europe', 'Northern Europe', '49.25000000', '-2.16666666', 'U+1F1EF U+1F1EA', NULL, '2025-04-14 14:06:55'),
(249, 'XK', 'KOSOVO', 'Kosovo', '---', 0, 381, 'Pristina', 'EUR', '€', 0.00, '.xk', 'Republika e Kosovës', 'Europe', 'Eastern Europe', '42.56129090', '20.34030350', 'U+1F1FD U+1F1F0', NULL, '2025-04-14 14:06:55'),
(250, 'BL', 'SAINT BARTHELEMY', 'Saint Barthelemy', 'BLM', 652, 590, 'Gustavia', 'EUR', '€', 0.00, '.bl', 'Saint-Barthélemy', 'Americas', 'Caribbean', '18.50000000', '-63.41666666', 'U+1F1E7 U+1F1F1', NULL, '2025-04-14 14:06:55'),
(251, 'MF', 'SAINT MARTIN', 'Saint Martin', 'MAF', 663, 590, 'Marigot', 'EUR', '€', 0.00, '.mf', 'Saint-Martin', 'Americas', 'Caribbean', '18.08333333', '-63.95000000', 'U+1F1F2 U+1F1EB', NULL, '2025-04-14 14:06:55'),
(252, 'SX', 'SINT MAARTEN', 'Sint Maarten', 'SXM', 534, 1, 'Philipsburg', 'ANG', 'ƒ', 0.00, '.sx', 'Sint Maarten', 'Americas', 'Caribbean', '18.03333300', '-63.05000000', 'U+1F1F8 U+1F1FD', NULL, '2025-04-14 14:06:55'),
(253, 'SS', 'SOUTH SUDAN', 'South Sudan', 'SSD', 728, 211, 'Juba', 'SSP', '£', 0.00, '.ss', 'South Sudan', 'Africa', 'Middle Africa', '7.00000000', '30.00000000', 'U+1F1F8 U+1F1F8', NULL, '2025-04-14 14:06:55');

-- --------------------------------------------------------

--
-- Table structure for table `coupons`
--

CREATE TABLE `coupons` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(191) NOT NULL,
  `start_date_time` datetime DEFAULT NULL,
  `end_date_time` datetime DEFAULT NULL,
  `uses_limit` int(11) DEFAULT NULL,
  `used_time` int(11) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `discount_type` enum('percentage','amount') NOT NULL DEFAULT 'percentage',
  `minimum_purchase_amount` int(11) NOT NULL DEFAULT 0,
  `days` text DEFAULT NULL,
  `status` enum('active','inactive','expire') NOT NULL DEFAULT 'active',
  `description` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `coupons`
--

INSERT INTO `coupons` (`id`, `title`, `start_date_time`, `end_date_time`, `uses_limit`, `used_time`, `amount`, `discount_type`, `minimum_purchase_amount`, `days`, `status`, `description`, `created_at`, `updated_at`) VALUES
(1, 'SUMMER10', '2025-04-17 04:02:00', '2025-04-30 04:02:00', 1, 1, 10, 'percentage', 50, '[\"Sunday\",\"Monday\",\"Tuesday\",\"Wednesday\",\"Thursday\",\"Friday\",\"Saturday\"]', 'active', '<p>Get Extra 10% Discount on your AC Services</p>', '2025-04-16 22:33:23', '2025-04-23 09:23:48');

-- --------------------------------------------------------

--
-- Table structure for table `coupon_users`
--

CREATE TABLE `coupon_users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `coupon_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `currencies`
--

CREATE TABLE `currencies` (
  `id` int(10) UNSIGNED NOT NULL,
  `currency_name` varchar(191) NOT NULL,
  `currency_symbol` varchar(191) NOT NULL,
  `currency_code` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `currencies`
--

INSERT INTO `currencies` (`id`, `currency_name`, `currency_symbol`, `currency_code`, `created_at`, `updated_at`) VALUES
(1, 'US Dollars', '$', 'USD', '2025-04-14 14:06:52', '2025-04-14 14:06:52'),
(2, 'Australian Dollar', '$', 'AUD', '2025-04-16 05:54:59', '2025-04-16 05:54:59');

-- --------------------------------------------------------

--
-- Table structure for table `currency_format_settings`
--

CREATE TABLE `currency_format_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `currency_position` enum('left','right','left_with_space','right_with_space') NOT NULL DEFAULT 'right',
  `no_of_decimal` int(10) UNSIGNED NOT NULL,
  `thousand_separator` varchar(191) DEFAULT NULL,
  `decimal_separator` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `currency_format_settings`
--

INSERT INTO `currency_format_settings` (`id`, `currency_position`, `no_of_decimal`, `thousand_separator`, `decimal_separator`) VALUES
(1, 'right', 2, ',', '.');

-- --------------------------------------------------------

--
-- Table structure for table `customer_feedback`
--

CREATE TABLE `customer_feedback` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `booking_id` int(10) UNSIGNED DEFAULT NULL,
  `customer_name` varchar(191) NOT NULL,
  `feedback_message` text NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'inactive',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `customer_feedback`
--

INSERT INTO `customer_feedback` (`id`, `user_id`, `booking_id`, `customer_name`, `feedback_message`, `status`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, 'Henry Dube', 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti\n                atque corrupti\n                quos. At vero eos et accusamus et iusto odio.', 'active', '2025-04-14 14:06:54', '2025-04-14 14:06:54'),
(2, NULL, NULL, 'John Doe', 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti\n                atque corrupti\n                quos. At vero eos et accusamus et iusto odio.', 'active', '2025-04-14 14:06:54', '2025-04-14 14:06:54'),
(3, NULL, NULL, 'Celena Gomez', 'At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti\n                atque corrupti\n                quos. At vero eos et accusamus et iusto odio.', 'active', '2025-04-14 14:06:54', '2025-04-14 14:06:54');

-- --------------------------------------------------------

--
-- Table structure for table `deals`
--

CREATE TABLE `deals` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) NOT NULL,
  `slug` varchar(191) DEFAULT NULL,
  `location_id` int(11) NOT NULL,
  `deal_type` varchar(191) NOT NULL,
  `start_date_time` datetime DEFAULT NULL,
  `end_date_time` datetime DEFAULT NULL,
  `open_time` time NOT NULL,
  `close_time` time NOT NULL,
  `uses_limit` int(11) DEFAULT NULL,
  `used_time` int(11) DEFAULT NULL,
  `original_amount` double DEFAULT NULL,
  `deal_amount` double DEFAULT NULL,
  `days` text DEFAULT NULL,
  `image` varchar(191) DEFAULT NULL,
  `status` enum('active','inactive','expire') NOT NULL DEFAULT 'active',
  `description` text DEFAULT NULL,
  `discount_type` varchar(191) NOT NULL,
  `percentage` int(11) DEFAULT NULL,
  `deal_applied_on` varchar(191) NOT NULL,
  `max_order_per_customer` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `deals`
--

INSERT INTO `deals` (`id`, `title`, `slug`, `location_id`, `deal_type`, `start_date_time`, `end_date_time`, `open_time`, `close_time`, `uses_limit`, `used_time`, `original_amount`, `deal_amount`, `days`, `image`, `status`, `description`, `discount_type`, `percentage`, `deal_applied_on`, `max_order_per_customer`, `created_at`, `updated_at`) VALUES
(1, '30% Off', '30-off', 2, '', '2025-04-16 17:00:00', '2025-05-31 13:59:00', '14:49:00', '13:47:00', NULL, NULL, 150, 105, '[\"Sunday\",\"Monday\",\"Tuesday\",\"Wednesday\",\"Thursday\",\"Friday\",\"Saturday\"]', 'ff3717dae252fd8c2b8e5266221928d0.png', 'active', NULL, 'percentage', 30, 'service', 1, '2025-04-16 22:21:18', '2025-04-16 22:21:18'),
(2, '30% Off', '30-off-1', 2, '', '2025-04-16 17:00:00', '2025-05-31 13:59:00', '14:49:00', '13:47:00', NULL, 1, 300, 150, '[\"Sunday\",\"Monday\",\"Tuesday\",\"Wednesday\",\"Thursday\",\"Friday\",\"Saturday\"]', 'ba0ac6ca2bb9ff74a36a37a6312ef7ea.png', 'active', NULL, 'percentage', 50, 'service', 1, '2025-04-16 22:22:40', '2025-04-23 09:38:15');

-- --------------------------------------------------------

--
-- Table structure for table `deal_items`
--

CREATE TABLE `deal_items` (
  `id` int(10) UNSIGNED NOT NULL,
  `deal_id` int(10) UNSIGNED DEFAULT NULL,
  `business_service_id` int(10) UNSIGNED DEFAULT NULL,
  `quantity` tinyint(4) NOT NULL,
  `unit_price` double NOT NULL,
  `discount_amount` double NOT NULL,
  `total_amount` double NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_groups`
--

CREATE TABLE `employee_groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) DEFAULT NULL,
  `status` enum('active','deactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_group_services`
--

CREATE TABLE `employee_group_services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `employee_groups_id` int(10) UNSIGNED DEFAULT NULL,
  `business_service_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employee_schedules`
--

CREATE TABLE `employee_schedules` (
  `id` int(10) UNSIGNED NOT NULL,
  `location_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `is_working` varchar(191) NOT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `days` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `employee_schedules`
--

INSERT INTO `employee_schedules` (`id`, `location_id`, `employee_id`, `is_working`, `start_time`, `end_time`, `days`, `created_at`, `updated_at`) VALUES
(15, 2, 4, 'yes', '09:00:00', '18:00:00', 'monday', '2025-04-23 09:28:12', '2025-04-23 09:28:12'),
(16, 2, 4, 'yes', '09:00:00', '18:00:00', 'tuesday', '2025-04-23 09:28:12', '2025-04-23 09:28:12'),
(17, 2, 4, 'yes', '09:00:00', '18:00:00', 'wednesday', '2025-04-23 09:28:12', '2025-04-23 09:28:12'),
(18, 2, 4, 'yes', '09:00:00', '18:00:00', 'thursday', '2025-04-23 09:28:12', '2025-04-23 09:28:12'),
(19, 2, 4, 'yes', '09:00:00', '18:00:00', 'friday', '2025-04-23 09:28:12', '2025-04-23 09:28:12'),
(20, 2, 4, 'yes', '09:00:00', '18:00:00', 'saturday', '2025-04-23 09:28:12', '2025-04-23 09:28:12'),
(21, 2, 4, 'yes', '09:00:00', '18:00:00', 'sunday', '2025-04-23 09:28:12', '2025-04-23 09:28:12');

-- --------------------------------------------------------

--
-- Table structure for table `footer_settings`
--

CREATE TABLE `footer_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `social_links` text DEFAULT NULL,
  `footer_text` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `footer_settings`
--

INSERT INTO `footer_settings` (`id`, `social_links`, `footer_text`, `created_at`, `updated_at`) VALUES
(1, '[{\"name\":\"facebook\",\"link\":\"https:\\/\\/facebook.com\"},{\"name\":\"twitter\",\"link\":\"https:\\/\\/twitter.com\"},{\"name\":\"youtube\",\"link\":\"https:\\/\\/youtube.com\"},{\"name\":\"instagram\",\"link\":\"https:\\/\\/instagram.com\"},{\"name\":\"linkedin\",\"link\":\"https:\\/\\/linkedin.com\"}]', 'ABC. © 2025 - 2025 All Rights Reserved.', '2025-04-14 14:06:54', '2025-04-16 06:05:28');

-- --------------------------------------------------------

--
-- Table structure for table `front_theme_settings`
--

CREATE TABLE `front_theme_settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) DEFAULT NULL,
  `primary_color` varchar(191) NOT NULL,
  `secondary_color` varchar(191) NOT NULL,
  `custom_css` longtext DEFAULT NULL,
  `custom_js` varchar(191) DEFAULT NULL,
  `logo` varchar(191) DEFAULT NULL,
  `favicon` varchar(191) DEFAULT NULL,
  `carousel_status` enum('enabled','disabled') NOT NULL DEFAULT 'enabled',
  `carousel_autoplay` enum('enabled','disabled') NOT NULL DEFAULT 'enabled',
  `seo_description` varchar(191) NOT NULL,
  `seo_keywords` varchar(191) NOT NULL,
  `front_theme` enum('theme-1','theme-2') NOT NULL DEFAULT 'theme-2',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `front_theme_settings`
--

INSERT INTO `front_theme_settings` (`id`, `title`, `primary_color`, `secondary_color`, `custom_css`, `custom_js`, `logo`, `favicon`, `carousel_status`, `carousel_autoplay`, `seo_description`, `seo_keywords`, `front_theme`, `created_at`, `updated_at`) VALUES
(1, 'Appointo', '#000000', '#80B6E7', '/*Enter your custom css after this line*/', NULL, '4d919bba41c90f732cf442be4c4c39f5.png', '77488d571b6a8d64e4ee963a1f1b860e.png', 'enabled', 'enabled', '', '', 'theme-2', NULL, '2025-04-16 22:56:53');

-- --------------------------------------------------------

--
-- Table structure for table `google_captcha_settings`
--

CREATE TABLE `google_captcha_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'inactive',
  `v2_status` enum('active','inactive') NOT NULL DEFAULT 'inactive',
  `v2_site_key` varchar(191) DEFAULT NULL,
  `v2_secret_key` varchar(191) DEFAULT NULL,
  `v3_status` enum('active','inactive') NOT NULL DEFAULT 'inactive',
  `v3_site_key` varchar(191) DEFAULT NULL,
  `v3_secret_key` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `google_captcha_settings`
--

INSERT INTO `google_captcha_settings` (`id`, `status`, `v2_status`, `v2_site_key`, `v2_secret_key`, `v3_status`, `v3_site_key`, `v3_secret_key`, `created_at`, `updated_at`) VALUES
(1, 'inactive', 'inactive', NULL, NULL, 'inactive', NULL, NULL, '2025-04-14 14:06:54', '2025-04-14 14:06:54');

-- --------------------------------------------------------

--
-- Table structure for table `google_map_api_keys`
--

CREATE TABLE `google_map_api_keys` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `google_map_api_key` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `item_taxes`
--

CREATE TABLE `item_taxes` (
  `id` int(10) UNSIGNED NOT NULL,
  `tax_id` int(10) UNSIGNED DEFAULT NULL,
  `service_id` int(10) UNSIGNED DEFAULT NULL,
  `deal_id` int(10) UNSIGNED DEFAULT NULL,
  `product_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `item_taxes`
--

INSERT INTO `item_taxes` (`id`, `tax_id`, `service_id`, `deal_id`, `product_id`, `created_at`, `updated_at`) VALUES
(3, 1, NULL, 1, NULL, '2025-04-16 22:21:18', '2025-04-16 22:21:18'),
(4, 1, NULL, 2, NULL, '2025-04-16 22:22:40', '2025-04-16 22:22:40'),
(7, 1, NULL, NULL, 1, '2025-04-16 22:31:50', '2025-04-16 22:31:50'),
(12, 1, 6, NULL, NULL, '2025-04-16 23:54:42', '2025-04-16 23:54:42'),
(13, 1, 5, NULL, NULL, '2025-04-23 09:42:18', '2025-04-23 09:42:18');

-- --------------------------------------------------------

--
-- Table structure for table `languages`
--

CREATE TABLE `languages` (
  `id` int(10) UNSIGNED NOT NULL,
  `language_code` varchar(191) NOT NULL,
  `language_name` varchar(191) NOT NULL,
  `status` enum('enabled','disabled') NOT NULL DEFAULT 'disabled',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `languages`
--

INSERT INTO `languages` (`id`, `language_code`, `language_name`, `status`, `created_at`, `updated_at`) VALUES
(1, 'es', 'Spanish', 'disabled', '2025-04-14 14:06:52', '2025-04-14 14:06:52'),
(2, 'en', 'English', 'enabled', '2025-04-14 14:06:53', '2025-04-14 14:06:53');

-- --------------------------------------------------------

--
-- Table structure for table `leaves`
--

CREATE TABLE `leaves` (
  `id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `leave_type` varchar(191) NOT NULL,
  `status` enum('pending','approved','rejected') NOT NULL,
  `reason` varchar(191) DEFAULT NULL,
  `approved_by` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `locations`
--

CREATE TABLE `locations` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `lat` double NOT NULL,
  `lng` double NOT NULL,
  `pincode` varchar(191) DEFAULT NULL,
  `country_id` int(10) UNSIGNED DEFAULT NULL,
  `timezone_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `locations`
--

INSERT INTO `locations` (`id`, `name`, `lat`, `lng`, `pincode`, `country_id`, `timezone_id`, `created_at`, `updated_at`) VALUES
(2, 'Sydney, Australia', 33.8688, 151.2093, '12203', 13, 46, '2025-04-16 05:36:42', '2025-04-16 05:36:42');

-- --------------------------------------------------------

--
-- Table structure for table `location_user`
--

CREATE TABLE `location_user` (
  `location_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `location_user`
--

INSERT INTO `location_user` (`location_id`, `user_id`) VALUES
(2, 4);

-- --------------------------------------------------------

--
-- Table structure for table `ltm_translations`
--

CREATE TABLE `ltm_translations` (
  `id` int(10) UNSIGNED NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `locale` varchar(191) NOT NULL,
  `group` varchar(191) NOT NULL,
  `key` text NOT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE `media` (
  `id` int(10) UNSIGNED NOT NULL,
  `file_name` varchar(191) NOT NULL,
  `is_section_content` enum('yes','no') DEFAULT 'no',
  `have_content` enum('yes','no') DEFAULT 'no',
  `section_title` longtext DEFAULT NULL,
  `title_note` longtext DEFAULT NULL,
  `section_content` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `content_alignment` enum('left','right') DEFAULT 'left'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `media`
--

INSERT INTO `media` (`id`, `file_name`, `is_section_content`, `have_content`, `section_title`, `title_note`, `section_content`, `created_at`, `updated_at`, `content_alignment`) VALUES
(5, '1744784731.png', 'no', 'no', NULL, NULL, NULL, '2025-04-16 06:25:31', '2025-04-16 06:25:31', 'left'),
(6, '1744784768.png', 'no', 'no', NULL, NULL, NULL, '2025-04-16 06:26:08', '2025-04-16 06:26:08', 'left'),
(7, '1744784843.png', 'no', 'no', NULL, NULL, NULL, '2025-04-16 06:27:23', '2025-04-16 06:27:23', 'left'),
(9, 'f99480511fd0da740a9615c414ae12c1.jpg', 'yes', 'yes', 'This is a New Section', 'We are now Available At Perth', '<p>Welcome to Perth, Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,Welcome to Perth,</p>', '2025-04-23 10:19:46', '2025-04-23 10:19:46', 'left');

-- --------------------------------------------------------

--
-- Table structure for table `memberships`
--

CREATE TABLE `memberships` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `duration_days` int(10) UNSIGNED NOT NULL,
  `discount_percent` tinyint(3) UNSIGNED DEFAULT 20,
  `description` text DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `memberships`
--

INSERT INTO `memberships` (`id`, `name`, `price`, `duration_days`, `discount_percent`, `description`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Basic Plan', 200.00, 30, 20, 'This is a test', 'active', '2025-05-01 18:11:17', '2025-05-01 19:19:16'),
(2, 'Advanced Plan', 300.00, 30, 30, 'This is another test', 'active', '2025-05-01 19:21:08', '2025-05-01 19:21:34');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_04_02_193005_create_translations_table', 1),
(2, '2014_10_12_000000_create_users_table', 1),
(3, '2014_10_12_100000_create_password_resets_table', 1),
(4, '2018_09_06_071923_create_categories_table', 1),
(5, '2018_09_11_093015_create_business_services_table', 1),
(6, '2018_09_11_173520_create_bookings_table', 1),
(7, '2018_09_11_174709_add_discount_column_serices_table', 1),
(8, '2018_09_11_184348_create_tax_settings_table', 1),
(9, '2018_09_12_151158_create_booking_times_table', 1),
(10, '2018_09_18_064516_add_mobile_column_users_table', 1),
(11, '2018_09_19_095300_add_status_column_categories_table', 1),
(12, '2018_09_19_095530_add_status_column_booking_services_table', 1),
(13, '2018_09_20_130124_create_currencies_table', 1),
(14, '2018_09_20_131417_create_company_settings_table', 1),
(15, '2018_09_25_112040_create_booking_items_table', 1),
(16, '2018_09_28_074544_add_columns_bookings_table', 1),
(17, '2018_10_03_182207_create_languages_table', 1),
(18, '2018_10_04_100225_add_spanish_language', 1),
(19, '2018_10_04_112244_create_smtp_settings_table', 1),
(20, '2018_10_08_122033_add_image_users_table', 1),
(21, '2018_10_09_121006_create_theme_settings_table', 1),
(22, '2018_10_15_123811_add_time_slot_duration_booing_times_table', 1),
(23, '2018_11_01_091108_add_is_admin_column_users_table', 1),
(24, '2018_11_02_052534_add_topbar_textcolor_column_theme_settings', 1),
(25, '2018_12_03_104905_change_tax_column_nullable_bookings_table', 1),
(26, '2018_12_19_192042_add_source_column_bookings_table', 1),
(27, '2018_12_20_115707_allow_soft_delete_user', 1),
(28, '2018_12_27_053940_create_payment_gateway_credential_table', 1),
(29, '2018_12_27_064431_create_payments_table', 1),
(30, '2019_01_03_192042_alter_credential_table', 1),
(31, '2019_01_31_111812_add_multiple_booking_column_booking_times_table', 1),
(32, '2019_02_10_075422_add_addition_notes_column_bookings_table', 1),
(33, '2019_04_08_053940_create_employee_groups_table', 1),
(34, '2019_04_08_075422_alter_user_employee_table', 1),
(35, '2019_04_08_085422_alter_booking_group_table', 1),
(36, '2019_08_06_104829_create_media_table', 1),
(37, '2019_08_08_071516_create_locations_table', 1),
(38, '2019_08_08_095010_add_location_id_column_in_business_services_table', 1),
(39, '2019_08_13_073129_update_settings_add_envato_key', 1),
(40, '2019_08_13_073129_update_settings_add_support_key', 1),
(41, '2019_08_14_093126_alter_booking_times_and_bookings_table', 1),
(42, '2019_08_14_121322_create_front_theme_settings_table', 1),
(43, '2019_08_27_043810_create_pages_table', 1),
(44, '2019_08_28_081847_update_smtp_setting_verified', 1),
(45, '2019_09_03_110646_add_slug_field_in_categories_and_business_services_table', 1),
(46, '2019_09_17_083105_create_sms_settings_table', 1),
(47, '2019_09_18_115145_add_mobile_verified_column_in_users_table', 1),
(48, '2019_09_23_064129_create_universal_search_table', 1),
(49, '2019_10_07_073041_add_status_column_in_languages_table', 1),
(50, '2019_10_14_084220_alter_foreign_key_in_business_services_table', 1),
(51, '2019_11_07_065036_alter_status_of_payments_table', 1),
(52, '2019_11_13_090143_add_date_and_time_format_columns_in_company_settings_table', 1),
(53, '2019_11_14_085440_add_unique_slugs_to_categories_and_services_tables', 1),
(54, '2019_11_14_121846_laratrust_setup_tables', 1),
(55, '2019_11_18_121633_create_modules_table', 1),
(56, '2019_11_25_043859_remove_is_admin_and_is_employee_columns_from_users_table', 1),
(57, '2019_11_25_092025_seed_booking_times_table', 1),
(58, '2019_11_26_092726_create_payments_for_pos_bookings', 1),
(59, '2019_11_27_065035_add_max_booking_column_in_booking_times_table', 1),
(60, '2019_11_28_075109_add_razorpay_details_in_payment_gateway_credentials_table', 1),
(61, '2019_12_02_085713_add_paypal_mode_column_in_payment_gateway_credentials_table', 1),
(62, '2019_12_02_112618_alter_status_column_in_bookings_table', 1),
(63, '2019_12_04_063825_run_permission_change_command', 1),
(64, '2019_12_04_071454_add_english_row_in_languages_table', 1),
(65, '2019_12_05_102158_add_default_image_column_in_business_services_table', 1),
(66, '2019_12_06_071155_alter_image_column_to_text_in_business_services_table', 1),
(67, '2019_12_12_083028_remove_pos_module_from_modules_table', 1),
(68, '2019_12_12_110226_add_show_payment_column_in_payment_gateway_credentials_table', 1),
(69, '2019_12_12_121633_create_coupons_table', 1),
(70, '2019_12_13_053737_add_custom_css_column_in_front_and_admin_theme_settings_tables', 1),
(71, '2019_12_13_081452_create_todo_items_table', 1),
(72, '2019_12_13_121633_create_coupon_users_table', 1),
(73, '2019_12_18_085713_add_coupon_id_column_in_bookings_table', 1),
(74, '2019_12_23_085713_remove_field_in_coupon_table', 1),
(75, '2020_01_16_084419_change_customers_to_employees_in_universal_searches_table', 1),
(76, '2020_02_03_123340_alter_foreign_key_in_company_settings_table', 1),
(77, '2020_03_02_121855_alter_employees_and_customers_in_universal_searches_table', 1),
(78, '2020_03_20_102434_create_booking_user_table', 1),
(79, '2020_03_21_130010_create_business_service_user_table', 1),
(80, '2020_03_23_083957_add_multi_task_user_to_company_settings', 1),
(81, '2020_04_03_122036_remove_employee_id_column_bookings_table', 1),
(82, '2020_04_10_155242_create_deals_table', 1),
(83, '2020_04_17_083036_add_deal_id_column_to_bookings_table', 1),
(84, '2020_04_17_083138_create_deal_items_table', 1),
(85, '2020_04_29_103926_add_slug_column_to_deal_table', 1),
(86, '2020_05_11_112146_add_booking_per_day_column_to_company_settings_table', 1),
(87, '2020_05_18_052041_add_employee_selection_column_to_company_settings_table', 1),
(88, '2020_05_28_061604_add_two_columns_to_company_settings_table', 1),
(89, '2020_06_02_031736_create_employee_group_services_table', 1),
(90, '2020_06_30_082856_add_7_columns_to_deals_table', 1),
(91, '2020_07_07_101959_create_coupon_and_deal_module', 1),
(92, '2020_10_27_113311_add_carousel_status_column_to_front_theme_settings_table', 1),
(93, '2020_11_03_111316_seo_details_in_front_theme_settings', 1),
(94, '2020_11_04_090145_create_leaves_table', 1),
(95, '2020_12_03_071029_create_employee_schedules_table', 1),
(96, '2020_12_14_050828_add_schedule', 1),
(97, '2021_02_05_070704_add_leaves_columns_table', 1),
(98, '2021_02_12_092251_create_products_table', 1),
(99, '2021_02_16_121052_add_product_id_in_booking_items', 1),
(100, '2021_02_17_083722_add_product_amount_in_booking_table', 1),
(101, '2021_04_07_085532_add_paystack_to_payment_table', 1),
(102, '2021_04_12_064148_add_choose_theme_option_in_front_theme_settings_table', 1),
(103, '2021_04_12_114507_add_blog_and_terms_conditions_in_universal_searches_table', 1),
(104, '2021_04_14_051737_add_front_section_content_in_media_table', 1),
(105, '2021_04_16_064541_create_customer_feedback_table', 1),
(106, '2021_04_16_094147_add_getstarted_note_column_in_company_settings_table', 1),
(107, '2021_04_16_110055_create_footer_settings_table', 1),
(108, '2021_05_27_065105_create_office__leaves_table', 1),
(109, '2021_06_01_114624_add_two_columns_in_company_settings', 1),
(110, '2021_06_09_055655_add_new_column_to_booking_times', 1),
(111, '2021_06_14_085715_create_currency_format_settings_table', 1),
(112, '2021_06_30_114051_add_google_o_auth_ids_to_company_settings_table', 1),
(113, '2021_06_30_114052_add_google_event_id_to_bookings_table', 1),
(114, '2021_07_02_054512_add_favicon_column_in_front_theme_settings_table', 1),
(115, '2021_07_06_100049_create_booking_notifactions_table', 1),
(116, '2021_07_06_112554_create_item_taxes_table', 1),
(117, '2021_07_06_112726_change_tax_settings_table_name', 1),
(118, '2021_07_06_112923_add_tax_for_services_and_deals_in_tax_settings_table', 1),
(119, '2021_07_09_053020_add_notifaction_column_to_bookings_table', 1),
(120, '2021_07_15_091656_add_msg91_column_to_sms_settings_table', 1),
(121, '2021_08_16_045608_create_google_captcha_settings_table', 1),
(122, '2021_08_23_062919_create_social_auth_settings_table', 1),
(123, '2021_09_03_091733_add_rtl_column_in_users_table', 1),
(124, '2021_09_20_063352_create_countries_table', 1),
(125, '2021_09_21_080945_create_addresses_table', 1),
(126, '2021_12_02_082154_add_discount_type_column_to_coupons_table', 1),
(127, '2021_12_07_115030_update_datatype_of_address_in_addresses_table', 1),
(128, '2021_12_07_115445_update_datatype_of_image_in_products_table', 1),
(129, '2021_12_14_084635_create_zoom_settings_table', 1),
(130, '2021_12_14_102113_add_service_type_in_business_services_table', 1),
(131, '2021_12_14_111046_create_zoom_meetings_table', 1),
(132, '2021_12_28_055716_add_sections_in_pages_table', 1),
(133, '2021_12_30_052531_add_amount_remaining_column_in_payments', 1),
(134, '2022_01_03_090124_add_amount_paid_coloumn_in_payments_table', 1),
(135, '2022_01_25_072348_add_image_to_pages_table', 1),
(136, '2022_02_01_092128_create_advertisement_banners_table', 1),
(137, '2022_02_04_063542_add_date_to_advertisement_banners_table', 1),
(138, '2022_02_07_061020_create_advertisement_module', 1),
(139, '2022_02_10_113530_add_crone_column_table', 1),
(140, '2022_02_11_055749_alter_countries_table', 1),
(141, '2022_02_11_070804_add_two_column_in_locations_table', 1),
(142, '2022_02_17_060431_add_location_id_column_in_booking_times_table', 1),
(143, '2022_02_17_084850_create_location_user_table', 1),
(144, '2022_02_23_064437_add_carousel_autoplay_to_front_theme_settings_table', 1),
(145, '2022_02_24_090708_create_new_deals_table', 1),
(146, '2022_03_01_062803_add_lat_and_long_column_to_locations_table', 1),
(147, '2022_03_04_094839_create_google_map_api_keys_table', 1),
(148, '2022_03_14_111129_add_enum_column_to_bookings_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `modules`
--

CREATE TABLE `modules` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `display_name` varchar(191) NOT NULL,
  `description` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `modules`
--

INSERT INTO `modules` (`id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'location', 'Location', 'modules.module.locationDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(2, 'category', 'Category', 'modules.module.categoryDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(3, 'business_service', 'Business Service', 'modules.module.businessServiceDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(4, 'customer', 'Customer', 'modules.module.customerDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(5, 'employee', 'Employee', 'modules.module.employeeDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(6, 'employee_group', 'Employee Group', 'modules.module.employeeGroupDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(7, 'coupon', 'Coupon', 'modules.module.couponDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(8, 'deal', 'Deal', 'modules.module.dealDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(9, 'booking', 'Booking', 'modules.module.bookingDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(10, 'report', 'Report', 'modules.module.reportDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(11, 'settings', 'Settings', 'modules.module.settingsDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(12, 'advertisement_banner', 'Advertisement Banner', 'modules.module.advertisementBannerDescription', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(13, 'memberships', 'Memberships', 'modules.module.memberships', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(14, 'reviews', 'Reviews', 'modules.module.reviews', '2025-04-14 14:06:53', '2025-04-14 14:06:53');

-- --------------------------------------------------------

--
-- Table structure for table `new_deals`
--

CREATE TABLE `new_deals` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `image` varchar(191) NOT NULL,
  `location_id` int(10) UNSIGNED NOT NULL,
  `link` varchar(191) NOT NULL,
  `status` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `new_deals`
--

INSERT INTO `new_deals` (`id`, `image`, `location_id`, `link`, `status`, `created_at`, `updated_at`) VALUES
(1, 'a02065be8db1e216f73976fa472afece.png', 2, 'https://azure-zebra-384245.hostingersite.com/', 'active', '2025-04-16 06:06:39', '2025-04-16 06:06:39');

-- --------------------------------------------------------

--
-- Table structure for table `office_leaves`
--

CREATE TABLE `office_leaves` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `slug` varchar(150) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `section` enum('who we are','support') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `pages`
--

INSERT INTO `pages` (`id`, `image`, `title`, `content`, `slug`, `created_at`, `updated_at`, `section`) VALUES
(1, NULL, 'About Us', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', 'about-us', '2025-04-14 14:06:53', '2025-04-14 14:06:54', 'who we are'),
(2, NULL, 'Contact Us', '<h2>Contact Us</h2>\n\n                <p>How can we help you? We will try to get back to you as soon as possible.</p>', 'contact-us', '2025-04-14 14:06:53', '2025-04-14 14:06:54', 'support'),
(3, NULL, 'How It Works', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', 'how-it-works', '2025-04-14 14:06:53', '2025-04-14 14:06:54', 'who we are'),
(4, NULL, 'Privacy Policy', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', 'privacy-policy', '2025-04-14 14:06:53', '2025-04-14 14:06:54', 'support'),
(5, NULL, 'Blog', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', 'blog', '2025-04-14 14:06:54', '2025-04-14 14:06:54', 'who we are'),
(6, NULL, 'Terms And Conditions', 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', 'terms-and-conditions', '2025-04-14 14:06:54', '2025-04-14 14:06:54', 'support');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` int(10) UNSIGNED NOT NULL,
  `currency_id` int(11) DEFAULT NULL,
  `booking_id` int(10) UNSIGNED NOT NULL,
  `amount` double NOT NULL,
  `amount_remaining` double DEFAULT NULL,
  `amount_paid` double DEFAULT NULL,
  `gateway` varchar(191) DEFAULT NULL,
  `transaction_id` varchar(191) DEFAULT NULL,
  `status` enum('completed','pending') NOT NULL DEFAULT 'pending',
  `paid_on` datetime DEFAULT NULL,
  `customer_id` varchar(191) DEFAULT NULL,
  `event_id` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `payments`
--

INSERT INTO `payments` (`id`, `currency_id`, `booking_id`, `amount`, `amount_remaining`, `amount_paid`, `gateway`, `transaction_id`, `status`, `paid_on`, `customer_id`, `event_id`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 70, NULL, NULL, 'cash', NULL, 'completed', '2025-04-23 09:50:10', NULL, NULL, '2025-04-23 09:50:10', '2025-04-23 09:50:10');

-- --------------------------------------------------------

--
-- Table structure for table `payment_gateway_credentials`
--

CREATE TABLE `payment_gateway_credentials` (
  `id` int(10) UNSIGNED NOT NULL,
  `paypal_client_id` varchar(191) DEFAULT NULL,
  `paypal_secret` varchar(191) DEFAULT NULL,
  `stripe_client_id` varchar(191) DEFAULT NULL,
  `stripe_secret` varchar(191) DEFAULT NULL,
  `stripe_webhook_secret` varchar(191) DEFAULT NULL,
  `stripe_status` enum('active','deactive') NOT NULL DEFAULT 'deactive',
  `paystack_public_id` varchar(191) DEFAULT NULL,
  `paystack_secret_id` varchar(191) DEFAULT NULL,
  `paystack_webhook_secret` varchar(191) DEFAULT NULL,
  `paystack_status` enum('active','deactive') NOT NULL DEFAULT 'deactive',
  `paypal_status` enum('active','deactive') NOT NULL DEFAULT 'deactive',
  `paypal_mode` enum('sandbox','live') NOT NULL DEFAULT 'sandbox',
  `offline_payment` enum('0','1') NOT NULL DEFAULT '1',
  `show_payment_options` enum('hide','show') NOT NULL DEFAULT 'show',
  `razorpay_key` varchar(191) DEFAULT NULL,
  `razorpay_secret` varchar(191) DEFAULT NULL,
  `razorpay_status` enum('active','deactive') NOT NULL DEFAULT 'deactive',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `payment_gateway_credentials`
--

INSERT INTO `payment_gateway_credentials` (`id`, `paypal_client_id`, `paypal_secret`, `stripe_client_id`, `stripe_secret`, `stripe_webhook_secret`, `stripe_status`, `paystack_public_id`, `paystack_secret_id`, `paystack_webhook_secret`, `paystack_status`, `paypal_status`, `paypal_mode`, `offline_payment`, `show_payment_options`, `razorpay_key`, `razorpay_secret`, `razorpay_status`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, NULL, NULL, NULL, 'active', NULL, NULL, NULL, 'deactive', 'active', 'sandbox', '1', 'show', NULL, NULL, 'deactive', '2025-04-14 14:06:52', '2025-04-14 14:06:52');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `module_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `display_name` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `module_id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 1, 'create_location', 'Create Location', 'Create Location', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(2, 1, 'read_location', 'Read Location', 'Read Location', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(3, 1, 'update_location', 'Update Location', 'Update Location', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(4, 1, 'delete_location', 'Delete Location', 'Delete Location', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(5, 2, 'create_category', 'Create Category', 'Create Category', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(6, 2, 'read_category', 'Read Category', 'Read Category', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(7, 2, 'update_category', 'Update Category', 'Update Category', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(8, 2, 'delete_category', 'Delete Category', 'Delete Category', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(9, 3, 'create_business_service', 'Create Business Service', 'Create Business Service', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(10, 3, 'read_business_service', 'Read Business Service', 'Read Business Service', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(11, 3, 'update_business_service', 'Update Business Service', 'Update Business Service', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(12, 3, 'delete_business_service', 'Delete Business Service', 'Delete Business Service', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(13, 4, 'create_customer', 'Create Customer', 'Create Customer', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(14, 4, 'read_customer', 'Read Customer', 'Read Customer', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(15, 4, 'update_customer', 'Update Customer', 'Update Customer', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(16, 4, 'delete_customer', 'Delete Customer', 'Delete Customer', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(17, 5, 'create_employee', 'Create Employee', 'Create Employee', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(18, 5, 'read_employee', 'Read Employee', 'Read Employee', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(19, 5, 'update_employee', 'Update Employee', 'Update Employee', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(20, 5, 'delete_employee', 'Delete Employee', 'Delete Employee', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(21, 6, 'create_employee_group', 'Create Employee Group', 'Create Employee Group', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(22, 6, 'read_employee_group', 'Read Employee Group', 'Read Employee Group', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(23, 6, 'update_employee_group', 'Update Employee Group', 'Update Employee Group', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(24, 6, 'delete_employee_group', 'Delete Employee Group', 'Delete Employee Group', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(25, 7, 'create_coupon', 'Create Coupon', 'Create Coupon', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(26, 7, 'read_coupon', 'Read Coupon', 'Read Coupon', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(27, 7, 'update_coupon', 'Update Coupon', 'Update Coupon', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(28, 7, 'delete_coupon', 'Delete Coupon', 'Delete Coupon', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(29, 8, 'create_deal', 'Create Deal', 'Create Deal', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(30, 8, 'read_deal', 'Read Deal', 'Read Deal', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(31, 8, 'update_deal', 'Update Deal', 'Update Deal', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(32, 8, 'delete_deal', 'Delete Deal', 'Delete Deal', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(33, 9, 'create_booking', 'Create Booking', 'Create Booking', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(34, 9, 'read_booking', 'Read Booking', 'Read Booking', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(35, 9, 'update_booking', 'Update Booking', 'Update Booking', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(36, 9, 'delete_booking', 'Delete Booking', 'Delete Booking', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(37, 10, 'create_report', 'Create Report', 'Create Report', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(38, 10, 'read_report', 'Read Report', 'Read Report', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(39, 10, 'update_report', 'Update Report', 'Update Report', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(40, 10, 'delete_report', 'Delete Report', 'Delete Report', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(41, 11, 'manage_settings', 'Manage Settings', 'Manage Settings', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(42, 12, 'create_advertisement_banner', 'Create Advertisement Banner', 'Create Advertisement Banner', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(43, 12, 'read_advertisement_banner', 'Read Advertisement Banner', 'Read Advertisement Banner', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(44, 12, 'update_advertisement_banner', 'Update Advertisement Banner', 'Update Advertisement Banner', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(45, 12, 'delete_advertisement_banner', 'Delete Advertisement Banner', 'Delete Advertisement Banner', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(46, 13, 'create_memberships', 'Create Memberships', 'Create Memberships', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(47, 13, 'read_memberships', 'Read Memberships', 'Read Memberships', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(48, 13, 'update_memberships', 'Update Memberships', 'Update Memberships', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(49, 13, 'delete_memberships', 'Delete Memberships', 'Delete Memberships', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(50, 14, 'create_reviews', 'Create Reviews', 'Create Reviews', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(51, 14, 'read_reviews', 'Read Reviews', 'Read Reviews', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(52, 14, 'update_reviews', 'Update Reviews', 'Update Reviews', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(53, 14, 'delete_reviews', 'Delete Reviews', 'Delete Reviews', '2025-04-14 14:06:53', '2025-04-14 14:06:53');

-- --------------------------------------------------------

--
-- Table structure for table `permission_role`
--

CREATE TABLE `permission_role` (
  `permission_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `permission_role`
--

INSERT INTO `permission_role` (`permission_id`, `role_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(17, 1),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(34, 1),
(34, 2),
(34, 3),
(35, 1),
(35, 2),
(35, 3),
(36, 1),
(37, 1),
(38, 1),
(39, 1),
(40, 1),
(41, 1),
(42, 1),
(43, 1),
(44, 1),
(45, 1),
(46, 1),
(47, 1),
(48, 1),
(49, 1),
(50, 1),
(51, 1),
(52, 1),
(53, 1);

-- --------------------------------------------------------

--
-- Table structure for table `permission_user`
--

CREATE TABLE `permission_user` (
  `permission_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `user_type` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(10) UNSIGNED NOT NULL,
  `location_id` int(10) UNSIGNED NOT NULL DEFAULT 1,
  `name` varchar(191) NOT NULL,
  `description` text NOT NULL,
  `price` double(8,2) NOT NULL,
  `discount` double(8,2) NOT NULL,
  `discount_type` enum('percent','fixed') NOT NULL,
  `image` text DEFAULT NULL,
  `default_image` varchar(191) DEFAULT NULL,
  `status` enum('active','deactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `location_id`, `name`, `description`, `price`, `discount`, `discount_type`, `image`, `default_image`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 'AC Cover', '<p>AC Cover Used to cover AC while you are not Using it in winter.</p>', 50.00, 10.00, 'percent', '[\"6832b874b3fa76fa624c9072b673c3f1.png\",\"fa0a4ac52f5435b5403653845fb0de26.png\"]', '6832b874b3fa76fa624c9072b673c3f1.png', 'active', '2025-04-16 22:31:50', '2025-04-16 22:31:50');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `display_name` varchar(191) DEFAULT NULL,
  `description` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `display_name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'administrator', 'Administrator', 'Administrator', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(2, 'employee', 'Employee', 'Employee', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(3, 'customer', 'Customer', 'Customer', '2025-04-14 14:06:53', '2025-04-14 14:06:53');

-- --------------------------------------------------------

--
-- Table structure for table `role_user`
--

CREATE TABLE `role_user` (
  `role_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `user_type` varchar(191) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `role_user`
--

INSERT INTO `role_user` (`role_id`, `user_id`, `user_type`) VALUES
(1, 1, 'App\\User'),
(3, 1, 'App\\User'),
(3, 3, 'App\\User'),
(2, 4, 'App\\User'),
(3, 5, 'App\\User');

-- --------------------------------------------------------

--
-- Table structure for table `service_reviews`
--

CREATE TABLE `service_reviews` (
  `id` int(10) UNSIGNED NOT NULL,
  `booking_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `service_id` int(10) UNSIGNED NOT NULL,
  `rating` tinyint(3) UNSIGNED NOT NULL CHECK (`rating` between 1 and 5),
  `review_text` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `service_reviews`
--

INSERT INTO `service_reviews` (`id`, `booking_id`, `user_id`, `service_id`, `rating`, `review_text`, `created_at`, `updated_at`) VALUES
(9, 3, 5, 5, 4, 'This is a test', '2025-05-02 07:12:24', '2025-05-02 07:12:24');

-- --------------------------------------------------------

--
-- Table structure for table `sms_settings`
--

CREATE TABLE `sms_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nexmo_status` enum('active','deactive') NOT NULL DEFAULT 'deactive',
  `nexmo_key` varchar(191) DEFAULT NULL,
  `nexmo_secret` varchar(191) DEFAULT NULL,
  `nexmo_from` varchar(191) DEFAULT 'NEXMO',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `msg91_status` enum('active','deactive') NOT NULL DEFAULT 'deactive',
  `msg91_key` varchar(191) DEFAULT NULL,
  `msg91_from` varchar(191) DEFAULT 'msgind'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `sms_settings`
--

INSERT INTO `sms_settings` (`id`, `nexmo_status`, `nexmo_key`, `nexmo_secret`, `nexmo_from`, `created_at`, `updated_at`, `msg91_status`, `msg91_key`, `msg91_from`) VALUES
(1, 'deactive', NULL, NULL, 'NEXMO', '2025-04-14 14:06:53', '2025-04-14 14:06:53', 'deactive', NULL, 'msgind');

-- --------------------------------------------------------

--
-- Table structure for table `smtp_settings`
--

CREATE TABLE `smtp_settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `mail_driver` varchar(191) NOT NULL,
  `mail_host` varchar(191) NOT NULL,
  `mail_port` varchar(191) NOT NULL,
  `mail_username` varchar(191) NOT NULL,
  `mail_password` varchar(191) NOT NULL,
  `mail_from_name` varchar(191) NOT NULL,
  `mail_from_email` varchar(191) NOT NULL,
  `mail_encryption` enum('none','tls','ssl') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `smtp_settings`
--

INSERT INTO `smtp_settings` (`id`, `mail_driver`, `mail_host`, `mail_port`, `mail_username`, `mail_password`, `mail_from_name`, `mail_from_email`, `mail_encryption`, `created_at`, `updated_at`, `verified`) VALUES
(1, 'mail', 'smtp.gmail.com', '587', 'myemail@gmail.com', 'mypassword', 'SchedMate', 'myemail@gmail.com', '', '2025-04-14 14:06:52', '2025-04-16 09:15:38', 0);

-- --------------------------------------------------------

--
-- Table structure for table `socials`
--

CREATE TABLE `socials` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `social_id` text NOT NULL,
  `social_service` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `social_auth_settings`
--

CREATE TABLE `social_auth_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `google_client_id` varchar(191) DEFAULT NULL,
  `google_secret_id` varchar(191) DEFAULT NULL,
  `google_status` enum('active','inactive') NOT NULL DEFAULT 'inactive',
  `facebook_client_id` varchar(191) DEFAULT NULL,
  `facebook_secret_id` varchar(191) DEFAULT NULL,
  `facebook_status` enum('active','inactive') NOT NULL DEFAULT 'inactive',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `social_auth_settings`
--

INSERT INTO `social_auth_settings` (`id`, `google_client_id`, `google_secret_id`, `google_status`, `facebook_client_id`, `facebook_secret_id`, `facebook_status`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, 'inactive', NULL, NULL, 'inactive', '2025-04-14 14:06:54', '2025-04-14 14:06:54');

-- --------------------------------------------------------

--
-- Table structure for table `taxes`
--

CREATE TABLE `taxes` (
  `id` int(10) UNSIGNED NOT NULL,
  `tax_name` varchar(191) NOT NULL,
  `percent` double(8,2) NOT NULL,
  `status` enum('active','deactive') NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `taxes`
--

INSERT INTO `taxes` (`id`, `tax_name`, `percent`, `status`, `created_at`, `updated_at`) VALUES
(1, 'GST', 18.00, 'active', '2025-04-14 14:06:52', '2025-04-14 14:06:52');

-- --------------------------------------------------------

--
-- Table structure for table `theme_settings`
--

CREATE TABLE `theme_settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `primary_color` varchar(191) NOT NULL,
  `secondary_color` varchar(191) NOT NULL,
  `sidebar_bg_color` varchar(191) NOT NULL,
  `sidebar_text_color` varchar(191) NOT NULL,
  `topbar_text_color` varchar(191) NOT NULL DEFAULT '#FFFFFF',
  `custom_css` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `theme_settings`
--

INSERT INTO `theme_settings` (`id`, `primary_color`, `secondary_color`, `sidebar_bg_color`, `sidebar_text_color`, `topbar_text_color`, `custom_css`, `created_at`, `updated_at`) VALUES
(1, '#003CFF', '#788AE2', '#FFFFFF', '#FF0000', '#FFFFFF', '/*Enter your custom css after this line*/', NULL, '2025-04-16 23:18:13');

-- --------------------------------------------------------

--
-- Table structure for table `timezones`
--

CREATE TABLE `timezones` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `country_id` int(10) UNSIGNED DEFAULT NULL,
  `zone_name` varchar(191) NOT NULL COMMENT 'Timezone database name',
  `name` varchar(191) DEFAULT NULL COMMENT 'Timezone name',
  `gmt_offset` varchar(191) DEFAULT NULL COMMENT 'Timezone offset from UTC',
  `gmt_offset_name` varchar(191) DEFAULT NULL COMMENT 'Timezone offset from UTC name',
  `abbreviation` varchar(191) DEFAULT NULL COMMENT 'Timezone abbreviation',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `timezones`
--

INSERT INTO `timezones` (`id`, `country_id`, `zone_name`, `name`, `gmt_offset`, `gmt_offset_name`, `abbreviation`, `created_at`, `updated_at`) VALUES
(1, 1, 'Asia/Kabul', 'Afghanistan Time', '16200', 'UTC+04:30', 'AFT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(2, 243, 'Europe/Mariehamn', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(3, 2, 'Europe/Tirane', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(4, 3, 'Africa/Algiers', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(5, 4, 'Pacific/Pago_Pago', 'Samoa Standard Time', '-39600', 'UTC-11:00', 'SST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(6, 5, 'Europe/Andorra', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(7, 6, 'Africa/Luanda', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(8, 7, 'America/Anguilla', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(9, 8, 'Antarctica/Casey', 'Australian Western Standard Time', '39600', 'UTC+11:00', 'AWST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(10, 8, 'Antarctica/Davis', 'Davis Time', '25200', 'UTC+07:00', 'DAVT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(11, 8, 'Antarctica/DumontDUrville', 'Dumont d\'Urville Time', '36000', 'UTC+10:00', 'DDUT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(12, 8, 'Antarctica/Mawson', 'Mawson Station Time', '18000', 'UTC+05:00', 'MAWT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(13, 8, 'Antarctica/McMurdo', 'New Zealand Daylight Time', '46800', 'UTC+13:00', 'NZDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(14, 8, 'Antarctica/Palmer', 'Chile Summer Time', '-10800', 'UTC-03:00', 'CLST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(15, 8, 'Antarctica/Rothera', 'Rothera Research Station Time', '-10800', 'UTC-03:00', 'ROTT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(16, 8, 'Antarctica/Syowa', 'Showa Station Time', '10800', 'UTC+03:00', 'SYOT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(17, 8, 'Antarctica/Troll', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(18, 8, 'Antarctica/Vostok', 'Vostok Station Time', '21600', 'UTC+06:00', 'VOST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(19, 9, 'America/Antigua', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(20, 10, 'America/Argentina/Buenos_Aires', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(21, 10, 'America/Argentina/Catamarca', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(22, 10, 'America/Argentina/Cordoba', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(23, 10, 'America/Argentina/Jujuy', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(24, 10, 'America/Argentina/La_Rioja', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(25, 10, 'America/Argentina/Mendoza', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(26, 10, 'America/Argentina/Rio_Gallegos', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(27, 10, 'America/Argentina/Salta', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(28, 10, 'America/Argentina/San_Juan', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(29, 10, 'America/Argentina/San_Luis', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(30, 10, 'America/Argentina/Tucuman', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(31, 10, 'America/Argentina/Ushuaia', 'Argentina Time', '-10800', 'UTC-03:00', 'ART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(32, 11, 'Asia/Yerevan', 'Armenia Time', '14400', 'UTC+04:00', 'AMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(33, 12, 'America/Aruba', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(34, 13, 'Antarctica/Macquarie', 'Macquarie Island Station Time', '39600', 'UTC+11:00', 'MIST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(35, 13, 'Australia/Adelaide', 'Australian Central Daylight Saving Time', '37800', 'UTC+10:30', 'ACDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(36, 13, 'Australia/Brisbane', 'Australian Eastern Standard Time', '36000', 'UTC+10:00', 'AEST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(37, 13, 'Australia/Broken_Hill', 'Australian Central Daylight Saving Time', '37800', 'UTC+10:30', 'ACDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(38, 13, 'Australia/Currie', 'Australian Eastern Daylight Saving Time', '39600', 'UTC+11:00', 'AEDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(39, 13, 'Australia/Darwin', 'Australian Central Standard Time', '34200', 'UTC+09:30', 'ACST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(40, 13, 'Australia/Eucla', 'Australian Central Western Standard Time (Unofficial)', '31500', 'UTC+08:45', 'ACWST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(41, 13, 'Australia/Hobart', 'Australian Eastern Daylight Saving Time', '39600', 'UTC+11:00', 'AEDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(42, 13, 'Australia/Lindeman', 'Australian Eastern Standard Time', '36000', 'UTC+10:00', 'AEST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(43, 13, 'Australia/Lord_Howe', 'Lord Howe Summer Time', '39600', 'UTC+11:00', 'LHST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(44, 13, 'Australia/Melbourne', 'Australian Eastern Daylight Saving Time', '39600', 'UTC+11:00', 'AEDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(45, 13, 'Australia/Perth', 'Australian Western Standard Time', '28800', 'UTC+08:00', 'AWST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(46, 13, 'Australia/Sydney', 'Australian Eastern Daylight Saving Time', '39600', 'UTC+11:00', 'AEDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(47, 14, 'Europe/Vienna', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(48, 15, 'Asia/Baku', 'Azerbaijan Time', '14400', 'UTC+04:00', 'AZT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(49, 16, 'America/Nassau', 'Eastern Standard Time (North America)', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(50, 17, 'Asia/Bahrain', 'Arabia Standard Time', '10800', 'UTC+03:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(51, 18, 'Asia/Dhaka', 'Bangladesh Standard Time', '21600', 'UTC+06:00', 'BDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(52, 19, 'America/Barbados', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(53, 20, 'Europe/Minsk', 'Moscow Time', '10800', 'UTC+03:00', 'MSK', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(54, 21, 'Europe/Brussels', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(55, 22, 'America/Belize', 'Central Standard Time (North America)', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(56, 23, 'Africa/Porto-Novo', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(57, 24, 'Atlantic/Bermuda', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(58, 25, 'Asia/Thimphu', 'Bhutan Time', '21600', 'UTC+06:00', 'BTT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(59, 26, 'America/La_Paz', 'Bolivia Time', '-14400', 'UTC-04:00', 'BOT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(60, 244, 'America/Anguilla', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(61, 27, 'Europe/Sarajevo', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(62, 28, 'Africa/Gaborone', 'Central Africa Time', '7200', 'UTC+02:00', 'CAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(63, 29, 'Europe/Oslo', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(64, 30, 'America/Araguaina', 'Brasília Time', '-10800', 'UTC-03:00', 'BRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(65, 30, 'America/Bahia', 'Brasília Time', '-10800', 'UTC-03:00', 'BRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(66, 30, 'America/Belem', 'Brasília Time', '-10800', 'UTC-03:00', 'BRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(67, 30, 'America/Boa_Vista', 'Amazon Time (Brazil)[3', '-14400', 'UTC-04:00', 'AMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(68, 30, 'America/Campo_Grande', 'Amazon Time (Brazil)[3', '-14400', 'UTC-04:00', 'AMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(69, 30, 'America/Cuiaba', 'Brasilia Time', '-14400', 'UTC-04:00', 'BRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(70, 30, 'America/Eirunepe', 'Acre Time', '-18000', 'UTC-05:00', 'ACT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(71, 30, 'America/Fortaleza', 'Brasília Time', '-10800', 'UTC-03:00', 'BRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(72, 30, 'America/Maceio', 'Brasília Time', '-10800', 'UTC-03:00', 'BRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(73, 30, 'America/Manaus', 'Amazon Time (Brazil)', '-14400', 'UTC-04:00', 'AMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(74, 30, 'America/Noronha', 'Fernando de Noronha Time', '-7200', 'UTC-02:00', 'FNT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(75, 30, 'America/Porto_Velho', 'Amazon Time (Brazil)[3', '-14400', 'UTC-04:00', 'AMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(76, 30, 'America/Recife', 'Brasília Time', '-10800', 'UTC-03:00', 'BRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(77, 30, 'America/Rio_Branco', 'Acre Time', '-18000', 'UTC-05:00', 'ACT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(78, 30, 'America/Santarem', 'Brasília Time', '-10800', 'UTC-03:00', 'BRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(79, 30, 'America/Sao_Paulo', 'Brasília Time', '-10800', 'UTC-03:00', 'BRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(80, 31, 'Indian/Chagos', 'Indian Ocean Time', '21600', 'UTC+06:00', 'IOT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(81, 32, 'Asia/Brunei', 'Brunei Darussalam Time', '28800', 'UTC+08:00', 'BNT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(82, 33, 'Europe/Sofia', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(83, 34, 'Africa/Ouagadougou', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(84, 35, 'Africa/Bujumbura', 'Central Africa Time', '7200', 'UTC+02:00', 'CAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(85, 36, 'Asia/Phnom_Penh', 'Indochina Time', '25200', 'UTC+07:00', 'ICT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(86, 37, 'Africa/Douala', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(87, 38, 'America/Atikokan', 'Eastern Standard Time (North America)', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(88, 38, 'America/Blanc-Sablon', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(89, 38, 'America/Cambridge_Bay', 'Mountain Standard Time (North America)', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(90, 38, 'America/Creston', 'Mountain Standard Time (North America)', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(91, 38, 'America/Dawson', 'Mountain Standard Time (North America)', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(92, 38, 'America/Dawson_Creek', 'Mountain Standard Time (North America)', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(93, 38, 'America/Edmonton', 'Mountain Standard Time (North America)', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(94, 38, 'America/Fort_Nelson', 'Mountain Standard Time (North America)', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(95, 38, 'America/Glace_Bay', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(96, 38, 'America/Goose_Bay', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(97, 38, 'America/Halifax', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(98, 38, 'America/Inuvik', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(99, 38, 'America/Iqaluit', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(100, 38, 'America/Moncton', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(101, 38, 'America/Nipigon', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(102, 38, 'America/Pangnirtung', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(103, 38, 'America/Rainy_River', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(104, 38, 'America/Rankin_Inlet', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(105, 38, 'America/Regina', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(106, 38, 'America/Resolute', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(107, 38, 'America/St_Johns', 'Newfoundland Standard Time', '-12600', 'UTC-03:30', 'NST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(108, 38, 'America/Swift_Current', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(109, 38, 'America/Thunder_Bay', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(110, 38, 'America/Toronto', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(111, 38, 'America/Vancouver', 'Pacific Standard Time (North America', '-28800', 'UTC-08:00', 'PST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(112, 38, 'America/Whitehorse', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(113, 38, 'America/Winnipeg', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(114, 38, 'America/Yellowknife', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(115, 39, 'Atlantic/Cape_Verde', 'Cape Verde Time', '-3600', 'UTC-01:00', 'CVT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(116, 40, 'America/Cayman', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(117, 41, 'Africa/Bangui', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(118, 42, 'Africa/Ndjamena', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(119, 43, 'America/Punta_Arenas', 'Chile Summer Time', '-10800', 'UTC-03:00', 'CLST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(120, 43, 'America/Santiago', 'Chile Summer Time', '-10800', 'UTC-03:00', 'CLST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(121, 43, 'Pacific/Easter', 'Easter Island Summer Time', '-18000', 'UTC-05:00', 'EASST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(122, 44, 'Asia/Shanghai', 'China Standard Time', '28800', 'UTC+08:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(123, 44, 'Asia/Urumqi', 'China Standard Time', '21600', 'UTC+06:00', 'XJT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(124, 45, 'Indian/Christmas', 'Christmas Island Time', '25200', 'UTC+07:00', 'CXT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(125, 46, 'Indian/Cocos', 'Cocos Islands Time', '23400', 'UTC+06:30', 'CCT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(126, 47, 'America/Bogota', 'Colombia Time', '-18000', 'UTC-05:00', 'COT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(127, 48, 'Indian/Comoro', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(128, 49, 'Africa/Brazzaville', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(129, 51, 'Pacific/Rarotonga', 'Cook Island Time', '-36000', 'UTC-10:00', 'CKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(130, 52, 'America/Costa_Rica', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(131, 53, 'Africa/Abidjan', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(132, 54, 'Europe/Zagreb', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(133, 55, 'America/Havana', 'Cuba Standard Time', '-18000', 'UTC-05:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(134, 245, 'America/Curacao', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(135, 56, 'Asia/Famagusta', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(136, 56, 'Asia/Nicosia', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(137, 57, 'Europe/Prague', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(138, 50, 'Africa/Kinshasa', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(139, 50, 'Africa/Lubumbashi', 'Central Africa Time', '7200', 'UTC+02:00', 'CAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(140, 58, 'Europe/Copenhagen', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(141, 59, 'Africa/Djibouti', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(142, 60, 'America/Dominica', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(143, 61, 'America/Santo_Domingo', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(144, 212, 'Asia/Dili', 'Timor Leste Time', '32400', 'UTC+09:00', 'TLT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(145, 62, 'America/Guayaquil', 'Ecuador Time', '-18000', 'UTC-05:00', 'ECT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(146, 62, 'Pacific/Galapagos', 'Galápagos Time', '-21600', 'UTC-06:00', 'GALT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(147, 63, 'Africa/Cairo', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(148, 64, 'America/El_Salvador', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(149, 65, 'Africa/Malabo', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(150, 66, 'Africa/Asmara', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(151, 67, 'Europe/Tallinn', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(152, 68, 'Africa/Addis_Ababa', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(153, 69, 'Atlantic/Stanley', 'Falkland Islands Summer Time', '-10800', 'UTC-03:00', 'FKST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(154, 70, 'Atlantic/Faroe', 'Western European Time', '0', 'UTC±00', 'WET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(155, 71, 'Pacific/Fiji', 'Fiji Time', '43200', 'UTC+12:00', 'FJT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(156, 72, 'Europe/Helsinki', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(157, 73, 'Europe/Paris', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(158, 74, 'America/Cayenne', 'French Guiana Time', '-10800', 'UTC-03:00', 'GFT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(159, 75, 'Pacific/Gambier', 'Gambier Islands Time', '-32400', 'UTC-09:00', 'GAMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(160, 75, 'Pacific/Marquesas', 'Marquesas Islands Time', '-34200', 'UTC-09:30', 'MART', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(161, 75, 'Pacific/Tahiti', 'Tahiti Time', '-36000', 'UTC-10:00', 'TAHT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(162, 76, 'Indian/Kerguelen', 'French Southern and Antarctic Time', '18000', 'UTC+05:00', 'TFT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(163, 77, 'Africa/Libreville', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(164, 78, 'Africa/Banjul', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(165, 79, 'Asia/Tbilisi', 'Georgia Standard Time', '14400', 'UTC+04:00', 'GET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(166, 80, 'Europe/Berlin', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(167, 80, 'Europe/Busingen', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(168, 81, 'Africa/Accra', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(169, 82, 'Europe/Gibraltar', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(170, 83, 'Europe/Athens', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(171, 84, 'America/Danmarkshavn', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(172, 84, 'America/Nuuk', 'West Greenland Time', '-10800', 'UTC-03:00', 'WGT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(173, 84, 'America/Scoresbysund', 'Eastern Greenland Time', '-3600', 'UTC-01:00', 'EGT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(174, 84, 'America/Thule', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(175, 85, 'America/Grenada', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(176, 86, 'America/Guadeloupe', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(177, 87, 'Pacific/Guam', 'Chamorro Standard Time', '36000', 'UTC+10:00', 'CHST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(178, 88, 'America/Guatemala', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(179, 246, 'Europe/Guernsey', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(180, 89, 'Africa/Conakry', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(181, 90, 'Africa/Bissau', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(182, 91, 'America/Guyana', 'Guyana Time', '-14400', 'UTC-04:00', 'GYT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(183, 92, 'America/Port-au-Prince', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(184, 93, 'Indian/Kerguelen', 'French Southern and Antarctic Time', '18000', 'UTC+05:00', 'TFT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(185, 95, 'America/Tegucigalpa', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(186, 96, 'Asia/Hong_Kong', 'Hong Kong Time', '28800', 'UTC+08:00', 'HKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(187, 97, 'Europe/Budapest', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(188, 98, 'Atlantic/Reykjavik', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(189, 99, 'Asia/Kolkata', 'Indian Standard Time', '19800', 'UTC+05:30', 'IST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(190, 100, 'Asia/Jakarta', 'Western Indonesian Time', '25200', 'UTC+07:00', 'WIB', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(191, 100, 'Asia/Jayapura', 'Eastern Indonesian Time', '32400', 'UTC+09:00', 'WIT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(192, 100, 'Asia/Makassar', 'Central Indonesia Time', '28800', 'UTC+08:00', 'WITA', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(193, 100, 'Asia/Pontianak', 'Western Indonesian Time', '25200', 'UTC+07:00', 'WIB', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(194, 101, 'Asia/Tehran', 'Iran Daylight Time', '12600', 'UTC+03:30', 'IRDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(195, 102, 'Asia/Baghdad', 'Arabia Standard Time', '10800', 'UTC+03:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(196, 103, 'Europe/Dublin', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(197, 104, 'Asia/Jerusalem', 'Israel Standard Time', '7200', 'UTC+02:00', 'IST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(198, 105, 'Europe/Rome', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(199, 106, 'America/Jamaica', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(200, 107, 'Asia/Tokyo', 'Japan Standard Time', '32400', 'UTC+09:00', 'JST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(201, 248, 'Europe/Jersey', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(202, 108, 'Asia/Amman', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(203, 109, 'Asia/Almaty', 'Alma-Ata Time[1', '21600', 'UTC+06:00', 'ALMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(204, 109, 'Asia/Aqtau', 'Aqtobe Time', '18000', 'UTC+05:00', 'AQTT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(205, 109, 'Asia/Aqtobe', 'Aqtobe Time', '18000', 'UTC+05:00', 'AQTT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(206, 109, 'Asia/Atyrau', 'Moscow Daylight Time+1', '18000', 'UTC+05:00', 'MSD+1', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(207, 109, 'Asia/Oral', 'Oral Time', '18000', 'UTC+05:00', 'ORAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(208, 109, 'Asia/Qostanay', 'Qyzylorda Summer Time', '21600', 'UTC+06:00', 'QYZST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(209, 109, 'Asia/Qyzylorda', 'Qyzylorda Summer Time', '18000', 'UTC+05:00', 'QYZT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(210, 110, 'Africa/Nairobi', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(211, 111, 'Pacific/Enderbury', 'Phoenix Island Time', '46800', 'UTC+13:00', 'PHOT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(212, 111, 'Pacific/Kiritimati', 'Line Islands Time', '50400', 'UTC+14:00', 'LINT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(213, 111, 'Pacific/Tarawa', 'Gilbert Island Time', '43200', 'UTC+12:00', 'GILT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(214, 249, 'Europe/Belgrade', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(215, 114, 'Asia/Kuwait', 'Arabia Standard Time', '10800', 'UTC+03:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(216, 115, 'Asia/Bishkek', 'Kyrgyzstan Time', '21600', 'UTC+06:00', 'KGT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(217, 116, 'Asia/Vientiane', 'Indochina Time', '25200', 'UTC+07:00', 'ICT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(218, 117, 'Europe/Riga', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(219, 118, 'Asia/Beirut', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(220, 119, 'Africa/Maseru', 'South African Standard Time', '7200', 'UTC+02:00', 'SAST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(221, 120, 'Africa/Monrovia', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(222, 121, 'Africa/Tripoli', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(223, 122, 'Europe/Vaduz', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(224, 123, 'Europe/Vilnius', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(225, 124, 'Europe/Luxembourg', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(226, 125, 'Asia/Macau', 'China Standard Time', '28800', 'UTC+08:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(227, 126, 'Europe/Skopje', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(228, 127, 'Indian/Antananarivo', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(229, 128, 'Africa/Blantyre', 'Central Africa Time', '7200', 'UTC+02:00', 'CAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(230, 129, 'Asia/Kuala_Lumpur', 'Malaysia Time', '28800', 'UTC+08:00', 'MYT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(231, 129, 'Asia/Kuching', 'Malaysia Time', '28800', 'UTC+08:00', 'MYT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(232, 130, 'Indian/Maldives', 'Maldives Time', '18000', 'UTC+05:00', 'MVT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(233, 131, 'Africa/Bamako', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(234, 132, 'Europe/Malta', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(235, 247, 'Europe/Isle_of_Man', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(236, 133, 'Pacific/Kwajalein', 'Marshall Islands Time', '43200', 'UTC+12:00', 'MHT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(237, 133, 'Pacific/Majuro', 'Marshall Islands Time', '43200', 'UTC+12:00', 'MHT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(238, 134, 'America/Martinique', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(239, 135, 'Africa/Nouakchott', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(240, 136, 'Indian/Mauritius', 'Mauritius Time', '14400', 'UTC+04:00', 'MUT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(241, 137, 'Indian/Mayotte', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(242, 138, 'America/Bahia_Banderas', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(243, 138, 'America/Cancun', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(244, 138, 'America/Chihuahua', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(245, 138, 'America/Hermosillo', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(246, 138, 'America/Matamoros', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(247, 138, 'America/Mazatlan', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(248, 138, 'America/Merida', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(249, 138, 'America/Mexico_City', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(250, 138, 'America/Monterrey', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(251, 138, 'America/Ojinaga', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(252, 138, 'America/Tijuana', 'Pacific Standard Time (North America', '-28800', 'UTC-08:00', 'PST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(253, 139, 'Pacific/Chuuk', 'Chuuk Time', '36000', 'UTC+10:00', 'CHUT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(254, 139, 'Pacific/Kosrae', 'Kosrae Time', '39600', 'UTC+11:00', 'KOST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(255, 139, 'Pacific/Pohnpei', 'Pohnpei Standard Time', '39600', 'UTC+11:00', 'PONT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(256, 140, 'Europe/Chisinau', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(257, 141, 'Europe/Monaco', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(258, 142, 'Asia/Choibalsan', 'Choibalsan Standard Time', '28800', 'UTC+08:00', 'CHOT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(259, 142, 'Asia/Hovd', 'Hovd Time', '25200', 'UTC+07:00', 'HOVT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(260, 142, 'Asia/Ulaanbaatar', 'Ulaanbaatar Standard Time', '28800', 'UTC+08:00', 'ULAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(261, 242, 'Europe/Podgorica', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(262, 143, 'America/Montserrat', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(263, 144, 'Africa/Casablanca', 'Western European Summer Time', '3600', 'UTC+01:00', 'WEST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(264, 145, 'Africa/Maputo', 'Central Africa Time', '7200', 'UTC+02:00', 'CAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(265, 146, 'Asia/Yangon', 'Myanmar Standard Time', '23400', 'UTC+06:30', 'MMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(266, 147, 'Africa/Windhoek', 'West Africa Summer Time', '7200', 'UTC+02:00', 'WAST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(267, 148, 'Pacific/Nauru', 'Nauru Time', '43200', 'UTC+12:00', 'NRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(268, 149, 'Asia/Kathmandu', 'Nepal Time', '20700', 'UTC+05:45', 'NPT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(269, 150, 'Europe/Amsterdam', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(270, 152, 'Pacific/Noumea', 'New Caledonia Time', '39600', 'UTC+11:00', 'NCT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(271, 153, 'Pacific/Auckland', 'New Zealand Daylight Time', '46800', 'UTC+13:00', 'NZDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(272, 153, 'Pacific/Chatham', 'Chatham Standard Time', '49500', 'UTC+13:45', 'CHAST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(273, 154, 'America/Managua', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(274, 155, 'Africa/Niamey', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(275, 156, 'Africa/Lagos', 'West Africa Time', '3600', 'UTC+01:00', 'WAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(276, 157, 'Pacific/Niue', 'Niue Time', '-39600', 'UTC-11:00', 'NUT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(277, 158, 'Pacific/Norfolk', 'Norfolk Time', '43200', 'UTC+12:00', 'NFT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(278, 112, 'Asia/Pyongyang', 'Korea Standard Time', '32400', 'UTC+09:00', 'KST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(279, 159, 'Pacific/Saipan', 'Chamorro Standard Time', '36000', 'UTC+10:00', 'ChST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(280, 160, 'Europe/Oslo', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(281, 161, 'Asia/Muscat', 'Gulf Standard Time', '14400', 'UTC+04:00', 'GST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(282, 162, 'Asia/Karachi', 'Pakistan Standard Time', '18000', 'UTC+05:00', 'PKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(283, 163, 'Pacific/Palau', 'Palau Time', '32400', 'UTC+09:00', 'PWT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(284, 164, 'Asia/Gaza', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(285, 164, 'Asia/Hebron', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(286, 165, 'America/Panama', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(287, 166, 'Pacific/Bougainville', 'Bougainville Standard Time[6', '39600', 'UTC+11:00', 'BST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(288, 166, 'Pacific/Port_Moresby', 'Papua New Guinea Time', '36000', 'UTC+10:00', 'PGT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(289, 167, 'America/Asuncion', 'Paraguay Summer Time', '-10800', 'UTC-03:00', 'PYST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(290, 168, 'America/Lima', 'Peru Time', '-18000', 'UTC-05:00', 'PET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(291, 169, 'Asia/Manila', 'Philippine Time', '28800', 'UTC+08:00', 'PHT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(292, 170, 'Pacific/Pitcairn', 'Pacific Standard Time (North America', '-28800', 'UTC-08:00', 'PST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(293, 171, 'Europe/Warsaw', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(294, 172, 'Atlantic/Azores', 'Azores Standard Time', '-3600', 'UTC-01:00', 'AZOT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(295, 172, 'Atlantic/Madeira', 'Western European Time', '0', 'UTC±00', 'WET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(296, 172, 'Europe/Lisbon', 'Western European Time', '0', 'UTC±00', 'WET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(297, 173, 'America/Puerto_Rico', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(298, 174, 'Asia/Qatar', 'Arabia Standard Time', '10800', 'UTC+03:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(299, 175, 'Indian/Reunion', 'Réunion Time', '14400', 'UTC+04:00', 'RET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(300, 176, 'Europe/Bucharest', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(301, 177, 'Asia/Anadyr', 'Anadyr Time[4', '43200', 'UTC+12:00', 'ANAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(302, 177, 'Asia/Barnaul', 'Krasnoyarsk Time', '25200', 'UTC+07:00', 'KRAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(303, 177, 'Asia/Chita', 'Yakutsk Time', '32400', 'UTC+09:00', 'YAKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(304, 177, 'Asia/Irkutsk', 'Irkutsk Time', '28800', 'UTC+08:00', 'IRKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(305, 177, 'Asia/Kamchatka', 'Kamchatka Time', '43200', 'UTC+12:00', 'PETT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(306, 177, 'Asia/Khandyga', 'Yakutsk Time', '32400', 'UTC+09:00', 'YAKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(307, 177, 'Asia/Krasnoyarsk', 'Krasnoyarsk Time', '25200', 'UTC+07:00', 'KRAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(308, 177, 'Asia/Magadan', 'Magadan Time', '39600', 'UTC+11:00', 'MAGT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(309, 177, 'Asia/Novokuznetsk', 'Krasnoyarsk Time', '25200', 'UTC+07:00', 'KRAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(310, 177, 'Asia/Novosibirsk', 'Novosibirsk Time', '25200', 'UTC+07:00', 'NOVT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(311, 177, 'Asia/Omsk', 'Omsk Time', '21600', 'UTC+06:00', 'OMST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(312, 177, 'Asia/Sakhalin', 'Sakhalin Island Time', '39600', 'UTC+11:00', 'SAKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(313, 177, 'Asia/Srednekolymsk', 'Srednekolymsk Time', '39600', 'UTC+11:00', 'SRET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(314, 177, 'Asia/Tomsk', 'Moscow Daylight Time+3', '25200', 'UTC+07:00', 'MSD+3', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(315, 177, 'Asia/Ust-Nera', 'Vladivostok Time', '36000', 'UTC+10:00', 'VLAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(316, 177, 'Asia/Vladivostok', 'Vladivostok Time', '36000', 'UTC+10:00', 'VLAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(317, 177, 'Asia/Yakutsk', 'Yakutsk Time', '32400', 'UTC+09:00', 'YAKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(318, 177, 'Asia/Yekaterinburg', 'Yekaterinburg Time', '18000', 'UTC+05:00', 'YEKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(319, 177, 'Europe/Astrakhan', 'Samara Time', '14400', 'UTC+04:00', 'SAMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(320, 177, 'Europe/Kaliningrad', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(321, 177, 'Europe/Kirov', 'Moscow Time', '10800', 'UTC+03:00', 'MSK', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(322, 177, 'Europe/Moscow', 'Moscow Time', '10800', 'UTC+03:00', 'MSK', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(323, 177, 'Europe/Samara', 'Samara Time', '14400', 'UTC+04:00', 'SAMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(324, 177, 'Europe/Saratov', 'Moscow Daylight Time+4', '14400', 'UTC+04:00', 'MSD', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(325, 177, 'Europe/Ulyanovsk', 'Samara Time', '14400', 'UTC+04:00', 'SAMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(326, 177, 'Europe/Volgograd', 'Moscow Standard Time', '14400', 'UTC+04:00', 'MSK', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(327, 178, 'Africa/Kigali', 'Central Africa Time', '7200', 'UTC+02:00', 'CAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(328, 179, 'Atlantic/St_Helena', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(329, 180, 'America/St_Kitts', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(330, 181, 'America/St_Lucia', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(331, 182, 'America/Miquelon', 'Pierre & Miquelon Daylight Time', '-10800', 'UTC-03:00', 'PMDT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(332, 183, 'America/St_Vincent', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(333, 250, 'America/St_Barthelemy', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(334, 251, 'America/Marigot', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(335, 184, 'Pacific/Apia', 'West Samoa Time', '50400', 'UTC+14:00', 'WST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(336, 185, 'Europe/San_Marino', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(337, 186, 'Africa/Sao_Tome', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(338, 187, 'Asia/Riyadh', 'Arabia Standard Time', '10800', 'UTC+03:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(339, 188, 'Africa/Dakar', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(340, 240, 'Europe/Belgrade', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(341, 190, 'Indian/Mahe', 'Seychelles Time', '14400', 'UTC+04:00', 'SCT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(342, 191, 'Africa/Freetown', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(343, 192, 'Asia/Singapore', 'Singapore Time', '28800', 'UTC+08:00', 'SGT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(344, 252, 'America/Anguilla', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(345, 193, 'Europe/Bratislava', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(346, 194, 'Europe/Ljubljana', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(347, 195, 'Pacific/Guadalcanal', 'Solomon Islands Time', '39600', 'UTC+11:00', 'SBT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(348, 196, 'Africa/Mogadishu', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(349, 197, 'Africa/Johannesburg', 'South African Standard Time', '7200', 'UTC+02:00', 'SAST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(350, 198, 'Atlantic/South_Georgia', 'South Georgia and the South Sandwich Islands Time', '-7200', 'UTC-02:00', 'GST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(351, 113, 'Asia/Seoul', 'Korea Standard Time', '32400', 'UTC+09:00', 'KST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(352, 253, 'Africa/Juba', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(353, 199, 'Africa/Ceuta', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(354, 199, 'Atlantic/Canary', 'Western European Time', '0', 'UTC±00', 'WET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(355, 199, 'Europe/Madrid', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(356, 200, 'Asia/Colombo', 'Indian Standard Time', '19800', 'UTC+05:30', 'IST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(357, 201, 'Africa/Khartoum', 'Eastern African Time', '7200', 'UTC+02:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(358, 202, 'America/Paramaribo', 'Suriname Time', '-10800', 'UTC-03:00', 'SRT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(359, 203, 'Arctic/Longyearbyen', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(360, 204, 'Africa/Mbabane', 'South African Standard Time', '7200', 'UTC+02:00', 'SAST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(361, 205, 'Europe/Stockholm', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(362, 206, 'Europe/Zurich', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(363, 207, 'Asia/Damascus', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(364, 208, 'Asia/Taipei', 'China Standard Time', '28800', 'UTC+08:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(365, 209, 'Asia/Dushanbe', 'Tajikistan Time', '18000', 'UTC+05:00', 'TJT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(366, 210, 'Africa/Dar_es_Salaam', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(367, 211, 'Asia/Bangkok', 'Indochina Time', '25200', 'UTC+07:00', 'ICT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(368, 213, 'Africa/Lome', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(369, 214, 'Pacific/Fakaofo', 'Tokelau Time', '46800', 'UTC+13:00', 'TKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(370, 215, 'Pacific/Tongatapu', 'Tonga Time', '46800', 'UTC+13:00', 'TOT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(371, 216, 'America/Port_of_Spain', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(372, 217, 'Africa/Tunis', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(373, 218, 'Europe/Istanbul', 'Eastern European Time', '10800', 'UTC+03:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(374, 219, 'Asia/Ashgabat', 'Turkmenistan Time', '18000', 'UTC+05:00', 'TMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(375, 220, 'America/Grand_Turk', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(376, 221, 'Pacific/Funafuti', 'Tuvalu Time', '43200', 'UTC+12:00', 'TVT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(377, 222, 'Africa/Kampala', 'East Africa Time', '10800', 'UTC+03:00', 'EAT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(378, 223, 'Europe/Kiev', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(379, 223, 'Europe/Simferopol', 'Moscow Time', '10800', 'UTC+03:00', 'MSK', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(380, 223, 'Europe/Uzhgorod', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(381, 223, 'Europe/Zaporozhye', 'Eastern European Time', '7200', 'UTC+02:00', 'EET', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(382, 224, 'Asia/Dubai', 'Gulf Standard Time', '14400', 'UTC+04:00', 'GST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(383, 225, 'Europe/London', 'Greenwich Mean Time', '0', 'UTC±00', 'GMT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(384, 226, 'America/Adak', 'Hawaii–Aleutian Standard Time', '-36000', 'UTC-10:00', 'HST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(385, 226, 'America/Anchorage', 'Alaska Standard Time', '-32400', 'UTC-09:00', 'AKST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(386, 226, 'America/Boise', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(387, 226, 'America/Chicago', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55');
INSERT INTO `timezones` (`id`, `country_id`, `zone_name`, `name`, `gmt_offset`, `gmt_offset_name`, `abbreviation`, `created_at`, `updated_at`) VALUES
(388, 226, 'America/Denver', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(389, 226, 'America/Detroit', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(390, 226, 'America/Indiana/Indianapolis', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(391, 226, 'America/Indiana/Knox', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(392, 226, 'America/Indiana/Marengo', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(393, 226, 'America/Indiana/Petersburg', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(394, 226, 'America/Indiana/Tell_City', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(395, 226, 'America/Indiana/Vevay', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(396, 226, 'America/Indiana/Vincennes', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(397, 226, 'America/Indiana/Winamac', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(398, 226, 'America/Juneau', 'Alaska Standard Time', '-32400', 'UTC-09:00', 'AKST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(399, 226, 'America/Kentucky/Louisville', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(400, 226, 'America/Kentucky/Monticello', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(401, 226, 'America/Los_Angeles', 'Pacific Standard Time (North America', '-28800', 'UTC-08:00', 'PST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(402, 226, 'America/Menominee', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(403, 226, 'America/Metlakatla', 'Alaska Standard Time', '-32400', 'UTC-09:00', 'AKST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(404, 226, 'America/New_York', 'Eastern Standard Time (North America', '-18000', 'UTC-05:00', 'EST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(405, 226, 'America/Nome', 'Alaska Standard Time', '-32400', 'UTC-09:00', 'AKST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(406, 226, 'America/North_Dakota/Beulah', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(407, 226, 'America/North_Dakota/Center', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(408, 226, 'America/North_Dakota/New_Salem', 'Central Standard Time (North America', '-21600', 'UTC-06:00', 'CST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(409, 226, 'America/Phoenix', 'Mountain Standard Time (North America', '-25200', 'UTC-07:00', 'MST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(410, 226, 'America/Sitka', 'Alaska Standard Time', '-32400', 'UTC-09:00', 'AKST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(411, 226, 'America/Yakutat', 'Alaska Standard Time', '-32400', 'UTC-09:00', 'AKST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(412, 226, 'Pacific/Honolulu', 'Hawaii–Aleutian Standard Time', '-36000', 'UTC-10:00', 'HST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(413, 227, 'Pacific/Midway', 'Samoa Standard Time', '-39600', 'UTC-11:00', 'SST', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(414, 227, 'Pacific/Wake', 'Wake Island Time', '43200', 'UTC+12:00', 'WAKT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(415, 228, 'America/Montevideo', 'Uruguay Standard Time', '-10800', 'UTC-03:00', 'UYT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(416, 229, 'Asia/Samarkand', 'Uzbekistan Time', '18000', 'UTC+05:00', 'UZT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(417, 229, 'Asia/Tashkent', 'Uzbekistan Time', '18000', 'UTC+05:00', 'UZT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(418, 230, 'Pacific/Efate', 'Vanuatu Time', '39600', 'UTC+11:00', 'VUT', '2025-04-14 14:06:55', '2025-04-14 14:06:55'),
(419, 94, 'Europe/Vatican', 'Central European Time', '3600', 'UTC+01:00', 'CET', '2025-04-14 14:06:56', '2025-04-14 14:06:56'),
(420, 231, 'America/Caracas', 'Venezuelan Standard Time', '-14400', 'UTC-04:00', 'VET', '2025-04-14 14:06:56', '2025-04-14 14:06:56'),
(421, 232, 'Asia/Ho_Chi_Minh', 'Indochina Time', '25200', 'UTC+07:00', 'ICT', '2025-04-14 14:06:56', '2025-04-14 14:06:56'),
(422, 233, 'America/Tortola', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:56', '2025-04-14 14:06:56'),
(423, 234, 'America/St_Thomas', 'Atlantic Standard Time', '-14400', 'UTC-04:00', 'AST', '2025-04-14 14:06:56', '2025-04-14 14:06:56'),
(424, 235, 'Pacific/Wallis', 'Wallis & Futuna Time', '43200', 'UTC+12:00', 'WFT', '2025-04-14 14:06:56', '2025-04-14 14:06:56'),
(425, 236, 'Africa/El_Aaiun', 'Western European Summer Time', '3600', 'UTC+01:00', 'WEST', '2025-04-14 14:06:56', '2025-04-14 14:06:56'),
(426, 237, 'Asia/Aden', 'Arabia Standard Time', '10800', 'UTC+03:00', 'AST', '2025-04-14 14:06:56', '2025-04-14 14:06:56'),
(427, 238, 'Africa/Lusaka', 'Central Africa Time', '7200', 'UTC+02:00', 'CAT', '2025-04-14 14:06:56', '2025-04-14 14:06:56'),
(428, 239, 'Africa/Harare', 'Central Africa Time', '7200', 'UTC+02:00', 'CAT', '2025-04-14 14:06:56', '2025-04-14 14:06:56');

-- --------------------------------------------------------

--
-- Table structure for table `todo_items`
--

CREATE TABLE `todo_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `title` varchar(191) NOT NULL,
  `status` enum('pending','completed') NOT NULL DEFAULT 'pending',
  `position` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `universal_searches`
--

CREATE TABLE `universal_searches` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `searchable_id` varchar(191) NOT NULL,
  `searchable_type` varchar(191) NOT NULL,
  `title` varchar(191) NOT NULL,
  `route_name` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `universal_searches`
--

INSERT INTO `universal_searches` (`id`, `searchable_id`, `searchable_type`, `title`, `route_name`, `created_at`, `updated_at`) VALUES
(2, 'about-us', 'Page', 'About Us', 'admin.pages.edit', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(3, 'contact-us', 'Page', 'Contact Us', 'admin.pages.edit', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(4, 'how-it-works', 'Page', 'How It Works', 'admin.pages.edit', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(5, 'privacy-policy', 'Page', 'Privacy Policy', 'admin.pages.edit', '2025-04-14 14:06:53', '2025-04-14 14:06:53'),
(6, 'blog', 'Page', 'Blog', 'admin.pages.edit', '2025-04-14 14:06:54', '2025-04-14 14:06:54'),
(7, 'terms-and-conditions', 'Page', 'Terms And Conditions', 'admin.pages.edit', '2025-04-14 14:06:54', '2025-04-14 14:06:54'),
(8, '2', 'Location', 'Sydney, Australia', 'admin.locations.edit', '2025-04-16 05:36:42', '2025-04-16 05:36:42'),
(10, '1', 'Service', 'Split AC Installation', 'admin.business-services.edit', '2025-04-16 22:15:54', '2025-04-16 22:15:54'),
(11, '2', 'Service', 'Window AC Installation', 'admin.business-services.edit', '2025-04-16 22:24:42', '2025-04-16 22:24:42'),
(12, '3', 'Service', 'Split AC Uninstallation', 'admin.business-services.edit', '2025-04-16 22:28:38', '2025-04-16 22:28:38'),
(14, '4', 'Service', 'Washing Machine Repair', 'admin.business-services.edit', '2025-04-16 23:13:47', '2025-04-16 23:13:47'),
(15, '3', 'Category', 'General Medicine', 'admin.categories.edit', '2025-04-16 23:27:56', '2025-04-16 23:27:56'),
(16, '4', 'Category', 'Ayurvedic', 'admin.categories.edit', '2025-04-16 23:36:47', '2025-04-16 23:36:47'),
(17, '5', 'Category', 'Physiotherapy', 'admin.categories.edit', '2025-04-16 23:37:08', '2025-04-16 23:37:08'),
(18, '6', 'Category', 'Chiropracter', 'admin.categories.edit', '2025-04-16 23:37:33', '2025-04-16 23:37:33'),
(19, '7', 'Category', 'Optomologist', 'admin.categories.edit', '2025-04-16 23:38:49', '2025-04-16 23:38:49'),
(20, '5', 'Service', 'Initial Consultation', 'admin.business-services.edit', '2025-04-16 23:39:03', '2025-04-16 23:54:04'),
(21, '8', 'Category', 'Nutritionist Consultant', 'admin.categories.edit', '2025-04-16 23:39:05', '2025-04-16 23:39:05'),
(22, '9', 'Category', 'Dental Care', 'admin.categories.edit', '2025-04-16 23:50:34', '2025-04-16 23:50:34'),
(23, '10', 'Category', 'Wellness & Fitness', 'admin.categories.edit', '2025-04-16 23:50:49', '2025-04-16 23:50:49'),
(24, '6', 'Service', 'Initial Consultation', 'admin.business-services.edit', '2025-04-16 23:52:25', '2025-04-16 23:54:42'),
(25, '7', 'Service', 'Initial Consultation', 'admin.business-services.edit', '2025-04-17 00:24:04', '2025-04-17 00:24:04'),
(28, '3', 'Customer', 'Abhishek Bhatt', 'admin.customers.show', '2025-04-23 09:23:47', '2025-04-23 09:23:47'),
(29, '3', 'Customer', 'abhatt4522@gmail.com', 'admin.customers.show', '2025-04-23 09:23:47', '2025-04-23 09:23:47'),
(30, '4', 'Employee', 'Kapil Raina', 'admin.employee.edit', '2025-04-23 09:28:12', '2025-04-23 09:28:12'),
(31, '4', 'Employee', 'kapilraina@gmail.com', 'admin.employee.edit', '2025-04-23 09:28:12', '2025-04-23 09:28:12'),
(32, '5', 'Customer', 'Sanjay Bindal', 'admin.customers.show', '2025-04-23 09:37:17', '2025-04-23 09:37:17'),
(33, '5', 'Customer', 'sanjaybindal0405@gmail.com', 'admin.customers.show', '2025-04-23 09:37:17', '2025-04-23 09:37:17');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `name` varchar(191) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `calling_code` varchar(191) DEFAULT NULL,
  `mobile` varchar(191) DEFAULT NULL,
  `mobile_verified` tinyint(1) NOT NULL DEFAULT 0,
  `password` varchar(191) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `rtl` enum('enabled','disabled') NOT NULL DEFAULT 'disabled',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `country_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `group_id`, `name`, `email`, `calling_code`, `mobile`, `mobile_verified`, `password`, `image`, `remember_token`, `rtl`, `created_at`, `updated_at`, `deleted_at`, `country_id`) VALUES
(1, NULL, 'M.S.Dhoni', 'admin@example.com', '+61', '1919191919', 0, '$2y$10$Q13W7ggBne.ZfvLBfaOxQ.3hVHUzF9ivOmxX9j27DSZoKQIQGPb0G', '9b57554af8aea82b558d185701740441.png', NULL, '', '2025-04-14 14:07:30', '2025-04-16 05:53:14', NULL, NULL),
(3, NULL, 'Abhishek Bhatt', 'abhatt4522@gmail.com', NULL, '9999049325', 0, '$2y$10$/xj6oPj.2zCji/HaYT66g.2cwAq6uuv9GWEE3YvFK0fGiXyQclTw.', NULL, NULL, 'disabled', '2025-04-23 09:23:47', '2025-04-23 09:23:47', NULL, NULL),
(4, NULL, 'Kapil Raina', 'kapilraina@gmail.com', '+61', '9876543211', 0, '$2y$10$w21kLNj25j4gyZfBJ4pCE.iMT29r27K2iDU/1XzNAnd8J/fSyODCe', NULL, NULL, 'disabled', '2025-04-23 09:28:12', '2025-04-23 09:29:48', NULL, NULL),
(5, NULL, 'Sanjay Bindal', 'sanjaybindal0405@gmail.com', NULL, '987655543', 0, '$2y$10$qodQZbFMqWTF.U.TmKdALu.L.owtwQMi/5TwIypQBRBZbv1MY3kWm', NULL, NULL, 'disabled', '2025-04-23 09:37:17', '2025-05-01 15:11:44', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_memberships`
--

CREATE TABLE `user_memberships` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `membership_id` int(10) UNSIGNED NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `user_memberships`
--

INSERT INTO `user_memberships` (`id`, `user_id`, `membership_id`, `start_date`, `end_date`, `is_active`, `created_at`, `updated_at`) VALUES
(3, 1, 2, '2025-05-01', '2025-05-31', 1, '2025-05-01 23:57:07', '2025-05-01 23:57:07'),
(4, 1, 2, '2025-05-01', '2025-05-31', 1, '2025-05-01 23:58:30', '2025-05-01 23:58:30');

-- --------------------------------------------------------

--
-- Table structure for table `zoom_meetings`
--

CREATE TABLE `zoom_meetings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `meeting_id` varchar(50) DEFAULT NULL,
  `host_id` int(10) UNSIGNED DEFAULT NULL,
  `created_by` int(10) UNSIGNED DEFAULT NULL,
  `booking_id` int(10) UNSIGNED NOT NULL,
  `meeting_name` varchar(100) NOT NULL,
  `description` mediumtext DEFAULT NULL,
  `start_date_time` datetime NOT NULL,
  `end_date_time` datetime NOT NULL,
  `host_video` tinyint(1) NOT NULL DEFAULT 0,
  `start_link` varchar(191) DEFAULT NULL,
  `join_link` varchar(191) DEFAULT NULL,
  `status` enum('waiting','live','canceled','finished') NOT NULL DEFAULT 'waiting',
  `password` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `zoom_settings`
--

CREATE TABLE `zoom_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `api_key` varchar(50) DEFAULT NULL,
  `secret_key` varchar(50) DEFAULT NULL,
  `purchase_code` varchar(191) DEFAULT NULL,
  `meeting_app` varchar(191) NOT NULL,
  `supported_until` timestamp NULL DEFAULT NULL,
  `enable_zoom` enum('active','inactive') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_unicode_ci;

--
-- Dumping data for table `zoom_settings`
--

INSERT INTO `zoom_settings` (`id`, `api_key`, `secret_key`, `purchase_code`, `meeting_app`, `supported_until`, `enable_zoom`, `created_at`, `updated_at`) VALUES
(1, NULL, NULL, NULL, 'in_app', NULL, 'inactive', NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `addresses_user_id_foreign` (`user_id`),
  ADD KEY `addresses_country_id_foreign` (`country_id`);

--
-- Indexes for table `advertisement_banners`
--
ALTER TABLE `advertisement_banners`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bookings_user_id_foreign` (`user_id`),
  ADD KEY `bookings_coupon_id_foreign` (`coupon_id`),
  ADD KEY `bookings_deal_id_foreign` (`deal_id`);

--
-- Indexes for table `booking_items`
--
ALTER TABLE `booking_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_items_booking_id_foreign` (`booking_id`),
  ADD KEY `booking_items_business_service_id_foreign` (`business_service_id`),
  ADD KEY `booking_items_product_id_foreign` (`product_id`);

--
-- Indexes for table `booking_notifactions`
--
ALTER TABLE `booking_notifactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `booking_times`
--
ALTER TABLE `booking_times`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_times_location_id_foreign` (`location_id`);

--
-- Indexes for table `booking_user`
--
ALTER TABLE `booking_user`
  ADD PRIMARY KEY (`booking_id`,`user_id`),
  ADD KEY `booking_user_user_id_foreign` (`user_id`);

--
-- Indexes for table `business_services`
--
ALTER TABLE `business_services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `business_services_category_id_foreign` (`category_id`),
  ADD KEY `business_services_location_id_foreign` (`location_id`);

--
-- Indexes for table `business_service_user`
--
ALTER TABLE `business_service_user`
  ADD PRIMARY KEY (`business_service_id`,`user_id`),
  ADD KEY `business_service_user_user_id_foreign` (`user_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `company_settings`
--
ALTER TABLE `company_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `company_settings_currency_id_foreign` (`currency_id`);

--
-- Indexes for table `countries`
--
ALTER TABLE `countries`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coupon_users`
--
ALTER TABLE `coupon_users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coupon_users_coupon_id_foreign` (`coupon_id`),
  ADD KEY `coupon_users_user_id_foreign` (`user_id`);

--
-- Indexes for table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `currency_format_settings`
--
ALTER TABLE `currency_format_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer_feedback`
--
ALTER TABLE `customer_feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_feedback_user_id_foreign` (`user_id`),
  ADD KEY `customer_feedback_booking_id_foreign` (`booking_id`);

--
-- Indexes for table `deals`
--
ALTER TABLE `deals`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `deal_items`
--
ALTER TABLE `deal_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `deal_items_deal_id_foreign` (`deal_id`),
  ADD KEY `deal_items_business_service_id_foreign` (`business_service_id`);

--
-- Indexes for table `employee_groups`
--
ALTER TABLE `employee_groups`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `employee_group_services`
--
ALTER TABLE `employee_group_services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_group_services_employee_groups_id_foreign` (`employee_groups_id`),
  ADD KEY `employee_group_services_business_service_id_foreign` (`business_service_id`);

--
-- Indexes for table `employee_schedules`
--
ALTER TABLE `employee_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_schedules_employee_id_foreign` (`employee_id`),
  ADD KEY `employee_schedules_location_id_foreign` (`location_id`);

--
-- Indexes for table `footer_settings`
--
ALTER TABLE `footer_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `front_theme_settings`
--
ALTER TABLE `front_theme_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `google_captcha_settings`
--
ALTER TABLE `google_captcha_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `google_map_api_keys`
--
ALTER TABLE `google_map_api_keys`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `item_taxes`
--
ALTER TABLE `item_taxes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_taxes_tax_id_foreign` (`tax_id`),
  ADD KEY `item_taxes_service_id_foreign` (`service_id`),
  ADD KEY `item_taxes_deal_id_foreign` (`deal_id`),
  ADD KEY `item_taxes_product_id_foreign` (`product_id`);

--
-- Indexes for table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leaves`
--
ALTER TABLE `leaves`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leaves_employee_id_foreign` (`employee_id`);

--
-- Indexes for table `locations`
--
ALTER TABLE `locations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `locations_country_id_foreign` (`country_id`),
  ADD KEY `locations_timezone_id_foreign` (`timezone_id`);

--
-- Indexes for table `location_user`
--
ALTER TABLE `location_user`
  ADD PRIMARY KEY (`location_id`,`user_id`),
  ADD KEY `location_user_user_id_foreign` (`user_id`);

--
-- Indexes for table `ltm_translations`
--
ALTER TABLE `ltm_translations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `memberships`
--
ALTER TABLE `memberships`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `modules`
--
ALTER TABLE `modules`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `new_deals`
--
ALTER TABLE `new_deals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `new_deals_location_id_foreign` (`location_id`);

--
-- Indexes for table `office_leaves`
--
ALTER TABLE `office_leaves`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `payments_transaction_id_unique` (`transaction_id`),
  ADD UNIQUE KEY `payments_event_id_unique` (`event_id`),
  ADD KEY `payments_booking_id_foreign` (`booking_id`);

--
-- Indexes for table `payment_gateway_credentials`
--
ALTER TABLE `payment_gateway_credentials`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`);

--
-- Indexes for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `permission_role_role_id_foreign` (`role_id`);

--
-- Indexes for table `permission_user`
--
ALTER TABLE `permission_user`
  ADD PRIMARY KEY (`user_id`,`permission_id`,`user_type`),
  ADD KEY `permission_user_permission_id_foreign` (`permission_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `products_location_id_foreign` (`location_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_unique` (`name`);

--
-- Indexes for table `role_user`
--
ALTER TABLE `role_user`
  ADD PRIMARY KEY (`user_id`,`role_id`,`user_type`),
  ADD KEY `role_user_role_id_foreign` (`role_id`);

--
-- Indexes for table `service_reviews`
--
ALTER TABLE `service_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_id` (`booking_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `service_id` (`service_id`);

--
-- Indexes for table `sms_settings`
--
ALTER TABLE `sms_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `smtp_settings`
--
ALTER TABLE `smtp_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `socials`
--
ALTER TABLE `socials`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `social_auth_settings`
--
ALTER TABLE `social_auth_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `taxes`
--
ALTER TABLE `taxes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `theme_settings`
--
ALTER TABLE `theme_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `timezones`
--
ALTER TABLE `timezones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `timezones_country_id_foreign` (`country_id`);

--
-- Indexes for table `todo_items`
--
ALTER TABLE `todo_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `todo_items_user_id_foreign` (`user_id`);

--
-- Indexes for table `universal_searches`
--
ALTER TABLE `universal_searches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_country_id_foreign` (`country_id`);

--
-- Indexes for table `user_memberships`
--
ALTER TABLE `user_memberships`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `membership_id` (`membership_id`);

--
-- Indexes for table `zoom_meetings`
--
ALTER TABLE `zoom_meetings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `zoom_meetings_host_id_foreign` (`host_id`),
  ADD KEY `zoom_meetings_created_by_foreign` (`created_by`),
  ADD KEY `zoom_meetings_booking_id_foreign` (`booking_id`);

--
-- Indexes for table `zoom_settings`
--
ALTER TABLE `zoom_settings`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `advertisement_banners`
--
ALTER TABLE `advertisement_banners`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `booking_items`
--
ALTER TABLE `booking_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `booking_notifactions`
--
ALTER TABLE `booking_notifactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_times`
--
ALTER TABLE `booking_times`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `business_services`
--
ALTER TABLE `business_services`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `company_settings`
--
ALTER TABLE `company_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=254;

--
-- AUTO_INCREMENT for table `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `coupon_users`
--
ALTER TABLE `coupon_users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `currency_format_settings`
--
ALTER TABLE `currency_format_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_feedback`
--
ALTER TABLE `customer_feedback`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `deals`
--
ALTER TABLE `deals`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `deal_items`
--
ALTER TABLE `deal_items`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `employee_groups`
--
ALTER TABLE `employee_groups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee_group_services`
--
ALTER TABLE `employee_group_services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employee_schedules`
--
ALTER TABLE `employee_schedules`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `footer_settings`
--
ALTER TABLE `footer_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `front_theme_settings`
--
ALTER TABLE `front_theme_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `google_captcha_settings`
--
ALTER TABLE `google_captcha_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `google_map_api_keys`
--
ALTER TABLE `google_map_api_keys`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `item_taxes`
--
ALTER TABLE `item_taxes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `languages`
--
ALTER TABLE `languages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `leaves`
--
ALTER TABLE `leaves`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `locations`
--
ALTER TABLE `locations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `ltm_translations`
--
ALTER TABLE `ltm_translations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `media`
--
ALTER TABLE `media`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `memberships`
--
ALTER TABLE `memberships`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=149;

--
-- AUTO_INCREMENT for table `modules`
--
ALTER TABLE `modules`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `new_deals`
--
ALTER TABLE `new_deals`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `office_leaves`
--
ALTER TABLE `office_leaves`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `payment_gateway_credentials`
--
ALTER TABLE `payment_gateway_credentials`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `service_reviews`
--
ALTER TABLE `service_reviews`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `sms_settings`
--
ALTER TABLE `sms_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `smtp_settings`
--
ALTER TABLE `smtp_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `socials`
--
ALTER TABLE `socials`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `social_auth_settings`
--
ALTER TABLE `social_auth_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `taxes`
--
ALTER TABLE `taxes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `theme_settings`
--
ALTER TABLE `theme_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `timezones`
--
ALTER TABLE `timezones`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=429;

--
-- AUTO_INCREMENT for table `todo_items`
--
ALTER TABLE `todo_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `universal_searches`
--
ALTER TABLE `universal_searches`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user_memberships`
--
ALTER TABLE `user_memberships`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `zoom_meetings`
--
ALTER TABLE `zoom_meetings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `zoom_settings`
--
ALTER TABLE `zoom_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `addresses_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_coupon_id_foreign` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bookings_deal_id_foreign` FOREIGN KEY (`deal_id`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `bookings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `booking_items`
--
ALTER TABLE `booking_items`
  ADD CONSTRAINT `booking_items_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `booking_items_business_service_id_foreign` FOREIGN KEY (`business_service_id`) REFERENCES `business_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `booking_items_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `booking_times`
--
ALTER TABLE `booking_times`
  ADD CONSTRAINT `booking_times_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `booking_user`
--
ALTER TABLE `booking_user`
  ADD CONSTRAINT `booking_user_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `booking_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `business_services`
--
ALTER TABLE `business_services`
  ADD CONSTRAINT `business_services_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `business_services_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `business_service_user`
--
ALTER TABLE `business_service_user`
  ADD CONSTRAINT `business_service_user_business_service_id_foreign` FOREIGN KEY (`business_service_id`) REFERENCES `business_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `business_service_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `company_settings`
--
ALTER TABLE `company_settings`
  ADD CONSTRAINT `company_settings_currency_id_foreign` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `coupon_users`
--
ALTER TABLE `coupon_users`
  ADD CONSTRAINT `coupon_users_coupon_id_foreign` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `coupon_users_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `customer_feedback`
--
ALTER TABLE `customer_feedback`
  ADD CONSTRAINT `customer_feedback_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `customer_feedback_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `deal_items`
--
ALTER TABLE `deal_items`
  ADD CONSTRAINT `deal_items_business_service_id_foreign` FOREIGN KEY (`business_service_id`) REFERENCES `business_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `deal_items_deal_id_foreign` FOREIGN KEY (`deal_id`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `employee_group_services`
--
ALTER TABLE `employee_group_services`
  ADD CONSTRAINT `employee_group_services_business_service_id_foreign` FOREIGN KEY (`business_service_id`) REFERENCES `business_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `employee_group_services_employee_groups_id_foreign` FOREIGN KEY (`employee_groups_id`) REFERENCES `employee_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `employee_schedules`
--
ALTER TABLE `employee_schedules`
  ADD CONSTRAINT `employee_schedules_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `employee_schedules_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `item_taxes`
--
ALTER TABLE `item_taxes`
  ADD CONSTRAINT `item_taxes_deal_id_foreign` FOREIGN KEY (`deal_id`) REFERENCES `deals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `item_taxes_product_id_foreign` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `item_taxes_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `business_services` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `item_taxes_tax_id_foreign` FOREIGN KEY (`tax_id`) REFERENCES `taxes` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `leaves`
--
ALTER TABLE `leaves`
  ADD CONSTRAINT `leaves_employee_id_foreign` FOREIGN KEY (`employee_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `locations`
--
ALTER TABLE `locations`
  ADD CONSTRAINT `locations_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `locations_timezone_id_foreign` FOREIGN KEY (`timezone_id`) REFERENCES `timezones` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `location_user`
--
ALTER TABLE `location_user`
  ADD CONSTRAINT `location_user_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `location_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `new_deals`
--
ALTER TABLE `new_deals`
  ADD CONSTRAINT `new_deals_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `permission_user`
--
ALTER TABLE `permission_user`
  ADD CONSTRAINT `permission_user_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_location_id_foreign` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`);

--
-- Constraints for table `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `service_reviews`
--
ALTER TABLE `service_reviews`
  ADD CONSTRAINT `service_reviews_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `service_reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `service_reviews_ibfk_3` FOREIGN KEY (`service_id`) REFERENCES `business_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `timezones`
--
ALTER TABLE `timezones`
  ADD CONSTRAINT `timezones_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `todo_items`
--
ALTER TABLE `todo_items`
  ADD CONSTRAINT `todo_items_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_country_id_foreign` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `user_memberships`
--
ALTER TABLE `user_memberships`
  ADD CONSTRAINT `user_memberships_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_memberships_ibfk_2` FOREIGN KEY (`membership_id`) REFERENCES `memberships` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `zoom_meetings`
--
ALTER TABLE `zoom_meetings`
  ADD CONSTRAINT `zoom_meetings_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `zoom_meetings_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `zoom_meetings_host_id_foreign` FOREIGN KEY (`host_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
