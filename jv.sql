-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 08, 2024 at 02:04 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.1.17

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jv`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `merge_user_cart_product` (IN `old_cart_id` BIGINT, IN `new_cart_id` BIGINT)   BEGIN
    -- Create a temporary table
    CREATE TEMPORARY TABLE temp_user_cart_item_product (
        id INT NOT NULL AUTO_INCREMENT,
        product_id BIGINT,
        product_sku VARCHAR(20),
        product_qty INT,
        unit_price DECIMAL(10,2),
      	
        PRIMARY KEY(id),
        CONSTRAINT uniq_product_id UNIQUE(product_id,product_sku)
    );

    -- Insert data into the temporary table using the input parameters
     INSERT INTO temp_user_cart_item_product (product_id, product_sku, product_qty, unit_price)
    	SELECT product_id, product_sku, qty AS product_qty, unit_price FROM jv_customer_cart_items WHERE cart_id = old_cart_id;
        
     INSERT INTO temp_user_cart_item_product (product_id, product_sku, product_qty, unit_price)
    	SELECT product_id, product_sku, qty AS product_qty, unit_price FROM jv_customer_cart_items WHERE cart_id = new_cart_id
     ON DUPLICATE KEY UPDATE product_qty = product_qty + VALUES(product_qty);

    -- Query the temporary table
    SELECT * FROM temp_user_cart_item_product;

    -- Don't forget to drop the temporary table at the end of the procedure
    DROP TEMPORARY TABLE temp_user_cart_item_product;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `merge_user_cart_service` (IN `old_cart_id` BIGINT, IN `new_cart_id` BIGINT)   BEGIN
    -- Create a temporary table
    CREATE TEMPORARY TABLE temp_user_cart_item_service (
        id INT NOT NULL AUTO_INCREMENT,
        service_id BIGINT,
        item_qty INT,
        unit_price DECIMAL(10,2),
      	
        PRIMARY KEY(id),
        CONSTRAINT uniq_service_id UNIQUE(service_id)
    );

    -- Insert data into the temporary table using the input parameters
     INSERT INTO temp_user_cart_item_service (service_id, item_qty, unit_price)
    	SELECT service_id, qty AS item_qty, unit_price FROM jv_customer_cart_service_items WHERE cart_id = old_cart_id;
        
     INSERT INTO temp_user_cart_item_service (service_id, item_qty, unit_price)
    	SELECT service_id, qty AS item_qty, unit_price FROM jv_customer_cart_service_items WHERE cart_id = new_cart_id
     ON DUPLICATE KEY UPDATE item_qty = item_qty + VALUES(item_qty);

    -- Query the temporary table
    SELECT * FROM temp_user_cart_item_service;

    -- Don't forget to drop the temporary table at the end of the procedure
    DROP TEMPORARY TABLE temp_user_cart_item_service;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_image_url` (`image_name` VARCHAR(200)) RETURNS VARCHAR(1000) CHARSET utf8mb4 COLLATE utf8mb4_general_ci  BEGIN

    DECLARE final_url VARCHAR(1000);

    SET final_url = CONCAT('https://ik.imagekit.io/5o2uz1trj/', image_name);

    RETURN final_url;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `app_settings`
--

CREATE TABLE `app_settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `site_name` varchar(191) DEFAULT NULL,
  `site_email` varchar(191) DEFAULT NULL,
  `site_logo` varchar(191) DEFAULT NULL,
  `site_favicon` varchar(191) DEFAULT NULL,
  `site_description` longtext DEFAULT NULL,
  `site_copyright` varchar(191) DEFAULT NULL,
  `facebook_url` varchar(191) DEFAULT NULL,
  `instagram_url` varchar(191) DEFAULT NULL,
  `twitter_url` varchar(191) DEFAULT NULL,
  `linkedin_url` varchar(191) DEFAULT NULL,
  `remember_token` varchar(191) DEFAULT NULL,
  `language_option` text DEFAULT NULL,
  `inquriy_email` varchar(191) DEFAULT NULL,
  `helpline_number` varchar(191) DEFAULT NULL,
  `time_zone` varchar(191) DEFAULT NULL,
  `earning_type` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `app_settings`
--

INSERT INTO `app_settings` (`id`, `site_name`, `site_email`, `site_logo`, `site_favicon`, `site_description`, `site_copyright`, `facebook_url`, `instagram_url`, `twitter_url`, `linkedin_url`, `remember_token`, `language_option`, `inquriy_email`, `helpline_number`, `time_zone`, `earning_type`) VALUES
(1, 'JV Services', NULL, '/tmp/phpfmNxao', '/tmp/phptvEDQt', 'hello', 'CopyRight@JV Services', NULL, NULL, NULL, NULL, NULL, '[\"fr\",\"en\"]', 'info@jvservices.ca', NULL, 'America/New_York', 'commission');

-- --------------------------------------------------------

--
-- Table structure for table `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `service_id` bigint(20) UNSIGNED DEFAULT NULL,
  `provider_id` bigint(20) UNSIGNED DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `start_at` datetime DEFAULT NULL,
  `end_at` datetime DEFAULT NULL,
  `booking_date` datetime DEFAULT NULL,
  `booking_time` varchar(40) DEFAULT NULL,
  `quantity` int(11) DEFAULT 0,
  `amount` double DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `total_amount` double DEFAULT NULL,
  `description` text DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `coupon_id` bigint(20) DEFAULT NULL,
  `status` varchar(191) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `payment_id` bigint(20) DEFAULT NULL,
  `duration_diff` varchar(191) DEFAULT '0',
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `booking_address_id` bigint(20) UNSIGNED DEFAULT NULL,
  `tax` longtext DEFAULT NULL,
  `transaction_id` varchar(200) DEFAULT NULL,
  `tx_status` varchar(50) DEFAULT NULL,
  `tx_date` varchar(30) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_activities`
--

CREATE TABLE `booking_activities` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) DEFAULT NULL,
  `datetime` timestamp NULL DEFAULT NULL,
  `activity_type` varchar(191) DEFAULT NULL,
  `activity_message` text DEFAULT NULL,
  `activity_data` text DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `booking_activities`
--

INSERT INTO `booking_activities` (`id`, `booking_id`, `datetime`, `activity_type`, `activity_message`, `activity_data`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, '2022-06-04 14:38:59', 'add_booking', 'New Booking added by customer', '{\"service_id\":3,\"service_name\":\"THE COMB OVER\",\"customer_id\":22,\"customer_name\":\"Venkatesh Kota\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-04 14:38:59', '2022-06-04 14:38:59'),
(2, 1, '2022-06-04 14:40:24', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-04 14:40:24', '2022-06-04 14:40:24'),
(3, 1, '2022-06-04 14:44:21', 'update_booking_status', 'Booking status has been changed from Accept to On Going.', '{\"reason\":null,\"status\":\"on_going\",\"status_label\":\"On Going\",\"old_status\":\"accept\",\"old_status_label\":\"Accept\"}', NULL, '2022-06-04 14:44:21', '2022-06-04 14:44:21'),
(4, 1, '2022-06-04 14:44:45', 'update_booking_status', 'Booking status has been changed from On Going to In Progress.', '{\"reason\":null,\"status\":\"in_progress\",\"status_label\":\"In Progress\",\"old_status\":\"on_going\",\"old_status_label\":\"On Going\"}', NULL, '2022-06-04 14:44:45', '2022-06-04 14:44:45'),
(5, 1, '2022-06-04 14:45:42', 'update_booking_status', 'Booking status has been changed from In Progress to Completed.', '{\"reason\":\"Work Done\",\"status\":\"completed\",\"status_label\":\"Completed\",\"old_status\":\"in_progress\",\"old_status_label\":\"In Progress\"}', NULL, '2022-06-04 14:45:42', '2022-06-04 14:45:42'),
(6, 1, '2022-06-04 14:49:15', 'payment_message_status', 'Your payment is paid', '{\"activity_type\":\"payment_message_status\",\"payment_status\":\"paid\",\"booking_id\":\"1\"}', NULL, '2022-06-04 14:49:15', '2022-06-04 14:49:15'),
(7, 2, '2022-06-06 11:07:19', 'add_booking', 'New Booking added by customer', '{\"service_id\":6,\"service_name\":\"STRAIGH FADE\",\"customer_id\":22,\"customer_name\":\"Venkatesh Kota\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-06 11:07:19', '2022-06-06 11:07:19'),
(8, 2, '2022-06-06 11:07:47', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-06 11:07:47', '2022-06-06 11:07:47'),
(9, 2, '2022-06-06 11:08:37', 'update_booking_status', 'Booking status has been changed from Accept to In Progress.', '{\"reason\":null,\"status\":\"in_progress\",\"status_label\":\"In Progress\",\"old_status\":\"accept\",\"old_status_label\":\"Accept\"}', NULL, '2022-06-06 11:08:37', '2022-06-06 11:08:37'),
(10, 2, '2022-06-06 11:10:46', 'update_booking_status', 'Booking status has been changed from In Progress to Completed.', '{\"reason\":null,\"status\":\"completed\",\"status_label\":\"Completed\",\"old_status\":\"in_progress\",\"old_status_label\":\"In Progress\"}', NULL, '2022-06-06 11:10:46', '2022-06-06 11:10:46'),
(11, 3, '2022-06-06 12:27:06', 'add_booking', 'New Booking added by customer', '{\"service_id\":1,\"service_name\":\"Traditional Haircut\",\"customer_id\":22,\"customer_name\":\"Venkatesh Kota\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-06 12:27:06', '2022-06-06 12:27:06'),
(12, 3, '2022-06-06 12:27:29', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-06 12:27:29', '2022-06-06 12:27:29'),
(13, 3, '2022-06-06 12:28:31', 'update_booking_status', 'Booking status has been changed from Accept to Completed.', '{\"reason\":\"Work Done\",\"status\":\"completed\",\"status_label\":\"Completed\",\"old_status\":\"accept\",\"old_status_label\":\"Accept\"}', NULL, '2022-06-06 12:28:31', '2022-06-06 12:28:31'),
(14, 4, '2022-06-08 03:13:09', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"18.Quiff Short\",\"customer_id\":46,\"customer_name\":\"Sirajuddin Shaik\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 03:13:09', '2022-06-08 03:13:09'),
(15, 5, '2022-06-08 03:13:59', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"18.Quiff Short\",\"customer_id\":46,\"customer_name\":\"Sirajuddin Shaik\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 03:13:59', '2022-06-08 03:13:59'),
(16, 6, '2022-06-08 03:19:34', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"18.Quiff Short\",\"customer_id\":46,\"customer_name\":\"Sirajuddin Shaik\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 03:19:34', '2022-06-08 03:19:34'),
(17, 7, '2022-06-08 03:31:19', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"18.Quiff Short\",\"customer_id\":46,\"customer_name\":\"Sirajuddin Shaik\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 03:31:19', '2022-06-08 03:31:19'),
(18, 7, '2022-06-08 03:33:12', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-08 03:33:12', '2022-06-08 03:33:12'),
(19, 8, '2022-06-08 03:36:16', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"18.Quiff Short\",\"customer_id\":46,\"customer_name\":\"Sirajuddin Shaik\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 03:36:16', '2022-06-08 03:36:16'),
(20, 9, '2022-06-08 18:23:26', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"18.Quiff Short\",\"customer_id\":50,\"customer_name\":\"Arun Shinde\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 18:23:26', '2022-06-08 18:23:26'),
(21, 10, '2022-06-08 18:24:04', 'add_booking', 'New Booking added by customer', '{\"service_id\":33,\"service_name\":\"TEST SERVICE 4\",\"customer_id\":50,\"customer_name\":\"Arun Shinde\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 18:24:04', '2022-06-08 18:24:04'),
(22, 11, '2022-06-08 18:28:46', 'add_booking', 'New Booking added by customer', '{\"service_id\":33,\"service_name\":\"TEST SERVICE 4\",\"customer_id\":46,\"customer_name\":\"Sirajuddin Shaik\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 18:28:46', '2022-06-08 18:28:46'),
(23, 12, '2022-06-08 18:29:59', 'add_booking', 'New Booking added by customer', '{\"service_id\":32,\"service_name\":\"TEST SERVICE 2\",\"customer_id\":46,\"customer_name\":\"Sirajuddin Shaik\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 18:29:59', '2022-06-08 18:29:59'),
(24, 12, '2022-06-08 18:30:24', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-08 18:30:24', '2022-06-08 18:30:24'),
(25, 11, '2022-06-08 18:31:17', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-08 18:31:17', '2022-06-08 18:31:17'),
(26, 9, '2022-06-08 18:31:28', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-08 18:31:28', '2022-06-08 18:31:28'),
(27, 12, '2022-06-08 18:45:47', 'assigned_booking', 'Booking has been assigned to Handyman Demo ', '{\"handyman_id\":[5],\"handyman_name\":[{\"id\":1,\"booking_id\":12,\"handyman_id\":5,\"deleted_at\":null,\"created_at\":null,\"updated_at\":null,\"handyman\":{\"id\":5,\"username\":\"handyman\",\"first_name\":\"Handyman\",\"last_name\":\"Demo\",\"email\":\"demo@handyman.com\",\"user_type\":\"handyman\",\"contact_number\":\"4564552664\",\"country_id\":181,\"state_id\":3924,\"city_id\":42865,\"provider_id\":4,\"address\":null,\"player_id\":null,\"status\":1,\"display_name\":\"Handyman Demo\",\"providertype_id\":null,\"is_featured\":0,\"time_zone\":\"UTC\",\"last_notification_seen\":null,\"email_verified_at\":null,\"deleted_at\":null,\"created_at\":\"2021-05-29T05:43:24.000000Z\",\"updated_at\":null,\"login_type\":null,\"service_address_id\":null,\"uid\":null,\"handymantype_id\":null,\"is_subscribe\":0}}]}', NULL, '2022-06-08 18:45:47', '2022-06-08 18:45:47'),
(28, 12, '2022-06-08 18:49:25', 'cancel_booking', 'Booking has been cancelled.', '{\"reason\":null,\"status\":\"cancelled\",\"status_label\":\"Cancelled\"}', NULL, '2022-06-08 18:49:25', '2022-06-08 18:49:25'),
(29, 13, '2022-06-08 19:04:09', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"18.Quiff Short\",\"customer_id\":46,\"customer_name\":\"Sirajuddin Shaik\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-08 19:04:09', '2022-06-08 19:04:09'),
(30, 13, '2022-06-08 19:04:43', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-08 19:04:43', '2022-06-08 19:04:43'),
(31, 13, '2022-06-08 19:05:26', 'assigned_booking', 'Booking has been assigned to Handyman Demo ', '{\"handyman_id\":[5],\"handyman_name\":[{\"id\":2,\"booking_id\":13,\"handyman_id\":5,\"deleted_at\":null,\"created_at\":null,\"updated_at\":null,\"handyman\":{\"id\":5,\"username\":\"handyman\",\"first_name\":\"Handyman\",\"last_name\":\"Demo\",\"email\":\"demo@handyman.com\",\"user_type\":\"handyman\",\"contact_number\":\"4564552664\",\"country_id\":181,\"state_id\":3924,\"city_id\":42865,\"provider_id\":4,\"address\":null,\"player_id\":null,\"status\":1,\"display_name\":\"Handyman Demo\",\"providertype_id\":null,\"is_featured\":0,\"time_zone\":\"UTC\",\"last_notification_seen\":null,\"email_verified_at\":null,\"deleted_at\":null,\"created_at\":\"2021-05-29T05:43:24.000000Z\",\"updated_at\":null,\"login_type\":null,\"service_address_id\":null,\"uid\":null,\"handymantype_id\":null,\"is_subscribe\":0}}]}', NULL, '2022-06-08 19:05:26', '2022-06-08 19:05:26'),
(32, 7, '2022-06-08 22:19:28', 'cancel_booking', 'Booking has been cancelled.', '{\"reason\":\"test call\",\"status\":\"cancelled\",\"status_label\":\"Cancelled\"}', NULL, '2022-06-08 22:19:28', '2022-06-08 22:19:28'),
(33, 14, '2022-06-09 01:06:06', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"18.Quiff Short\",\"customer_id\":42,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-09 01:06:06', '2022-06-09 01:06:06'),
(34, 15, '2022-06-09 05:11:35', 'add_booking', 'New Booking added by customer', '{\"service_id\":27,\"service_name\":\"16.Pompadour\",\"customer_id\":46,\"customer_name\":\"Sirajuddin Shaik\",\"provider_id\":4,\"provider_name\":\"Provider Demo\"}', NULL, '2022-06-09 05:11:35', '2022-06-09 05:11:35'),
(35, 15, '2022-06-09 05:12:05', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-09 05:12:05', '2022-06-09 05:12:05'),
(36, 15, '2022-06-09 05:13:10', 'assigned_booking', 'Booking has been assigned to Handyman Demo ', '{\"handyman_id\":[5],\"handyman_name\":[{\"id\":3,\"booking_id\":15,\"handyman_id\":5,\"deleted_at\":null,\"created_at\":null,\"updated_at\":null,\"handyman\":{\"id\":5,\"username\":\"handyman\",\"first_name\":\"Handyman\",\"last_name\":\"Demo\",\"email\":\"demo@handyman.com\",\"user_type\":\"handyman\",\"contact_number\":\"4564552664\",\"country_id\":181,\"state_id\":3924,\"city_id\":42865,\"provider_id\":4,\"address\":null,\"player_id\":null,\"status\":1,\"display_name\":\"Handyman Demo\",\"providertype_id\":null,\"is_featured\":0,\"time_zone\":\"UTC\",\"last_notification_seen\":null,\"email_verified_at\":null,\"deleted_at\":null,\"created_at\":\"2021-05-29T05:43:24.000000Z\",\"updated_at\":null,\"login_type\":null,\"service_address_id\":null,\"uid\":null,\"handymantype_id\":null,\"is_subscribe\":0}}]}', NULL, '2022-06-09 05:13:10', '2022-06-09 05:13:10'),
(37, 16, '2022-06-09 06:11:26', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"18.Quiff Short\",\"customer_id\":55,\"customer_name\":\"sirajuddin shaik\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-09 06:11:26', '2022-06-09 06:11:26'),
(38, 17, '2022-06-09 06:13:24', 'add_booking', 'New Booking added by customer', '{\"service_id\":32,\"service_name\":\"TEST SERVICE 2\",\"customer_id\":55,\"customer_name\":\"sirajuddin shaik\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-09 06:13:24', '2022-06-09 06:13:24'),
(39, 17, '2022-06-09 06:14:21', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-09 06:14:21', '2022-06-09 06:14:21'),
(40, 17, '2022-06-09 06:21:28', 'assigned_booking', 'Booking has been assigned to Handyman Demo ', '{\"handyman_id\":[5],\"handyman_name\":[{\"id\":4,\"booking_id\":17,\"handyman_id\":5,\"deleted_at\":null,\"created_at\":null,\"updated_at\":null,\"handyman\":{\"id\":5,\"username\":\"handyman\",\"first_name\":\"Handyman\",\"last_name\":\"Demo\",\"email\":\"demo@handyman.com\",\"user_type\":\"handyman\",\"contact_number\":\"4564552664\",\"country_id\":181,\"state_id\":3924,\"city_id\":42865,\"provider_id\":4,\"address\":null,\"player_id\":null,\"status\":1,\"display_name\":\"Handyman Demo\",\"providertype_id\":null,\"is_featured\":0,\"time_zone\":\"UTC\",\"last_notification_seen\":null,\"email_verified_at\":null,\"deleted_at\":null,\"created_at\":\"2021-05-29T05:43:24.000000Z\",\"updated_at\":null,\"login_type\":null,\"service_address_id\":null,\"uid\":null,\"handymantype_id\":null,\"is_subscribe\":0}}]}', NULL, '2022-06-09 06:21:29', '2022-06-09 06:21:29'),
(41, 16, '2022-06-09 20:57:34', 'update_booking_status', 'Booking status has been changed from Pending to In Progress.', '{\"reason\":null,\"status\":\"in_progress\",\"status_label\":\"In Progress\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-09 20:57:34', '2022-06-09 20:57:34'),
(42, 16, '2022-06-09 20:57:51', 'update_booking_status', 'Booking status has been changed from In Progress to Pending.', '{\"reason\":null,\"status\":\"pending\",\"status_label\":\"Pending\",\"old_status\":\"in_progress\",\"old_status_label\":\"In Progress\"}', NULL, '2022-06-09 20:57:51', '2022-06-09 20:57:51'),
(43, 16, '2022-06-12 07:50:28', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-12 07:50:28', '2022-06-12 07:50:28'),
(44, 18, '2022-06-12 19:22:13', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"Quiff Short\",\"customer_id\":55,\"customer_name\":\"sirajuddin shaik\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-12 19:22:13', '2022-06-12 19:22:13'),
(45, 19, '2022-06-13 21:36:42', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"Quiff Short\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-13 21:36:42', '2022-06-13 21:36:42'),
(46, 20, '2022-06-13 21:39:39', 'add_booking', 'New Booking added by customer', '{\"service_id\":27,\"service_name\":\"16.Pompadour\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-13 21:39:39', '2022-06-13 21:39:39'),
(47, 21, '2022-06-13 21:48:07', 'add_booking', 'New Booking added by customer', '{\"service_id\":26,\"service_name\":\"5.Comb Over Medium\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-13 21:48:07', '2022-06-13 21:48:07'),
(48, 21, '2022-06-13 23:41:30', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-13 23:41:30', '2022-06-13 23:41:30'),
(49, 22, '2022-06-14 05:55:24', 'add_booking', 'New Booking added by customer', '{\"service_id\":33,\"service_name\":\"TEST SERVICE 4\",\"customer_id\":66,\"customer_name\":\"Asif Ali\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-14 05:55:24', '2022-06-14 05:55:24'),
(50, 22, '2022-06-14 05:58:44', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-14 05:58:44', '2022-06-14 05:58:44'),
(51, 22, '2022-06-14 06:00:39', 'assigned_booking', 'Booking has been assigned to Handyman Demo ', '{\"handyman_id\":[5],\"handyman_name\":[{\"id\":5,\"booking_id\":22,\"handyman_id\":5,\"deleted_at\":null,\"created_at\":null,\"updated_at\":null,\"handyman\":{\"id\":5,\"username\":\"handyman\",\"first_name\":\"Handyman\",\"last_name\":\"Demo\",\"email\":\"demo@handyman.com\",\"user_type\":\"handyman\",\"contact_number\":\"4564552664\",\"country_id\":181,\"state_id\":3924,\"city_id\":42865,\"provider_id\":4,\"address\":null,\"player_id\":null,\"status\":1,\"display_name\":\"Handyman Demo\",\"providertype_id\":null,\"is_featured\":0,\"time_zone\":\"UTC\",\"last_notification_seen\":null,\"email_verified_at\":null,\"deleted_at\":null,\"created_at\":\"2021-05-29T05:43:24.000000Z\",\"updated_at\":null,\"login_type\":null,\"service_address_id\":null,\"uid\":null,\"handymantype_id\":null,\"is_subscribe\":0}}]}', NULL, '2022-06-14 06:00:39', '2022-06-14 06:00:39'),
(52, 23, '2022-06-14 22:47:16', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"Quiff Short\",\"customer_id\":55,\"customer_name\":\"sirajuddin shaik\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-14 22:47:16', '2022-06-14 22:47:16'),
(53, 23, '2022-06-14 22:47:34', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-14 22:47:34', '2022-06-14 22:47:34'),
(54, 23, '2022-06-14 22:48:12', 'assigned_booking', 'Booking has been assigned to Handyman Demo ', '{\"handyman_id\":[5],\"handyman_name\":[{\"id\":6,\"booking_id\":23,\"handyman_id\":5,\"deleted_at\":null,\"created_at\":null,\"updated_at\":null,\"handyman\":{\"id\":5,\"username\":\"handyman\",\"first_name\":\"Handyman\",\"last_name\":\"Demo\",\"email\":\"demo@handyman.com\",\"user_type\":\"handyman\",\"contact_number\":\"4564552664\",\"country_id\":181,\"state_id\":3924,\"city_id\":42865,\"provider_id\":4,\"address\":null,\"player_id\":null,\"status\":1,\"display_name\":\"Handyman Demo\",\"providertype_id\":null,\"is_featured\":0,\"time_zone\":\"UTC\",\"last_notification_seen\":null,\"email_verified_at\":null,\"deleted_at\":null,\"created_at\":\"2021-05-29T05:43:24.000000Z\",\"updated_at\":null,\"login_type\":null,\"service_address_id\":null,\"uid\":null,\"handymantype_id\":null,\"is_subscribe\":0}}]}', NULL, '2022-06-14 22:48:12', '2022-06-14 22:48:12'),
(55, 20, '2022-06-14 23:11:37', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-14 23:11:37', '2022-06-14 23:11:37'),
(56, 24, '2022-06-15 09:23:04', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"Quiff Short\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-15 09:23:04', '2022-06-15 09:23:04'),
(57, 19, '2022-06-15 09:23:59', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-15 09:23:59', '2022-06-15 09:23:59'),
(58, 25, '2022-06-17 04:19:56', 'add_booking', 'New Booking added by customer', '{\"service_id\":29,\"service_name\":\"Quiff Short\",\"customer_id\":55,\"customer_name\":\"sirajuddin shaik\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-17 04:19:56', '2022-06-17 04:19:56'),
(59, 26, '2022-06-17 04:22:25', 'add_booking', 'New Booking added by customer', '{\"service_id\":33,\"service_name\":\"TEST SERVICE 4\",\"customer_id\":55,\"customer_name\":\"sirajuddin shaik\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-17 04:22:25', '2022-06-17 04:22:25'),
(60, 26, '2022-06-22 04:15:55', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-06-22 04:15:55', '2022-06-22 04:15:55'),
(61, 27, '2022-06-28 15:10:48', 'add_booking', 'New Booking added by customer', '{\"service_id\":32,\"service_name\":\"WOMEN GROOMING SALON\",\"customer_id\":72,\"customer_name\":\"Jean David\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-06-28 15:10:48', '2022-06-28 15:10:48'),
(62, 28, '2022-07-05 12:27:35', 'add_booking', 'New Booking added by customer', '{\"service_id\":34,\"service_name\":\"Bath clean\",\"customer_id\":83,\"customer_name\":\"khushi choudhary\",\"provider_id\":70,\"provider_name\":\"Micheal Jordon\"}', NULL, '2022-07-05 12:27:35', '2022-07-05 12:27:35'),
(63, 29, '2022-07-05 13:15:37', 'add_booking', 'New Booking added by customer', '{\"service_id\":36,\"service_name\":\"Most Popular Styles For 2022\",\"customer_id\":83,\"customer_name\":\"khushi choudhary\",\"provider_id\":58,\"provider_name\":\"jean tremblay\"}', NULL, '2022-07-05 13:15:37', '2022-07-05 13:15:37'),
(64, 17, '2022-07-05 13:30:31', 'update_booking_status', 'Booking status has been changed from Accept to On Going.', '{\"reason\":null,\"status\":\"on_going\",\"status_label\":\"On Going\",\"old_status\":\"accept\",\"old_status_label\":\"Accept\"}', NULL, '2022-07-05 13:30:31', '2022-07-05 13:30:31'),
(65, 29, '2022-07-05 13:31:31', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-07-05 13:31:31', '2022-07-05 13:31:31'),
(66, 21, '2022-08-01 11:15:30', 'update_booking_status', 'Booking status has been changed from Accept to On Going.', '{\"reason\":null,\"status\":\"on_going\",\"status_label\":\"On Going\",\"old_status\":\"accept\",\"old_status_label\":\"Accept\"}', NULL, '2022-08-01 11:15:30', '2022-08-01 11:15:30'),
(67, 21, '2022-08-01 11:15:30', 'payment_message_status', 'Your payment is pending', '{\"activity_type\":\"payment_message_status\",\"payment_status\":\"pending\",\"booking_id\":21}', NULL, '2022-08-01 11:15:30', '2022-08-01 11:15:30'),
(68, 30, '2022-08-05 02:41:51', 'add_booking', 'New Booking added by customer', '{\"service_id\":38,\"service_name\":\"Coupe Classic\\/Classic Haircut\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-08-05 02:41:51', '2022-08-05 02:41:51'),
(69, 31, '2022-08-05 02:58:11', 'add_booking', 'New Booking added by customer', '{\"service_id\":38,\"service_name\":\"Coupe Classic\\/Classic Haircut\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-08-05 02:58:11', '2022-08-05 02:58:11'),
(70, 32, '2022-08-05 03:09:26', 'add_booking', 'New Booking added by customer', '{\"service_id\":31,\"service_name\":\"Garden Tools repairing\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":70,\"provider_name\":\"Micheal Jordon\"}', NULL, '2022-08-05 03:09:26', '2022-08-05 03:09:26'),
(71, 33, '2022-08-05 15:19:36', 'add_booking', 'New Booking added by customer', '{\"service_id\":38,\"service_name\":\"Coupe Classic\\/Classic Haircut\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-08-05 15:19:36', '2022-08-05 15:19:36'),
(72, 34, '2022-08-05 15:22:09', 'add_booking', 'New Booking added by customer', '{\"service_id\":35,\"service_name\":\"Wall paint\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":54,\"provider_name\":\"JeVeux Professional 02\"}', NULL, '2022-08-05 15:22:09', '2022-08-05 15:22:09'),
(73, 35, '2022-08-05 23:37:00', 'add_booking', 'New Booking added by customer', '{\"service_id\":38,\"service_name\":\"Coupe Classic\\/Classic Haircut\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', NULL, '2022-08-05 23:37:00', '2022-08-05 23:37:00'),
(74, 36, '2022-08-05 23:38:00', 'add_booking', 'New Booking added by customer', '{\"service_id\":31,\"service_name\":\"Garden Tools repairing\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":70,\"provider_name\":\"Micheal Jordon\"}', NULL, '2022-08-05 23:38:00', '2022-08-05 23:38:00'),
(75, 36, '2022-08-05 23:40:00', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-08-05 23:40:00', '2022-08-05 23:40:00'),
(76, 36, '2022-08-05 23:40:05', 'update_booking_status', 'Booking status has been changed from Accept to On Going.', '{\"reason\":null,\"status\":\"on_going\",\"status_label\":\"On Going\",\"old_status\":\"accept\",\"old_status_label\":\"Accept\"}', NULL, '2022-08-05 23:40:05', '2022-08-05 23:40:05'),
(77, 36, '2022-08-05 23:40:26', 'update_booking_status', 'Booking status has been changed from On Going to In Progress.', '{\"reason\":null,\"status\":\"in_progress\",\"status_label\":\"In Progress\",\"old_status\":\"on_going\",\"old_status_label\":\"On Going\"}', NULL, '2022-08-05 23:40:26', '2022-08-05 23:40:26'),
(78, 36, '2022-08-05 23:40:35', 'update_booking_status', 'Booking status has been changed from In Progress to Completed.', '{\"reason\":\"Done\",\"status\":\"completed\",\"status_label\":\"Completed\",\"old_status\":\"in_progress\",\"old_status_label\":\"In Progress\"}', NULL, '2022-08-05 23:40:35', '2022-08-05 23:40:35'),
(79, 35, '2022-08-05 23:42:15', 'update_booking_status', 'Booking status has been changed from Pending to Accept.', '{\"reason\":null,\"status\":\"accept\",\"status_label\":\"Accept\",\"old_status\":\"pending\",\"old_status_label\":\"Pending\"}', NULL, '2022-08-05 23:42:15', '2022-08-05 23:42:15'),
(80, 44, '2022-08-28 06:20:26', 'add_booking', 'New Booking added by customer', '{\"service_id\":48,\"service_name\":\"ladies hair\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":1,\"provider_name\":\"Admin Admin\"}', NULL, '2022-08-28 06:20:26', '2022-08-28 06:20:26'),
(81, 46, '2022-08-29 12:45:34', 'add_booking', 'New Booking added by customer', '{\"service_id\":48,\"service_name\":\"ladies hair\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":1,\"provider_name\":\"Admin Admin\"}', NULL, '2022-08-29 12:45:34', '2022-08-29 12:45:34'),
(82, 47, '2022-09-04 06:31:00', 'add_booking', 'New Booking added by customer', '{\"service_id\":62,\"service_name\":\"Swedish Massage\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":1,\"provider_name\":\"Admin Admin\"}', NULL, '2022-09-04 06:31:00', '2022-09-04 06:31:00'),
(83, 48, '2022-09-07 17:12:40', 'add_booking', 'New Booking added by customer', '{\"service_id\":70,\"service_name\":\"Toilet Clean\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":1,\"provider_name\":\"Admin Admin\"}', '2022-09-25 13:45:54', '2022-09-07 17:12:40', '2022-09-25 13:45:54'),
(84, 49, '2022-09-07 17:56:46', 'add_booking', 'New Booking added by customer', '{\"service_id\":67,\"service_name\":\"Refrigerator Cleaning\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', '2022-09-25 13:45:58', '2022-09-07 17:56:46', '2022-09-25 13:45:58'),
(85, 50, '2022-09-07 17:57:59', 'add_booking', 'New Booking added by customer', '{\"service_id\":67,\"service_name\":\"Refrigerator Cleaning\",\"customer_id\":63,\"customer_name\":\"sethu jangid\",\"provider_id\":4,\"provider_name\":\"Jeveux Professional 01\"}', '2022-09-25 13:45:43', '2022-09-07 17:57:59', '2022-09-25 13:45:43');

-- --------------------------------------------------------

--
-- Table structure for table `booking_address_mappings`
--

CREATE TABLE `booking_address_mappings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED DEFAULT NULL,
  `address` text DEFAULT NULL,
  `latitude` text DEFAULT NULL,
  `longitude` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_coupon_mappings`
--

CREATE TABLE `booking_coupon_mappings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) DEFAULT NULL,
  `code` varchar(191) DEFAULT NULL,
  `discount` double DEFAULT NULL,
  `discount_type` varchar(191) DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_handyman_mappings`
--

CREATE TABLE `booking_handyman_mappings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `handyman_id` bigint(20) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_ratings`
--

CREATE TABLE `booking_ratings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `service_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `rating` double DEFAULT NULL,
  `review` longtext DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `booking_statuses`
--

CREATE TABLE `booking_statuses` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `value` varchar(191) DEFAULT NULL,
  `label` varchar(191) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1 COMMENT '0-inactive , 1 - active',
  `sequence` int(11) DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `booking_statuses`
--

INSERT INTO `booking_statuses` (`id`, `value`, `label`, `status`, `sequence`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'pending', 'Pending', 1, 1, NULL, '2021-05-30 20:47:08', '2021-05-30 20:47:21'),
(2, 'accept', 'Accept', 1, 2, NULL, '2021-05-30 20:50:40', '2021-05-30 20:50:44'),
(3, 'on_going', 'On Going', 1, 3, NULL, '2021-05-30 20:50:46', '2021-05-30 20:50:48'),
(4, 'in_progress', 'In Progress', 1, 4, NULL, '2021-05-30 20:50:50', '2021-05-30 20:50:52'),
(5, 'hold', 'Hold', 1, 5, NULL, '2021-05-30 20:50:54', '2021-05-30 20:50:56'),
(6, 'cancelled', 'Cancelled', 1, 6, NULL, '2021-05-30 20:55:03', '2021-05-30 20:55:05'),
(7, 'rejected', 'Rejected', 1, 7, NULL, '2021-05-30 20:55:09', '2021-05-30 20:55:10'),
(8, 'failed', 'Failed', 1, 8, NULL, '2021-05-30 20:55:11', '2021-05-30 20:55:12'),
(9, 'completed', 'Completed', 1, 9, NULL, '2021-05-30 20:55:11', '2021-05-30 20:55:12');

-- --------------------------------------------------------

--
-- Table structure for table `cities`
--

CREATE TABLE `cities` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

CREATE TABLE `countries` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(3) NOT NULL,
  `name` varchar(150) NOT NULL,
  `dial_code` int(11) NOT NULL,
  `currency_name` varchar(20) NOT NULL,
  `symbol` varchar(20) NOT NULL,
  `currency_code` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `code`, `name`, `dial_code`, `currency_name`, `symbol`, `currency_code`) VALUES
(1, 'AF', 'Afghanistan', 93, 'Afghan afghani', '؋', 'AFN'),
(2, 'AL', 'Albania', 355, 'Albanian lek', 'L', 'ALL'),
(3, 'DZ', 'Algeria', 213, 'Algerian dinar', 'د.ج', 'DZD'),
(4, 'AS', 'American Samoa', 1684, '', '', ''),
(5, 'AD', 'Andorra', 376, 'Euro', '€', 'EUR'),
(6, 'AO', 'Angola', 244, 'Angolan kwanza', 'Kz', 'AOA'),
(7, 'AI', 'Anguilla', 1264, 'East Caribbean dolla', '$', 'XCD'),
(8, 'AQ', 'Antarctica', 0, '', '', ''),
(9, 'AG', 'Antigua And Barbuda', 1268, 'East Caribbean dolla', '$', 'XCD'),
(10, 'AR', 'Argentina', 54, 'Argentine peso', '$', 'ARS'),
(11, 'AM', 'Armenia', 374, 'Armenian dram', '', 'AMD'),
(12, 'AW', 'Aruba', 297, 'Aruban florin', 'ƒ', 'AWG'),
(13, 'AU', 'Australia', 61, 'Australian dollar', '$', 'AUD'),
(14, 'AT', 'Austria', 43, 'Euro', '€', 'EUR'),
(15, 'AZ', 'Azerbaijan', 994, 'Azerbaijani manat', '', 'AZN'),
(16, 'BS', 'Bahamas The', 1242, '', '', ''),
(17, 'BH', 'Bahrain', 973, 'Bahraini dinar', '.د.ب', 'BHD'),
(18, 'BD', 'Bangladesh', 880, 'Bangladeshi taka', '৳', 'BDT'),
(19, 'BB', 'Barbados', 1246, 'Barbadian dollar', '$', 'BBD'),
(20, 'BY', 'Belarus', 375, 'Belarusian ruble', 'Br', 'BYR'),
(21, 'BE', 'Belgium', 32, 'Euro', '€', 'EUR'),
(22, 'BZ', 'Belize', 501, 'Belize dollar', '$', 'BZD'),
(23, 'BJ', 'Benin', 229, 'West African CFA fra', 'Fr', 'XOF'),
(24, 'BM', 'Bermuda', 1441, 'Bermudian dollar', '$', 'BMD'),
(25, 'BT', 'Bhutan', 975, 'Bhutanese ngultrum', 'Nu.', 'BTN'),
(26, 'BO', 'Bolivia', 591, 'Bolivian boliviano', 'Bs.', 'BOB'),
(27, 'BA', 'Bosnia and Herzegovina', 387, 'Bosnia and Herzegovi', 'KM or КМ', 'BAM'),
(28, 'BW', 'Botswana', 267, 'Botswana pula', 'P', 'BWP'),
(29, 'BV', 'Bouvet Island', 0, '', '', ''),
(30, 'BR', 'Brazil', 55, 'Brazilian real', 'R$', 'BRL'),
(31, 'IO', 'British Indian Ocean Territory', 246, 'United States dollar', '$', 'USD'),
(32, 'BN', 'Brunei', 673, 'Brunei dollar', '$', 'BND'),
(33, 'BG', 'Bulgaria', 359, 'Bulgarian lev', 'лв', 'BGN'),
(34, 'BF', 'Burkina Faso', 226, 'West African CFA fra', 'Fr', 'XOF'),
(35, 'BI', 'Burundi', 257, 'Burundian franc', 'Fr', 'BIF'),
(36, 'KH', 'Cambodia', 855, 'Cambodian riel', '៛', 'KHR'),
(37, 'CM', 'Cameroon', 237, 'Central African CFA ', 'Fr', 'XAF'),
(38, 'CA', 'Canada', 1, 'Canadian dollar', '$', 'CAD'),
(39, 'CV', 'Cape Verde', 238, 'Cape Verdean escudo', 'Esc or $', 'CVE'),
(40, 'KY', 'Cayman Islands', 1345, 'Cayman Islands dolla', '$', 'KYD'),
(41, 'CF', 'Central African Republic', 236, 'Central African CFA ', 'Fr', 'XAF'),
(42, 'TD', 'Chad', 235, 'Central African CFA ', 'Fr', 'XAF'),
(43, 'CL', 'Chile', 56, 'Chilean peso', '$', 'CLP'),
(44, 'CN', 'China', 86, 'Chinese yuan', '¥ or 元', 'CNY'),
(45, 'CX', 'Christmas Island', 61, '', '$', ''),
(46, 'CC', 'Cocos (Keeling) Islands', 672, 'Australian dollar', '$', 'AUD'),
(47, 'CO', 'Colombia', 57, 'Colombian peso', '$', 'COP'),
(48, 'KM', 'Comoros', 269, 'Comorian franc', 'Fr', 'KMF'),
(49, 'CG', 'Congo', 242, '', '$', ''),
(50, 'CD', 'Congo The Democratic Republic Of The', 242, '', '$', ''),
(51, 'CK', 'Cook Islands', 682, 'New Zealand dollar', '$', 'NZD'),
(52, 'CR', 'Costa Rica', 506, 'Costa Rican colón', '₡', 'CRC'),
(53, 'CI', 'Cote D\'Ivoire (Ivory Coast)', 225, '', '', ''),
(54, 'HR', 'Croatia (Hrvatska)', 385, '', '', ''),
(55, 'CU', 'Cuba', 53, 'Cuban convertible pe', '$', 'CUC'),
(56, 'CY', 'Cyprus', 357, 'Euro', '€', 'EUR'),
(57, 'CZ', 'Czech Republic', 420, 'Czech koruna', 'Kč', 'CZK'),
(58, 'DK', 'Denmark', 45, 'Danish krone', 'kr', 'DKK'),
(59, 'DJ', 'Djibouti', 253, 'Djiboutian franc', 'Fr', 'DJF'),
(60, 'DM', 'Dominica', 1767, 'East Caribbean dolla', '$', 'XCD'),
(61, 'DO', 'Dominican Republic', 1809, 'Dominican peso', '$', 'DOP'),
(62, 'TP', 'East Timor', 670, 'United States dollar', '$', 'USD'),
(63, 'EC', 'Ecuador', 593, 'United States dollar', '$', 'USD'),
(64, 'EG', 'Egypt', 20, 'Egyptian pound', '£ or ج.م', 'EGP'),
(65, 'SV', 'El Salvador', 503, 'United States dollar', '$', 'USD'),
(66, 'GQ', 'Equatorial Guinea', 240, 'Central African CFA ', 'Fr', 'XAF'),
(67, 'ER', 'Eritrea', 291, 'Eritrean nakfa', 'Nfk', 'ERN'),
(68, 'EE', 'Estonia', 372, 'Euro', '€', 'EUR'),
(69, 'ET', 'Ethiopia', 251, 'Ethiopian birr', 'Br', 'ETB'),
(70, 'XA', 'External Territories of Australia', 61, '', '', ''),
(71, 'FK', 'Falkland Islands', 500, 'Falkland Islands pou', '£', 'FKP'),
(72, 'FO', 'Faroe Islands', 298, 'Danish krone', 'kr', 'DKK'),
(73, 'FJ', 'Fiji Islands', 679, '', '', ''),
(74, 'FI', 'Finland', 358, 'Euro', '€', 'EUR'),
(75, 'FR', 'France', 33, 'Euro', '€', 'EUR'),
(76, 'GF', 'French Guiana', 594, '', '', ''),
(77, 'PF', 'French Polynesia', 689, 'CFP franc', 'Fr', 'XPF'),
(78, 'TF', 'French Southern Territories', 0, '', '', ''),
(79, 'GA', 'Gabon', 241, 'Central African CFA ', 'Fr', 'XAF'),
(80, 'GM', 'Gambia The', 220, '', '', ''),
(81, 'GE', 'Georgia', 995, 'Georgian lari', 'ლ', 'GEL'),
(82, 'DE', 'Germany', 49, 'Euro', '€', 'EUR'),
(83, 'GH', 'Ghana', 233, 'Ghana cedi', '₵', 'GHS'),
(84, 'GI', 'Gibraltar', 350, 'Gibraltar pound', '£', 'GIP'),
(85, 'GR', 'Greece', 30, 'Euro', '€', 'EUR'),
(86, 'GL', 'Greenland', 299, '', '', ''),
(87, 'GD', 'Grenada', 1473, 'East Caribbean dolla', '$', 'XCD'),
(88, 'GP', 'Guadeloupe', 590, '', '', ''),
(89, 'GU', 'Guam', 1671, '', '', ''),
(90, 'GT', 'Guatemala', 502, 'Guatemalan quetzal', 'Q', 'GTQ'),
(91, 'XU', 'Guernsey and Alderney', 44, '', '', ''),
(92, 'GN', 'Guinea', 224, 'Guinean franc', 'Fr', 'GNF'),
(93, 'GW', 'Guinea-Bissau', 245, 'West African CFA fra', 'Fr', 'XOF'),
(94, 'GY', 'Guyana', 592, 'Guyanese dollar', '$', 'GYD'),
(95, 'HT', 'Haiti', 509, 'Haitian gourde', 'G', 'HTG'),
(96, 'HM', 'Heard and McDonald Islands', 0, '', '', '$'),
(97, 'HN', 'Honduras', 504, 'Honduran lempira', 'L', 'HNL'),
(98, 'HK', 'Hong Kong S.A.R.', 852, '', '', '$'),
(99, 'HU', 'Hungary', 36, 'Hungarian forint', 'Ft', 'HUF'),
(100, 'IS', 'Iceland', 354, 'Icelandic króna', 'kr', 'ISK'),
(101, 'IN', 'India', 91, 'Indian rupee', '₹', 'INR'),
(102, 'ID', 'Indonesia', 62, 'Indonesian rupiah', 'Rp', 'IDR'),
(103, 'IR', 'Iran', 98, 'Iranian rial', '﷼', 'IRR'),
(104, 'IQ', 'Iraq', 964, 'Iraqi dinar', 'ع.د', 'IQD'),
(105, 'IE', 'Ireland', 353, 'Euro', '€', 'EUR'),
(106, 'IL', 'Israel', 972, 'Israeli new shekel', '₪', 'ILS'),
(107, 'IT', 'Italy', 39, 'Euro', '€', 'EUR'),
(108, 'JM', 'Jamaica', 1876, 'Jamaican dollar', '$', 'JMD'),
(109, 'JP', 'Japan', 81, 'Japanese yen', '¥', 'JPY'),
(110, 'XJ', 'Jersey', 44, 'British pound', '£', 'GBP'),
(111, 'JO', 'Jordan', 962, 'Jordanian dinar', 'د.ا', 'JOD'),
(112, 'KZ', 'Kazakhstan', 7, 'Kazakhstani tenge', '', 'KZT'),
(113, 'KE', 'Kenya', 254, 'Kenyan shilling', 'Sh', 'KES'),
(114, 'KI', 'Kiribati', 686, 'Australian dollar', '$', 'AUD'),
(115, 'KP', 'Korea North', 850, '', '', ''),
(116, 'KR', 'Korea South', 82, '', '', ''),
(117, 'KW', 'Kuwait', 965, 'Kuwaiti dinar', 'د.ك', 'KWD'),
(118, 'KG', 'Kyrgyzstan', 996, 'Kyrgyzstani som', 'лв', 'KGS'),
(119, 'LA', 'Laos', 856, 'Lao kip', '₭', 'LAK'),
(120, 'LV', 'Latvia', 371, 'Euro', '€', 'EUR'),
(121, 'LB', 'Lebanon', 961, 'Lebanese pound', 'ل.ل', 'LBP'),
(122, 'LS', 'Lesotho', 266, 'Lesotho loti', 'L', 'LSL'),
(123, 'LR', 'Liberia', 231, 'Liberian dollar', '$', 'LRD'),
(124, 'LY', 'Libya', 218, 'Libyan dinar', 'ل.د', 'LYD'),
(125, 'LI', 'Liechtenstein', 423, 'Swiss franc', 'Fr', 'CHF'),
(126, 'LT', 'Lithuania', 370, 'Euro', '€', 'EUR'),
(127, 'LU', 'Luxembourg', 352, 'Euro', '€', 'EUR'),
(128, 'MO', 'Macau S.A.R.', 853, '', '', ''),
(129, 'MK', 'Macedonia', 389, '', '', ''),
(130, 'MG', 'Madagascar', 261, 'Malagasy ariary', 'Ar', 'MGA'),
(131, 'MW', 'Malawi', 265, 'Malawian kwacha', 'MK', 'MWK'),
(132, 'MY', 'Malaysia', 60, 'Malaysian ringgit', 'RM', 'MYR'),
(133, 'MV', 'Maldives', 960, 'Maldivian rufiyaa', '.ރ', 'MVR'),
(134, 'ML', 'Mali', 223, 'West African CFA fra', 'Fr', 'XOF'),
(135, 'MT', 'Malta', 356, 'Euro', '€', 'EUR'),
(136, 'XM', 'Man (Isle of)', 44, '', '', ''),
(137, 'MH', 'Marshall Islands', 692, 'United States dollar', '$', 'USD'),
(138, 'MQ', 'Martinique', 596, '', '', ''),
(139, 'MR', 'Mauritania', 222, 'Mauritanian ouguiya', 'UM', 'MRO'),
(140, 'MU', 'Mauritius', 230, 'Mauritian rupee', '₨', 'MUR'),
(141, 'YT', 'Mayotte', 269, '', '', ''),
(142, 'MX', 'Mexico', 52, 'Mexican peso', '$', 'MXN'),
(143, 'FM', 'Micronesia', 691, 'Micronesian dollar', '$', ''),
(144, 'MD', 'Moldova', 373, 'Moldovan leu', 'L', 'MDL'),
(145, 'MC', 'Monaco', 377, 'Euro', '€', 'EUR'),
(146, 'MN', 'Mongolia', 976, 'Mongolian tögrög', '₮', 'MNT'),
(147, 'MS', 'Montserrat', 1664, 'East Caribbean dolla', '$', 'XCD'),
(148, 'MA', 'Morocco', 212, 'Moroccan dirham', 'د.م.', 'MAD'),
(149, 'MZ', 'Mozambique', 258, 'Mozambican metical', 'MT', 'MZN'),
(150, 'MM', 'Myanmar', 95, 'Burmese kyat', 'Ks', 'MMK'),
(151, 'NA', 'Namibia', 264, 'Namibian dollar', '$', 'NAD'),
(152, 'NR', 'Nauru', 674, 'Australian dollar', '$', 'AUD'),
(153, 'NP', 'Nepal', 977, 'Nepalese rupee', '₨', 'NPR'),
(154, 'AN', 'Netherlands Antilles', 599, '', '', ''),
(155, 'NL', 'Netherlands The', 31, '', '', ''),
(156, 'NC', 'New Caledonia', 687, 'CFP franc', 'Fr', 'XPF'),
(157, 'NZ', 'New Zealand', 64, 'New Zealand dollar', '$', 'NZD'),
(158, 'NI', 'Nicaragua', 505, 'Nicaraguan córdoba', 'C$', 'NIO'),
(159, 'NE', 'Niger', 227, 'West African CFA fra', 'Fr', 'XOF'),
(160, 'NG', 'Nigeria', 234, 'Nigerian naira', '₦', 'NGN'),
(161, 'NU', 'Niue', 683, 'New Zealand dollar', '$', 'NZD'),
(162, 'NF', 'Norfolk Island', 672, '', '', ''),
(163, 'MP', 'Northern Mariana Islands', 1670, '', '', ''),
(164, 'NO', 'Norway', 47, 'Norwegian krone', 'kr', 'NOK'),
(165, 'OM', 'Oman', 968, 'Omani rial', 'ر.ع.', 'OMR'),
(166, 'PK', 'Pakistan', 92, 'Pakistani rupee', '₨', 'PKR'),
(167, 'PW', 'Palau', 680, 'Palauan dollar', '$', ''),
(168, 'PS', 'Palestinian Territory Occupied', 970, '', '', ''),
(169, 'PA', 'Panama', 507, 'Panamanian balboa', 'B/.', 'PAB'),
(170, 'PG', 'Papua new Guinea', 675, 'Papua New Guinean ki', 'K', 'PGK'),
(171, 'PY', 'Paraguay', 595, 'Paraguayan guaraní', '₲', 'PYG'),
(172, 'PE', 'Peru', 51, 'Peruvian nuevo sol', 'S/.', 'PEN'),
(173, 'PH', 'Philippines', 63, 'Philippine peso', '₱', 'PHP'),
(174, 'PN', 'Pitcairn Island', 0, '', '', ''),
(175, 'PL', 'Poland', 48, 'Polish złoty', 'zł', 'PLN'),
(176, 'PT', 'Portugal', 351, 'Euro', '€', 'EUR'),
(177, 'PR', 'Puerto Rico', 1787, '', '', ''),
(178, 'QA', 'Qatar', 974, 'Qatari riyal', 'ر.ق', 'QAR'),
(179, 'RE', 'Reunion', 262, '', '', ''),
(180, 'RO', 'Romania', 40, 'Romanian leu', 'lei', 'RON'),
(181, 'RU', 'Russia', 70, 'Russian ruble', '', 'RUB'),
(182, 'RW', 'Rwanda', 250, 'Rwandan franc', 'Fr', 'RWF'),
(183, 'SH', 'Saint Helena', 290, 'Saint Helena pound', '£', 'SHP'),
(184, 'KN', 'Saint Kitts And Nevis', 1869, 'East Caribbean dolla', '$', 'XCD'),
(185, 'LC', 'Saint Lucia', 1758, 'East Caribbean dolla', '$', 'XCD'),
(186, 'PM', 'Saint Pierre and Miquelon', 508, '', '', ''),
(187, 'VC', 'Saint Vincent And The Grenadines', 1784, 'East Caribbean dolla', '$', 'XCD'),
(188, 'WS', 'Samoa', 684, 'Samoan tālā', 'T', 'WST'),
(189, 'SM', 'San Marino', 378, 'Euro', '€', 'EUR'),
(190, 'ST', 'Sao Tome and Principe', 239, 'São Tomé and Príncip', 'Db', 'STD'),
(191, 'SA', 'Saudi Arabia', 966, 'Saudi riyal', 'ر.س', 'SAR'),
(192, 'SN', 'Senegal', 221, 'West African CFA fra', 'Fr', 'XOF'),
(193, 'RS', 'Serbia', 381, 'Serbian dinar', 'дин. or din.', 'RSD'),
(194, 'SC', 'Seychelles', 248, 'Seychellois rupee', '₨', 'SCR'),
(195, 'SL', 'Sierra Leone', 232, 'Sierra Leonean leone', 'Le', 'SLL'),
(196, 'SG', 'Singapore', 65, 'Brunei dollar', '$', 'BND'),
(197, 'SK', 'Slovakia', 421, 'Euro', '€', 'EUR'),
(198, 'SI', 'Slovenia', 386, 'Euro', '€', 'EUR'),
(199, 'XG', 'Smaller Territories of the UK', 44, '', '', ''),
(200, 'SB', 'Solomon Islands', 677, 'Solomon Islands doll', '$', 'SBD'),
(201, 'SO', 'Somalia', 252, 'Somali shilling', 'Sh', 'SOS'),
(202, 'ZA', 'South Africa', 27, 'South African rand', 'R', 'ZAR'),
(203, 'GS', 'South Georgia', 0, '', '', ''),
(204, 'SS', 'South Sudan', 211, 'South Sudanese pound', '£', 'SSP'),
(205, 'ES', 'Spain', 34, 'Euro', '€', 'EUR'),
(206, 'LK', 'Sri Lanka', 94, 'Sri Lankan rupee', 'Rs or රු', 'LKR'),
(207, 'SD', 'Sudan', 249, 'Sudanese pound', 'ج.س.', 'SDG'),
(208, 'SR', 'Suriname', 597, 'Surinamese dollar', '$', 'SRD'),
(209, 'SJ', 'Svalbard And Jan Mayen Islands', 47, '', '', ''),
(210, 'SZ', 'Swaziland', 268, 'Swazi lilangeni', 'L', 'SZL'),
(211, 'SE', 'Sweden', 46, 'Swedish krona', 'kr', 'SEK'),
(212, 'CH', 'Switzerland', 41, 'Swiss franc', 'Fr', 'CHF'),
(213, 'SY', 'Syria', 963, 'Syrian pound', '£ or ل.س', 'SYP'),
(214, 'TW', 'Taiwan', 886, 'New Taiwan dollar', '$', 'TWD'),
(215, 'TJ', 'Tajikistan', 992, 'Tajikistani somoni', 'ЅМ', 'TJS'),
(216, 'TZ', 'Tanzania', 255, 'Tanzanian shilling', 'Sh', 'TZS'),
(217, 'TH', 'Thailand', 66, 'Thai baht', '฿', 'THB'),
(218, 'TG', 'Togo', 228, 'West African CFA fra', 'Fr', 'XOF'),
(219, 'TK', 'Tokelau', 690, '', '', ''),
(220, 'TO', 'Tonga', 676, 'Tongan paʻanga', 'T$', 'TOP'),
(221, 'TT', 'Trinidad And Tobago', 1868, 'Trinidad and Tobago ', '$', 'TTD'),
(222, 'TN', 'Tunisia', 216, 'Tunisian dinar', 'د.ت', 'TND'),
(223, 'TR', 'Turkey', 90, 'Turkish lira', '', 'TRY'),
(224, 'TM', 'Turkmenistan', 7370, 'Turkmenistan manat', 'm', 'TMT'),
(225, 'TC', 'Turks And Caicos Islands', 1649, 'United States dollar', '$', 'USD'),
(226, 'TV', 'Tuvalu', 688, 'Australian dollar', '$', 'AUD'),
(227, 'UG', 'Uganda', 256, 'Ugandan shilling', 'Sh', 'UGX'),
(228, 'UA', 'Ukraine', 380, 'Ukrainian hryvnia', '₴', 'UAH'),
(229, 'AE', 'United Arab Emirates', 971, 'United Arab Emirates', 'د.إ', 'AED'),
(230, 'GB', 'United Kingdom', 44, 'British pound', '£', 'GBP'),
(231, 'US', 'United States', 1, 'United States dollar', '$', 'USD'),
(232, 'UM', 'United States Minor Outlying Islands', 1, '', '', ''),
(233, 'UY', 'Uruguay', 598, 'Uruguayan peso', '$', 'UYU'),
(234, 'UZ', 'Uzbekistan', 998, 'Uzbekistani som', '', 'UZS'),
(235, 'VU', 'Vanuatu', 678, 'Vanuatu vatu', 'Vt', 'VUV'),
(236, 'VA', 'Vatican City State (Holy See)', 39, '', '', ''),
(237, 'VE', 'Venezuela', 58, 'Venezuelan bolívar', 'Bs F', 'VEF'),
(238, 'VN', 'Vietnam', 84, 'Vietnamese đồng', '₫', 'VND'),
(239, 'VG', 'Virgin Islands (British)', 1284, '', '', ''),
(240, 'VI', 'Virgin Islands (US)', 1340, '', '', ''),
(241, 'WF', 'Wallis And Futuna Islands', 681, '', '', ''),
(242, 'EH', 'Western Sahara', 212, '', '', ''),
(243, 'YE', 'Yemen', 967, 'Yemeni rial', '﷼', 'YER'),
(244, 'YU', 'Yugoslavia', 38, '', '', ''),
(245, 'ZM', 'Zambia', 260, 'Zambian kwacha', 'ZK', 'ZMW'),
(246, 'ZW', 'Zimbabwe', 263, 'Botswana pula', 'P', 'BWP');

-- --------------------------------------------------------

--
-- Table structure for table `coupons`
--

CREATE TABLE `coupons` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `code` varchar(191) DEFAULT NULL,
  `image` varchar(191) DEFAULT NULL,
  `discount_type` enum('fixed','percentage') DEFAULT NULL COMMENT 'percentage,fixed',
  `discount` decimal(10,2) DEFAULT NULL,
  `desp` text DEFAULT NULL,
  `expire_date` date DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coupons`
--

INSERT INTO `coupons` (`id`, `code`, `image`, `discount_type`, `discount`, `desp`, `expire_date`, `deleted_at`, `created_at`, `updated_at`) VALUES
(5, 'CP0001', '658b0f1d9899e_OjiiFzody.jpg', 'fixed', 10.00, 'demo desp', '2023-12-27', NULL, '2023-12-26 17:36:30', '2023-12-26 17:36:30'),
(6, 'NEW11', '659445465c46e_Q8JJKg6FQP.jpg', 'percentage', 10.00, 'sdsdf', '2024-01-03', NULL, '2024-01-02 17:17:59', '2024-01-02 17:17:59');

-- --------------------------------------------------------

--
-- Table structure for table `coupon_service_mappings`
--

CREATE TABLE `coupon_service_mappings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `coupon_id` bigint(20) UNSIGNED DEFAULT NULL,
  `service_id` bigint(20) UNSIGNED DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `coupon_service_mappings`
--

INSERT INTO `coupon_service_mappings` (`id`, `coupon_id`, `service_id`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 1, 97, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

CREATE TABLE `documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `is_required` tinyint(4) DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `documents`
--

INSERT INTO `documents` (`id`, `name`, `status`, `is_required`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Upload Photo', 1, 1, NULL, '2022-06-02 15:48:58', '2023-07-11 05:45:25'),
(2, 'Upload Portfolio', 1, 1, NULL, '2022-06-02 15:49:32', '2022-07-01 05:41:37'),
(3, 'Upload Driver\'s Licenses', 1, 1, NULL, '2022-06-02 15:49:55', '2022-06-02 15:49:55'),
(4, 'Upload Secondary ID (Valid Government Photo ID)', 1, 1, NULL, '2022-06-02 15:50:39', '2022-07-01 05:41:38'),
(5, 'Upload Experience OR Certifications', 1, 1, NULL, '2022-06-02 15:51:08', '2022-06-02 15:51:08'),
(7, 'Direct Deposit form / Specimen check', 1, 1, NULL, '2022-07-01 05:41:31', '2022-07-01 05:41:31'),
(8, 'Aadhar Card', 1, 0, NULL, NULL, NULL),
(9, 'Pan Card', 1, 0, NULL, NULL, NULL),
(10, 'Sin', 1, 0, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(191) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `getmap`
--

CREATE TABLE `getmap` (
  `id` int(11) NOT NULL,
  `provider_id` varchar(100) NOT NULL,
  `customer_id` varchar(100) NOT NULL,
  `lat` varchar(100) NOT NULL,
  `lang` varchar(100) NOT NULL,
  `updated_at` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `getmap`
--

INSERT INTO `getmap` (`id`, `provider_id`, `customer_id`, `lat`, `lang`, `updated_at`) VALUES
(1, '4', '3', '17.0590570579', '20.890759077', '2022-09-16 03:50:29');

-- --------------------------------------------------------

--
-- Table structure for table `handyman_payouts`
--

CREATE TABLE `handyman_payouts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `handyman_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_method` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `paid_date` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `handyman_ratings`
--

CREATE TABLE `handyman_ratings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `service_id` bigint(20) UNSIGNED NOT NULL,
  `handyman_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `rating` double DEFAULT NULL,
  `review` longtext DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `handyman_types`
--

CREATE TABLE `handyman_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `commission` double DEFAULT 0,
  `type` varchar(191) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `handyman_types`
--

INSERT INTO `handyman_types` (`id`, `name`, `commission`, `type`, `status`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, 'Company', 20, 'percent', 1, NULL, '2021-02-14 16:43:51', NULL),
(2, 'Freelance', 5, 'fixed', 1, NULL, '2021-02-14 16:58:53', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jv_bookings`
--

CREATE TABLE `jv_bookings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uniq_order_id` varchar(100) NOT NULL,
  `customer_cart_id` varchar(500) DEFAULT NULL,
  `customer_lat` varchar(10) DEFAULT NULL,
  `customer_lng` varchar(10) DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `provider_id` bigint(20) UNSIGNED DEFAULT NULL,
  `otp` varchar(6) DEFAULT NULL,
  `otp_validated` enum('yes','no') DEFAULT 'no',
  `subtotal` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) DEFAULT 0.00,
  `tax_gst` decimal(10,2) NOT NULL,
  `tax_qst` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `order_status` enum('pending','accepted','proccessing','cancelled','completed') DEFAULT 'pending',
  `payment_status` enum('paid','unpaid') NOT NULL DEFAULT 'unpaid',
  `stripe_payment_ref` text DEFAULT NULL,
  `billing_address` longtext NOT NULL,
  `shipping_address` longtext NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_bookings`
--

INSERT INTO `jv_bookings` (`id`, `uniq_order_id`, `customer_cart_id`, `customer_lat`, `customer_lng`, `customer_id`, `provider_id`, `otp`, `otp_validated`, `subtotal`, `discount`, `tax_gst`, `tax_qst`, `total`, `order_status`, `payment_status`, `stripe_payment_ref`, `billing_address`, `shipping_address`, `created_at`, `updated_at`) VALUES
(33, 'JV-SER-657F40630A243', 'a40451151599c67738a19a72239d70e0468fd1c8', '22.5726', '88.3639', 412, 408, NULL, 'no', 10.00, 0.00, 0.61, 1.21, 11.82, 'pending', 'unpaid', NULL, '{\"id\":68,\"user_id\":412,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-17 18:39:17\",\"updated_at\":\"2023-12-17 18:39:17\"}', '{\"id\":68,\"user_id\":412,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-17 18:39:17\",\"updated_at\":\"2023-12-17 18:39:17\"}', '2023-12-17 18:39:31', '2023-12-31 09:41:36'),
(34, 'JV-SER-65808E1160569', '04635147ecd21aa22834b103d8fd23fb2ca526ed', '22.5726', '88.3639', 412, 408, NULL, 'no', 10.00, 0.00, 0.61, 1.21, 11.82, 'accepted', 'unpaid', NULL, '{\"id\":68,\"user_id\":412,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-17 18:39:17\",\"updated_at\":\"2023-12-17 18:39:17\"}', '{\"id\":68,\"user_id\":412,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-17 18:39:17\",\"updated_at\":\"2023-12-17 18:39:17\"}', '2023-12-18 18:23:13', '2023-12-30 20:01:26'),
(35, 'JV-SER-658163A284C9C', '9aee2e8f441f8c18bd862a41869465924ddb3d24', '37.7858', '-122.4064', 411, 408, NULL, 'no', 450.00, 0.00, 27.23, 54.31, 531.54, 'completed', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 09:34:26', '2023-12-31 09:40:21'),
(36, 'JV-SER-6581644EBE5E3', '9aee2e8f441f8c18bd862a41869465924ddb3d24', '37.7858', '-122.4064', 411, 408, NULL, 'no', 450.00, 0.00, 27.23, 54.31, 531.54, 'accepted', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 09:37:18', '2023-12-30 20:03:41'),
(37, 'JV-SER-658166D5E1E6F', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, 408, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'accepted', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 09:48:05', '2023-12-30 20:06:24'),
(38, 'JV-SER-65816767A3711', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, 408, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'cancelled', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 09:50:31', '2023-12-31 09:39:40'),
(39, 'JV-SER-658167C1B7E7A', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, 408, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'cancelled', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 09:52:01', '2023-12-31 09:39:33'),
(40, 'JV-SER-658175E2EA4A1', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, 408, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'completed', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 10:52:18', '2023-12-31 09:39:47'),
(41, 'JV-SER-6581761597F53', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, 408, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'completed', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 10:53:09', '2023-12-31 09:39:53'),
(42, 'JV-SER-6581770CDFA49', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 10:57:16', NULL),
(43, 'JV-SER-658177C138AD4', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:00:17', NULL),
(44, 'JV-SER-65817918E59C4', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:06:00', NULL),
(45, 'JV-SER-6581795C63AA3', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:07:08', NULL),
(46, 'JV-SER-65817EB7455D5', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:29:59', NULL),
(47, 'JV-SER-65817FA42F5C6', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:33:56', NULL),
(48, 'JV-SER-65817FAB8D54C', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:34:03', NULL),
(49, 'JV-SER-65817FD63B546', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:34:46', NULL),
(50, 'JV-SER-65817FEC62089', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:35:08', NULL),
(51, 'JV-SER-658180565532E', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:36:54', NULL),
(52, 'JV-SER-658180F6E5E53', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:39:34', NULL),
(53, 'JV-SER-6581812B0A352', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:40:27', NULL),
(54, 'JV-SER-6581824396695', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:45:07', NULL),
(55, 'JV-SER-658183394AAFF', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:49:13', NULL),
(56, 'JV-SER-6581841C4236E', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 11:53:00', NULL),
(57, 'JV-SER-658188F666183', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 12:13:42', NULL),
(58, 'JV-SER-658189558A81D', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 12:15:17', NULL),
(59, 'JV-SER-65818A2862A9B', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 12:18:48', NULL),
(60, 'JV-SER-65818A3C407AD', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 12:19:08', NULL),
(61, 'JV-SER-6581BD53B39D4', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 15:57:07', NULL),
(62, 'JV-SER-6581BE03DF397', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 16:00:03', NULL),
(63, 'JV-SER-6581BF448DCA9', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 16:05:24', NULL),
(64, 'JV-SER-6581C00EF14CB', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 16:08:46', NULL),
(65, 'JV-SER-6581C3D85D567', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 16:24:56', NULL),
(66, 'JV-SER-6581CA3730E80', '3284b1990e90a4693b3de7f85cbc056fe2caf8f6', '12.9598', '77.7144', 413, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":69,\"user_id\":413,\"first_name\":\"Amol\",\"last_name\":\"Test\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"West Bengal\",\"zip_code\":\"394964\",\"country_code\":\"+1\",\"phone\":\"9668882346\",\"email\":\"amol@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-19 16:51:42\",\"updated_at\":\"2023-12-19 16:51:42\"}', '{\"id\":69,\"user_id\":413,\"first_name\":\"Amol\",\"last_name\":\"Test\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"West Bengal\",\"zip_code\":\"394964\",\"country_code\":\"+1\",\"phone\":\"9668882346\",\"email\":\"amol@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-19 16:51:42\",\"updated_at\":\"2023-12-19 16:51:42\"}', '2023-12-19 16:52:07', NULL),
(67, 'JV-SER-6581D35DDDAC8', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 17:31:09', NULL),
(68, 'JV-SER-6581D38FEC9C7', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 17:31:59', NULL),
(69, 'JV-SER-6581D466D1C12', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 17:35:34', NULL),
(70, 'JV-SER-6581D497C457E', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 17:36:23', NULL);
INSERT INTO `jv_bookings` (`id`, `uniq_order_id`, `customer_cart_id`, `customer_lat`, `customer_lng`, `customer_id`, `provider_id`, `otp`, `otp_validated`, `subtotal`, `discount`, `tax_gst`, `tax_qst`, `total`, `order_status`, `payment_status`, `stripe_payment_ref`, `billing_address`, `shipping_address`, `created_at`, `updated_at`) VALUES
(71, 'JV-SER-6581D552DD8A3', '14883fe360da7601313b10b201757f43b32933ab', '37.7858', '-122.4064', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-19 17:39:30', NULL),
(72, 'JV-SER-6583205487D5F', 'cd0f7b116a360c1fdb0f61aa0cb08feb8b286071', '22.5726', '88.3639', 412, NULL, NULL, 'no', 10.00, 0.00, 0.61, 1.21, 11.82, 'pending', 'unpaid', NULL, '{\"id\":68,\"user_id\":412,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-17 18:39:17\",\"updated_at\":\"2023-12-17 18:39:17\"}', '{\"id\":68,\"user_id\":412,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-17 18:39:17\",\"updated_at\":\"2023-12-17 18:39:17\"}', '2023-12-20 17:11:48', NULL),
(73, 'JV-SER-6586A6FBC00DC', 'fc0a9fdda1f2a85332770272a7874bb8957a588c', '22.5726', '88.3639', 412, NULL, NULL, 'no', 10.00, 0.00, 0.61, 1.21, 11.82, 'pending', 'unpaid', NULL, '{\"id\":68,\"user_id\":412,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-17 18:39:17\",\"updated_at\":\"2023-12-17 18:39:17\"}', '{\"id\":68,\"user_id\":412,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-17 18:39:17\",\"updated_at\":\"2023-12-17 18:39:17\"}', '2023-12-23 09:23:07', NULL),
(74, 'JV-SER-6586EB99185FF', 'c27abec22075aefd229dd76a1d96858e2ed5c7eb', '21.4536', '80.2122', 414, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":70,\"user_id\":414,\"first_name\":\"Pravin\",\"last_name\":\"Patel\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"test capital GJHGJahu\",\"city\":\"Gondia\",\"province\":\"Maharashtra\",\"zip_code\":\"441601\",\"country_code\":\"+91\",\"phone\":\"7498143684\",\"email\":\"pravinpatle1699@gmail.com\",\"additional_information\":null,\"locality\":\"Gondia\",\"landmark\":\"gyhhh\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-23 14:15:26\",\"updated_at\":\"2023-12-23 14:15:26\"}', '{\"id\":70,\"user_id\":414,\"first_name\":\"Pravin\",\"last_name\":\"Patel\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"test capital GJHGJahu\",\"city\":\"Gondia\",\"province\":\"Maharashtra\",\"zip_code\":\"441601\",\"country_code\":\"+91\",\"phone\":\"7498143684\",\"email\":\"pravinpatle1699@gmail.com\",\"additional_information\":null,\"locality\":\"Gondia\",\"landmark\":\"gyhhh\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-23 14:15:26\",\"updated_at\":\"2023-12-23 14:15:26\"}', '2023-12-23 14:15:53', NULL),
(75, 'JV-SER-65884983548CA', '365a4644adfb1d2bdb2fe1c728bafd3d0ebe0140', '12.9598', '77.7143', 407, NULL, NULL, 'no', 250.00, 0.00, 15.13, 30.17, 295.30, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 15:08:51', NULL),
(76, 'JV-SER-65884B06F1059', '886d707155fb2ecc595184c2ff9cb737e2b70140', '12.9598', '77.7143', 407, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 15:15:18', NULL),
(77, 'JV-SER-658B0CEEA9271', '130330399324e283e5b847ad467d4911d4925bf7', '37.7858', '-122.4064', 407, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-26 17:27:10', NULL),
(78, 'JV-SER-658B0DAF32282', '63a3b51a8e36c08bce06607d0bdf3c4dc59f18c4', '37.7858', '-122.4064', 407, NULL, NULL, 'no', 200.00, 0.00, 12.10, 24.14, 236.24, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-26 17:30:23', NULL),
(79, 'JV-SER-658C7CD8DF7AD', 'e452ffb0b2c67aed7a4c2b06ef67a8f10673a9b9', '12.9598', '77.7143', 407, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-27 19:36:56', NULL),
(80, 'JV-SER-658C7F5E35289', '16264533e07405ab751d78ceed35bfa094cb3e6d', '21.1767', '72.8025', 420, NULL, NULL, 'no', 650.00, 0.00, 39.33, 78.45, 767.78, 'pending', 'unpaid', NULL, '{\"id\":71,\"user_id\":420,\"first_name\":\"Nilesh\",\"last_name\":\"Surat\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Vnnh\",\"city\":\"Surat\",\"province\":\"Gujarat\",\"zip_code\":\"395007\",\"country_code\":\"+1\",\"phone\":\"7764973378\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"locality\":\"Surat\",\"landmark\":\"Nmn\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-27 19:46:27\",\"updated_at\":\"2023-12-27 19:46:27\"}', '{\"id\":71,\"user_id\":420,\"first_name\":\"Nilesh\",\"last_name\":\"Surat\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Vnnh\",\"city\":\"Surat\",\"province\":\"Gujarat\",\"zip_code\":\"395007\",\"country_code\":\"+1\",\"phone\":\"7764973378\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"locality\":\"Surat\",\"landmark\":\"Nmn\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-27 19:46:27\",\"updated_at\":\"2023-12-27 19:46:27\"}', '2023-12-27 19:47:42', NULL),
(81, 'JV-SER-658C891C3FA5C', '9fd37ead5d0e9ee4b0feef35cc4295f54e2e0189', '17.4852', '78.3086', 407, NULL, NULL, 'no', 50.00, 0.00, 3.03, 6.03, 59.06, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-27 20:29:16', NULL),
(82, 'JV-SER-658FA23C5D12E', '9164bf4b69f513a8b8cd46f9641155ecf16e3c13', '21.1767', '72.8025', 407, NULL, NULL, 'no', 150.00, 0.00, 9.08, 18.10, 177.18, 'pending', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2023-12-30 04:53:16', NULL),
(83, 'JV-SER-658FBED2ABC11', '1a801e347d3422a7691bd94d659600dd3b672a21', '22.3675', '88.2233', 407, NULL, NULL, 'no', 50.00, 0.00, 3.03, 6.03, 59.06, 'pending', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2023-12-30 06:55:14', NULL),
(84, 'JV-SER-658FC073AD5B6', 'b7262e1b56b22eb303ff4cb8b90e0b7cd12c3a29', '12.9598', '77.7143', 411, NULL, NULL, 'no', 200.00, 0.00, 12.10, 24.14, 236.24, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 07:02:11', NULL),
(85, 'JV-SER-658FE64CB8E8F', '922efeb1ce429cc6d68fc62324365e1ea36f4fa8', '37.4220', '-122.0840', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 09:43:40', NULL),
(86, 'JV-SER-658FE6F371732', '3100702063db0156afab24cf92800589cbcc782d', '37.4220', '-122.0840', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 09:46:27', NULL),
(87, 'JV-SER-658FE765DFB75', '3100702063db0156afab24cf92800589cbcc782d', '37.4220', '-122.0840', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 09:48:21', NULL),
(88, 'JV-SER-658FE82761A2E', '3100702063db0156afab24cf92800589cbcc782d', '37.4220', '-122.0840', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 09:51:35', NULL),
(89, 'JV-SER-658FE87BA1B50', '3100702063db0156afab24cf92800589cbcc782d', '37.4220', '-122.0840', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 09:52:59', NULL),
(90, 'JV-SER-658FEB04375F8', '40ac6fbb5fa90f0e23e5b3ccc6015fa9d90ec93e', '37.4220', '-122.0840', 411, NULL, NULL, 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 10:03:48', NULL),
(91, 'JV-SER-65905E53DDFA9', 'a7290000e19a90597640455afc251e39c25c61f7', '21.1767', '72.8025', 407, NULL, NULL, 'no', 500.00, 0.00, 30.25, 60.35, 590.60, 'pending', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2023-12-30 18:15:47', NULL),
(92, 'JV-SER-65905FA955CF7', '1853d41675f3b2bd864ab5749fc28fe147edb872', '21.1767', '72.8025', 407, NULL, '3304', 'no', 400.00, 0.00, 24.20, 48.28, 472.48, 'pending', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2023-12-30 18:21:29', NULL),
(93, 'JV-SER-659061D7E382E', '294fffa0b33beae87794f417a6903cb3f8bb14f4', '21.1767', '72.8025', 407, NULL, '5736', 'no', 200.00, 0.00, 12.10, 24.14, 236.24, 'pending', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2023-12-30 18:30:47', NULL),
(94, 'JV-SER-659062CCBB9D0', '89eec9c5c3551374aa465c57c9451cd736013549', '21.1767', '72.8025', 407, NULL, '4357', 'no', 200.00, 0.00, 12.10, 24.14, 236.24, 'pending', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2023-12-30 18:34:52', NULL),
(95, 'JV-SER-6590642CC23B4', 'bc4f04afa93b3e563ff601a7f0dd9015a1c3a41d', '21.1767', '72.8025', 407, NULL, '3439', 'no', 200.00, 0.00, 12.10, 24.14, 236.24, 'pending', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2023-12-30 18:40:44', NULL),
(96, 'JV-SER-6590655C5E032', '0967bfa15b548f8ca988f76e47606a42a44911b1', '21.1767', '72.8025', 407, 408, '5650', 'no', 200.00, 0.00, 12.10, 24.14, 236.24, 'accepted', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2023-12-30 18:45:48', '2023-12-30 19:16:02'),
(97, 'JV-SER-659072943DA97', '40ac6fbb5fa90f0e23e5b3ccc6015fa9d90ec93e', '37.4220', '-122.0840', 411, NULL, '9939', 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 19:42:12', NULL),
(98, 'JV-SER-6590746B46101', '5afb02bd6f987f9592f4f9b58ce80f20983ef545', '37.4220', '-122.0840', 411, NULL, '9213', 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 19:50:03', NULL),
(99, 'JV-SER-659076BA87EB2', 'c5c590b9543cabb6313697f6dc7a3280cf67ec3e', '37.4220', '-122.0840', 411, NULL, '3820', 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 19:59:54', NULL),
(100, 'JV-SER-659077B9BEA9A', 'df62a5e80f8aa0fe2453ca988970797990ffb872', '37.4220', '-122.0840', 411, NULL, '9275', 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 20:04:09', NULL),
(101, 'JV-SER-6592FAABF102A', '30957535cf6099f922d0c4c122581871759659d2', '21.1458', '79.0882', 422, NULL, '9832', 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'pending', 'unpaid', NULL, '{\"id\":73,\"user_id\":422,\"first_name\":\"Test\",\"last_name\":\"Testman\",\"apartment\":null,\"company_name\":\"Testing\",\"country_name\":\"India\",\"street_address\":\"test test test\",\"city\":\"Test Test Test\",\"province\":\"Western Province\",\"zip_code\":\"441614\",\"country_code\":\"+1\",\"phone\":\"7498143684\",\"email\":\"pravinpatle74@gmail.com\",\"additional_information\":\"test\",\"locality\":null,\"landmark\":null,\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2024-01-01 17:47:21\",\"updated_at\":\"2024-01-01 17:47:21\"}', '{\"id\":73,\"user_id\":422,\"first_name\":\"Test\",\"last_name\":\"Testman\",\"apartment\":null,\"company_name\":\"Testing\",\"country_name\":\"India\",\"street_address\":\"test test test\",\"city\":\"Test Test Test\",\"province\":\"Western Province\",\"zip_code\":\"441614\",\"country_code\":\"+1\",\"phone\":\"7498143684\",\"email\":\"pravinpatle74@gmail.com\",\"additional_information\":\"test\",\"locality\":null,\"landmark\":null,\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2024-01-01 17:47:21\",\"updated_at\":\"2024-01-01 17:47:21\"}', '2024-01-01 17:47:23', NULL),
(102, 'JV-SER-65943D56883BF', '30957535cf6099f922d0c4c122581871759659d2', '21.1458', '79.0882', 422, NULL, '6778', 'no', 600.00, 0.00, 36.30, 72.42, 708.72, 'pending', 'unpaid', NULL, '{\"id\":73,\"user_id\":422,\"first_name\":\"Test\",\"last_name\":\"Testman\",\"apartment\":null,\"company_name\":\"Testing\",\"country_name\":\"India\",\"street_address\":\"test test test\",\"city\":\"Test Test Test\",\"province\":\"Western Province\",\"zip_code\":\"441614\",\"country_code\":\"+1\",\"phone\":\"7498143684\",\"email\":\"pravinpatle74@gmail.com\",\"additional_information\":\"test\",\"locality\":null,\"landmark\":null,\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2024-01-01 17:47:21\",\"updated_at\":\"2024-01-01 17:47:21\"}', '{\"id\":73,\"user_id\":422,\"first_name\":\"Test\",\"last_name\":\"Testman\",\"apartment\":null,\"company_name\":\"Testing\",\"country_name\":\"India\",\"street_address\":\"test test test\",\"city\":\"Test Test Test\",\"province\":\"Western Province\",\"zip_code\":\"441614\",\"country_code\":\"+1\",\"phone\":\"7498143684\",\"email\":\"pravinpatle74@gmail.com\",\"additional_information\":\"test\",\"locality\":null,\"landmark\":null,\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2024-01-01 17:47:21\",\"updated_at\":\"2024-01-01 17:47:21\"}', '2024-01-02 16:44:06', NULL),
(103, 'JV-SER-659445E7407EC', 'a96c3e27cf54666886fe4703002dce7dfc9c8f84', '21.5379', '80.1619', 407, NULL, '8016', 'no', 800.00, 0.00, 48.40, 96.56, 944.96, 'pending', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2024-01-02 17:20:39', NULL),
(104, 'JV-SER-6594465041BC7', '88aab242fd2becf251bc2647578506913097f103', 'NaN', 'NaN', 407, 408, '7213', 'no', 100.00, 0.00, 6.05, 12.07, 118.12, 'accepted', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2024-01-02 17:22:24', '2024-01-02 17:23:05');

-- --------------------------------------------------------

--
-- Table structure for table `jv_booking_items`
--

CREATE TABLE `jv_booking_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `service_id` bigint(20) UNSIGNED DEFAULT NULL,
  `qty` int(10) UNSIGNED DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jv_booking_items`
--

INSERT INTO `jv_booking_items` (`id`, `order_id`, `service_id`, `qty`, `unit_price`) VALUES
(42, 33, 99, 1, 10.00),
(43, 34, 99, 1, 10.00),
(44, 35, 97, 1, 100.00),
(45, 35, 98, 1, 200.00),
(46, 35, 100, 1, 50.00),
(47, 35, 101, 1, 100.00),
(48, 36, 97, 1, 100.00),
(49, 36, 98, 1, 200.00),
(50, 36, 100, 1, 50.00),
(51, 36, 101, 1, 100.00),
(52, 37, 101, 1, 100.00),
(53, 38, 101, 1, 100.00),
(54, 39, 101, 1, 100.00),
(55, 40, 101, 1, 100.00),
(56, 41, 101, 1, 100.00),
(57, 42, 101, 1, 100.00),
(58, 43, 101, 1, 100.00),
(59, 44, 101, 1, 100.00),
(60, 45, 101, 1, 100.00),
(61, 46, 101, 1, 100.00),
(62, 47, 101, 1, 100.00),
(63, 48, 101, 1, 100.00),
(64, 49, 101, 1, 100.00),
(65, 50, 101, 1, 100.00),
(66, 51, 101, 1, 100.00),
(67, 52, 101, 1, 100.00),
(68, 53, 101, 1, 100.00),
(69, 54, 101, 1, 100.00),
(70, 55, 101, 1, 100.00),
(71, 56, 101, 1, 100.00),
(72, 57, 101, 1, 100.00),
(73, 58, 101, 1, 100.00),
(74, 59, 101, 1, 100.00),
(75, 60, 101, 1, 100.00),
(76, 61, 101, 1, 100.00),
(77, 62, 101, 1, 100.00),
(78, 63, 101, 1, 100.00),
(79, 64, 101, 1, 100.00),
(80, 65, 101, 1, 100.00),
(81, 66, 101, 1, 100.00),
(82, 67, 101, 1, 100.00),
(83, 68, 101, 1, 100.00),
(84, 69, 101, 1, 100.00),
(85, 70, 101, 1, 100.00),
(86, 71, 101, 1, 100.00),
(87, 72, 99, 1, 10.00),
(88, 73, 99, 1, 10.00),
(89, 74, 97, 1, 100.00),
(90, 75, 98, 1, 200.00),
(91, 75, 100, 1, 50.00),
(92, 76, 101, 1, 100.00),
(93, 77, 101, 1, 100.00),
(94, 78, 98, 1, 200.00),
(95, 79, 101, 1, 100.00),
(96, 80, 98, 2, 200.00),
(97, 80, 99, 1, 200.00),
(98, 80, 100, 1, 50.00),
(99, 81, 100, 1, 50.00),
(100, 82, 101, 1, 100.00),
(101, 82, 100, 1, 50.00),
(102, 83, 100, 1, 50.00),
(103, 84, 98, 1, 200.00),
(104, 85, 101, 1, 100.00),
(105, 86, 101, 1, 100.00),
(106, 87, 101, 1, 100.00),
(107, 88, 101, 1, 100.00),
(108, 89, 101, 1, 100.00),
(109, 90, 101, 1, 100.00),
(110, 91, 102, 1, 500.00),
(111, 92, 98, 2, 200.00),
(112, 93, 97, 2, 100.00),
(113, 94, 98, 1, 200.00),
(114, 95, 98, 1, 200.00),
(115, 96, 98, 1, 200.00),
(116, 97, 101, 1, 100.00),
(117, 98, 101, 1, 100.00),
(118, 99, 101, 1, 100.00),
(119, 100, 101, 1, 100.00),
(120, 101, 101, 1, 100.00),
(121, 102, 101, 1, 100.00),
(122, 102, 102, 1, 500.00),
(123, 103, 98, 1, 200.00),
(124, 103, 101, 1, 100.00),
(125, 103, 102, 1, 500.00),
(126, 104, 101, 1, 100.00);

-- --------------------------------------------------------

--
-- Table structure for table `jv_booking_reject_history`
--

CREATE TABLE `jv_booking_reject_history` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jv_booking_reject_history`
--

INSERT INTO `jv_booking_reject_history` (`id`, `user_id`, `order_id`, `created_at`, `updated_at`) VALUES
(1, 408, 42, '2023-12-30 20:21:28', NULL),
(2, 408, 43, '2023-12-30 20:23:59', NULL),
(3, 408, 43, '2023-12-31 07:28:39', NULL),
(4, 408, 103, '2024-01-02 17:21:31', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jv_contact`
--

CREATE TABLE `jv_contact` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_email` varchar(255) NOT NULL,
  `subject` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `message` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_contact`
--

INSERT INTO `jv_contact` (`id`, `customer_name`, `customer_email`, `subject`, `message`, `created_at`, `updated_at`) VALUES
(1, 'Jhon Doe', 'john@gmail.com', 'This is demo line', 'This is also a demo line too', '2023-11-01 20:18:22', '2023-11-01 20:18:22'),
(2, 'Jhon Doe', 'john@gmail.com', 'This is demo line', 'This is also a demo line too', '2023-11-02 03:24:50', '2023-11-02 03:24:50'),
(3, 'Jhon Doe', 'john@gmail.com', 'This is demo line', 'This is also a demo line too', '2023-11-03 01:51:06', '2023-11-03 01:51:06'),
(4, 'Jhon Doe', 'john@gmail.com', 'This is demo line', 'test', '2023-11-03 02:04:57', '2023-11-03 02:04:57'),
(5, 'Jhon Doe', 'john@gmail.com', 'This is demo line', 'test', '2023-11-03 02:05:58', '2023-11-03 02:05:58'),
(6, 'Jhon Doe', 'john@gmail.com', 'test', 'test', '2023-11-03 02:08:30', '2023-11-03 02:08:30'),
(7, 'sc', 'schattaraj200@gmail.com', 'test', 'test', '2023-11-03 03:32:39', '2023-11-03 03:32:39'),
(8, 'testdvjn', 'higufigig@hotmail.com', 'ghjkldfghjk', 'dfghjk', '2024-01-01 18:24:20', '2024-01-01 18:24:20');

-- --------------------------------------------------------

--
-- Table structure for table `jv_customer_cart`
--

CREATE TABLE `jv_customer_cart` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uniq_cart_id` varchar(100) NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `customer_lat` varchar(50) NOT NULL,
  `customer_lng` varchar(50) NOT NULL,
  `item_type` enum('product','service') DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jv_customer_cart`
--

INSERT INTO `jv_customer_cart` (`id`, `uniq_cart_id`, `customer_id`, `customer_lat`, `customer_lng`, `item_type`, `created_at`, `updated_at`) VALUES
(51, 'd9411a901a92462d67a9e45a0bbd5df023597279', NULL, '22.5726', '88.3639', 'product', '2023-11-22 19:20:05', NULL),
(52, '61ca3525e4832bf6a4e90bb4a73b063dbf1225a8', NULL, '22.9868', '87.8550', 'product', '2023-11-25 17:41:20', NULL),
(53, '8eeddcac7b333d6f000dc3a43043cc757bc5a269', NULL, '22.5761', '88.4285', 'service', '2023-11-26 04:32:30', NULL),
(59, '20c55c56f425d14fca99091a5e2b1f98895aa60f', NULL, '22.5706', '88.3622', 'product', '2023-11-28 18:01:21', NULL),
(61, '30a3fceed4dad60eb34cafff2d7694670244de39', NULL, '22.5518', '88.3531', 'product', '2023-11-30 09:43:35', NULL),
(68, '452877ce0061c1145a6860d69da8393c84906811', NULL, '22.5726', '88.3639', 'product', '2023-12-05 18:38:01', NULL),
(69, 'ed78c7218efa1f0d1177518d0bde5b3a05944666', NULL, '22.4887', '88.3261', 'service', '2023-12-09 08:54:51', NULL),
(70, '37b6c02b51a34f8e56411fe794d2160a684b9f1e', 409, '22.9868', '87.8550', 'service', '2023-12-10 09:46:20', '2024-01-03 06:34:45'),
(74, '9c8cac3be4fc208052208ec78d1489bd73ee3c89', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:44:07', NULL),
(75, '0595c031dee681ecafe601929beaab47aa222c96', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:44:34', NULL),
(76, '6e071b284cd925833dd7263a8123b492f22e35d4', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:45:03', NULL),
(77, 'c1e90e97388ae3bf06760f8ee8b7cf068a9819bb', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:45:26', NULL),
(78, '4ac0781a0981c043dd016e4d0213e26a14ea2809', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:45:59', NULL),
(79, 'a4c03560f1d2918967d2de831a8470dc0829a06b', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:46:47', NULL),
(80, 'c8516f3eed059bdacb951e02f25ad1c7db2e9723', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:49:55', NULL),
(81, '70dcaed165612a3e7b0ac9f48c854d16412ae391', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:50:44', NULL),
(82, '41a4372544621cb47117583e2142661a4b267941', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:50:52', NULL),
(83, 'a638aed65ad4fb5247f9d2420279bf1684c0e195', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:54:16', NULL),
(84, '25176efdd8427837550c1eed95be7eec03df89c7', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:54:49', NULL),
(85, '655ddd4e35b7c284aa0d854beb0272a27e89b34e', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:55:14', NULL),
(86, 'b6f2ad91d3cf495ef3d92689b481984f0c7043e8', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:56:18', NULL),
(87, 'c68730f2488ff15cf8fff08c2818ca8693a5ed7b', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:58:07', NULL),
(88, 'af0070ed9809ab63c10a641d569b2022608be39d', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:58:24', NULL),
(89, 'c750ce58047d931979a4026b61d65dbf9ed846e4', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:58:29', NULL),
(90, '596468d04044a0290f56c29bc6a7707107407282', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:58:53', NULL),
(91, '9ff12d23e12a203b006397840bf7727921e0cf68', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 19:59:35', NULL),
(92, 'b580acf79e4b49bacab200c99d904001200b3376', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 20:00:48', NULL),
(94, '24250810aff759b5d4b6271b79d014886ba5bc1c', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 20:37:24', NULL),
(95, '78cd6372c39952eab71f475851d864c449b8ff24', NULL, '37.7858', '-122.4064', 'service', '2023-12-10 20:42:53', NULL),
(98, 'c3e765dc58ae5ecb8b670ba4db5e985b1ea4393d', NULL, '37.7858', '-122.4064', 'product', '2023-12-16 08:59:54', '2023-12-16 09:02:30'),
(99, '90e6ad5b78b7843e08d3ebe29bd23d0f87a23dfa', NULL, '12.9598', '77.7143', 'service', '2023-12-16 09:08:18', NULL),
(100, '299ca98a547270ef8329b9c14db35111579f34ac', NULL, '37.7858', '-122.4064', 'service', '2023-12-16 09:11:48', NULL),
(102, '6b91a152ead3f0416cdae53319af3019ebec5be2', NULL, '37.7858', '-122.4064', 'product', '2023-12-16 17:48:22', '2023-12-16 17:51:27'),
(103, '5840e8dd38760127807f671712e55969b1c666aa', NULL, '37.7858', '-122.4064', 'service', '2023-12-16 17:54:09', '2023-12-16 18:22:50'),
(110, '3284b1990e90a4693b3de7f85cbc056fe2caf8f6', 413, '12.9598', '77.7144', 'service', '2023-12-19 16:50:34', NULL),
(112, 'c27abec22075aefd229dd76a1d96858e2ed5c7eb', 414, '21.4536', '80.2122', 'service', '2023-12-21 17:08:59', NULL),
(119, '815fbfe2db9b2830045ae2dd8d082bb36fe3ae16', NULL, '17.4852', '78.3086', 'service', '2023-12-27 19:31:52', NULL),
(121, '16264533e07405ab751d78ceed35bfa094cb3e6d', 420, '21.1767', '72.8025', 'service', '2023-12-27 19:42:37', NULL),
(123, '13e24954d83d4e8514ffc9860fda1cd6f61e120e', 408, '21.1767', '72.8025', 'product', '2023-12-29 18:19:29', NULL),
(124, 'c7104ceacecf562cc76b08dfc24bd24664f24e8b', 408, '21.1767', '72.8025', 'product', '2023-12-29 18:19:29', NULL),
(125, '1435af3c14f2b96304064a653e46f9b8cdd5ef9b', 408, '21.1767', '72.8025', 'product', '2023-12-29 18:19:29', NULL),
(126, '95f0e14792e34489d1e3dd5b689d0bff75551f0a', 408, '21.1767', '72.8025', 'product', '2023-12-29 18:19:29', NULL),
(144, '8d1f085891c5fbcaebdad9bbf984600deed30514', 411, 'NaN', 'NaN', 'service', '2023-12-30 20:05:15', NULL),
(146, '30957535cf6099f922d0c4c122581871759659d2', 422, '21.1458', '79.0882', 'service', '2024-01-01 17:44:21', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jv_customer_cart_items`
--

CREATE TABLE `jv_customer_cart_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cart_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_sku` varchar(20) NOT NULL,
  `qty` int(10) UNSIGNED NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_customer_cart_items`
--

INSERT INTO `jv_customer_cart_items` (`id`, `cart_id`, `product_id`, `product_sku`, `qty`, `unit_price`, `created_at`) VALUES
(79, 51, 3, 'PO01278', 1, 80.00, '2023-11-22 19:20:05'),
(80, 51, 1, 'JVDIN001', 1, 90.00, '2023-11-22 19:22:16'),
(81, 52, 1, 'JVDIN001', 1, 90.00, '2023-11-25 17:41:20'),
(87, 59, 1, 'JVDIN001', 1, 90.00, '2023-11-28 18:01:22'),
(89, 61, 1, 'JVDIN001', 1, 90.00, '2023-11-30 09:43:35'),
(94, 68, 3, 'PO01278', 2, 90.00, '2023-12-05 18:38:01'),
(114, 98, 6, '7575868', 1, 1200.00, '2023-12-16 09:02:41'),
(115, 102, 6, '7575868', 1, 1200.00, '2023-12-16 17:51:27'),
(121, 124, 5, '567565675', 1, 800.00, '2023-12-29 18:19:29'),
(122, 126, 5, '567565675', 1, 800.00, '2023-12-29 18:19:29'),
(123, 125, 5, '567565675', 1, 800.00, '2023-12-29 18:19:29'),
(124, 123, 5, '567565675', 2, 800.00, '2023-12-29 18:19:29');

-- --------------------------------------------------------

--
-- Table structure for table `jv_customer_cart_service_items`
--

CREATE TABLE `jv_customer_cart_service_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cart_id` bigint(20) UNSIGNED DEFAULT NULL,
  `service_id` bigint(20) UNSIGNED DEFAULT NULL,
  `qty` int(10) UNSIGNED DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `weekday_number` tinyint(4) DEFAULT NULL,
  `timing` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_customer_cart_service_items`
--

INSERT INTO `jv_customer_cart_service_items` (`id`, `cart_id`, `service_id`, `qty`, `unit_price`, `weekday_number`, `timing`) VALUES
(3, 53, 91, 1, 10.00, NULL, NULL),
(35, 74, 101, 1, 100.00, NULL, NULL),
(36, 75, 101, 1, 100.00, NULL, NULL),
(37, 76, 101, 1, 100.00, NULL, NULL),
(38, 77, 101, 1, 100.00, NULL, NULL),
(39, 78, 101, 1, 100.00, NULL, NULL),
(40, 79, 101, 1, 100.00, NULL, NULL),
(41, 80, 101, 1, 100.00, NULL, NULL),
(42, 81, 101, 1, 100.00, NULL, NULL),
(43, 82, 101, 1, 100.00, NULL, NULL),
(44, 83, 101, 1, 100.00, NULL, NULL),
(45, 84, 101, 1, 100.00, NULL, NULL),
(46, 85, 101, 1, 100.00, NULL, NULL),
(47, 86, 101, 1, 100.00, NULL, NULL),
(48, 87, 101, 1, 100.00, NULL, NULL),
(49, 88, 98, 1, 200.00, NULL, NULL),
(50, 89, 98, 1, 200.00, NULL, NULL),
(51, 90, 100, 1, 50.00, NULL, NULL),
(52, 91, 98, 1, 200.00, NULL, NULL),
(58, 94, 98, 1, 200.00, NULL, NULL),
(59, 94, 100, 1, 50.00, NULL, NULL),
(62, 95, 101, 1, 100.00, NULL, NULL),
(83, 99, 101, 1, 100.00, NULL, NULL),
(84, 100, 101, 1, 100.00, NULL, NULL),
(90, 103, 101, 1, 100.00, NULL, NULL),
(102, 110, 101, 1, 100.00, 0, '15:00:00'),
(105, 112, 97, 1, 100.00, 1, '07:30:00'),
(107, 112, 100, 1, 50.00, NULL, NULL),
(118, 119, 98, 1, 200.00, NULL, NULL),
(120, 121, 98, 2, 200.00, NULL, NULL),
(121, 121, 99, 1, 200.00, NULL, NULL),
(122, 121, 100, 1, 50.00, NULL, NULL),
(155, 144, 101, 1, 100.00, NULL, NULL),
(159, 146, 101, 1, 100.00, NULL, NULL),
(160, 146, 102, 1, 500.00, NULL, NULL),
(163, 70, 102, 1, 500.00, 0, '07:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `jv_orders`
--

CREATE TABLE `jv_orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uniq_order_id` varchar(100) NOT NULL,
  `customer_cart_id` varchar(500) DEFAULT NULL,
  `customer_lat` varchar(10) DEFAULT NULL,
  `customer_lng` varchar(10) DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `discount` decimal(10,2) DEFAULT 0.00,
  `tax_gst` decimal(10,2) NOT NULL,
  `tax_qst` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `order_status` enum('pending','onhold','proccessing','completed') DEFAULT 'pending',
  `payment_status` enum('paid','unpaid') NOT NULL DEFAULT 'unpaid',
  `stripe_payment_ref` text DEFAULT NULL,
  `billing_address` longtext NOT NULL,
  `shipping_address` longtext NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_orders`
--

INSERT INTO `jv_orders` (`id`, `uniq_order_id`, `customer_cart_id`, `customer_lat`, `customer_lng`, `customer_id`, `subtotal`, `discount`, `tax_gst`, `tax_qst`, `total`, `order_status`, `payment_status`, `stripe_payment_ref`, `billing_address`, `shipping_address`, `created_at`, `updated_at`) VALUES
(2, 'JV-653E35F81050F', '133a02f259753f7750636432f9e2813c59aed5ac', '22.5726', '88.3639', NULL, 360.00, 0.00, 18.00, 35.91, 413.91, 'pending', 'unpaid', NULL, '{\"id\":6,\"user_id\":302,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-10-29 10:35:18\",\"updated_at\":\"2023-10-29 10:35:18\"}', '{\"id\":6,\"user_id\":302,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-10-29 10:35:18\",\"updated_at\":\"2023-10-29 10:35:18\"}', '2023-10-29 10:37:44', NULL),
(3, 'JV-653E366063CB0', '133a02f259753f7750636432f9e2813c59aed5ac', '22.5726', '88.3639', NULL, 360.00, 0.00, 18.00, 35.91, 413.91, 'pending', 'paid', '{\"stripe_invoice_id\":\"in_1O6WQCSJdxCyQkYTAKz1Epsk\",\"stripe_customer_id\":\"cus_OuL6bFkSvNpQQn\",\"currency\":\"cad\",\"payment_method_types\":[\"card\"]}', '{\"id\":6,\"user_id\":302,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-10-29 10:35:18\",\"updated_at\":\"2023-10-29 10:35:18\"}', '{\"id\":6,\"user_id\":302,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-10-29 10:35:18\",\"updated_at\":\"2023-10-29 10:35:18\"}', '2023-10-29 10:39:28', '2023-10-29 10:40:47'),
(4, 'JV-653E37B815ABA', 'c2b54aad5772622b154cc16aa33acf9ff2e1f9c1', '22.5726', '88.3639', NULL, 180.00, 0.00, 9.00, 17.96, 206.96, 'pending', 'paid', '{\"stripe_invoice_id\":\"in_1O6WWcSJdxCyQkYTDyXMMkLJ\",\"stripe_customer_id\":\"cus_OuLCjNLmaW0ZaF\",\"currency\":\"cad\",\"payment_method_types\":[\"card\"]}', '{\"id\":6,\"user_id\":302,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-10-29 10:35:18\",\"updated_at\":\"2023-10-29 10:35:18\"}', '{\"id\":6,\"user_id\":302,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-10-29 10:35:18\",\"updated_at\":\"2023-10-29 10:35:18\"}', '2023-10-29 10:45:12', '2023-10-29 10:47:25'),
(5, 'JV-653F48CB8E105', '8f78817e4f711ec6afb20f2a8e6d79dac54a5792', '22.6269095', '88.4024249', NULL, 90.00, 0.00, 4.50, 8.98, 103.48, 'pending', 'unpaid', NULL, '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '2023-10-30 06:10:19', NULL),
(6, 'JV-653F49633E034', '8f78817e4f711ec6afb20f2a8e6d79dac54a5792', '22.6269095', '88.4024249', NULL, 90.00, 0.00, 4.50, 8.98, 103.48, 'pending', 'unpaid', NULL, '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '2023-10-30 06:12:51', NULL),
(7, 'JV-653F497502AEA', '8f78817e4f711ec6afb20f2a8e6d79dac54a5792', '22.6269095', '88.4024249', NULL, 90.00, 0.00, 4.50, 8.98, 103.48, 'pending', 'unpaid', NULL, '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '2023-10-30 06:13:09', NULL),
(8, 'JV-653F49D1D34FD', '8f78817e4f711ec6afb20f2a8e6d79dac54a5792', '22.6269095', '88.4024249', NULL, 90.00, 0.00, 4.50, 8.98, 103.48, 'pending', 'unpaid', NULL, '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '2023-10-30 06:14:41', NULL),
(9, 'JV-653F49E02318A', '8f78817e4f711ec6afb20f2a8e6d79dac54a5792', '22.6269095', '88.4024249', NULL, 90.00, 0.00, 4.50, 8.98, 103.48, 'pending', 'unpaid', NULL, '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '2023-10-30 06:14:56', NULL),
(10, 'JV-653F4A827792E', '8f78817e4f711ec6afb20f2a8e6d79dac54a5792', '22.6269095', '88.4024249', NULL, 90.00, 0.00, 4.50, 8.98, 103.48, 'pending', 'unpaid', NULL, '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '2023-10-30 06:17:38', NULL),
(11, 'JV-6541258427F1C', '717a67139eb48853199c4be09d2bf951692075d1', '22.6269', '88.4024', NULL, 90.00, 0.00, 4.50, 8.98, 103.48, 'pending', 'unpaid', NULL, '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-10-31 16:04:20', NULL),
(12, 'JV-654128C79360E', '717a67139eb48853199c4be09d2bf951692075d1', '22.6269', '88.4024', NULL, 90.00, 0.00, 4.50, 8.98, 103.48, 'pending', 'paid', '{\"stripe_invoice_id\":\"in_1O7KmRSJdxCyQkYTPYjd0pkE\",\"stripe_customer_id\":\"cus_OvB4uhXDGtTpQ7\",\"currency\":\"cad\",\"payment_method_types\":[\"card\"]}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-10-31 16:18:15', '2023-10-31 16:27:08'),
(13, 'JV-65431156437C4', '9133f9616aa8805753c2707bb4a11bcd996612a3', '23.5204', '87.3119', NULL, 80.00, 0.00, 4.00, 7.98, 91.98, 'pending', 'unpaid', NULL, '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-02 03:02:46', NULL),
(14, 'JV-6543CC6849403', '810c68dcdbdc93faee5519615eb76b070ab44965', '21.1766', '72.8025', NULL, 80.00, 0.00, 4.00, 7.98, 91.98, 'pending', 'paid', '{\"stripe_invoice_id\":\"in_1O83iNSJdxCyQkYT3Mu26Swy\",\"stripe_customer_id\":\"cus_OvvYJiGrrtr3Ds\",\"currency\":\"cad\",\"payment_method_types\":[\"card\"]}', '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '2023-11-02 16:20:56', '2023-11-02 16:25:55'),
(15, 'JV-6543CF2E9BBBC', '6d655c0a62a9e35126eefa9d7b82252561d55c10', '21.1766', '72.8023', NULL, 80.00, 0.00, 4.00, 7.98, 91.98, 'pending', 'unpaid', NULL, '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '2023-11-02 16:32:46', NULL),
(16, 'JV-6543CF52348EE', '6d655c0a62a9e35126eefa9d7b82252561d55c10', '21.1766', '72.8023', NULL, 80.00, 0.00, 4.00, 7.98, 91.98, 'pending', 'unpaid', NULL, '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '2023-11-02 16:33:22', NULL),
(17, 'JV-6543CF91CE42D', '6d655c0a62a9e35126eefa9d7b82252561d55c10', '21.1766', '72.8023', NULL, 80.00, 0.00, 4.00, 7.98, 91.98, 'pending', 'unpaid', NULL, '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '2023-11-02 16:34:25', NULL),
(18, 'JV-6543D0B38D3D2', '6d655c0a62a9e35126eefa9d7b82252561d55c10', '21.1766', '72.8023', NULL, 80.00, 0.00, 4.00, 7.98, 91.98, 'pending', 'paid', '{\"stripe_invoice_id\":\"in_1O83z1SJdxCyQkYTsRjtt1Q1\",\"stripe_customer_id\":\"cus_OvvqSe4VtERH1n\",\"currency\":\"cad\",\"payment_method_types\":[\"card\"]}', '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '2023-11-02 16:39:15', '2023-11-02 16:43:05'),
(19, 'JV-6543D0CA92E63', '6d655c0a62a9e35126eefa9d7b82252561d55c10', '21.1766', '72.8023', NULL, 80.00, 0.00, 4.00, 7.98, 91.98, 'pending', 'unpaid', NULL, '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '{\"id\":34,\"user_id\":306,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Rampur digar\",\"city\":\"Surat\",\"province\":\"Ontario\",\"zip_code\":\"841408\",\"country_code\":\"+1\",\"phone\":\"07903792110\",\"email\":\"nileshkumar5896@gmail.com\",\"additional_information\":null,\"is_defualt\":0,\"created_at\":\"2023-11-02 16:20:53\",\"updated_at\":\"2023-11-02 16:20:53\"}', '2023-11-02 16:39:38', NULL),
(20, 'JV-6544E88ECE5BD', 'c9e2a1b4b8071e958fc4a7ee1a9ff6f8402f8f67', '22.5397', '88.3493', NULL, 170.00, 0.00, 8.50, 16.96, 195.46, 'pending', 'paid', '{\"stripe_invoice_id\":\"in_1O8MccSJdxCyQkYTCkf4Ne0f\",\"stripe_customer_id\":\"cus_OwF6hyLaGNQc5w\",\"currency\":\"cad\",\"payment_method_types\":[\"card\"]}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-03 12:33:18', '2023-11-03 12:37:13'),
(21, 'JV-654531846F1F7', '1c177aa4e811374ce1af4f420e6b280d2a5d83e6', '23.5204', '87.3119', NULL, 80.00, 0.00, 4.00, 7.98, 91.98, 'pending', 'unpaid', NULL, '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-03 17:44:36', NULL),
(22, 'JV-6545381C2021E', '1c177aa4e811374ce1af4f420e6b280d2a5d83e6', '23.5204', '87.3119', NULL, 130.00, 0.00, 6.50, 12.97, 149.47, 'pending', 'paid', '{\"stripe_invoice_id\":\"in_1O8RxnSJdxCyQkYTk11tIErF\",\"stripe_customer_id\":\"cus_OwKcQRFeGS5co0\",\"currency\":\"cad\",\"payment_method_types\":[\"card\"]}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-03 18:12:44', '2023-11-03 18:19:28'),
(23, 'JV-65453DD4BD890', '932a5cf749ee9d1467e15c5b1926c84d3ef80d6b', '23.5204', '87.3119', NULL, 50.00, 0.00, 2.50, 4.99, 57.49, 'pending', 'unpaid', NULL, '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-03 18:37:08', NULL),
(24, 'JV-65453F1AE53EF', '932a5cf749ee9d1467e15c5b1926c84d3ef80d6b', '23.5204', '87.3119', NULL, 140.00, 0.00, 7.00, 13.97, 160.97, 'pending', 'unpaid', NULL, '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-03 18:42:34', NULL),
(25, 'JV-65453F5531284', '932a5cf749ee9d1467e15c5b1926c84d3ef80d6b', '23.5204', '87.3119', NULL, 140.00, 0.00, 7.00, 13.97, 160.97, 'pending', 'unpaid', NULL, '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-03 18:43:33', NULL),
(26, 'JV-65453FB98F704', '932a5cf749ee9d1467e15c5b1926c84d3ef80d6b', '23.5204', '87.3119', NULL, 140.00, 0.00, 7.00, 13.97, 160.97, 'pending', 'unpaid', NULL, '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-03 18:45:13', NULL),
(27, 'JV-6545D6676E4F0', '932a5cf749ee9d1467e15c5b1926c84d3ef80d6b', '23.5204', '87.3119', NULL, 140.00, 0.00, 7.00, 13.97, 160.97, 'pending', 'unpaid', NULL, '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-04 05:28:07', NULL),
(28, 'JV-65468B47B852B', '932a5cf749ee9d1467e15c5b1926c84d3ef80d6b', '23.5204', '87.3119', NULL, 250.00, 0.00, 12.50, 24.94, 287.44, 'pending', 'unpaid', NULL, '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '{\"id\":25,\"user_id\":305,\"first_name\":\"subrata\",\"last_name\":\"chattaraj\",\"company_name\":\"company\",\"country_name\":\"India\",\"street_address\":\"bankura\",\"city\":\"bankura\",\"province\":\"Ontario\",\"zip_code\":\"71234\",\"country_code\":\"+1\",\"phone\":\"8637378344\",\"email\":\"schattaraj200@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-31 16:04:18\",\"updated_at\":\"2023-10-31 16:04:18\"}', '2023-11-04 18:19:51', NULL),
(29, 'JV-PRO-6547689FA9DC0', 'a71d75fc42e9fddecebedcaad8f162ee3bdae084', '22.5726', '88.3639', NULL, 180.00, 0.00, 9.00, 17.96, 206.96, 'pending', 'paid', '{\"stripe_invoice_id\":\"in_1O93DCSJdxCyQkYTOLkHgfVG\",\"stripe_customer_id\":\"cus_Owx7kTNPcbwpI7\",\"currency\":\"cad\",\"payment_method_types\":[\"card\"]}', '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '{\"id\":8,\"user_id\":287,\"first_name\":\"sudip\",\"last_name\":\"chatterjee\",\"company_name\":\"company\",\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":\"test\",\"is_defualt\":0,\"created_at\":\"2023-10-29 18:48:01\",\"updated_at\":\"2023-10-29 18:48:01\"}', '2023-11-05 15:34:15', '2023-11-05 15:35:49'),
(30, 'JV-PRO-657B57E30E729', 'b1d9a3e7a139af61615c5060422eed16e09c1f85', '22.5726', '88.3639', NULL, 800.00, 0.00, 48.40, 96.56, 944.96, 'pending', 'unpaid', NULL, '{\"id\":63,\"user_id\":398,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-14 19:30:15\",\"updated_at\":\"2023-12-14 19:30:15\"}', '{\"id\":63,\"user_id\":398,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-14 19:30:15\",\"updated_at\":\"2023-12-14 19:30:15\"}', '2023-12-14 19:30:43', NULL),
(31, 'JV-PRO-657B5F8E95960', 'b1d9a3e7a139af61615c5060422eed16e09c1f85', '22.5726', '88.3639', NULL, 800.00, 0.00, 48.40, 96.56, 944.96, 'pending', 'unpaid', NULL, '{\"id\":63,\"user_id\":398,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-14 19:30:15\",\"updated_at\":\"2023-12-14 19:30:15\"}', '{\"id\":63,\"user_id\":398,\"first_name\":\"Richard\",\"last_name\":\"Paul\",\"apartment\":\"BC Apartment\",\"company_name\":null,\"country_name\":\"Canada\",\"street_address\":\"70 The Pond Rd\",\"city\":\"Toronto\",\"province\":\"Ontario\",\"zip_code\":\"M3J3M6\",\"country_code\":\"+1\",\"phone\":\"4164915050\",\"email\":\"bera@gmail.com\",\"additional_information\":null,\"locality\":\"R Nagar\",\"landmark\":\"Near Mia More Shop\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-14 19:30:15\",\"updated_at\":\"2023-12-14 19:30:15\"}', '2023-12-14 20:03:26', NULL),
(32, 'JV-PRO-657B62FE133A2', 'e8727fcab7a0130b8b5ae60472809cc4f43b82e8', '37.7858', '-122.4064', NULL, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '2023-12-14 20:18:06', NULL),
(33, 'JV-PRO-657B63530EEF4', 'e8727fcab7a0130b8b5ae60472809cc4f43b82e8', '37.7858', '-122.4064', NULL, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '2023-12-14 20:19:31', NULL),
(34, 'JV-PRO-657B654187C17', 'e8727fcab7a0130b8b5ae60472809cc4f43b82e8', '37.7858', '-122.4064', NULL, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '2023-12-14 20:27:45', NULL),
(35, 'JV-PRO-657B655C99561', 'e8727fcab7a0130b8b5ae60472809cc4f43b82e8', '37.7858', '-122.4064', NULL, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '2023-12-14 20:28:12', NULL),
(36, 'JV-PRO-657B659DD4702', 'e8727fcab7a0130b8b5ae60472809cc4f43b82e8', '37.7858', '-122.4064', NULL, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '2023-12-14 20:29:17', NULL),
(37, 'JV-PRO-657B65B28A43F', 'e8727fcab7a0130b8b5ae60472809cc4f43b82e8', '37.7858', '-122.4064', NULL, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '2023-12-14 20:29:38', NULL),
(38, 'JV-PRO-657B66060ECA4', 'e8727fcab7a0130b8b5ae60472809cc4f43b82e8', '37.7858', '-122.4064', NULL, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '2023-12-14 20:31:02', NULL),
(39, 'JV-PRO-657B68F3D320D', 'e8727fcab7a0130b8b5ae60472809cc4f43b82e8', '37.7858', '-122.4064', NULL, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '2023-12-14 20:43:31', NULL),
(40, 'JV-PRO-657B690422DA1', 'e8727fcab7a0130b8b5ae60472809cc4f43b82e8', '37.7858', '-122.4064', NULL, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '{\"id\":61,\"user_id\":400,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Mkd\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"35 Mkd\",\"city\":\"Kolkata\",\"province\":\"West Bengal\",\"zip_code\":\"767676\",\"country_code\":\"+1\",\"phone\":\"8787878786\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"L Lane\",\"landmark\":\"C Club\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-10 21:09:36\",\"updated_at\":\"2023-12-10 21:09:36\"}', '2023-12-14 20:43:48', NULL),
(41, 'JV-PRO-657DF73CA01A7', 'ae0219266c6c91347ab158e4b8944c331ff00524', '37.7858', '-122.4064', 411, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-16 19:15:08', NULL),
(42, 'JV-PRO-65883809DF575', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 13:54:17', NULL);
INSERT INTO `jv_orders` (`id`, `uniq_order_id`, `customer_cart_id`, `customer_lat`, `customer_lng`, `customer_id`, `subtotal`, `discount`, `tax_gst`, `tax_qst`, `total`, `order_status`, `payment_status`, `stripe_payment_ref`, `billing_address`, `shipping_address`, `created_at`, `updated_at`) VALUES
(43, 'JV-PRO-6588386C6F2A9', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 13:55:56', NULL),
(44, 'JV-PRO-65883881AF92C', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 13:56:17', NULL),
(45, 'JV-PRO-6588389FE1F93', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 13:56:47', NULL),
(46, 'JV-PRO-658838F0AFFA8', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 13:58:08', NULL),
(47, 'JV-PRO-6588392476258', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 13:59:00', NULL),
(48, 'JV-PRO-6588399A965C5', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 14:00:58', NULL),
(49, 'JV-PRO-65883A8B2D308', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 14:04:59', NULL),
(50, 'JV-PRO-65883AC7311D0', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 14:05:59', NULL),
(51, 'JV-PRO-65883AF50B784', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 14:06:45', NULL),
(52, 'JV-PRO-65883B13910E1', 'd93dca837e6ce04e61460f11dd4dfe7f20f07f3c', '12.9598', '77.7143', 407, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '{\"id\":65,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":\"Test\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Test\",\"city\":\"Test\",\"province\":\"Assam\",\"zip_code\":\"252458\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Test\",\"landmark\":\"Test\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 09:08:55\",\"updated_at\":\"2023-12-16 09:08:55\"}', '2023-12-24 14:07:15', NULL),
(53, 'JV-PRO-658F96CF66E18', '93e9063b8a522c9e858ee8a81d30d0eafa54695a', '21.1767', '72.8025', 407, 2400.00, 0.00, 145.20, 289.67, 2834.87, 'pending', 'unpaid', NULL, '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '{\"id\":72,\"user_id\":407,\"first_name\":\"Test\",\"last_name\":\"User\",\"apartment\":null,\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"Abc\",\"city\":\"Surat\",\"province\":\"Haryana\",\"zip_code\":\"9669\",\"country_code\":\"+1\",\"phone\":\"8525254625\",\"email\":\"test@mail.com\",\"additional_information\":null,\"locality\":\"Kolk\",\"landmark\":\"Abc\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-30 04:03:53\",\"updated_at\":\"2023-12-30 04:03:53\"}', '2023-12-30 04:04:31', NULL),
(54, 'JV-PRO-6590739B58D88', '944053ce08600e14dd8f96ac37e4bd656507f6a5', '37.4220', '-122.0840', 411, 1200.00, 0.00, 72.60, 144.84, 1417.44, 'pending', 'unpaid', NULL, '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '{\"id\":67,\"user_id\":411,\"first_name\":\"Nilesh\",\"last_name\":\"Kumar\",\"apartment\":\"Ujjaini\",\"company_name\":null,\"country_name\":\"India\",\"street_address\":\"108\",\"city\":\"Bangalore\",\"province\":\"Karnataka\",\"zip_code\":\"878887\",\"country_code\":\"+1\",\"phone\":\"7676674647\",\"email\":\"nilesh@mail.com\",\"additional_information\":null,\"locality\":\"Ujjaini\",\"landmark\":\"Ujjaini\",\"landmark_type\":\"home\",\"is_defualt\":0,\"created_at\":\"2023-12-16 18:47:08\",\"updated_at\":\"2023-12-16 18:47:08\"}', '2023-12-30 19:46:35', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jv_order_items`
--

CREATE TABLE `jv_order_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `product_sku` varchar(100) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `unit_price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_order_items`
--

INSERT INTO `jv_order_items` (`id`, `order_id`, `product_id`, `product_sku`, `qty`, `unit_price`) VALUES
(2, 2, 37, 'JVDIN001', 4, 90.00),
(3, 3, 1, 'JVDIN001', 4, 90.00),
(4, 4, 1, 'JVDIN001', 2, 90.00),
(5, 5, 1, 'JVDIN001', 1, 90.00),
(6, 6, 1, 'JVDIN001', 1, 90.00),
(7, 7, 1, 'JVDIN001', 1, 90.00),
(8, 8, 1, 'JVDIN001', 1, 90.00),
(9, 9, 1, 'JVDIN001', 1, 90.00),
(10, 10, 1, 'JVDIN001', 1, 90.00),
(11, 11, 1, 'JVDIN001', 1, 90.00),
(12, 12, 1, 'JVDIN001', 1, 90.00),
(13, 13, 3, 'PO01278', 1, 80.00),
(14, 14, 3, 'PO01278', 1, 80.00),
(15, 15, 3, 'PO01278', 1, 80.00),
(16, 16, 3, 'PO01278', 1, 80.00),
(17, 17, 3, 'PO01278', 1, 80.00),
(18, 18, 3, 'PO01278', 1, 80.00),
(19, 19, 3, 'PO01278', 1, 80.00),
(20, 20, 1, 'JVDIN001', 1, 90.00),
(21, 20, 3, 'PO01278', 1, 80.00),
(22, 21, 3, 'PO01278', 1, 80.00),
(23, 22, 2, 'PO01235', 1, 50.00),
(24, 22, 3, 'PO01278', 1, 80.00),
(25, 23, 2, 'PO01235', 1, 50.00),
(26, 24, 1, 'JVDIN001', 1, 90.00),
(27, 24, 2, 'PO01235', 1, 50.00),
(28, 25, 1, 'JVDIN001', 1, 90.00),
(29, 25, 2, 'PO01235', 1, 50.00),
(30, 26, 1, 'JVDIN001', 1, 90.00),
(31, 26, 2, 'PO01235', 1, 50.00),
(32, 27, 1, 'JVDIN001', 1, 90.00),
(33, 27, 2, 'PO01235', 1, 50.00),
(34, 28, 2, 'PO01235', 1, 50.00),
(35, 28, 3, 'PO01278', 2, 100.00),
(36, 29, 1, 'JVDIN001', 2, 90.00),
(37, 30, 7, '57586869798', 1, 800.00),
(38, 31, 7, '57586869798', 1, 800.00),
(39, 32, 6, '7575868', 1, 1200.00),
(40, 33, 6, '7575868', 1, 1200.00),
(41, 34, 6, '7575868', 1, 1200.00),
(42, 35, 6, '7575868', 1, 1200.00),
(43, 36, 6, '7575868', 1, 1200.00),
(44, 37, 6, '7575868', 1, 1200.00),
(45, 38, 6, '7575868', 1, 1200.00),
(46, 39, 6, '7575868', 1, 1200.00),
(47, 40, 6, '7575868', 1, 1200.00),
(48, 41, 6, '7575868', 1, 1200.00),
(49, 42, 6, '7575868', 1, 1200.00),
(50, 43, 6, '7575868', 1, 1200.00),
(51, 44, 6, '7575868', 1, 1200.00),
(52, 45, 6, '7575868', 1, 1200.00),
(53, 46, 6, '7575868', 1, 1200.00),
(54, 47, 6, '7575868', 1, 1200.00),
(55, 48, 6, '7575868', 1, 1200.00),
(56, 49, 6, '7575868', 1, 1200.00),
(57, 50, 6, '7575868', 1, 1200.00),
(58, 51, 6, '7575868', 1, 1200.00),
(59, 52, 6, '7575868', 1, 1200.00),
(60, 53, 6, '7575868', 2, 1200.00),
(61, 54, 6, '7575868', 1, 1200.00);

-- --------------------------------------------------------

--
-- Table structure for table `jv_product`
--

CREATE TABLE `jv_product` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `seller_id` bigint(20) DEFAULT NULL,
  `name` varchar(500) NOT NULL,
  `slug` varchar(500) NOT NULL,
  `desp` text DEFAULT NULL,
  `sku` varchar(20) DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `units_in_stock` bigint(20) UNSIGNED DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `listing_status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `is_archived` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_product`
--

INSERT INTO `jv_product` (`id`, `seller_id`, `name`, `slug`, `desp`, `sku`, `category_id`, `units_in_stock`, `image_url`, `listing_status`, `is_archived`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, NULL, 'Dining Table', 'dining-table', 'Dining Table', 'JVDIN001', 3, 10, '653254573b677.jpg', 'active', 1, '2023-10-20 10:20:07', '2023-12-12 11:43:14', NULL, NULL),
(2, NULL, 'Normal Table For Kids', 'normal-table-for-kids', 'Normal Table', 'PO01235', 1, 10, '655e417fd56ef.jpeg', 'active', 1, '2023-10-20 10:22:04', '2023-12-12 11:43:11', NULL, NULL),
(3, NULL, 'Demo Product', 'demo-product', 'demo desp', 'PO01278', 2, 10, '655e35cd5b7fb.jpeg', 'active', 1, '2023-10-21 05:37:36', '2023-12-12 11:43:07', NULL, NULL),
(4, NULL, 'Dining Table', 'dining-table', 'Dining Table For 4 people', 'DIN-0001', 3, 10, '65742ad7a5683_DZdRyc2vP.jpg', 'active', 0, '2023-12-09 08:52:40', NULL, NULL, NULL),
(5, NULL, 'Fancy Chair', 'fancy-chair', 'Fancy chair for home.', '567565675', 2, 5, '6578820a402b6_T4UymByL-.jpeg', 'active', 0, '2023-12-12 15:53:47', NULL, NULL, NULL),
(6, NULL, 'Fridge', 'fridge', 'Best in class fridge.', '7575868', 4, 10, '65788241d4139_oab13jBVSo.jpeg', 'active', 0, '2023-12-12 15:54:43', NULL, NULL, NULL),
(7, NULL, 'Decoration Item', 'decoration-item', 'Home Decoration Item', '57586869798', 1, 12, '657882a1147cd_x2CTECHPLg.jpeg', 'active', 0, '2023-12-12 15:56:18', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jv_product_category`
--

CREATE TABLE `jv_product_category` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) DEFAULT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `image_url` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_product_category`
--

INSERT INTO `jv_product_category` (`id`, `name`, `slug`, `parent_id`, `image_url`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 'Home Essential', 'home-essential', NULL, 'https://ik.imagekit.io/5o2uz1trj/653253e3502d5_317PTSVNs.jpg', '2023-10-20 10:18:13', '2023-10-20 10:18:13', NULL, NULL),
(2, 'Home Extra', 'home-extra', NULL, 'https://ik.imagekit.io/5o2uz1trj/653253fe5dba8_di1bTYlK7.jpg', '2023-10-20 10:18:40', '2023-10-20 10:18:40', NULL, NULL),
(3, 'Furniture', 'furniture', NULL, 'https://ik.imagekit.io/5o2uz1trj/6532540bd1c0d_4Hef1ZfAA.jpg', '2023-10-20 10:18:53', '2023-10-20 10:18:53', NULL, NULL),
(4, 'Electricals', 'electricals', NULL, 'https://ik.imagekit.io/5o2uz1trj/6533659cd068a_qSCVPDZ5Gc.png', '2023-10-20 10:19:11', '2023-10-21 05:46:06', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jv_product_gallery`
--

CREATE TABLE `jv_product_gallery` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `image_url` text NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jv_product_gallery`
--

INSERT INTO `jv_product_gallery` (`id`, `product_id`, `image_url`, `created_at`) VALUES
(5, 2, '653254df202ac.jpg', '2023-10-20 10:22:23'),
(6, 2, '653254df204f9.jpg', '2023-10-20 10:22:23'),
(7, 3, '653363ca238ca.jpg', '2023-10-21 05:38:18'),
(8, 3, '653363ca23b44.jpg', '2023-10-21 05:38:18'),
(9, 3, '653363ca23cc6.jpg', '2023-10-21 05:38:18'),
(10, 2, '65336760efe6a.jpg', '2023-10-21 05:53:36'),
(11, 2, '65336760f02e8.jpg', '2023-10-21 05:53:36'),
(12, 2, '65336760f0d30.webp', '2023-10-21 05:53:36'),
(13, 1, '655e41a8b3e15.jpeg', '2023-11-22 18:00:08'),
(15, 7, '6578913ed6c30.jpeg', '2023-12-12 16:58:38'),
(16, 6, '657891546d324.jpeg', '2023-12-12 16:59:00'),
(17, 6, '65789191d4b26.jpeg', '2023-12-12 17:00:01');

-- --------------------------------------------------------

--
-- Table structure for table `jv_product_price`
--

CREATE TABLE `jv_product_price` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `sale_price` decimal(10,2) DEFAULT NULL,
  `currency` enum('INR','CAD') NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `created_by` int(11) DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_product_price`
--

INSERT INTO `jv_product_price` (`id`, `product_id`, `price`, `sale_price`, `currency`, `created_at`, `updated_at`, `created_by`, `updated_by`) VALUES
(1, 1, 100.00, 90.00, 'CAD', '2023-10-20 10:20:07', NULL, NULL, NULL),
(2, 2, 50.00, NULL, 'CAD', '2023-10-20 10:22:04', NULL, NULL, NULL),
(3, 3, 100.00, 90.00, 'CAD', '2023-10-21 05:37:36', NULL, NULL, NULL),
(4, 3, 100.00, 80.00, 'CAD', '2023-10-21 05:38:46', NULL, NULL, NULL),
(5, 2, 50.00, 40.00, 'CAD', '2023-10-21 05:48:00', NULL, NULL, NULL),
(6, 2, 50.00, NULL, 'CAD', '2023-10-23 18:56:04', NULL, NULL, NULL),
(7, 4, 500.00, 400.00, 'CAD', '2023-12-09 08:52:40', NULL, NULL, NULL),
(8, 4, 500.00, NULL, 'CAD', '2023-12-09 08:52:47', NULL, NULL, NULL),
(9, 4, 500.00, 400.00, 'CAD', '2023-12-09 08:52:54', NULL, NULL, NULL),
(10, 5, 800.00, 600.00, 'CAD', '2023-12-12 15:53:47', NULL, NULL, NULL),
(11, 6, 1200.00, 900.00, 'CAD', '2023-12-12 15:54:43', NULL, NULL, NULL),
(12, 7, 1000.00, 800.00, 'CAD', '2023-12-12 15:56:18', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jv_product_ratings`
--

CREATE TABLE `jv_product_ratings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `review` text DEFAULT NULL,
  `rating` tinyint(4) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jv_product_tax`
--

CREATE TABLE `jv_product_tax` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `product_id` bigint(20) UNSIGNED DEFAULT NULL,
  `hsn_code` varchar(10) NOT NULL,
  `tax_code` varchar(20) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jv_provider_slots`
--

CREATE TABLE `jv_provider_slots` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `provider_id` bigint(20) UNSIGNED DEFAULT NULL,
  `weeekday` tinyint(3) UNSIGNED NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jv_provider_slots`
--

INSERT INTO `jv_provider_slots` (`id`, `provider_id`, `weeekday`, `created_at`, `updated_at`) VALUES
(407, 408, 1, '2023-12-16 09:08:51', NULL),
(408, 408, 2, '2023-12-16 09:08:51', NULL),
(409, 408, 3, '2023-12-16 09:08:51', NULL),
(410, 408, 4, '2023-12-16 09:08:51', NULL),
(411, 408, 5, '2023-12-16 09:08:51', NULL),
(412, 408, 6, '2023-12-16 09:08:51', NULL),
(413, 408, 7, '2023-12-16 09:08:51', NULL),
(414, 416, 1, '2023-12-23 14:56:10', NULL),
(415, 416, 2, '2023-12-23 14:56:10', NULL),
(416, 416, 3, '2023-12-23 14:56:10', NULL),
(417, 416, 4, '2023-12-23 14:56:10', NULL),
(418, 416, 5, '2023-12-23 14:56:10', NULL),
(419, 416, 6, '2023-12-23 14:56:10', NULL),
(420, 416, 7, '2023-12-23 14:56:10', NULL),
(421, 417, 1, '2023-12-23 15:00:05', NULL),
(422, 417, 2, '2023-12-23 15:00:05', NULL),
(423, 417, 3, '2023-12-23 15:00:05', NULL),
(424, 417, 4, '2023-12-23 15:00:05', NULL),
(425, 417, 5, '2023-12-23 15:00:05', NULL),
(426, 417, 6, '2023-12-23 15:00:05', NULL),
(427, 417, 7, '2023-12-23 15:00:05', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jv_provider_slot_items`
--

CREATE TABLE `jv_provider_slot_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `slot_id` bigint(20) UNSIGNED DEFAULT NULL,
  `slot_time` time NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jv_services`
--

CREATE TABLE `jv_services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `service_id` varchar(200) DEFAULT NULL,
  `is_approved` tinyint(4) NOT NULL DEFAULT 0,
  `name` varchar(191) NOT NULL,
  `namefr` varchar(100) NOT NULL,
  `image` varchar(191) DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED DEFAULT NULL,
  `subcategory_id` bigint(20) DEFAULT NULL,
  `provider_id` bigint(20) UNSIGNED DEFAULT NULL,
  `price` decimal(10,2) DEFAULT 0.00,
  `price_currency` enum('CAD','INR') NOT NULL DEFAULT 'CAD',
  `type` enum('fixed','hourly') DEFAULT 'fixed' COMMENT 'fixed , hourly',
  `duration` decimal(3,1) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `description` text DEFAULT NULL,
  `descriptionfr` text NOT NULL,
  `is_featured` tinyint(4) DEFAULT 0,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_services`
--

INSERT INTO `jv_services` (`id`, `service_id`, `is_approved`, `name`, `namefr`, `image`, `category_id`, `subcategory_id`, `provider_id`, `price`, `price_currency`, `type`, `duration`, `status`, `description`, `descriptionfr`, `is_featured`, `deleted_at`, `created_at`, `updated_at`) VALUES
(91, NULL, 0, 'New Switch Service', '', '656cba4326cbd_nFdaA6ckY.jpg', 65, 63, 236, 10.00, 'CAD', 'fixed', 1.0, 1, 'New Switch Service', '', 1, '2023-12-08 19:09:30', '2023-10-19 19:26:25', '2023-12-08 19:09:30'),
(97, NULL, 0, 'Full Hair Cut', '', '65742a6726fea_SEWOF6qdIL.jpg', 70, 65, NULL, 100.00, 'CAD', 'fixed', 1.0, 1, 'full hair cut for men in $100', '', 1, NULL, '2023-12-09 08:50:48', '2023-12-09 08:51:04'),
(98, NULL, 0, 'Mens Hair Style', '', '6575e20233043_fWZay1RO8.jpg', 70, 64, NULL, 200.00, 'CAD', 'fixed', 1.0, 1, 'Mens Haircut', '', 1, NULL, '2023-12-10 16:06:29', '2023-12-10 16:06:29'),
(99, NULL, 0, 'Mens Haircut', '', '6575e5992258a_yZiS5Xd8B.jpg', 70, 64, NULL, 200.00, 'CAD', 'fixed', 1.0, 1, 'Mens Haircut', '', 1, NULL, '2023-12-10 16:21:48', '2023-12-10 16:22:17'),
(100, NULL, 0, 'New Mens Hair', '', '6575ebb222eb8_Wa8gPZ8lz.jpeg', 70, 64, NULL, 50.00, 'CAD', 'fixed', 1.0, 1, 'Brand new haircut.', '', 1, NULL, '2023-12-10 16:47:48', '2023-12-10 16:47:48'),
(101, NULL, 0, 'Repair', '', '6576139d077d8_MSktN4_ay.jpeg', 75, 66, NULL, 100.00, 'CAD', 'fixed', 2.0, 1, 'Premium repair services', '', 1, NULL, '2023-12-10 19:38:07', '2023-12-10 19:38:07'),
(102, NULL, 0, 'Women Hair Care', '', '6576227a3a981_Xbzh2O2bQ.jpg', 70, 65, NULL, 500.00, 'CAD', 'fixed', 2.0, 1, 'Women Hair Care', '', 1, NULL, '2023-12-10 20:41:32', '2023-12-10 20:41:32'),
(103, NULL, 0, 'testeng', 'test fr', '659bf222b4e91_U-s_Mpq1u.png', 70, 64, NULL, 100.00, 'CAD', 'fixed', 0.3, 1, 'test in english', 'test in french', 1, NULL, '2024-01-08 13:01:24', '2024-01-08 13:01:24');

-- --------------------------------------------------------

--
-- Table structure for table `jv_service_categories`
--

CREATE TABLE `jv_service_categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `ser_type_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `namefr` varchar(255) NOT NULL,
  `image` varchar(500) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `descriptionfr` text NOT NULL,
  `color` varchar(100) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1 COMMENT '1- Active , 0- InActive',
  `is_featured` tinyint(4) DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_service_categories`
--

INSERT INTO `jv_service_categories` (`id`, `ser_type_id`, `name`, `namefr`, `image`, `description`, `descriptionfr`, `color`, `status`, `is_featured`, `deleted_at`, `created_at`, `updated_at`) VALUES
(55, 2, 'test', '', NULL, NULL, '', '#000000', 1, 0, '2023-09-19 01:38:29', '2023-09-10 15:24:44', '2023-09-19 01:38:29'),
(56, 3, 'test 2', '', NULL, NULL, '', '#000000', 1, 0, '2023-09-19 01:41:08', '2023-09-10 15:25:10', '2023-09-19 01:41:08'),
(57, 1, 'test3', '', NULL, NULL, '', '#000000', 1, 0, '2023-09-19 01:41:05', '2023-09-10 15:26:10', '2023-09-19 01:41:05'),
(58, 2, 'Hair Salon', '', NULL, 'Hair salon', '', '#000000', 1, 1, '2023-12-04 13:06:32', '2023-09-19 01:40:57', '2023-12-04 13:06:32'),
(59, 2, 'Womens beauty services', '', NULL, NULL, '', '#000000', 1, 1, '2023-12-04 13:06:29', '2023-09-19 01:42:48', '2023-12-04 13:06:29'),
(60, 2, 'Men Body care', '', NULL, NULL, '', '#000000', 1, 1, '2023-12-04 13:06:27', '2023-09-19 01:44:03', '2023-12-04 13:06:27'),
(61, 3, 'Home Cleaning services', '', NULL, NULL, '', '#000000', 1, 0, '2023-12-04 13:06:25', '2023-09-19 02:04:22', '2023-12-04 13:06:25'),
(62, 3, 'Locksmith', '', NULL, NULL, '', '#000000', 1, 0, '2023-12-04 13:06:23', '2023-09-19 02:04:58', '2023-12-04 13:06:23'),
(63, 3, 'carpet & Upholstery Cleaning', '', NULL, NULL, '', '#000000', 1, 0, '2023-12-04 13:06:18', '2023-09-19 02:06:39', '2023-12-04 13:06:18'),
(64, 3, 'Window cleaning services', '', NULL, NULL, '', '#000000', 1, 0, '2023-12-04 13:06:16', '2023-09-19 02:07:58', '2023-12-04 13:06:16'),
(65, 1, 'Electrical services', '', '656cc1055f8f4_TSiIsAZNj.jpg', 'dev', '', '#000000', 1, 0, '2023-12-04 13:06:13', '2023-09-19 02:08:38', '2023-12-04 13:06:13'),
(66, 1, 'Plumbing services', '', NULL, NULL, '', '#000000', 1, 0, '2023-12-04 13:06:10', '2023-09-19 02:08:59', '2023-12-04 13:06:10'),
(67, 1, 'HVAC services', '', NULL, NULL, '', '#000000', 1, 0, '2023-12-04 13:06:08', '2023-09-19 02:09:19', '2023-12-04 13:06:08'),
(68, 1, 'Deck and fences', '', NULL, NULL, '', '#000000', 1, 0, '2023-12-04 13:06:06', '2023-09-19 02:09:43', '2023-12-04 13:06:06'),
(69, 1, 'Garage door opener', '', '656cba12b9a6a_6diy3-UKOK.jpg', 'desp', '', '#000000', 1, 0, '2023-12-04 13:06:03', '2023-09-19 02:10:21', '2023-12-04 13:06:03'),
(70, 2, 'Hair Salon', '', '656dd0384c078_yBLh1DqV6.png', 'Hair salons offer hair services including professional hair styling and hair texturing. Many hair salons also offer hair coloring, highlights, head and scalp treatments and formal styling.', '', NULL, 1, 1, NULL, '2023-12-04 13:10:16', '2023-12-04 13:12:26'),
(71, 1, 'Landscape', '', '656f677c6e49c_pDSDsQ0ws.jpg', 'You can now use JeVeux Services, which can connect you with local landscaping professionals. Our app allows you to schedule services, get price estimates, and even pay through the app. It\'s a convenient way to find and hire landscaping services right from your phone! ??\r\n\r\nFor the people that are looking for the process of modifying or enhancing the outdoor area of a property. JeVeux can connect you with professionals that can help you accomplish your vision in regards of your house like planting trees and flowers, installing irrigation systems, creating walkways, building retaining walls, and designing outdoor living spaces. JeVeux aims to improve the aesthetic appeal and functionality of a space while considering factors like climate, soil conditions, and client preferences. It can be done for residential, commercial, or public spaces.', '', NULL, 1, 1, NULL, '2023-12-05 18:10:06', '2023-12-05 18:10:06'),
(72, 3, 'Cleaning Services', '', '656f67aea6900_L1G5nxK6s.jpg', 'Our cleaning specialists provide services such as dusting, vacuuming, mopping floors, cleaning bathrooms, kitchens, and bedrooms, as well as other tasks like window cleaning and organizing. The prices can vary depending on the size of your home and the specific services you need. It\'s best to reach out to one of our professionals near your location in order to get a proper estimate for your home.', '', NULL, 1, 1, NULL, '2023-12-05 18:10:58', '2023-12-05 18:10:58'),
(73, 3, 'Cleaning Services', '', '656f68cf0ccdb_hHgtF9l55.jpg', 'Our cleaning specialists provide services such as dusting, vacuuming, mopping floors, cleaning bathrooms, kitchens, and bedrooms, as well as other tasks like window cleaning and organizing. The prices can vary depending on the size of your home and the specific services you need. It\'s best to reach out to one of our professionals near your location in order to get a proper estimate for your home.', '', NULL, 1, 1, '2023-12-05 18:16:00', '2023-12-05 18:15:45', '2023-12-05 18:16:00'),
(74, 3, 'Dog walking', '', '656f6e1434276_u0gmTNcZa.jpg', 'JeVeux’s dog walking service is a professional service where trained individuals take dogs for walks on behalf of their owners. It\'s a great option for busy pet owners who may not have the time or ability to walk their dogs regularly. Dog walkers typically follow specific routes, ensuring that the dogs get exercise, fresh air, and a chance to relieve themselves. They may also provide additional services like feeding, giving medication, or playing with the dogs. It\'s a convenient way to ensure that your furry friend gets the exercise and attention they need, even when you\'re unable to do it yourself.', '', NULL, 1, 1, NULL, '2023-12-05 18:38:14', '2023-12-05 18:38:14'),
(75, 1, 'Electrical services', '', '656f7a5392ebc_ll4jVd8qH.jpg', 'Contact the company to reach', '', NULL, 1, 1, NULL, '2023-12-05 19:30:31', '2023-12-05 19:30:31'),
(76, 1, 'Carpenter services', '', '657341d03049c_bo_-iFIJg.jpg', 'carpenters construct, erect, install and repair structures and fixtures made from wood and other materials. Carpenters can do anything from small repairs, such as fixing your crown molding, to bigger home projects, such as adding on new areas of your home', '', NULL, 1, 1, NULL, '2023-12-08 16:18:26', '2023-12-08 16:18:26'),
(77, 3, 'test eng', 'test fr1', '659be9cc387e5_5P56NlzqX6.png', 'testing text in english', 'testing text in french1', NULL, 1, 1, '2024-01-08 07:03:18', '2024-01-08 06:55:50', '2024-01-08 07:03:18');

-- --------------------------------------------------------

--
-- Table structure for table `jv_service_slots`
--

CREATE TABLE `jv_service_slots` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `service_id` bigint(20) UNSIGNED DEFAULT NULL,
  `weekday_number` tinyint(4) NOT NULL,
  `timing` time NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jv_service_slots`
--

INSERT INTO `jv_service_slots` (`id`, `service_id`, `weekday_number`, `timing`, `created_at`, `updated_at`) VALUES
(1, 102, 0, '07:30:00', '2023-12-12 19:26:08', '2023-12-12 19:26:08'),
(2, 102, 0, '07:45:00', '2023-12-12 19:26:25', '2023-12-12 19:26:25'),
(3, 102, 0, '09:00:00', '2023-12-12 19:26:36', '2023-12-12 19:26:36'),
(4, 102, 0, '09:30:00', '2023-12-12 19:26:50', '2023-12-12 19:26:50'),
(5, 102, 0, '10:00:00', '2023-12-12 19:27:04', '2023-12-12 19:27:04'),
(6, 102, 1, '07:30:00', '2023-12-13 16:01:12', '2023-12-13 16:01:12'),
(7, 97, 0, '07:25:00', '2023-12-15 15:55:23', '2023-12-15 15:55:23'),
(8, 97, 0, '07:25:00', '2023-12-15 15:55:40', '2023-12-15 15:55:40'),
(9, 97, 1, '07:30:00', '2023-12-15 15:55:57', '2023-12-15 15:55:57'),
(10, 101, 0, '15:00:00', '2023-12-19 07:17:39', '2023-12-19 07:17:39'),
(11, 100, 2, '17:10:00', '2023-12-19 08:40:27', '2023-12-19 08:40:27'),
(12, 98, 0, '20:30:00', '2023-12-19 08:41:28', '2023-12-19 08:41:28');

-- --------------------------------------------------------

--
-- Table structure for table `jv_service_subcategories`
--

CREATE TABLE `jv_service_subcategories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sub_image` longtext DEFAULT NULL,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `namefr` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `descriptionfr` text NOT NULL,
  `status` tinyint(4) DEFAULT 1 COMMENT '1- Active , 0- InActive',
  `is_featured` tinyint(4) DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_service_subcategories`
--

INSERT INTO `jv_service_subcategories` (`id`, `sub_image`, `category_id`, `name`, `namefr`, `description`, `descriptionfr`, `status`, `is_featured`, `deleted_at`, `created_at`, `updated_at`) VALUES
(56, 'public/sub/2023091901451605873121Hair salon1.jpg', 58, 'Mens Hair services', '', NULL, '', 1, 0, '2023-12-08 19:07:54', '2023-09-19 01:45:21', '2023-12-08 19:07:54'),
(57, 'public/sub/202309190146806575135Massage1.jpg', 58, 'Mens beauty services', '', NULL, '', 1, 0, '2023-12-08 19:07:56', '2023-09-19 01:46:20', '2023-12-08 19:07:56'),
(58, 'public/sub/2023091901471501369761Women beauty4.jpg', 59, 'Manicure', '', NULL, '', 1, 0, '2023-12-08 19:07:40', '2023-09-19 01:47:10', '2023-12-08 19:07:40'),
(59, 'public/sub/202309190147671168000Hair salon1.jpg', 59, 'Women hair services', '', NULL, '', 1, 0, '2023-12-08 19:07:45', '2023-09-19 01:47:36', '2023-12-08 19:07:45'),
(60, 'public/sub/2023091901481389594058blowout_med .png', 58, 'Kids hair services', '', NULL, '', 1, 0, '2023-12-08 19:07:58', '2023-09-19 01:48:04', '2023-12-08 19:07:58'),
(61, 'public/sub/202309190149264795035Hair salon.jpg', 59, 'Women Beauty services', '', NULL, '', 1, 0, '2023-12-08 19:07:47', '2023-09-19 01:49:25', '2023-12-08 19:07:47'),
(62, 'public/sub/2023091901521690377790Massage2.jpg', 60, 'Mens massage', '', NULL, '', 1, 0, '2023-12-08 19:07:43', '2023-09-19 01:52:14', '2023-12-08 19:07:43'),
(63, '656cba238231a_RWUyQGA6Y.jpg', 65, 'Switch', '', 'Switch', '', 1, 0, '2023-12-08 19:07:37', '2023-10-19 19:23:22', '2023-12-08 19:07:37'),
(64, '657369b3b04b8_rIAphDrLp.jpg', 70, 'Short hair', '', 'Short hair saloon', '', 1, 0, NULL, '2023-12-08 19:08:37', '2023-12-08 19:08:37'),
(65, '657369d32785a_5n5NNPFWM.jpg', 70, 'Long hair', '', 'Long hair', '', 1, 0, NULL, '2023-12-08 19:09:09', '2023-12-08 19:09:09'),
(66, '6576135e3ff76_NwJiKsZD-.jpg', 75, 'Repair', '', 'Repair Services', '', 1, 0, NULL, '2023-12-10 19:37:04', '2023-12-10 19:37:04'),
(67, '659bef2aeee51_m4rg9g5bW.png', 70, 'test eng1', 'test fr', 'testing purpose eng1', 'testing purpose  fr', 1, 0, '2024-01-08 07:19:33', '2024-01-08 07:18:45', '2024-01-08 07:19:33');

-- --------------------------------------------------------

--
-- Table structure for table `jv_service_types`
--

CREATE TABLE `jv_service_types` (
  `id` int(11) NOT NULL,
  `type_img` longtext DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` int(11) NOT NULL COMMENT '1 = Active , 0 = Inactive',
  `show_order` tinyint(4) DEFAULT 1,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `jv_service_types`
--

INSERT INTO `jv_service_types` (`id`, `type_img`, `name`, `description`, `status`, `show_order`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, NULL, 'Construction', NULL, 1, 1, NULL, NULL, NULL),
(2, NULL, 'Self Care', NULL, 1, 1, NULL, NULL, NULL),
(3, NULL, 'Home Care', NULL, 1, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jv_wishlist`
--

CREATE TABLE `jv_wishlist` (
  `id` bigint(20) NOT NULL,
  `customer_id` bigint(20) DEFAULT NULL,
  `type` enum('product','service') DEFAULT NULL,
  `ref_id` bigint(20) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jv_wishlist`
--

INSERT INTO `jv_wishlist` (`id`, `customer_id`, `type`, `ref_id`, `created_at`, `updated_at`) VALUES
(1, 370, 'service', 63, '2023-11-26 12:16:21', '2023-11-26 12:16:21'),
(2, 377, 'product', 1, '2023-12-03 08:03:55', '2023-12-03 08:03:55'),
(3, 393, 'service', 66, '2023-12-12 16:11:41', '2023-12-12 16:11:41'),
(4, 393, 'service', 65, '2023-12-12 16:27:05', '2023-12-12 16:27:05'),
(5, 393, 'product', 6, '2023-12-12 16:29:21', '2023-12-12 16:29:21');

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE `media` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(191) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL,
  `uuid` char(36) DEFAULT NULL,
  `collection_name` varchar(191) NOT NULL,
  `name` varchar(191) NOT NULL,
  `file_name` varchar(191) NOT NULL,
  `mime_type` varchar(191) DEFAULT NULL,
  `disk` varchar(191) NOT NULL,
  `conversions_disk` varchar(191) DEFAULT NULL,
  `size` bigint(20) UNSIGNED NOT NULL,
  `manipulations` varchar(191) NOT NULL,
  `custom_properties` varchar(191) NOT NULL,
  `generated_conversions` varchar(191) NOT NULL,
  `responsive_images` varchar(191) NOT NULL,
  `order_column` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `media`
--

INSERT INTO `media` (`id`, `model_type`, `model_id`, `uuid`, `collection_name`, `name`, `file_name`, `mime_type`, `disk`, `conversions_disk`, `size`, `manipulations`, `custom_properties`, `generated_conversions`, `responsive_images`, `order_column`, `created_at`, `updated_at`) VALUES
(6, 'App\\Models\\AppSetting', 1, 'd2e8d5c3-1e45-44c1-af17-05929249e86f', 'site_favicon', 'Logo PNG', 'Logo-PNG.png', 'image/png', 'public', 'public', 34892, '[]', '[]', '[]', '[]', 3, '2022-05-31 14:56:31', '2022-05-31 14:56:31'),
(9, 'App\\Models\\User', 1, '092ea80f-27d6-49db-885c-ff14b6258093', 'profile_image', 'Logo PNG', 'Logo-PNG.png', 'image/png', 'public', 'public', 34892, '[]', '[]', '[]', '[]', 5, '2022-05-31 15:50:00', '2022-05-31 15:50:00'),
(21, 'App\\Models\\SubCategory', 7, 'e7657d0e-c01e-432a-b5ff-938a57317e73', 'subcategory_image', '19', '19.png', 'image/png', 'public', 'public', 183939, '[]', '[]', '[]', '[]', 16, '2022-05-31 18:42:17', '2022-05-31 18:42:17'),
(22, 'App\\Models\\SubCategory', 8, '76c66be8-2267-43ee-8364-9444fd3fd297', 'subcategory_image', '15', '15.png', 'image/png', 'public', 'public', 202424, '[]', '[]', '[]', '[]', 17, '2022-05-31 18:42:43', '2022-05-31 18:42:43'),
(26, 'App\\Models\\SubCategory', 11, '2d97f778-68cb-419b-b5ff-b09043728872', 'subcategory_image', 'comb over short', 'comb-over-short.jpg', 'image/jpeg', 'public', 'public', 631552, '[]', '[]', '[]', '[]', 21, '2022-05-31 18:53:09', '2022-05-31 18:53:09'),
(27, 'App\\Models\\SubCategory', 12, '2715d7db-e6bf-47dc-8528-2d42658af089', 'subcategory_image', 'faux hauk long', 'faux-hauk-long.jpg', 'image/jpeg', 'public', 'public', 709289, '[]', '[]', '[]', '[]', 22, '2022-05-31 18:53:36', '2022-05-31 18:53:36'),
(28, 'App\\Models\\SubCategory', 13, '5d23093f-9109-4813-ab8f-964e218a07f6', 'subcategory_image', 'short faux hawk', 'short-faux-hawk.jpg', 'image/jpeg', 'public', 'public', 662531, '[]', '[]', '[]', '[]', 23, '2022-05-31 18:54:13', '2022-05-31 18:54:13'),
(30, 'App\\Models\\SubCategory', 15, 'd06df764-c349-4b26-b888-8a1a74d3feac', 'subcategory_image', 'med fringe', 'med-fringe.jpg', 'image/jpeg', 'public', 'public', 578637, '[]', '[]', '[]', '[]', 24, '2022-05-31 18:55:38', '2022-05-31 18:55:38'),
(31, 'App\\Models\\Service', 1, 'cadd9f96-95b2-4c7f-bb71-4027b24d07a8', 'service_attachment', '3', '3.png', 'image/png', 'public', 'public', 193503, '[]', '[]', '[]', '[]', 25, '2022-05-31 19:05:26', '2022-05-31 19:05:26'),
(32, 'App\\Models\\Service', 2, 'cd5d9078-1617-40e7-b784-718d45657578', 'service_attachment', '9', '9.png', 'image/png', 'public', 'public', 220443, '[]', '[]', '[]', '[]', 26, '2022-05-31 19:06:25', '2022-05-31 19:06:25'),
(33, 'App\\Models\\Service', 3, 'fedfc2f6-1093-4a30-8e78-d50aadaae77a', 'service_attachment', '12', '12.png', 'image/png', 'public', 'public', 194022, '[]', '[]', '[]', '[]', 27, '2022-05-31 19:07:22', '2022-05-31 19:07:22'),
(34, 'App\\Models\\Service', 4, '3064c61b-b769-4d40-a6c1-a6f5362e393a', 'service_attachment', '16', '16.png', 'image/png', 'public', 'public', 202558, '[]', '[]', '[]', '[]', 28, '2022-05-31 19:07:51', '2022-05-31 19:07:51'),
(35, 'App\\Models\\Service', 5, 'b7d1fcb0-fe36-4daa-aac9-c5aa2419bbd4', 'service_attachment', '18', '18.png', 'image/png', 'public', 'public', 213692, '[]', '[]', '[]', '[]', 29, '2022-05-31 19:08:24', '2022-05-31 19:08:24'),
(36, 'App\\Models\\Service', 7, 'e715ed06-3007-4cda-957c-2e88105f5f31', 'service_attachment', '15', '15.png', 'image/png', 'public', 'public', 202424, '[]', '[]', '[]', '[]', 30, '2022-05-31 19:09:26', '2022-05-31 19:09:26'),
(37, 'App\\Models\\Service', 8, 'e3bc1f59-d520-4a8b-b12c-a0e6d5f60c8d', 'service_attachment', '11', '11.png', 'image/png', 'public', 'public', 193221, '[]', '[]', '[]', '[]', 31, '2022-05-31 19:11:04', '2022-05-31 19:11:04'),
(38, 'App\\Models\\Service', 9, '4879cc18-7b85-43eb-a2a4-e65ffd810420', 'service_attachment', 'BEARD', 'BEARD.png', 'image/png', 'public', 'public', 144982, '[]', '[]', '[]', '[]', 32, '2022-05-31 19:11:39', '2022-05-31 19:11:39'),
(40, 'App\\Models\\SubCategory', 16, '6b1bd6e6-54f6-4f04-a099-66774bea5220', 'subcategory_image', 'WOMEN SALOON', 'WOMEN-SALOON.png', 'image/png', 'public', 'public', 397969, '[]', '[]', '[]', '[]', 34, '2022-05-31 21:23:53', '2022-05-31 21:23:53'),
(41, 'App\\Models\\SubCategory', 17, '2d431abb-0885-4dcb-b47e-20086a33fd3d', 'subcategory_image', 'HOME CLEANING', 'HOME-CLEANING.png', 'image/png', 'public', 'public', 132091, '[]', '[]', '[]', '[]', 35, '2022-05-31 21:26:26', '2022-05-31 21:26:26'),
(42, 'App\\Models\\AppSetting', 1, 'c9a1f182-0523-43c0-b99c-6ffbc21b0976', 'site_logo', 'imgonline-com-ua-resize-Hq0TprtyuH', 'imgonline-com-ua-resize-Hq0TprtyuH.png', 'image/png', 'public', 'public', 70803, '[]', '[]', '[]', '[]', 36, '2022-06-02 12:44:15', '2022-06-02 12:44:15'),
(48, 'App\\Models\\SubCategory', 22, '90fc98b6-ee5f-4555-a8bb-ff0e0152e35b', 'subcategory_image', 'BEARD', 'BEARD.png', 'image/png', 'public', 'public', 144982, '[]', '[]', '[]', '[]', 40, '2022-06-06 20:10:32', '2022-06-06 20:10:32'),
(49, 'App\\Models\\Service', 12, 'd2ace82c-61b7-494e-a905-73395c167d9c', 'service_attachment', '1', '1.png', 'image/png', 'public', 'public', 181813, '[]', '[]', '[]', '[]', 41, '2022-06-06 20:17:19', '2022-06-06 20:17:19'),
(50, 'App\\Models\\Service', 13, '9366c91c-ef45-4ecc-b00c-bfc4d6989e80', 'service_attachment', '2', '2.png', 'image/png', 'public', 'public', 182005, '[]', '[]', '[]', '[]', 42, '2022-06-06 20:19:47', '2022-06-06 20:19:47'),
(51, 'App\\Models\\Service', 14, '50f4f24c-2807-4666-8ad6-21df25a1634b', 'service_attachment', '5', '5.png', 'image/png', 'public', 'public', 180703, '[]', '[]', '[]', '[]', 43, '2022-06-06 20:21:23', '2022-06-06 20:21:23'),
(52, 'App\\Models\\Service', 15, '098d1ee0-d3c2-4f6d-8364-83e2ac65875c', 'service_attachment', '15', '15.png', 'image/png', 'public', 'public', 202424, '[]', '[]', '[]', '[]', 44, '2022-06-06 20:28:13', '2022-06-06 20:28:13'),
(53, 'App\\Models\\Service', 17, '022a8a9b-3e72-4d38-bd4b-375cad8495ac', 'service_attachment', '9', '9.png', 'image/png', 'public', 'public', 220443, '[]', '[]', '[]', '[]', 45, '2022-06-06 20:33:18', '2022-06-06 20:33:18'),
(54, 'App\\Models\\Service', 18, 'e46a024c-d168-418e-8828-92dc105ab497', 'service_attachment', '10', '10.png', 'image/png', 'public', 'public', 205942, '[]', '[]', '[]', '[]', 46, '2022-06-06 20:54:07', '2022-06-06 20:54:07'),
(55, 'App\\Models\\Service', 19, 'c074cc63-14ef-4746-9078-a26a04fad294', 'service_attachment', '16', '16.png', 'image/png', 'public', 'public', 202558, '[]', '[]', '[]', '[]', 47, '2022-06-06 20:55:44', '2022-06-06 20:55:44'),
(56, 'App\\Models\\Service', 20, '5f7ae374-de1b-4a69-8ee0-06f1eeb3ccea', 'service_attachment', '19', '19.png', 'image/png', 'public', 'public', 183939, '[]', '[]', '[]', '[]', 48, '2022-06-06 20:56:43', '2022-06-06 20:56:43'),
(57, 'App\\Models\\Service', 21, '75a0bb24-0c24-4da6-9f05-16a7899a96a4', 'service_attachment', '20', '20.png', 'image/png', 'public', 'public', 200706, '[]', '[]', '[]', '[]', 49, '2022-06-06 20:57:18', '2022-06-06 20:57:18'),
(58, 'App\\Models\\Service', 22, '5762d137-bc28-4cd2-9233-5a5106c30bcf', 'service_attachment', '7', '7.png', 'image/png', 'public', 'public', 194352, '[]', '[]', '[]', '[]', 50, '2022-06-06 20:58:21', '2022-06-06 20:58:21'),
(59, 'App\\Models\\Service', 23, 'e94ed5af-a4da-480e-a929-10c4f9d97d23', 'service_attachment', '8', '8.png', 'image/png', 'public', 'public', 187950, '[]', '[]', '[]', '[]', 51, '2022-06-06 21:08:36', '2022-06-06 21:08:36'),
(60, 'App\\Models\\Service', 24, 'cef72d91-6c6e-4ac9-865b-fde97554de9b', 'service_attachment', '17', '17.png', 'image/png', 'public', 'public', 201998, '[]', '[]', '[]', '[]', 52, '2022-06-06 21:09:58', '2022-06-06 21:09:58'),
(61, 'App\\Models\\Service', 25, 'ec5d36d8-c4ef-4e9b-b7be-e64b65f2c660', 'service_attachment', '11', '11.png', 'image/png', 'public', 'public', 193221, '[]', '[]', '[]', '[]', 53, '2022-06-06 21:10:42', '2022-06-06 21:10:42'),
(62, 'App\\Models\\Service', 26, '1cd10c1d-51a7-40e8-a2b9-8a6df3c7dbed', 'service_attachment', '12', '12.png', 'image/png', 'public', 'public', 194022, '[]', '[]', '[]', '[]', 54, '2022-06-06 21:12:08', '2022-06-06 21:12:08'),
(66, 'App\\Models\\ProviderDocument', 1, '886b91ee-8b18-4fdf-a827-458b9c2d8912', 'provider_document', 'T6', 'T6.png', 'image/png', 'public', 'public', 400409, '[]', '[]', '[]', '[]', 58, '2022-06-09 06:04:23', '2022-06-09 06:04:23'),
(67, 'App\\Models\\ProviderDocument', 2, '08ae6be8-5799-4d61-9361-59fbefbe56d8', 'provider_document', 'T6', 'T6.png', 'image/png', 'public', 'public', 400409, '[]', '[]', '[]', '[]', 59, '2022-06-09 06:04:42', '2022-06-09 06:04:42'),
(68, 'App\\Models\\ProviderDocument', 3, '62231d9b-bf28-4da4-aa05-066eec8756d5', 'provider_document', 'T2', 'T2.png', 'image/png', 'public', 'public', 417709, '[]', '[]', '[]', '[]', 60, '2022-06-09 06:05:03', '2022-06-09 06:05:03'),
(69, 'App\\Models\\ProviderDocument', 4, 'cae000bb-d4c1-4010-90cb-17af40e01d71', 'provider_document', 'T3', 'T3.png', 'image/png', 'public', 'public', 514125, '[]', '[]', '[]', '[]', 61, '2022-06-09 06:33:40', '2022-06-09 06:33:40'),
(70, 'App\\Models\\ProviderDocument', 5, '762b01cf-ff1b-435f-9f14-95a8b41d180d', 'provider_document', 'T3', 'T3.png', 'image/png', 'public', 'public', 514125, '[]', '[]', '[]', '[]', 62, '2022-06-09 06:36:21', '2022-06-09 06:36:21'),
(75, 'App\\Models\\Service', 31, 'b090d83b-9020-4596-8ebb-383ac438fb67', 'service_attachment', '55555555555', '55555555555.png', 'image/png', 'public', 'public', 1587432, '[]', '[]', '[]', '[]', 67, '2022-06-22 05:19:50', '2022-06-22 05:19:50'),
(76, 'App\\Models\\Service', 34, '18196739-d575-45e7-878e-863d788cfd30', 'service_attachment', '6666666666666', '6666666666666.png', 'image/png', 'public', 'public', 678486, '[]', '[]', '[]', '[]', 68, '2022-06-22 05:36:46', '2022-06-22 05:36:46'),
(77, 'App\\Models\\Service', 37, 'a8e390a7-dafb-4af6-a666-962d435b4e60', 'service_attachment', 'images', 'images.jpg', 'image/jpeg', 'public', 'public', 8461, '[]', '[]', '[]', '[]', 69, '2022-07-05 12:25:18', '2022-07-05 12:25:18'),
(78, 'App\\Models\\Service', 36, 'f60c410f-f1c9-4463-b41a-7be1bc1f62fd', 'service_attachment', 'cool-haircuts-for-boys-blackwater_barber-', 'cool-haircuts-for-boys-blackwater_barber-.jpg', 'image/jpeg', 'public', 'public', 73044, '[]', '[]', '[]', '[]', 70, '2022-07-05 15:25:34', '2022-07-05 15:25:34'),
(79, 'App\\Models\\Service', 35, '55f68792-cb3d-4129-9240-31373a1ed82c', 'service_attachment', 'interior-emulsions', 'interior-emulsions.png', 'image/jpeg', 'public', 'public', 13324, '[]', '[]', '[]', '[]', 71, '2022-07-05 15:30:04', '2022-07-05 15:30:04'),
(80, 'App\\Models\\Service', 34, 'cbebd43c-38fd-45f2-a53e-88c8085112fa', 'service_attachment', 'download (1)', 'download-(1).jpg', 'image/jpeg', 'public', 'public', 5161, '[]', '[]', '[]', '[]', 72, '2022-07-05 15:43:18', '2022-07-05 15:43:18'),
(81, 'App\\Models\\Service', 32, 'be25b84d-f677-4882-9028-a7854fb40eaa', 'service_attachment', 'e7216716876dcd4cc16d16cde4906f1d', 'e7216716876dcd4cc16d16cde4906f1d.jpg', 'image/jpeg', 'public', 'public', 46328, '[]', '[]', '[]', '[]', 73, '2022-07-05 15:46:03', '2022-07-05 15:46:03'),
(82, 'App\\Models\\Service', 32, 'df8a5dbc-450b-4b7c-b918-a80bca32d3c5', 'service_attachment', 'Glitz-and-glamour-coffin-nail-design', 'Glitz-and-glamour-coffin-nail-design.png', 'image/png', 'public', 'public', 104213, '[]', '[]', '[]', '[]', 74, '2022-07-05 15:46:56', '2022-07-05 15:46:56'),
(83, 'App\\Models\\Service', 31, '2cea4dd5-8375-42bb-87c3-9eb919475e14', 'service_attachment', 'download (2)', 'download-(2).jpg', 'image/jpeg', 'public', 'public', 9469, '[]', '[]', '[]', '[]', 75, '2022-07-05 15:51:12', '2022-07-05 15:51:12'),
(84, 'App\\Models\\Service', 27, 'ea9b4086-c9d9-457a-9be0-fd1efad6d3f1', 'service_attachment', '1461c3a1d553b0d243934b37a858d794', '1461c3a1d553b0d243934b37a858d794.jpg', 'image/jpeg', 'public', 'public', 73668, '[]', '[]', '[]', '[]', 76, '2022-07-05 15:56:30', '2022-07-05 15:56:30'),
(85, 'App\\Models\\Category', 11, '41a902ca-c94c-4da8-8fdf-48871ca53936', 'category_image', 'istockphoto-1200096999-612x612', 'istockphoto-1200096999-612x612.jpg', 'image/jpeg', 'public', 'public', 23558, '[]', '[]', '[]', '[]', 77, '2022-07-05 16:03:01', '2022-07-05 16:03:01'),
(86, 'App\\Models\\Category', 13, 'c531606e-e8ea-4fd3-bd82-a9223f487468', 'category_image', '360_F_335984544_im2SjLS6UfXCdOpjw8Lhp7rs7k9zCfWl', '360_F_335984544_im2SjLS6UfXCdOpjw8Lhp7rs7k9zCfWl.jpg', 'image/jpeg', 'public', 'public', 24308, '[]', '[]', '[]', '[]', 78, '2022-07-05 16:04:19', '2022-07-05 16:04:19'),
(87, 'App\\Models\\Category', 12, '0fd9cd86-0473-4c27-b1f0-e3b6aafe5288', 'category_image', 'download (3)', 'download-(3).jpg', 'image/jpeg', 'public', 'public', 7014, '[]', '[]', '[]', '[]', 79, '2022-07-05 16:05:12', '2022-07-05 16:05:12'),
(88, 'App\\Models\\Service', 38, '09a03085-bd08-439d-8d6f-1a03545e00eb', 'service_attachment', 'WhatsApp Image 2022-07-02 at 12.39.48 PM', 'WhatsApp-Image-2022-07-02-at-12.39.48-PM.jpeg', 'image/jpeg', 'public', 'public', 35783, '[]', '[]', '[]', '[]', 80, '2022-07-06 20:48:50', '2022-07-06 20:48:50'),
(89, 'App\\Models\\Service', 39, '3567ae02-f129-4a3b-8bd6-1a4ae783caf5', 'service_attachment', 'backblue', 'backblue.gif', 'image/gif', 'public', 'public', 4243, '[]', '[]', '[]', '[]', 81, '2022-07-31 11:26:54', '2022-07-31 11:26:54'),
(90, 'App\\Models\\Service', 45, '51fd7598-96d5-44ce-ac38-6cd44a176397', 'service_attachment', 'digit-number-img-1', 'digit-number-img-1.jpg', 'image/jpeg', 'public', 'public', 6648, '[]', '[]', '[]', '[]', 82, '2022-08-19 10:52:49', '2022-08-19 10:52:49'),
(91, 'App\\Models\\Service', 45, 'ba880158-2be7-4a49-af35-4496767dc05b', 'service_attachment', 'download (1)', 'download-(1).png', 'image/png', 'public', 'public', 935, '[]', '[]', '[]', '[]', 83, '2022-08-19 10:52:49', '2022-08-19 10:52:49'),
(92, 'App\\Models\\Service', 45, '09d041ff-1564-4b2e-83ba-9484be65bf6f', 'service_attachment', 'download', 'download.png', 'image/png', 'public', 'public', 1644, '[]', '[]', '[]', '[]', 84, '2022-08-19 10:52:49', '2022-08-19 10:52:49'),
(98, 'App\\Models\\Service', 46, 'c48f99a8-a4f1-440e-874d-d7a4ce790a4c', 'service_attachment', '3-blog-1', '3-blog-1.jpg', 'image/jpeg', 'public', 'public', 12797, '[]', '[]', '[]', '[]', 90, '2022-08-24 08:11:35', '2022-08-24 08:11:35'),
(99, 'App\\Models\\Service', 46, '142da40f-d1d0-403a-8e17-107f49f7791b', 'service_attachment', 'backblue', 'backblue.gif', 'image/gif', 'public', 'public', 4243, '[]', '[]', '[]', '[]', 91, '2022-08-24 08:11:35', '2022-08-24 08:11:35'),
(100, 'App\\Models\\Service', 46, '3d24cfd6-50f2-4067-ae6b-e529b127e6b8', 'service_attachment', 'digit-number-img-1', 'digit-number-img-1.jpg', 'image/jpeg', 'public', 'public', 6648, '[]', '[]', '[]', '[]', 92, '2022-08-24 08:11:35', '2022-08-24 08:11:35'),
(101, 'App\\Models\\Service', 46, '63a640f6-4a32-4529-b0fc-966c9521fad1', 'service_attachment', 'download (1)', 'download-(1).png', 'image/png', 'public', 'public', 935, '[]', '[]', '[]', '[]', 93, '2022-08-24 08:11:35', '2022-08-24 08:11:35'),
(102, 'App\\Models\\Service', 46, '7cdafca3-4671-4dc1-b458-b6fe17d41160', 'service_attachment', 'download', 'download.png', 'image/png', 'public', 'public', 1644, '[]', '[]', '[]', '[]', 94, '2022-08-24 08:11:35', '2022-08-24 08:11:35'),
(103, 'App\\Models\\Service', 47, 'dc56a589-215d-4ac9-9216-c1a078372e80', 'service_attachment', 'backblue', 'backblue.gif', 'image/gif', 'public', 'public', 4243, '[]', '[]', '[]', '[]', 95, '2022-08-24 08:12:06', '2022-08-24 08:12:06'),
(104, 'App\\Models\\Service', 47, 'fbaac6f0-51f5-459a-ab29-0f0a627724eb', 'service_attachment', 'download', 'download.png', 'image/png', 'public', 'public', 1644, '[]', '[]', '[]', '[]', 96, '2022-08-24 08:12:06', '2022-08-24 08:12:06'),
(105, 'App\\Models\\Service', 47, '59be0077-0016-4643-be45-fad423ad8871', 'service_attachment', 'logojv', 'logojv.jpeg', 'image/jpeg', 'public', 'public', 34947, '[]', '[]', '[]', '[]', 97, '2022-08-24 08:12:06', '2022-08-24 08:12:06'),
(106, 'App\\Models\\Service', 47, '6263648f-9546-40b6-9842-7a58a6e54e73', 'service_attachment', 'WhatsApp Image 2022-08-10 at 3.43.06 PM', 'WhatsApp-Image-2022-08-10-at-3.43.06-PM.jpeg', 'image/jpeg', 'public', 'public', 153356, '[]', '[]', '[]', '[]', 98, '2022-08-24 08:12:06', '2022-08-24 08:12:06'),
(107, 'App\\Models\\Service', 48, '51412a25-2ebd-48ef-b018-d1f1ceef54a5', 'service_attachment', 'download', 'download.jpg', 'image/jpeg', 'public', 'public', 8895, '[]', '[]', '[]', '[]', 99, '2022-08-24 08:13:56', '2022-08-24 08:13:56'),
(108, 'App\\Models\\Service', 48, '7be27f6a-3eb0-4365-a455-d9d778079f2b', 'service_attachment', 'hair-thumb1609162003', 'hair-thumb1609162003.jpg', 'image/jpeg', 'public', 'public', 89923, '[]', '[]', '[]', '[]', 100, '2022-08-24 08:13:56', '2022-08-24 08:13:56'),
(109, 'App\\Models\\Service', 48, '483fec0f-2521-4008-b43a-ceb2589e98d6', 'service_attachment', 'images', 'images.jpg', 'image/jpeg', 'public', 'public', 6642, '[]', '[]', '[]', '[]', 101, '2022-08-24 08:13:56', '2022-08-24 08:13:56'),
(110, 'App\\Models\\Service', 49, '36c610e4-302f-4c63-ad3d-8b8b809dae33', 'service_attachment', 'download', 'download.jpg', 'image/jpeg', 'public', 'public', 8895, '[]', '[]', '[]', '[]', 102, '2022-08-24 08:14:14', '2022-08-24 08:14:14'),
(111, 'App\\Models\\Service', 49, '516b2862-2883-40bf-aad1-869c9c7b5cfe', 'service_attachment', 'hair-thumb1609162003', 'hair-thumb1609162003.jpg', 'image/jpeg', 'public', 'public', 89923, '[]', '[]', '[]', '[]', 103, '2022-08-24 08:14:14', '2022-08-24 08:14:14'),
(112, 'App\\Models\\Service', 49, 'af3f4579-d7a6-4c69-8867-610ac61898ea', 'service_attachment', 'images', 'images.jpg', 'image/jpeg', 'public', 'public', 6642, '[]', '[]', '[]', '[]', 104, '2022-08-24 08:14:14', '2022-08-24 08:14:14'),
(113, 'App\\Models\\Service', 49, '7fe0dec1-9c56-439b-8e54-5cc741bb9290', 'service_attachment', 'WhatsApp Image 2022-08-10 at 3.43.06 PM', 'WhatsApp-Image-2022-08-10-at-3.43.06-PM.jpeg', 'image/jpeg', 'public', 'public', 153356, '[]', '[]', '[]', '[]', 105, '2022-08-24 08:14:14', '2022-08-24 08:14:14'),
(114, 'App\\Models\\Slider', 1, '0823c3c4-b001-4986-a8c3-1a4bf2eb51f8', 'slider_image', 'WhatsApp Image 2022-08-24 at 6.57.32 PM', 'WhatsApp-Image-2022-08-24-at-6.57.32-PM.jpeg', 'image/jpeg', 'public', 'public', 22091, '[]', '[]', '[]', '[]', 106, '2022-08-24 19:19:45', '2022-08-24 19:19:45'),
(115, 'App\\Models\\Slider', 2, '76e6ae99-4b93-4a1f-afa6-829e2c0778c8', 'slider_image', 'WhatsApp Image 2022-08-24 at 6.58.08 PM', 'WhatsApp-Image-2022-08-24-at-6.58.08-PM.jpeg', 'image/jpeg', 'public', 'public', 57362, '[]', '[]', '[]', '[]', 107, '2022-08-24 19:20:08', '2022-08-24 19:20:08'),
(116, 'App\\Models\\Slider', 3, '3daa66c2-bf0b-4a30-9be5-a3547ccdc15f', 'slider_image', 'WhatsApp Image 2022-08-24 at 6.58.17 PM', 'WhatsApp-Image-2022-08-24-at-6.58.17-PM.jpeg', 'image/jpeg', 'public', 'public', 49209, '[]', '[]', '[]', '[]', 108, '2022-08-24 19:20:26', '2022-08-24 19:20:26'),
(117, 'App\\Models\\Slider', 4, 'beffdd93-2683-4c96-a60b-6ce574a0d47f', 'slider_image', 'WhatsApp Image 2022-08-24 at 6.58.39 PM', 'WhatsApp-Image-2022-08-24-at-6.58.39-PM.jpeg', 'image/jpeg', 'public', 'public', 52784, '[]', '[]', '[]', '[]', 109, '2022-08-24 19:20:41', '2022-08-24 19:20:41'),
(118, 'App\\Models\\Slider', 5, 'b9220a20-0b72-4d9b-8674-af184f78344e', 'slider_image', 'WhatsApp Image 2022-08-24 at 6.58.54 PM', 'WhatsApp-Image-2022-08-24-at-6.58.54-PM.jpeg', 'image/jpeg', 'public', 'public', 37545, '[]', '[]', '[]', '[]', 110, '2022-08-24 19:20:55', '2022-08-24 19:20:55'),
(122, 'App\\Models\\Service', 58, 'a5195529-af16-4aae-a6b2-77e330e1a0a7', 'service_attachment', 'Massage-2', 'Massage-2.jpg', 'image/jpeg', 'public', 'public', 15524, '[]', '[]', '[]', '[]', 113, '2022-08-29 22:23:26', '2022-08-29 22:23:26'),
(123, 'App\\Models\\Service', 59, '5672273d-d6bf-4168-8e83-5743c02e43e0', 'service_attachment', 'massage3', 'massage3.jpg', 'image/jpeg', 'public', 'public', 5349, '[]', '[]', '[]', '[]', 114, '2022-08-29 22:25:07', '2022-08-29 22:25:07'),
(124, 'App\\Models\\Service', 60, '151b27bb-347e-418c-bc7b-40df469c0de3', 'service_attachment', 'massage4', 'massage4.jpg', 'image/jpeg', 'public', 'public', 5493, '[]', '[]', '[]', '[]', 115, '2022-08-29 22:27:30', '2022-08-29 22:27:30'),
(125, 'App\\Models\\Service', 61, '51fc4a70-7c6c-49ac-8e2a-b2e0b8f54ac3', 'service_attachment', 'Massage-2', 'Massage-2.jpg', 'image/jpeg', 'public', 'public', 15524, '[]', '[]', '[]', '[]', 116, '2022-08-29 22:33:38', '2022-08-29 22:33:38'),
(126, 'App\\Models\\Service', 62, '1fee304f-9cba-42e1-8516-2f0c301bb3a4', 'service_attachment', 'massage3', 'massage3.jpg', 'image/jpeg', 'public', 'public', 5349, '[]', '[]', '[]', '[]', 117, '2022-08-29 22:34:23', '2022-08-29 22:34:23'),
(127, 'App\\Models\\Service', 63, 'fa610cee-71d9-4c05-b0fd-d61525608cbc', 'service_attachment', 'massage4', 'massage4.jpg', 'image/jpeg', 'public', 'public', 5493, '[]', '[]', '[]', '[]', 118, '2022-08-29 22:35:19', '2022-08-29 22:35:19'),
(149, 'App\\Models\\Service', 64, '3a5124e0-c664-44af-8056-2002631a0ae1', 'service_attachment', 'test', 'test.png', 'image/png', 'public', 'public', 73963, '[]', '[]', '[]', '[]', 119, '2022-09-19 20:21:36', '2022-09-19 20:21:36'),
(150, 'App\\Models\\Service', 67, '18af5375-d11d-47a7-b6f4-6d56d30e5e1f', 'service_attachment', 'test', 'test.png', 'image/png', 'public', 'public', 73963, '[]', '[]', '[]', '[]', 120, '2022-09-19 20:23:19', '2022-09-19 20:23:19'),
(155, 'App\\Models\\Service', 66, '5ffb0bad-aa2e-4f73-86b9-d5a80feb94b7', 'service_attachment', 'test', 'test.jpeg', 'image/jpeg', 'public', 'public', 43460, '[]', '[]', '[]', '[]', 121, '2022-09-20 04:12:26', '2022-09-20 04:12:26'),
(156, 'App\\Models\\Service', 68, 'a3fa8113-5886-4365-8262-b4e07b05eb38', 'service_attachment', 'image', 'image.jpg', 'image/jpeg', 'public', 'public', 1468209, '[]', '[]', '[]', '[]', 122, '2022-09-20 04:16:36', '2022-09-20 04:16:36'),
(157, 'App\\Models\\Service', 80, '0796556e-8758-45d4-b5f9-381fa5717fae', 'service_attachment', 'test', 'test.jpeg', 'image/jpeg', 'public', 'public', 43460, '[]', '[]', '[]', '[]', 123, '2022-09-25 18:26:24', '2022-09-25 18:26:24'),
(158, 'App\\Models\\Service', 79, 'b2db01a3-593c-465e-af19-6a130a9eb2f8', 'service_attachment', 'test', 'test.jpeg', 'image/jpeg', 'public', 'public', 43460, '[]', '[]', '[]', '[]', 124, '2022-09-25 18:39:16', '2022-09-25 18:39:16'),
(159, 'App\\Models\\Service', 65, '887e9c54-8b1f-404b-abb3-672680dd1db5', 'service_attachment', 'D61E3765-B056-4FC3-8204-C99FAF6AE806', 'D61E3765-B056-4FC3-8204-C99FAF6AE806.jpeg', 'image/jpeg', 'public', 'public', 719932, '[]', '[]', '[]', '[]', 125, '2022-09-29 03:08:22', '2022-09-29 03:08:22'),
(160, 'App\\Models\\Service', 69, '1f332ac1-fc0e-4a5d-b357-86ca37086c01', 'service_attachment', 'C7616523-C45D-4BD7-8863-8F7A46131334', 'C7616523-C45D-4BD7-8863-8F7A46131334.jpeg', 'image/jpeg', 'public', 'public', 241269, '[]', '[]', '[]', '[]', 126, '2022-09-29 03:09:24', '2022-09-29 03:09:24'),
(161, 'App\\Models\\Service', 71, '7039fc06-bfda-4110-acfc-98a0a195e76c', 'service_attachment', '22783848-018C-4B73-B702-D44CD065758F', '22783848-018C-4B73-B702-D44CD065758F.jpeg', 'image/jpeg', 'public', 'public', 241269, '[]', '[]', '[]', '[]', 127, '2022-09-29 03:09:42', '2022-09-29 03:09:42'),
(162, 'App\\Models\\Category', 55, '8e74bd63-b872-46a7-a9de-87e8e183a0f0', 'category_image', 'img1', 'img1.jpg', 'image/jpeg', 'public', 'public', 137952, '[]', '[]', '[]', '[]', 128, '2023-09-10 15:24:44', '2023-09-10 15:24:44'),
(163, 'App\\Models\\Category', 56, '22cc58d5-e015-4ff8-b8af-561076559769', 'category_image', 'img2', 'img2.jpg', 'image/jpeg', 'public', 'public', 133228, '[]', '[]', '[]', '[]', 129, '2023-09-10 15:25:10', '2023-09-10 15:25:10'),
(164, 'App\\Models\\Category', 57, '4a83db1a-8052-4624-b698-535e08a3a4ae', 'category_image', 'img3', 'img3.jpg', 'image/jpeg', 'public', 'public', 78614, '[]', '[]', '[]', '[]', 130, '2023-09-10 15:26:10', '2023-09-10 15:26:10'),
(166, 'App\\Models\\Category', 59, '270efb05-4dba-4add-bb70-153a79a6906b', 'category_image', 'Women beauty3', 'Women-beauty3.jpg', 'image/jpeg', 'public', 'public', 235853, '[]', '[]', '[]', '[]', 132, '2023-09-19 01:42:48', '2023-09-19 01:42:48'),
(167, 'App\\Models\\Category', 60, '84e70a21-c447-46cf-8a5e-3d2388d1386a', 'category_image', 'Massage2', 'Massage2.jpg', 'image/jpeg', 'public', 'public', 127409, '[]', '[]', '[]', '[]', 133, '2023-09-19 01:44:03', '2023-09-19 01:44:03'),
(168, 'App\\Models\\Category', 58, '165a662f-a272-4daf-b73d-a11f1e2f91a8', 'category_image', 'Hair salon2', 'Hair-salon2.jpg', 'image/jpeg', 'public', 'public', 1464294, '[]', '[]', '[]', '[]', 134, '2023-09-19 01:44:25', '2023-09-19 01:44:25'),
(169, 'App\\Models\\Service', 82, '2a851140-eb4d-4e8d-ad02-7fc30dcb5e45', 'service_attachment', 'blowout_short', 'blowout_short.png', 'image/png', 'public', 'public', 184286, '[]', '[]', '[]', '[]', 135, '2023-09-19 01:53:15', '2023-09-19 01:53:15'),
(170, 'App\\Models\\Service', 83, '6ee332bc-1a32-4b61-a453-a4fd3f7d0cff', 'service_attachment', 'drop fade low 1', 'drop-fade-low-1.png', 'image/png', 'public', 'public', 190920, '[]', '[]', '[]', '[]', 136, '2023-09-19 01:53:48', '2023-09-19 01:53:48'),
(171, 'App\\Models\\Service', 84, '06535ecd-c83f-400c-b40a-b8dde42938f9', 'service_attachment', 'long_faux_hawk', 'long_faux_hawk.png', 'image/png', 'public', 'public', 220443, '[]', '[]', '[]', '[]', 137, '2023-09-19 01:54:31', '2023-09-19 01:54:31'),
(172, 'App\\Models\\Service', 86, '5a7e18af-dc49-44a5-8ae2-d0a1cdd00957', 'service_attachment', 'Women beauty1', 'Women-beauty1.jpg', 'image/jpeg', 'public', 'public', 1221555, '[]', '[]', '[]', '[]', 138, '2023-09-19 01:57:01', '2023-09-19 01:57:01'),
(173, 'App\\Models\\Service', 88, '4be1c153-c23c-47c2-9695-e4a3a8edb151', 'service_attachment', 'Massage1', 'Massage1.jpg', 'image/jpeg', 'public', 'public', 1046061, '[]', '[]', '[]', '[]', 139, '2023-09-19 01:59:57', '2023-09-19 01:59:57'),
(174, 'App\\Models\\Service', 89, '0cf1605a-1847-4a6f-905b-b9750474a210', 'service_attachment', 'Women beauty4', 'Women-beauty4.jpg', 'image/jpeg', 'public', 'public', 130371, '[]', '[]', '[]', '[]', 140, '2023-09-19 02:01:55', '2023-09-19 02:01:55'),
(175, 'App\\Models\\Service', 90, '3d533b76-83b3-4266-9660-ffa458dd9148', 'service_attachment', '7637473_3714955 (1)', '7637473_3714955-(1).jpg', 'image/jpeg', 'public', 'public', 228044, '[]', '[]', '[]', '[]', 141, '2023-09-19 02:03:08', '2023-09-19 02:03:08'),
(176, 'App\\Models\\Category', 61, 'a027e810-b135-4fe0-8078-2ed9af36d670', 'category_image', '20334893_holly_jolly_dachshund', '20334893_holly_jolly_dachshund.jpg', 'image/jpeg', 'public', 'public', 1436933, '[]', '[]', '[]', '[]', 142, '2023-09-19 02:04:22', '2023-09-19 02:04:22'),
(177, 'App\\Models\\Category', 62, '3d83fe20-ce95-4abf-bf39-aede5d7a770c', 'category_image', 'Locksmith1', 'Locksmith1.jpg', 'image/jpeg', 'public', 'public', 176176, '[]', '[]', '[]', '[]', 143, '2023-09-19 02:04:58', '2023-09-19 02:04:58'),
(178, 'App\\Models\\Category', 63, 'a1c21599-bb83-441b-8a2d-b2538fd50c6d', 'category_image', 'Ceramic floor installers1', 'Ceramic-floor-installers1.jpg', 'image/jpeg', 'public', 'public', 200022, '[]', '[]', '[]', '[]', 144, '2023-09-19 02:06:39', '2023-09-19 02:06:39'),
(179, 'App\\Models\\Category', 64, '26e5f0d1-4bd1-4662-bd42-2941298aa55c', 'category_image', 'Window cleaning 1', 'Window-cleaning-1.jpg', 'image/jpeg', 'public', 'public', 1376260, '[]', '[]', '[]', '[]', 145, '2023-09-19 02:07:58', '2023-09-19 02:07:58'),
(180, 'App\\Models\\Category', 65, '506e2465-c063-4d57-88f0-39df5179def2', 'category_image', 'Electrical1', 'Electrical1.jpg', 'image/jpeg', 'public', 'public', 1718896, '[]', '[]', '[]', '[]', 146, '2023-09-19 02:08:38', '2023-09-19 02:08:38'),
(181, 'App\\Models\\Category', 66, 'e39d96ad-c90b-4df4-8d5c-d6222fb5a6a2', 'category_image', 'Plumbing1', 'Plumbing1.jpg', 'image/jpeg', 'public', 'public', 1362559, '[]', '[]', '[]', '[]', 147, '2023-09-19 02:08:59', '2023-09-19 02:08:59'),
(182, 'App\\Models\\Category', 67, '18815c00-661d-4dae-86a1-5d4c447d5ecc', 'category_image', 'HVAC1', 'HVAC1.jpg', 'image/jpeg', 'public', 'public', 1631476, '[]', '[]', '[]', '[]', 148, '2023-09-19 02:09:19', '2023-09-19 02:09:19'),
(183, 'App\\Models\\Category', 68, '209db826-26d1-41fa-b2ac-31903fbf4943', 'category_image', 'Dog walkers1', 'Dog-walkers1.jpg', 'image/jpeg', 'public', 'public', 202255, '[]', '[]', '[]', '[]', 149, '2023-09-19 02:09:43', '2023-09-19 02:09:43'),
(184, 'App\\Models\\Category', 69, '17be4c71-2a70-45e6-acf6-9c970a9ab60e', 'category_image', '24758308_in_nature_06', '24758308_in_nature_06.jpg', 'image/jpeg', 'public', 'public', 453364, '[]', '[]', '[]', '[]', 150, '2023-09-19 02:10:21', '2023-09-19 02:10:21'),
(185, 'App\\Models\\Service', 91, '6cb8217e-d1ef-43d0-beb4-dcefbb11660e', 'service_attachment', 'download', 'download.jpg', 'image/jpeg', 'public', 'public', 5055, '[]', '[]', '[]', '[]', 151, '2023-10-19 19:26:25', '2023-10-19 19:26:25');

-- --------------------------------------------------------

--
-- Table structure for table `menus`
--

CREATE TABLE `menus` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` text DEFAULT NULL,
  `nickname` text DEFAULT NULL,
  `url` text DEFAULT NULL,
  `url_params` text DEFAULT NULL,
  `icon` text DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `menu_order` bigint(20) DEFAULT NULL,
  `permission` text DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menus`
--

INSERT INTO `menus` (`id`, `title`, `nickname`, `url`, `url_params`, `icon`, `parent_id`, `menu_order`, `permission`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Dashboard', 'dashboard', 'home', NULL, '<i class=\"ri-dashboard-line\"></i>', 0, 1, NULL, 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(2, 'Category', 'category', NULL, NULL, '<i class=\"ri-shopping-basket-2-line\"></i>', 0, 2, 'category list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(3, 'Category List', 'categorylist', 'category.index', NULL, '<i class=\"ri-list-unordered\"></i>', 2, NULL, 'category list', 1, '2022-02-03 16:38:15', NULL),
(4, 'Category Add', 'categoryadd', 'category.create', NULL, '<i class=\"ri-add-box-line\"></i>', 2, NULL, 'category add', 1, '2022-02-03 16:38:15', NULL),
(5, 'Service', 'service', NULL, NULL, '<i class=\"ri-service-line\"></i>', 0, 4, 'service list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(6, 'Service List', 'servicelist', 'service.index', NULL, '<i class=\"ri-list-unordered\"></i>', 5, NULL, 'service list', 1, '2022-02-03 16:38:15', NULL),
(7, 'Service Add', 'serviceadd', 'service.create', NULL, '<i class=\"ri-add-box-line\"></i>', 5, NULL, 'service add', 1, '2022-02-03 16:38:15', NULL),
(8, 'Provider', 'provider', NULL, NULL, '<i class=\"la la-users\"></i>', 0, 8, 'provider list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(9, 'Provider List', 'providerlist', 'provider.index', NULL, '<i class=\"ri-list-unordered\"></i>', 8, NULL, 'service list', 1, '2022-02-03 16:38:15', NULL),
(10, 'Pending Provider', 'providerpending', 'provider.pending', 'pending', '<i class=\"ri-list-unordered\"></i>', 8, NULL, 'provider pending', 1, '2022-02-03 16:38:15', NULL),
(11, 'Payout History', 'providerhistory', 'providerpayout.index', NULL, '<i class=\"fas fa-exchange-alt\"></i>', 8, NULL, 'admin,provider', 1, '2022-02-03 16:38:15', NULL),
(12, 'Document', 'document', NULL, NULL, '<i class=\"ri-shopping-basket-2-line\"></i>', 0, 9, 'document list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(13, 'Document List', 'documentlist', 'document.index', NULL, '<i class=\"ri-list-unordered\"></i>', 12, NULL, 'document list', 1, '2022-02-03 16:38:15', NULL),
(14, 'Document Add', 'documentadd', 'document.create', NULL, '<i class=\"ri-add-box-line\"></i>', 12, NULL, 'document add', 1, '2022-02-03 16:38:15', NULL),
(15, 'Booking', 'booking', 'booking.index', NULL, '<i class=\"fa fa-calendar\"></i>', 0, 6, 'booking list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(16, 'Tax', 'tax', 'tax.index', NULL, '<i class=\"fas fa-percent\"></i>', 0, 13, 'admin', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(17, 'Earning', 'earning', 'earning', NULL, '<i class=\"fas fa-money-bill-alt\"></i>', 0, 10, 'admin', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(19, 'Handyman List', 'handymanlist', 'handyman.index', NULL, '<i class=\"ri-list-unordered\"></i>', 18, NULL, 'handyman list', 1, '2022-02-03 16:38:15', NULL),
(20, 'Handyman Pending List', 'handymanpending', 'handyman.pending', 'pending', '<i class=\"ri-list-unordered\"></i>', 18, NULL, 'handyman pending', 1, '2022-02-03 16:38:15', NULL),
(21, 'Users', 'users', 'user.index', NULL, '<i class=\"fa fa-users\"></i>', 0, 5, 'user list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(22, 'Coupon', 'coupon', NULL, NULL, '<i class=\"ri-coupon-fill\"></i>', 0, 14, 'coupon list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(23, 'Coupon List', 'couponlist', 'coupon.index', NULL, '<i class=\"ri-list-unordered\"></i>', 22, NULL, 'coupon list', 1, '2022-02-03 16:38:15', NULL),
(24, 'Coupon Add', 'couponadd', 'coupon.create', NULL, '<i class=\"ri-add-box-line\"></i>', 22, NULL, 'coupon add', 1, '2022-02-03 16:38:15', NULL),
(25, 'Payment', 'payment', 'payment.index', NULL, '<i class=\"ri-secure-payment-line\"></i>', 0, 7, 'payment list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(26, 'Slider', 'slider', NULL, NULL, '<i class=\"ri-slideshow-line\"></i>', 0, 15, 'slider list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(27, 'Slider List', 'sliderlist', 'slider.index', NULL, '<i class=\"ri-list-unordered\"></i>', 26, NULL, 'slider list', 1, '2022-02-03 16:38:15', NULL),
(28, 'Slider Add', 'slideradd', 'slider.index', NULL, '<i class=\"ri-add-box-line\"></i>', 26, NULL, 'slider add', 1, '2022-02-03 16:38:15', NULL),
(29, 'Account Setting', 'account_setting', NULL, NULL, '<i class=\"ri-list-settings-line\"></i>', 0, 18, 'role list,permission list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(30, 'Role List', 'rolelist', 'role.index', NULL, '<i class=\"ri-list-unordered\"></i>', 29, NULL, 'role list', 1, '2022-02-03 16:38:15', NULL),
(31, 'Permission List', 'permissionlist', 'permission.index', NULL, '<i class=\"ri-add-box-line\"></i>', 29, NULL, 'permission list', 1, '2022-02-03 16:38:15', NULL),
(32, 'Pages', 'pages', NULL, NULL, '<i class=\"ri-pages-line\"></i>', 0, 16, 'pages', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(33, 'Terms Condition', 'termscondition', 'term-condition', NULL, '<i class=\"fas fa-file-contract\"></i>', 32, NULL, 'terms condition', 1, '2022-02-03 16:38:15', NULL),
(34, 'Privacy Policy', 'privacypolicy', 'privacy-policy', NULL, '<i class=\"ri-file-shield-2-line\"></i>', 32, NULL, 'privacy policy', 1, '2022-02-03 16:38:15', NULL),
(35, 'Setting', 'setting', 'setting.index', NULL, '<i class=\"ri-settings-2-line\"></i>', 0, 17, 'system setting', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(36, 'Provider Type List', 'providertype list', 'providertype.index', NULL, '<i class=\"ri-file-list-3-line\"></i>', 8, NULL, 'providertype list', 1, '2022-02-03 16:38:15', NULL),
(37, 'Address List', 'address List', 'provideraddress.index', NULL, '<i class=\"ri-file-list-3-line\"></i>', 8, NULL, 'address list', 1, '2022-02-03 16:38:15', NULL),
(38, 'Provider Document List', 'document List', 'providerdocument.index', NULL, '<i class=\"ri-file-list-3-line\"></i>', 8, NULL, 'providerdocument list', 1, '2022-02-03 16:38:15', NULL),
(39, 'Handyman Earning', 'handyman earning', 'handymanEarning', NULL, '<i class=\"fas fa-money-bill-alt\"></i>', 18, NULL, 'provider', 1, '2022-02-03 16:38:15', NULL),
(40, 'Handyman Type List', 'handymantype list', 'handymantype.index', NULL, '<i class=\"ri-file-list-3-line\"></i>', 18, NULL, 'provider', 1, '2022-02-03 16:38:15', NULL),
(41, 'Handyman Payout List', 'handymanpayout list', 'handymanpayout.index', NULL, '<i class=\"fas fa-exchange-alt\"></i>', 18, NULL, 'handyman,provider', 1, '2022-02-03 16:38:15', NULL),
(42, 'Wallet List', 'walletlist', 'wallet.index', NULL, '<i class=\"fas fa-exchange-alt\"></i>', 8, NULL, 'admin', 1, '2022-04-01 15:38:15', NULL),
(43, 'SubCategory', 'subcategory', NULL, NULL, '<i class=\"ri-shopping-basket-2-line\"></i>', 0, 3, 'subcategory list', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21'),
(44, 'SubCategory List', 'subcategorylist', 'subcategory.index', NULL, '<i class=\"ri-list-unordered\"></i>', 43, NULL, 'subcategory list', 1, '2022-02-03 16:38:15', NULL),
(45, 'SubCategory Add', 'subcategoryadd', 'subcategory.create', NULL, '<i class=\"ri-add-box-line\"></i>', 43, NULL, 'subcategory add', 1, '2022-02-03 16:38:15', NULL),
(46, 'Plans', 'plans', 'plans.index', NULL, '<i class=\"ri-list-unordered\"></i>', 0, 12, 'admin', 1, '2022-02-03 16:38:15', '2022-06-03 17:56:21');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(191) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2021_05_29_065224_create_categories_table', 1),
(6, '2021_05_29_070033_create_services_table', 1),
(7, '2021_05_29_112557_create_bookings_table', 1),
(8, '2021_05_30_055042_create_media_table', 1),
(9, '2021_05_30_070712_create_countries_table', 1),
(10, '2021_05_30_070726_create_states_table', 1),
(11, '2021_05_30_070735_create_cities_table', 1),
(12, '2021_05_30_095337_create_booking_handyman_mappings_table', 1),
(13, '2021_06_01_050736_create_booking_ratings_table', 1),
(14, '2021_06_03_052433_create_permission_tables', 1),
(15, '2021_06_10_102714_create_provider_types_table', 1),
(16, '2021_06_24_125715_create_booking_coupon_mappings_table', 1),
(17, '2021_07_06_055059_create_booking_statuses_table', 1),
(18, '2021_07_06_093626_create_booking_activities_table', 1),
(19, '2021_07_09_074735_create_app_settings_table', 1),
(20, '2021_07_09_074743_create_settings_table', 1),
(21, '2021_07_19_100454_create_payments_table', 1),
(22, '2021_07_20_092824_create_notifications_table', 1),
(23, '2021_07_28_000004_create_coupons_table', 1),
(24, '2021_07_28_000013_create_sliders_table', 1),
(25, '2021_07_28_000017_create_coupon_service_mappings_table', 1),
(26, '2021_09_11_121648_create_user_favourite_services_table', 1),
(27, '2021_09_18_073847_add_language_option_to_app_settings_table', 1),
(28, '2021_10_01_044809_create_provider_address_mappings_table', 1),
(29, '2021_10_01_044851_create_provider_service_address_mappings_table', 1),
(30, '2021_10_05_101306_create_booking_address_mappings_table', 1),
(31, '2021_10_06_052616_alter_bookings', 1),
(32, '2021_10_06_074321_add_login_type_to_users_table', 1),
(33, '2021_10_27_052244_create_documents_table', 1),
(34, '2021_10_27_090904_create_provider_documents_table', 1),
(35, '2021_10_27_115257_create_handyman_ratings_table', 1),
(36, '2021_12_01_073610_alter_app_settings', 1),
(37, '2021_12_25_102810_create_payment_gateways_table', 1),
(38, '2022_01_10_093501_create_taxes_table', 1),
(39, '2022_01_11_051545_alter_provider_types', 1),
(40, '2022_01_12_100148_create_provider_taxes_table', 1),
(41, '2022_01_12_100212_create_provider_payouts_table', 1),
(42, '2022_01_20_091224_alter_booking_tax', 1),
(43, '2022_02_02_073806_create_menus_table', 1),
(44, '2022_02_12_064817_create_handyman_payouts_table', 1),
(45, '2022_02_14_051023_create_handyman_types_table', 1),
(46, '2022_02_14_054750_alter_users_table', 1),
(47, '2022_03_03_091112_create_service_faqs_table', 1),
(48, '2022_03_05_070357_alter_app_settings_time_zone', 1),
(49, '2022_03_10_055017_create_plans_table', 1),
(50, '2022_03_10_064650_create_provider_subscriptions_table', 1),
(51, '2022_03_10_101132_create_subscription_transactions_table', 1),
(52, '2022_03_10_101854_alter_users_provider_subscribe', 1),
(53, '2022_03_16_101916_alter_app_settings_earningtype', 1),
(54, '2022_03_30_040831_create_wallets_table', 1),
(55, '2022_03_30_043359_create_wallet_histories_table', 1),
(56, '2022_03_31_041639_create_sub_categories_table', 1),
(57, '2022_03_31_101955_alter_services_subcategory_id', 1),
(58, '2022_04_06_100943_create_service_proofs_table', 1),
(59, '2022_04_08_071126_alter_plans_table', 1),
(60, '2022_04_21_041519_create_static_data_table', 1),
(61, '2022_04_22_052403_create_plan_limits_table', 1),
(62, '2022_04_28_045146_alter_provider_subscriptions', 1),
(63, '2023_01_26_113759_create_phone_verifications_table', 2),
(64, '2023_01_26_123006_alter_user_table', 3);

-- --------------------------------------------------------

--
-- Table structure for table `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(191) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `model_has_roles`
--

CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(191) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\User', 1),
(2, 'App\\Models\\User', 2),
(3, 'App\\Models\\User', 3),
(3, 'App\\Models\\User', 34),
(3, 'App\\Models\\User', 55),
(3, 'App\\Models\\User', 59),
(3, 'App\\Models\\User', 63),
(3, 'App\\Models\\User', 66),
(3, 'App\\Models\\User', 83),
(3, 'App\\Models\\User', 84),
(3, 'App\\Models\\User', 97),
(3, 'App\\Models\\User', 99),
(3, 'App\\Models\\User', 100),
(3, 'App\\Models\\User', 105),
(3, 'App\\Models\\User', 106),
(3, 'App\\Models\\User', 107),
(3, 'App\\Models\\User', 108),
(3, 'App\\Models\\User', 109),
(3, 'App\\Models\\User', 110),
(3, 'App\\Models\\User', 114),
(3, 'App\\Models\\User', 115),
(3, 'App\\Models\\User', 118),
(3, 'App\\Models\\User', 119),
(3, 'App\\Models\\User', 122),
(3, 'App\\Models\\User', 123),
(3, 'App\\Models\\User', 124),
(4, 'App\\Models\\User', 69),
(4, 'App\\Models\\User', 70),
(4, 'App\\Models\\User', 71),
(4, 'App\\Models\\User', 74),
(4, 'App\\Models\\User', 75),
(4, 'App\\Models\\User', 76),
(4, 'App\\Models\\User', 77),
(4, 'App\\Models\\User', 78),
(4, 'App\\Models\\User', 79),
(4, 'App\\Models\\User', 80),
(4, 'App\\Models\\User', 81),
(4, 'App\\Models\\User', 82),
(4, 'App\\Models\\User', 85),
(4, 'App\\Models\\User', 86),
(4, 'App\\Models\\User', 87),
(4, 'App\\Models\\User', 88),
(4, 'App\\Models\\User', 89),
(4, 'App\\Models\\User', 90),
(4, 'App\\Models\\User', 91),
(4, 'App\\Models\\User', 92),
(4, 'App\\Models\\User', 93),
(4, 'App\\Models\\User', 94),
(4, 'App\\Models\\User', 101),
(5, 'App\\Models\\User', 5),
(5, 'App\\Models\\User', 13),
(5, 'App\\Models\\User', 20),
(5, 'App\\Models\\User', 21),
(5, 'App\\Models\\User', 56),
(5, 'App\\Models\\User', 57);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` char(36) NOT NULL,
  `type` varchar(191) NOT NULL,
  `notifiable_type` varchar(191) NOT NULL,
  `notifiable_id` bigint(20) UNSIGNED NOT NULL,
  `data` text NOT NULL,
  `read_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('03d7dd7a-e2f4-4823-9e50-df11a6ef2e14', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":6,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 03:19:34', '2022-06-08 03:19:34'),
('0580d705-8aa9-4261-b5ac-b5ca4193e8b2', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":36,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from On Going to In Progress.\"}', NULL, '2022-08-05 23:40:26', '2022-08-05 23:40:26'),
('070dea5f-ecde-45f6-ab4f-729799d98f25', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":35,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 23:37:00', '2022-08-05 23:37:00'),
('07347991-c47b-4a5a-bb2e-2c003d0d5318', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 46, '{\"id\":12,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-08 19:01:50', '2022-06-08 18:30:25', '2022-06-08 19:01:50'),
('0835f346-ea7c-439c-9f6f-f729cc9244aa', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":24,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-15 09:23:04', '2022-06-15 09:23:04'),
('0a45dd37-eeb2-49ca-8a01-a58fc7ede6c8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":1,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from On Going to In Progress.\"}', '2022-06-09 05:34:53', '2022-06-04 14:44:45', '2022-06-09 05:34:53'),
('0ba29c6d-9279-4e3c-88e3-ec1ee1d060a0', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":27,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-28 15:10:48', '2022-06-28 15:10:48'),
('0c27178a-3c16-4135-a737-aed748f1153a', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 70, '{\"id\":36,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-08-05 23:40:00', '2022-08-05 23:40:00'),
('0d32b840-a774-4186-a7b4-78c3158b766e', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 46, '{\"id\":15,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-09 05:12:05', '2022-06-09 05:12:05'),
('0e2076a7-8d6b-4613-b7a6-12405ea997bd', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 22, '{\"id\":1,\"type\":\"payment_message_status\",\"subject\":\"payment_message_status\",\"message\":\"Your payment is paid\"}', '2022-06-04 14:49:22', '2022-06-04 14:49:15', '2022-06-04 14:49:22'),
('0f7c3208-2263-4f13-9bf2-8c62248173bc', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":16,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-10 17:20:17', '2022-06-09 06:11:26', '2022-06-10 17:20:17'),
('107cf13e-59b0-4c6f-8078-f3a4c098ec54', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":10,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-08 18:24:04', '2022-06-09 05:34:53'),
('11767b91-6741-4975-9ede-4a74b5990f06', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":30,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 02:41:51', '2022-08-05 02:41:51'),
('1210c943-390d-4fb3-826f-24332753b099', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 46, '{\"id\":11,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-08 18:43:43', '2022-06-08 18:31:17', '2022-06-08 18:43:43'),
('12435ea4-78f3-414b-a33d-ae98d2e7040b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":12,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-08 18:45:37', '2022-06-08 18:29:59', '2022-06-08 18:45:37'),
('1298ce36-e004-4426-bc17-3c6bb879faa8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":13,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 19:04:09', '2022-06-08 19:04:09'),
('13332c8e-6ed2-4775-9eaf-e9cd8f1c1d3e', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 55, '{\"id\":16,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from In Progress to Pending.\"}', '2022-06-12 19:18:25', '2022-06-09 20:57:52', '2022-06-12 19:18:25'),
('16b34d1d-1197-48c8-8f37-3d2dde85cfb8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":35,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-08-05 23:42:15', '2022-08-05 23:42:15'),
('17b65c7a-5c44-4848-b644-3acf8f57b1e1', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":29,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-07-05 13:15:37', '2022-07-05 13:15:37'),
('18c70e94-b939-4af0-8ba3-1c0c33cf5e6f', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 63, '{\"id\":19,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-19 22:55:03', '2022-06-15 09:24:00', '2022-06-19 22:55:03'),
('1a9803e7-0d82-454a-aa11-bb43af9d0c1b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 5, '{\"id\":23,\"type\":\"assigned_booking\",\"subject\":\"assigned_booking\",\"message\":\"Booking has been assigned to Handyman Demo \"}', NULL, '2022-06-14 22:48:12', '2022-06-14 22:48:12'),
('1b0b94e6-166f-48b3-b9e5-9e3e1b2d377e', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":27,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-28 15:10:48', '2022-06-28 15:10:48'),
('1bb411a2-fd72-435b-84d2-0dc4f8194092', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 55, '{\"id\":17,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to On Going.\"}', NULL, '2022-07-05 13:30:32', '2022-07-05 13:30:32'),
('1d5e44b1-503b-4e28-a9d6-29927b42205c', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 70, '{\"id\":36,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 23:38:01', '2022-08-05 23:38:01'),
('2397961e-d771-4ac0-93f1-309c9c6c31cb', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":14,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-09 01:06:06', '2022-06-09 01:06:06'),
('262d677c-d906-4b8d-a2d9-5942eb929d3a', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 55, '{\"id\":17,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-09 06:15:55', '2022-06-09 06:14:21', '2022-06-09 06:15:55'),
('26bbf2f3-349d-4d3a-9d75-f03c542570c0', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 22, '{\"id\":2,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from In Progress to Completed.\"}', '2022-06-06 11:10:56', '2022-06-06 11:10:47', '2022-06-06 11:10:56'),
('293b0905-ef45-40a7-b779-bec7a5f15c04', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":33,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 15:19:36', '2022-08-05 15:19:36'),
('2cc6a6eb-2902-4cbe-998a-fbb996e84a62', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":7,\"type\":\"cancel_booking\",\"subject\":\"cancel_booking\",\"message\":\"Booking has been cancelled.\"}', NULL, '2022-06-08 22:19:28', '2022-06-08 22:19:28'),
('2f65c291-7d1a-48f4-a3f3-3178b5fb194a', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":17,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-09 06:21:23', '2022-06-09 06:14:21', '2022-06-09 06:21:23'),
('30fe9b42-1b90-4a77-b988-7172324842df', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":30,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 02:41:51', '2022-08-05 02:41:51'),
('311bebbe-cd87-4525-a8c1-aa6ddb514154', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 22, '{\"id\":2,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to In Progress.\"}', '2022-06-06 11:10:56', '2022-06-06 11:08:37', '2022-06-06 11:10:56'),
('31e17a13-4e07-4633-99a5-546f7469cd23', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 5, '{\"id\":15,\"type\":\"assigned_booking\",\"subject\":\"assigned_booking\",\"message\":\"Booking has been assigned to Handyman Demo \"}', NULL, '2022-06-09 05:13:10', '2022-06-09 05:13:10'),
('32906b57-ece0-43cd-b7ca-fe22ddc84450', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 50, '{\"id\":9,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-08 18:31:29', '2022-06-08 18:31:29'),
('37c5f46d-c447-4806-91c3-fbb683c66f0c', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":23,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-14 22:48:07', '2022-06-14 22:47:16', '2022-06-14 22:48:07'),
('37e12770-ffea-4961-9620-4ec8b4bec5fc', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":23,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-14 22:47:16', '2022-06-14 22:47:16'),
('39102748-65e5-4d76-927a-8834d12e66e8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":4,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-08 03:13:09', '2022-06-09 05:34:53'),
('3949f675-ba4d-415d-b2c8-045e7438810d', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":7,\"type\":\"cancel_booking\",\"subject\":\"cancel_booking\",\"message\":\"Booking has been cancelled.\"}', '2022-06-09 05:34:53', '2022-06-08 22:19:28', '2022-06-09 05:34:53'),
('3bbe7fda-c804-4e30-af4b-62f05be0c582', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 55, '{\"id\":16,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to In Progress.\"}', '2022-06-12 19:18:25', '2022-06-09 20:57:35', '2022-06-12 19:18:25'),
('3e23ca08-e503-4a61-8ccc-b590c8abbbb2', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":24,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-15 09:23:04', '2022-06-15 09:23:04'),
('3eaef9ab-7bc7-4591-a986-c4e03407058e', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":2,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from In Progress to Completed.\"}', NULL, '2022-06-06 11:10:46', '2022-06-06 11:10:46'),
('4182925a-1c5b-43ed-bb06-94bc5c4a3435', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 70, '{\"id\":32,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 03:09:26', '2022-08-05 03:09:26'),
('45330a41-812b-400e-ba89-921fdb100ee8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":47,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-09-04 06:31:00', '2022-09-04 06:31:00'),
('4540d155-642c-4bb6-b8ce-30059baa6f26', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 55, '{\"id\":26,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-22 06:18:01', '2022-06-22 04:15:55', '2022-06-22 06:18:01'),
('45542b3a-d37d-4982-9b34-106a44d4fc98', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":46,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-29 12:45:34', '2022-08-29 12:45:34'),
('45c49bf0-01d1-4df5-bdfc-477742faf7a8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 70, '{\"id\":36,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from In Progress to Completed.\"}', NULL, '2022-08-05 23:40:35', '2022-08-05 23:40:35'),
('46c96075-4d75-4649-b93f-05fff5571bd8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":12,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-08 18:45:37', '2022-06-08 18:30:24', '2022-06-08 18:45:37'),
('48b16236-e4ee-4106-b41c-428b6c603c11', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":11,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-08 18:28:46', '2022-06-09 05:34:53'),
('48b179b8-8945-4205-9628-1b1ec4081f3b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":16,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-09 06:11:26', '2022-06-09 06:11:26'),
('4b2914a3-6056-4a08-b265-67ba91368b13', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":18,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-13 20:13:18', '2022-06-12 19:22:13', '2022-06-13 20:13:18'),
('4c5ae39a-95e9-4c35-860e-1b01beed5ce7', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":26,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-22 04:15:55', '2022-06-22 04:15:55'),
('4d1f34bf-184e-4f90-96f9-403b7a2a6186', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":5,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 03:13:59', '2022-06-08 03:13:59'),
('4d64e753-390b-4a3e-904e-c7006037839d', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":14,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-09 01:06:06', '2022-06-09 05:34:53'),
('4eff1cf8-b9d5-4b80-bd10-a61aca2bfe67', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 46, '{\"id\":7,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-08 22:19:13', '2022-06-08 03:33:13', '2022-06-08 22:19:13'),
('4f1516f0-d604-48a0-a280-f1fe9b6a95e9', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":1,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from On Going to In Progress.\"}', NULL, '2022-06-04 14:44:45', '2022-06-04 14:44:45'),
('4f63d179-0673-4d6f-bc04-82268bb6879b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":11,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-09 05:34:53', '2022-06-08 18:31:17', '2022-06-09 05:34:53'),
('5148685d-78db-4230-bca7-5663737b1121', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 58, '{\"id\":29,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-07-05 13:31:31', '2022-07-05 13:31:31'),
('5580e111-e704-40e1-adeb-c9d2f5c2fd6e', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 70, '{\"id\":28,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-07-05 12:27:36', '2022-07-05 12:27:36'),
('5c529d9f-dd05-4707-b9d3-183436038520', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":1,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-04 14:40:24', '2022-06-04 14:40:24'),
('5c755a12-fbe1-4ab6-9938-1d979e29b401', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":21,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-13 21:48:07', '2022-06-13 21:48:07'),
('5e3b7732-4a55-47f8-9ea2-29bd4f0809e2', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 55, '{\"id\":23,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-14 22:48:46', '2022-06-14 22:47:34', '2022-06-14 22:48:46'),
('5e874f3a-394b-42ec-9914-7c4b39b5977f', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 54, '{\"id\":34,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 15:22:09', '2022-08-05 15:22:09'),
('5fa2332b-3240-4b73-abef-dd4a9dc4e861', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 70, '{\"id\":36,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from On Going to In Progress.\"}', NULL, '2022-08-05 23:40:27', '2022-08-05 23:40:27'),
('62ed092d-dc8d-4bef-946f-f8d1765b43cd', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 46, '{\"id\":13,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-08 19:06:23', '2022-06-08 19:04:44', '2022-06-08 19:06:23'),
('634798f3-67b8-4390-a5ac-47adcc0c8a48', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":32,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 03:09:26', '2022-08-05 03:09:26'),
('6646a5e5-9f2e-43a6-9dac-c654d47d7f53', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":2,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to In Progress.\"}', NULL, '2022-06-06 11:08:37', '2022-06-06 11:08:37'),
('6704caa0-5457-4ac7-b2ea-df81f5f11109', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":20,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-13 21:39:39', '2022-06-13 21:39:39'),
('6a556cb6-c0ff-4f2e-8bd9-348322356ff7', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":26,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-17 04:22:25', '2022-06-17 04:22:25'),
('6bd1ffcf-ba73-4b4b-9f8a-82c8510c0dde', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":36,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-08-05 23:40:00', '2022-08-05 23:40:00'),
('6ca57e1f-58ab-4306-aee1-cc2d92e4e839', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":15,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:13:02', '2022-06-09 05:11:35', '2022-06-09 05:13:02'),
('6d9413a8-956b-4141-be15-896ae75e404b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 5, '{\"id\":13,\"type\":\"assigned_booking\",\"subject\":\"assigned_booking\",\"message\":\"Booking has been assigned to Handyman Demo \"}', NULL, '2022-06-08 19:05:26', '2022-06-08 19:05:26'),
('7131e063-7181-4e57-91b2-39cf003c7299', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 70, '{\"id\":36,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to On Going.\"}', NULL, '2022-08-05 23:40:06', '2022-08-05 23:40:06'),
('7448b7f6-97c7-4a36-b428-fb24966eac14', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":21,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-13 21:48:07', '2022-06-13 21:48:07'),
('75fe5383-500f-47d8-95c1-68f9c3500e77', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":13,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-08 19:04:09', '2022-06-09 05:34:53'),
('769cea06-4169-467f-a0c1-ceebc334eea8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 5, '{\"id\":12,\"type\":\"cancel_booking\",\"subject\":\"cancel_booking\",\"message\":\"Booking has been cancelled.\"}', NULL, '2022-06-08 18:49:25', '2022-06-08 18:49:25'),
('76d4a80d-9ec5-4248-b83b-ea05a3b2f04c', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":7,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-09 05:34:53', '2022-06-08 03:33:12', '2022-06-09 05:34:53'),
('785e2cc3-16d8-4fb0-a770-53cb6e2c0fa5', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":3,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-06 12:51:47', '2022-06-06 12:27:06', '2022-06-06 12:51:47'),
('7bc1435e-7e8d-499c-ac5b-9836204c0f3c', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 22, '{\"id\":1,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to On Going.\"}', '2022-06-04 14:44:38', '2022-06-04 14:44:21', '2022-06-04 14:44:38'),
('7d565aac-c0c0-4e92-b560-56be402b9074', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":13,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-09 05:34:53', '2022-06-08 19:04:43', '2022-06-09 05:34:53'),
('7d9f8952-fce3-4be6-a078-a057b10c950c', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":16,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from In Progress to Pending.\"}', NULL, '2022-06-09 20:57:51', '2022-06-09 20:57:51'),
('7dea0eb4-721e-4e52-b7f8-539a32b90b50', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":34,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 15:22:09', '2022-08-05 15:22:09'),
('7f59b82b-d8c4-4b2a-8470-e41c527e2e8c', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":17,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 06:21:23', '2022-06-09 06:13:24', '2022-06-09 06:21:23'),
('86374147-e18d-4046-9051-8f177ef85492', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":22,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-14 05:55:24', '2022-06-14 05:55:24'),
('86c94f50-04ec-4ac1-945e-da4d3a3e4abf', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 5, '{\"id\":22,\"type\":\"assigned_booking\",\"subject\":\"assigned_booking\",\"message\":\"Booking has been assigned to Handyman Demo \"}', NULL, '2022-06-14 06:00:39', '2022-06-14 06:00:39'),
('86fb8ac8-091c-4458-9bf3-f11052f81020', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":3,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-06 12:27:29', '2022-06-06 12:27:29'),
('89f295b5-ae5e-49c6-9bf0-2c4e59e2628b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":2,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-06 11:07:19', '2022-06-09 05:34:53'),
('8a235e95-e88c-4669-85d6-8216ffdef63b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":12,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 18:29:59', '2022-06-08 18:29:59'),
('8cca4f7c-d47a-4652-9874-7b5ff08c1f18', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 63, '{\"id\":21,\"type\":\"payment_message_status\",\"subject\":\"payment_message_status\",\"message\":\"Your payment is pending\"}', '2022-08-01 15:15:32', '2022-08-01 11:15:31', '2022-08-01 15:15:32'),
('90cd1131-93f4-4a20-800d-37a2c1d6803a', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":15,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-09 05:11:35', '2022-06-09 05:11:35'),
('924c3785-ac4f-4370-83b0-ef01353c0c3e', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":21,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-13 23:41:30', '2022-06-13 23:41:30'),
('93bc476a-f283-4c05-893d-9e845c9d786b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":4,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 03:13:09', '2022-06-08 03:13:09'),
('94d53669-771f-4f3f-b1a3-84763c4ab4dc', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 22, '{\"id\":3,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-06 12:28:38', '2022-06-06 12:27:29', '2022-06-06 12:28:38'),
('9784696e-fefb-4336-b8c7-2561bbdb35d9', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":21,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to On Going.\"}', NULL, '2022-08-01 11:15:30', '2022-08-01 11:15:30'),
('991b7c93-e745-43ec-9102-1e253dfb08d8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":31,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 02:58:12', '2022-08-05 02:58:12'),
('99b72af9-4b8b-42b5-aaba-1e5d81f35f78', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":11,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 18:28:46', '2022-06-08 18:28:46'),
('9fc6fa15-21f9-412b-8db3-0f3a378b80a6', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":36,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to On Going.\"}', NULL, '2022-08-05 23:40:05', '2022-08-05 23:40:05'),
('a064ebe5-2b0d-4ac8-a3d4-1258e66ff0e8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":31,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 02:58:12', '2022-08-05 02:58:12'),
('a08bd19f-0faa-4282-b5b4-c6c747f3c9cb', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":1,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from In Progress to Completed.\"}', NULL, '2022-06-04 14:45:42', '2022-06-04 14:45:42'),
('a1213063-775c-4504-b110-d4678a22dc95', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 5, '{\"id\":17,\"type\":\"assigned_booking\",\"subject\":\"assigned_booking\",\"message\":\"Booking has been assigned to Handyman Demo \"}', NULL, '2022-06-09 06:21:29', '2022-06-09 06:21:29'),
('a2125b7c-7af2-492b-a4d8-77e922add37b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":44,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-28 06:20:27', '2022-08-28 06:20:27'),
('a46503d5-dcb2-458b-ae71-701d6986b9cb', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 83, '{\"id\":29,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-07-05 13:31:31', '2022-07-05 13:31:31'),
('a4a51037-1af6-4115-a2ed-6fc140b69b69', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":5,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-08 03:13:59', '2022-06-09 05:34:53'),
('a4ef6150-927b-4f8a-a8c0-5fa32454cdda', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 22, '{\"id\":2,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-06 11:10:56', '2022-06-06 11:07:48', '2022-06-06 11:10:56'),
('a649314d-758c-4aaa-a848-297f93a4244a', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 46, '{\"id\":12,\"type\":\"cancel_booking\",\"subject\":\"cancel_booking\",\"message\":\"Booking has been cancelled.\"}', '2022-06-08 19:01:50', '2022-06-08 18:49:25', '2022-06-08 19:01:50'),
('a6c7c721-8282-4364-8c29-435204a90922', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 22, '{\"id\":3,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to Completed.\"}', '2022-06-06 12:28:38', '2022-06-06 12:28:31', '2022-06-06 12:28:38'),
('a6e6bd9c-07d4-45f1-acec-de26489b772c', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 5, '{\"id\":17,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to On Going.\"}', NULL, '2022-07-05 13:30:31', '2022-07-05 13:30:31'),
('a84eceed-29af-4f83-a718-acbe89c7e277', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":8,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 03:36:16', '2022-06-08 03:36:16'),
('a8fced00-5b71-4e19-a23c-e1af8598d953', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":18,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-12 19:22:13', '2022-06-12 19:22:13'),
('abfce851-77ba-48e2-96d8-b7755411a3ba', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":19,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-13 21:36:42', '2022-06-13 21:36:42'),
('acaf8902-1585-4897-9ac6-499f26ea1ec4', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":44,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-28 06:20:27', '2022-08-28 06:20:27'),
('ad6c79ad-5194-4fa0-b05e-2e0b57dc5d7e', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":26,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-17 04:22:25', '2022-06-17 04:22:25'),
('aefd4a9e-3127-47ae-a861-55afab114ddf', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":16,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-12 07:50:28', '2022-06-12 07:50:28'),
('afc1cc62-7654-49a7-b58c-ca635fde448d', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 63, '{\"id\":20,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-21 10:21:41', '2022-06-14 23:11:37', '2022-06-21 10:21:41'),
('b17daf6a-3d99-4f39-847c-7cbdaca16cb9', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":2,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-06 11:07:19', '2022-06-06 11:07:19'),
('b75430c6-a8da-4c57-9332-5071c68fe1aa', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":22,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-14 06:00:34', '2022-06-14 05:55:24', '2022-06-14 06:00:34'),
('b921dc96-fad5-451e-994d-acf239dfbcc3', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":22,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-14 06:00:34', '2022-06-14 05:58:44', '2022-06-14 06:00:34'),
('b96ded67-56e0-44c0-965b-7db1e910d531', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":35,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-08-05 23:42:15', '2022-08-05 23:42:15'),
('bacbb29b-f130-4a9d-b1fd-83583eb691aa', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":9,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-08 18:23:26', '2022-06-09 05:34:53'),
('bb1314bd-2f61-42de-90de-e553835d82e4', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 22, '{\"id\":1,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-04 14:44:38', '2022-06-04 14:40:24', '2022-06-04 14:44:38'),
('bee957eb-b9cd-4b3a-b80e-16eb12bd9abd', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":28,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-07-05 12:27:35', '2022-07-05 12:27:35'),
('c251d534-5a67-4317-9dd7-7467e314b3ef', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":19,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-13 21:36:42', '2022-06-13 21:36:42'),
('c82a97b8-dbdf-4ff9-855a-5d319f0d1b38', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":8,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-08 03:36:16', '2022-06-09 05:34:53'),
('c9d7b3c6-32c2-4dcc-b1e2-0643c37dcfc9', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":46,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-29 12:45:34', '2022-08-29 12:45:34'),
('c9ef76e8-904c-4886-b3c8-2bd09fb8de51', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":1,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to On Going.\"}', NULL, '2022-06-04 14:44:21', '2022-06-04 14:44:21'),
('ca9e0f72-f500-4e14-974d-ed67061f7ab8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 66, '{\"id\":22,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-14 06:01:54', '2022-06-14 05:58:44', '2022-06-14 06:01:54'),
('d0ad7347-c4be-4817-b121-3e6c4a90ee6e', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":35,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 23:37:00', '2022-08-05 23:37:00'),
('d3dc362c-a117-485a-abf3-612c126acd71', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":16,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to In Progress.\"}', NULL, '2022-06-09 20:57:34', '2022-06-09 20:57:34'),
('d4652846-c6ce-4074-b572-a011c49ef3e7', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":25,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-17 04:19:56', '2022-06-17 04:19:56'),
('d64a01a2-c6ef-403e-bfee-e524a1a88be7', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":20,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-14 23:11:37', '2022-06-14 23:11:37'),
('d81a8af0-e94e-4160-b1cb-df65fb03001d', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":9,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-09 05:34:53', '2022-06-08 18:31:28', '2022-06-09 05:34:53'),
('d8a0a32c-200c-4d05-aae0-0fc5a9c9bee7', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":3,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to Completed.\"}', NULL, '2022-06-06 12:28:31', '2022-06-06 12:28:31'),
('d9e047a1-5fec-4c55-8b73-19e012186a01', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":1,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-04 14:38:59', '2022-06-04 14:38:59'),
('daa226f0-f4f3-4bb2-8cb9-e2830fc74e7b', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":23,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-14 22:48:07', '2022-06-14 22:47:34', '2022-06-14 22:48:07'),
('df1eb0c0-5eb2-48de-98d7-a5b92f03365d', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":2,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-06 11:07:47', '2022-06-06 11:07:47'),
('e0c049f5-29d3-45e4-89ff-30e6bb4d5b88', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 63, '{\"id\":21,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-13 23:42:07', '2022-06-13 23:41:30', '2022-06-13 23:42:07'),
('e38fef30-09d3-42b3-9f4a-62a223c2f27d', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":17,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to On Going.\"}', NULL, '2022-07-05 13:30:31', '2022-07-05 13:30:31'),
('e3ac5162-9795-41ec-a719-16ff88a3d987', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":1,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-04 14:39:24', '2022-06-04 14:38:59', '2022-06-04 14:39:24'),
('e6671e78-5305-4b74-adee-d6b99c60170f', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":19,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', NULL, '2022-06-15 09:23:59', '2022-06-15 09:23:59'),
('e732433b-4eac-4c35-b905-8137535169aa', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":25,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-17 04:19:56', '2022-06-17 04:19:56'),
('e7d9b199-4671-4b19-9711-c5527cb83081', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":15,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-09 05:13:02', '2022-06-09 05:12:05', '2022-06-09 05:13:02'),
('e88b55b4-8395-48c4-9e01-ae8f35692fab', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 22, '{\"id\":1,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from In Progress to Completed.\"}', '2022-06-04 14:45:49', '2022-06-04 14:45:42', '2022-06-04 14:45:49'),
('ec6a7402-68f9-48f9-916d-e45ebec66382', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":12,\"type\":\"cancel_booking\",\"subject\":\"cancel_booking\",\"message\":\"Booking has been cancelled.\"}', NULL, '2022-06-08 18:49:25', '2022-06-08 18:49:25'),
('ed30caaa-2139-4201-b3c9-ed4b478f3368', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":9,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 18:23:26', '2022-06-08 18:23:26'),
('ee0b9b11-240f-430b-9751-15762d8264b8', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":20,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-13 21:39:39', '2022-06-13 21:39:39'),
('eed3433e-01b6-4d2d-b140-230582af5794', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":6,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-08 03:19:34', '2022-06-09 05:34:53'),
('eee985ae-6413-40b3-a6f8-e07b14fd99bf', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":3,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-06 12:27:06', '2022-06-06 12:27:06'),
('f04c00f5-e128-4bfb-ac79-8a7cb0dd701e', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":21,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Accept to On Going.\"}', NULL, '2022-08-01 11:15:30', '2022-08-01 11:15:30'),
('f196ee32-ff87-4165-9828-2c1a4519d2a1', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":47,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-09-04 06:31:00', '2022-09-04 06:31:00'),
('f67f0078-fedb-4be4-a970-9431fc7e7b33', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":7,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 03:31:19', '2022-06-08 03:31:19'),
('f6908662-40e6-439e-b0e9-269b7d633244', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":17,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-09 06:13:24', '2022-06-09 06:13:24'),
('f699c2d6-9bd1-4cfc-8c78-a47a9659a7e0', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":33,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 15:19:36', '2022-08-05 15:19:36'),
('f71fd7b1-87e3-4e80-bd12-51c91838f51f', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 55, '{\"id\":16,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from Pending to Accept.\"}', '2022-06-12 19:18:25', '2022-06-12 07:50:29', '2022-06-12 19:18:25'),
('f73c9bb0-87ff-49ce-9dc8-5fa11c9717ff', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":36,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-08-05 23:38:00', '2022-08-05 23:38:00'),
('f8d2027b-cd9f-48a7-b768-3f01ff964a10', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":36,\"type\":\"update_booking_status\",\"subject\":\"update_booking_status\",\"message\":\"Booking status has been changed from In Progress to Completed.\"}', NULL, '2022-08-05 23:40:35', '2022-08-05 23:40:35'),
('f904a733-6560-4d6d-9b6e-65a5dc5d0aeb', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 5, '{\"id\":12,\"type\":\"assigned_booking\",\"subject\":\"assigned_booking\",\"message\":\"Booking has been assigned to Handyman Demo \"}', NULL, '2022-06-08 18:45:47', '2022-06-08 18:45:47'),
('f9e77152-d848-406f-b702-69e55254c2c6', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 58, '{\"id\":29,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-07-05 13:15:38', '2022-07-05 13:15:38'),
('fb73dcb5-e7fa-4ee5-a1de-127c0e54a557', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 1, '{\"id\":7,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', '2022-06-09 05:34:53', '2022-06-08 03:31:19', '2022-06-09 05:34:53'),
('fbad9078-4f93-476c-b7f8-46e8487b0e87', 'App\\Notifications\\BookingNotification', 'App\\Models\\User', 4, '{\"id\":10,\"type\":\"add_booking\",\"subject\":\"add_booking\",\"message\":\"New Booking added by customer\"}', NULL, '2022-06-08 18:24:04', '2022-06-08 18:24:04');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(191) NOT NULL,
  `token` varchar(191) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `password_resets`
--

INSERT INTO `password_resets` (`email`, `token`, `created_at`) VALUES
('kebena3@gmail.com', '$2y$10$cQ6vPaTpP9TF7/FyIB8PGeMkjJpCuKboRZjCJDEF7z0nOPqikLxDO', '2022-06-04 08:18:57'),
('alichahadi@gmail.com', '$2y$10$lfq6tN1fZCT16Zv6SsiP4u20sELl0BTcEM0hlz7n5ODgv2gPCEyzm', '2022-06-05 18:42:39'),
('s.sirajuddin92@hotmail.com', '$2y$10$3AIsjtXkmN/zXCHsCpCueOn1kP6YRbYBtWYWO4xnF2eFbVdaXCcCW', '2022-06-06 21:50:50'),
('vkota2774@gmail.com', '$2y$10$AlhinyA9BsNbnOM2waLtA.uk89T1qExqzBudhTvYOSeiRRU9gbIu.', '2022-06-08 22:12:13'),
('admin@gmail.com', '$2y$10$58sW6ZCYfxyPRNBk8kGtA.PEYvYjc7lTYYhotULTRPXSwW1qbk1dm', '2023-10-18 17:22:55');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `booking_id` bigint(20) UNSIGNED NOT NULL,
  `datetime` datetime DEFAULT NULL,
  `discount` double DEFAULT 0,
  `total_amount` double DEFAULT 0,
  `payment_type` varchar(100) NOT NULL,
  `txn_id` varchar(100) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL COMMENT 'pending, paid , failed',
  `other_transaction_detail` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment_gateways`
--

CREATE TABLE `payment_gateways` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1 COMMENT '1- Active , 0- InActive',
  `is_test` tinyint(4) DEFAULT 1 COMMENT '1- Yes , 0- No',
  `value` text DEFAULT NULL,
  `live_value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `payment_gateways`
--

INSERT INTO `payment_gateways` (`id`, `title`, `type`, `status`, `is_test`, `value`, `live_value`, `created_at`, `updated_at`) VALUES
(1, 'Cash on Delivery', 'cash', 1, 0, NULL, NULL, '2022-05-31 15:48:32', '2022-05-31 15:48:32'),
(2, 'Stripe', 'stripe', 1, 1, '{\"stripe_url\":\"https:\\/\\/stripe.com\\/en-in\",\"stripe_key\":\"pk_test_51KrOSQCuldPGQCPaZ43oaNvvTLQpvU2MHWd4EforE2eH0tIEyT6WJPxGDJzeRd9caPPeNJcambmjbmNdhqON2d7b00eApiWfUZ\",\"stripe_publickey\":\"sk_test_51KrOSQCuldPGQCPaZgcH0VWZByd63Ye6NEtOrRRX9S0QnqLdRr1JN4saqfsieYwlrGm1o1sy2v2GSMYbo8mt6UHD00p2NHqNXJ\"}', '{\"stripe_url\":\"https:\\/\\/stripe.com\\/en-in\",\"stripe_key\":\"sk_test_51KrOSQCuldPGQCPaZgcH0VWZByd63Ye6NEtOrRRX9S0QnqLdRr1JN4saqfsieYwlrGm1o1sy2v2GSMYbo8mt6UHD00p2NHqNXJ\",\"stripe_publickey\":\"pk_test_51KrOSQCuldPGQCPaZ43oaNvvTLQpvU2MHWd4EforE2eH0tIEyT6WJPxGDJzeRd9caPPeNJcambmjbmNdhqON2d7b00eApiWfUZ\"}', '2022-06-03 16:47:16', '2022-06-06 13:02:01'),
(3, 'Razorpay', 'razorPay', 1, 0, NULL, '{\"razor_url\":\"https:\\/\\/razorpay.com\\/\",\"razor_key\":\"rzp_live_O3IRjaCmXBKDua\",\"razor_secret\":\"uaoxsFXLyGQ9N0sqczuoANLh\"}', '2022-06-06 11:17:37', '2022-06-06 11:17:37');

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `guard_name` varchar(191) NOT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `guard_name`, `parent_id`, `created_at`, `updated_at`) VALUES
(1, 'role', 'web', NULL, '2021-06-04 10:06:03', '2021-06-04 10:06:03'),
(2, 'role add', 'web', 1, '2021-06-04 10:58:07', '2021-06-04 10:58:07'),
(3, 'role list', 'web', 1, '2021-06-04 10:58:22', '2021-06-04 10:58:22'),
(4, 'permission', 'web', NULL, '2021-06-04 10:58:47', '2021-06-04 10:58:47'),
(5, 'permission add', 'web', 4, '2021-06-04 10:58:59', '2021-06-04 10:58:59'),
(6, 'permission list', 'web', 4, '2021-06-04 10:59:54', '2021-06-04 10:59:54'),
(7, 'category', 'web', NULL, '2021-06-08 07:57:14', '2021-06-08 07:57:14'),
(8, 'category list', 'web', 7, '2021-06-08 07:57:27', '2021-06-08 07:57:27'),
(9, 'category add', 'web', 7, '2021-06-08 07:57:39', '2021-06-08 07:57:39'),
(10, 'category edit', 'web', 7, '2021-06-08 08:11:52', '2021-06-08 08:11:52'),
(11, 'category delete', 'web', 7, '2021-06-08 08:12:03', '2021-06-08 08:12:03'),
(12, 'service', 'web', NULL, '2021-07-13 08:17:18', '2021-07-13 08:17:18'),
(13, 'service list', 'web', 12, '2021-07-13 08:17:34', '2021-07-13 08:17:34'),
(14, 'service add', 'web', 12, '2021-07-13 08:17:48', '2021-07-13 08:17:48'),
(15, 'service edit', 'web', 12, '2021-07-13 08:18:07', '2021-07-13 08:18:07'),
(16, 'service delete', 'web', 12, '2021-07-13 08:18:22', '2021-07-13 08:18:22'),
(17, 'provider', 'web', NULL, '2021-07-13 08:57:48', '2021-07-13 08:57:48'),
(18, 'provider list', 'web', 17, '2021-07-13 08:57:59', '2021-07-13 08:57:59'),
(19, 'provider add', 'web', 17, '2021-07-13 08:58:14', '2021-07-13 08:58:14'),
(20, 'provider edit', 'web', 17, '2021-07-13 08:58:30', '2021-07-13 08:58:30'),
(21, 'provider delete', 'web', 17, '2021-07-13 08:58:46', '2021-07-13 08:58:46'),
(22, 'handyman', 'web', NULL, '2021-07-13 08:59:30', '2021-07-13 08:59:30'),
(23, 'handyman list', 'web', 22, '2021-07-13 09:00:40', '2021-07-13 09:00:40'),
(24, 'handyman add', 'web', 22, '2021-07-13 09:00:53', '2021-07-13 09:00:53'),
(25, 'handyman edit', 'web', 22, '2021-07-13 09:01:07', '2021-07-13 09:01:07'),
(26, 'handyman delete', 'web', 22, '2021-07-13 09:01:20', '2021-07-13 09:01:20'),
(27, 'booking', 'web', NULL, '2021-07-13 09:11:44', '2021-07-13 09:11:44'),
(28, 'booking list', 'web', 27, '2021-07-13 09:11:56', '2021-07-13 09:11:56'),
(29, 'booking edit', 'web', 27, '2021-07-13 09:12:05', '2021-07-13 09:12:05'),
(30, 'booking delete', 'web', 27, '2021-07-13 09:13:27', '2021-07-13 09:13:27'),
(31, 'booking view', 'web', 27, '2021-07-13 10:25:02', '2021-07-13 10:25:02'),
(32, 'payment', 'web', NULL, '2021-08-05 11:09:53', '2021-08-05 11:09:53'),
(33, 'payment list', 'web', 32, '2021-08-05 11:10:29', '2021-08-05 11:10:29'),
(34, 'user', 'web', NULL, '2021-08-05 11:12:02', '2021-08-05 11:12:02'),
(35, 'user list', 'web', 34, '2021-08-05 11:12:17', '2021-08-05 11:12:17'),
(36, 'user view', 'web', 34, '2021-08-05 11:13:56', '2021-08-05 11:13:56'),
(37, 'user delete', 'web', 34, '2021-08-05 11:14:08', '2021-08-05 11:14:08'),
(38, 'providertype', 'web', NULL, '2021-08-11 07:35:29', '2021-08-11 07:35:29'),
(39, 'providertype list', 'web', 38, '2021-08-11 07:35:42', '2021-08-11 07:35:42'),
(40, 'providertype add', 'web', 38, '2021-08-11 07:35:57', '2021-08-11 07:35:57'),
(41, 'providertype edit', 'web', 38, '2021-08-11 07:36:39', '2021-08-11 07:36:39'),
(42, 'providertype delete', 'web', 38, '2021-08-11 07:39:22', '2021-08-11 07:39:22'),
(43, 'coupon', 'web', NULL, '2021-08-11 12:10:38', '2021-08-11 12:10:38'),
(44, 'coupon list', 'web', 43, '2021-08-11 12:10:47', '2021-08-11 12:10:47'),
(45, 'coupon add', 'web', 43, '2021-08-11 12:11:02', '2021-08-11 12:11:02'),
(46, 'coupon edit', 'web', 43, '2021-08-11 12:11:17', '2021-08-11 12:11:17'),
(47, 'coupon delete', 'web', 43, '2021-08-11 12:11:27', '2021-08-11 12:11:27'),
(48, 'slider', 'web', NULL, '2021-08-12 10:38:52', '2021-08-12 10:38:52'),
(49, 'slider list', 'web', 48, '2021-08-12 10:39:05', '2021-08-12 10:39:05'),
(50, 'slider add', 'web', 48, '2021-08-12 10:39:17', '2021-08-12 10:39:17'),
(51, 'slider edit', 'web', 48, '2021-08-12 10:39:26', '2021-08-12 10:39:26'),
(52, 'slider delete', 'web', 48, '2021-08-12 10:39:37', '2021-08-12 10:39:37'),
(53, 'pending provider', 'web', 17, '2021-09-28 10:39:26', '2021-09-28 10:39:26'),
(54, 'pending handyman', 'web', 22, '2021-09-28 10:39:37', '2021-09-28 10:39:37'),
(55, 'pages', 'web', NULL, '2021-09-28 10:39:37', '2021-09-28 10:39:37'),
(56, 'terms condition', 'web', 55, '2021-09-28 10:39:37', '2021-09-28 10:39:37'),
(57, 'privacy policy', 'web', 55, '2021-09-28 10:39:37', '2021-09-28 10:39:37'),
(58, 'provider address', 'web', NULL, '2021-09-28 10:39:37', '2021-09-28 10:39:37'),
(59, 'provideraddress list', 'web', 58, '2021-09-28 10:39:37', '2021-09-28 10:39:37'),
(60, 'provideraddress add', 'web', 58, '2021-09-28 10:39:37', '2021-09-28 10:39:37'),
(61, 'provideraddress edit', 'web', 58, '2021-09-28 10:39:37', '2021-09-28 10:39:37'),
(62, 'provideraddress delete', 'web', 58, '2021-09-28 10:39:37', '2021-09-28 10:39:37'),
(63, 'document', 'web', NULL, '2021-10-27 10:00:09', '2021-10-27 10:00:09'),
(64, 'document list', 'web', 63, '2021-10-27 10:00:24', '2021-10-27 10:00:24'),
(65, 'document add', 'web', 63, '2021-10-27 10:00:38', '2021-10-27 10:00:38'),
(66, 'document edit', 'web', 63, '2021-10-27 10:00:56', '2021-10-27 10:00:56'),
(67, 'document delete', 'web', 63, '2021-10-27 10:01:11', '2021-10-27 10:01:11'),
(68, 'provider document', 'web', NULL, '2021-10-27 14:32:48', '2021-10-27 14:32:48'),
(69, 'providerdocument list', 'web', 68, '2021-10-27 14:33:05', '2021-10-27 14:33:05'),
(70, 'providerdocument add', 'web', 68, '2021-10-27 14:33:20', '2021-10-27 14:33:20'),
(71, 'providerdocument edit', 'web', 68, '2021-10-27 14:33:32', '2021-10-27 14:33:32'),
(72, 'providerdocument delete', 'web', 68, '2021-10-27 14:33:51', '2021-10-27 14:33:51'),
(73, 'provider payout', 'web', 17, '2022-01-21 09:46:07', '2022-01-21 09:46:07'),
(74, 'handyman payout', 'web', 22, '2022-02-14 09:46:07', '2022-02-14 09:46:07'),
(75, 'servicefaq', 'web', NULL, '2022-02-19 09:46:07', '2022-02-19 09:46:07'),
(76, 'servicefaq add', 'web', 75, '2022-02-19 09:46:07', '2022-02-19 09:46:07'),
(77, 'servicefaq edit', 'web', 75, '2022-02-19 09:46:07', '2022-02-19 09:46:07'),
(78, 'servicefaq delete', 'web', 75, '2022-02-19 09:46:07', '2022-02-19 09:46:07'),
(79, 'servicefaq list', 'web', 75, '2022-02-19 09:46:07', '2022-02-19 09:46:07'),
(80, 'user add', 'web', 34, '2022-02-19 09:46:07', '2022-02-19 09:46:07'),
(81, 'user edit', 'web', 34, '2022-02-19 09:46:07', '2022-02-19 09:46:07'),
(82, 'subcategory', 'web', NULL, '2022-04-01 08:46:07', '2022-04-01 08:46:07'),
(83, 'subcategory add', 'web', 82, '2022-04-01 08:46:07', '2022-04-01 08:46:07'),
(84, 'subcategory edit', 'web', 82, '2022-04-01 08:46:07', '2022-04-01 08:46:07'),
(85, 'subcategory delete', 'web', 82, '2022-04-01 08:46:07', '2022-04-01 08:46:07'),
(86, 'subcategory list', 'web', 82, '2022-04-01 08:46:07', '2022-04-01 08:46:07');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(191) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 3, 'auth_token', '0313a673a2d083c40fd758808be033537acf0525b67de10390b6adfc967ef576', '[\"*\"]', NULL, '2022-05-31 14:46:04', '2022-05-31 14:46:04'),
(2, 'App\\Models\\User', 6, 'auth_token', 'b2d6d076861287df4c9d405bffad39d3fb72b01be93c68831edcbe67522cd6b2', '[\"*\"]', NULL, '2022-05-31 14:48:48', '2022-05-31 14:48:48'),
(3, 'App\\Models\\User', 6, 'auth_token', 'fb23605e616b007b35cb69cc9862f6875d3f56d60eb4d369c3bcf338d97fbe18', '[\"*\"]', NULL, '2022-05-31 14:48:48', '2022-05-31 14:48:48'),
(4, 'App\\Models\\User', 6, 'auth_token', 'cba95c130e0d22055cd7deaa8ee4889064fcf6bbef893d2186bed7d149d70c29', '[\"*\"]', '2022-05-31 14:49:04', '2022-05-31 14:48:52', '2022-05-31 14:49:04'),
(5, 'App\\Models\\User', 6, 'auth_token', '5c0a1297622cf7730b8e038b9c9a1058ac4965b9c2e4ed0a741e35c6358e9953', '[\"*\"]', '2022-05-31 14:53:17', '2022-05-31 14:49:19', '2022-05-31 14:53:17'),
(6, 'App\\Models\\User', 10, 'auth_token', '522751f00d2be9f2f4ca12011535329d895f84041fce1a0106b05e79e7234226', '[\"*\"]', NULL, '2022-05-31 19:13:45', '2022-05-31 19:13:45'),
(7, 'App\\Models\\User', 10, 'auth_token', '763236e522c69c2f2d36fea9ea4bc6d2fbfb814b7afa108d1bf5250483e89065', '[\"*\"]', NULL, '2022-05-31 19:13:45', '2022-05-31 19:13:45'),
(8, 'App\\Models\\User', 6, 'auth_token', '626d1fd5faba3df61313d52f19b37b3506415f97b1ffa6850c3d2a9c27fdeaa6', '[\"*\"]', '2022-05-31 21:54:25', '2022-05-31 20:46:28', '2022-05-31 21:54:25'),
(9, 'App\\Models\\User', 11, 'auth_token', 'b17f913cb3e49038c281b45f935a2555427973bd70adf04ba147a15df6f9beab', '[\"*\"]', NULL, '2022-06-01 03:09:10', '2022-06-01 03:09:10'),
(10, 'App\\Models\\User', 11, 'auth_token', '285911825a2a2c47f0140b44ff39e8e764db478d47801f36f6fbb87c5f9f3ccc', '[\"*\"]', NULL, '2022-06-01 03:09:10', '2022-06-01 03:09:10'),
(11, 'App\\Models\\User', 12, 'auth_token', '3c6f207a6436db12a2c4826f65a7035a9a64eda866af9614c1b3b8d4a3b7ccce', '[\"*\"]', NULL, '2022-06-01 19:58:25', '2022-06-01 19:58:25'),
(12, 'App\\Models\\User', 12, 'auth_token', '88f0f83238d589862e6fba69071b40d83d5315de21b03f484200cfee18fa6504', '[\"*\"]', NULL, '2022-06-01 19:58:25', '2022-06-01 19:58:25'),
(13, 'App\\Models\\User', 12, 'auth_token', '58e731829c27c54b2fa4ea3c29068f748f13128ab8f9bc60c4b78800a0a5fdd8', '[\"*\"]', NULL, '2022-06-01 19:59:29', '2022-06-01 19:59:29'),
(14, 'App\\Models\\User', 12, 'auth_token', '00b1f75c654cbfe80ba97842a663a0c4f20817f851273e6f7feac700f531ae69', '[\"*\"]', NULL, '2022-06-01 19:59:35', '2022-06-01 19:59:35'),
(15, 'App\\Models\\User', 12, 'auth_token', 'd05181f0e4c22d75f7a4accf561a6f8ebfde6abf1cbd15744635bfbdfb302151', '[\"*\"]', NULL, '2022-06-01 20:00:01', '2022-06-01 20:00:01'),
(16, 'App\\Models\\User', 4, 'auth_token', '4517922bb6d24b1bce1ee1d662d616e95406dc451ab7357094deb20c3ad21915', '[\"*\"]', '2022-06-01 20:25:23', '2022-06-01 20:08:07', '2022-06-01 20:25:23'),
(17, 'App\\Models\\User', 4, 'auth_token', 'd450f9c92ab25365146b52f1a34561ae0d0833a8dd4f0890d8e4baaf451446cb', '[\"*\"]', '2022-06-01 20:38:14', '2022-06-01 20:26:41', '2022-06-01 20:38:14'),
(18, 'App\\Models\\User', 13, 'auth_token', 'e9cc2b15d1e9a66d9da1d2cdaa1972009496cc9f058c4c4c946a56a6c8fd40a4', '[\"*\"]', NULL, '2022-06-01 21:15:10', '2022-06-01 21:15:10'),
(19, 'App\\Models\\User', 13, 'auth_token', '87c49c72d9415ed81b1ef80c399d17a43e42ac7dac18e3d7413c07ba3e195e6c', '[\"*\"]', NULL, '2022-06-01 21:15:10', '2022-06-01 21:15:10'),
(20, 'App\\Models\\User', 13, 'auth_token', '20c9eec7f7e76936207be3899fa82192ce2b9c2fdba2f3a2db6d1dba4a65786f', '[\"*\"]', NULL, '2022-06-01 21:15:35', '2022-06-01 21:15:35'),
(21, 'App\\Models\\User', 13, 'auth_token', '6414494dd1d6e00ab85cdf00518d7e2c5f631067536cc77598f9e29a8bf07808', '[\"*\"]', NULL, '2022-06-01 21:15:42', '2022-06-01 21:15:42'),
(22, 'App\\Models\\User', 13, 'auth_token', '4e909210ee67306cf02a1019a852131cc0728329ac489c839b35971208dab0d4', '[\"*\"]', NULL, '2022-06-01 21:16:28', '2022-06-01 21:16:28'),
(23, 'App\\Models\\User', 14, 'auth_token', 'ffc4751bfc4749a032fb968713cb3e0903d3cf2dea877ca21e866617ab5b4c52', '[\"*\"]', NULL, '2022-06-02 06:55:47', '2022-06-02 06:55:47'),
(24, 'App\\Models\\User', 14, 'auth_token', 'b2fad0bd8cc50a00ed9e0fbbe8a1157b5aff07a7fd9805c4f6643df19335827d', '[\"*\"]', NULL, '2022-06-02 06:55:47', '2022-06-02 06:55:47'),
(25, 'App\\Models\\User', 15, 'auth_token', 'd5fdf1dcd39b7670d2f87d70b3b81a164a579a2e23e6c3eecc59b7d3fe659f19', '[\"*\"]', NULL, '2022-06-02 06:59:49', '2022-06-02 06:59:49'),
(26, 'App\\Models\\User', 15, 'auth_token', '17315ab0af2dcaa95da6a98a366f100bfeddeca241b144330cb082f5821b16c0', '[\"*\"]', NULL, '2022-06-02 06:59:49', '2022-06-02 06:59:49'),
(27, 'App\\Models\\User', 16, 'auth_token', '49636ff78c47fbfed5725687f57a6cba5475b1ff46b68e3f36392aeadfabda1d', '[\"*\"]', NULL, '2022-06-02 11:46:17', '2022-06-02 11:46:17'),
(28, 'App\\Models\\User', 16, 'auth_token', 'd080a4b97cdc655c450c59d23b6127e9813eaa6a9224c33df355202d0cec4946', '[\"*\"]', NULL, '2022-06-02 11:46:17', '2022-06-02 11:46:17'),
(29, 'App\\Models\\User', 4, 'auth_token', '1d5639682e39b763b6ee9fd663aa7647f07212f5a8b559cd8f47d1c103c66f2d', '[\"*\"]', NULL, '2022-06-02 15:53:36', '2022-06-02 15:53:36'),
(30, 'App\\Models\\User', 4, 'auth_token', '303c81dae68613938c8d7c8df6dc7b86cc757c8abab6ea1792f42ed792680ea3', '[\"*\"]', NULL, '2022-06-02 15:53:53', '2022-06-02 15:53:53'),
(31, 'App\\Models\\User', 4, 'auth_token', 'b74eaf911608db28e08dfccb6e12c11eb8556607a0ffc879619c3a8de3caa574', '[\"*\"]', NULL, '2022-06-02 15:54:11', '2022-06-02 15:54:11'),
(32, 'App\\Models\\User', 17, 'auth_token', '3d9c3d13e2385a4228131449e78651b4ea5623009ec0aa0c22a3f88b1c2eff3e', '[\"*\"]', NULL, '2022-06-02 15:55:36', '2022-06-02 15:55:36'),
(33, 'App\\Models\\User', 17, 'auth_token', 'd04d1f6220129c18616ccf30193b7ba42262c10d56f027da76720eb804d6afe4', '[\"*\"]', NULL, '2022-06-02 15:55:36', '2022-06-02 15:55:36'),
(34, 'App\\Models\\User', 12, 'auth_token', '102ba6e5488ee2c7a09dfea1256436b24cc8eddbee701184d6d541aaad0b3388', '[\"*\"]', NULL, '2022-06-02 15:58:17', '2022-06-02 15:58:17'),
(35, 'App\\Models\\User', 4, 'auth_token', 'bcabef7c17ad2a8910647cce16586c3907dfb7aa03f151638b8627a616e503f3', '[\"*\"]', NULL, '2022-06-02 16:01:29', '2022-06-02 16:01:29'),
(36, 'App\\Models\\User', 4, 'auth_token', '27e7d474136a28d4980fe6262861988b4dedfdea6ee966e8d149581e3c5a4bd0', '[\"*\"]', NULL, '2022-06-02 16:01:32', '2022-06-02 16:01:32'),
(37, 'App\\Models\\User', 4, 'auth_token', 'a8e05cfb8a2800c1d985f116a575bbdcb9df547a2acbc53fe63a8eb1e25e041f', '[\"*\"]', NULL, '2022-06-02 16:01:32', '2022-06-02 16:01:32'),
(38, 'App\\Models\\User', 4, 'auth_token', '0afd6762b1bdedaa79465f1bacdecb1ba3d3a0fb4e336d614610c8c211112d4a', '[\"*\"]', NULL, '2022-06-02 16:01:33', '2022-06-02 16:01:33'),
(39, 'App\\Models\\User', 4, 'auth_token', 'dfe46a4bd764b2dfe20003ed1b659eb60218d06c4e346abbc5adc12f5c9c141d', '[\"*\"]', NULL, '2022-06-02 16:01:33', '2022-06-02 16:01:33'),
(40, 'App\\Models\\User', 4, 'auth_token', '871d2b3b48a8bdc0ea0b3748a9305c237e35881b817e3f9a785fc6bb8ced0e9d', '[\"*\"]', NULL, '2022-06-02 16:01:33', '2022-06-02 16:01:33'),
(41, 'App\\Models\\User', 4, 'auth_token', 'beeb59973b50f3fe94f66e68d8e1bae70aa7dd1db81685ac3e11b09ca5b5d9b6', '[\"*\"]', NULL, '2022-06-02 16:01:33', '2022-06-02 16:01:33'),
(42, 'App\\Models\\User', 4, 'auth_token', 'aeba739413d239f941b4721fbd18036ec50e2184c6d265860eb6f8dbc7accdf6', '[\"*\"]', NULL, '2022-06-02 16:01:33', '2022-06-02 16:01:33'),
(43, 'App\\Models\\User', 4, 'auth_token', 'ce62d3214cc3d83df6e34a97dbdcc42c37ab21bfdec1fae37a92a219ea80a138', '[\"*\"]', NULL, '2022-06-02 16:01:33', '2022-06-02 16:01:33'),
(44, 'App\\Models\\User', 4, 'auth_token', 'd97cfdbcdd2537736d6b5c1a044ac41f412bd909392159176f719f53caf6a106', '[\"*\"]', NULL, '2022-06-02 16:01:33', '2022-06-02 16:01:33'),
(45, 'App\\Models\\User', 4, 'auth_token', '9f4251f017b568ed460cbc2863c8fc3fba7ff9858d73017bce1cd7e66f47a076', '[\"*\"]', NULL, '2022-06-02 16:01:33', '2022-06-02 16:01:33'),
(46, 'App\\Models\\User', 4, 'auth_token', 'c1ef4cb1f2bbf92a86547e4e298a5f622ea74d19a745694a02e195634a42a782', '[\"*\"]', NULL, '2022-06-02 16:01:34', '2022-06-02 16:01:34'),
(47, 'App\\Models\\User', 4, 'auth_token', '782e2ed78c7efa3f3cdb6c99ce0912083aa85965ae04b4991d05ed4dec1428a4', '[\"*\"]', NULL, '2022-06-02 16:01:34', '2022-06-02 16:01:34'),
(48, 'App\\Models\\User', 4, 'auth_token', '2eef9c8f3d414a78e8b7b2ba707a80681b8a3a3e0537c8d936e95262883e08c7', '[\"*\"]', NULL, '2022-06-02 16:01:34', '2022-06-02 16:01:34'),
(49, 'App\\Models\\User', 4, 'auth_token', 'ab08c3a97304cdfd0cbac62f7c3299c03dc40f6c3b5d27ea63c8171a3eb27f2a', '[\"*\"]', NULL, '2022-06-02 16:01:34', '2022-06-02 16:01:34'),
(50, 'App\\Models\\User', 4, 'auth_token', 'd4e9fc744c2e76a0d4c2386c84581faff071567fb74b849f150a1b83485830b2', '[\"*\"]', NULL, '2022-06-02 16:01:34', '2022-06-02 16:01:34'),
(51, 'App\\Models\\User', 4, 'auth_token', '081a619d95011bc248e849c8970481ce1aba6d9b169ddbacb0dcf741b0b68120', '[\"*\"]', NULL, '2022-06-02 16:01:34', '2022-06-02 16:01:34'),
(52, 'App\\Models\\User', 4, 'auth_token', 'ecf3a04337a2161b6369de23acc8cca58dba9e819fe0f0b0410cbcb61dec169b', '[\"*\"]', NULL, '2022-06-02 16:01:34', '2022-06-02 16:01:34'),
(53, 'App\\Models\\User', 4, 'auth_token', '324f74d98b75e009a480ff13a88544543fbec1e452d221c662e3a37a0e4bf2d0', '[\"*\"]', NULL, '2022-06-02 16:01:35', '2022-06-02 16:01:35'),
(54, 'App\\Models\\User', 4, 'auth_token', 'eda52bcf3e066aa846ae70e09ebbad02d1761d2ae551175d340a5ff014c84076', '[\"*\"]', '2022-06-02 16:05:31', '2022-06-02 16:05:03', '2022-06-02 16:05:31'),
(55, 'App\\Models\\User', 12, 'auth_token', '162c5464af1053f021b499daf1a444d5dc73de05fa58993ad2603f1f8c77fa16', '[\"*\"]', '2022-06-02 16:12:45', '2022-06-02 16:12:42', '2022-06-02 16:12:45'),
(56, 'App\\Models\\User', 12, 'auth_token', 'b34d5b09cbdc1df98b2b3c575f9cff321589f0c04daca4b05dfac0e5b0e2f515', '[\"*\"]', NULL, '2022-06-02 16:15:47', '2022-06-02 16:15:47'),
(57, 'App\\Models\\User', 12, 'auth_token', '28536c1ba5fba25d0e09486896a4c0676d5c1d24a2ebf63a3fba2ad57ce9b963', '[\"*\"]', NULL, '2022-06-02 16:15:56', '2022-06-02 16:15:56'),
(58, 'App\\Models\\User', 4, 'auth_token', '2f7fb773fc42e839ca8ba6e896c95630c608721fa7b26b4e5db1b7c71b9eec99', '[\"*\"]', NULL, '2022-06-02 16:16:26', '2022-06-02 16:16:26'),
(59, 'App\\Models\\User', 4, 'auth_token', 'd787a8604391a8dff4373216eb53a2cd073c8f042b85c88d0776666a65059305', '[\"*\"]', NULL, '2022-06-02 16:16:35', '2022-06-02 16:16:35'),
(60, 'App\\Models\\User', 4, 'auth_token', '6b8494815bee318fc5e2ca2c3a937c39e2f03daf122a683dbddb221e415ee051', '[\"*\"]', NULL, '2022-06-02 16:16:42', '2022-06-02 16:16:42'),
(61, 'App\\Models\\User', 4, 'auth_token', '81b086790671492b262e003d43c1fb95e865d97ecdcf8688cf6ca800c8340b33', '[\"*\"]', NULL, '2022-06-02 21:55:37', '2022-06-02 21:55:37'),
(62, 'App\\Models\\User', 12, 'auth_token', '538ce54bf4b18ad01d6c63d86caca9158aa09cc3355d53c3d08f24b622ca86ca', '[\"*\"]', NULL, '2022-06-02 22:06:08', '2022-06-02 22:06:08'),
(63, 'App\\Models\\User', 18, 'auth_token', 'f9e7881fe9d158b705fa20a874a499ba75c89bfb6d9d6e6941e82c930b73be87', '[\"*\"]', NULL, '2022-06-03 01:59:56', '2022-06-03 01:59:56'),
(64, 'App\\Models\\User', 18, 'auth_token', '20be5eb9b94550302a0ed76f144261595aeec08acfb5014dc1038c2538e9cbb8', '[\"*\"]', NULL, '2022-06-03 01:59:56', '2022-06-03 01:59:56'),
(65, 'App\\Models\\User', 19, 'auth_token', '233c73b661222c39db5f4c82306e22a65966b9d193b0b77799f9c54ca9b93ff9', '[\"*\"]', NULL, '2022-06-03 16:58:22', '2022-06-03 16:58:22'),
(66, 'App\\Models\\User', 19, 'auth_token', 'a3efadc258a3275b1b58da8a3d5164f72efe48bb54d62827680bede206fb0305', '[\"*\"]', NULL, '2022-06-03 16:58:22', '2022-06-03 16:58:22'),
(67, 'App\\Models\\User', 4, 'auth_token', '131a3e21546f768e71e1b50bbfed071c8e4d0f08112a575a16895db309413c92', '[\"*\"]', NULL, '2022-06-03 17:31:07', '2022-06-03 17:31:07'),
(68, 'App\\Models\\User', 4, 'auth_token', 'd151ca9670b7634430318667830e9b565a3e4f0073f57ba9843bf8d1f432151b', '[\"*\"]', NULL, '2022-06-03 17:31:18', '2022-06-03 17:31:18'),
(69, 'App\\Models\\User', 12, 'auth_token', 'f4ca2f0f1fedf7c325f1901f0ed83e88bb7b52f2e220e19f3939e4310009ede4', '[\"*\"]', NULL, '2022-06-03 17:31:40', '2022-06-03 17:31:40'),
(70, 'App\\Models\\User', 12, 'auth_token', '97dce9b67d428c327e5342e9a4469604d9ed0ac7f7e64331006f6feaafe5e36c', '[\"*\"]', NULL, '2022-06-03 17:31:44', '2022-06-03 17:31:44'),
(71, 'App\\Models\\User', 12, 'auth_token', '84c9d5dc63ea066a2f1228971e23be9d4b860d26b6ce08314d5b76d220f771af', '[\"*\"]', NULL, '2022-06-03 17:32:22', '2022-06-03 17:32:22'),
(72, 'App\\Models\\User', 4, 'auth_token', '359f4284d96fc120379e06d055e0a8ad1d2a667b8fad7b4c48cfb53da2e0a949', '[\"*\"]', NULL, '2022-06-03 22:19:24', '2022-06-03 22:19:24'),
(73, 'App\\Models\\User', 4, 'auth_token', 'c3ce21c53089350012a3f6fa51bac89eba52b774a95e56cbf02d8890b1c1d2fe', '[\"*\"]', NULL, '2022-06-03 22:19:29', '2022-06-03 22:19:29'),
(74, 'App\\Models\\User', 12, 'auth_token', '5be64cb6cd89d79e0bc630aa7a35a81e6d46829375daf57a27a8d6c2fcf22165', '[\"*\"]', NULL, '2022-06-03 22:19:49', '2022-06-03 22:19:49'),
(75, 'App\\Models\\User', 12, 'auth_token', '311578fc799871b9c57b883b0b3e8119ac802de0af9f54b61327e212104d1f5e', '[\"*\"]', NULL, '2022-06-04 06:28:47', '2022-06-04 06:28:47'),
(76, 'App\\Models\\User', 12, 'auth_token', '92dee3fd509081da5da6f145ec9200c3d85305ee4853378d29e6b5d7223e6324', '[\"*\"]', NULL, '2022-06-04 06:30:50', '2022-06-04 06:30:50'),
(77, 'App\\Models\\User', 12, 'auth_token', '45ac47fd23c5bc928ee97abe723b48d912cb3e0e8b72e2f9db5fb5a19be34ff4', '[\"*\"]', NULL, '2022-06-04 06:42:03', '2022-06-04 06:42:03'),
(78, 'App\\Models\\User', 12, 'auth_token', 'f84365fb092df0c132f79d6102928056de3473497114f248541b85980182f8c4', '[\"*\"]', NULL, '2022-06-04 06:42:15', '2022-06-04 06:42:15'),
(79, 'App\\Models\\User', 12, 'auth_token', 'bef429bedcb88c8d859040b666bfb8ad2bdbd44090b921ba67a19c0891d24501', '[\"*\"]', NULL, '2022-06-04 06:42:29', '2022-06-04 06:42:29'),
(80, 'App\\Models\\User', 12, 'auth_token', '6daab2146645bb07d12e9f6bb63c910fb0f27f3193ba8f4b695ef0288d614a34', '[\"*\"]', NULL, '2022-06-04 06:42:35', '2022-06-04 06:42:35'),
(81, 'App\\Models\\User', 12, 'auth_token', 'ef024e243476dd7a193c588b8ec2a2e9fa7899a57efdefe0e7e76b3897191c09', '[\"*\"]', NULL, '2022-06-04 06:42:46', '2022-06-04 06:42:46'),
(82, 'App\\Models\\User', 12, 'auth_token', 'ffb3aded2b9e270e7fc3deaa91a7f611d7b63938b84ea6a09fd55b05e16e511f', '[\"*\"]', NULL, '2022-06-04 06:42:49', '2022-06-04 06:42:49'),
(83, 'App\\Models\\User', 12, 'auth_token', 'b0fe8723820e5a3e614b76973d3ecdd6ac889eaf16801c3ce6d8e29bdf365dec', '[\"*\"]', NULL, '2022-06-04 06:44:04', '2022-06-04 06:44:04'),
(84, 'App\\Models\\User', 12, 'auth_token', '4cbc0f7c69eb3bffbc6c039dd8d9b8452c3d70e1ad8db5987dd7cf2734a311c6', '[\"*\"]', NULL, '2022-06-04 07:09:16', '2022-06-04 07:09:16'),
(85, 'App\\Models\\User', 12, 'auth_token', 'c5c2a6877ae870f7fd431b57718d1dfac67646bbf2f1fb2cf118bce659b5a4af', '[\"*\"]', NULL, '2022-06-04 07:09:23', '2022-06-04 07:09:23'),
(86, 'App\\Models\\User', 12, 'auth_token', '6b1de1c5520f480935be2fedd48802897aab5c9c5493bf5ff370f2e56e1781b2', '[\"*\"]', NULL, '2022-06-04 07:15:09', '2022-06-04 07:15:09'),
(87, 'App\\Models\\User', 12, 'auth_token', '8367c7537a97bec51567626457229fb5514554d09965df5cf41cbfa042308d7a', '[\"*\"]', NULL, '2022-06-04 07:17:20', '2022-06-04 07:17:20'),
(88, 'App\\Models\\User', 12, 'auth_token', '96e2848eb1226e0ce20b407b53ce9ddd03be116caed41e8bf5beafb41d0c2b51', '[\"*\"]', NULL, '2022-06-04 07:18:23', '2022-06-04 07:18:23'),
(89, 'App\\Models\\User', 12, 'auth_token', '728f7c9d16fa99319c0654fb17a543de5125447f71b1c574d9e4cc9d1f1d6f3a', '[\"*\"]', NULL, '2022-06-04 07:20:17', '2022-06-04 07:20:17'),
(90, 'App\\Models\\User', 12, 'auth_token', '60d82f4375fd89b24dca6bd159978d16b588e61413eb8e9a0adc6ae13937532e', '[\"*\"]', NULL, '2022-06-04 07:21:56', '2022-06-04 07:21:56'),
(91, 'App\\Models\\User', 12, 'auth_token', 'c88d08b2f6d4f6d285d81560051ef09d3e9970faf6453a72478017327e67867a', '[\"*\"]', NULL, '2022-06-04 07:22:42', '2022-06-04 07:22:42'),
(92, 'App\\Models\\User', 12, 'auth_token', 'f8d7edc5ae8fe6c6eacadca89bbf68d32c45f67259607b696cda5129104db134', '[\"*\"]', NULL, '2022-06-04 07:22:50', '2022-06-04 07:22:50'),
(93, 'App\\Models\\User', 12, 'auth_token', '09a498345ccf27bb253da0b3d228329082483f8a23d6c501d9d88b3e56680e1f', '[\"*\"]', NULL, '2022-06-04 07:22:58', '2022-06-04 07:22:58'),
(94, 'App\\Models\\User', 12, 'auth_token', '2003e4f7f50741626d07f2ec1c046c80ffd4b3339dc07f7815e30e764caec64c', '[\"*\"]', NULL, '2022-06-04 07:23:11', '2022-06-04 07:23:11'),
(95, 'App\\Models\\User', 12, 'auth_token', 'c9fad436a36522327189676e45453cd46806029588aad241641a7e877f77f2a1', '[\"*\"]', NULL, '2022-06-04 07:23:19', '2022-06-04 07:23:19'),
(96, 'App\\Models\\User', 12, 'auth_token', 'c486bc6e4bb0bde6719394510e3b336987d525f8c0bea596f4af6782612d54d5', '[\"*\"]', NULL, '2022-06-04 07:23:52', '2022-06-04 07:23:52'),
(97, 'App\\Models\\User', 12, 'auth_token', 'd95cd20d2e965e2bc0e6dd5516b8768f8131581d52e4e4c1e5f89552fab77b96', '[\"*\"]', '2022-06-04 07:25:21', '2022-06-04 07:25:16', '2022-06-04 07:25:21'),
(98, 'App\\Models\\User', 12, 'auth_token', '00b23ddc91a3793e86f0870f871857fd56219dd55650d6b7749f58bf572361c3', '[\"*\"]', '2022-06-04 07:34:32', '2022-06-04 07:26:55', '2022-06-04 07:34:32'),
(99, 'App\\Models\\User', 12, 'auth_token', '241ff868b8db2512954bdaa409b17f4d26b3524fd34a5874dad9941befd2856c', '[\"*\"]', '2022-06-07 08:08:15', '2022-06-04 07:39:20', '2022-06-07 08:08:15'),
(100, 'App\\Models\\User', 4, 'auth_token', '59287455effad85a19671258a1e2924942d4f1379622bde1e414118213d421e4', '[\"*\"]', '2022-06-04 08:07:12', '2022-06-04 08:06:11', '2022-06-04 08:07:12'),
(101, 'App\\Models\\User', 20, 'auth_token', '069e9921638a79688936e6a6185054fbccdd87939b15f863950359f5d3014ae4', '[\"*\"]', NULL, '2022-06-04 08:09:11', '2022-06-04 08:09:11'),
(102, 'App\\Models\\User', 20, 'auth_token', 'f9ed53101a3f100ca074fc0ca5d4a9b5bd1ac7c1ea9e8be643754051736067e1', '[\"*\"]', NULL, '2022-06-04 08:09:11', '2022-06-04 08:09:11'),
(103, 'App\\Models\\User', 20, 'auth_token', 'ea1950d47642f6987c97cf6d5d2e804fdf9e21d38cb20862f49f848bf4858d25', '[\"*\"]', NULL, '2022-06-04 08:09:50', '2022-06-04 08:09:50'),
(104, 'App\\Models\\User', 20, 'auth_token', '145e3967131346e2665b85ca469ea21069c9d6c4092bac00d1adfe24f96ee07a', '[\"*\"]', NULL, '2022-06-04 08:10:01', '2022-06-04 08:10:01'),
(105, 'App\\Models\\User', 21, 'auth_token', '1e89c341ef6d3562f8f98cd8a8f159343019ad8047f9cacfc1bf50cab3a2e488', '[\"*\"]', NULL, '2022-06-04 08:16:08', '2022-06-04 08:16:08'),
(106, 'App\\Models\\User', 21, 'auth_token', '97a8c0fa42fc13d1fc0dd6cf991ee40c45839e641c73dcd2a42dbc62d850fe52', '[\"*\"]', NULL, '2022-06-04 08:16:08', '2022-06-04 08:16:08'),
(107, 'App\\Models\\User', 21, 'auth_token', '1bbca0d1dd9c2452c0eaf7f8cc2a6bab94805c54d9a112218d457520a891f18a', '[\"*\"]', NULL, '2022-06-04 08:16:23', '2022-06-04 08:16:23'),
(108, 'App\\Models\\User', 21, 'auth_token', 'f40b6e039b8996ef812d03a26c97ac26e210c2c66444f175459a9a2c31ad5560', '[\"*\"]', NULL, '2022-06-04 08:18:11', '2022-06-04 08:18:11'),
(109, 'App\\Models\\User', 21, 'auth_token', 'f213618df9d6c1e5e87c7503d740e6013a247264b816e7e5ecb10de544ed506a', '[\"*\"]', NULL, '2022-06-04 08:23:07', '2022-06-04 08:23:07'),
(110, 'App\\Models\\User', 21, 'auth_token', '8e09637d73f5b34199e5a13a8f7331d5a3abea86e969b65fb06351579b8cb532', '[\"*\"]', NULL, '2022-06-04 08:23:25', '2022-06-04 08:23:25'),
(111, 'App\\Models\\User', 22, 'auth_token', '85a8d8cbba9a25821fd65b116fc7b18250941477af150cd240f3b85781240e22', '[\"*\"]', NULL, '2022-06-04 14:28:24', '2022-06-04 14:28:24'),
(112, 'App\\Models\\User', 22, 'auth_token', '93559c7156cd820f270c40057f4b28add33ebec0be9c6f799e2aa86ed9a1a460', '[\"*\"]', NULL, '2022-06-04 14:28:24', '2022-06-04 14:28:24'),
(113, 'App\\Models\\User', 22, 'auth_token', '9e130a89184bd4a95f5e203bcb6f57af5b5e31179cbc71b36f79608da93b0c68', '[\"*\"]', '2022-06-06 13:02:16', '2022-06-04 14:28:28', '2022-06-06 13:02:16'),
(114, 'App\\Models\\User', 23, 'auth_token', '0d222195f1eebbb5d8fa09d58bef4ab473c74b2fea834468de45026e527d8301', '[\"*\"]', NULL, '2022-06-04 18:50:11', '2022-06-04 18:50:11'),
(115, 'App\\Models\\User', 23, 'auth_token', 'ff218a2ab4b3c12bcf5c177e9e553711a3ff6efab125f0c988a0a545deaf7100', '[\"*\"]', NULL, '2022-06-04 18:50:11', '2022-06-04 18:50:11'),
(116, 'App\\Models\\User', 24, 'auth_token', 'e1af15fb3c79d58f094cebb8ffc9550a18782fc715572d7cccc2f29a9944af13', '[\"*\"]', NULL, '2022-06-04 18:51:59', '2022-06-04 18:51:59'),
(117, 'App\\Models\\User', 24, 'auth_token', '343a89379547977c151ae90acc3e515741a83754b4ac2ea23b8baba47529def7', '[\"*\"]', NULL, '2022-06-04 18:51:59', '2022-06-04 18:51:59'),
(118, 'App\\Models\\User', 25, 'auth_token', '33e99bc3bb554d4f762c140eea95e73eed165c486294b0673107943e4cdad024', '[\"*\"]', NULL, '2022-06-04 18:53:41', '2022-06-04 18:53:41'),
(119, 'App\\Models\\User', 25, 'auth_token', 'd32722e465fc527560450558c9f6b3c3be0988b8beb302b9eea50426427921be', '[\"*\"]', NULL, '2022-06-04 18:53:41', '2022-06-04 18:53:41'),
(120, 'App\\Models\\User', 25, 'auth_token', '5ea01589af7451e1a6b10b1738319b1719064e3016be93e6474189ccddcd1ed9', '[\"*\"]', NULL, '2022-06-04 18:54:01', '2022-06-04 18:54:01'),
(121, 'App\\Models\\User', 25, 'auth_token', '6b4183f4e7d7947a557c81124edd1e6e6b57fd9bcb8923fd537e5456b266fc08', '[\"*\"]', NULL, '2022-06-04 18:54:08', '2022-06-04 18:54:08'),
(122, 'App\\Models\\User', 25, 'auth_token', '257d3b67c0b2f425002a9d5000a63b58304de82dfb5521476aeb0929c61186dc', '[\"*\"]', '2022-06-04 19:02:58', '2022-06-04 18:58:36', '2022-06-04 19:02:58'),
(123, 'App\\Models\\User', 12, 'auth_token', '1b3dacadf9670aa5425ea50dc1b580ed7c5d7d61ddbf6db464984ddb79abca83', '[\"*\"]', '2022-06-04 22:37:16', '2022-06-04 22:33:20', '2022-06-04 22:37:16'),
(124, 'App\\Models\\User', 21, 'auth_token', '04649a115e00a629f0abf67318f44cd7217ade39831a16c8c400af46f5962a40', '[\"*\"]', NULL, '2022-06-04 22:57:25', '2022-06-04 22:57:25'),
(125, 'App\\Models\\User', 21, 'auth_token', 'f0e20f9b57fd3bd79ca1b1bd76f080b3311bed27b1a07944eda5e3898c10d403', '[\"*\"]', NULL, '2022-06-05 18:40:13', '2022-06-05 18:40:13'),
(126, 'App\\Models\\User', 21, 'auth_token', 'a4d044d41d48f0cf3a97494fa49eedc0bcb718d6b557d7409bf14c8586e037dc', '[\"*\"]', NULL, '2022-06-05 18:40:25', '2022-06-05 18:40:25'),
(127, 'App\\Models\\User', 26, 'auth_token', '656bea8c876630dae8e4465d9133cb187c230a5efacbcbd92a3c76888f7841c2', '[\"*\"]', NULL, '2022-06-05 18:40:55', '2022-06-05 18:40:55'),
(128, 'App\\Models\\User', 26, 'auth_token', '45df706c7065726d3ab43e4ad505433d4bb4712c91d6c09d2552bd8da2f80a15', '[\"*\"]', NULL, '2022-06-05 18:40:55', '2022-06-05 18:40:55'),
(129, 'App\\Models\\User', 27, 'auth_token', '91dbe66fa4b8fe20d58c73a2e33f5dabad4bbbced994d94c12e1fc8fd0b6e05f', '[\"*\"]', NULL, '2022-06-05 18:53:35', '2022-06-05 18:53:35'),
(130, 'App\\Models\\User', 27, 'auth_token', 'd9c6c41569d564a482a22ee608a810c4704443dfd8cca935f562ef48c9ad3b95', '[\"*\"]', NULL, '2022-06-05 18:53:35', '2022-06-05 18:53:35'),
(131, 'App\\Models\\User', 27, 'auth_token', 'bb9b0582cd21b05a201acc37e24c2832e855a135c24a24a9f27cd8ae12e8d3d1', '[\"*\"]', NULL, '2022-06-05 18:53:55', '2022-06-05 18:53:55'),
(132, 'App\\Models\\User', 27, 'auth_token', '6bcb0998424a9aea0e38cf847c4f6bc7cbdbc03e8ebe77b24dc05eed46ea9679', '[\"*\"]', NULL, '2022-06-05 18:59:43', '2022-06-05 18:59:43'),
(133, 'App\\Models\\User', 27, 'auth_token', '00d88ea969922ce47d3be0f2e2ec75a88ef42c3b12a89e651b53b22534fc217d', '[\"*\"]', NULL, '2022-06-05 19:15:41', '2022-06-05 19:15:41'),
(134, 'App\\Models\\User', 27, 'auth_token', '85db8d15a402a60e6816c360512c5815963a4b80c206259b8c0ebfdd44d473a0', '[\"*\"]', NULL, '2022-06-05 19:31:33', '2022-06-05 19:31:33'),
(135, 'App\\Models\\User', 27, 'auth_token', 'bd78a85ba7be22646c5d7e346abfa4cb1db154c251b48698e3e7620af6d05f3a', '[\"*\"]', NULL, '2022-06-05 19:35:21', '2022-06-05 19:35:21'),
(136, 'App\\Models\\User', 26, 'auth_token', 'ab721ba47cdccc3bf5b44fa71420a42d4a9088c7717be0ab45c9b6304f887651', '[\"*\"]', '2022-06-05 19:44:27', '2022-06-05 19:36:28', '2022-06-05 19:44:27'),
(137, 'App\\Models\\User', 22, 'auth_token', 'ccc0593910f43fbb08802758cbbb8138578f9163b99cfaefa07e0a4c6b13a3df', '[\"*\"]', '2022-06-05 23:06:57', '2022-06-05 23:06:31', '2022-06-05 23:06:57'),
(138, 'App\\Models\\User', 28, 'auth_token', 'ab1d6ae63eb2d009405274250f962ad810e98371c1ecd2ec5778a02cc84f1916', '[\"*\"]', NULL, '2022-06-06 19:04:15', '2022-06-06 19:04:15'),
(139, 'App\\Models\\User', 28, 'auth_token', 'ee18614b1abbe1c7665b3103452ed5932647c039bd2da36fa80821e1fdedd319', '[\"*\"]', NULL, '2022-06-06 19:04:15', '2022-06-06 19:04:15'),
(140, 'App\\Models\\User', 29, 'auth_token', '3ceffd9027ad1f53684774ae964e3f2f8a3622be29dec36f4ff5fce4b3f20af2', '[\"*\"]', NULL, '2022-06-06 19:05:02', '2022-06-06 19:05:02'),
(141, 'App\\Models\\User', 29, 'auth_token', '9457890a09701a45ff1e3bd4390beca7e0aaec493cff21d54fe746320d950b75', '[\"*\"]', NULL, '2022-06-06 19:05:02', '2022-06-06 19:05:02'),
(142, 'App\\Models\\User', 29, 'auth_token', '43f281fb2886a3d3bae5e493a56eef5467bf2f9da173930323f9eb5477e42abd', '[\"*\"]', NULL, '2022-06-06 19:05:20', '2022-06-06 19:05:20'),
(143, 'App\\Models\\User', 29, 'auth_token', '0211d1d3dc5d8d284ae5b0fdd5170d5a9368f6eb5fda8a1968282284c7ba7178', '[\"*\"]', NULL, '2022-06-06 19:05:33', '2022-06-06 19:05:33'),
(144, 'App\\Models\\User', 17, 'auth_token', '83b84936f67957993d1a811a44c2b2b7dfc152857dd02fdccc332deb7f680bea', '[\"*\"]', NULL, '2022-06-06 21:43:27', '2022-06-06 21:43:27'),
(145, 'App\\Models\\User', 17, 'auth_token', '674d72728d377540b718a83b8542b87845e81a57887c361eef96027c2213e471', '[\"*\"]', '2022-06-06 21:43:37', '2022-06-06 21:43:34', '2022-06-06 21:43:37'),
(146, 'App\\Models\\User', 21, 'auth_token', 'c444fbd4048524efc103f571c86e6fe90664e101e856e8798df77bbcf46c7f0a', '[\"*\"]', NULL, '2022-06-07 01:57:03', '2022-06-07 01:57:03'),
(147, 'App\\Models\\User', 27, 'auth_token', 'be888b00fb73dfb5d8df4d0693a47fc9fad6847f4fec2ca4fed8b5a2aee6fc4c', '[\"*\"]', '2022-06-09 02:22:59', '2022-06-07 03:43:38', '2022-06-09 02:22:59'),
(148, 'App\\Models\\User', 12, 'auth_token', '85b56fa6df3206207519fd9046ba208af1d8b1d010467ac6fd58dd02de726904', '[\"*\"]', NULL, '2022-06-07 07:55:00', '2022-06-07 07:55:00'),
(149, 'App\\Models\\User', 33, 'auth_token', '9f18dd49296e84844bd2021d511707ad8f585e629ecc736ccdc719325a627da0', '[\"*\"]', NULL, '2022-06-07 08:05:43', '2022-06-07 08:05:43'),
(150, 'App\\Models\\User', 33, 'auth_token', '7abb6c212ceea770bb44dbac5abfd8e732ddd09661d15b621b8e5b48ed3a9333', '[\"*\"]', NULL, '2022-06-07 08:05:43', '2022-06-07 08:05:43'),
(151, 'App\\Models\\User', 33, 'auth_token', '6a15abbc196c65e15b5b57fb2039cd81f9a5b07fbf7e668e479439e75f140398', '[\"*\"]', '2022-06-07 08:06:18', '2022-06-07 08:06:05', '2022-06-07 08:06:18'),
(152, 'App\\Models\\User', 33, 'auth_token', '79b6b6d779a80952bca888ae4a2f07f687ebc0d24da11cfa01bcac0317013ec7', '[\"*\"]', '2022-06-07 08:25:14', '2022-06-07 08:24:50', '2022-06-07 08:25:14'),
(153, 'App\\Models\\User', 33, 'auth_token', '43dbe4eb184596fee059d9971f6863ceb531993e98af033966fa3f543adcd101', '[\"*\"]', '2022-06-07 08:45:16', '2022-06-07 08:43:24', '2022-06-07 08:45:16'),
(154, 'App\\Models\\User', 28, 'auth_token', 'd80dba165b9bd933d1a5b6a7220c60ce8243c37a2627683333cc1cd4023924c4', '[\"*\"]', NULL, '2022-06-07 08:45:55', '2022-06-07 08:45:55'),
(155, 'App\\Models\\User', 35, 'auth_token', '7bd7d8cf74701e33575215d399defcb048794e6df134cb76367bae61f8aef645', '[\"*\"]', NULL, '2022-06-07 15:30:46', '2022-06-07 15:30:46'),
(156, 'App\\Models\\User', 35, 'auth_token', 'c3e0f4a88efd1e8dfb48e0e830f4856893dc89b1ae67e39d4cad2438896b253a', '[\"*\"]', NULL, '2022-06-07 15:30:46', '2022-06-07 15:30:46'),
(157, 'App\\Models\\User', 35, 'auth_token', '26acd2dc7fd07323dabd202898b96c4e82934fb7b3a39b046d70402100661fc4', '[\"*\"]', '2022-06-07 15:32:14', '2022-06-07 15:30:51', '2022-06-07 15:32:14'),
(158, 'App\\Models\\User', 34, 'auth_token', '79a05e1b9a4636a4456198008dc576ae724aef19f52953e924dea1efca7b0477', '[\"*\"]', NULL, '2022-06-07 15:36:28', '2022-06-07 15:36:28'),
(159, 'App\\Models\\User', 36, 'auth_token', '065fac1daea911e7b3bdf9953c53cc16b666fcdf02fc4686388cc34cc56ca70c', '[\"*\"]', NULL, '2022-06-07 15:46:24', '2022-06-07 15:46:24'),
(160, 'App\\Models\\User', 36, 'auth_token', '085dd42faf16e9a4f8aab265203e6719478d9a37f32a43c52428a529216b5d7c', '[\"*\"]', NULL, '2022-06-07 15:46:24', '2022-06-07 15:46:24'),
(161, 'App\\Models\\User', 36, 'auth_token', '95ee25b0a1082606c26c22b41a45cc3dd2b84eb4e1c968580f3e8b821e9847f1', '[\"*\"]', '2022-06-07 15:46:29', '2022-06-07 15:46:28', '2022-06-07 15:46:29'),
(162, 'App\\Models\\User', 37, 'auth_token', '538204c199a5336cd9d119cdd8cf7d5ecd5944a85923e9de9aa38c509fcec120', '[\"*\"]', NULL, '2022-06-07 16:28:34', '2022-06-07 16:28:34'),
(163, 'App\\Models\\User', 37, 'auth_token', '7b1da8b088326fb7e441b08c3d2f2b374f92b19a9e4cb1af980f684e82ed864b', '[\"*\"]', NULL, '2022-06-07 16:28:34', '2022-06-07 16:28:34'),
(164, 'App\\Models\\User', 38, 'auth_token', '13a7117feee9f1cf7bcfb032e1d6e55f1df3c91a09aa1860895f459c822ded33', '[\"*\"]', NULL, '2022-06-07 16:29:25', '2022-06-07 16:29:25'),
(165, 'App\\Models\\User', 38, 'auth_token', '1787bd375796579b57d30eb39b728a6cc2d978227921a5380a67acec71b908f0', '[\"*\"]', NULL, '2022-06-07 16:29:25', '2022-06-07 16:29:25'),
(166, 'App\\Models\\User', 38, 'auth_token', '36c3e1e19037c30bf07be49a03bd6f4976fe8ce06b3b83b5b8b4aea55508417a', '[\"*\"]', NULL, '2022-06-07 16:30:19', '2022-06-07 16:30:19'),
(167, 'App\\Models\\User', 38, 'auth_token', '95f896c0dfbacbfd41420c876e780eebf73759bbffa97653df0dcddbbefd8590', '[\"*\"]', '2022-06-09 05:19:36', '2022-06-07 16:30:25', '2022-06-09 05:19:36'),
(168, 'App\\Models\\User', 39, 'auth_token', 'a163b13cfb72458363d201df2d4c7c141082cd7925526f5c342918f55c17607f', '[\"*\"]', NULL, '2022-06-07 21:37:16', '2022-06-07 21:37:16'),
(169, 'App\\Models\\User', 39, 'auth_token', 'ebf4bebc9ec3a35165ad6d4d361e157be000b42f02b8853f2ff94d64260eb684', '[\"*\"]', NULL, '2022-06-07 21:37:16', '2022-06-07 21:37:16'),
(170, 'App\\Models\\User', 39, 'auth_token', '120a060dc3fe6512dd7e024b02a0546a9250ce7a30965f4954d1f14f7ecbe39d', '[\"*\"]', '2022-06-07 21:37:29', '2022-06-07 21:37:20', '2022-06-07 21:37:29'),
(171, 'App\\Models\\User', 40, 'auth_token', '22437eab4bb5604d54f1abc715ed3632fb71772242324f7b1f50e2e495636611', '[\"*\"]', NULL, '2022-06-07 21:45:00', '2022-06-07 21:45:00'),
(172, 'App\\Models\\User', 40, 'auth_token', '240253f67a72f1e9ce2384ce07c7b134afda61adc0e1a86ef70fbe3d6c054cb2', '[\"*\"]', NULL, '2022-06-07 21:45:00', '2022-06-07 21:45:00'),
(173, 'App\\Models\\User', 40, 'auth_token', 'c371cc1b46167581d7a58f8f893961b9b0520cf37d05b90a3507ebe34cec3986', '[\"*\"]', NULL, '2022-06-07 21:45:03', '2022-06-07 21:45:03'),
(174, 'App\\Models\\User', 41, 'auth_token', 'dac7b828db136d4d6ca26a6a35c10eaf4574416149a41815ba3cdf37c1752c19', '[\"*\"]', NULL, '2022-06-07 21:48:42', '2022-06-07 21:48:42'),
(175, 'App\\Models\\User', 41, 'auth_token', 'c1616a2f1c49c2dafcf7aa1c557cce0321fde30f26ea75b648c70cfd67fd4667', '[\"*\"]', NULL, '2022-06-07 21:48:42', '2022-06-07 21:48:42'),
(176, 'App\\Models\\User', 41, 'auth_token', '5796ffcb343a7a36341a905e4eb90363d427586302726bc3ea8a86916ad8bd95', '[\"*\"]', '2022-06-07 21:49:05', '2022-06-07 21:48:47', '2022-06-07 21:49:05'),
(177, 'App\\Models\\User', 42, 'auth_token', '3219e7b8b35d3a9d2e78495b12871215efdf916dca86d203dbbb6fccc542648b', '[\"*\"]', NULL, '2022-06-07 21:57:50', '2022-06-07 21:57:50'),
(178, 'App\\Models\\User', 42, 'auth_token', '7a5ede7a6986e5547fecd3ae277d6cb336a0702e33d924998d34b90be4bafbfb', '[\"*\"]', NULL, '2022-06-07 21:57:50', '2022-06-07 21:57:50'),
(179, 'App\\Models\\User', 42, 'auth_token', 'd06d68c21222494c868337be542490a3a5210bf6cfdcf66e86a8f7b671ad9dff', '[\"*\"]', '2022-06-09 03:33:49', '2022-06-07 21:57:54', '2022-06-09 03:33:49'),
(180, 'App\\Models\\User', 43, 'auth_token', 'b7c287a75ae14964c582523cb07d8729c1c667eda0350dd572199b2578443f7c', '[\"*\"]', NULL, '2022-06-07 22:00:36', '2022-06-07 22:00:36'),
(181, 'App\\Models\\User', 43, 'auth_token', 'cf8cae9a68ea4df27c92fd3bd3cb83cbe5e3a40ada7ac4948530ab777fdf4a48', '[\"*\"]', NULL, '2022-06-07 22:00:36', '2022-06-07 22:00:36'),
(182, 'App\\Models\\User', 43, 'auth_token', '183f75266d9bb419ede85a733489d31627d269e24e1708bf5720230c98306ee1', '[\"*\"]', NULL, '2022-06-07 22:00:42', '2022-06-07 22:00:42'),
(183, 'App\\Models\\User', 44, 'auth_token', '1bce46e21769718fb0b39b37289efda5c6930c427dd2ac8890bb5d36f5a3aee5', '[\"*\"]', NULL, '2022-06-07 22:04:01', '2022-06-07 22:04:01'),
(184, 'App\\Models\\User', 44, 'auth_token', '25bd65ccd81e01b9fc2ee3e59c121e26ea2e1907b181d8c6e481cc3c9a503ea0', '[\"*\"]', NULL, '2022-06-07 22:04:01', '2022-06-07 22:04:01'),
(185, 'App\\Models\\User', 44, 'auth_token', '7037659bcd2e384593c4edde62a60eea6acbfa21aa7b450a6643cb97c7e6fd33', '[\"*\"]', '2022-06-07 22:04:21', '2022-06-07 22:04:04', '2022-06-07 22:04:21'),
(186, 'App\\Models\\User', 45, 'auth_token', '60e9e071e9c262fabb5e9fb0c28847c8aa2f45ba1854026d555a7ffdbe19b4ef', '[\"*\"]', NULL, '2022-06-07 22:08:20', '2022-06-07 22:08:20'),
(187, 'App\\Models\\User', 45, 'auth_token', 'd71c7b07a9ec554d21b6b126b95b3e5726f1df13a8dda6d143ba3ec7fcd179f8', '[\"*\"]', NULL, '2022-06-07 22:08:20', '2022-06-07 22:08:20'),
(188, 'App\\Models\\User', 45, 'auth_token', '7d3422a687ae35ed9b8001c6c79f6d7c326b7703dd09615dd0f68dbc621fc6d9', '[\"*\"]', NULL, '2022-06-07 22:08:24', '2022-06-07 22:08:24'),
(189, 'App\\Models\\User', 42, 'auth_token', '0c005511384e32ab1a7008a068ea0ea36f9b53982340bb15cb395e363ca4f242', '[\"*\"]', NULL, '2022-06-07 23:46:15', '2022-06-07 23:46:15'),
(190, 'App\\Models\\User', 42, 'auth_token', '6113cdf7fc0af71378e820c4b7d80426508c07bc0b062f83d3d351e193418d3e', '[\"*\"]', NULL, '2022-06-07 23:46:18', '2022-06-07 23:46:18'),
(191, 'App\\Models\\User', 46, 'auth_token', '496c9392ebf97d1bbce2eeeba93f649c929a9d9fbbf9eedbe03f1290286fdb3e', '[\"*\"]', NULL, '2022-06-08 03:07:04', '2022-06-08 03:07:04'),
(192, 'App\\Models\\User', 46, 'auth_token', '694225853497adda208a2d432ff4ae5732244ec06fb7810ba18b8e27b4354d92', '[\"*\"]', NULL, '2022-06-08 03:07:04', '2022-06-08 03:07:04'),
(193, 'App\\Models\\User', 46, 'auth_token', '98f165f0b8a036819bd18d65956d6a70de86fccc14c834ab042f6f8dc44213e3', '[\"*\"]', '2022-06-08 03:36:17', '2022-06-08 03:07:58', '2022-06-08 03:36:17'),
(194, 'App\\Models\\User', 47, 'auth_token', '27ff3b69bda81c5098498334c3b3fdcf6cf1388c17a2fd45cca24971b05dba80', '[\"*\"]', NULL, '2022-06-08 03:16:38', '2022-06-08 03:16:38'),
(195, 'App\\Models\\User', 47, 'auth_token', '217f3eb62c0edbdfe24d351478966fc944b68433f8658258ee392a90565bf7e4', '[\"*\"]', NULL, '2022-06-08 03:16:38', '2022-06-08 03:16:38'),
(196, 'App\\Models\\User', 47, 'auth_token', '74a51caf21faafbc8eddd11200a85dbdd6962b98f0ce5d376adf8be9308d8372', '[\"*\"]', NULL, '2022-06-08 03:17:04', '2022-06-08 03:17:04'),
(197, 'App\\Models\\User', 48, 'auth_token', '36234dff09044700ea3d4e31e822d39ed24ec7dd91c1586ac1e9bfc95d59afcd', '[\"*\"]', NULL, '2022-06-08 03:28:28', '2022-06-08 03:28:28'),
(198, 'App\\Models\\User', 48, 'auth_token', 'd26cd3b1a81a891c12b9dc2342352f417a22c25e1333b0f7829ee997b15b349f', '[\"*\"]', NULL, '2022-06-08 03:28:28', '2022-06-08 03:28:28'),
(199, 'App\\Models\\User', 46, 'auth_token', '1f5c03114bc83c6327bd0469ef92dbda0469f6557e8f768a9b6dbd0e0140d5ae', '[\"*\"]', '2022-06-08 03:30:19', '2022-06-08 03:28:48', '2022-06-08 03:30:19'),
(200, 'App\\Models\\User', 48, 'auth_token', 'cd8c7f3bc29733719ce33a34a98cf2aa02aecc0a7aa792cb989292af8178a745', '[\"*\"]', NULL, '2022-06-08 03:28:55', '2022-06-08 03:28:55'),
(201, 'App\\Models\\User', 48, 'auth_token', '2d256690dbbf79762acbcc8e064a1ab286f3f20ffa32422473c730e4e0b78b4b', '[\"*\"]', NULL, '2022-06-08 03:29:00', '2022-06-08 03:29:00'),
(202, 'App\\Models\\User', 46, 'auth_token', '9eb121df02b9f5c9be8ed8b334e3aa7301dcfdbe767239202cf73036e3a375a9', '[\"*\"]', '2022-06-08 04:05:08', '2022-06-08 03:30:54', '2022-06-08 04:05:08'),
(203, 'App\\Models\\User', 47, 'auth_token', '14a550c9092969d346da499dac2a350eb3ad1b1445f8704781e747b3cc7b3988', '[\"*\"]', NULL, '2022-06-08 03:56:56', '2022-06-08 03:56:56'),
(204, 'App\\Models\\User', 46, 'auth_token', 'd906f3169383096024da83aea6bb8c3911c8e48a5907479a27444b05bc2b9f5d', '[\"*\"]', NULL, '2022-06-08 06:12:44', '2022-06-08 06:12:44'),
(205, 'App\\Models\\User', 46, 'auth_token', 'ded557cf3b31dd325c11b71fa6b50643df824b4be9eaa0e73e90ca906b70f166', '[\"*\"]', NULL, '2022-06-08 06:12:47', '2022-06-08 06:12:47'),
(206, 'App\\Models\\User', 47, 'auth_token', 'e19f30be5a599f9446432ef4f6b6afc97d53d27dbcdcf44aaa22aec8942d5e78', '[\"*\"]', NULL, '2022-06-08 06:13:05', '2022-06-08 06:13:05'),
(207, 'App\\Models\\User', 47, 'auth_token', '779075bb625758c2f37c2d6f8af10baab7f307aa0201cd171d8d2c51e1a3f5e0', '[\"*\"]', NULL, '2022-06-08 06:13:08', '2022-06-08 06:13:08'),
(208, 'App\\Models\\User', 33, 'auth_token', '911a41a0b2f211d1903fdf7545fc1d3df66836e585d26695eb30fc95a334d797', '[\"*\"]', '2022-06-08 08:40:41', '2022-06-08 08:39:14', '2022-06-08 08:40:41'),
(209, 'App\\Models\\User', 42, 'auth_token', 'be56c032e3d2694c5ad80a04779b98d95539c20ef71852bf16f6de9c9a7c9d24', '[\"*\"]', NULL, '2022-06-08 09:37:17', '2022-06-08 09:37:17'),
(210, 'App\\Models\\User', 50, 'auth_token', '7d85352011c1943eaa246e4b5920a03dab3e72743d50af14bd5409e2de7e5e8b', '[\"*\"]', NULL, '2022-06-08 10:32:16', '2022-06-08 10:32:16'),
(211, 'App\\Models\\User', 50, 'auth_token', 'ee5e814767a4b21ce0ab820bb228904eca44ffb521822f57169e2e00e8a29247', '[\"*\"]', NULL, '2022-06-08 10:32:16', '2022-06-08 10:32:16'),
(212, 'App\\Models\\User', 50, 'auth_token', 'd24e75c500b267fbbe1c4b7df6f18ec795efe212095ec92bf12605cb87acf258', '[\"*\"]', '2022-06-08 18:24:37', '2022-06-08 10:32:20', '2022-06-08 18:24:37'),
(213, 'App\\Models\\User', 51, 'auth_token', 'a664b4d517e1f843cb0024dd2d44767a322b117a5be901e324f9f8674bcb3df1', '[\"*\"]', NULL, '2022-06-08 18:08:52', '2022-06-08 18:08:52'),
(214, 'App\\Models\\User', 51, 'auth_token', '51d38de342be203fa7f2dae6305b55c97b622d0a484ffd2e968c684a00103b08', '[\"*\"]', NULL, '2022-06-08 18:08:52', '2022-06-08 18:08:52'),
(215, 'App\\Models\\User', 51, 'auth_token', '3f1e25d6b73b19536ff944cdf944cc42fed3517317b147ee6d2fda8fd9590bcd', '[\"*\"]', NULL, '2022-06-08 18:08:57', '2022-06-08 18:08:57'),
(216, 'App\\Models\\User', 46, 'auth_token', 'd6246b9bc2bc11de25ead365aead504bda9a5b89c40b78afa11e3bea9e1c27ae', '[\"*\"]', '2022-06-08 22:19:29', '2022-06-08 18:24:20', '2022-06-08 22:19:29'),
(217, 'App\\Models\\User', 52, 'auth_token', 'd4b81b27c35fd45c34924879334777cce56b296b3dfb3bb10326fc21486988b4', '[\"*\"]', NULL, '2022-06-08 18:36:30', '2022-06-08 18:36:30'),
(218, 'App\\Models\\User', 52, 'auth_token', '083bc539d16585ed824573805f879a65ad1f14cb0211734e5118ac5dde1d94bc', '[\"*\"]', NULL, '2022-06-08 18:36:30', '2022-06-08 18:36:30'),
(219, 'App\\Models\\User', 52, 'auth_token', '63c11b4ddd90f119098ab4c67edf5f3d54bed770b429c0cfedb174ebb269aa68', '[\"*\"]', NULL, '2022-06-08 18:36:33', '2022-06-08 18:36:33'),
(220, 'App\\Models\\User', 53, 'auth_token', 'f79360e37a80d116ae7d09735b57e9b47290327d6295f779811126e38128a1ae', '[\"*\"]', NULL, '2022-06-08 21:17:48', '2022-06-08 21:17:48'),
(221, 'App\\Models\\User', 53, 'auth_token', 'a07201af54bc680680016664bb9c87f3beab1d314d89fbfbae403cb3b8acc14a', '[\"*\"]', NULL, '2022-06-08 21:17:48', '2022-06-08 21:17:48'),
(222, 'App\\Models\\User', 53, 'auth_token', '77270221a6fa7977a2564aa19c9e0b8b37631481aabf110c9aad32f9cff476ee', '[\"*\"]', NULL, '2022-06-08 21:17:53', '2022-06-08 21:17:53'),
(223, 'App\\Models\\User', 46, 'auth_token', 'd7c825f3dae732db7f670ef9d532f998e524020e23ce3a95c991d464915e61dc', '[\"*\"]', '2022-06-09 05:11:46', '2022-06-09 05:08:45', '2022-06-09 05:11:46'),
(224, 'App\\Models\\User', 55, 'auth_token', '5077a0280e9e5226f9f8dc8d01b3153df9d34fb74e5a9d8c65edd4d9a8ade19a', '[\"*\"]', NULL, '2022-06-09 05:42:24', '2022-06-09 05:42:24'),
(225, 'App\\Models\\User', 55, 'auth_token', '57695a13557658091aba78015a979173f410f30ccbec6168a9cb034ddd467752', '[\"*\"]', NULL, '2022-06-09 05:42:24', '2022-06-09 05:42:24'),
(226, 'App\\Models\\User', 55, 'auth_token', '583cb186588d9949c91e5187b06cb7ddf50060e7dd639d3f74248655736e6d2f', '[\"*\"]', '2022-06-09 06:25:16', '2022-06-09 05:43:04', '2022-06-09 06:25:16'),
(227, 'App\\Models\\User', 56, 'auth_token', 'd7debd1a812ad86b62fab807f6f8fca45a7bbab98066398c4f611d41eba34c26', '[\"*\"]', NULL, '2022-06-09 05:53:30', '2022-06-09 05:53:30'),
(228, 'App\\Models\\User', 56, 'auth_token', 'f71db75f0a6dc40bc547b81bbfcf6ecb682dbf85679dc76f97a43ce4dc3ea121', '[\"*\"]', NULL, '2022-06-09 05:53:30', '2022-06-09 05:53:30'),
(229, 'App\\Models\\User', 57, 'auth_token', 'a4ea738bd59144603c6bc417c9354741bf2c4eb09657f08ea2939158b3536a9a', '[\"*\"]', NULL, '2022-06-09 05:55:07', '2022-06-09 05:55:07'),
(230, 'App\\Models\\User', 57, 'auth_token', 'd1aa0adaf0f6d6601d7d6f5975b1f5b323b725d983f6ccbcb1da4d7c8ac5c6ce', '[\"*\"]', NULL, '2022-06-09 05:55:07', '2022-06-09 05:55:07'),
(231, 'App\\Models\\User', 57, 'auth_token', 'd585dafabdc3ea25bb2a8a4c8551cb42a6f3f1ddede9f3fc3ffb2a0da6d1b658', '[\"*\"]', NULL, '2022-06-09 05:55:33', '2022-06-09 05:55:33'),
(232, 'App\\Models\\User', 57, 'auth_token', '494c25cfe31be4d0ba8ab22b7c1a0255cb9c576b494d2b299ecff4808b5621b4', '[\"*\"]', NULL, '2022-06-09 05:55:38', '2022-06-09 05:55:38'),
(233, 'App\\Models\\User', 57, 'auth_token', '31a04688ce2e3667e917e03a5743abe5d82651a25ad44f6958880cdebcce9d2a', '[\"*\"]', NULL, '2022-06-09 05:55:43', '2022-06-09 05:55:43'),
(234, 'App\\Models\\User', 57, 'auth_token', '27d3ddfb66a2285ed93d2b3a5cc9768f15a2ce77518792d92bcc7d8749ea1c00', '[\"*\"]', NULL, '2022-06-09 05:55:48', '2022-06-09 05:55:48'),
(235, 'App\\Models\\User', 58, 'auth_token', '7bc0b31d95b55d966578764a1155f835573b7e00e505b822c81a04b9580c84bb', '[\"*\"]', NULL, '2022-06-09 05:58:00', '2022-06-09 05:58:00'),
(236, 'App\\Models\\User', 58, 'auth_token', '98ad39bc858220ed412fbbd85f221b03eb3451048ab497610b7773a464a46592', '[\"*\"]', NULL, '2022-06-09 05:58:00', '2022-06-09 05:58:00'),
(237, 'App\\Models\\User', 58, 'auth_token', '151995852d9210d31f96336e03b26379224f9562051038f3941f81ccaa6127dc', '[\"*\"]', NULL, '2022-06-09 05:58:15', '2022-06-09 05:58:15'),
(238, 'App\\Models\\User', 58, 'auth_token', 'ffe08c8020d56bbe372030b1f609149268b84acf8b5fe485bbf8455315915b8f', '[\"*\"]', NULL, '2022-06-09 06:00:34', '2022-06-09 06:00:34'),
(239, 'App\\Models\\User', 58, 'auth_token', '1d6804d601dec825dfa7f18dcbb848da667a5831c3d2e463ff6f4cff219ac97c', '[\"*\"]', '2022-06-09 06:25:51', '2022-06-09 06:09:32', '2022-06-09 06:25:51'),
(240, 'App\\Models\\User', 59, 'auth_token', 'cc5ffa4d15388537c45d14d863c9ffa460971ed02640cd516b926cc743eacda4', '[\"*\"]', NULL, '2022-06-09 06:32:01', '2022-06-09 06:32:01'),
(241, 'App\\Models\\User', 59, 'auth_token', '307b4f18420fead9e082e5f103a83f9fbad0f8f35d19490724d32c14a7b9e058', '[\"*\"]', NULL, '2022-06-09 06:32:01', '2022-06-09 06:32:01'),
(242, 'App\\Models\\User', 59, 'auth_token', 'fdda423fad8a7f724d3ec2c096fe650719e095e8145f2bb7ec7f6a71422a61a6', '[\"*\"]', NULL, '2022-06-09 06:32:03', '2022-06-09 06:32:03'),
(243, 'App\\Models\\User', 61, 'auth_token', '0c2d128954687f632a51557185bae70c5d8b0537b5fe8329db3cf3dad00ce7d4', '[\"*\"]', NULL, '2022-06-12 07:32:39', '2022-06-12 07:32:39'),
(244, 'App\\Models\\User', 61, 'auth_token', 'f1b1b2ce61bf1ba10a9dae07561ae9646af36551069f422705fcc8f0dcee1f2f', '[\"*\"]', NULL, '2022-06-12 07:32:39', '2022-06-12 07:32:39'),
(245, 'App\\Models\\User', 62, 'auth_token', 'd1b38980aa4284997330c4fa7b1c89ac0ee24c2084080493e03b81e8d5220378', '[\"*\"]', NULL, '2022-06-12 07:33:10', '2022-06-12 07:33:10'),
(246, 'App\\Models\\User', 62, 'auth_token', '54df6284377788f563f2e982629e56e552e4478857499fdd61946912ae97a4e6', '[\"*\"]', NULL, '2022-06-12 07:33:10', '2022-06-12 07:33:10'),
(247, 'App\\Models\\User', 62, 'auth_token', '8071dabab47bb026f02808345bd276701bd6ee6cb0db1e6506e74fab8bc649bd', '[\"*\"]', NULL, '2022-06-12 07:34:38', '2022-06-12 07:34:38'),
(248, 'App\\Models\\User', 62, 'auth_token', '087f702b8a30cb317b1692e6f05270dbb843a7355c9c3471809b41cf6ffc9d7d', '[\"*\"]', NULL, '2022-06-12 07:34:39', '2022-06-12 07:34:39'),
(249, 'App\\Models\\User', 62, 'auth_token', '7010a4a9fc01c71e7f83773a86637632fdcfbd996488dffeefa733445951ce41', '[\"*\"]', '2022-06-12 08:12:33', '2022-06-12 07:44:26', '2022-06-12 08:12:33'),
(250, 'App\\Models\\User', 62, 'auth_token', '88e030218e6f6333be34311b6e3e6eabd29300c20544995c9bf7ce6d6221a63d', '[\"*\"]', '2022-06-12 19:23:15', '2022-06-12 07:45:44', '2022-06-12 19:23:15'),
(251, 'App\\Models\\User', 62, 'auth_token', 'abc9fc2bff8e05ee752cf18a49495f15dba114ab488fc5a63f0a238678bbd82f', '[\"*\"]', NULL, '2022-06-12 19:01:47', '2022-06-12 19:01:47'),
(252, 'App\\Models\\User', 55, 'auth_token', '55e3dea86f3aa5f7e131ecc75a2131899406f064557a8c408569fb12246df2ae', '[\"*\"]', '2022-06-12 19:22:14', '2022-06-12 19:02:38', '2022-06-12 19:22:14'),
(253, 'App\\Models\\User', 63, 'auth_token', 'b5edf7872ec842b69e7b07f95e00264c599028612643c4398a8904a40a70f382', '[\"*\"]', NULL, '2022-06-13 21:05:45', '2022-06-13 21:05:45'),
(254, 'App\\Models\\User', 63, 'auth_token', 'ce351080029fcc9a1a5ce1b0f540426450d00685ef79b391b6fc363277a9b11e', '[\"*\"]', NULL, '2022-06-13 21:05:45', '2022-06-13 21:05:45'),
(255, 'App\\Models\\User', 63, 'auth_token', '15af572eb33014f451a495cd44a6ef0e352b2cabdaad45db51f02046d6a583fd', '[\"*\"]', '2022-06-22 01:13:38', '2022-06-13 21:06:15', '2022-06-22 01:13:38'),
(256, 'App\\Models\\User', 55, 'auth_token', '35ebeeb42a3c9387a0fbfe6654b41b7fce3424e94d65a44eca3cc65cace8c7c5', '[\"*\"]', NULL, '2022-06-13 22:29:05', '2022-06-13 22:29:05'),
(257, 'App\\Models\\User', 63, 'auth_token', '7f870c12b55876acc791dfd2d8e828bd4d8eb08865eba1a1c610b25185eb06f7', '[\"*\"]', NULL, '2022-06-13 22:46:05', '2022-06-13 22:46:05'),
(258, 'App\\Models\\User', 63, 'auth_token', '323deec91fbcb25b0a20f47d2b325e0ef480cc4224c3d646fe60ee84d6d0fdef', '[\"*\"]', NULL, '2022-06-13 22:46:12', '2022-06-13 22:46:12'),
(259, 'App\\Models\\User', 64, 'auth_token', '861ede22d81fb81e6b9d5689d4cd1e7be25a7f0738b1d70fcb12ec16468827e4', '[\"*\"]', NULL, '2022-06-13 22:47:16', '2022-06-13 22:47:16'),
(260, 'App\\Models\\User', 64, 'auth_token', '4995199a7d4276f733b7beef35a73153a1056a3cd7822a235329944a2a0e9fba', '[\"*\"]', NULL, '2022-06-13 22:47:16', '2022-06-13 22:47:16'),
(261, 'App\\Models\\User', 63, 'auth_token', '0a7118e1d805b81e843ddba65db791bb14b4258faf00e5623cc1dde6d0e1f78b', '[\"*\"]', NULL, '2022-06-13 23:04:18', '2022-06-13 23:04:18'),
(262, 'App\\Models\\User', 65, 'auth_token', '7900293fe3f7cace20f26ba9c0da38a6dcd062c550376c13126793329541b62f', '[\"*\"]', NULL, '2022-06-13 23:09:14', '2022-06-13 23:09:14'),
(263, 'App\\Models\\User', 65, 'auth_token', '0c94e64c5dc613869f65b44940fe7bdc83c3a9c557688cc93683c577c8730dbe', '[\"*\"]', NULL, '2022-06-13 23:09:14', '2022-06-13 23:09:14'),
(264, 'App\\Models\\User', 65, 'auth_token', '09e249412d52d4e0b1da4f39e650871d0389b216b82b2a13efcc16e46d324b31', '[\"*\"]', NULL, '2022-06-13 23:09:39', '2022-06-13 23:09:39'),
(265, 'App\\Models\\User', 65, 'auth_token', '54779d791a4e8a82606a02b3e11557055b216e08ed49f2325f22a63bafde0fa7', '[\"*\"]', NULL, '2022-06-13 23:21:18', '2022-06-13 23:21:18'),
(266, 'App\\Models\\User', 65, 'auth_token', 'ef9841cbef1051ba4e1d7b4c9d102992af5bbff080e5318342b65a5c3d7143fe', '[\"*\"]', NULL, '2022-06-13 23:24:44', '2022-06-13 23:24:44'),
(267, 'App\\Models\\User', 65, 'auth_token', 'e4ac45a3051c6eb5f7d7cec2e218a905e88dcb06a1b02fef5de5b07486f4fb43', '[\"*\"]', NULL, '2022-06-13 23:24:53', '2022-06-13 23:24:53'),
(268, 'App\\Models\\User', 65, 'auth_token', '41d613a44b55e8ac191b90895598aed0a1fb8a3bca2d793e4e3ea0a5c5c525d5', '[\"*\"]', NULL, '2022-06-13 23:29:22', '2022-06-13 23:29:22'),
(269, 'App\\Models\\User', 65, 'auth_token', 'cb65961a6b076940107cbeba77e0eb73ce032410b741f7c0de0a85d1780e80e3', '[\"*\"]', NULL, '2022-06-13 23:31:58', '2022-06-13 23:31:58'),
(270, 'App\\Models\\User', 65, 'auth_token', 'f9585c3f6d78138465a402662089ed0566726951f1023541f2fd3b2ffa97a6b1', '[\"*\"]', NULL, '2022-06-13 23:32:04', '2022-06-13 23:32:04'),
(271, 'App\\Models\\User', 65, 'auth_token', '069e277e5b732dc5cf45564a556246bef39de7747eff14072c9c5cff56b75e95', '[\"*\"]', NULL, '2022-06-13 23:32:23', '2022-06-13 23:32:23'),
(272, 'App\\Models\\User', 65, 'auth_token', '8dc2b4e3de13742b8c2f1576038aae449ed6ba0fca8c91fbb2144720da4092d6', '[\"*\"]', '2022-06-15 21:29:54', '2022-06-13 23:41:07', '2022-06-15 21:29:54'),
(273, 'App\\Models\\User', 66, 'auth_token', '5587683000e199b283b1f8433ba86cc6133fc70a4f4ce869a755e9b29b7454fb', '[\"*\"]', NULL, '2022-06-14 05:54:08', '2022-06-14 05:54:08'),
(274, 'App\\Models\\User', 66, 'auth_token', '5afe2b401458ea0ce04c1867f9fbbbc8a8657bd7e37ed7c019c82a89fa2f6783', '[\"*\"]', NULL, '2022-06-14 05:54:08', '2022-06-14 05:54:08'),
(275, 'App\\Models\\User', 66, 'auth_token', 'b2e1d1f5fd076ec1b847a26cf06bbf50c50077e151b0d24f9819d9c35999fa1d', '[\"*\"]', '2022-06-14 06:03:28', '2022-06-14 05:54:10', '2022-06-14 06:03:28'),
(276, 'App\\Models\\User', 55, 'auth_token', 'dc2fde857dd8df61fb1e81b18f8a65a8e748064160f3bee274da2fbbfdff5465', '[\"*\"]', NULL, '2022-06-14 05:55:48', '2022-06-14 05:55:48'),
(277, 'App\\Models\\User', 67, 'auth_token', '11342e7cee0e8b32ba5bb12b8df5ae251543291622ac8f5eb859737ad3c5b184', '[\"*\"]', NULL, '2022-06-14 05:57:32', '2022-06-14 05:57:32'),
(278, 'App\\Models\\User', 67, 'auth_token', 'de38f9fea7add839f17bc91978ff17e7dbfec6ba532e72da8a2835465e928809', '[\"*\"]', NULL, '2022-06-14 05:57:32', '2022-06-14 05:57:32'),
(279, 'App\\Models\\User', 67, 'auth_token', 'd571913a2d43b33fe04fff4fd0ee317a9951c906b574ca5c2e235dad7db497c7', '[\"*\"]', NULL, '2022-06-14 05:58:25', '2022-06-14 05:58:25'),
(280, 'App\\Models\\User', 67, 'auth_token', 'c258a85e7d423a5b2d7830e20f1221088af869286bc4818d18957110d81b2d56', '[\"*\"]', '2022-06-22 04:15:56', '2022-06-14 05:58:29', '2022-06-22 04:15:56'),
(281, 'App\\Models\\User', 55, 'auth_token', 'd6e4eb78a2f6195c3c5d5446c56182cb2780392ed2dd8c82c62ddabc8ecab6e0', '[\"*\"]', '2022-06-14 23:09:33', '2022-06-14 22:41:23', '2022-06-14 23:09:33');
INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `created_at`, `updated_at`) VALUES
(282, 'App\\Models\\User', 68, 'auth_token', '089d6f0d8bb95a429f258cdfaaf0a54d51146a12a192a93074686261a793f80b', '[\"*\"]', NULL, '2022-06-15 21:31:38', '2022-06-15 21:31:38'),
(283, 'App\\Models\\User', 68, 'auth_token', '0d997d4dbad3de8059ebacaeb0eca164cda4d327090d8411fd00990df992a355', '[\"*\"]', NULL, '2022-06-15 21:31:38', '2022-06-15 21:31:38'),
(284, 'App\\Models\\User', 64, 'auth_token', '75c2ea9f76c00b86d92387caa848b41b1123093347fb45ac5c53a2225e7dae71', '[\"*\"]', NULL, '2022-06-15 21:32:03', '2022-06-15 21:32:03'),
(285, 'App\\Models\\User', 64, 'auth_token', '51380b3f074b8ac77b9e7d6b120f1ce61cae4cf0a94a74b25b94f95361e8e852', '[\"*\"]', NULL, '2022-06-15 21:32:05', '2022-06-15 21:32:05'),
(286, 'App\\Models\\User', 64, 'auth_token', '465b5d83607eead3fbbde0106019eebaaa2c95db218cab46928f3882df22ff55', '[\"*\"]', NULL, '2022-06-16 00:29:43', '2022-06-16 00:29:43'),
(287, 'App\\Models\\User', 65, 'auth_token', 'd1c6dfe61b3b0749f68e3710decdb2a788afbea8e1b76e823f212d26d673c1a5', '[\"*\"]', '2022-06-17 00:17:44', '2022-06-16 00:30:17', '2022-06-17 00:17:44'),
(288, 'App\\Models\\User', 69, 'auth_token', '1b13af2e112e56b2b595c3a952f065edb08037e690e64aa599213abba9a8ed59', '[\"*\"]', NULL, '2022-06-17 00:19:56', '2022-06-17 00:19:56'),
(289, 'App\\Models\\User', 69, 'auth_token', '75f3a78fbce632e8542655e7eb8a21adc8cdcfe733ff15d3b7aeb0c1035a25cd', '[\"*\"]', NULL, '2022-06-17 00:19:56', '2022-06-17 00:19:56'),
(290, 'App\\Models\\User', 69, 'auth_token', '78c03750f7b271eb6039105aa82a5a450016b1d47eb85099804a7de4d40c63c2', '[\"*\"]', NULL, '2022-06-17 00:20:47', '2022-06-17 00:20:47'),
(291, 'App\\Models\\User', 69, 'auth_token', 'c420f0a109612c141081de0e6c49beb9486815a7614d54649f3f3077c924c94b', '[\"*\"]', NULL, '2022-06-17 00:20:51', '2022-06-17 00:20:51'),
(292, 'App\\Models\\User', 69, 'auth_token', 'b7dec04bc754603ad2ca56bc5b0f825b6dfb7a60107cfc32ef9b26f2210662eb', '[\"*\"]', '2022-06-17 00:23:32', '2022-06-17 00:23:29', '2022-06-17 00:23:32'),
(293, 'App\\Models\\User', 70, 'auth_token', '47b56377ae2e915a738521c6dbfee0d272ec5c54d7f480e33ef2bb4fb7b86a88', '[\"*\"]', NULL, '2022-06-17 04:14:06', '2022-06-17 04:14:06'),
(294, 'App\\Models\\User', 70, 'auth_token', 'f62e6aa4583e12602f56f34762f761af1548acbb4c2b87d562db5178609f8c10', '[\"*\"]', NULL, '2022-06-17 04:14:06', '2022-06-17 04:14:06'),
(295, 'App\\Models\\User', 71, 'auth_token', 'fd065265d38331f521ae648deb656abe54e7449cf8542e849f77519e83b35e31', '[\"*\"]', NULL, '2022-06-17 04:14:41', '2022-06-17 04:14:41'),
(296, 'App\\Models\\User', 71, 'auth_token', 'acb47088ac5fd95417961d2233e067cfa554166a38c3532f98da1302b159864a', '[\"*\"]', NULL, '2022-06-17 04:14:41', '2022-06-17 04:14:41'),
(297, 'App\\Models\\User', 71, 'auth_token', '81592fd64c22b9d869d771f249c21e2468561d083c56dc14eafa644d76cd03a9', '[\"*\"]', '2022-06-17 04:15:05', '2022-06-17 04:15:04', '2022-06-17 04:15:05'),
(298, 'App\\Models\\User', 55, 'auth_token', '3ca0e1825e672c0d054c97cc33418cd364e7ddd20b4f834f5c5c1122b1494a7f', '[\"*\"]', '2022-06-22 17:49:34', '2022-06-17 04:18:55', '2022-06-22 17:49:34'),
(299, 'App\\Models\\User', 70, 'auth_token', 'c35d266b5468b19437d63825d44c948753bfe4eede08235b456dd85b1f3c70f0', '[\"*\"]', '2022-06-17 04:23:13', '2022-06-17 04:20:41', '2022-06-17 04:23:13'),
(300, 'App\\Models\\User', 72, 'auth_token', 'c4440f703d7ee07851aa9592505e74e0d0a82e7e5a6ae494ea0e4fc5cb693572', '[\"*\"]', NULL, '2022-06-18 12:20:22', '2022-06-18 12:20:22'),
(301, 'App\\Models\\User', 72, 'auth_token', '8ce03c35abf604a3637cf0db5bdc32a3e6a8cbe7e152acf10e8937abad7760bf', '[\"*\"]', NULL, '2022-06-18 12:20:22', '2022-06-18 12:20:22'),
(302, 'App\\Models\\User', 72, 'auth_token', 'e0d5073165398b893295347f027464dc87a7b363e939933cff9e0bd9578fb719', '[\"*\"]', '2022-06-18 12:23:37', '2022-06-18 12:20:27', '2022-06-18 12:23:37'),
(303, 'App\\Models\\User', 73, 'auth_token', '28b745bd380d5bef066d141d3fd0cb34d6348b1fb55255ac31c1813f4a57dbaa', '[\"*\"]', NULL, '2022-06-20 18:19:30', '2022-06-20 18:19:30'),
(304, 'App\\Models\\User', 73, 'auth_token', '5807739109d5453baec56874c23be70eb126145f61739816def2ff0da7d96b62', '[\"*\"]', NULL, '2022-06-20 18:19:30', '2022-06-20 18:19:30'),
(305, 'App\\Models\\User', 73, 'auth_token', 'f8689e1e7c18c5b28e09b803b01ff6d9b425e3aa5d5859b72b214f494d33cafd', '[\"*\"]', NULL, '2022-06-20 18:19:43', '2022-06-20 18:19:43'),
(306, 'App\\Models\\User', 73, 'auth_token', '2779b9220217bceb4a8a65570d274180534d6781ef98139f13bffcc1031615dd', '[\"*\"]', NULL, '2022-06-21 05:07:16', '2022-06-21 05:07:16'),
(307, 'App\\Models\\User', 63, 'auth_token', 'e0a85477f06d520a1b9b1e850c65ac76cc08effd4c4bb214754bc802c3cbeb4d', '[\"*\"]', '2022-07-03 13:38:03', '2022-06-22 03:21:39', '2022-07-03 13:38:03'),
(308, 'App\\Models\\User', 74, 'auth_token', '4866af795f8dd31773273066ee53ba7597b193ce514da94e3eaf29ad4d8927d1', '[\"*\"]', NULL, '2022-06-22 04:27:26', '2022-06-22 04:27:26'),
(309, 'App\\Models\\User', 74, 'auth_token', '4304159e5d984253d392d87b7097303d74dced032f0534ae0f5152f4443e193e', '[\"*\"]', NULL, '2022-06-22 04:27:26', '2022-06-22 04:27:26'),
(310, 'App\\Models\\User', 75, 'auth_token', 'dbfe8a171aac21d5f11313785cf4df43f43f88f00fa49eef950c818d82f8569d', '[\"*\"]', NULL, '2022-06-22 04:29:13', '2022-06-22 04:29:13'),
(311, 'App\\Models\\User', 75, 'auth_token', 'c567e4504f1f81e0af3f321f122e1c2df3e1dda021c334e2cb3b5003b4336575', '[\"*\"]', NULL, '2022-06-22 04:29:13', '2022-06-22 04:29:13'),
(312, 'App\\Models\\User', 75, 'auth_token', '4824d969fe23bcf284fb649dd3fed6e36d9d5ed801208490cd9977ecfaf637d4', '[\"*\"]', NULL, '2022-06-22 04:30:10', '2022-06-22 04:30:10'),
(313, 'App\\Models\\User', 75, 'auth_token', '8cad0a42ac6d69722212371e2f45cbc4de952eb9bbafb587ee071040c1fa72f3', '[\"*\"]', '2022-06-22 04:57:03', '2022-06-22 04:30:11', '2022-06-22 04:57:03'),
(314, 'App\\Models\\User', 76, 'auth_token', '457fe8baabb34518b9ee717145b4cc65f88e8d203f1ea8ff4d2a79c88bfe78b5', '[\"*\"]', NULL, '2022-06-22 04:58:12', '2022-06-22 04:58:12'),
(315, 'App\\Models\\User', 76, 'auth_token', 'cbde1d8ae91954023c5db70df2a6dede4c1aaff1fd59d63e2976f7b866c7826b', '[\"*\"]', NULL, '2022-06-22 04:58:12', '2022-06-22 04:58:12'),
(316, 'App\\Models\\User', 77, 'auth_token', 'c92dba27187efadb9cea65a607c75d92a19a313aa0e6531de22d3e84e80460f9', '[\"*\"]', NULL, '2022-06-22 04:59:37', '2022-06-22 04:59:37'),
(317, 'App\\Models\\User', 77, 'auth_token', '697f7a3b1db7e3b23af1ab31a75000aff944f75f245f8c3ccd11b85605571f3c', '[\"*\"]', NULL, '2022-06-22 04:59:37', '2022-06-22 04:59:37'),
(318, 'App\\Models\\User', 78, 'auth_token', 'a9d269df4947739a944babc9708e03bd1d88057dd0007e669bad5c7aafcbf5d8', '[\"*\"]', NULL, '2022-06-22 05:23:56', '2022-06-22 05:23:56'),
(319, 'App\\Models\\User', 78, 'auth_token', '7a7dd67ba5bfeeeedf7a0ff497fbdd13cc96bc5f96d517eb3aef13eb1aaf166a', '[\"*\"]', NULL, '2022-06-22 05:23:56', '2022-06-22 05:23:56'),
(320, 'App\\Models\\User', 75, 'auth_token', 'd450f1a056ad97718d3bf13469a6687bba1b7371d2cee007baec8b999b1a2b3e', '[\"*\"]', '2022-06-22 05:28:47', '2022-06-22 05:28:44', '2022-06-22 05:28:47'),
(321, 'App\\Models\\User', 79, 'auth_token', 'fa330fbe713427dcdb5c86aefdaa492a2b5d94880eab464fdcf39bd7576d52f9', '[\"*\"]', NULL, '2022-06-22 06:25:48', '2022-06-22 06:25:48'),
(322, 'App\\Models\\User', 79, 'auth_token', 'ef205d370a1caed2cfeea5604e1d6d1a2f64c7da5f3ec93f902a70d270ba1f1c', '[\"*\"]', NULL, '2022-06-22 06:25:48', '2022-06-22 06:25:48'),
(323, 'App\\Models\\User', 79, 'auth_token', '1a143d13050cbc907ac169f1c521e9e99d963012e3fc069db6521305a466ba08', '[\"*\"]', '2022-06-22 06:27:33', '2022-06-22 06:26:27', '2022-06-22 06:27:33'),
(324, 'App\\Models\\User', 80, 'auth_token', 'f629cb05032e25715b77adde89982cebff8c23b132014c29a153dd2c05625808', '[\"*\"]', NULL, '2022-06-22 07:01:41', '2022-06-22 07:01:41'),
(325, 'App\\Models\\User', 80, 'auth_token', '729a9e1e36234b12009a40d9e2bde426d92fc4eb94e18e6e09e4596f47b501ac', '[\"*\"]', NULL, '2022-06-22 07:01:41', '2022-06-22 07:01:41'),
(326, 'App\\Models\\User', 81, 'auth_token', '3d27d9745d72372004c080598b61dcbfb12a67ce7ea0e91f08970661f6fa1bb6', '[\"*\"]', NULL, '2022-06-22 07:03:15', '2022-06-22 07:03:15'),
(327, 'App\\Models\\User', 81, 'auth_token', 'ab3e8923fafd316298f56f9e3903f51a63aeaf1a23c5231e7b0fbe96aeba612b', '[\"*\"]', NULL, '2022-06-22 07:03:15', '2022-06-22 07:03:15'),
(328, 'App\\Models\\User', 82, 'auth_token', '421ea48f89b7dcc307a4cd28480ef52078aab66b540059513728c4d218a569ca', '[\"*\"]', NULL, '2022-06-22 07:03:49', '2022-06-22 07:03:49'),
(329, 'App\\Models\\User', 82, 'auth_token', 'b359f6f0607d185946d673d6b9e1f7bdf92842c84fbfd8d5ed9622c3f1d94238', '[\"*\"]', NULL, '2022-06-22 07:03:49', '2022-06-22 07:03:49'),
(330, 'App\\Models\\User', 75, 'auth_token', '6861f1913bf39f204db987f7ac4ee895e5751467b6b576db400d1a27734d9b97', '[\"*\"]', '2022-06-24 22:00:28', '2022-06-24 22:00:24', '2022-06-24 22:00:28'),
(331, 'App\\Models\\User', 72, 'auth_token', '640e3c49ede425a8e79c3f2f7411ebabfb06f5d5f3d0173af334db480a16e988', '[\"*\"]', NULL, '2022-06-28 15:03:00', '2022-06-28 15:03:00'),
(332, 'App\\Models\\User', 63, 'auth_token', '98a8224f7cb518f789214f87a8346bd37b4478f685511580aaa5f168ae9db6e8', '[\"*\"]', NULL, '2022-07-03 14:13:09', '2022-07-03 14:13:09'),
(333, 'App\\Models\\User', 83, 'auth_token', 'efd9820675271b3f953b4d8df3276491de6e0561df90df3c73f164cead69a2c8', '[\"*\"]', NULL, '2022-07-05 16:26:52', '2022-07-05 16:26:52'),
(334, 'App\\Models\\User', 83, 'auth_token', 'f14a0408f709628e664fd3b5a434cf87097dc6653cb10ee95ec7ebd2e3e25615', '[\"*\"]', '2022-07-06 15:12:00', '2022-07-05 16:26:52', '2022-07-06 15:12:00'),
(335, 'App\\Models\\User', 83, 'auth_token', 'cec8d7eb5253815ef3d8679d4765d4afc34a77b6766ba3b6976c8dcbdda96822', '[\"*\"]', NULL, '2022-07-05 16:31:03', '2022-07-05 16:31:03'),
(336, 'App\\Models\\User', 83, 'auth_token', '5cdfb3f8e2019895b09b739c85228b52c777b614f3bee393637d63ce8c1e9036', '[\"*\"]', NULL, '2022-07-06 16:21:16', '2022-07-06 16:21:16'),
(337, 'App\\Models\\User', 83, 'auth_token', '05fe67bda591ebc72217e39a2a60568fec59331c1dbe86603915a72d6a789bcc', '[\"*\"]', '2022-07-07 07:53:34', '2022-07-06 17:31:02', '2022-07-07 07:53:34'),
(338, 'App\\Models\\User', 63, 'auth_token', '252544b242b4f6ac963e233a17deac4afe80ed05cbf82294501025784ef171e3', '[\"*\"]', '2022-07-30 09:36:33', '2022-07-30 09:30:47', '2022-07-30 09:36:33'),
(339, 'App\\Models\\User', 63, 'auth_token', '6774e535e799c66f89ca7e3cc5340e18505fb97322c6e355f1a57e3ba0de3bea', '[\"*\"]', '2022-08-05 19:22:10', '2022-07-30 20:26:59', '2022-08-05 19:22:10'),
(340, 'App\\Models\\User', 84, 'auth_token', '040867b65e2ae78bfad2d8c1f526432cc74fbb31cc1fdfcd8bc309469389ecde', '[\"*\"]', NULL, '2022-07-31 04:03:46', '2022-07-31 04:03:46'),
(341, 'App\\Models\\User', 84, 'auth_token', 'e71ab27791c0e4179c75c4f0be4ce5181fdb233b203c15cb881ca0b2bc9c7dfd', '[\"*\"]', NULL, '2022-07-31 04:03:46', '2022-07-31 04:03:46'),
(342, 'App\\Models\\User', 84, 'auth_token', '158309c9c15a214a25917b21cbdb955680fabb985ef8402fdf24616bc306d2c2', '[\"*\"]', '2022-07-31 04:08:37', '2022-07-31 04:03:48', '2022-07-31 04:08:37'),
(343, 'App\\Models\\User', 63, 'auth_token', '62d1fff2ce928310bb13af52b2eb1b73cc5ce69e3f862cc87016f26ca2c250be', '[\"*\"]', '2022-08-01 15:14:52', '2022-08-01 15:14:21', '2022-08-01 15:14:52'),
(344, 'App\\Models\\User', 63, 'auth_token', '173c8fc7d3e3f421bb60c8fce4678a406995e679a3c54b0e931583bac104e74d', '[\"*\"]', '2022-08-01 15:16:09', '2022-08-01 15:15:02', '2022-08-01 15:16:09'),
(345, 'App\\Models\\User', 85, 'auth_token', 'fa10e8b7b6074ddb6d50b0fc07c53c1e3c733ca766b5d3e39ad70f60a0aa30bd', '[\"*\"]', NULL, '2022-08-01 15:18:01', '2022-08-01 15:18:01'),
(346, 'App\\Models\\User', 85, 'auth_token', 'd47c82ec146c4585f3abc0c0d16e982597086a57027fcad8535c1f8b41c1549c', '[\"*\"]', NULL, '2022-08-01 15:18:01', '2022-08-01 15:18:01'),
(347, 'App\\Models\\User', 86, 'auth_token', '5fb784765237755577b81bb23cecd97702553407f84081d3f9649108ba942cfd', '[\"*\"]', NULL, '2022-08-01 15:25:36', '2022-08-01 15:25:36'),
(348, 'App\\Models\\User', 86, 'auth_token', '88f3ce0c81aecfb539b8cc9e48f9c1551a4b8e51cd691f1f95e918e7d53cbbdf', '[\"*\"]', NULL, '2022-08-01 15:25:36', '2022-08-01 15:25:36'),
(349, 'App\\Models\\User', 87, 'auth_token', '641918fceb02dd74ee026f7bd4c7681592b9341a0ee3a48311153a8201fd8099', '[\"*\"]', NULL, '2022-08-01 15:27:19', '2022-08-01 15:27:19'),
(350, 'App\\Models\\User', 87, 'auth_token', 'e05a7cbcf5ec06cb28f5ae7a37176071a0486efcfb802d50107d741391c9808d', '[\"*\"]', NULL, '2022-08-01 15:27:19', '2022-08-01 15:27:19'),
(351, 'App\\Models\\User', 88, 'auth_token', 'e28f7756510930400e9c32675736cd798463b2f98e148b222551fa580a7ab9eb', '[\"*\"]', NULL, '2022-08-01 15:29:41', '2022-08-01 15:29:41'),
(352, 'App\\Models\\User', 88, 'auth_token', 'eb3e90677291db6b36fa9515010cc5b983e9ea8c69780490023f7ef0d4dea210', '[\"*\"]', NULL, '2022-08-01 15:29:41', '2022-08-01 15:29:41'),
(353, 'App\\Models\\User', 89, 'auth_token', '3f30b2197ce80d82d91138b264b8f337996d0330b9c6caee18467f1ed2b3c801', '[\"*\"]', NULL, '2022-08-01 15:31:08', '2022-08-01 15:31:08'),
(354, 'App\\Models\\User', 89, 'auth_token', '0f2f07f5608ef5fa6465b351b35d3e6bb25ad793154fc05d99acb8bb0529abc8', '[\"*\"]', NULL, '2022-08-01 15:31:08', '2022-08-01 15:31:08'),
(355, 'App\\Models\\User', 90, 'auth_token', 'b09e3736bbd31151831b3f914f4fb9f22e0a6fcbc9f82bfff55473e7e05fd00e', '[\"*\"]', NULL, '2022-08-01 15:32:57', '2022-08-01 15:32:57'),
(356, 'App\\Models\\User', 90, 'auth_token', '59b9ac1319841893214a08ecd7c6b69c5ac5e7b39aa8bc349ec2c2552b948448', '[\"*\"]', NULL, '2022-08-01 15:32:57', '2022-08-01 15:32:57'),
(357, 'App\\Models\\User', 63, 'auth_token', '0ab16968d2c757d295d498b428b7dc54a82b0cdb68b67ff823aecc36d518344d', '[\"*\"]', '2022-08-03 19:57:16', '2022-08-03 19:55:57', '2022-08-03 19:57:16'),
(358, 'App\\Models\\User', 91, 'auth_token', '5be80bf77adbbcf5d313be395183b02ce95005803979513c4a023fa5c7a865ac', '[\"*\"]', NULL, '2022-08-03 19:58:53', '2022-08-03 19:58:53'),
(359, 'App\\Models\\User', 91, 'auth_token', '878cdc1630e108047590e0e4d003817f6eb1795a5fe129f80866a92f723d7ba8', '[\"*\"]', NULL, '2022-08-03 19:58:53', '2022-08-03 19:58:53'),
(360, 'App\\Models\\User', 92, 'auth_token', '707caa0faddbafaed75c5c2b67a9ec9283363152da02fe5d680702f18835cf53', '[\"*\"]', NULL, '2022-08-03 22:54:05', '2022-08-03 22:54:05'),
(361, 'App\\Models\\User', 92, 'auth_token', '8418e9ee93bb581c130dc694e84645188de4ff6dee4d6ebee039deb6a354f5b1', '[\"*\"]', NULL, '2022-08-03 22:54:05', '2022-08-03 22:54:05'),
(362, 'App\\Models\\User', 92, 'auth_token', '04f885cac7442bf2e8123d3993fd106759205b782b52204337e74ec468bd3aad', '[\"*\"]', NULL, '2022-08-03 23:46:00', '2022-08-03 23:46:00'),
(363, 'App\\Models\\User', 92, 'auth_token', 'eab97fe530bf365af72396493da3568e929f58a88a3a7ac7415bdd3fb1ec9506', '[\"*\"]', NULL, '2022-08-03 23:46:04', '2022-08-03 23:46:04'),
(364, 'App\\Models\\User', 92, 'auth_token', '49a2d2e0df4513ffb3dc0fddf84590d79ed233334414c5afc1f07a05e6ef0721', '[\"*\"]', NULL, '2022-08-03 23:46:06', '2022-08-03 23:46:06'),
(365, 'App\\Models\\User', 92, 'auth_token', '9477500203275f6136bf9488519595c6fa5483c17e3d0bf97e864d64ad916658', '[\"*\"]', NULL, '2022-08-03 23:46:07', '2022-08-03 23:46:07'),
(366, 'App\\Models\\User', 92, 'auth_token', '34e4b910e576c6098d40d350a3a6f3be5d1c76ef445b7778a87cf756b66683cb', '[\"*\"]', NULL, '2022-08-03 23:46:18', '2022-08-03 23:46:18'),
(367, 'App\\Models\\User', 92, 'auth_token', '8c044f530103a99c660cda8bcc90d7aea4dc1a150203b58f279ce4ac8d847df6', '[\"*\"]', NULL, '2022-08-03 23:46:32', '2022-08-03 23:46:32'),
(368, 'App\\Models\\User', 92, 'auth_token', '71dced38c6eb189ce5fe6561b1eb4f9583926b6c6e2b3047d4476dcb9f6dd4bf', '[\"*\"]', NULL, '2022-08-03 23:46:33', '2022-08-03 23:46:33'),
(369, 'App\\Models\\User', 92, 'auth_token', '8d56fb284434c7db3205f474c8a43860f500e9e9f5bc29a22f90b58ccc61a6d4', '[\"*\"]', NULL, '2022-08-03 23:46:34', '2022-08-03 23:46:34'),
(370, 'App\\Models\\User', 92, 'auth_token', 'f03bd8c00414113712f0dcaac81efffc787160c2782f103da94df7e00303f389', '[\"*\"]', NULL, '2022-08-03 23:46:34', '2022-08-03 23:46:34'),
(371, 'App\\Models\\User', 92, 'auth_token', '215d63d2331588c4e7b173bb9f7057ded1be275761f4c34576f51306be45e3ad', '[\"*\"]', NULL, '2022-08-03 23:46:34', '2022-08-03 23:46:34'),
(372, 'App\\Models\\User', 92, 'auth_token', '7fe481cc95e042fb0adf3065280abf9ed4b521ef2a14b85cd72c65ae4e067f46', '[\"*\"]', NULL, '2022-08-03 23:46:34', '2022-08-03 23:46:34'),
(373, 'App\\Models\\User', 92, 'auth_token', 'f8b4d074aca966041810f9721c416a4d596b2d67ed6f0b5f047182b82b5e3e13', '[\"*\"]', NULL, '2022-08-03 23:46:35', '2022-08-03 23:46:35'),
(374, 'App\\Models\\User', 92, 'auth_token', '7209742d11651cbb73cc373dfaec8c2da847a3b40f498959bf8391cb6bcfe198', '[\"*\"]', NULL, '2022-08-03 23:46:35', '2022-08-03 23:46:35'),
(375, 'App\\Models\\User', 92, 'auth_token', '69d9a48d64e791f1a0be26a398a585a658c949b5475b0c19f2b82769c31fb8ef', '[\"*\"]', NULL, '2022-08-03 23:46:36', '2022-08-03 23:46:36'),
(376, 'App\\Models\\User', 92, 'auth_token', '4d14c6e5906395efdc73fa6eb85691ceca023fbc19a4838606c1b4bb66957242', '[\"*\"]', NULL, '2022-08-03 23:59:27', '2022-08-03 23:59:27'),
(377, 'App\\Models\\User', 92, 'auth_token', '179c8917fafb2125ad66a661b9e8808fa6e4596c6279879908d6d1928433ffc5', '[\"*\"]', NULL, '2022-08-03 23:59:29', '2022-08-03 23:59:29'),
(378, 'App\\Models\\User', 93, 'auth_token', '9bd83ae5b7e0bd777c071c906eb0364092d46830b46552dee5433bb033a0bed6', '[\"*\"]', NULL, '2022-08-04 03:22:52', '2022-08-04 03:22:52'),
(379, 'App\\Models\\User', 93, 'auth_token', '234e51a621f607bc5761cb5ed8a3109f397cd4e6606834e2828b93a7bd50c7c3', '[\"*\"]', NULL, '2022-08-04 03:22:52', '2022-08-04 03:22:52'),
(380, 'App\\Models\\User', 94, 'auth_token', '21117dee2cdee1804c3f134e91f97d15719323bfc3ea2da26cc1cb34a2725812', '[\"*\"]', NULL, '2022-08-04 04:16:29', '2022-08-04 04:16:29'),
(381, 'App\\Models\\User', 94, 'auth_token', '4a85fe90209d2b1ad7231cf85bf45750ba3fca44380c49eb2f713850e7e72429', '[\"*\"]', NULL, '2022-08-04 04:16:29', '2022-08-04 04:16:29'),
(382, 'App\\Models\\User', 94, 'auth_token', 'e6049612b9696cf81b06cf39b5ae58450d79f5d4af9150935568ebaeda07c2bb', '[\"*\"]', '2022-08-04 04:18:58', '2022-08-04 04:17:05', '2022-08-04 04:18:58'),
(383, 'App\\Models\\User', 63, 'auth_token', 'd4b804fa06b976b9f8b037e03f61b4050d395821819277576530a7f5decfe504', '[\"*\"]', '2022-08-16 08:49:05', '2022-08-06 03:36:30', '2022-08-16 08:49:05'),
(384, 'App\\Models\\User', 63, 'auth_token', 'c520119b2e0606dc8cac1b763dbac630d85e77e911211b879e96dff288c929de', '[\"*\"]', '2022-08-06 03:42:17', '2022-08-06 03:39:39', '2022-08-06 03:42:17'),
(385, 'App\\Models\\User', 63, 'auth_token', '77e7e0299e7ebd149dff697dd0ec105cb616bf74f057ecd03dcbfcd12344b6fe', '[\"*\"]', NULL, '2022-08-18 17:59:35', '2022-08-18 17:59:35'),
(386, 'App\\Models\\User', 63, 'auth_token', 'cf8f4b955caceca16816da5e49f9f24be5f9c4c1135a757e4ab361474f749724', '[\"*\"]', NULL, '2022-08-18 17:59:38', '2022-08-18 17:59:38'),
(387, 'App\\Models\\User', 63, 'auth_token', 'c92ae23901432d46c2ef2a05d7c00760a79f719da4b4ec5d542ca580fd31e7ee', '[\"*\"]', NULL, '2022-08-18 17:59:54', '2022-08-18 17:59:54'),
(388, 'App\\Models\\User', 63, 'auth_token', 'eda0635e8ff500874f5be18e40c20fca5c6438b27a9beba98244e62d33db10a1', '[\"*\"]', '2022-08-25 17:58:15', '2022-08-18 18:00:36', '2022-08-25 17:58:15'),
(389, 'App\\Models\\User', 63, 'auth_token', 'e52dff791aa61784648a6a43e0d0bf0b90e917e2d927ccf6ab00d02f8b783a27', '[\"*\"]', NULL, '2022-08-28 09:19:26', '2022-08-28 09:19:26'),
(390, 'App\\Models\\User', 63, 'auth_token', '44f360e02b36af5e2c1ddfe943e2e026c678e02e6a855a65bc3307840bcca611', '[\"*\"]', '2022-08-29 17:32:37', '2022-08-28 09:19:26', '2022-08-29 17:32:37'),
(391, 'App\\Models\\User', 63, 'auth_token', 'e16779be6b5983da527809590d7d48d77677f4c8c2db11b7c53cb0866c385980', '[\"*\"]', '2022-08-29 17:35:33', '2022-08-29 17:35:18', '2022-08-29 17:35:33'),
(392, 'App\\Models\\User', 63, 'auth_token', '2ac74613714c11dcc996a12222cfbe56beb431c8428552c63793c421e6cc15b3', '[\"*\"]', '2022-09-05 16:09:19', '2022-08-29 17:35:55', '2022-09-05 16:09:19'),
(393, 'App\\Models\\User', 63, 'auth_token', '2091880937a632af7f91aa13cfc5e3d794f5c1e6c16e5fc8114261aa1a14aed7', '[\"*\"]', '2022-09-04 18:50:43', '2022-09-04 18:19:16', '2022-09-04 18:50:43'),
(394, 'App\\Models\\User', 63, 'auth_token', '1fba2541294dd38f7b280ce7705e1513be2319706b7c9e689a3b8b046db9090b', '[\"*\"]', '2022-09-05 16:39:44', '2022-09-05 16:39:42', '2022-09-05 16:39:44'),
(395, 'App\\Models\\User', 63, 'auth_token', '3221b7efb28d88d0c006b518481bc04fccc8199d56f238df6985007d4004e318', '[\"*\"]', '2022-09-05 16:40:58', '2022-09-05 16:40:55', '2022-09-05 16:40:58'),
(396, 'App\\Models\\User', 63, 'auth_token', '07617f95e529903635f7abcee8b991b632e8869cd1e16b7cbd96c46242fb5132', '[\"*\"]', '2022-09-25 15:41:49', '2022-09-05 17:20:28', '2022-09-25 15:41:49'),
(397, 'App\\Models\\User', 63, 'auth_token', '6e247cebc50aa3b3c8c19874a20730596435c8413ca26c5eb468691e0ea4dfc6', '[\"*\"]', NULL, '2022-09-07 11:23:21', '2022-09-07 11:23:21'),
(398, 'App\\Models\\User', 63, 'auth_token', '9b9e91330f9538c58bafc8e70ae3dab07d8dd1d7e04eb03c7ea6591fd4916d15', '[\"*\"]', '2022-09-07 13:44:14', '2022-09-07 11:23:24', '2022-09-07 13:44:14'),
(399, 'App\\Models\\User', 63, 'auth_token', 'b54a88bcfbe528deb2ff06e21e2f5ef1fbbc3fc0aab52ae3a2d045cb237bc4cd', '[\"*\"]', '2022-09-07 21:58:01', '2022-09-07 21:55:49', '2022-09-07 21:58:01'),
(400, 'App\\Models\\User', 63, 'auth_token', '75c801cbf753137e7c4435d1970388acf56b592ea51348e25595b2359ebf095c', '[\"*\"]', '2022-09-08 02:24:41', '2022-09-08 01:56:52', '2022-09-08 02:24:41'),
(401, 'App\\Models\\User', 63, 'auth_token', '3505ea4e6741c86bc6dba60348ed23f5ac5169d4e66d0a29fe555080e0bf629c', '[\"*\"]', NULL, '2022-09-24 21:26:30', '2022-09-24 21:26:30'),
(402, 'App\\Models\\User', 63, 'auth_token', '9f62d354b7ea376ce7b3e899bdead5fdd3277469273f8b5de4273a1a9b740b0d', '[\"*\"]', NULL, '2022-09-24 21:26:37', '2022-09-24 21:26:37'),
(403, 'App\\Models\\User', 63, 'auth_token', 'a7fe1f414e1449f71d916b1c63ff002a44397886fca2b35316a351cddf58986d', '[\"*\"]', NULL, '2022-09-24 21:45:23', '2022-09-24 21:45:23'),
(404, 'App\\Models\\User', 63, 'auth_token', '95a55d7eb150e555b9d0f3b8abd7fce5777d0486c4905cee9611908e7c2d0c00', '[\"*\"]', NULL, '2022-09-24 21:50:01', '2022-09-24 21:50:01'),
(405, 'App\\Models\\User', 63, 'auth_token', '699a6eb3a1efcac54c15d4c0e7a30733fb0cd97ef9f91031f639aa50a4aef18c', '[\"*\"]', NULL, '2022-09-24 21:50:47', '2022-09-24 21:50:47'),
(406, 'App\\Models\\User', 63, 'auth_token', 'e31ad220cf49db9e386f5ded46523a40d7fb7479fe444bf6f22e8cc946cbf4cc', '[\"*\"]', NULL, '2022-09-24 21:54:35', '2022-09-24 21:54:35'),
(407, 'App\\Models\\User', 63, 'auth_token', 'd0057441cfcf838e701d131d54a7c297e5f4af9bb2ee491339e07644912b5d83', '[\"*\"]', NULL, '2022-09-24 21:56:35', '2022-09-24 21:56:35'),
(408, 'App\\Models\\User', 63, 'auth_token', '4bd420a82a4b937efef0c1547d4793f646ddf43cc36acbf85e57500f10ba6c7d', '[\"*\"]', NULL, '2022-09-24 21:59:13', '2022-09-24 21:59:13'),
(409, 'App\\Models\\User', 63, 'auth_token', '5735f51144b0dbc2d3780723ecd66645450a1095350a9d1e79da6e78404ce0c2', '[\"*\"]', NULL, '2022-09-24 21:59:18', '2022-09-24 21:59:18'),
(410, 'App\\Models\\User', 63, 'auth_token', 'd8967e27c4d67e0b7d5d93ec6dbeeae3d9f52cd0d0472dd43c0ff5dad4823cfd', '[\"*\"]', NULL, '2022-09-24 21:59:38', '2022-09-24 21:59:38'),
(411, 'App\\Models\\User', 63, 'auth_token', 'c28a629ec46ebd11d9549808a896a4dc12db9de8293c5df6c3e38e9bf76283a8', '[\"*\"]', NULL, '2022-09-24 22:09:23', '2022-09-24 22:09:23'),
(412, 'App\\Models\\User', 63, 'auth_token', '42029c105f321bf177cb1a27d15bd9fd5f1421d89fccd2ce863c8713f8496736', '[\"*\"]', NULL, '2022-09-25 18:25:24', '2022-09-25 18:25:24'),
(413, 'App\\Models\\User', 63, 'auth_token', '0c0b2838f906ffb2f787d14c9cc97c8714250e0e1b84d9f8e685d3c2331955f1', '[\"*\"]', NULL, '2022-09-25 20:56:12', '2022-09-25 20:56:12'),
(414, 'App\\Models\\User', 63, 'auth_token', '5db8d72c0e7e94a0b5402a1ae11fafa81d5f07cee2345adf1d93d811167a48b0', '[\"*\"]', NULL, '2022-09-26 04:39:20', '2022-09-26 04:39:20'),
(415, 'App\\Models\\User', 63, 'auth_token', '7cb36566275e6d40ffce16df3aee78ffdc0ae54edb32a4027bbc916bc00b15e6', '[\"*\"]', NULL, '2022-09-26 04:39:32', '2022-09-26 04:39:32'),
(416, 'App\\Models\\User', 63, 'auth_token', 'e9898fba6c0582a815a853a62d201977ba77e209d8118ed3b838f0eb85e29ce8', '[\"*\"]', NULL, '2022-09-26 04:39:35', '2022-09-26 04:39:35'),
(417, 'App\\Models\\User', 63, 'auth_token', 'ea54a83e2443b11071a73adbcd51c3e96d53f0c48acc503e2ce847c3f1d5e586', '[\"*\"]', NULL, '2022-09-26 04:39:37', '2022-09-26 04:39:37'),
(418, 'App\\Models\\User', 63, 'auth_token', '10e131bcf16afaea16cef0539152c2648848d4e97c9f689094fe2f4592dabce8', '[\"*\"]', NULL, '2022-09-26 19:03:28', '2022-09-26 19:03:28'),
(419, 'App\\Models\\User', 63, 'auth_token', 'dd8e0bc62f38aef602d295bbdc1066b84f9b6f0cd009b1e3a40b2154adc4c7ec', '[\"*\"]', NULL, '2022-09-26 19:03:54', '2022-09-26 19:03:54'),
(420, 'App\\Models\\User', 63, 'auth_token', 'd50740687208a839458a4b219d1f2b874149119ae0b831ffec4b717610f51ab4', '[\"*\"]', NULL, '2022-09-26 19:04:57', '2022-09-26 19:04:57'),
(421, 'App\\Models\\User', 63, 'auth_token', '1b996f654877664b4da8485e2fe788d66c260314b4aa4337108e4e47050f8a0b', '[\"*\"]', NULL, '2022-09-26 19:06:41', '2022-09-26 19:06:41'),
(422, 'App\\Models\\User', 63, 'auth_token', 'b25b2eac4a15f0291ac2a2ce8b4db9075ecee005518d3e27471cf0089d91d03b', '[\"*\"]', NULL, '2022-09-26 19:32:14', '2022-09-26 19:32:14'),
(423, 'App\\Models\\User', 98, 'auth_token', '1395f86c9d52ff73956ed5762aca80897061d58e963461a03805b796dd3f89c6', '[\"*\"]', NULL, '2023-01-26 17:20:52', '2023-01-26 17:20:52'),
(424, 'App\\Models\\User', 99, 'auth_token', '76fc63bd1d489ac65e0655f9d0177e7ac4b2ebff807992817975635834269916', '[\"*\"]', NULL, '2023-03-05 17:46:57', '2023-03-05 17:46:57'),
(425, 'App\\Models\\User', 99, 'auth_token', '54b4e33d285d5665c6fb917521e3054c166fad3742d4dcadccc09df6ac6087f6', '[\"*\"]', NULL, '2023-03-05 17:46:57', '2023-03-05 17:46:57'),
(426, 'App\\Models\\User', 105, 'auth_token', 'a719d2349d2e4ffb1ad75b6cdff3bddb901a39a1dc50c6b6f35d1b5fb375a887', '[\"*\"]', NULL, '2023-09-08 10:59:08', '2023-09-08 10:59:08'),
(427, 'App\\Models\\User', 105, 'auth_token', 'fb6986c777224d0564083d62f6291ec8f8f05023c51c45d008381e99c5b7b218', '[\"*\"]', NULL, '2023-09-08 10:59:08', '2023-09-08 10:59:08'),
(428, 'App\\Models\\User', 105, 'auth_token', 'f7791fdb699aa1375ae434d8fc209c53030d043f37596528dd67626466969c64', '[\"*\"]', NULL, '2023-09-08 10:59:15', '2023-09-08 10:59:15'),
(429, 'App\\Models\\User', 105, 'auth_token', '0a65f9db5201e662c54b33b5626edd82dea5e5e534845829be719ea9dc44ac7b', '[\"*\"]', NULL, '2023-09-09 04:20:58', '2023-09-09 04:20:58'),
(430, 'App\\Models\\User', 105, 'auth_token', '3cfe9488552882d785a9c4fa25dc94c697f6a49db708161d450d6e8c586569df', '[\"*\"]', NULL, '2023-09-09 04:36:13', '2023-09-09 04:36:13'),
(431, 'App\\Models\\User', 105, 'auth_token', 'dd407bf19713e65273a51e2e45caa8d945c6e1ca655c582c4633522ccbabc5dc', '[\"*\"]', NULL, '2023-09-09 10:13:00', '2023-09-09 10:13:00'),
(432, 'App\\Models\\User', 105, 'auth_token', '38950ebf14e02c7e2a33bf30841d513b757fdc0f496fbc862e145f30fc9d5e32', '[\"*\"]', NULL, '2023-09-09 10:17:38', '2023-09-09 10:17:38'),
(433, 'App\\Models\\User', 105, 'auth_token', 'd75b40058ffaf00ae615424a33592916b757aeee2bf747dcabbe796bea44b61e', '[\"*\"]', NULL, '2023-09-09 10:20:18', '2023-09-09 10:20:18'),
(434, 'App\\Models\\User', 105, 'auth_token', '009ba54dc21d98085a547793affdcff8e175bbd597bbd091dc2de0656d114191', '[\"*\"]', NULL, '2023-09-09 11:03:52', '2023-09-09 11:03:52'),
(435, 'App\\Models\\User', 105, 'auth_token', 'ac09f02123a9b8a5e5442d4587e5e09d5e2a3bd707bc042e68cc494a5f650c03', '[\"*\"]', NULL, '2023-09-09 13:30:06', '2023-09-09 13:30:06'),
(436, 'App\\Models\\User', 105, 'auth_token', '1d9c823782673c62f66dc835d61389509320643e6d750fb59aa5f3de22766cf4', '[\"*\"]', NULL, '2023-09-09 13:32:25', '2023-09-09 13:32:25'),
(437, 'App\\Models\\User', 105, 'auth_token', 'd1d548f6c1fe2bcbdd150bb58ba770af489dac2514522059ac6cc3b28ddfeade', '[\"*\"]', NULL, '2023-09-09 13:32:57', '2023-09-09 13:32:57'),
(438, 'App\\Models\\User', 106, 'auth_token', '2b503e137d2158a70989f4209eaa314ad3aff38458d166133e51a6233bbe978b', '[\"*\"]', NULL, '2023-09-09 13:57:47', '2023-09-09 13:57:47'),
(439, 'App\\Models\\User', 106, 'auth_token', '2f5e19f634aabe5866f0759159e15e9419416124a20b7a1aeac496ecd6a05994', '[\"*\"]', NULL, '2023-09-09 13:57:47', '2023-09-09 13:57:47'),
(440, 'App\\Models\\User', 106, 'auth_token', '589dcadfc59a7b69384d12bcfb15c2cd6a66619b427069f9d5250c3b09cf6c92', '[\"*\"]', NULL, '2023-09-09 15:06:01', '2023-09-09 15:06:01'),
(441, 'App\\Models\\User', 106, 'auth_token', 'cb130cc00cf4f98019f00225b8ac6dd4b4ae5e3356f18b77b95aff96f3c06e2d', '[\"*\"]', NULL, '2023-09-09 15:07:25', '2023-09-09 15:07:25'),
(442, 'App\\Models\\User', 106, 'auth_token', '1c8537abe7f5bc5b18e27e4de4fddcf862f1cbb256b88163bb7ee2b79b0a7591', '[\"*\"]', NULL, '2023-09-09 15:07:46', '2023-09-09 15:07:46'),
(443, 'App\\Models\\User', 106, 'auth_token', '500d6065dd0947a7402d2915411c8e47dbf53210119c0641439513fb23f7177b', '[\"*\"]', NULL, '2023-09-09 15:11:27', '2023-09-09 15:11:27'),
(444, 'App\\Models\\User', 106, 'auth_token', '2704c5f9aa8d6984a6a3486066ec0ec17b600e83466b166808807c43164ec071', '[\"*\"]', NULL, '2023-09-09 15:22:36', '2023-09-09 15:22:36'),
(445, 'App\\Models\\User', 106, 'auth_token', '4325fd861a25fab0cde23af439e2462e6741ef941bfd01a0430b310a485e143a', '[\"*\"]', NULL, '2023-09-09 15:23:12', '2023-09-09 15:23:12'),
(446, 'App\\Models\\User', 106, 'auth_token', '46e0be653a8d75141a06c94aada1b19f98dc54bd6642a1b470997ec1a97ae5d2', '[\"*\"]', NULL, '2023-09-09 15:23:53', '2023-09-09 15:23:53'),
(447, 'App\\Models\\User', 106, 'auth_token', '5eb730bd33fa952c2ae7950bfa2a56dc55dbcd36b25342f7f5ba282344e7809b', '[\"*\"]', NULL, '2023-09-09 15:39:50', '2023-09-09 15:39:50'),
(448, 'App\\Models\\User', 106, 'auth_token', '9ffe284cb70166ddd4c9976c3458cdb52e79d371d0b406d841ad3e9ef6b41b4a', '[\"*\"]', NULL, '2023-09-09 15:40:21', '2023-09-09 15:40:21'),
(449, 'App\\Models\\User', 106, 'auth_token', '3d0a8feea7ff1bea02f1708b5e3eeaecb079e5f1d1bc92107f76c75bee47c4a6', '[\"*\"]', NULL, '2023-09-09 15:40:53', '2023-09-09 15:40:53'),
(450, 'App\\Models\\User', 106, 'auth_token', '6b16a84543ef088b9d8229c2c66e6f1279185c7779249d273e69c1b6cb1909de', '[\"*\"]', NULL, '2023-09-09 15:42:20', '2023-09-09 15:42:20'),
(451, 'App\\Models\\User', 106, 'auth_token', 'e973d9b1869a065f43017b3f59f4bfa441815778e09b2bc7edebffffdba464d3', '[\"*\"]', NULL, '2023-09-09 15:42:28', '2023-09-09 15:42:28'),
(452, 'App\\Models\\User', 106, 'auth_token', '7af648bdd4ed245a9fca784f7ce9354267baa3d499ddd14c2230048e97c0c870', '[\"*\"]', NULL, '2023-09-09 15:43:49', '2023-09-09 15:43:49'),
(453, 'App\\Models\\User', 106, 'auth_token', 'f6460f673cd57699436faa209d2848ed130404ca6b3af59262e11267d50083f2', '[\"*\"]', NULL, '2023-09-09 17:15:30', '2023-09-09 17:15:30'),
(454, 'App\\Models\\User', 106, 'auth_token', '88658c9bd84cea55356b2a8f12f489d94f405ea571d6a200bc814393f102f761', '[\"*\"]', NULL, '2023-09-09 17:15:47', '2023-09-09 17:15:47'),
(455, 'App\\Models\\User', 106, 'auth_token', '2e8790d529e5735a5ebcad69983eb89443702c96efe1a6c76dbb58e6a7bf35be', '[\"*\"]', NULL, '2023-09-09 17:18:47', '2023-09-09 17:18:47'),
(456, 'App\\Models\\User', 106, 'auth_token', '23a7a5f47718bb99bc96fef0bc6b98f682754593564baaac250a0b27b5da340c', '[\"*\"]', NULL, '2023-09-09 17:19:01', '2023-09-09 17:19:01'),
(457, 'App\\Models\\User', 106, 'auth_token', '04af540b14ea263c3806b4ee1e506778b87b991a4afd378122a7b70e3dcc8de6', '[\"*\"]', NULL, '2023-09-09 17:21:35', '2023-09-09 17:21:35'),
(458, 'App\\Models\\User', 106, 'auth_token', 'abe4e162003a661f78d86997cae78ea7d283ca3220099df147053e5caf560594', '[\"*\"]', NULL, '2023-09-09 17:21:59', '2023-09-09 17:21:59'),
(459, 'App\\Models\\User', 106, 'auth_token', '24d7169dbd3f9351a2cbd61135b3312807dd232e38aef9d224d94bf53ea60404', '[\"*\"]', NULL, '2023-09-09 17:45:45', '2023-09-09 17:45:45'),
(460, 'App\\Models\\User', 106, 'auth_token', '3654e63e21b92691c1ddb48d41df3b601d862010ab87355df254156acb7b04d3', '[\"*\"]', NULL, '2023-09-09 17:52:15', '2023-09-09 17:52:15'),
(461, 'App\\Models\\User', 106, 'auth_token', '0171460780e821649090cdec259b0cd009821314464af86db617d42d48be8486', '[\"*\"]', NULL, '2023-09-09 17:56:06', '2023-09-09 17:56:06'),
(462, 'App\\Models\\User', 106, 'auth_token', '81b09cdeccbe3f9a6b4d8d54ca45bc0d7c01c8e524e109d344f21b1ce094fce6', '[\"*\"]', NULL, '2023-09-09 17:57:02', '2023-09-09 17:57:02'),
(463, 'App\\Models\\User', 106, 'auth_token', 'e79e7b4597d705daaab6a981e692538d4770b89de805d8589916ad85c3e7b3f2', '[\"*\"]', NULL, '2023-09-09 17:57:55', '2023-09-09 17:57:55'),
(464, 'App\\Models\\User', 106, 'auth_token', '727b2d6f8d3c27dcd8c97358539c76f935aaa7307649e751141f20111d295f91', '[\"*\"]', NULL, '2023-09-09 18:00:19', '2023-09-09 18:00:19'),
(465, 'App\\Models\\User', 106, 'auth_token', '4caf573bf600e4655a07a763c4c198800962e9be2117bc8e79499be729d0e2b5', '[\"*\"]', NULL, '2023-09-09 18:04:11', '2023-09-09 18:04:11'),
(466, 'App\\Models\\User', 106, 'auth_token', '5096849497503157661d148da7e3eb2497d2d226e72c7d954861d95a07ba5a05', '[\"*\"]', NULL, '2023-09-09 18:04:56', '2023-09-09 18:04:56'),
(467, 'App\\Models\\User', 106, 'auth_token', '1516caca3effe6542b8e47ffbc5dd06c279144910a5cc6f92d5825114fc29cff', '[\"*\"]', '2023-09-10 08:38:36', '2023-09-09 18:29:56', '2023-09-10 08:38:36'),
(468, 'App\\Models\\User', 106, 'auth_token', 'b5ed316940676116d89fab18a9df70f8eb282b3840cd5e735603107629b3ddd1', '[\"*\"]', NULL, '2023-09-10 05:43:41', '2023-09-10 05:43:41'),
(469, 'App\\Models\\User', 101, 'auth_token', 'ead3c233aa709ae8dea06edfee996f9d7d112a5b1342d142eab5a2b2e4ba7cd0', '[\"*\"]', NULL, '2023-09-10 08:14:09', '2023-09-10 08:14:09'),
(470, 'App\\Models\\User', 101, 'auth_token', '0b563756f244e5d87d8bb245782c7b8ad1fa918e434d616eaa15a8776e457bfd', '[\"*\"]', NULL, '2023-09-10 08:14:41', '2023-09-10 08:14:41'),
(471, 'App\\Models\\User', 101, 'auth_token', 'f8fce29245d1474879271be540b72627e665cc150ffcf00cb86bec5bccd793d6', '[\"*\"]', NULL, '2023-09-10 08:48:22', '2023-09-10 08:48:22'),
(472, 'App\\Models\\User', 101, 'auth_token', '77953fcb55d9dc5b9ce1ec9977e33256b26e46188e4771e8b5f43d2204bfbfd1', '[\"*\"]', NULL, '2023-09-10 08:48:33', '2023-09-10 08:48:33'),
(473, 'App\\Models\\User', 101, 'auth_token', '18650447f1cc76a925ac6e29cd0cee729d5ece7e213b6a243233da73cabe7b36', '[\"*\"]', NULL, '2023-09-10 08:49:22', '2023-09-10 08:49:22'),
(474, 'App\\Models\\User', 101, 'auth_token', 'd3c97e102fbdfa05d02483700c0b53f451042bc76550cff1ae8255db99104312', '[\"*\"]', NULL, '2023-09-10 08:49:27', '2023-09-10 08:49:27'),
(475, 'App\\Models\\User', 101, 'auth_token', '2c8b4bad14313a0eea607d9466b6cba496ca575a6aad47e80e51b82da7c26249', '[\"*\"]', NULL, '2023-09-10 08:53:22', '2023-09-10 08:53:22'),
(476, 'App\\Models\\User', 101, 'auth_token', '1ef6e406d9e3096599a76807012e1beefe8a502492587487d163369add0f4451', '[\"*\"]', '2023-09-10 10:12:35', '2023-09-10 09:20:21', '2023-09-10 10:12:35'),
(477, 'App\\Models\\User', 107, 'auth_token', '19c22f40fc4996e832392913f60b6cac58ad294c47b160c4fe78aa9d5abb0f44', '[\"*\"]', NULL, '2023-09-10 14:34:50', '2023-09-10 14:34:50'),
(478, 'App\\Models\\User', 107, 'auth_token', '96d4528c0fafa28e8a3faaf5b552a0bde47fa4cc582c188741f17d48406f859d', '[\"*\"]', NULL, '2023-09-10 14:34:50', '2023-09-10 14:34:50'),
(479, 'App\\Models\\User', 107, 'auth_token', '9ac1ab65a1541d4d64efcdf18be1c8527c668ff5b3b7fb3875099ea0ff6b3ab4', '[\"*\"]', NULL, '2023-09-10 14:35:24', '2023-09-10 14:35:24'),
(480, 'App\\Models\\User', 107, 'auth_token', 'da877d4684e844bea1cee24a23e7332830a754fbb45529c300711caac72f6f40', '[\"*\"]', NULL, '2023-09-10 14:49:15', '2023-09-10 14:49:15'),
(481, 'App\\Models\\User', 107, 'auth_token', 'a77995ac883a793cf0a992c8cac5c21402c0b058c6a20a5befb6b7b48bc91111', '[\"*\"]', NULL, '2023-09-10 14:49:40', '2023-09-10 14:49:40'),
(482, 'App\\Models\\User', 107, 'auth_token', '907e5263ba5eda455fe6bc51722bf9f90c2bd4ed31dfcebbea5ac46c51ee6f4e', '[\"*\"]', NULL, '2023-09-10 14:49:48', '2023-09-10 14:49:48'),
(483, 'App\\Models\\User', 107, 'auth_token', 'cbcd707211d9ac0b8e6b75f5339fcd93bc5d14c045cce013bc0c12a937354508', '[\"*\"]', NULL, '2023-09-10 15:08:15', '2023-09-10 15:08:15'),
(484, 'App\\Models\\User', 107, 'auth_token', '188d56a39270623b37c27a590a7ac27cf49225ce8f6c4dba78a896d7eadd8f40', '[\"*\"]', NULL, '2023-09-10 15:08:32', '2023-09-10 15:08:32'),
(485, 'App\\Models\\User', 107, 'auth_token', '1f210b5805dd4092f5f4c6f5666117078e9a3d0501e045c4d9321ebac15a1e84', '[\"*\"]', NULL, '2023-09-10 15:10:40', '2023-09-10 15:10:40'),
(486, 'App\\Models\\User', 107, 'auth_token', 'cb77e129f8033fa93d3e85e2ee4169c44ded0a760040c30aa758acf277f3b73b', '[\"*\"]', NULL, '2023-09-10 15:21:28', '2023-09-10 15:21:28'),
(487, 'App\\Models\\User', 107, 'auth_token', 'e849a0b5e2f7f6f3e0cf5eee1976daa9a72eb948b1b749f10affe0b2c5f4f80e', '[\"*\"]', NULL, '2023-09-10 15:23:01', '2023-09-10 15:23:01'),
(488, 'App\\Models\\User', 108, 'auth_token', 'a6c4f740a7c1d106e58777e063e072432bd9a150a5adea25b356bce91688e898', '[\"*\"]', NULL, '2023-09-10 15:28:26', '2023-09-10 15:28:26'),
(489, 'App\\Models\\User', 108, 'auth_token', '36bf7f4742ee848a525e352f9d2003f345cee406d746e705b8940afff1d180a9', '[\"*\"]', NULL, '2023-09-10 15:28:26', '2023-09-10 15:28:26'),
(490, 'App\\Models\\User', 107, 'auth_token', 'fd126566ce32e6d33ce9448aa823bb7b6d3eda4630e085102aeb4d1f18f4d599', '[\"*\"]', NULL, '2023-09-10 15:44:53', '2023-09-10 15:44:53'),
(491, 'App\\Models\\User', 107, 'auth_token', '5121defb51af22266cbee9870e8188a2b37609a068864cec2f721660f2d1e47e', '[\"*\"]', NULL, '2023-09-10 15:45:35', '2023-09-10 15:45:35'),
(492, 'App\\Models\\User', 109, 'auth_token', '2c55888606f4508c647a93a7d2da04fcd3315719de185576c6cbac75247b084a', '[\"*\"]', NULL, '2023-09-10 15:57:55', '2023-09-10 15:57:55'),
(493, 'App\\Models\\User', 109, 'auth_token', 'f087b83cc703c975c43e19a5270da9c8ccc683ab10ff5118c3324ad1ecbe9954', '[\"*\"]', NULL, '2023-09-10 15:57:55', '2023-09-10 15:57:55'),
(494, 'App\\Models\\User', 106, 'auth_token', '4cda012b61cec31c7284dd1a1195d96d81ce2a68204257dc1361ed2bb0335441', '[\"*\"]', NULL, '2023-09-13 17:43:40', '2023-09-13 17:43:40'),
(495, 'App\\Models\\User', 106, 'auth_token', 'b1127005df2e13bde640505e65ebb5944839f3790e3922f91816a57d9723dbf9', '[\"*\"]', '2023-09-14 06:07:38', '2023-09-13 17:45:00', '2023-09-14 06:07:38'),
(496, 'App\\Models\\User', 110, 'auth_token', '6d2b93eb769d40e336a205e6bc86a6d7d294d6cbf4b24e06592fa83836ef1b09', '[\"*\"]', NULL, '2023-09-13 18:04:32', '2023-09-13 18:04:32'),
(497, 'App\\Models\\User', 110, 'auth_token', '40d555fe5a6d4c29507305e42fbe8e82f1367d5fc90ab34d856eb1b9480258d9', '[\"*\"]', NULL, '2023-09-13 18:04:32', '2023-09-13 18:04:32'),
(498, 'App\\Models\\User', 114, 'auth_token', '0ef1787fd04e8f63cdd9b8b0b1da16c04da0e72dded46416712c61bbe89ba40a', '[\"*\"]', NULL, '2023-09-13 18:08:02', '2023-09-13 18:08:02'),
(499, 'App\\Models\\User', 114, 'auth_token', '726654716e4c9a9c9bc273e7160d435fdcd22015e67382ae14bc6620095c8ed4', '[\"*\"]', NULL, '2023-09-13 18:08:02', '2023-09-13 18:08:02'),
(500, 'App\\Models\\User', 107, 'auth_token', 'c7c57b8b37c2e07a245387a7b4a864411d869996a868001f397647d5fa19e104', '[\"*\"]', '2023-09-14 15:33:02', '2023-09-14 07:04:06', '2023-09-14 15:33:02'),
(501, 'App\\Models\\User', 107, 'auth_token', 'b85ff14af55974ee2bbe50d968e7f7e638affbaae35b05ba92aba09d8c120273', '[\"*\"]', NULL, '2023-09-14 16:50:25', '2023-09-14 16:50:25'),
(502, 'App\\Models\\User', 106, 'auth_token', '3d8cf1ceb055b21313a780654f87557edd3a079c61654cd02900b1f2b1bcee38', '[\"*\"]', NULL, '2023-09-14 16:59:41', '2023-09-14 16:59:41'),
(503, 'App\\Models\\User', 115, 'auth_token', 'f339e824e6ccde12872cdb6499fb03d11861731c20daab87fa7922d072622f58', '[\"*\"]', NULL, '2023-09-14 17:03:34', '2023-09-14 17:03:34'),
(504, 'App\\Models\\User', 115, 'auth_token', 'e019ff34b640b6a7e2aa87c9f65d5a75b1c16534ab4403ca020c7a422661365f', '[\"*\"]', NULL, '2023-09-14 17:03:34', '2023-09-14 17:03:34'),
(505, 'App\\Models\\User', 106, 'auth_token', '2e968d3a49d784dc304ff796a25b44098faebfa2cce000b11544bad7204aabb7', '[\"*\"]', NULL, '2023-09-14 17:16:46', '2023-09-14 17:16:46'),
(506, 'App\\Models\\User', 107, 'auth_token', '335243bfcd93c2c5a8d08d193dee18b46b98477f7fb2abce9d1b47fa839c7722', '[\"*\"]', NULL, '2023-09-14 17:16:52', '2023-09-14 17:16:52'),
(507, 'App\\Models\\User', 106, 'auth_token', '577a9620371684c752245a7dd95fc1f3610bcbe66b020ce7fb4c736bfd14fa78', '[\"*\"]', NULL, '2023-09-14 17:17:00', '2023-09-14 17:17:00'),
(508, 'App\\Models\\User', 106, 'auth_token', 'c70fc928d216a6f1a1666377cc0ff1b6fbe8405965ae0c89add11f94f6d542dd', '[\"*\"]', NULL, '2023-09-14 17:17:38', '2023-09-14 17:17:38'),
(509, 'App\\Models\\User', 106, 'auth_token', '6bf187f822fc85baf78f52f5a8df87db4262a2b16f44a4d22cb882e24698fcee', '[\"*\"]', NULL, '2023-09-14 17:22:20', '2023-09-14 17:22:20'),
(510, 'App\\Models\\User', 106, 'auth_token', '9641f00d190c17c23c636e5ec03804588bc6efee57c831934bd8a0fa54dd9316', '[\"*\"]', NULL, '2023-09-14 17:30:16', '2023-09-14 17:30:16'),
(511, 'App\\Models\\User', 118, 'auth_token', '47d7c8584cb3d0c0930068c8d836fd01da1f2289e6254433db87d7e03e653f89', '[\"*\"]', NULL, '2023-09-15 18:20:50', '2023-09-15 18:20:50'),
(512, 'App\\Models\\User', 118, 'auth_token', '165bb339f2b2938ca342fc89060448c0b29bb016af82f60ad39a4371a3d95112', '[\"*\"]', NULL, '2023-09-15 18:20:50', '2023-09-15 18:20:50'),
(513, 'App\\Models\\User', 118, 'auth_token', '392894af89966cc70a92d527bc63686158cf37bc24c1b68ffd5d64cfa542d22d', '[\"*\"]', NULL, '2023-09-15 18:21:15', '2023-09-15 18:21:15'),
(514, 'App\\Models\\User', 118, 'auth_token', 'ada17f9ce7b481bda6a529eccb4b64a91a88c65622fbb2f0ce9c9bc6ddb36807', '[\"*\"]', NULL, '2023-09-15 18:23:11', '2023-09-15 18:23:11'),
(515, 'App\\Models\\User', 118, 'auth_token', '465a3f52546dc07caedbc0f712a348f5f2c5525dba68ded4e0c8be6e5206ce48', '[\"*\"]', '2023-09-15 18:25:48', '2023-09-15 18:25:20', '2023-09-15 18:25:48'),
(516, 'App\\Models\\User', 118, 'auth_token', '26235f9483adc52a5bf919908c0343cbbb999a212778dad963734af7722ab894', '[\"*\"]', '2023-09-17 09:46:44', '2023-09-15 18:25:46', '2023-09-17 09:46:44'),
(517, 'App\\Models\\User', 119, 'auth_token', 'dfb27f3982cb1fa573098ef111fda3b94f8c2156612b06facc7a70256e00b221', '[\"*\"]', NULL, '2023-09-16 18:25:47', '2023-09-16 18:25:47'),
(518, 'App\\Models\\User', 119, 'auth_token', '22ef9c071d8c09342451d74f2275edb89c1ca1513d12e5550e298fdf16b5b218', '[\"*\"]', NULL, '2023-09-16 18:25:47', '2023-09-16 18:25:47'),
(519, 'App\\Models\\User', 107, 'auth_token', '0cc58fccfbd4a1f17819cd119efe3ef73d146f4a348fb9fb87b79273038703d7', '[\"*\"]', '2023-09-17 11:06:10', '2023-09-17 09:49:46', '2023-09-17 11:06:10'),
(520, 'App\\Models\\User', 122, 'auth_token', 'c2893797d5837285cebac284626aa27673999b3160bc650c9c708641f5301307', '[\"*\"]', NULL, '2023-09-17 11:05:53', '2023-09-17 11:05:53'),
(521, 'App\\Models\\User', 122, 'auth_token', 'de7316014b25e992101a1feec79e19605aa892e3d48eaf3cf457f478d8535e1f', '[\"*\"]', NULL, '2023-09-17 11:05:53', '2023-09-17 11:05:53'),
(522, 'App\\Models\\User', 122, 'auth_token', 'f42909cb353a6e97ff6bce7274d1f2c394861f129613a1f2ba075ce68e2c46e0', '[\"*\"]', '2023-09-17 15:03:02', '2023-09-17 11:08:08', '2023-09-17 15:03:02'),
(523, 'App\\Models\\User', 123, 'auth_token', '652d97b32562372a7d9cb6ceeee5c1b22e7b23390a73807853e6f96491469137', '[\"*\"]', NULL, '2023-09-17 11:57:39', '2023-09-17 11:57:39'),
(524, 'App\\Models\\User', 123, 'auth_token', 'f6d6aa77ea58570744f2503cb08701980ce42bf4588fcbb81a9f5582e8f27c2d', '[\"*\"]', NULL, '2023-09-17 11:57:39', '2023-09-17 11:57:39'),
(525, 'App\\Models\\User', 124, 'auth_token', '4feab8ebda7a41b829e667a03f99eeea3bb45788a415126093abea3a5e770045', '[\"*\"]', NULL, '2023-09-17 17:26:38', '2023-09-17 17:26:38'),
(526, 'App\\Models\\User', 124, 'auth_token', '282727702db3a44e2244ad9ba3f479791e073912158e5960e292e1db2434f604', '[\"*\"]', NULL, '2023-09-17 17:26:38', '2023-09-17 17:26:38'),
(527, 'App\\Models\\User', 124, 'auth_token', 'ef5378e99f77a411067dca9f7108ce753990e9f8c4f4db2870a5fbfbbed1661d', '[\"*\"]', '2023-10-01 10:42:56', '2023-09-17 17:26:54', '2023-10-01 10:42:56'),
(528, 'App\\Models\\User', 107, 'auth_token', '67b2691358b34cf554b106a59b44d3808f667353174e1cdf089ff4da8f75d591', '[\"*\"]', '2023-09-29 18:14:04', '2023-09-29 18:11:52', '2023-09-29 18:14:04'),
(529, 'App\\Models\\User', 107, 'auth_token', '987bbdefe593c76e1235bf9e8f5449bbc41159b04a06e8442ae52cb98295759c', '[\"*\"]', '2023-09-29 18:13:23', '2023-09-29 18:13:22', '2023-09-29 18:13:23');

-- --------------------------------------------------------

--
-- Table structure for table `phone_verifications`
--

CREATE TABLE `phone_verifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `country_code` varchar(30) NOT NULL,
  `contact_number` varchar(30) NOT NULL,
  `token` varchar(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `phone_verifications`
--

INSERT INTO `phone_verifications` (`id`, `country_code`, `contact_number`, `token`, `created_at`, `updated_at`) VALUES
(2, '+91', '+917874625621', '9540', '2023-02-01 05:28:49', '2023-03-05 17:47:30');

-- --------------------------------------------------------

--
-- Table structure for table `plans`
--

CREATE TABLE `plans` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(191) NOT NULL,
  `identifier` varchar(191) NOT NULL,
  `type` varchar(191) NOT NULL,
  `trial_period` bigint(20) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `duration` text DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plan_type` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `plans`
--

INSERT INTO `plans` (`id`, `title`, `identifier`, `type`, `trial_period`, `amount`, `status`, `created_at`, `updated_at`, `duration`, `description`, `plan_type`) VALUES
(1, 'Free plan', 'free', 'weekly', 7, 0, 1, '2022-03-10 16:26:15', '2022-03-10 16:26:15', NULL, NULL, NULL),
(2, 'Basic plan', 'basic', 'monthly', NULL, 10, 1, '2022-03-10 16:26:15', '2022-03-10 16:26:15', NULL, NULL, NULL),
(3, 'Premium plan', 'premium', 'yearly', NULL, 100, 1, '2022-03-10 16:26:15', '2022-03-10 16:26:15', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `plan_limits`
--

CREATE TABLE `plan_limits` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `plan_id` bigint(20) UNSIGNED DEFAULT NULL,
  `plan_limitation` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provider_address_mappings`
--

CREATE TABLE `provider_address_mappings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `provider_id` bigint(20) UNSIGNED DEFAULT NULL,
  `address` text DEFAULT NULL,
  `latitude` text DEFAULT NULL,
  `longitude` text DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provider_bank_accounts`
--

CREATE TABLE `provider_bank_accounts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `bank_name` varchar(500) NOT NULL,
  `account_number` varchar(100) NOT NULL,
  `ifsc_code` varchar(30) DEFAULT NULL,
  `transit_no` varchar(100) DEFAULT NULL,
  `institution_no` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `provider_bank_accounts`
--

INSERT INTO `provider_bank_accounts` (`id`, `user_id`, `bank_name`, `account_number`, `ifsc_code`, `transit_no`, `institution_no`, `created_at`, `updated_at`) VALUES
(38, 408, 'Bandhan bank', '9876543214569874', NULL, '12345', '12356789', '2023-12-16 09:11:38', '2023-12-20 16:14:24');

-- --------------------------------------------------------

--
-- Table structure for table `provider_documents`
--

CREATE TABLE `provider_documents` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `provider_id` bigint(20) UNSIGNED NOT NULL,
  `document_number` varchar(500) DEFAULT NULL,
  `document_back_photo` text DEFAULT NULL,
  `document_front_photo` text DEFAULT NULL,
  `document_id` bigint(20) UNSIGNED NOT NULL,
  `is_verified` tinyint(4) DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `provider_documents`
--

INSERT INTO `provider_documents` (`id`, `provider_id`, `document_number`, `document_back_photo`, `document_front_photo`, `document_id`, `is_verified`, `deleted_at`, `created_at`, `updated_at`) VALUES
(91, 408, '123456987456', 'https://ik.imagekit.io/5o2uz1trj/65831f2e2029b_m9U64R0e5.jpg', 'https://ik.imagekit.io/5o2uz1trj/65831f2d0b7af_-Sst9xEl9.jpg', 8, 0, NULL, '2023-12-16 09:12:17', '2023-12-20 17:06:55'),
(92, 408, 'ABCDE1234F', 'https://ik.imagekit.io/5o2uz1trj/65831f4a000ad_sVGFmkSXF.jpg', 'https://ik.imagekit.io/5o2uz1trj/65831f48d3c52_jOu-UaleK.jpg', 9, 0, NULL, '2023-12-16 09:13:21', '2023-12-20 17:07:23'),
(93, 408, '123-456-789', NULL, 'https://ik.imagekit.io/5o2uz1trj/65831f597e932_O4r0a-KAT.jpg', 10, 0, NULL, '2023-12-16 09:13:45', '2023-12-20 17:07:38');

-- --------------------------------------------------------

--
-- Table structure for table `provider_payouts`
--

CREATE TABLE `provider_payouts` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `provider_id` bigint(20) UNSIGNED DEFAULT NULL,
  `payment_method` text DEFAULT NULL,
  `description` text DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `paid_date` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provider_service_address_mappings`
--

CREATE TABLE `provider_service_address_mappings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `service_id` bigint(20) UNSIGNED DEFAULT NULL,
  `provider_address_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provider_subscriptions`
--

CREATE TABLE `provider_subscriptions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `plan_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `title` varchar(191) NOT NULL,
  `identifier` varchar(191) NOT NULL,
  `type` varchar(191) NOT NULL,
  `start_at` datetime DEFAULT NULL,
  `end_at` datetime DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `status` varchar(191) DEFAULT NULL,
  `payment_id` varchar(191) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `plan_limitation` text DEFAULT NULL,
  `duration` text DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `plan_type` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provider_taxes`
--

CREATE TABLE `provider_taxes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `provider_id` bigint(20) UNSIGNED DEFAULT NULL,
  `tax_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `provider_types`
--

CREATE TABLE `provider_types` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `commission` double DEFAULT 0,
  `status` tinyint(4) DEFAULT 1,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `provider_types`
--

INSERT INTO `provider_types` (`id`, `name`, `commission`, `status`, `deleted_at`, `created_at`, `updated_at`, `type`) VALUES
(4, 'hair spa', 10, 1, NULL, '2023-03-29 09:14:34', '2023-03-29 09:14:34', 'percent');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `guard_name` varchar(191) NOT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `guard_name`, `status`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'web', 1, '2021-06-03 16:23:01', '2021-06-03 16:23:03'),
(2, 'demo_admin', 'web', 1, '2021-06-03 16:23:16', '2021-06-04 14:24:13'),
(3, 'user', 'web', 1, '2021-06-04 14:31:46', '2021-06-04 14:31:46'),
(4, 'provider', 'web', 1, '2021-06-04 14:31:46', '2023-07-22 12:48:36'),
(5, 'handyman', 'web', 0, '2021-06-04 14:31:46', '2023-07-22 18:42:08');

-- --------------------------------------------------------

--
-- Table structure for table `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(8, 4),
(9, 1),
(9, 2),
(9, 4),
(10, 1),
(10, 2),
(10, 4),
(11, 1),
(11, 2),
(11, 4),
(12, 1),
(13, 1),
(13, 4),
(14, 1),
(14, 4),
(15, 1),
(15, 4),
(16, 1),
(16, 4),
(17, 1),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(22, 1),
(23, 1),
(23, 4),
(24, 1),
(24, 4),
(25, 1),
(25, 4),
(26, 1),
(27, 1),
(28, 1),
(28, 2),
(28, 3),
(28, 4),
(29, 1),
(29, 4),
(30, 1),
(30, 4),
(31, 1),
(31, 2),
(31, 3),
(31, 4),
(32, 1),
(33, 1),
(33, 2),
(33, 3),
(33, 4),
(34, 1),
(35, 1),
(36, 1),
(37, 1),
(38, 1),
(39, 1),
(40, 1),
(41, 1),
(42, 1),
(43, 1),
(44, 1),
(44, 2),
(45, 1),
(46, 1),
(47, 1),
(48, 1),
(49, 1),
(49, 2),
(50, 1),
(51, 1),
(52, 1),
(53, 1),
(54, 1),
(54, 4),
(55, 1),
(56, 1),
(57, 1),
(58, 1),
(59, 1),
(60, 1),
(61, 1),
(62, 1),
(63, 1),
(64, 1),
(65, 1),
(66, 1),
(67, 1),
(68, 1),
(69, 1),
(69, 4),
(70, 1),
(70, 4),
(71, 1),
(71, 4),
(72, 1),
(72, 4),
(75, 1),
(76, 1),
(77, 1),
(78, 1),
(79, 1),
(80, 1),
(81, 1),
(82, 1),
(83, 1),
(83, 2),
(83, 4),
(84, 1),
(84, 2),
(84, 4),
(85, 1),
(85, 2),
(85, 4),
(86, 1),
(86, 2),
(86, 4);

-- --------------------------------------------------------

--
-- Table structure for table `service_faqs`
--

CREATE TABLE `service_faqs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `service_id` bigint(20) UNSIGNED DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1 COMMENT '1- Active , 0- InActive',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `service_proofs`
--

CREATE TABLE `service_proofs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `service_id` bigint(20) UNSIGNED DEFAULT NULL,
  `booking_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` varchar(191) DEFAULT NULL,
  `key` varchar(191) NOT NULL,
  `value` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `type`, `key`, `value`) VALUES
(1, 'ADMOB', 'ADMOB_APP_ID', NULL),
(2, 'ADMOB', 'ADMOB_BANNER_ID', NULL),
(3, 'ADMOB', 'ADMOB_INTERSTITIAL_ID', NULL),
(4, 'COLOR', 'COLOR_PRIMARY_COLOR', '#000000'),
(5, 'COLOR', 'COLOR_SECONDARY_COLOR', '#000000'),
(6, 'CURRENCY', 'CURRENCY_COUNTRY_ID', '38'),
(7, 'CURRENCY', 'CURRENCY_POSITION', 'left'),
(8, 'ONESIGNAL', 'ONESIGNAL_API_KEY', 'cd33a6f7-e5bb-47c4-9c52-e25011f9cd49'),
(9, 'ONESIGNAL', 'ONESIGNAL_REST_API_KEY', 'YTgxMjQwN2EtYzQxNC00MGUwLThjOGEtZTU2YmYwOWFhNDI3'),
(10, 'DISTANCE', 'DISTANCE_TYPE', 'km'),
(11, 'DISTANCE', 'DISTANCE_RADIOUS', '50'),
(12, 'dashboard_setting', 'dashboard_setting', '{\"Top_Cards\":\"top_card\",\"Monthly_Revenue_card\":\"monthly_revenue_card\",\"Top_Services_card\":\"top_service_card\",\"New_Provider_card\":\"new_provider_card\",\"Upcoming_Booking_card\":\"upcoming_booking_card\",\"New_Customer_card\":\"new_customer_card\"}'),
(13, 'provider_dashboard_setting', 'provider_dashboard_setting', '{\"Top_Cards\":\"top_card\",\"Monthly_Revenue_card\":\"monthly_revenue_card\",\"Top_Services_card\":\"top_service_card\",\"New_Provider_card\":\"new_provider_card\",\"Upcoming_Booking_card\":\"upcoming_booking_card\",\"New_Customer_card\":\"new_customer_card\"}'),
(14, 'handyman_dashboard_setting', 'handyman_dashboard_setting', '{\"Top_Cards\":\"top_card\",\"Schedule_Card\":\"schedule_card\"}'),
(15, 'terms_condition', 'terms_condition', '<p>Termes et conditions:</p>\r\n<p>Merci d\'avoir choisi Je Veux Services Inc, un endroit id&eacute;al pour r&eacute;server un service professionnel &agrave; votre domicile, h&ocirc;tel ou bureau.</p>\r\n<p>Ces termes et conditions de service ainsi que tous les termes et politiques qui y sont mentionn&eacute;s (nos termes) constituent un accord juridiquement contraignant entre vous et Je Veux Services Inc.</p>\r\n<p>UTILISATION DE NOTRE SITE ET DE NOTRE APPLICATION</p>\r\n<p>Nos conditions r&eacute;gissent votre utilisation de notre site Web (&laquo; notre site &raquo;) ainsi que de notre application (&laquo; notre application &raquo;) et des services. En utilisant Notre Site, Notre Application ou les Services, vous acceptez de vous conformer &agrave; Nos Conditions.</p>\r\n<p>Veuillez lire attentivement et attentivement nos conditions. Si vous n\'acceptez pas nos conditions, vous ne devez pas effectuer de r&eacute;servation via Je Veux Services Inc pour un service professionnel ou acheter des produits via Je Veux Services Inc.</p>\r\n<p>DONN&Eacute;ES PERSONNELLES</p>\r\n<p>Afin de fournir les Services, nous pouvons collecter des donn&eacute;es personnelles aupr&egrave;s de vous. Avant de faire une r&eacute;servation ou un achat par notre interm&eacute;diaire, veuillez lire notre politique de confidentialit&eacute; disponible ici (Notre politique de confidentialit&eacute;).</p>\r\n<p>CONDITIONS DE CONSOMMATION</p>\r\n<p>Le r&egrave;glement de 2013 sur les contrats de consommation (informations, annulation et frais suppl&eacute;mentaires) exige que Je Veux Services Inc vous fournisse certaines informations cl&eacute;s pour qu\'il y ait un contrat juridiquement contraignant entre vous et nous. Ces informations sont pr&eacute;sent&eacute;es ci-dessous et sont &eacute;galement li&eacute;es dans l\'e-mail que nous vous enverrons pour confirmer toute r&eacute;servation que vous effectuez par notre interm&eacute;diaire aupr&egrave;s d\'un professionnel ind&eacute;pendant ou pour confirmer tout achat d\'un Produit.</p>\r\n<p>UTILISATION ADMISSIBLE</p>\r\n<p>Vous confirmez que vous avez l\'&acirc;ge l&eacute;gal pour acc&eacute;der et utiliser Notre Site, Notre Application et/ou les Services et que vous avez la capacit&eacute; juridique d\'accepter Nos Conditions. Vous n\'&ecirc;tes pas autoris&eacute; &agrave; utiliser les Services si vous avez moins de 18 ans. Nos Conditions s\'appliquent uniquement aux particuliers ; pour toute r&eacute;servation ou achat d\'entreprise.</p>\r\n<p>NOS SERVICES</p>\r\n<p>Je Veux Services Inc fournit un service de r&eacute;servation et d\'achat (les Services). Les Services vous permettent de r&eacute;server une gamme de services professionnels (Services professionnels) qui sont ex&eacute;cut&eacute;s dans chaque cas par des professionnels ind&eacute;pendants ind&eacute;pendants (Professionnels ind&eacute;pendants) et d\'acheter des biens connexes (&laquo; Produits &raquo;) qui sont fournis dans chaque cas. tous les cas par des d&eacute;taillants ind&eacute;pendants (&laquo; d&eacute;taillants &raquo;). En fournissant les Services, Je Veux Services Inc agit &agrave; titre d\'agent des Professionnels Ind&eacute;pendants et/ou des D&eacute;taillants. Je Veux Services Inc n\'a aucune responsabilit&eacute; pour les services professionnels ou les produits que vous r&eacute;servez ou achetez par notre interm&eacute;diaire : nous sommes simplement impliqu&eacute;s dans le processus de r&eacute;servation et/ou d\'achat, ainsi que la fourniture de services auxiliaires (y compris un service de r&eacute;servation en ligne) comme expliqu&eacute; ci-dessous. .</p>\r\n<p>Les Services que nous proposons vous permettent de rechercher sur Notre Site et d\'acheter des Services Professionnels et/ou des Produits aupr&egrave;s d\'un certain nombre de professionnels Ind&eacute;pendants et/ou de D&eacute;taillants. En vous permettant d\'acheter des Services Professionnels et/ou des Produits via Notre Site, nous agissons en tant qu\'agent commercial de ces professionnels et/ou D&eacute;taillants Ind&eacute;pendants. Dans le cadre des Services, nous fournissons &eacute;galement certains services auxiliaires tels que l\'assistance aux probl&egrave;mes de service client (toujours en notre qualit&eacute; d\'agent pour les professionnels ind&eacute;pendants et/ou les d&eacute;taillants).</p>\r\n<p>Cependant, comme indiqu&eacute; ci-dessus, le contrat d\'achat des Services Professionnels et/ou des Produits est conclu entre vous et le Professionnel Ind&eacute;pendant et/ou le D&eacute;taillant. Cela signifie que c\'est le professionnel ind&eacute;pendant ou le d&eacute;taillant (pas nous) qui est l&eacute;galement responsable de vous fournir le service professionnel et/ou le produit. Cependant, Je Veux Services Inc demeure responsable du respect de ses obligations envers vous conform&eacute;ment &agrave; Nos Conditions qui seront juridiquement contraignantes.</p>\r\n<p>Je Veux Services Inc fournira, sur demande, des services d\'interm&eacute;diaire entre vous et un professionnel ind&eacute;pendant et/ou un d&eacute;taillant en mati&egrave;re de service &agrave; la client&egrave;le ou de r&egrave;glement des diff&eacute;rends.</p>\r\n<p>ACCORDS POUR SERVICES PROFESSIONNELS ET/OU PRODUITS</p>\r\n<p>SERVICES PROFESSIONNELS</p>\r\n<p>Lorsqu\'il est r&eacute;serv&eacute; par notre interm&eacute;diaire, le service professionnel que vous recevez sera soumis aux conditions g&eacute;n&eacute;rales du professionnel ind&eacute;pendant (Conditions du professionnel ind&eacute;pendant). Vous recevrez et vous serez invit&eacute; &agrave; confirmer votre acceptation des conditions du professionnel ind&eacute;pendant lors de la r&eacute;servation par notre interm&eacute;diaire. Je Veux Services Inc n\'est pas partie aux Conditions du professionnel ind&eacute;pendant : ces conditions seront uniquement entre vous et le professionnel ind&eacute;pendant qui vous fournit votre service professionnel.</p>\r\n<p>DES PRODUITS</p>\r\n<p>Lorsque vous achetez un produit par notre interm&eacute;diaire, vous achetez directement aupr&egrave;s du d&eacute;taillant concern&eacute; (et non de nous) et la relation contractuelle relative &agrave; la vente sera uniquement entre vous et ce d&eacute;taillant. Nous n\'y participerons pas. Le d&eacute;taillant concern&eacute; sera responsable de la vente, de la livraison et des autres soins apr&egrave;s-vente et notre r&ocirc;le se limite &agrave; agir en tant qu\'agent commercial pour conclure la vente en acceptant votre commande et en encaissant ou en organisant l\'encaissement de votre paiement au nom de ce d&eacute;taillant.</p>\r\n<p>Notre r&eacute;ception du paiement int&eacute;gral de votre part acquittera votre dette envers le d&eacute;taillant concern&eacute; &agrave; l\'&eacute;gard de cette commande. Bien que nous puissions vous aider &agrave; r&eacute;soudre certains probl&egrave;mes pratiques au nom du d&eacute;taillant concern&eacute;, nous n\'avons aucune obligation contractuelle envers vous et vous n\'avez aucun droit contractuel contre nous concernant tout produit vendu par notre interm&eacute;diaire par un d&eacute;taillant.</p>\r\n<p>R&Eacute;SERVATION DE SERVICES PROFESSIONNELS</p>\r\n<p>Vous pouvez effectuer une r&eacute;servation via Notre Site ou via Notre Application en choisissant un professionnel Ind&eacute;pendant.</p>\r\n<p>Vous ne pouvez effectuer une r&eacute;servation que jusqu\'&agrave; deux mois &agrave; l\'avance.</p>\r\n<p>Vos informations de paiement vous seront demand&eacute;es au moment de la r&eacute;servation et le paiement sera collect&eacute; lors de la r&eacute;servation.</p>\r\n<p>Le paiement int&eacute;gral des frais de traitement est d&ucirc; au moment de la r&eacute;servation du service professionnel avec le professionnel ind&eacute;pendant par notre interm&eacute;diaire. Tous les d&eacute;tails des prix sont mentionn&eacute;s ci-dessous.</p>\r\n<p>Les frais de traitement appartiennent au professionnel ind&eacute;pendant qui fournit le service professionnel. Je Veux Services Inc, en tant qu\'agent du professionnel ind&eacute;pendant, per&ccedil;oit ou fait en sorte qu\'un tiers per&ccedil;oive en notre nom les frais de traitement aupr&egrave;s de vous. Notre r&eacute;ception de l\'int&eacute;gralit&eacute; des frais de traitement acquittera votre dette envers le professionnel ind&eacute;pendant concern&eacute; en ce qui concerne cette r&eacute;servation.</p>\r\n<p>Nous sommes mandat&eacute;s par des professionnels Ind&eacute;pendants pour conclure les r&eacute;servations en leur nom en tant que leur agent commercial. Une fois votre r&eacute;servation accept&eacute;e par nous au nom du et du Professionnel Ind&eacute;pendant, vous recevrez de notre part une confirmation de votre rendez-vous par email.</p>\r\n<p>En effectuant une r&eacute;servation, vous &ecirc;tes responsable de :</p>\r\n<p>Paiement int&eacute;gral des frais de traitement applicables ;</p>\r\n<p>S\'assurer que le professionnel ind&eacute;pendant a acc&egrave;s &agrave; vos locaux d&eacute;sign&eacute;s qui doivent, dans tous les cas, repr&eacute;senter un espace appropri&eacute; dans lequel le service professionnel peut &ecirc;tre effectu&eacute;, avec toutes les installations appropri&eacute;es (y compris un &eacute;clairage et un chauffage ad&eacute;quats) ; et</p>\r\n<p>Assurer la sant&eacute; et la s&eacute;curit&eacute; du professionnel ind&eacute;pendant dans vos locaux d&eacute;sign&eacute;s.</p>\r\n<p>PRODUITS D\'ACHAT :</p>\r\n<p>Les produits peuvent &ecirc;tre command&eacute;s en cliquant sur les articles que vous souhaitez acheter, puis en suivant les instructions qui appara&icirc;tront &agrave; l\'&eacute;cran. Vous pouvez &eacute;galement commander des Produits par l\'interm&eacute;diaire d\'un professionnel ind&eacute;pendant, qui initiera la commande en votre nom et vous recevrez un e-mail vous invitant &agrave; finaliser la commande. Vous pouvez v&eacute;rifier et corriger toute erreur de saisie dans votre commande jusqu\'au moment o&ugrave; vous soumettez votre commande. Vous devez accepter toutes les conditions du d&eacute;taillant qui vous sont pr&eacute;sent&eacute;es avant de pouvoir continuer. La commande est soumise en cliquant sur le bouton [&laquo; Acheter maintenant &raquo;] sur la page de paiement.</p>\r\n<p>Apr&egrave;s avoir pass&eacute; une commande, vous recevrez un e-mail confirmant que votre commande a &eacute;t&eacute; re&ccedil;ue et vous donnant un num&eacute;ro de r&eacute;f&eacute;rence de commande. Veuillez noter que cela ne signifie pas que votre commande a &eacute;t&eacute; accept&eacute;e. Votre commande constitue une offre au D&eacute;taillant concern&eacute; d\'acheter le(s) Produit(s) command&eacute;(s). Toutes les commandes sont soumises &agrave; l\'acceptation du D&eacute;taillant concern&eacute;. Le D&eacute;taillant n\'est pas oblig&eacute; d\'accepter votre commande et peut, &agrave; sa discr&eacute;tion, refuser d\'accepter toute commande. Vous reconnaissez cependant qu\'en cliquant sur le bouton [&laquo; Acheter maintenant &raquo;], vous vous engagez &agrave; payer le(s) Produit(s). Lorsque votre commande est accept&eacute;e, cette acceptation sera confirm&eacute;e par l\'envoi d\'un e-mail confirmant que votre commande a &eacute;t&eacute; exp&eacute;di&eacute;e ou, si vous optez (le cas &eacute;ch&eacute;ant) pour le retrait, lorsqu\'elle sera pr&ecirc;te &agrave; &ecirc;tre retir&eacute;e (\"Confirmation de commande\"). Vous recevrez une confirmation de commande pour chaque d&eacute;taillant aupr&egrave;s duquel vous effectuez un achat. L\'accord entre vous et le D&eacute;taillant concern&eacute; concernant le(s) Produit(s) command&eacute;(s) (&laquo; Accord de D&eacute;taillant &raquo;) ne sera form&eacute; et ne deviendra contraignant que lorsque la Confirmation de commande vous sera envoy&eacute;e. Apr&egrave;s avoir conclu le Contrat de D&eacute;taillant, le D&eacute;taillant concern&eacute; sera dans l\'obligation l&eacute;gale de vous fournir des biens conformes au Contrat de D&eacute;taillant.</p>\r\n<p>Le Contrat de D&eacute;taillant ne concernera que le(s) Produit(s) qui ont &eacute;t&eacute; confirm&eacute;s dans la Confirmation de Commande. Le D&eacute;taillant concern&eacute; ne sera pas tenu de fournir tout autre Produit qui aurait pu faire partie de votre commande jusqu\'&agrave; ce que ce(s) Produit(s) ait(ont) &eacute;t&eacute; confirm&eacute;(s) dans une Confirmation de Commande s&eacute;par&eacute;e.</p>\r\n<p>LIVRAISON OU COLLECTE DES PRODUITS</p>\r\n<p>Votre commande sera ex&eacute;cut&eacute;e &agrave; la date de livraison indiqu&eacute;e dans la Confirmation de commande ou, si aucune date de livraison n\'est sp&eacute;cifi&eacute;e, dans les 30 jours suivant la date de la Confirmation de commande, sauf circonstances exceptionnelles.</p>\r\n<p>Votre commande sera livr&eacute;e &agrave; l\'adresse de livraison au Royaume-Uni que vous avez indiqu&eacute;e lors de votre commande, sauf si vous choisissez (le cas &eacute;ch&eacute;ant) de la r&eacute;cup&eacute;rer dans l\'un des points de retrait propos&eacute;s par le D&eacute;taillant concern&eacute;. Votre confirmation de commande comprendra les d&eacute;tails de la livraison ou de la collecte.</p>\r\n<p>Les produits compris dans une m&ecirc;me commande ne peuvent &ecirc;tre livr&eacute;s &agrave; des adresses diff&eacute;rentes. Les livraisons ne peuvent pas &ecirc;tre effectu&eacute;es &agrave; des bo&icirc;tes postales.</p>\r\n<p>Veuillez &eacute;galement noter que vous devez vous conformer &agrave; toutes les lois et r&eacute;glementations applicables du pays auquel le ou les produits sont destin&eacute;s. Le D&eacute;taillant concern&eacute; ne sera pas responsable de toute violation par vous de ces lois.</p>\r\n<p>RISQUE ET PROPRI&Eacute;T&Eacute;</p>\r\n<p>Le(s) Produit(s) command&eacute;(s) seront &agrave; vos risques et p&eacute;rils &agrave; partir du moment de la livraison ou de la collecte (selon le cas). La propri&eacute;t&eacute; du ou des Produit(s) command&eacute;(s) vous sera &eacute;galement transf&eacute;r&eacute;e lors de la livraison ou de l\'enl&egrave;vement (selon le cas), &agrave; condition que le paiement int&eacute;gral de toutes les sommes dues au titre du ou des Produit(s), y compris les &eacute;ventuels frais de livraison, ait &eacute;t&eacute; re&ccedil;u.</p>\r\n<p>PAIEMENT</p>\r\n<p>Tous les frais de traitement et/ou frais de produit sont payables via notre site, notre application ou par t&eacute;l&eacute;phone. Nous collectons ou organisons la collecte du paiement des frais de traitement au nom du professionnel ind&eacute;pendant et des frais de produit au nom du d&eacute;taillant. Dans chaque cas, notre r&eacute;ception de votre paiement en tant qu\'agent pour le d&eacute;taillant ou le professionnel ind&eacute;pendant lib&egrave;re votre dette envers ce d&eacute;taillant ou ce professionnel ind&eacute;pendant pour le montant pay&eacute;.</p>\r\n<p>Nous ferons tout notre possible pour nous assurer que toutes les informations que vous nous fournissez lors du paiement du Service professionnel et/ou du ou des Produit(s) sont s&eacute;curis&eacute;es en utilisant un m&eacute;canisme de paiement s&eacute;curis&eacute; crypt&eacute;. Cependant, en l\'absence de n&eacute;gligence de la part de Je Veux Services Inc, nous ne serons pas l&eacute;galement responsables envers vous de toute perte que vous pourriez subir si un tiers obtient un acc&egrave;s non autoris&eacute; &agrave; toute information que vous pourriez nous fournir &agrave; tout moment.</p>\r\n<p>Tous les paiements par carte de cr&eacute;dit ou carte de d&eacute;bit doivent &ecirc;tre autoris&eacute;s par l\'&eacute;metteur de carte concern&eacute;. Nous pouvons &eacute;galement avoir besoin d\'utiliser des mesures de s&eacute;curit&eacute; suppl&eacute;mentaires via V&eacute;rifi&eacute; par Visa, le cas &eacute;ch&eacute;ant.</p>\r\n<p>En effectuant une r&eacute;servation ou un achat, vous acceptez de fournir des informations compl&egrave;tes, correctes et v&eacute;ridiques, y compris, sans s\'y limiter, les informations de facturation et de paiement.</p>\r\n<p>BONS ET CR&Eacute;DITS</p>\r\n<p>Tous les bons et cr&eacute;dits Je Veux Services Inc expirent dans les 12 mois suivant la date d\'&eacute;mission, sauf s\'ils font partie d\'une promotion pour laquelle une date d\'expiration sp&eacute;cifique a &eacute;t&eacute; sp&eacute;cifi&eacute;e par &eacute;crit.</p>\r\n<p>Tous les bons et cr&eacute;dits ne sont ni remboursables ni &eacute;changeables contre n\'importe quelle devise ou esp&egrave;ces.</p>\r\n<p>Dans le cas d\'un bon ou d\'un cr&eacute;dit &eacute;mis gratuitement, c\'est-&agrave;-dire qu\'aucun achat n\'a &eacute;t&eacute; requis, Je Veux Services Inc se r&eacute;serve le droit d\'annuler le cr&eacute;dit ou le bon en partie ou en totalit&eacute; &agrave; tout moment, pour quelque raison que ce soit et sans pr&eacute;avis. .</p>\r\n<p>SERVICES PROFESSIONNELS</p>\r\n<p>Le prix des Services Professionnels (chacun &eacute;tant un &laquo; Prix de Traitement &raquo; et collectivement des &laquo; Prix de Traitement &raquo;) varie en fonction du type et de la dur&eacute;e du Service Professionnel que vous r&eacute;servez ainsi que de l\'emplacement des locaux que vous avez d&eacute;sign&eacute;s pour que le Service Professionnel soit fourni &agrave; vous par le professionnel ind&eacute;pendant (&laquo; Lieux d&eacute;sign&eacute;s &raquo;). Les prix des traitements sont fix&eacute;s de temps &agrave; autre et le prix des traitements que vous devrez payer pour un service professionnel sp&eacute;cifique (chacun des &laquo; frais de traitement &raquo; et collectivement les &laquo; frais de traitement &raquo;) sera d&eacute;termin&eacute; par r&eacute;f&eacute;rence aux prix des traitements en vigueur au date &agrave; laquelle ce service professionnel est r&eacute;serv&eacute;.</p>\r\n<p>Tous les d&eacute;tails des prix des traitements sont indiqu&eacute;s sur notre site et notre application. Les prix des soins sont susceptibles de changer &agrave; tout moment et en fonction des fluctuations de la demande sur la plateforme, mais les modifications n\'affecteront pas les r&eacute;servations que vous avez d&eacute;j&agrave; effectu&eacute;es.</p>\r\n<p>DES PRODUITS</p>\r\n<p>Le prix des Produits (chacun un &laquo; Prix du Produit &raquo; et collectivement les &laquo; Prix des Produits &raquo;) varie en fonction du Produit s&eacute;lectionn&eacute;. Les prix des produits sont fix&eacute;s de temps &agrave; autre et le prix des produits que vous devrez payer pour un produit sp&eacute;cifique (chacun des &laquo; frais de produit &raquo; et collectivement des &laquo; frais de produit &raquo;) sera d&eacute;termin&eacute; par r&eacute;f&eacute;rence aux prix des produits en vigueur &agrave; la date lorsque ce Produit a &eacute;t&eacute; achet&eacute;.</p>\r\n<p>Les prix des produits excluent les frais de livraison, qui seront ajout&eacute;s (au co&ucirc;t indiqu&eacute;) au montant total d&ucirc; lorsque vous consulterez les articles de votre panier.</p>\r\n<p>Les prix des produits et les frais de livraison sont susceptibles de changer &agrave; tout moment, mais les changements n\'affecteront pas les commandes pour lesquelles vous avez d&eacute;j&agrave; re&ccedil;u une confirmation de commande.</p>\r\n<p>Notre site, notre application et notre service de r&eacute;servation par chat en ligne contiennent un grand nombre de produits et il est toujours possible que, malgr&eacute; tous les efforts, certains des produits r&eacute;pertori&eacute;s sur notre site, notre application ou notre service de r&eacute;servation par chat en ligne soient mal tarif&eacute;s. Les prix factur&eacute;s seront normalement v&eacute;rifi&eacute;s dans le cadre des proc&eacute;dures d\'exp&eacute;dition de sorte que, lorsque le prix correct d\'un produit est inf&eacute;rieur au prix indiqu&eacute;, vous serez factur&eacute; le montant le plus bas. Si le prix correct d\'un Produit est sup&eacute;rieur au prix indiqu&eacute; sur Notre Site, Notre Application ou notre service de r&eacute;servation par chat en ligne, le D&eacute;taillant concern&eacute; vous contactera normalement pour obtenir des instructions avant d\'exp&eacute;dier le Produit, ou votre commande sera rejet&eacute;e, auquel cas vous &ecirc;tre avis&eacute; de ce rejet.</p>\r\n<p>Tous les d&eacute;tails des prix des produits sont indiqu&eacute;s sur notre site et notre application.</p>\r\n<p>VOS RESPONSABILIT&Eacute;S</p>\r\n<p>En plus des responsabilit&eacute;s indiqu&eacute;es ci-dessus, il est de votre responsabilit&eacute; de fournir des informations compl&egrave;tes et exactes au moment de la r&eacute;servation ou de l\'achat. Le d&eacute;faut de fournir des informations compl&egrave;tes et exactes peut entra&icirc;ner le rejet de votre demande de r&eacute;servation, l\'annulation de votre r&eacute;servation, l\'incapacit&eacute; du professionnel ind&eacute;pendant r&eacute;serv&eacute; &agrave; fournir le service professionnel demand&eacute; ou l\'incapacit&eacute; du d&eacute;taillant &agrave; fournir le produit. Un tel manquement peut entra&icirc;ner l\'inadmissibilit&eacute; de vos paiements &agrave; un remboursement, ou une perte ou une livraison incorrecte de votre r&eacute;servation ou de votre confirmation de commande.</p>\r\n<p>Dans de tels cas o&ugrave; il y a eu un manquement de votre part &agrave; nous fournir des informations exactes, notre politique d\'annulation et de remboursement s\'appliquera.</p>\r\n<p>ANNULATIONS ET REMBOURSEMENTS</p>\r\n<p>SERVICES PROFESSIONNELS</p>\r\n<p>Vous reconnaissez que vous n\'avez aucun droit l&eacute;gal d\'annuler une r&eacute;servation effectu&eacute;e pour un service professionnel. Cependant, vous avez le droit contractuel d\'annuler toute r&eacute;servation que vous avez effectu&eacute;e aupr&egrave;s d\'un professionnel ind&eacute;pendant par notre interm&eacute;diaire dans les circonstances suivantes et selon les conditions d&eacute;crites.</p>\r\n<p>Sous r&eacute;serve que l\'annulation soit une annulation tardive ou tr&egrave;s tardive (comme d&eacute;crit ci-dessous), si vous changez d\'avis sur votre r&eacute;servation avant l\'heure de d&eacute;but de rendez-vous convenue dans cette r&eacute;servation (\"Heure de rendez-vous\"), le professionnel ind&eacute;pendant sera dispos&eacute; &agrave; traiter votre r&eacute;servation comme annul&eacute;e (sans exiger le paiement de tout ou partie des frais de traitement applicables et sans pr&eacute;lever de frais d\'annulation)</p>\r\n<p>Les frais de traitement complets vous seront &eacute;galement factur&eacute;s si vous :</p>\r\n<p>Annuler une r&eacute;servation autre que celle autoris&eacute;e ci-dessus ;</p>\r\n<p>Tenter d\'annuler une r&eacute;servation &agrave; l\'heure de rendez-vous ou apr&egrave;s ; ou</p>\r\n<p>Ne pas se pr&eacute;senter &agrave; une r&eacute;servation &agrave; l\'heure du rendez-vous et/ou dans les locaux d&eacute;sign&eacute;s.</p>\r\n<p>D&eacute;faut de fournir des informations exactes pour que votre professionnel ind&eacute;pendant se rende dans les locaux d&eacute;sign&eacute;s</p>\r\n<p>Ne pas fournir des coordonn&eacute;es exactes et compl&egrave;tes ou des informations personnelles telles que, mais sans s\'y limiter, le nom complet, le num&eacute;ro de t&eacute;l&eacute;phone et l\'adresse</p>\r\n<p>R&eacute;servez un soin qui ne peut &ecirc;tre r&eacute;alis&eacute; car vous r&eacute;pondez &agrave; l\'une des contre-indications mentionn&eacute;es sur la page de description du soin sur notre Application ou Site Internet</p>\r\n<p>Des frais d\'annulation sont factur&eacute;s afin d\'indemniser le professionnel ind&eacute;pendant car il n\'est pas raisonnable de s\'attendre &agrave; ce que le professionnel ind&eacute;pendant soit en mesure de fournir un service professionnel lors d\'une autre r&eacute;servation o&ugrave; vous annulez avec un pr&eacute;avis court ou sans pr&eacute;avis.</p>\r\n<p>Les frais d\'annulation peuvent, &agrave; notre enti&egrave;re discr&eacute;tion, &ecirc;tre annul&eacute;s si vous n\'avez pas &eacute;t&eacute; en mesure d\'annuler une r&eacute;servation sans encourir les frais d\'annulation pour des raisons r&eacute;elles ind&eacute;pendantes de votre volont&eacute;. Lorsque nous renon&ccedil;ons aux frais d\'annulation, nous agissons en tant qu\'agent du professionnel ind&eacute;pendant qui est le principal fournisseur du service professionnel.</p>\r\n<p>DES PRODUITS</p>\r\n<p>Sauf en ce qui concerne certains produits d&eacute;crits ci-dessous, vous pouvez annuler une commande pour un produit &agrave; tout moment avant la livraison de votre commande et jusqu\'&agrave; 14 jours apr&egrave;s, &agrave; compter du lendemain de la livraison de votre commande (dans son int&eacute;gralit&eacute;) ou , si vous choisissez (le cas &eacute;ch&eacute;ant) de le retirer dans l\'un des points de retrait propos&eacute;s par le coursier et que ce point de retrait est g&eacute;r&eacute; par un tiers autre que le coursier (par exemple, un d&eacute;panneur local), le lendemain du jour o&ugrave; il est remis &agrave; ce tiers (&laquo; D&eacute;lai de r&eacute;flexion &raquo;).</p>\r\n<p>Si vous annulez, vous recevrez un remboursement complet du prix pay&eacute; pour le(s) Produit(s) conform&eacute;ment &agrave; la politique de remboursement (voir ci-dessous).</p>\r\n<p>Pour annuler une commande, vous devez clairement informer le D&eacute;taillant concern&eacute;, de pr&eacute;f&eacute;rence :</p>\r\n<p>par &eacute;crit, par e-mail ou par t&eacute;l&eacute;phone, en indiquant vos nom, adresse et r&eacute;f&eacute;rence de commande ; ou</p>\r\n<p>en remplissant et en soumettant notre formulaire de r&eacute;tractation disponible sur Notre Site ou Notre Application, dont une copie est &eacute;galement jointe au(x) Produit(s) lors de la livraison.</p>\r\n<p>Vous devez &eacute;galement retourner le(s) Produit(s) dans les 14 jours suivant le jour o&ugrave; vous notifiez votre annulation, dans le m&ecirc;me &eacute;tat dans lequel vous les avez re&ccedil;us (ce qui n\'interf&egrave;re pas avec votre droit de prendre des mesures raisonnables pour examiner le(s) Produit(s) et assurez-vous qu\'ils sont conformes &agrave; votre commande). Les Produits doivent &ecirc;tre retourn&eacute;s au D&eacute;taillant concern&eacute;. Vous avez l\'obligation l&eacute;gale de prendre raisonnablement soin du ou des produits lorsqu\'ils sont en votre possession. Si vous ne respectez pas cette obligation, le D&eacute;taillant concern&eacute; peut avoir le droit de d&eacute;duire le co&ucirc;t de toute d&eacute;t&eacute;rioration (due, par exemple, &agrave; votre utilisation du ou des Produit(s)), jusqu\'&agrave; concurrence du prix du ou des Produit(s) , du remboursement auquel vous avez autrement droit.</p>\r\n<p>Pour retourner le(s) Produit(s), vous devez emballer le colis en toute s&eacute;curit&eacute; (en veillant &agrave; inclure une note de votre nom et adresse (en joignant tout bordereau de retour, si vous en avez re&ccedil;u un) &agrave; l\'int&eacute;rieur du colis) puis le retourner au D&eacute;taillant concern&eacute;, soit par coursier, soit par courrier recommand&eacute;, soit par une autre forme de courrier certifi&eacute; ou, si le(s) Produit(s) sont trop volumineux pour &ecirc;tre renvoy&eacute;s par la poste, par un transporteur appropri&eacute;, &agrave; l\'adresse de retour indiqu&eacute;e soit dans la Confirmation de Commande, soit le bon de livraison &agrave; l\'int&eacute;rieur du colis livr&eacute;.</p>\r\n<p>Il est conseill&eacute; de souscrire une assurance postale/transport suffisante pour couvrir la valeur du contenu. Veuillez conserver votre preuve d\'envoi/d\'exp&eacute;dition et les informations de suivi jusqu\'&agrave; ce que votre remboursement ait &eacute;t&eacute; trait&eacute;. Vous serez responsable du co&ucirc;t et du risque de retour du ou des Produit(s).</p>\r\n<p>Les d&eacute;tails des droits des consommateurs d&eacute;crits ci-dessus et une explication de la mani&egrave;re de les exercer sont fournis dans la confirmation de commande. Rien dans cette section n\'affecte vos droits l&eacute;gaux.</p>\r\n<p>POLITIQUE DE REMBOURSEMENT DU PRODUIT</p>\r\n<p>Si vous annulez une commande pendant le D&eacute;lai de r&eacute;flexion, tout remboursement qui vous est d&ucirc; sera trait&eacute; d&egrave;s que possible et, dans tous les cas, dans les 14 jours suivant le jour o&ugrave; le D&eacute;taillant concern&eacute; re&ccedil;oit le(s) Produit(s) en retour ou, s\'il est ant&eacute;rieur, le jour o&ugrave; le D&eacute;taillant concern&eacute; re&ccedil;oit la preuve que vous avez retourn&eacute; le(s) Produit(s) &agrave; l\'adresse de retour (voir ci-dessus). Vous serez rembours&eacute; du prix pay&eacute; en totalit&eacute; (sous r&eacute;serve de toute d&eacute;duction que le D&eacute;taillant concern&eacute; est en droit de faire en raison de votre utilisation ou des dommages caus&eacute;s au(x) Produit(s)), y compris les frais de livraison standard. Cependant, vous ne serez pas rembours&eacute; de vos frais de retour du ou des Produit(s). Si vous avez re&ccedil;u une remise promotionnelle ou autre lors de votre paiement, tout remboursement ne refl&eacute;tera que le montant que vous avez r&eacute;ellement pay&eacute;.</p>\r\n<p>Les remboursements sont effectu&eacute;s en utilisant la m&ecirc;me m&eacute;thode que vous avez utilis&eacute;e &agrave; l\'origine pour payer votre achat ou convertis en cr&eacute;dits Je Veux Services Inc, sauf accord contraire.</p>\r\n<p>PRODUITS D&Eacute;FECTUEUX</p>\r\n<p>Si un produit que vous commandez est endommag&eacute; ou d&eacute;fectueux lors de sa livraison ou a d&eacute;velopp&eacute; un d&eacute;faut, vous pouvez avoir un ou plusieurs recours l&eacute;gaux &agrave; votre disposition, selon le moment o&ugrave; vous informez le d&eacute;taillant concern&eacute; du probl&egrave;me, conform&eacute;ment &agrave; vos droits l&eacute;gaux. . Si vous pensez qu\'un Produit a &eacute;t&eacute; livr&eacute; endommag&eacute; ou d&eacute;fectueux ou a d&eacute;velopp&eacute; un d&eacute;faut, vous devez en informer le D&eacute;taillant concern&eacute; d&egrave;s que possible, de pr&eacute;f&eacute;rence par &eacute;crit, en indiquant votre nom, adresse et r&eacute;f&eacute;rence de commande.</p>\r\n<p>Veuillez noter que nous n\'avons aucun contr&ocirc;le sur un d&eacute;taillant ou sur la qualit&eacute; de l\'un des produits ou services fournis par le d&eacute;taillant, nous ne donnons aucun engagement &agrave; leur sujet, et nous ne sommes pas en mesure de fournir, et n\'avons aucune responsabilit&eacute; ou obligation de fournir, toute compensation pour vous au nom de tout D&eacute;taillant. Rien dans cette section n\'affecte vos droits l&eacute;gaux.</p>\r\n<p>PROLONGATIONS ET RETARDS</p>\r\n<p>Si vous souhaitez prolonger la dur&eacute;e de votre r&eacute;servation d\'un Service Professionnel, le professionnel Ind&eacute;pendant s\'efforcera de r&eacute;pondre &agrave; votre demande. Ceci est soumis &agrave; la disponibilit&eacute; du professionnel ind&eacute;pendant et au paiement de frais suppl&eacute;mentaires pour la dur&eacute;e prolong&eacute;e calcul&eacute;s conform&eacute;ment aux prix du traitement (chacun &eacute;tant un &laquo; frais de temps suppl&eacute;mentaire &raquo; et collectivement, les &laquo; frais de temps suppl&eacute;mentaire &raquo;).</p>\r\n<p>Si vous &ecirc;tes retard&eacute; et incapable de commencer le Service Professionnel dans les Locaux D&eacute;sign&eacute;s &agrave; l\'Heure du Rendez-Vous de plus de 10 minutes, sauf accord contraire du Professionnel Ind&eacute;pendant (ce qui est &agrave; la seule discr&eacute;tion du Professionnel Ind&eacute;pendant) :</p>\r\n<p>le Professionnel Ind&eacute;pendant a le droit de mettre fin &agrave; la Prestation Professionnelle &agrave; l\'heure convenue lors de la r&eacute;servation sans proc&eacute;der &agrave; aucun ajustement du Prix du Traitement pour tenir compte du temps r&eacute;duit de la Prestation Professionnelle ; ou</p>\r\n<p>si vous et le professionnel ind&eacute;pendant acceptez de poursuivre le service professionnel pendant tout le temps imparti nonobstant l\'heure de d&eacute;but retard&eacute;e, vous serez alors tenu de payer avant que le service professionnel concern&eacute; ne soit fourni, des frais suppl&eacute;mentaires calcul&eacute;s au taux indiqu&eacute; avec le Prix ​​du traitement pour le temps suppl&eacute;mentaire.</p>\r\n<p>Nous collecterons les frais de temps suppl&eacute;mentaire en tant qu\'agent du professionnel ind&eacute;pendant.</p>\r\n<p>Je Veux Services Inc AGIT UNIQUEMENT EN TANT D\'INTRODUCTEUR</p>\r\n<p>Les Services permettent &agrave; ceux qui recherchent des Services professionnels de prendre rendez-vous avec des professionnels ind&eacute;pendants cherchant &agrave; fournir de tels Services professionnels. Bien que Je Veux Services Inc &eacute;value les professionnels ind&eacute;pendants qui souhaitent fournir des services professionnels, nous ne garantissons ni ne garantissons et ne faisons aucune d&eacute;claration concernant la fiabilit&eacute;, la qualit&eacute; ou l\'ad&eacute;quation des professionnels ind&eacute;pendants. C\'est enti&egrave;rement une question pour vous. En cons&eacute;quence, vous reconnaissez et acceptez que Je Veux Services Inc n\'a aucune obligation de proc&eacute;der &agrave; des v&eacute;rifications des ant&eacute;c&eacute;dents de tout professionnel ind&eacute;pendant et n\'a aucune obligation &agrave; l\'&eacute;gard de tout service qu\'il peut fournir.</p>\r\n<p>Lorsque vous interagissez avec un professionnel ind&eacute;pendant, vous devez faire preuve de prudence et de bon sens pour prot&eacute;ger votre s&eacute;curit&eacute; personnelle, vos donn&eacute;es et vos biens, tout comme vous le feriez lorsque vous interagissez avec d\'autres personnes qui vous sont inconnues.</p>\r\n<p>CODES PROMO ET R&Eacute;F&Eacute;RENCES</p>\r\n<p>Nous pouvons de temps &agrave; autre cr&eacute;er et offrir des codes promotionnels et des codes de parrainage (ensemble les &laquo; codes &raquo;) qui peuvent &ecirc;tre &eacute;chang&eacute;s contre des achats de services ou de produits professionnels. Les codes ne seront valides que pour une p&eacute;riode de temps indiqu&eacute;e sur ou avec eux.</p>\r\n<p>Les codes n\'ont aucune valeur mon&eacute;taire. Les codes peuvent :</p>\r\n<p>(1) &ecirc;tre utilis&eacute; uniquement &agrave; des fins personnelles et non commerciales. Vous pouvez partager votre code unique avec vos relations personnelles via les m&eacute;dias sociaux o&ugrave; vous &ecirc;tes le principal propri&eacute;taire du contenu. Les codes ne peuvent pas &ecirc;tre dupliqu&eacute;s, vendus, transf&eacute;r&eacute;s, distribu&eacute;s ou mis &agrave; la disposition d\'autres personnes en ligne (y compris via des sites publics tels que des sites de coupons) ou par d\'autres moyens ;</p>\r\n<p>(2) ne pas faire l\'objet d\'une promotion de quelque mani&egrave;re que ce soit, y compris via un moteur de recherche ou des sites Web/forums de r&eacute;duction ;</p>\r\n<p>(3) ne pas &ecirc;tre &eacute;chang&eacute;s contre de l\'argent ;</p>\r\n<p>(4) n\'&ecirc;tre utilis&eacute; qu\'une seule fois et un seul code peut &ecirc;tre utilis&eacute; par personne ; et</p>\r\n<p>(5) peuvent &ecirc;tre soumis &agrave; des conditions sp&eacute;cifiques que nous mettrons &agrave; disposition, y compris, mais sans s\'y limiter, la date d\'expiration / d\'utilisation indiqu&eacute;e sur la promotion, et ne doivent &ecirc;tre utilis&eacute;s que conform&eacute;ment &agrave; ces conditions.</p>\r\n<p>Les r&eacute;ductions ne peuvent pas &ecirc;tre utilis&eacute;es conjointement avec d\'autres offres ou r&eacute;ductions. Je Veux Services Inc se r&eacute;serve le droit de modifier, suspendre, r&eacute;silier ou interrompre les offres de code promotionnel / de parrainage de temps &agrave; autre et &agrave; partir de votre compte pour quelque raison que ce soit, y compris, mais sans s\'y limiter, la violation de notre programme.</p>\r\n<p>UTILISATION INTERDITE</p>\r\n<p>Les Services sont destin&eacute;s &agrave; votre usage personnel et non commercial et ne doivent &ecirc;tre utilis&eacute;s qu\'aux fins d\'enqu&ecirc;te ou de r&eacute;servation de Services Professionnels et/ou d\'achat de Produits comme express&eacute;ment d&eacute;crit ci-dessus. Vous ne devez pas utiliser Notre Site, Notre Application ou les Services pour faire l\'une des choses suivantes (chacune &eacute;tant strictement interdite) :</p>\r\n<p>Adopter un comportement inappropri&eacute;, y compris, mais sans s\'y limiter, des remarques illicites ou sexuellement suggestives, des avances sexuelles, la consommation de drogue, une consommation excessive d\'alcool et/ou tout autre comportement inappropri&eacute; ;</p>\r\n<p>Restreindre ou emp&ecirc;cher tout autre utilisateur d\'utiliser et de profiter des Services ;</p>\r\n<p>Enfreindre les droits &agrave; la vie priv&eacute;e, les droits de propri&eacute;t&eacute; ou d\'autres droits civils de toute personne ;</p>\r\n<p>Harceler, abuser, menacer ou autrement enfreindre ou violer les droits des professionnels ind&eacute;pendants, Je Veux Services Inc (y compris ses employ&eacute;s et son personnel) ou autres ;</p>\r\n<p>R&eacute;colter, extraire des donn&eacute;es ou autrement collecter des informations sur d\'autres personnes, y compris des adresses e-mail, sans leur consentement ;</p>\r\n<p>Utiliser la technologie ou d\'autres moyens pour acc&eacute;der &agrave; notre r&eacute;seau informatique, &agrave; du contenu non autoris&eacute; ou &agrave; des espaces non publics ;</p>\r\n<p>Introduire ou tenter d\'introduire des virus ou tout autre code, fichier ou programme nuisible qui interrompt ou autrement ou limite les services, notre site ou la fonctionnalit&eacute; de notre application, ou endommage, d&eacute;sactive ou alt&egrave;re autrement nos serveurs ou r&eacute;seaux ou tente de faire de m&ecirc;me ; ou</p>\r\n<p>S\'engager ou encourager d\'autres personnes &agrave; se livrer &agrave; une conduite criminelle ou ill&eacute;gale ou &agrave; enfreindre Nos Conditions, y compris l\'utilisation abusive des Services &agrave; des fins ill&eacute;gales ou non autoris&eacute;es.</p>\r\n<p>Vous acceptez de ne pas enfreindre Nos Conditions d\'une mani&egrave;re qui pourrait entra&icirc;ner, entre autres, la r&eacute;siliation ou la suspension de votre acc&egrave;s aux Services. Nous nous r&eacute;servons le droit de divulguer des informations sur un comportement suspect li&eacute;, mais sans s\'y limiter, &agrave; l\'un des &eacute;l&eacute;ments &eacute;num&eacute;r&eacute;s ci-dessus aux forces de l\'ordre.</p>\r\n<p>&nbsp;</p>\r\n<p>PROPRI&Eacute;T&Eacute; INTELLECTUELLE</p>\r\n<p>Je Veux Services Inc, le logo Je Veux Services Inc, la marque et tous les autres droits de propri&eacute;t&eacute; intellectuelle, marques de commerce, marques de service, graphiques et logos utilis&eacute;s en relation avec le Site, l\'Application ou les Services (qu\'ils soient enregistr&eacute;s ou non) nous appartiennent ou appartiennent &agrave; nos conc&eacute;dants de licence (le cas &eacute;ch&eacute;ant) et sont prot&eacute;g&eacute;s par le droit de la propri&eacute;t&eacute; intellectuelle. Rien dans nos conditions ne vous accorde de droits sur le site, l\'application ou les services ou le contenu de ceux-ci. Tous les droits sont r&eacute;serv&eacute;s.</p>\r\n<p>Clause de non-responsabilit&eacute;</p>\r\n<p>Comme indiqu&eacute; ci-dessus, nous pr&eacute;sentons les personnes &agrave; la recherche de services professionnels &agrave; des professionnels ind&eacute;pendants cherchant &agrave; fournir de tels services professionnels. Nous ne sommes pas responsables de l\'ex&eacute;cution de toute r&eacute;servation ou de la performance du professionnel ind&eacute;pendant. Vous reconnaissez et acceptez que nous ne sommes pas responsables du traitement de vos r&eacute;clamations concernant tout professionnel ind&eacute;pendant ou tout service professionnel, mais nous essayons de vous aider en fournissant les services interm&eacute;diaires pour r&eacute;soudre les litiges et les plaintes comme mentionn&eacute; ci-dessus.</p>\r\n<p>NOS SERVICES SONT UNIQUEMENT &Agrave; TITRE D\'INFORMATION G&Eacute;N&Eacute;RALE</p>\r\n<p>Le contenu de notre site et de notre application mis &agrave; disposition dans le cadre des services est fourni uniquement &agrave; des fins d\'information g&eacute;n&eacute;rale. Aucune information contenue sur Notre Site, Notre Application ou communiqu&eacute;e de toute autre mani&egrave;re dans le cadre des Services ne constitue, ou n\'est destin&eacute;e &agrave; constituer, un conseil, une opinion ou une orientation de quelque nature que ce soit. Nous ne sommes pas un fournisseur de soins de sant&eacute; et nous ne fournissons pas de conseils m&eacute;dicaux ni de traitements m&eacute;dicaux. Les r&eacute;f&eacute;rences sur notre site, notre application et ailleurs &agrave; &laquo; traitement &raquo; et &laquo; th&eacute;rapie &raquo; ou &agrave; tout terme similaire ne font pas r&eacute;f&eacute;rence &agrave; un traitement m&eacute;dical ou &agrave; une th&eacute;rapie m&eacute;dicale. Les informations pr&eacute;sent&eacute;es sur notre site, notre application et autrement dans le cadre des services ne sont pas destin&eacute;es &agrave; diagnostiquer des probl&egrave;mes de sant&eacute; ou &agrave; remplacer les soins m&eacute;dicaux professionnels. Si vous avez un probl&egrave;me m&eacute;dical, vous devriez toujours consulter un professionnel de la sant&eacute; qualifi&eacute;.</p>\r\n<p>NOUS NE POUVONS PAS GARANTIR NOTRE SITE, NOTRE APPLICATION OU LES SERVICES.</p>\r\n<p>Nous ne garantissons ni ne garantissons que Notre Site, Notre Application ou tout autre aspect des Services est adapt&eacute; &agrave; l\'utilisation que vous en faites, sans erreur, opportun, fiable, enti&egrave;rement s&eacute;curis&eacute;, sans virus ou disponible. Nous ne garantissons pas les r&eacute;sultats ou r&eacute;sultats particuliers de l\'utilisation de notre site, de notre application ou de tout autre aspect des services.</p>\r\n<p>Rien dans Nos Conditions n\'exclura ou ne limitera toute garantie implicite par la loi qu\'il serait ill&eacute;gal d\'exclure ou de limiter et rien dans Nos Conditions n\'exclura ou ne limitera notre responsabilit&eacute; en cas de : d&eacute;c&egrave;s ou blessure caus&eacute;e par la n&eacute;gligence de Je Veux Services Inc, fraude ou fausse d&eacute;claration frauduleuse par Je Veux Services Inc, ou toute question pour laquelle il serait ill&eacute;gal ou ill&eacute;gal pour Je Veux Services Inc d\'exclure ou de limiter, ou de tenter ou de pr&eacute;tendre exclure ou limiter sa responsabilit&eacute;.</p>\r\n<p>Nous ne sommes pas responsables de toute erreur ou incapacit&eacute; &agrave; fournir les Services en raison de votre erreur ou de votre incapacit&eacute; &agrave; fournir des informations exactes et compl&egrave;tes.</p>\r\n<p>Bien que nous fassions tout notre possible pour nous assurer que les Services sont disponibles, nous ne repr&eacute;sentons, ne garantissons ni ne garantissons en aucune mani&egrave;re la disponibilit&eacute; continue &agrave; tout moment ou l\'utilisation ininterrompue par vous des Services. Nous nous r&eacute;servons le droit de suspendre ou de cesser le fonctionnement de tout ou partie des Services de temps &agrave; autre &agrave; notre seule discr&eacute;tion.</p>\r\n<p>L\'utilisation de notre site, de notre application et des services se fait &laquo; en l\'&eacute;tat &raquo; et &laquo; selon la disponibilit&eacute; &raquo;. Dans la mesure maximale autoris&eacute;e par la loi, nous ne serons en aucun cas responsables des dommages directs, indirects, punitifs, accessoires, sp&eacute;ciaux, cons&eacute;cutifs ou de tout dommage, y compris, sans s\'y limiter, les dommages pour perte d\'utilisation, perte de donn&eacute;es, perte de revenus, perte de client&egrave;le, perte d\'&eacute;conomies ou de b&eacute;n&eacute;fices anticip&eacute;s, ou r&eacute;sultant de ou li&eacute; de quelque mani&egrave;re que ce soit &agrave; l\'utilisation ou &agrave; la performance du site ou des services, ou au retard ou &agrave; l\'impossibilit&eacute; d\'utiliser le site ou les services, ou &agrave; la fourniture de ou d&eacute;faut de fournir le site ou les services.</p>\r\n<p>INDEMNIT&Eacute;</p>\r\n<p>Vous acceptez de nous d&eacute;fendre et de nous indemniser contre toute r&eacute;clamation, cause d\'action, demande, recouvrement, perte, dommage, amende, p&eacute;nalit&eacute; ou autre co&ucirc;t ou d&eacute;pense de quelque nature que ce soit, y compris, mais sans s\'y limiter, les frais juridiques et comptables raisonnables, qui d&eacute;couler de ou se rapporter &agrave; votre utilisation ou mauvaise utilisation ou acc&egrave;s aux Services et autrement de votre violation de Nos Conditions.</p>\r\n<p>MODIFICATION ET R&Eacute;SILIATION</p>\r\n<p>Nous pouvons modifier nos conditions ou mettre fin &agrave; l\'utilisation des services &agrave; tout moment en vous en informant. Si vous n\'acceptez aucune modification, vous devez cesser d\'utiliser les Services. Nous pouvons &eacute;galement modifier, suspendre, r&eacute;silier ou interrompre tout aspect des Services, y compris la disponibilit&eacute; de certaines fonctionnalit&eacute;s, &agrave; tout moment et pour quelque raison que ce soit.</p>\r\n<p>DIVISIBILIT&Eacute;</p>\r\n<p>Si une disposition de Nos Conditions est r&eacute;put&eacute;e ou devient invalide, la validit&eacute; des autres dispositions ne sera pas affect&eacute;e.</p>\r\n<p>LOI APPLICABLE ET JURIDICTION</p>\r\n<p>Vous acceptez que Nos Conditions, &agrave; toutes fins utiles, soient r&eacute;gies et interpr&eacute;t&eacute;es conform&eacute;ment aux lois anglaises et galloises. Vous acceptez &eacute;galement de vous soumettre &agrave; la juridiction exclusive des tribunaux anglais en ce qui concerne toute r&eacute;clamation ou question d&eacute;coulant de Nos Conditions.</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>');
INSERT INTO `settings` (`id`, `type`, `key`, `value`) VALUES
(16, 'privacy_policy', 'privacy_policy', '<p>Je Veux Services Inc. respecte votre vie priv&eacute;e et s\'engage &agrave; la prot&eacute;ger en se conformant &agrave; ses politiques de confidentialit&eacute;. Cette politique d&eacute;crit :</p>\r\n<p>&bull; les types d\'informations que Je Veux Services Inc. peut collecter aupr&egrave;s de vous lorsque vous acc&eacute;dez ou utilisez ses sites Web, applications et autres services en ligne (collectivement, appel&eacute;s &laquo; Services &raquo;) ; et</p>\r\n<p>&bull; ses pratiques de collecte, d\'utilisation, de conservation, de protection et de divulgation de ces informations.</p>\r\n<p>Cette politique vise &agrave; vous fournir des informations sur Je Veux Services Inc. et les politiques de confidentialit&eacute; de ses soci&eacute;t&eacute;s affili&eacute;es. Nous prot&eacute;gerons la vie priv&eacute;e de nos clients et d\'autres personnes en appliquant ces politiques.</p>\r\n<p>Les informations que nous recueillons aupr&egrave;s de vous lorsque vous visitez nos sites, applications et autres services en ligne sont utilis&eacute;es pour am&eacute;liorer la qualit&eacute; de nos services et pour vous contacter concernant les offres et mises &agrave; jour pertinentes.</p>\r\n<p>Cette politique ne s\'applique pas aux informations que vous nous fournissez lorsque vous effectuez des r&eacute;servations ou payez des services via nos Services. Nous vous encourageons &agrave; consulter les politiques de confidentialit&eacute; des tiers avant de nous fournir des informations.</p>\r\n<p>Cette politique explique comment Je Veux Services Inc. utilisera et prot&eacute;gera les informations qu\'elle recueille et collecte aupr&egrave;s de vous, ainsi que les diff&eacute;rentes &eacute;tapes qu\'elle prend pour prot&eacute;ger ces informations. En vous inscrivant ou en acc&eacute;dant aux Services, vous consentez &eacute;galement &agrave; la collecte, &agrave; l\'utilisation et &agrave; la divulgation de vos informations personnelles. Si vous ne fournissez pas les informations n&eacute;cessaires &agrave; Je Veux Services Inc., il se peut qu\'elle ne soit pas en mesure de vous fournir ses Services.</p>\r\n<p>sera le responsable du traitement de vos donn&eacute;es personnelles fournies &agrave;, ou collect&eacute;es par ou pour, ou trait&eacute;es en relation avec nos Services ;</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Les informations que nous collectons et comment nous les utilisons</p>\r\n<p>Je Veux Services Inc. (&lsquo;&rsquo; Je Veux Services Inc. &lsquo;&rsquo;, la &lsquo;&rsquo; Soci&eacute;t&eacute; &lsquo;&rsquo;, &lsquo;&rsquo; nous &lsquo;&rsquo;, &lsquo;&rsquo; notre &lsquo;&rsquo; et &lsquo;&rsquo; nos &lsquo;&rsquo;) recueille plusieurs types d\'informations aupr&egrave;s des utilisateurs de nos Services et &agrave; leur sujet, notamment :</p>\r\n<p>Le type d\'informations personnelles qui peuvent &ecirc;tre utilis&eacute;es pour identifier une personne est l\'information qui peut &ecirc;tre utilis&eacute;e pour identifier cette personne. Ce type d\'informations peut &ecirc;tre utilis&eacute; pour collecter et utiliser diverses donn&eacute;es sur une personne, telles que les donn&eacute;es que nous avons collect&eacute;es et d\'autres sources. Nous n\'utilisons pas ce type d\'informations pour collecter des informations anonymes ou agr&eacute;g&eacute;es. Cette section vous fournira des informations vous concernant, telles que le type de connexion Internet que vous utilisez et l\'&eacute;quipement que vous utilisez pour acc&eacute;der &agrave; nos Services.</p>\r\n<p>Nous recueillons ces informations :</p>\r\n<p>&bull; directement aupr&egrave;s de vous lorsque vous nous les fournissez ; et/ou</p>\r\n<p>&bull; automatiquement lorsque vous naviguez sur nos Services (les informations collect&eacute;es automatiquement peuvent inclure des d&eacute;tails d\'utilisation, des adresses IP et des informations collect&eacute;es via des cookies, des balises Web, etc.)</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Informations que vous nous fournissez</p>\r\n<p>Les informations que nous collectons sur ou via nos Services peuvent inclure :</p>\r\n<p>&bull; Vos informations de compte : votre nom, votre adresse e-mail, votre adresse, votre mot de passe et d\'autres informations que vous pouvez fournir avec votre compte, telles que votre sexe, votre num&eacute;ro de t&eacute;l&eacute;phone portable et votre site Web. Votre photo de profil qui sera affich&eacute;e publiquement dans le cadre de votre profil de compte. Vous pouvez choisir de nous fournir ces informations via des services de connexion tiers tels que Facebook et Google Plus. Dans de tels cas, nous r&eacute;cup&eacute;rons et stockons toutes les informations que vous nous avez fournies via ces services de connexion.</p>\r\n<p>&bull; Vos pr&eacute;f&eacute;rences : vos pr&eacute;f&eacute;rences et param&egrave;tres tels que le fuseau horaire et la langue.</p>\r\n<p>&bull; Votre contenu : les informations que vous fournissez via nos Services, y compris vos avis, photographies, commentaires, listes, abonn&eacute;s, les utilisateurs que vous suivez. Coordonn&eacute;es des personnes que vous ajoutez ou signalez &agrave; vos besoins par le biais de nos Services, noms et autres informations que vous fournissez sur nos Services, et autres informations dans le profil de votre compte.</p>\r\n<p>&bull; Vos recherches et autres activit&eacute;s : les termes de recherche que vous avez recherch&eacute;s et les r&eacute;sultats que vous avez s&eacute;lectionn&eacute;s.</p>\r\n<p>&bull; Vos informations de navigation : combien de temps vous avez utilis&eacute; nos Services et quelles fonctionnalit&eacute;s vous avez utilis&eacute;es, les publicit&eacute;s sur lesquelles vous avez cliqu&eacute;.</p>\r\n<p>&bull; Vos communications : les communications entre vous et d\'autres utilisateurs ou marchands par le biais de nos Services, votre participation &agrave; une enqu&ecirc;te ou &agrave; un sondage. Votre communication avec nous concernant les opportunit&eacute;s d\'emploi affich&eacute;es dans les services.</p>\r\n<p>&bull; Vos informations transactionnelles : Le type d\'informations que nous collectons lorsque vous effectuez un achat via nos Services est g&eacute;n&eacute;ralement stock&eacute; sous la forme du nom, de l\'adresse et de l\'adresse e-mail d\'un client. Nous utiliserons &eacute;galement ces informations pour traiter vos demandes et effectuer vos transactions, y compris les informations de facturation et de carte de cr&eacute;dit.</p>\r\n<p>&bull; Vos publications publiques : les informations que vous nous fournissez sont utilis&eacute;es pour am&eacute;liorer la qualit&eacute; de nos services, et nous ne sommes pas responsables des politiques de confidentialit&eacute; ou des mesures de s&eacute;curit&eacute; que vous choisissez de mettre en &oelig;uvre. Si vous souhaitez d&eacute;finir vos propres param&egrave;tres de confidentialit&eacute;, veuillez vous connecter &agrave; votre compte. Nous ne sommes pas responsables des actions des autres utilisateurs des Services qui peuvent choisir de partager leurs Contributions d\'utilisateur. En effet, nous ne pouvons pas contr&ocirc;ler les actions des personnes non autoris&eacute;es. Nous pouvons afficher et partager ces informations avec nos partenaires et d\'autres tiers, et nous pouvons &eacute;galement les diffuser &agrave; un public plus large. Nous utilisons les informations que vous nous fournissez pour am&eacute;liorer la fonctionnalit&eacute; et la qualit&eacute; de nos Services, et pour personnaliser votre exp&eacute;rience lors de l\'utilisation de nos Services. Nous utilisons &eacute;galement ces informations pour afficher des publicit&eacute;s pertinentes, vous fournir une assistance, communiquer avec vous et respecter nos obligations l&eacute;gales.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Informations sur vos amis</p>\r\n<p>Vous avez la possibilit&eacute; de demander &agrave; vos amis de rejoindre les Services en fournissant leurs coordonn&eacute;es.</p>\r\n<p>Informations sur vos messages</p>\r\n<p>Si vous &eacute;changez des messages avec d\'autres via les Services, nous pouvons les stocker afin de les traiter et de les livrer, vous permettre de les g&eacute;rer. Si vous envoyez des informations des Services &agrave; votre appareil mobile par SMS, nous pouvons enregistrer votre num&eacute;ro de t&eacute;l&eacute;phone, votre op&eacute;rateur t&eacute;l&eacute;phonique, ainsi que la date et l\'heure auxquelles le message a &eacute;t&eacute; trait&eacute;. Les op&eacute;rateurs peuvent facturer les destinataires pour les SMS qu\'ils re&ccedil;oivent.</p>\r\n<p>Informations que nous recueillons gr&acirc;ce aux technologies de collecte automatique de donn&eacute;es</p>\r\n<p>Nous pouvons collecter automatiquement certaines informations sur l\'ordinateur ou les appareils (y compris les appareils mobiles) que vous utilisez pour acc&eacute;der &agrave; nos Services, et sur votre utilisation des Services, m&ecirc;me si vous utilisez les Services sans vous inscrire ou vous connecter.</p>\r\n<p>Informations d\'utilisation : d&eacute;tails de votre utilisation de nos Services, y compris les donn&eacute;es de trafic, les donn&eacute;es de localisation, les journaux auxquels vous acc&eacute;dez et que vous utilisez sur ou via nos Services.</p>\r\n<p>&bull; Informations sur l\'ordinateur et l\'appareil : informations sur votre ordinateur, votre connexion Internet et votre appareil mobile, y compris votre adresse IP, vos syst&egrave;mes d\'exploitation, vos plates-formes, le type de navigateur, d\'autres informations de navigation (connexion, vitesse, type de connexion, etc.), le type d\'appareil, l\'appareil unique de l\'appareil identifiant, les informations du r&eacute;seau mobile et le num&eacute;ro de t&eacute;l&eacute;phone de l\'appareil.</p>\r\n<p>Informations et fichiers stock&eacute;s : nos applications peuvent &eacute;galement acc&eacute;der aux m&eacute;tadonn&eacute;es et autres informations associ&eacute;es &agrave; d\'autres fichiers stock&eacute;s sur votre appareil mobile. Cela peut inclure, par exemple, des photographies, des clips audio et vid&eacute;o, des contacts personnels et des informations de carnet d\'adresses.</p>\r\n<p>&bull; Informations de localisation : nos applications collectent des informations en temps r&eacute;el sur la localisation de votre appareil, dans la mesure o&ugrave; vous l\'autorisez.</p>\r\n<p>&bull; Derni&egrave;re URL visit&eacute;e : L\'URL de la derni&egrave;re page Web que vous avez visit&eacute;e avant de visiter nos sites Web.</p>\r\n<p>&bull; Identifiants d\'appareils mobiles : si vous utilisez nos Services sur un appareil mobile, nous pouvons utiliser des identifiants d\'appareils mobiles (l\'identifiant unique attribu&eacute; &agrave; un appareil par le fabricant), au lieu de cookies, pour vous reconna&icirc;tre. Nous pouvons le faire pour stocker vos pr&eacute;f&eacute;rences et suivre votre utilisation de nos applications. Contrairement aux cookies, les identifiants d\'appareils mobiles ne peuvent pas &ecirc;tre supprim&eacute;s. Les soci&eacute;t&eacute;s de publicit&eacute; peuvent utiliser des identifiants d\'appareils pour suivre votre utilisation de nos applications, suivre le nombre de publicit&eacute;s affich&eacute;es, mesurer les performances publicitaires et afficher des publicit&eacute;s plus pertinentes pour vous. Les soci&eacute;t&eacute;s d\'analyse peuvent utiliser des identifiants d\'appareils mobiles pour suivre votre utilisation de nos applications.</p>\r\n<p>&bull; Vos pr&eacute;f&eacute;rences : vos pr&eacute;f&eacute;rences et param&egrave;tres tels que le fuseau horaire et la langue.</p>\r\n<p>&bull; Votre activit&eacute; sur les Services : informations sur votre activit&eacute; sur les Services, telles que vos requ&ecirc;tes de recherche, vos commentaires, les noms de domaine, les r&eacute;sultats de recherche s&eacute;lectionn&eacute;s, le nombre de clics, les pages consult&eacute;es et l\'ordre de ces pages, la dur&eacute;e de votre visite sur nos Services, la date et l\'heure auxquelles vous avez utilis&eacute; les Services, les journaux d\'erreurs et d\'autres informations similaires.</p>\r\n<p>&bull; Statut mobile : Pour les utilisateurs de l\'application mobile, le statut en ligne ou hors ligne de votre application.</p>\r\n<p>&bull; Applications : Si vous utilisez l\'application Je Veux Services Inc, Je Veux Services Inc peut recueillir des informations sur la pr&eacute;sence et/ou l\'absence et/ou des d&eacute;tails relatifs &agrave; d\'autres applications sur votre t&eacute;l&eacute;phone mobile. Les applications pour lesquelles nous recueillons des informations peuvent varier selon les cat&eacute;gories, y compris, sans s\'y limiter. Cela nous aidera &agrave; mieux vous comprendre, vous et vos pr&eacute;f&eacute;rences, et permettra &agrave; Je Veux Services Inc de vous offrir une exp&eacute;rience personnalis&eacute;e.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Informations de localisation pr&eacute;cises</p>\r\n<p>Lorsque vous utilisez l\'un de nos services de localisation (par exemple, lorsque vous acc&eacute;dez aux Services &agrave; partir d\'un appareil mobile), nous pouvons collecter et traiter des informations sur la position GPS de votre appareil mobile (y compris la latitude, la longitude ou l\'altitude de votre appareil mobile) et l\'heure &agrave; laquelle les informations de localisation sont enregistr&eacute;es pour personnaliser les Services avec des informations et des fonctionnalit&eacute;s bas&eacute;es sur la localisation. Certains de ces services n&eacute;cessitent vos donn&eacute;es personnelles pour que la fonctionnalit&eacute; fonctionne et nous pouvons associer des donn&eacute;es de localisation &agrave; l\'identifiant de votre appareil et &agrave; d\'autres informations que nous d&eacute;tenons &agrave; votre sujet. Nous conservons ces donn&eacute;es pendant la dur&eacute;e raisonnablement n&eacute;cessaire pour vous fournir des services. Si vous souhaitez utiliser la fonctionnalit&eacute; particuli&egrave;re, votre consentement sera requis pour que vos donn&eacute;es soient utilis&eacute;es &agrave; cette fin. Vous pouvez retirer votre consentement &agrave; tout moment en d&eacute;sactivant le GPS ou d\'autres fonctions de localisation sur votre appareil, &agrave; condition que votre appareil vous le permette. Consultez les instructions du fabricant de votre appareil pour plus de d&eacute;tails.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Cookies et autres outils &eacute;lectroniques.</p>\r\n<p>Nous, et les tiers avec lesquels nous travaillons en partenariat, pouvons utiliser des cookies, des balises Web, des identifiants d\'appareils mobiles, des &laquo; cookies flash &raquo; et des fichiers ou technologies similaires pour collecter et stocker des informations concernant votre utilisation des Services et des sites Web tiers. Un cookie est un petit fichier texte stock&eacute; sur votre ordinateur qui nous permet de vous reconna&icirc;tre. Lorsque vous visitez notre site Web, enregistrez vos pr&eacute;f&eacute;rences et param&egrave;tres, am&eacute;liorez votre exp&eacute;rience en diffusant du contenu et des publicit&eacute;s sp&eacute;cifiques &agrave; vos centres d\'int&eacute;r&ecirc;t, effectuez des recherches et des analyses, suivez votre utilisation de nos Services et participez aux fonctions de s&eacute;curit&eacute; et d\'administration. Les cookies peuvent &ecirc;tre persistants ou stock&eacute;s uniquement pendant une session individuelle.</p>\r\n<p>La plupart des navigateurs sont configur&eacute;s pour autoriser automatiquement les cookies. Veuillez noter qu\'il peut &ecirc;tre possible de d&eacute;sactiver certains cookies (mais pas tous) via les param&egrave;tres de votre appareil ou de votre navigateur, mais cela peut interf&eacute;rer avec certaines fonctionnalit&eacute;s des Services. Les principaux navigateurs offrent aux utilisateurs diverses options en mati&egrave;re de cookies. Les utilisateurs peuvent g&eacute;n&eacute;ralement configurer leur navigateur pour bloquer tous les cookies tiers (qui sont ceux d&eacute;finis par des soci&eacute;t&eacute;s tierces qui collectent des informations sur des sites Web exploit&eacute;s par d\'autres soci&eacute;t&eacute;s), bloquer tous les cookies (y compris les cookies propri&eacute;taires tels que ceux de Je Veux Services Inc. utilise pour collecter des informations sur les activit&eacute;s de recherche de ses utilisateurs), ou bloquer des cookies sp&eacute;cifiques. Pour modifier vos param&egrave;tres de cookies, veuillez consulter les param&egrave;tres d\'aide de votre navigateur. Vous devrez vous d&eacute;sinscrire sur chaque navigateur et chaque appareil que vous utilisez pour acc&eacute;der aux Services. Les cookies Flash fonctionnent diff&eacute;remment des cookies du navigateur et ne peuvent pas &ecirc;tre supprim&eacute;s ou bloqu&eacute;s via les param&egrave;tres du navigateur Web. En utilisant nos Services avec votre navigateur configur&eacute; pour accepter les cookies, vous consentez &agrave; notre utilisation des cookies de la mani&egrave;re d&eacute;crite dans cette section.</p>\r\n<p>Les tiers dont les produits ou services sont accessibles ou annonc&eacute;s via les Services, y compris les services de m&eacute;dias sociaux, peuvent &eacute;galement utiliser des cookies ou des outils similaires, et nous vous conseillons de consulter leurs politiques de confidentialit&eacute; pour obtenir des informations sur leurs cookies et autres pratiques. Nous ne contr&ocirc;lons pas les pratiques de ces partenaires et leurs politiques de confidentialit&eacute; r&eacute;gissent leurs interactions avec vous.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Informations de tiers</p>\r\n<p>Nous pouvons collecter, traiter et stocker votre identifiant utilisateur associ&eacute; &agrave; tout compte de r&eacute;seau social (tel que votre compte Facebook et Google) que vous utilisez pour vous connecter aux Services ou vous connecter ou utiliser les Services. Lorsque vous vous connectez &agrave; votre compte avec les informations de votre compte de r&eacute;seau social, ou que vous vous connectez autrement &agrave; votre compte de r&eacute;seau social avec les Services, vous consentez &agrave; notre collecte, stockage et utilisation, conform&eacute;ment &agrave; la pr&eacute;sente Politique de confidentialit&eacute;, des informations que vous faites &agrave; notre disposition via l\'interface des m&eacute;dias sociaux. Cela peut inclure, sans s\'y limiter, toute information que vous avez rendue publique via votre compte de r&eacute;seau social, les informations que le service de r&eacute;seau social partage avec nous ou les informations divulgu&eacute;es lors du processus de connexion. Veuillez consulter la politique de confidentialit&eacute; et le centre d\'aide de votre fournisseur de m&eacute;dias sociaux pour plus d\'informations sur la mani&egrave;re dont ils partagent les informations lorsque vous choisissez de connecter votre compte.</p>\r\n<p>Nous pouvons &eacute;galement obtenir des informations vous concernant aupr&egrave;s de tiers tels que des partenaires, des sp&eacute;cialistes du marketing, des sites Web tiers et des chercheurs, et combiner ces informations avec des informations que nous recueillons aupr&egrave;s de vous ou &agrave; votre sujet.</p>\r\n<p>Donn&eacute;es anonymes ou anonymis&eacute;es</p>\r\n<p>Nous pouvons anonymiser et/ou anonymiser les informations collect&eacute;es aupr&egrave;s de vous via les Services ou par d\'autres moyens, y compris via l\'utilisation d\'outils d\'analyse Web tiers, comme d&eacute;crit ci-dessous. Par cons&eacute;quent, notre utilisation et notre divulgation d\'informations agr&eacute;g&eacute;es et/ou anonymis&eacute;es ne sont pas limit&eacute;es par la pr&eacute;sente politique de confidentialit&eacute;, et elles peuvent &ecirc;tre utilis&eacute;es et divulgu&eacute;es &agrave; d\'autres sans limitation.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Comment nous utilisons les informations que nous recueillons</p>\r\n<p>&bull; Traiter et r&eacute;pondre &agrave; vos requ&ecirc;tes</p>\r\n<p>&bull; Comprendre nos utilisateurs (ce qu\'ils font sur nos Services, quelles fonctionnalit&eacute;s ils aiment, comment ils les utilisent, etc.), am&eacute;liorer le contenu et les fonctionnalit&eacute;s de nos Services (par exemple en personnalisant le contenu en fonction de vos int&eacute;r&ecirc;ts), traiter et compl&eacute;ter vos transactions , et faire des offres sp&eacute;ciales.</p>\r\n<p>&bull; Administrer nos Services et diagnostiquer les probl&egrave;mes techniques.</p>\r\n<p>&bull; Vous envoyer les communications que vous avez demand&eacute;es ou susceptibles de vous int&eacute;resser par courrier &eacute;lectronique, courrier recommand&eacute;, appels t&eacute;l&eacute;phoniques ou tout autre moyen de communication.</p>\r\n<p>&bull; Nous permettre de vous montrer des publicit&eacute;s pertinentes pour vous.</p>\r\n<p>&bull; G&eacute;n&eacute;rer et examiner des rapports et des donn&eacute;es sur, et mener des recherches sur, notre base d\'utilisateurs et les mod&egrave;les d\'utilisation du Service.</p>\r\n<p>&bull; Vous fournir un support client.</p>\r\n<p>&bull; Vous fournir des politiques concernant votre compte.</p>\r\n<p>&bull; Ex&eacute;cuter nos obligations et faire valoir nos droits d&eacute;coulant de tout contrat conclu entre vous et nous, y compris pour la facturation et le recouvrement.</p>\r\n<p>&bull; Vous informer des modifications apport&eacute;es &agrave; nos Services.</p>\r\n<p>&bull; Vous permettre de participer aux fonctions interactives offertes par nos Services.</p>\r\n<p>&bull; De toute autre mani&egrave;re que nous pouvons d&eacute;crire lorsque vous fournissez les informations.</p>\r\n<p>&bull; Pour toute autre fin avec votre consentement.</p>\r\n<p>Nous pouvons &eacute;galement utiliser vos informations pour vous contacter au sujet de nos propres produits et services et de ceux de tiers susceptibles de vous int&eacute;resser. Si vous ne souhaitez pas que nous utilisions vos informations de cette mani&egrave;re, veuillez cocher la case correspondante situ&eacute;e sur le formulaire sur lequel nous collectons vos donn&eacute;es et/ou ajuster vos pr&eacute;f&eacute;rences d\'utilisateur dans votre profil de compte.</p>\r\n<p>Nous pouvons utiliser les informations que nous avons recueillies aupr&egrave;s de vous pour nous permettre d\'afficher des publicit&eacute;s aux publics cibles de nos annonceurs/fournisseurs de services. M&ecirc;me si nous ne divulguons pas vos informations personnelles &agrave; ces fins sans votre consentement, si vous cliquez sur ou interagissez autrement avec une publicit&eacute;, l\'annonceur peut supposer que vous r&eacute;pondez &agrave; ses crit&egrave;res cibles.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Comment nous partageons les informations que nous recueillons.</p>\r\n<p>Nous pouvons divulguer les informations personnelles que nous collectons ou que vous fournissez, comme d&eacute;crit dans cette politique de confidentialit&eacute;, des mani&egrave;res suivantes :</p>\r\n<p>&nbsp;</p>\r\n<p>Divulgation d\'informations g&eacute;n&eacute;rales</p>\r\n<p>&bull; &Agrave; nos filiales et soci&eacute;t&eacute;s affili&eacute;es, qui sont des entit&eacute;s sous propri&eacute;t&eacute; ou contr&ocirc;le commun de notre soci&eacute;t&eacute; m&egrave;re ultime Je Veux Services Inc .</p>\r\n<p>&bull; Aux sous-traitants, annonceurs/fournisseurs de services et autres tiers que nous utilisons pour soutenir nos activit&eacute;s et qui sont tenus par des obligations contractuelles de garder les informations personnelles confidentielles et de les utiliser uniquement aux fins pour lesquelles nous les leur divulguons.</p>\r\n<p>&bull; &Agrave; un acqu&eacute;reur ou autre successeur en cas de fusion, cession, restructuration, r&eacute;organisation, dissolution ou autre vente ou transfert de tout ou partie des actifs de Je Veux Services Inc, que ce soit en tant qu\'entreprise en exploitation ou dans le cadre d\'une faillite, liquidation ou proc&eacute;dure similaire, dans laquelle les informations personnelles d&eacute;tenues par Je Veux Services Inc sur les utilisateurs de nos Services font partie des actifs transf&eacute;r&eacute;s.</p>\r\n<p>&bull; &Agrave; des tiers pour vous commercialiser leurs produits ou services si vous avez consenti &agrave; recevoir les mises &agrave; jour promotionnelles. Nous exigeons contractuellement de ces tiers qu\'ils gardent les informations personnelles confidentielles et les utilisent uniquement aux fins pour lesquelles nous les leur communiquons.</p>\r\n<p>&bull; Pour remplir le but pour lequel vous le fournissez.</p>\r\n<p>&bull; Pour toute autre fin divulgu&eacute;e par nous lorsque vous fournissez les informations.</p>\r\n<p>&bull; Les fournisseurs de services. Nous pouvons partager vos informations avec des fournisseurs externes que nous utilisons &agrave; diverses fins, telles que vous envoyer des communications par e-mail, messages ou appels pour vous informer sur nos produits susceptibles de vous int&eacute;resser, des notifications push sur votre appareil mobile sur en notre nom, fournir des services de reconnaissance vocale pour traiter vos requ&ecirc;tes et questions orales, nous aider &agrave; analyser l\'utilisation de nos Services, et traiter et percevoir les paiements. Certains de nos produits, services et bases de donn&eacute;es sont h&eacute;berg&eacute;s par des fournisseurs de services d\'h&eacute;bergement tiers. Nous pouvons &eacute;galement faire appel &agrave; des fournisseurs pour d\'autres projets, tels que la r&eacute;alisation d\'enqu&ecirc;tes ou l\'organisation de tirages au sort pour nous. Nous pouvons partager des informations vous concernant avec ces fournisseurs uniquement pour leur permettre d\'ex&eacute;cuter leurs services.</p>\r\n<p>&nbsp;</p>\r\n<p>Fins l&eacute;gales. Nous pouvons partager vos informations lorsque nous pensons de bonne foi qu\'un tel partage est raisonnablement n&eacute;cessaire pour enqu&ecirc;ter, pr&eacute;venir ou prendre des mesures concernant d\'&eacute;ventuelles activit&eacute;s ill&eacute;gales ou pour se conformer &agrave; une proc&eacute;dure judiciaire. Nous pouvons &eacute;galement partager vos informations pour enqu&ecirc;ter et traiter les menaces ou les menaces potentielles &agrave; la s&eacute;curit&eacute; physique de toute personne, pour enqu&ecirc;ter et traiter les violations de la pr&eacute;sente politique de confidentialit&eacute; ou des conditions d\'utilisation, ou pour enqu&ecirc;ter et traiter les violations des droits de tiers et /ou pour prot&eacute;ger les droits, la propri&eacute;t&eacute; et la s&eacute;curit&eacute; de Je Veux Services Inc, de nos employ&eacute;s, utilisateurs ou du public. Cela peut impliquer le partage de vos informations avec les forces de l\'ordre, les agences gouvernementales, les tribunaux et / ou d\'autres organisations en raison d\'une demande l&eacute;gale telle qu\'une assignation &agrave; compara&icirc;tre, une ordonnance d\'un tribunal ou une demande du gouvernement de se conformer &agrave; la loi.</p>\r\n<p>&bull; R&eacute;seaux sociaux. Si vous interagissez avec des fonctionnalit&eacute;s de m&eacute;dias sociaux sur nos Services, telles que le bouton Facebook Like, ou utilisez vos informations d\'identification de m&eacute;dias sociaux pour vous connecter ou publier du contenu, ces fonctionnalit&eacute;s peuvent collecter des informations sur votre utilisation des Services, ainsi que publier des informations sur vos activit&eacute;s sur le service de m&eacute;dias sociaux. Vos interactions avec les entreprises de m&eacute;dias sociaux sont r&eacute;gies par leurs politiques de confidentialit&eacute;.</p>\r\n<p>&bull; Pour faire respecter ou appliquer nos Conditions d\'utilisation et autres accords, y compris &agrave; des fins de facturation et de recouvrement.</p>\r\n<p>&bull; Si nous croyons que la divulgation est n&eacute;cessaire ou appropri&eacute;e pour prot&eacute;ger les droits, la propri&eacute;t&eacute; ou la s&eacute;curit&eacute; de Je Veux Services Inc, de nos clients ou d\'autres personnes. Cela inclut l\'&eacute;change d\'informations avec d\'autres soci&eacute;t&eacute;s et organisations &agrave; des fins de protection contre la fraude et de r&eacute;duction du risque de cr&eacute;dit.</p>\r\n<p>&bull; Consentement. Nous pouvons partager vos informations dans toute autre circonstance o&ugrave; nous avons votre consentement.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>&nbsp;</p>\r\n<p>Informations de paiement</p>\r\n<p>Pour utiliser nos services, nous pouvons exiger des informations sur votre compte de carte de cr&eacute;dit ou de d&eacute;bit. En soumettant les informations de votre compte de carte de cr&eacute;dit ou de d&eacute;bit via nos services, vous consentez au partage de vos informations avec des processeurs de paiement tiers et d\'autres fournisseurs de services tiers (y compris, mais sans s\'y limiter, les fournisseurs qui nous fournissent des services de d&eacute;tection de fraude et d\'autres tiers), et vous acceptez en outre les conditions suivantes :</p>\r\n<p>&bull; Lorsque vous utilisez une carte de cr&eacute;dit ou de d&eacute;bit pour s&eacute;curiser un service via nos Sites, nous fournissons les informations de votre compte de carte de cr&eacute;dit ou de d&eacute;bit (y compris le num&eacute;ro de carte et la date d\'expiration) &agrave; nos prestataires de services de paiement tiers.</p>\r\n<p>&bull; Lorsque vous fournissez initialement les informations de votre compte de carte de cr&eacute;dit ou de d&eacute;bit via nos Services afin d\'utiliser nos services de paiement, nous fournissons les informations de votre compte de carte de cr&eacute;dit ou de d&eacute;bit &agrave; nos prestataires de services de paiement tiers. Comme expliqu&eacute; dans nos Conditions d\'utilisation, ces tiers peuvent stocker les informations de votre compte de carte de cr&eacute;dit ou de d&eacute;bit afin que vous puissiez utiliser nos services de paiement via nos Services &agrave; l\'avenir.</p>\r\n<p>&bull; Pour plus d\'informations sur la s&eacute;curit&eacute; des informations de votre compte de carte de cr&eacute;dit ou de d&eacute;bit, consultez la section \"S&eacute;curit&eacute;\" ci-dessous.</p>\r\n<p>&nbsp;</p>\r\n<p>Analytique et publicit&eacute; sur mesure</p>\r\n<p>Pour nous aider &agrave; mieux comprendre votre utilisation des Services, nous pouvons utiliser des analyses Web tierces sur nos Services, telles que Google Analytics. Ces fournisseurs de services utilisent le type de technologie d&eacute;crit dans la section &laquo; Informations collect&eacute;es automatiquement &raquo; ci-dessus. Les informations collect&eacute;es par cette technologie seront divulgu&eacute;es ou collect&eacute;es directement par ces prestataires de services, qui utilisent les informations pour &eacute;valuer l\'utilisation des Services par nos utilisateurs. Nous utilisons &eacute;galement Google Analytics comme d&eacute;crit dans la section suivante. Pour emp&ecirc;cher Google Analytics de collecter ou d\'utiliser vos informations, vous pouvez installer le module compl&eacute;mentaire de navigateur de d&eacute;sactivation de Google Analytics.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>&nbsp;</p>\r\n<p>Publicit&eacute; sur mesure</p>\r\n<p>Les tiers dont les produits ou services sont accessibles ou annonc&eacute;s via les Services peuvent &eacute;galement utiliser des cookies ou des technologies similaires pour collecter des informations sur votre utilisation des Services. Ceci est fait afin de les aider-</p>\r\n<p>Informer, optimiser et diffuser des publicit&eacute;s en fonction des visites pass&eacute;es sur notre site Web et d\'autres sites et signaler comment nos impressions publicitaires, d\'autres utilisations des services publicitaires et les interactions avec ces impressions publicitaires et services publicitaires sont li&eacute;es aux visites sur notre site Web. Nous autorisons &eacute;galement d\'autres tiers (par exemple, des r&eacute;seaux publicitaires et des serveurs publicitaires tels que Google Analytics, OpenX, Pubmatic, DoubleClick et autres) &agrave; vous proposer des publicit&eacute;s personnalis&eacute;es sur les Services et &agrave; acc&eacute;der &agrave; leurs propres cookies ou technologies similaires sur votre ordinateur, t&eacute;l&eacute;phone portable ou autre appareil que vous utilisez pour acc&eacute;der aux Services. Nous n\'avons pas acc&egrave;s &agrave;, et cette politique de confidentialit&eacute; ne r&eacute;git pas, l\'utilisation de cookies ou d\'autres technologies de suivi qui peuvent &ecirc;tre plac&eacute;es par ces tiers. Ces parties peuvent vous permettre de d&eacute;sactiver le ciblage publicitaire. Si vous souhaitez plus d\'informations sur la publicit&eacute; sur navigateur personnalis&eacute;e et sur la mani&egrave;re dont vous pouvez g&eacute;n&eacute;ralement contr&ocirc;ler l\'installation de cookies sur votre ordinateur pour diffuser de la publicit&eacute; personnalis&eacute;e (c\'est-&agrave;-dire pas seulement pour les services), vous pouvez visiter le lien de d&eacute;sactivation des consommateurs de la Network Advertising Initiative. , et/ou le lien de d&eacute;sactivation des consommateurs de la Digital Advertising Alliance pour refuser de recevoir des publicit&eacute;s personnalis&eacute;es des entreprises qui participent &agrave; ces programmes. Pour d&eacute;sactiver Google Analytics pour la publicit&eacute; display ou personnaliser les publicit&eacute;s du R&eacute;seau Display de Google, vous pouvez visiter la page Param&egrave;tres Google Ads. Veuillez noter que dans la mesure o&ugrave; la technologie publicitaire est int&eacute;gr&eacute;e aux Services, vous pouvez toujours recevoir des publicit&eacute;s m&ecirc;me si vous vous d&eacute;sabonnez des publicit&eacute;s personnalis&eacute;es. Dans ce cas, les annonces ne seront tout simplement pas adapt&eacute;es &agrave; vos int&eacute;r&ecirc;ts. De plus, nous ne contr&ocirc;lons aucun des liens de d&eacute;sactivation ci-dessus et ne sommes pas responsables des choix que vous faites &agrave; l\'aide de ces m&eacute;canismes ou de la disponibilit&eacute; continue ou de l\'exactitude de ces m&eacute;canismes.</p>\r\n<p>&nbsp;</p>\r\n<p>Lorsque vous acc&eacute;dez aux Services &agrave; partir d\'une application mobile, vous pouvez &eacute;galement recevoir des publicit&eacute;s personnalis&eacute;es int&eacute;gr&eacute;es &agrave; l\'application. Chaque syst&egrave;me d\'exploitation : iOS, Android et Windows Phone fournit ses propres instructions sur la fa&ccedil;on d\'emp&ecirc;cher la diffusion de publicit&eacute;s personnalis&eacute;es dans l\'application. Vous pouvez consulter les documents d\'assistance et/ou les param&egrave;tres de confidentialit&eacute; des syst&egrave;mes d\'exploitation respectifs afin de vous d&eacute;sinscrire des publicit&eacute;s personnalis&eacute;es int&eacute;gr&eacute;es &agrave; l\'application. Pour tout autre appareil et/ou syst&egrave;me d\'exploitation, veuillez consulter les param&egrave;tres de confidentialit&eacute; de l\'appareil ou du syst&egrave;me d\'exploitation concern&eacute; ou contacter l\'op&eacute;rateur de la plateforme concern&eacute;e.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>&nbsp;</p>\r\n<p>Choix sur la fa&ccedil;on dont nous utilisons et divulguons vos informations</p>\r\n<p>&nbsp;</p>\r\n<p>Nous nous effor&ccedil;ons de vous offrir des choix concernant les informations personnelles que vous nous fournissez. Vous pouvez configurer votre navigateur ou votre appareil mobile pour refuser tout ou partie des cookies du navigateur, ou pour vous alerter lorsque des cookies sont envoy&eacute;s. Pour savoir comment vous pouvez g&eacute;rer vos param&egrave;tres de cookies Flash, visitez la page des param&egrave;tres du lecteur Flash sur le site Web d\'Adobe. Si vous d&eacute;sactivez ou refusez les cookies, veuillez noter que certaines parties de nos Services peuvent alors &ecirc;tre inaccessibles ou ne pas fonctionner correctement. Nous ne partageons vos informations personnelles avec aucune agence de publicit&eacute;.</p>\r\n<p>&nbsp;</p>\r\n<p>Choix de communication</p>\r\n<p>Lorsque vous cr&eacute;ez un compte, vous acceptez de recevoir des courriels d\'autres utilisateurs de Je Veux Services Inc, d\'entreprises et de Je Veux Services Inc lui-m&ecirc;me. Vous pouvez vous connecter pour g&eacute;rer vos pr&eacute;f&eacute;rences de messagerie et suivre les instructions de \"d&eacute;sinscription\" dans les messages &eacute;lectroniques commerciaux, mais notez que vous ne pouvez pas refuser de recevoir certaines politiques administratives, politiques de service ou politiques juridiques de Je Veux Services Inc.</p>\r\n<p>&nbsp;</p>\r\n<p>Consulter ou modifier des informations</p>\r\n<p>Si vous souhaitez consulter, modifier ou supprimer des informations personnelles que nous avons recueillies aupr&egrave;s de vous, ou supprimer d&eacute;finitivement votre compte, veuillez utiliser le lien \"Contactez-nous\", ou contactez le d&eacute;l&eacute;gu&eacute; &agrave; la protection des donn&eacute;es (DPO) de Je Veux Services Inc.</p>\r\n<p>Si vous supprimez vos contributions d\'utilisateur de nos sites Web, des copies de vos contributions d\'utilisateur peuvent rester visibles dans les pages mises en cache et archiv&eacute;es, ou peuvent avoir &eacute;t&eacute; copi&eacute;es ou stock&eacute;es par d\'autres utilisateurs de nos sites Web. L\'acc&egrave;s et l\'utilisation appropri&eacute;s des informations fournies sur nos sites Web, y compris les contributions des utilisateurs, sont r&eacute;gis par nos conditions d\'utilisation.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;-</p>\r\n<p>&nbsp;</p>\r\n<p>Acc&egrave;s et modification de vos informations personnelles</p>\r\n<p>Nous prendrons des mesures raisonnables pour enregistrer avec pr&eacute;cision les informations personnelles que vous nous fournissez et toute mise &agrave; jour ult&eacute;rieure.</p>\r\n<p>Nous vous encourageons &agrave; examiner, mettre &agrave; jour et corriger les informations personnelles que nous conservons &agrave; votre sujet, et vous pouvez demander que nous supprimions les informations personnelles vous concernant qui sont inexactes, incompl&egrave;tes ou non pertinentes &agrave; des fins l&eacute;gitimes, ou qui sont trait&eacute;es d\'une mani&egrave;re qui enfreint toute exigence l&eacute;gale applicable.</p>\r\n<p>Votre droit de consulter, mettre &agrave; jour, corriger et supprimer vos informations personnelles peut &ecirc;tre limit&eacute;, sous r&eacute;serve de la loi de votre juridiction :</p>\r\n<p>&bull; Si vos demandes sont abusives ou d&eacute;raisonnablement excessives,</p>\r\n<p>&bull; Lorsque les droits ou la s&eacute;curit&eacute; d\'une autre personne ou de personnes seraient empi&eacute;t&eacute;s, ou</p>\r\n<p>&bull; Si les informations ou le mat&eacute;riel que vous demandez concernent des proc&eacute;dures judiciaires existantes ou pr&eacute;vues entre vous et nous, ou si le fait de vous donner acc&egrave;s nuirait aux n&eacute;gociations entre nous ou &agrave; une enqu&ecirc;te sur une &eacute;ventuelle activit&eacute; ill&eacute;gale. Votre droit d\'examiner, de mettre &agrave; jour, de corriger et de supprimer vos informations est soumis &agrave; nos politiques de conservation des dossiers et &agrave; la loi applicable, y compris les exigences l&eacute;gales de conservation.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>&nbsp;</p>\r\n<p>S&eacute;curit&eacute;</p>\r\n<p>Comment nous prot&eacute;geons vos informations</p>\r\n<p>Nous avons mis en place des proc&eacute;dures physiques, &eacute;lectroniques et de gestion appropri&eacute;es pour prot&eacute;ger et emp&ecirc;cher tout acc&egrave;s non autoris&eacute; &agrave; vos informations et pour maintenir la s&eacute;curit&eacute; des donn&eacute;es. Ces garanties tiennent compte de la sensibilit&eacute; des informations que nous collectons, traitons et stockons et de l\'&eacute;tat actuel de la technologie. Nous suivons les normes g&eacute;n&eacute;ralement accept&eacute;es de l\'industrie pour prot&eacute;ger les informations personnelles qui nous sont soumises, &agrave; la fois pendant la transmission et une fois que nous les recevons. Les fournisseurs de services tiers en ce qui concerne la passerelle de paiement et le traitement des paiements sont tous valid&eacute;s comme conformes &agrave; la norme de l\'industrie des cartes de paiement (g&eacute;n&eacute;ralement appel&eacute;s fournisseurs de services conformes &agrave; la norme PCI).</p>\r\n<p>Nous n\'assumons aucune responsabilit&eacute; en cas de divulgation de vos informations en raison d\'erreurs de transmission, d\'un acc&egrave;s tiers non autoris&eacute; ou d\'autres causes ind&eacute;pendantes de notre volont&eacute;. Vous jouez un r&ocirc;le important dans la protection de vos informations personnelles. Vous ne devez pas partager votre nom d\'utilisateur, votre mot de passe ou toute autre information de s&eacute;curit&eacute; pour votre compte Je Veux Services Inc avec qui que ce soit. Si nous recevons des instructions utilisant votre nom d\'utilisateur et votre mot de passe, nous consid&eacute;rerons que vous avez autoris&eacute; les instructions.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Restrictions d\'&acirc;ge</p>\r\n<p>Les Services ne sont pas destin&eacute;s aux utilisateurs de moins de 18 ans, sauf autorisation en vertu des lois locales applicables (&acirc;ge autoris&eacute;). Nous ne recueillons sciemment aucune information personnelle des utilisateurs ou ne commercialisons ni ne sollicitons d\'informations aupr&egrave;s de quiconque n\'ayant pas atteint l\'&acirc;ge autoris&eacute;. Si nous apprenons qu\'une personne soumettant des informations personnelles n\'a pas atteint l\'&acirc;ge autoris&eacute;, nous supprimerons le compte et toute information connexe d&egrave;s que possible. Si vous pensez que nous pourrions avoir des informations de ou sur un utilisateur sous l\'&acirc;ge autoris&eacute;, veuillez nous contacter &agrave; privacy@Je Veux Services Inc.com.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Liens et services tiers</p>\r\n<p>Les Services peuvent contenir des liens vers des sites Web tiers. Votre utilisation de ces fonctionnalit&eacute;s peut entra&icirc;ner la collecte, le traitement ou le partage d\'informations vous concernant, selon la fonctionnalit&eacute;. Veuillez noter que nous ne sommes pas responsables du contenu ou des pratiques de confidentialit&eacute; d\'autres sites Web ou services qui peuvent &ecirc;tre li&eacute;s &agrave; nos services. Nous n\'approuvons ni ne faisons aucune d&eacute;claration concernant les sites Web ou services tiers. Notre politique de confidentialit&eacute; ne couvre pas les informations que vous choisissez de fournir ou qui sont collect&eacute;es par ces tiers. Nous vous encourageons vivement &agrave; lire les politiques de confidentialit&eacute; de ces tiers.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Conservation des donn&eacute;es et r&eacute;siliation du compte</p>\r\n<p>Vous pouvez fermer votre compte en visitant la page des param&egrave;tres de votre profil sur notre site Web. Nous supprimerons vos publications publiques et/ou les dissocierons du profil de votre compte, mais nous pouvons conserver des informations vous concernant aux fins autoris&eacute;es par la pr&eacute;sente politique de confidentialit&eacute;, sauf si la loi l\'interdit. Par la suite, nous supprimerons vos informations personnelles ou les anonymiserons afin qu\'elles soient anonymes et non attribu&eacute;es &agrave; votre identit&eacute;. Par exemple, nous pouvons conserver des informations pour pr&eacute;venir, enqu&ecirc;ter ou identifier d\'&eacute;ventuels actes r&eacute;pr&eacute;hensibles en rapport avec le Service ou pour nous conformer aux obligations l&eacute;gales.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Opportunit&eacute;s de carri&egrave;re</p>\r\n<p>Si vos informations nous sont soumises par le biais de notre Service lors de la candidature &agrave; un poste au sein de notre soci&eacute;t&eacute;, ces informations seront utilis&eacute;es pour examiner votre candidature. Nous pouvons conserver vos informations pendant une p&eacute;riode quelconque. Ces informations peuvent &ecirc;tre partag&eacute;es avec d\'autres entreprises dans le but d\'&eacute;valuer vos qualifications pour le poste particulier ou d\'autres postes disponibles, ainsi qu\'avec des fournisseurs de services tiers que nous avons retenus pour collecter, conserver et analyser les candidatures aux offres d\'emploi. Pour plus de d&eacute;tails, veuillez consulter la politique de confidentialit&eacute; sur notre page carri&egrave;res.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Modifications de cette politique de confidentialit&eacute;</p>\r\n<p>Nous nous r&eacute;servons le droit de modifier cette politique de confidentialit&eacute; de temps &agrave; autre pour refl&eacute;ter les modifications de la loi, nos pratiques de collecte et d\'utilisation des donn&eacute;es, les fonctionnalit&eacute;s de nos services ou les avanc&eacute;es technologiques. Veuillez v&eacute;rifier cette page p&eacute;riodiquement pour les changements. L\'utilisation des informations que nous collectons est soumise &agrave; la politique de confidentialit&eacute; en vigueur au moment o&ugrave; ces informations sont utilis&eacute;es. Si nous apportons des modifications importantes &agrave; cette politique de confidentialit&eacute;, nous publierons les modifications ici. Veuillez lire attentivement les modifications. Votre utilisation continue des Services apr&egrave;s la publication des modifications apport&eacute;es &agrave; la pr&eacute;sente Politique de confidentialit&eacute; constituera votre consentement et votre acceptation de ces modifications.</p>\r\n<p>&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;&mdash;</p>\r\n<p>Nous contacter</p>\r\n<p>Si vous avez des questions concernant l\'utilisation des informations fournies par vous ou la politique de confidentialit&eacute; de Je Veux Services Inc, vous pouvez envoyer un courriel au d&eacute;l&eacute;gu&eacute; &agrave; la protection des donn&eacute;es (DPO) &agrave; privacy@Je Veux Services Inc.com ou nous &eacute;crire &agrave; l\'adresse suivante.</p>\r\n<p>&nbsp;</p>\r\n<p>&nbsp;</p>');
INSERT INTO `settings` (`id`, `type`, `key`, `value`) VALUES
(17, 'page_about', 'page_about', '<div class=\"who-we-are\">\r\n<div class=\"container\">\r\n<div class=\"row align-items-center mb-5 pb-5\">\r\n<div class=\"col-md-6\">\r\n<div class=\"text\">\r\n<h3>Who we are</h3>\r\n<p>There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet.</p>\r\n</div>\r\n</div>\r\n<div class=\"col-md-6\">\r\n<div class=\"image ps-4\"><img src=\"images/about.webp\" alt=\"\" /></div>\r\n</div>\r\n</div>\r\n<div class=\"row align-items-center\">\r\n<div class=\"col-md-6\">\r\n<div class=\"image\"><img src=\"images/service7.png\" alt=\"\" /></div>\r\n</div>\r\n<div class=\"col-md-6\">\r\n<div class=\"text ps-4\">\r\n<h3>Our mission</h3>\r\n<p>There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don\'t look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn\'t anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet.</p>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n</div>');

-- --------------------------------------------------------

--
-- Table structure for table `sliders`
--

CREATE TABLE `sliders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(191) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `type` varchar(191) DEFAULT NULL COMMENT 'service',
  `type_id` varchar(191) DEFAULT NULL COMMENT 'service_id',
  `status` tinyint(4) DEFAULT 1,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sliders`
--

INSERT INTO `sliders` (`id`, `title`, `description`, `type`, `type_id`, `status`, `deleted_at`, `created_at`, `updated_at`) VALUES
(1, '1', NULL, 'service', '46', 1, NULL, '2022-08-24 19:19:45', '2023-04-14 07:44:38'),
(2, '2', NULL, 'service', '46', 1, NULL, '2022-08-24 19:20:08', '2023-04-14 07:38:07'),
(3, '3', NULL, 'service', '46', 1, NULL, '2022-08-24 19:20:25', '2023-04-14 07:38:06'),
(4, '4', NULL, 'service', '46', 1, NULL, '2022-08-24 19:20:41', '2023-04-14 07:38:08'),
(5, '5', NULL, 'service', '46', 1, NULL, '2022-08-24 19:20:55', '2022-08-24 19:20:55');

-- --------------------------------------------------------

--
-- Table structure for table `states`
--

CREATE TABLE `states` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `country_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `states`
--

INSERT INTO `states` (`id`, `name`, `country_id`) VALUES
(1, 'Andaman and Nicobar Islands', 101),
(2, 'Andhra Pradesh', 101),
(3, 'Arunachal Pradesh', 101),
(4, 'Assam', 101),
(5, 'Bihar', 101),
(6, 'Chandigarh', 101),
(7, 'Chhattisgarh', 101),
(8, 'Dadra and Nagar Haveli', 101),
(9, 'Daman and Diu', 101),
(10, 'Delhi', 101),
(11, 'Goa', 101),
(12, 'Gujarat', 101),
(13, 'Haryana', 101),
(14, 'Himachal Pradesh', 101),
(15, 'Jammu and Kashmir', 101),
(16, 'Jharkhand', 101),
(17, 'Karnataka', 101),
(18, 'Kenmore', 101),
(19, 'Kerala', 101),
(20, 'Lakshadweep', 101),
(21, 'Madhya Pradesh', 101),
(22, 'Maharashtra', 101),
(23, 'Manipur', 101),
(24, 'Meghalaya', 101),
(25, 'Mizoram', 101),
(26, 'Nagaland', 101),
(27, 'Narora', 101),
(28, 'Natwar', 101),
(29, 'Odisha', 101),
(30, 'Paschim Medinipur', 101),
(31, 'Pondicherry', 101),
(32, 'Punjab', 101),
(33, 'Rajasthan', 101),
(34, 'Sikkim', 101),
(35, 'Tamil Nadu', 101),
(36, 'Telangana', 101),
(37, 'Tripura', 101),
(38, 'Uttar Pradesh', 101),
(39, 'Uttarakhand', 101),
(40, 'Vaishali', 101),
(41, 'West Bengal', 101),
(42, 'Badakhshan', 1),
(43, 'Badgis', 1),
(44, 'Baglan', 1),
(45, 'Balkh', 1),
(46, 'Bamiyan', 1),
(47, 'Farah', 1),
(48, 'Faryab', 1),
(49, 'Gawr', 1),
(50, 'Gazni', 1),
(51, 'Herat', 1),
(52, 'Hilmand', 1),
(53, 'Jawzjan', 1),
(54, 'Kabul', 1),
(55, 'Kapisa', 1),
(56, 'Khawst', 1),
(57, 'Kunar', 1),
(58, 'Lagman', 1),
(59, 'Lawghar', 1),
(60, 'Nangarhar', 1),
(61, 'Nimruz', 1),
(62, 'Nuristan', 1),
(63, 'Paktika', 1),
(64, 'Paktiya', 1),
(65, 'Parwan', 1),
(66, 'Qandahar', 1),
(67, 'Qunduz', 1),
(68, 'Samangan', 1),
(69, 'Sar-e Pul', 1),
(70, 'Takhar', 1),
(71, 'Uruzgan', 1),
(72, 'Wardag', 1),
(73, 'Zabul', 1),
(74, 'Berat', 2),
(75, 'Bulqize', 2),
(76, 'Delvine', 2),
(77, 'Devoll', 2),
(78, 'Dibre', 2),
(79, 'Durres', 2),
(80, 'Elbasan', 2),
(81, 'Fier', 2),
(82, 'Gjirokaster', 2),
(83, 'Gramsh', 2),
(84, 'Has', 2),
(85, 'Kavaje', 2),
(86, 'Kolonje', 2),
(87, 'Korce', 2),
(88, 'Kruje', 2),
(89, 'Kucove', 2),
(90, 'Kukes', 2),
(91, 'Kurbin', 2),
(92, 'Lezhe', 2),
(93, 'Librazhd', 2),
(94, 'Lushnje', 2),
(95, 'Mallakaster', 2),
(96, 'Malsi e Madhe', 2),
(97, 'Mat', 2),
(98, 'Mirdite', 2),
(99, 'Peqin', 2),
(100, 'Permet', 2),
(101, 'Pogradec', 2),
(102, 'Puke', 2),
(103, 'Sarande', 2),
(104, 'Shkoder', 2),
(105, 'Skrapar', 2),
(106, 'Tepelene', 2),
(107, 'Tirane', 2),
(108, 'Tropoje', 2),
(109, 'Vlore', 2),
(110, '\'Ayn Daflah', 3),
(111, '\'Ayn Tamushanat', 3),
(112, 'Adrar', 3),
(113, 'Algiers', 3),
(114, 'Annabah', 3),
(115, 'Bashshar', 3),
(116, 'Batnah', 3),
(117, 'Bijayah', 3),
(118, 'Biskrah', 3),
(119, 'Blidah', 3),
(120, 'Buirah', 3),
(121, 'Bumardas', 3),
(122, 'Burj Bu Arririj', 3),
(123, 'Ghalizan', 3),
(124, 'Ghardayah', 3),
(125, 'Ilizi', 3),
(126, 'Jijili', 3),
(127, 'Jilfah', 3),
(128, 'Khanshalah', 3),
(129, 'Masilah', 3),
(130, 'Midyah', 3),
(131, 'Milah', 3),
(132, 'Muaskar', 3),
(133, 'Mustaghanam', 3),
(134, 'Naama', 3),
(135, 'Oran', 3),
(136, 'Ouargla', 3),
(137, 'Qalmah', 3),
(138, 'Qustantinah', 3),
(139, 'Sakikdah', 3),
(140, 'Satif', 3),
(141, 'Sayda\'', 3),
(142, 'Sidi ban-al-\'Abbas', 3),
(143, 'Suq Ahras', 3),
(144, 'Tamanghasat', 3),
(145, 'Tibazah', 3),
(146, 'Tibissah', 3),
(147, 'Tilimsan', 3),
(148, 'Tinduf', 3),
(149, 'Tisamsilt', 3),
(150, 'Tiyarat', 3),
(151, 'Tizi Wazu', 3),
(152, 'Umm-al-Bawaghi', 3),
(153, 'Wahran', 3),
(154, 'Warqla', 3),
(155, 'Wilaya d Alger', 3),
(156, 'Wilaya de Bejaia', 3),
(157, 'Wilaya de Constantine', 3),
(158, 'al-Aghwat', 3),
(159, 'al-Bayadh', 3),
(160, 'al-Jaza\'ir', 3),
(161, 'al-Wad', 3),
(162, 'ash-Shalif', 3),
(163, 'at-Tarif', 3),
(164, 'Eastern', 4),
(165, 'Manu\'a', 4),
(166, 'Swains Island', 4),
(167, 'Western', 4),
(168, 'Andorra la Vella', 5),
(169, 'Canillo', 5),
(170, 'Encamp', 5),
(171, 'La Massana', 5),
(172, 'Les Escaldes', 5),
(173, 'Ordino', 5),
(174, 'Sant Julia de Loria', 5),
(175, 'Bengo', 6),
(176, 'Benguela', 6),
(177, 'Bie', 6),
(178, 'Cabinda', 6),
(179, 'Cunene', 6),
(180, 'Huambo', 6),
(181, 'Huila', 6),
(182, 'Kuando-Kubango', 6),
(183, 'Kwanza Norte', 6),
(184, 'Kwanza Sul', 6),
(185, 'Luanda', 6),
(186, 'Lunda Norte', 6),
(187, 'Lunda Sul', 6),
(188, 'Malanje', 6),
(189, 'Moxico', 6),
(190, 'Namibe', 6),
(191, 'Uige', 6),
(192, 'Zaire', 6),
(193, 'Other Provinces', 7),
(194, 'Sector claimed by Argentina/Ch', 8),
(195, 'Sector claimed by Argentina/UK', 8),
(196, 'Sector claimed by Australia', 8),
(197, 'Sector claimed by France', 8),
(198, 'Sector claimed by New Zealand', 8),
(199, 'Sector claimed by Norway', 8),
(200, 'Unclaimed Sector', 8),
(201, 'Barbuda', 9),
(202, 'Saint George', 9),
(203, 'Saint John', 9),
(204, 'Saint Mary', 9),
(205, 'Saint Paul', 9),
(206, 'Saint Peter', 9),
(207, 'Saint Philip', 9),
(208, 'Buenos Aires', 10),
(209, 'Catamarca', 10),
(210, 'Chaco', 10),
(211, 'Chubut', 10),
(212, 'Cordoba', 10),
(213, 'Corrientes', 10),
(214, 'Distrito Federal', 10),
(215, 'Entre Rios', 10),
(216, 'Formosa', 10),
(217, 'Jujuy', 10),
(218, 'La Pampa', 10),
(219, 'La Rioja', 10),
(220, 'Mendoza', 10),
(221, 'Misiones', 10),
(222, 'Neuquen', 10),
(223, 'Rio Negro', 10),
(224, 'Salta', 10),
(225, 'San Juan', 10),
(226, 'San Luis', 10),
(227, 'Santa Cruz', 10),
(228, 'Santa Fe', 10),
(229, 'Santiago del Estero', 10),
(230, 'Tierra del Fuego', 10),
(231, 'Tucuman', 10),
(232, 'Aragatsotn', 11),
(233, 'Ararat', 11),
(234, 'Armavir', 11),
(235, 'Gegharkunik', 11),
(236, 'Kotaik', 11),
(237, 'Lori', 11),
(238, 'Shirak', 11),
(239, 'Stepanakert', 11),
(240, 'Syunik', 11),
(241, 'Tavush', 11),
(242, 'Vayots Dzor', 11),
(243, 'Yerevan', 11),
(244, 'Aruba', 12),
(245, 'Auckland', 13),
(246, 'Australian Capital Territory', 13),
(247, 'Balgowlah', 13),
(248, 'Balmain', 13),
(249, 'Bankstown', 13),
(250, 'Baulkham Hills', 13),
(251, 'Bonnet Bay', 13),
(252, 'Camberwell', 13),
(253, 'Carole Park', 13),
(254, 'Castle Hill', 13),
(255, 'Caulfield', 13),
(256, 'Chatswood', 13),
(257, 'Cheltenham', 13),
(258, 'Cherrybrook', 13),
(259, 'Clayton', 13),
(260, 'Collingwood', 13),
(261, 'Frenchs Forest', 13),
(262, 'Hawthorn', 13),
(263, 'Jannnali', 13),
(264, 'Knoxfield', 13),
(265, 'Melbourne', 13),
(266, 'New South Wales', 13),
(267, 'Northern Territory', 13),
(268, 'Perth', 13),
(269, 'Queensland', 13),
(270, 'South Australia', 13),
(271, 'Tasmania', 13),
(272, 'Templestowe', 13),
(273, 'Victoria', 13),
(274, 'Werribee south', 13),
(275, 'Western Australia', 13),
(276, 'Wheeler', 13),
(277, 'Bundesland Salzburg', 14),
(278, 'Bundesland Steiermark', 14),
(279, 'Bundesland Tirol', 14),
(280, 'Burgenland', 14),
(281, 'Carinthia', 14),
(282, 'Karnten', 14),
(283, 'Liezen', 14),
(284, 'Lower Austria', 14),
(285, 'Niederosterreich', 14),
(286, 'Oberosterreich', 14),
(287, 'Salzburg', 14),
(288, 'Schleswig-Holstein', 14),
(289, 'Steiermark', 14),
(290, 'Styria', 14),
(291, 'Tirol', 14),
(292, 'Upper Austria', 14),
(293, 'Vorarlberg', 14),
(294, 'Wien', 14),
(295, 'Abseron', 15),
(296, 'Baki Sahari', 15),
(297, 'Ganca', 15),
(298, 'Ganja', 15),
(299, 'Kalbacar', 15),
(300, 'Lankaran', 15),
(301, 'Mil-Qarabax', 15),
(302, 'Mugan-Salyan', 15),
(303, 'Nagorni-Qarabax', 15),
(304, 'Naxcivan', 15),
(305, 'Priaraks', 15),
(306, 'Qazax', 15),
(307, 'Saki', 15),
(308, 'Sirvan', 15),
(309, 'Xacmaz', 15),
(310, 'Abaco', 16),
(311, 'Acklins Island', 16),
(312, 'Andros', 16),
(313, 'Berry Islands', 16),
(314, 'Biminis', 16),
(315, 'Cat Island', 16),
(316, 'Crooked Island', 16),
(317, 'Eleuthera', 16),
(318, 'Exuma and Cays', 16),
(319, 'Grand Bahama', 16),
(320, 'Inagua Islands', 16),
(321, 'Long Island', 16),
(322, 'Mayaguana', 16),
(323, 'New Providence', 16),
(324, 'Ragged Island', 16),
(325, 'Rum Cay', 16),
(326, 'San Salvador', 16),
(327, '\'Isa', 17),
(328, 'Badiyah', 17),
(329, 'Hidd', 17),
(330, 'Jidd Hafs', 17),
(331, 'Mahama', 17),
(332, 'Manama', 17),
(333, 'Sitrah', 17),
(334, 'al-Manamah', 17),
(335, 'al-Muharraq', 17),
(336, 'ar-Rifa\'a', 17),
(337, 'Bagar Hat', 18),
(338, 'Bandarban', 18),
(339, 'Barguna', 18),
(340, 'Barisal', 18),
(341, 'Bhola', 18),
(342, 'Bogora', 18),
(343, 'Brahman Bariya', 18),
(344, 'Chandpur', 18),
(345, 'Chattagam', 18),
(346, 'Chittagong Division', 18),
(347, 'Chuadanga', 18),
(348, 'Dhaka', 18),
(349, 'Dinajpur', 18),
(350, 'Faridpur', 18),
(351, 'Feni', 18),
(352, 'Gaybanda', 18),
(353, 'Gazipur', 18),
(354, 'Gopalganj', 18),
(355, 'Habiganj', 18),
(356, 'Jaipur Hat', 18),
(357, 'Jamalpur', 18),
(358, 'Jessor', 18),
(359, 'Jhalakati', 18),
(360, 'Jhanaydah', 18),
(361, 'Khagrachhari', 18),
(362, 'Khulna', 18),
(363, 'Kishorganj', 18),
(364, 'Koks Bazar', 18),
(365, 'Komilla', 18),
(366, 'Kurigram', 18),
(367, 'Kushtiya', 18),
(368, 'Lakshmipur', 18),
(369, 'Lalmanir Hat', 18),
(370, 'Madaripur', 18),
(371, 'Magura', 18),
(372, 'Maimansingh', 18),
(373, 'Manikganj', 18),
(374, 'Maulvi Bazar', 18),
(375, 'Meherpur', 18),
(376, 'Munshiganj', 18),
(377, 'Naral', 18),
(378, 'Narayanganj', 18),
(379, 'Narsingdi', 18),
(380, 'Nator', 18),
(381, 'Naugaon', 18),
(382, 'Nawabganj', 18),
(383, 'Netrakona', 18),
(384, 'Nilphamari', 18),
(385, 'Noakhali', 18),
(386, 'Pabna', 18),
(387, 'Panchagarh', 18),
(388, 'Patuakhali', 18),
(389, 'Pirojpur', 18),
(390, 'Rajbari', 18),
(391, 'Rajshahi', 18),
(392, 'Rangamati', 18),
(393, 'Rangpur', 18),
(394, 'Satkhira', 18),
(395, 'Shariatpur', 18),
(396, 'Sherpur', 18),
(397, 'Silhat', 18),
(398, 'Sirajganj', 18),
(399, 'Sunamganj', 18),
(400, 'Tangayal', 18),
(401, 'Thakurgaon', 18),
(402, 'Christ Church', 19),
(403, 'Saint Andrew', 19),
(404, 'Saint George', 19),
(405, 'Saint James', 19),
(406, 'Saint John', 19),
(407, 'Saint Joseph', 19),
(408, 'Saint Lucy', 19),
(409, 'Saint Michael', 19),
(410, 'Saint Peter', 19),
(411, 'Saint Philip', 19),
(412, 'Saint Thomas', 19),
(413, 'Brest', 20),
(414, 'Homjel\'', 20),
(415, 'Hrodna', 20),
(416, 'Mahiljow', 20),
(417, 'Mahilyowskaya Voblasts', 20),
(418, 'Minsk', 20),
(419, 'Minskaja Voblasts\'', 20),
(420, 'Petrik', 20),
(421, 'Vicebsk', 20),
(422, 'Antwerpen', 21),
(423, 'Berchem', 21),
(424, 'Brabant', 21),
(425, 'Brabant Wallon', 21),
(426, 'Brussel', 21),
(427, 'East Flanders', 21),
(428, 'Hainaut', 21),
(429, 'Liege', 21),
(430, 'Limburg', 21),
(431, 'Luxembourg', 21),
(432, 'Namur', 21),
(433, 'Ontario', 21),
(434, 'Oost-Vlaanderen', 21),
(435, 'Provincie Brabant', 21),
(436, 'Vlaams-Brabant', 21),
(437, 'Wallonne', 21),
(438, 'West-Vlaanderen', 21),
(439, 'Belize', 22),
(440, 'Cayo', 22),
(441, 'Corozal', 22),
(442, 'Orange Walk', 22),
(443, 'Stann Creek', 22),
(444, 'Toledo', 22),
(445, 'Alibori', 23),
(446, 'Atacora', 23),
(447, 'Atlantique', 23),
(448, 'Borgou', 23),
(449, 'Collines', 23),
(450, 'Couffo', 23),
(451, 'Donga', 23),
(452, 'Littoral', 23),
(453, 'Mono', 23),
(454, 'Oueme', 23),
(455, 'Plateau', 23),
(456, 'Zou', 23),
(457, 'Hamilton', 24),
(458, 'Saint George', 24),
(459, 'Bumthang', 25),
(460, 'Chhukha', 25),
(461, 'Chirang', 25),
(462, 'Daga', 25),
(463, 'Geylegphug', 25),
(464, 'Ha', 25),
(465, 'Lhuntshi', 25),
(466, 'Mongar', 25),
(467, 'Pemagatsel', 25),
(468, 'Punakha', 25),
(469, 'Rinpung', 25),
(470, 'Samchi', 25),
(471, 'Samdrup Jongkhar', 25),
(472, 'Shemgang', 25),
(473, 'Tashigang', 25),
(474, 'Timphu', 25),
(475, 'Tongsa', 25),
(476, 'Wangdiphodrang', 25),
(477, 'Beni', 26),
(478, 'Chuquisaca', 26),
(479, 'Cochabamba', 26),
(480, 'La Paz', 26),
(481, 'Oruro', 26),
(482, 'Pando', 26),
(483, 'Potosi', 26),
(484, 'Santa Cruz', 26),
(485, 'Tarija', 26),
(486, 'Federacija Bosna i Hercegovina', 27),
(487, 'Republika Srpska', 27),
(488, 'Central Bobonong', 28),
(489, 'Central Boteti', 28),
(490, 'Central Mahalapye', 28),
(491, 'Central Serowe-Palapye', 28),
(492, 'Central Tutume', 28),
(493, 'Chobe', 28),
(494, 'Francistown', 28),
(495, 'Gaborone', 28),
(496, 'Ghanzi', 28),
(497, 'Jwaneng', 28),
(498, 'Kgalagadi North', 28),
(499, 'Kgalagadi South', 28),
(500, 'Kgatleng', 28),
(501, 'Kweneng', 28),
(502, 'Lobatse', 28),
(503, 'Ngamiland', 28),
(504, 'Ngwaketse', 28),
(505, 'North East', 28),
(506, 'Okavango', 28),
(507, 'Orapa', 28),
(508, 'Selibe Phikwe', 28),
(509, 'South East', 28),
(510, 'Sowa', 28),
(511, 'Bouvet Island', 29),
(512, 'Acre', 30),
(513, 'Alagoas', 30),
(514, 'Amapa', 30),
(515, 'Amazonas', 30),
(516, 'Bahia', 30),
(517, 'Ceara', 30),
(518, 'Distrito Federal', 30),
(519, 'Espirito Santo', 30),
(520, 'Estado de Sao Paulo', 30),
(521, 'Goias', 30),
(522, 'Maranhao', 30),
(523, 'Mato Grosso', 30),
(524, 'Mato Grosso do Sul', 30),
(525, 'Minas Gerais', 30),
(526, 'Para', 30),
(527, 'Paraiba', 30),
(528, 'Parana', 30),
(529, 'Pernambuco', 30),
(530, 'Piaui', 30),
(531, 'Rio Grande do Norte', 30),
(532, 'Rio Grande do Sul', 30),
(533, 'Rio de Janeiro', 30),
(534, 'Rondonia', 30),
(535, 'Roraima', 30),
(536, 'Santa Catarina', 30),
(537, 'Sao Paulo', 30),
(538, 'Sergipe', 30),
(539, 'Tocantins', 30),
(540, 'British Indian Ocean Territory', 31),
(541, 'Belait', 32),
(542, 'Brunei-Muara', 32),
(543, 'Temburong', 32),
(544, 'Tutong', 32),
(545, 'Blagoevgrad', 33),
(546, 'Burgas', 33),
(547, 'Dobrich', 33),
(548, 'Gabrovo', 33),
(549, 'Haskovo', 33),
(550, 'Jambol', 33),
(551, 'Kardzhali', 33),
(552, 'Kjustendil', 33),
(553, 'Lovech', 33),
(554, 'Montana', 33),
(555, 'Oblast Sofiya-Grad', 33),
(556, 'Pazardzhik', 33),
(557, 'Pernik', 33),
(558, 'Pleven', 33),
(559, 'Plovdiv', 33),
(560, 'Razgrad', 33),
(561, 'Ruse', 33),
(562, 'Shumen', 33),
(563, 'Silistra', 33),
(564, 'Sliven', 33),
(565, 'Smoljan', 33),
(566, 'Sofija grad', 33),
(567, 'Sofijska oblast', 33),
(568, 'Stara Zagora', 33),
(569, 'Targovishte', 33),
(570, 'Varna', 33),
(571, 'Veliko Tarnovo', 33),
(572, 'Vidin', 33),
(573, 'Vraca', 33),
(574, 'Yablaniza', 33),
(575, 'Bale', 34),
(576, 'Bam', 34),
(577, 'Bazega', 34),
(578, 'Bougouriba', 34),
(579, 'Boulgou', 34),
(580, 'Boulkiemde', 34),
(581, 'Comoe', 34),
(582, 'Ganzourgou', 34),
(583, 'Gnagna', 34),
(584, 'Gourma', 34),
(585, 'Houet', 34),
(586, 'Ioba', 34),
(587, 'Kadiogo', 34),
(588, 'Kenedougou', 34),
(589, 'Komandjari', 34),
(590, 'Kompienga', 34),
(591, 'Kossi', 34),
(592, 'Kouritenga', 34),
(593, 'Kourweogo', 34),
(594, 'Leraba', 34),
(595, 'Mouhoun', 34),
(596, 'Nahouri', 34),
(597, 'Namentenga', 34),
(598, 'Noumbiel', 34),
(599, 'Oubritenga', 34),
(600, 'Oudalan', 34),
(601, 'Passore', 34),
(602, 'Poni', 34),
(603, 'Sanguie', 34),
(604, 'Sanmatenga', 34),
(605, 'Seno', 34),
(606, 'Sissili', 34),
(607, 'Soum', 34),
(608, 'Sourou', 34),
(609, 'Tapoa', 34),
(610, 'Tuy', 34),
(611, 'Yatenga', 34),
(612, 'Zondoma', 34),
(613, 'Zoundweogo', 34),
(614, 'Bubanza', 35),
(615, 'Bujumbura', 35),
(616, 'Bururi', 35),
(617, 'Cankuzo', 35),
(618, 'Cibitoke', 35),
(619, 'Gitega', 35),
(620, 'Karuzi', 35),
(621, 'Kayanza', 35),
(622, 'Kirundo', 35),
(623, 'Makamba', 35),
(624, 'Muramvya', 35),
(625, 'Muyinga', 35),
(626, 'Ngozi', 35),
(627, 'Rutana', 35),
(628, 'Ruyigi', 35),
(629, 'Banteay Mean Chey', 36),
(630, 'Bat Dambang', 36),
(631, 'Kampong Cham', 36),
(632, 'Kampong Chhnang', 36),
(633, 'Kampong Spoeu', 36),
(634, 'Kampong Thum', 36),
(635, 'Kampot', 36),
(636, 'Kandal', 36),
(637, 'Kaoh Kong', 36),
(638, 'Kracheh', 36),
(639, 'Krong Kaeb', 36),
(640, 'Krong Pailin', 36),
(641, 'Krong Preah Sihanouk', 36),
(642, 'Mondol Kiri', 36),
(643, 'Otdar Mean Chey', 36),
(644, 'Phnum Penh', 36),
(645, 'Pousat', 36),
(646, 'Preah Vihear', 36),
(647, 'Prey Veaeng', 36),
(648, 'Rotanak Kiri', 36),
(649, 'Siem Reab', 36),
(650, 'Stueng Traeng', 36),
(651, 'Svay Rieng', 36),
(652, 'Takaev', 36),
(653, 'Adamaoua', 37),
(654, 'Centre', 37),
(655, 'Est', 37),
(656, 'Littoral', 37),
(657, 'Nord', 37),
(658, 'Nord Extreme', 37),
(659, 'Nordouest', 37),
(660, 'Ouest', 37),
(661, 'Sud', 37),
(662, 'Sudouest', 37),
(663, 'Alberta', 38),
(664, 'British Columbia', 38),
(665, 'Manitoba', 38),
(666, 'New Brunswick', 38),
(667, 'Newfoundland and Labrador', 38),
(668, 'Northwest Territories', 38),
(669, 'Nova Scotia', 38),
(670, 'Nunavut', 38),
(671, 'Ontario', 38),
(672, 'Prince Edward Island', 38),
(673, 'Quebec', 38),
(674, 'Saskatchewan', 38),
(675, 'Yukon', 38),
(676, 'Boavista', 39),
(677, 'Brava', 39),
(678, 'Fogo', 39),
(679, 'Maio', 39),
(680, 'Sal', 39),
(681, 'Santo Antao', 39),
(682, 'Sao Nicolau', 39),
(683, 'Sao Tiago', 39),
(684, 'Sao Vicente', 39),
(685, 'Grand Cayman', 40),
(686, 'Bamingui-Bangoran', 41),
(687, 'Bangui', 41),
(688, 'Basse-Kotto', 41),
(689, 'Haut-Mbomou', 41),
(690, 'Haute-Kotto', 41),
(691, 'Kemo', 41),
(692, 'Lobaye', 41),
(693, 'Mambere-Kadei', 41),
(694, 'Mbomou', 41),
(695, 'Nana-Gribizi', 41),
(696, 'Nana-Mambere', 41),
(697, 'Ombella Mpoko', 41),
(698, 'Ouaka', 41),
(699, 'Ouham', 41),
(700, 'Ouham-Pende', 41),
(701, 'Sangha-Mbaere', 41),
(702, 'Vakaga', 41),
(703, 'Batha', 42),
(704, 'Biltine', 42),
(705, 'Bourkou-Ennedi-Tibesti', 42),
(706, 'Chari-Baguirmi', 42),
(707, 'Guera', 42),
(708, 'Kanem', 42),
(709, 'Lac', 42),
(710, 'Logone Occidental', 42),
(711, 'Logone Oriental', 42),
(712, 'Mayo-Kebbi', 42),
(713, 'Moyen-Chari', 42),
(714, 'Ouaddai', 42),
(715, 'Salamat', 42),
(716, 'Tandjile', 42),
(717, 'Aisen', 43),
(718, 'Antofagasta', 43),
(719, 'Araucania', 43),
(720, 'Atacama', 43),
(721, 'Bio Bio', 43),
(722, 'Coquimbo', 43),
(723, 'Libertador General Bernardo O\'', 43),
(724, 'Los Lagos', 43),
(725, 'Magellanes', 43),
(726, 'Maule', 43),
(727, 'Metropolitana', 43),
(728, 'Metropolitana de Santiago', 43),
(729, 'Tarapaca', 43),
(730, 'Valparaiso', 43),
(731, 'Anhui', 44),
(732, 'Anhui Province', 44),
(733, 'Anhui Sheng', 44),
(734, 'Aomen', 44),
(735, 'Beijing', 44),
(736, 'Beijing Shi', 44),
(737, 'Chongqing', 44),
(738, 'Fujian', 44),
(739, 'Fujian Sheng', 44),
(740, 'Gansu', 44),
(741, 'Guangdong', 44),
(742, 'Guangdong Sheng', 44),
(743, 'Guangxi', 44),
(744, 'Guizhou', 44),
(745, 'Hainan', 44),
(746, 'Hebei', 44),
(747, 'Heilongjiang', 44),
(748, 'Henan', 44),
(749, 'Hubei', 44),
(750, 'Hunan', 44),
(751, 'Jiangsu', 44),
(752, 'Jiangsu Sheng', 44),
(753, 'Jiangxi', 44),
(754, 'Jilin', 44),
(755, 'Liaoning', 44),
(756, 'Liaoning Sheng', 44),
(757, 'Nei Monggol', 44),
(758, 'Ningxia Hui', 44),
(759, 'Qinghai', 44),
(760, 'Shaanxi', 44),
(761, 'Shandong', 44),
(762, 'Shandong Sheng', 44),
(763, 'Shanghai', 44),
(764, 'Shanxi', 44),
(765, 'Sichuan', 44),
(766, 'Tianjin', 44),
(767, 'Xianggang', 44),
(768, 'Xinjiang', 44),
(769, 'Xizang', 44),
(770, 'Yunnan', 44),
(771, 'Zhejiang', 44),
(772, 'Zhejiang Sheng', 44),
(773, 'Christmas Island', 45),
(774, 'Cocos (Keeling) Islands', 46),
(775, 'Amazonas', 47),
(776, 'Antioquia', 47),
(777, 'Arauca', 47),
(778, 'Atlantico', 47),
(779, 'Bogota', 47),
(780, 'Bolivar', 47),
(781, 'Boyaca', 47),
(782, 'Caldas', 47),
(783, 'Caqueta', 47),
(784, 'Casanare', 47),
(785, 'Cauca', 47),
(786, 'Cesar', 47),
(787, 'Choco', 47),
(788, 'Cordoba', 47),
(789, 'Cundinamarca', 47),
(790, 'Guainia', 47),
(791, 'Guaviare', 47),
(792, 'Huila', 47),
(793, 'La Guajira', 47),
(794, 'Magdalena', 47),
(795, 'Meta', 47),
(796, 'Narino', 47),
(797, 'Norte de Santander', 47),
(798, 'Putumayo', 47),
(799, 'Quindio', 47),
(800, 'Risaralda', 47),
(801, 'San Andres y Providencia', 47),
(802, 'Santander', 47),
(803, 'Sucre', 47),
(804, 'Tolima', 47),
(805, 'Valle del Cauca', 47),
(806, 'Vaupes', 47),
(807, 'Vichada', 47),
(808, 'Mwali', 48),
(809, 'Njazidja', 48),
(810, 'Nzwani', 48),
(811, 'Bouenza', 49),
(812, 'Brazzaville', 49),
(813, 'Cuvette', 49),
(814, 'Kouilou', 49),
(815, 'Lekoumou', 49),
(816, 'Likouala', 49),
(817, 'Niari', 49),
(818, 'Plateaux', 49),
(819, 'Pool', 49),
(820, 'Sangha', 49),
(821, 'Bandundu', 50),
(822, 'Bas-Congo', 50),
(823, 'Equateur', 50),
(824, 'Haut-Congo', 50),
(825, 'Kasai-Occidental', 50),
(826, 'Kasai-Oriental', 50),
(827, 'Katanga', 50),
(828, 'Kinshasa', 50),
(829, 'Maniema', 50),
(830, 'Nord-Kivu', 50),
(831, 'Sud-Kivu', 50),
(832, 'Aitutaki', 51),
(833, 'Atiu', 51),
(834, 'Mangaia', 51),
(835, 'Manihiki', 51),
(836, 'Mauke', 51),
(837, 'Mitiaro', 51),
(838, 'Nassau', 51),
(839, 'Pukapuka', 51),
(840, 'Rakahanga', 51),
(841, 'Rarotonga', 51),
(842, 'Tongareva', 51),
(843, 'Alajuela', 52),
(844, 'Cartago', 52),
(845, 'Guanacaste', 52),
(846, 'Heredia', 52),
(847, 'Limon', 52),
(848, 'Puntarenas', 52),
(849, 'San Jose', 52),
(850, 'Abidjan', 53),
(851, 'Agneby', 53),
(852, 'Bafing', 53),
(853, 'Denguele', 53),
(854, 'Dix-huit Montagnes', 53),
(855, 'Fromager', 53),
(856, 'Haut-Sassandra', 53),
(857, 'Lacs', 53),
(858, 'Lagunes', 53),
(859, 'Marahoue', 53),
(860, 'Moyen-Cavally', 53),
(861, 'Moyen-Comoe', 53),
(862, 'N\'zi-Comoe', 53),
(863, 'Sassandra', 53),
(864, 'Savanes', 53),
(865, 'Sud-Bandama', 53),
(866, 'Sud-Comoe', 53),
(867, 'Vallee du Bandama', 53),
(868, 'Worodougou', 53),
(869, 'Zanzan', 53),
(870, 'Bjelovar-Bilogora', 54),
(871, 'Dubrovnik-Neretva', 54),
(872, 'Grad Zagreb', 54),
(873, 'Istra', 54),
(874, 'Karlovac', 54),
(875, 'Koprivnica-Krizhevci', 54),
(876, 'Krapina-Zagorje', 54),
(877, 'Lika-Senj', 54),
(878, 'Medhimurje', 54),
(879, 'Medimurska Zupanija', 54),
(880, 'Osijek-Baranja', 54),
(881, 'Osjecko-Baranjska Zupanija', 54),
(882, 'Pozhega-Slavonija', 54),
(883, 'Primorje-Gorski Kotar', 54),
(884, 'Shibenik-Knin', 54),
(885, 'Sisak-Moslavina', 54),
(886, 'Slavonski Brod-Posavina', 54),
(887, 'Split-Dalmacija', 54),
(888, 'Varazhdin', 54),
(889, 'Virovitica-Podravina', 54),
(890, 'Vukovar-Srijem', 54),
(891, 'Zadar', 54),
(892, 'Zagreb', 54),
(893, 'Camaguey', 55),
(894, 'Ciego de Avila', 55),
(895, 'Cienfuegos', 55),
(896, 'Ciudad de la Habana', 55),
(897, 'Granma', 55),
(898, 'Guantanamo', 55),
(899, 'Habana', 55),
(900, 'Holguin', 55),
(901, 'Isla de la Juventud', 55),
(902, 'La Habana', 55),
(903, 'Las Tunas', 55),
(904, 'Matanzas', 55),
(905, 'Pinar del Rio', 55),
(906, 'Sancti Spiritus', 55),
(907, 'Santiago de Cuba', 55),
(908, 'Villa Clara', 55),
(909, 'Government controlled area', 56),
(910, 'Limassol', 56),
(911, 'Nicosia District', 56),
(912, 'Paphos', 56),
(913, 'Turkish controlled area', 56),
(914, 'Central Bohemian', 57),
(915, 'Frycovice', 57),
(916, 'Jihocesky Kraj', 57),
(917, 'Jihochesky', 57),
(918, 'Jihomoravsky', 57),
(919, 'Karlovarsky', 57),
(920, 'Klecany', 57),
(921, 'Kralovehradecky', 57),
(922, 'Liberecky', 57),
(923, 'Lipov', 57),
(924, 'Moravskoslezsky', 57),
(925, 'Olomoucky', 57),
(926, 'Olomoucky Kraj', 57),
(927, 'Pardubicky', 57),
(928, 'Plzensky', 57),
(929, 'Praha', 57),
(930, 'Rajhrad', 57),
(931, 'Smirice', 57),
(932, 'South Moravian', 57),
(933, 'Straz nad Nisou', 57),
(934, 'Stredochesky', 57),
(935, 'Unicov', 57),
(936, 'Ustecky', 57),
(937, 'Valletta', 57),
(938, 'Velesin', 57),
(939, 'Vysochina', 57),
(940, 'Zlinsky', 57),
(941, 'Arhus', 58),
(942, 'Bornholm', 58),
(943, 'Frederiksborg', 58),
(944, 'Fyn', 58),
(945, 'Hovedstaden', 58),
(946, 'Kobenhavn', 58),
(947, 'Kobenhavns Amt', 58),
(948, 'Kobenhavns Kommune', 58),
(949, 'Nordjylland', 58),
(950, 'Ribe', 58),
(951, 'Ringkobing', 58),
(952, 'Roervig', 58),
(953, 'Roskilde', 58),
(954, 'Roslev', 58),
(955, 'Sjaelland', 58),
(956, 'Soeborg', 58),
(957, 'Sonderjylland', 58),
(958, 'Storstrom', 58),
(959, 'Syddanmark', 58),
(960, 'Toelloese', 58),
(961, 'Vejle', 58),
(962, 'Vestsjalland', 58),
(963, 'Viborg', 58),
(964, '\'Ali Sabih', 59),
(965, 'Dikhil', 59),
(966, 'Jibuti', 59),
(967, 'Tajurah', 59),
(968, 'Ubuk', 59),
(969, 'Saint Andrew', 60),
(970, 'Saint David', 60),
(971, 'Saint George', 60),
(972, 'Saint John', 60),
(973, 'Saint Joseph', 60),
(974, 'Saint Luke', 60),
(975, 'Saint Mark', 60),
(976, 'Saint Patrick', 60),
(977, 'Saint Paul', 60),
(978, 'Saint Peter', 60),
(979, 'Azua', 61),
(980, 'Bahoruco', 61),
(981, 'Barahona', 61),
(982, 'Dajabon', 61),
(983, 'Distrito Nacional', 61),
(984, 'Duarte', 61),
(985, 'El Seybo', 61),
(986, 'Elias Pina', 61),
(987, 'Espaillat', 61),
(988, 'Hato Mayor', 61),
(989, 'Independencia', 61),
(990, 'La Altagracia', 61),
(991, 'La Romana', 61),
(992, 'La Vega', 61),
(993, 'Maria Trinidad Sanchez', 61),
(994, 'Monsenor Nouel', 61),
(995, 'Monte Cristi', 61),
(996, 'Monte Plata', 61),
(997, 'Pedernales', 61),
(998, 'Peravia', 61),
(999, 'Puerto Plata', 61),
(1000, 'Salcedo', 61),
(1001, 'Samana', 61),
(1002, 'San Cristobal', 61),
(1003, 'San Juan', 61),
(1004, 'San Pedro de Macoris', 61),
(1005, 'Sanchez Ramirez', 61),
(1006, 'Santiago', 61),
(1007, 'Santiago Rodriguez', 61),
(1008, 'Valverde', 61),
(1009, 'Aileu', 62),
(1010, 'Ainaro', 62),
(1011, 'Ambeno', 62),
(1012, 'Baucau', 62),
(1013, 'Bobonaro', 62),
(1014, 'Cova Lima', 62),
(1015, 'Dili', 62),
(1016, 'Ermera', 62),
(1017, 'Lautem', 62),
(1018, 'Liquica', 62),
(1019, 'Manatuto', 62),
(1020, 'Manufahi', 62),
(1021, 'Viqueque', 62),
(1022, 'Azuay', 63),
(1023, 'Bolivar', 63),
(1024, 'Canar', 63),
(1025, 'Carchi', 63),
(1026, 'Chimborazo', 63),
(1027, 'Cotopaxi', 63),
(1028, 'El Oro', 63),
(1029, 'Esmeraldas', 63),
(1030, 'Galapagos', 63),
(1031, 'Guayas', 63),
(1032, 'Imbabura', 63),
(1033, 'Loja', 63),
(1034, 'Los Rios', 63),
(1035, 'Manabi', 63),
(1036, 'Morona Santiago', 63),
(1037, 'Napo', 63),
(1038, 'Orellana', 63),
(1039, 'Pastaza', 63),
(1040, 'Pichincha', 63),
(1041, 'Sucumbios', 63),
(1042, 'Tungurahua', 63),
(1043, 'Zamora Chinchipe', 63),
(1044, 'Aswan', 64),
(1045, 'Asyut', 64),
(1046, 'Bani Suwayf', 64),
(1047, 'Bur Sa\'id', 64),
(1048, 'Cairo', 64),
(1049, 'Dumyat', 64),
(1050, 'Kafr-ash-Shaykh', 64),
(1051, 'Matruh', 64),
(1052, 'Muhafazat ad Daqahliyah', 64),
(1053, 'Muhafazat al Fayyum', 64),
(1054, 'Muhafazat al Gharbiyah', 64),
(1055, 'Muhafazat al Iskandariyah', 64),
(1056, 'Muhafazat al Qahirah', 64),
(1057, 'Qina', 64),
(1058, 'Sawhaj', 64),
(1059, 'Sina al-Janubiyah', 64),
(1060, 'Sina ash-Shamaliyah', 64),
(1061, 'ad-Daqahliyah', 64),
(1062, 'al-Bahr-al-Ahmar', 64),
(1063, 'al-Buhayrah', 64),
(1064, 'al-Fayyum', 64),
(1065, 'al-Gharbiyah', 64),
(1066, 'al-Iskandariyah', 64),
(1067, 'al-Ismailiyah', 64),
(1068, 'al-Jizah', 64),
(1069, 'al-Minufiyah', 64),
(1070, 'al-Minya', 64),
(1071, 'al-Qahira', 64),
(1072, 'al-Qalyubiyah', 64),
(1073, 'al-Uqsur', 64),
(1074, 'al-Wadi al-Jadid', 64),
(1075, 'as-Suways', 64),
(1076, 'ash-Sharqiyah', 64),
(1077, 'Ahuachapan', 65),
(1078, 'Cabanas', 65),
(1079, 'Chalatenango', 65),
(1080, 'Cuscatlan', 65),
(1081, 'La Libertad', 65),
(1082, 'La Paz', 65),
(1083, 'La Union', 65),
(1084, 'Morazan', 65),
(1085, 'San Miguel', 65),
(1086, 'San Salvador', 65),
(1087, 'San Vicente', 65),
(1088, 'Santa Ana', 65),
(1089, 'Sonsonate', 65),
(1090, 'Usulutan', 65),
(1091, 'Annobon', 66),
(1092, 'Bioko Norte', 66),
(1093, 'Bioko Sur', 66),
(1094, 'Centro Sur', 66),
(1095, 'Kie-Ntem', 66),
(1096, 'Litoral', 66),
(1097, 'Wele-Nzas', 66),
(1098, 'Anseba', 67),
(1099, 'Debub', 67),
(1100, 'Debub-Keih-Bahri', 67),
(1101, 'Gash-Barka', 67),
(1102, 'Maekel', 67),
(1103, 'Semien-Keih-Bahri', 67),
(1104, 'Harju', 68),
(1105, 'Hiiu', 68),
(1106, 'Ida-Viru', 68),
(1107, 'Jarva', 68),
(1108, 'Jogeva', 68),
(1109, 'Laane', 68),
(1110, 'Laane-Viru', 68),
(1111, 'Parnu', 68),
(1112, 'Polva', 68),
(1113, 'Rapla', 68),
(1114, 'Saare', 68),
(1115, 'Tartu', 68),
(1116, 'Valga', 68),
(1117, 'Viljandi', 68),
(1118, 'Voru', 68),
(1119, 'Addis Abeba', 69),
(1120, 'Afar', 69),
(1121, 'Amhara', 69),
(1122, 'Benishangul', 69),
(1123, 'Diredawa', 69),
(1124, 'Gambella', 69),
(1125, 'Harar', 69),
(1126, 'Jigjiga', 69),
(1127, 'Mekele', 69),
(1128, 'Oromia', 69),
(1129, 'Somali', 69),
(1130, 'Southern', 69),
(1131, 'Tigray', 69),
(1132, 'Christmas Island', 70),
(1133, 'Cocos Islands', 70),
(1134, 'Coral Sea Islands', 70),
(1135, 'Falkland Islands', 71),
(1136, 'South Georgia', 71),
(1137, 'Klaksvik', 72),
(1138, 'Nor ara Eysturoy', 72),
(1139, 'Nor oy', 72),
(1140, 'Sandoy', 72),
(1141, 'Streymoy', 72),
(1142, 'Su uroy', 72),
(1143, 'Sy ra Eysturoy', 72),
(1144, 'Torshavn', 72),
(1145, 'Vaga', 72),
(1146, 'Central', 73),
(1147, 'Eastern', 73),
(1148, 'Northern', 73),
(1149, 'South Pacific', 73),
(1150, 'Western', 73),
(1151, 'Ahvenanmaa', 74),
(1152, 'Etela-Karjala', 74),
(1153, 'Etela-Pohjanmaa', 74),
(1154, 'Etela-Savo', 74),
(1155, 'Etela-Suomen Laani', 74),
(1156, 'Ita-Suomen Laani', 74),
(1157, 'Ita-Uusimaa', 74),
(1158, 'Kainuu', 74),
(1159, 'Kanta-Hame', 74),
(1160, 'Keski-Pohjanmaa', 74),
(1161, 'Keski-Suomi', 74),
(1162, 'Kymenlaakso', 74),
(1163, 'Lansi-Suomen Laani', 74),
(1164, 'Lappi', 74),
(1165, 'Northern Savonia', 74),
(1166, 'Ostrobothnia', 74),
(1167, 'Oulun Laani', 74),
(1168, 'Paijat-Hame', 74),
(1169, 'Pirkanmaa', 74),
(1170, 'Pohjanmaa', 74),
(1171, 'Pohjois-Karjala', 74),
(1172, 'Pohjois-Pohjanmaa', 74),
(1173, 'Pohjois-Savo', 74),
(1174, 'Saarijarvi', 74),
(1175, 'Satakunta', 74),
(1176, 'Southern Savonia', 74),
(1177, 'Tavastia Proper', 74),
(1178, 'Uleaborgs Lan', 74),
(1179, 'Uusimaa', 74),
(1180, 'Varsinais-Suomi', 74),
(1181, 'Ain', 75),
(1182, 'Aisne', 75),
(1183, 'Albi Le Sequestre', 75),
(1184, 'Allier', 75),
(1185, 'Alpes-Cote dAzur', 75),
(1186, 'Alpes-Maritimes', 75),
(1187, 'Alpes-de-Haute-Provence', 75),
(1188, 'Alsace', 75),
(1189, 'Aquitaine', 75),
(1190, 'Ardeche', 75),
(1191, 'Ardennes', 75),
(1192, 'Ariege', 75),
(1193, 'Aube', 75),
(1194, 'Aude', 75),
(1195, 'Auvergne', 75),
(1196, 'Aveyron', 75),
(1197, 'Bas-Rhin', 75),
(1198, 'Basse-Normandie', 75),
(1199, 'Bouches-du-Rhone', 75),
(1200, 'Bourgogne', 75),
(1201, 'Bretagne', 75),
(1202, 'Brittany', 75),
(1203, 'Burgundy', 75),
(1204, 'Calvados', 75),
(1205, 'Cantal', 75),
(1206, 'Cedex', 75),
(1207, 'Centre', 75),
(1208, 'Charente', 75),
(1209, 'Charente-Maritime', 75),
(1210, 'Cher', 75),
(1211, 'Correze', 75),
(1212, 'Corse-du-Sud', 75),
(1213, 'Cote-d\'Or', 75),
(1214, 'Cotes-d\'Armor', 75),
(1215, 'Creuse', 75),
(1216, 'Crolles', 75),
(1217, 'Deux-Sevres', 75),
(1218, 'Dordogne', 75),
(1219, 'Doubs', 75),
(1220, 'Drome', 75),
(1221, 'Essonne', 75),
(1222, 'Eure', 75),
(1223, 'Eure-et-Loir', 75),
(1224, 'Feucherolles', 75),
(1225, 'Finistere', 75),
(1226, 'Franche-Comte', 75),
(1227, 'Gard', 75),
(1228, 'Gers', 75),
(1229, 'Gironde', 75),
(1230, 'Haut-Rhin', 75),
(1231, 'Haute-Corse', 75),
(1232, 'Haute-Garonne', 75),
(1233, 'Haute-Loire', 75),
(1234, 'Haute-Marne', 75),
(1235, 'Haute-Saone', 75),
(1236, 'Haute-Savoie', 75),
(1237, 'Haute-Vienne', 75),
(1238, 'Hautes-Alpes', 75),
(1239, 'Hautes-Pyrenees', 75),
(1240, 'Hauts-de-Seine', 75),
(1241, 'Herault', 75),
(1242, 'Ile-de-France', 75),
(1243, 'Ille-et-Vilaine', 75),
(1244, 'Indre', 75),
(1245, 'Indre-et-Loire', 75),
(1246, 'Isere', 75),
(1247, 'Jura', 75),
(1248, 'Klagenfurt', 75),
(1249, 'Landes', 75),
(1250, 'Languedoc-Roussillon', 75),
(1251, 'Larcay', 75),
(1252, 'Le Castellet', 75),
(1253, 'Le Creusot', 75),
(1254, 'Limousin', 75),
(1255, 'Loir-et-Cher', 75),
(1256, 'Loire', 75),
(1257, 'Loire-Atlantique', 75),
(1258, 'Loiret', 75),
(1259, 'Lorraine', 75),
(1260, 'Lot', 75),
(1261, 'Lot-et-Garonne', 75),
(1262, 'Lower Normandy', 75),
(1263, 'Lozere', 75),
(1264, 'Maine-et-Loire', 75),
(1265, 'Manche', 75),
(1266, 'Marne', 75),
(1267, 'Mayenne', 75),
(1268, 'Meurthe-et-Moselle', 75),
(1269, 'Meuse', 75),
(1270, 'Midi-Pyrenees', 75),
(1271, 'Morbihan', 75),
(1272, 'Moselle', 75),
(1273, 'Nievre', 75),
(1274, 'Nord', 75),
(1275, 'Nord-Pas-de-Calais', 75),
(1276, 'Oise', 75),
(1277, 'Orne', 75),
(1278, 'Paris', 75),
(1279, 'Pas-de-Calais', 75),
(1280, 'Pays de la Loire', 75),
(1281, 'Pays-de-la-Loire', 75),
(1282, 'Picardy', 75),
(1283, 'Puy-de-Dome', 75),
(1284, 'Pyrenees-Atlantiques', 75),
(1285, 'Pyrenees-Orientales', 75),
(1286, 'Quelmes', 75),
(1287, 'Rhone', 75),
(1288, 'Rhone-Alpes', 75),
(1289, 'Saint Ouen', 75),
(1290, 'Saint Viatre', 75),
(1291, 'Saone-et-Loire', 75),
(1292, 'Sarthe', 75),
(1293, 'Savoie', 75),
(1294, 'Seine-Maritime', 75),
(1295, 'Seine-Saint-Denis', 75),
(1296, 'Seine-et-Marne', 75),
(1297, 'Somme', 75),
(1298, 'Sophia Antipolis', 75),
(1299, 'Souvans', 75),
(1300, 'Tarn', 75),
(1301, 'Tarn-et-Garonne', 75),
(1302, 'Territoire de Belfort', 75),
(1303, 'Treignac', 75),
(1304, 'Upper Normandy', 75),
(1305, 'Val-d\'Oise', 75),
(1306, 'Val-de-Marne', 75),
(1307, 'Var', 75),
(1308, 'Vaucluse', 75),
(1309, 'Vellise', 75),
(1310, 'Vendee', 75),
(1311, 'Vienne', 75),
(1312, 'Vosges', 75),
(1313, 'Yonne', 75),
(1314, 'Yvelines', 75),
(1315, 'Cayenne', 76),
(1316, 'Saint-Laurent-du-Maroni', 76),
(1317, 'Iles du Vent', 77),
(1318, 'Iles sous le Vent', 77),
(1319, 'Marquesas', 77),
(1320, 'Tuamotu', 77),
(1321, 'Tubuai', 77),
(1322, 'Amsterdam', 78),
(1323, 'Crozet Islands', 78),
(1324, 'Kerguelen', 78),
(1325, 'Estuaire', 79),
(1326, 'Haut-Ogooue', 79),
(1327, 'Moyen-Ogooue', 79),
(1328, 'Ngounie', 79),
(1329, 'Nyanga', 79),
(1330, 'Ogooue-Ivindo', 79),
(1331, 'Ogooue-Lolo', 79),
(1332, 'Ogooue-Maritime', 79),
(1333, 'Woleu-Ntem', 79),
(1334, 'Banjul', 80),
(1335, 'Basse', 80),
(1336, 'Brikama', 80),
(1337, 'Janjanbureh', 80),
(1338, 'Kanifing', 80),
(1339, 'Kerewan', 80),
(1340, 'Kuntaur', 80),
(1341, 'Mansakonko', 80),
(1342, 'Abhasia', 81),
(1343, 'Ajaria', 81),
(1344, 'Guria', 81),
(1345, 'Imereti', 81),
(1346, 'Kaheti', 81),
(1347, 'Kvemo Kartli', 81),
(1348, 'Mcheta-Mtianeti', 81),
(1349, 'Racha', 81),
(1350, 'Samagrelo-Zemo Svaneti', 81),
(1351, 'Samche-Zhavaheti', 81),
(1352, 'Shida Kartli', 81),
(1353, 'Tbilisi', 81),
(1354, 'Auvergne', 82),
(1355, 'Baden-Wurttemberg', 82),
(1356, 'Bavaria', 82),
(1357, 'Bayern', 82),
(1358, 'Beilstein Wurtt', 82),
(1359, 'Berlin', 82),
(1360, 'Brandenburg', 82),
(1361, 'Bremen', 82),
(1362, 'Dreisbach', 82),
(1363, 'Freistaat Bayern', 82),
(1364, 'Hamburg', 82),
(1365, 'Hannover', 82),
(1366, 'Heroldstatt', 82),
(1367, 'Hessen', 82),
(1368, 'Kortenberg', 82),
(1369, 'Laasdorf', 82),
(1370, 'Land Baden-Wurttemberg', 82),
(1371, 'Land Bayern', 82),
(1372, 'Land Brandenburg', 82),
(1373, 'Land Hessen', 82),
(1374, 'Land Mecklenburg-Vorpommern', 82),
(1375, 'Land Nordrhein-Westfalen', 82),
(1376, 'Land Rheinland-Pfalz', 82),
(1377, 'Land Sachsen', 82),
(1378, 'Land Sachsen-Anhalt', 82),
(1379, 'Land Thuringen', 82),
(1380, 'Lower Saxony', 82),
(1381, 'Mecklenburg-Vorpommern', 82),
(1382, 'Mulfingen', 82),
(1383, 'Munich', 82),
(1384, 'Neubeuern', 82),
(1385, 'Niedersachsen', 82),
(1386, 'Noord-Holland', 82),
(1387, 'Nordrhein-Westfalen', 82),
(1388, 'North Rhine-Westphalia', 82),
(1389, 'Osterode', 82),
(1390, 'Rheinland-Pfalz', 82),
(1391, 'Rhineland-Palatinate', 82),
(1392, 'Saarland', 82),
(1393, 'Sachsen', 82),
(1394, 'Sachsen-Anhalt', 82),
(1395, 'Saxony', 82),
(1396, 'Schleswig-Holstein', 82),
(1397, 'Thuringia', 82),
(1398, 'Webling', 82),
(1399, 'Weinstrabe', 82),
(1400, 'schlobborn', 82),
(1401, 'Ashanti', 83),
(1402, 'Brong-Ahafo', 83),
(1403, 'Central', 83),
(1404, 'Eastern', 83),
(1405, 'Greater Accra', 83),
(1406, 'Northern', 83),
(1407, 'Upper East', 83),
(1408, 'Upper West', 83),
(1409, 'Volta', 83),
(1410, 'Western', 83),
(1411, 'Gibraltar', 84),
(1412, 'Acharnes', 85),
(1413, 'Ahaia', 85),
(1414, 'Aitolia kai Akarnania', 85),
(1415, 'Argolis', 85),
(1416, 'Arkadia', 85),
(1417, 'Arta', 85),
(1418, 'Attica', 85),
(1419, 'Attiki', 85),
(1420, 'Ayion Oros', 85),
(1421, 'Crete', 85),
(1422, 'Dodekanisos', 85),
(1423, 'Drama', 85),
(1424, 'Evia', 85),
(1425, 'Evritania', 85),
(1426, 'Evros', 85),
(1427, 'Evvoia', 85),
(1428, 'Florina', 85),
(1429, 'Fokis', 85),
(1430, 'Fthiotis', 85),
(1431, 'Grevena', 85),
(1432, 'Halandri', 85),
(1433, 'Halkidiki', 85),
(1434, 'Hania', 85),
(1435, 'Heraklion', 85),
(1436, 'Hios', 85),
(1437, 'Ilia', 85),
(1438, 'Imathia', 85),
(1439, 'Ioannina', 85),
(1440, 'Iraklion', 85),
(1441, 'Karditsa', 85),
(1442, 'Kastoria', 85),
(1443, 'Kavala', 85),
(1444, 'Kefallinia', 85),
(1445, 'Kerkira', 85),
(1446, 'Kiklades', 85),
(1447, 'Kilkis', 85),
(1448, 'Korinthia', 85),
(1449, 'Kozani', 85),
(1450, 'Lakonia', 85),
(1451, 'Larisa', 85),
(1452, 'Lasithi', 85),
(1453, 'Lesvos', 85),
(1454, 'Levkas', 85),
(1455, 'Magnisia', 85),
(1456, 'Messinia', 85),
(1457, 'Nomos Attikis', 85),
(1458, 'Nomos Zakynthou', 85),
(1459, 'Pella', 85),
(1460, 'Pieria', 85),
(1461, 'Piraios', 85),
(1462, 'Preveza', 85),
(1463, 'Rethimni', 85),
(1464, 'Rodopi', 85),
(1465, 'Samos', 85),
(1466, 'Serrai', 85),
(1467, 'Thesprotia', 85),
(1468, 'Thessaloniki', 85),
(1469, 'Trikala', 85),
(1470, 'Voiotia', 85),
(1471, 'West Greece', 85),
(1472, 'Xanthi', 85),
(1473, 'Zakinthos', 85),
(1474, 'Aasiaat', 86),
(1475, 'Ammassalik', 86),
(1476, 'Illoqqortoormiut', 86),
(1477, 'Ilulissat', 86),
(1478, 'Ivittuut', 86),
(1479, 'Kangaatsiaq', 86),
(1480, 'Maniitsoq', 86),
(1481, 'Nanortalik', 86),
(1482, 'Narsaq', 86),
(1483, 'Nuuk', 86),
(1484, 'Paamiut', 86),
(1485, 'Qaanaaq', 86),
(1486, 'Qaqortoq', 86),
(1487, 'Qasigiannguit', 86),
(1488, 'Qeqertarsuaq', 86),
(1489, 'Sisimiut', 86),
(1490, 'Udenfor kommunal inddeling', 86),
(1491, 'Upernavik', 86),
(1492, 'Uummannaq', 86),
(1493, 'Carriacou-Petite Martinique', 87),
(1494, 'Saint Andrew', 87),
(1495, 'Saint Davids', 87),
(1496, 'Saint George\'s', 87),
(1497, 'Saint John', 87),
(1498, 'Saint Mark', 87),
(1499, 'Saint Patrick', 87),
(1500, 'Basse-Terre', 88),
(1501, 'Grande-Terre', 88),
(1502, 'Iles des Saintes', 88),
(1503, 'La Desirade', 88),
(1504, 'Marie-Galante', 88),
(1505, 'Saint Barthelemy', 88),
(1506, 'Saint Martin', 88),
(1507, 'Agana Heights', 89),
(1508, 'Agat', 89),
(1509, 'Barrigada', 89),
(1510, 'Chalan-Pago-Ordot', 89),
(1511, 'Dededo', 89),
(1512, 'Hagatna', 89),
(1513, 'Inarajan', 89),
(1514, 'Mangilao', 89),
(1515, 'Merizo', 89),
(1516, 'Mongmong-Toto-Maite', 89),
(1517, 'Santa Rita', 89),
(1518, 'Sinajana', 89),
(1519, 'Talofofo', 89),
(1520, 'Tamuning', 89),
(1521, 'Yigo', 89),
(1522, 'Yona', 89),
(1523, 'Alta Verapaz', 90),
(1524, 'Baja Verapaz', 90),
(1525, 'Chimaltenango', 90),
(1526, 'Chiquimula', 90),
(1527, 'El Progreso', 90),
(1528, 'Escuintla', 90),
(1529, 'Guatemala', 90),
(1530, 'Huehuetenango', 90),
(1531, 'Izabal', 90),
(1532, 'Jalapa', 90),
(1533, 'Jutiapa', 90),
(1534, 'Peten', 90),
(1535, 'Quezaltenango', 90),
(1536, 'Quiche', 90),
(1537, 'Retalhuleu', 90),
(1538, 'Sacatepequez', 90),
(1539, 'San Marcos', 90),
(1540, 'Santa Rosa', 90),
(1541, 'Solola', 90),
(1542, 'Suchitepequez', 90),
(1543, 'Totonicapan', 90),
(1544, 'Zacapa', 90),
(1545, 'Alderney', 91),
(1546, 'Castel', 91),
(1547, 'Forest', 91),
(1548, 'Saint Andrew', 91),
(1549, 'Saint Martin', 91),
(1550, 'Saint Peter Port', 91),
(1551, 'Saint Pierre du Bois', 91),
(1552, 'Saint Sampson', 91),
(1553, 'Saint Saviour', 91),
(1554, 'Sark', 91),
(1555, 'Torteval', 91),
(1556, 'Vale', 91),
(1557, 'Beyla', 92),
(1558, 'Boffa', 92),
(1559, 'Boke', 92),
(1560, 'Conakry', 92),
(1561, 'Coyah', 92),
(1562, 'Dabola', 92),
(1563, 'Dalaba', 92),
(1564, 'Dinguiraye', 92),
(1565, 'Faranah', 92),
(1566, 'Forecariah', 92),
(1567, 'Fria', 92),
(1568, 'Gaoual', 92),
(1569, 'Gueckedou', 92),
(1570, 'Kankan', 92),
(1571, 'Kerouane', 92),
(1572, 'Kindia', 92),
(1573, 'Kissidougou', 92),
(1574, 'Koubia', 92),
(1575, 'Koundara', 92),
(1576, 'Kouroussa', 92),
(1577, 'Labe', 92),
(1578, 'Lola', 92),
(1579, 'Macenta', 92),
(1580, 'Mali', 92),
(1581, 'Mamou', 92),
(1582, 'Mandiana', 92),
(1583, 'Nzerekore', 92),
(1584, 'Pita', 92),
(1585, 'Siguiri', 92),
(1586, 'Telimele', 92),
(1587, 'Tougue', 92),
(1588, 'Yomou', 92),
(1589, 'Bafata', 93),
(1590, 'Bissau', 93),
(1591, 'Bolama', 93),
(1592, 'Cacheu', 93),
(1593, 'Gabu', 93),
(1594, 'Oio', 93),
(1595, 'Quinara', 93),
(1596, 'Tombali', 93),
(1597, 'Barima-Waini', 94),
(1598, 'Cuyuni-Mazaruni', 94),
(1599, 'Demerara-Mahaica', 94),
(1600, 'East Berbice-Corentyne', 94),
(1601, 'Essequibo Islands-West Demerar', 94),
(1602, 'Mahaica-Berbice', 94),
(1603, 'Pomeroon-Supenaam', 94),
(1604, 'Potaro-Siparuni', 94),
(1605, 'Upper Demerara-Berbice', 94),
(1606, 'Upper Takutu-Upper Essequibo', 94),
(1607, 'Artibonite', 95),
(1608, 'Centre', 95),
(1609, 'Grand\'Anse', 95),
(1610, 'Nord', 95),
(1611, 'Nord-Est', 95),
(1612, 'Nord-Ouest', 95),
(1613, 'Ouest', 95),
(1614, 'Sud', 95),
(1615, 'Sud-Est', 95),
(1616, 'Heard and McDonald Islands', 96),
(1617, 'Atlantida', 97),
(1618, 'Choluteca', 97),
(1619, 'Colon', 97),
(1620, 'Comayagua', 97),
(1621, 'Copan', 97),
(1622, 'Cortes', 97),
(1623, 'Distrito Central', 97),
(1624, 'El Paraiso', 97),
(1625, 'Francisco Morazan', 97),
(1626, 'Gracias a Dios', 97),
(1627, 'Intibuca', 97),
(1628, 'Islas de la Bahia', 97),
(1629, 'La Paz', 97),
(1630, 'Lempira', 97),
(1631, 'Ocotepeque', 97),
(1632, 'Olancho', 97),
(1633, 'Santa Barbara', 97),
(1634, 'Valle', 97),
(1635, 'Yoro', 97),
(1636, 'Hong Kong', 98),
(1637, 'Bacs-Kiskun', 99),
(1638, 'Baranya', 99),
(1639, 'Bekes', 99),
(1640, 'Borsod-Abauj-Zemplen', 99),
(1641, 'Budapest', 99),
(1642, 'Csongrad', 99),
(1643, 'Fejer', 99),
(1644, 'Gyor-Moson-Sopron', 99),
(1645, 'Hajdu-Bihar', 99),
(1646, 'Heves', 99),
(1647, 'Jasz-Nagykun-Szolnok', 99),
(1648, 'Komarom-Esztergom', 99),
(1649, 'Nograd', 99),
(1650, 'Pest', 99),
(1651, 'Somogy', 99),
(1652, 'Szabolcs-Szatmar-Bereg', 99),
(1653, 'Tolna', 99),
(1654, 'Vas', 99),
(1655, 'Veszprem', 99),
(1656, 'Zala', 99),
(1657, 'Austurland', 100),
(1658, 'Gullbringusysla', 100),
(1659, 'Hofu borgarsva i', 100),
(1660, 'Nor urland eystra', 100),
(1661, 'Nor urland vestra', 100),
(1662, 'Su urland', 100),
(1663, 'Su urnes', 100),
(1664, 'Vestfir ir', 100),
(1665, 'Vesturland', 100),
(1666, 'Aceh', 102),
(1667, 'Bali', 102),
(1668, 'Bangka-Belitung', 102),
(1669, 'Banten', 102),
(1670, 'Bengkulu', 102),
(1671, 'Gandaria', 102),
(1672, 'Gorontalo', 102),
(1673, 'Jakarta', 102),
(1674, 'Jambi', 102),
(1675, 'Jawa Barat', 102),
(1676, 'Jawa Tengah', 102),
(1677, 'Jawa Timur', 102),
(1678, 'Kalimantan Barat', 102),
(1679, 'Kalimantan Selatan', 102),
(1680, 'Kalimantan Tengah', 102),
(1681, 'Kalimantan Timur', 102),
(1682, 'Kendal', 102),
(1683, 'Lampung', 102),
(1684, 'Maluku', 102),
(1685, 'Maluku Utara', 102),
(1686, 'Nusa Tenggara Barat', 102),
(1687, 'Nusa Tenggara Timur', 102),
(1688, 'Papua', 102),
(1689, 'Riau', 102),
(1690, 'Riau Kepulauan', 102),
(1691, 'Solo', 102),
(1692, 'Sulawesi Selatan', 102),
(1693, 'Sulawesi Tengah', 102),
(1694, 'Sulawesi Tenggara', 102),
(1695, 'Sulawesi Utara', 102),
(1696, 'Sumatera Barat', 102),
(1697, 'Sumatera Selatan', 102),
(1698, 'Sumatera Utara', 102),
(1699, 'Yogyakarta', 102),
(1700, 'Ardabil', 103),
(1701, 'Azarbayjan-e Bakhtari', 103),
(1702, 'Azarbayjan-e Khavari', 103),
(1703, 'Bushehr', 103),
(1704, 'Chahar Mahal-e Bakhtiari', 103),
(1705, 'Esfahan', 103),
(1706, 'Fars', 103),
(1707, 'Gilan', 103),
(1708, 'Golestan', 103),
(1709, 'Hamadan', 103),
(1710, 'Hormozgan', 103),
(1711, 'Ilam', 103),
(1712, 'Kerman', 103),
(1713, 'Kermanshah', 103),
(1714, 'Khorasan', 103),
(1715, 'Khuzestan', 103),
(1716, 'Kohgiluyeh-e Boyerahmad', 103),
(1717, 'Kordestan', 103),
(1718, 'Lorestan', 103),
(1719, 'Markazi', 103),
(1720, 'Mazandaran', 103),
(1721, 'Ostan-e Esfahan', 103),
(1722, 'Qazvin', 103),
(1723, 'Qom', 103),
(1724, 'Semnan', 103),
(1725, 'Sistan-e Baluchestan', 103),
(1726, 'Tehran', 103),
(1727, 'Yazd', 103),
(1728, 'Zanjan', 103),
(1729, 'Babil', 104),
(1730, 'Baghdad', 104),
(1731, 'Dahuk', 104),
(1732, 'Dhi Qar', 104),
(1733, 'Diyala', 104),
(1734, 'Erbil', 104),
(1735, 'Irbil', 104),
(1736, 'Karbala', 104),
(1737, 'Kurdistan', 104),
(1738, 'Maysan', 104),
(1739, 'Ninawa', 104),
(1740, 'Salah-ad-Din', 104),
(1741, 'Wasit', 104),
(1742, 'al-Anbar', 104),
(1743, 'al-Basrah', 104),
(1744, 'al-Muthanna', 104),
(1745, 'al-Qadisiyah', 104),
(1746, 'an-Najaf', 104),
(1747, 'as-Sulaymaniyah', 104),
(1748, 'at-Ta\'mim', 104),
(1749, 'Armagh', 105),
(1750, 'Carlow', 105),
(1751, 'Cavan', 105),
(1752, 'Clare', 105),
(1753, 'Cork', 105),
(1754, 'Donegal', 105),
(1755, 'Dublin', 105),
(1756, 'Galway', 105),
(1757, 'Kerry', 105),
(1758, 'Kildare', 105),
(1759, 'Kilkenny', 105),
(1760, 'Laois', 105),
(1761, 'Leinster', 105),
(1762, 'Leitrim', 105),
(1763, 'Limerick', 105),
(1764, 'Loch Garman', 105),
(1765, 'Longford', 105),
(1766, 'Louth', 105),
(1767, 'Mayo', 105),
(1768, 'Meath', 105),
(1769, 'Monaghan', 105),
(1770, 'Offaly', 105),
(1771, 'Roscommon', 105),
(1772, 'Sligo', 105),
(1773, 'Tipperary North Riding', 105),
(1774, 'Tipperary South Riding', 105),
(1775, 'Ulster', 105),
(1776, 'Waterford', 105),
(1777, 'Westmeath', 105),
(1778, 'Wexford', 105),
(1779, 'Wicklow', 105),
(1780, 'Beit Hanania', 106),
(1781, 'Ben Gurion Airport', 106),
(1782, 'Bethlehem', 106),
(1783, 'Caesarea', 106),
(1784, 'Centre', 106),
(1785, 'Gaza', 106),
(1786, 'Hadaron', 106),
(1787, 'Haifa District', 106),
(1788, 'Hamerkaz', 106),
(1789, 'Hazafon', 106),
(1790, 'Hebron', 106),
(1791, 'Jaffa', 106),
(1792, 'Jerusalem', 106),
(1793, 'Khefa', 106),
(1794, 'Kiryat Yam', 106),
(1795, 'Lower Galilee', 106),
(1796, 'Qalqilya', 106),
(1797, 'Talme Elazar', 106),
(1798, 'Tel Aviv', 106),
(1799, 'Tsafon', 106),
(1800, 'Umm El Fahem', 106),
(1801, 'Yerushalayim', 106),
(1802, 'Abruzzi', 107),
(1803, 'Abruzzo', 107),
(1804, 'Agrigento', 107),
(1805, 'Alessandria', 107),
(1806, 'Ancona', 107),
(1807, 'Arezzo', 107),
(1808, 'Ascoli Piceno', 107),
(1809, 'Asti', 107),
(1810, 'Avellino', 107),
(1811, 'Bari', 107),
(1812, 'Basilicata', 107),
(1813, 'Belluno', 107),
(1814, 'Benevento', 107),
(1815, 'Bergamo', 107),
(1816, 'Biella', 107),
(1817, 'Bologna', 107),
(1818, 'Bolzano', 107),
(1819, 'Brescia', 107),
(1820, 'Brindisi', 107),
(1821, 'Calabria', 107),
(1822, 'Campania', 107),
(1823, 'Cartoceto', 107),
(1824, 'Caserta', 107),
(1825, 'Catania', 107),
(1826, 'Chieti', 107),
(1827, 'Como', 107),
(1828, 'Cosenza', 107),
(1829, 'Cremona', 107),
(1830, 'Cuneo', 107),
(1831, 'Emilia-Romagna', 107),
(1832, 'Ferrara', 107),
(1833, 'Firenze', 107),
(1834, 'Florence', 107),
(1835, 'Forli-Cesena ', 107),
(1836, 'Friuli-Venezia Giulia', 107),
(1837, 'Frosinone', 107),
(1838, 'Genoa', 107),
(1839, 'Gorizia', 107),
(1840, 'L\'Aquila', 107),
(1841, 'Lazio', 107),
(1842, 'Lecce', 107),
(1843, 'Lecco', 107),
(1844, 'Lecco Province', 107),
(1845, 'Liguria', 107),
(1846, 'Lodi', 107),
(1847, 'Lombardia', 107),
(1848, 'Lombardy', 107),
(1849, 'Macerata', 107),
(1850, 'Mantova', 107),
(1851, 'Marche', 107),
(1852, 'Messina', 107),
(1853, 'Milan', 107),
(1854, 'Modena', 107),
(1855, 'Molise', 107),
(1856, 'Molteno', 107),
(1857, 'Montenegro', 107),
(1858, 'Monza and Brianza', 107),
(1859, 'Naples', 107),
(1860, 'Novara', 107),
(1861, 'Padova', 107),
(1862, 'Parma', 107),
(1863, 'Pavia', 107),
(1864, 'Perugia', 107),
(1865, 'Pesaro-Urbino', 107),
(1866, 'Piacenza', 107),
(1867, 'Piedmont', 107),
(1868, 'Piemonte', 107),
(1869, 'Pisa', 107),
(1870, 'Pordenone', 107),
(1871, 'Potenza', 107),
(1872, 'Puglia', 107),
(1873, 'Reggio Emilia', 107),
(1874, 'Rimini', 107),
(1875, 'Roma', 107),
(1876, 'Salerno', 107),
(1877, 'Sardegna', 107),
(1878, 'Sassari', 107),
(1879, 'Savona', 107),
(1880, 'Sicilia', 107),
(1881, 'Siena', 107),
(1882, 'Sondrio', 107),
(1883, 'South Tyrol', 107),
(1884, 'Taranto', 107),
(1885, 'Teramo', 107),
(1886, 'Torino', 107),
(1887, 'Toscana', 107),
(1888, 'Trapani', 107),
(1889, 'Trentino-Alto Adige', 107),
(1890, 'Trento', 107),
(1891, 'Treviso', 107),
(1892, 'Udine', 107),
(1893, 'Umbria', 107),
(1894, 'Valle d\'Aosta', 107),
(1895, 'Varese', 107),
(1896, 'Veneto', 107),
(1897, 'Venezia', 107),
(1898, 'Verbano-Cusio-Ossola', 107),
(1899, 'Vercelli', 107),
(1900, 'Verona', 107),
(1901, 'Vicenza', 107),
(1902, 'Viterbo', 107),
(1903, 'Buxoro Viloyati', 108),
(1904, 'Clarendon', 108),
(1905, 'Hanover', 108),
(1906, 'Kingston', 108),
(1907, 'Manchester', 108),
(1908, 'Portland', 108),
(1909, 'Saint Andrews', 108),
(1910, 'Saint Ann', 108),
(1911, 'Saint Catherine', 108),
(1912, 'Saint Elizabeth', 108),
(1913, 'Saint James', 108),
(1914, 'Saint Mary', 108),
(1915, 'Saint Thomas', 108),
(1916, 'Trelawney', 108),
(1917, 'Westmoreland', 108),
(1918, 'Aichi', 109),
(1919, 'Akita', 109),
(1920, 'Aomori', 109),
(1921, 'Chiba', 109),
(1922, 'Ehime', 109),
(1923, 'Fukui', 109),
(1924, 'Fukuoka', 109),
(1925, 'Fukushima', 109),
(1926, 'Gifu', 109),
(1927, 'Gumma', 109),
(1928, 'Hiroshima', 109),
(1929, 'Hokkaido', 109),
(1930, 'Hyogo', 109),
(1931, 'Ibaraki', 109),
(1932, 'Ishikawa', 109),
(1933, 'Iwate', 109),
(1934, 'Kagawa', 109),
(1935, 'Kagoshima', 109),
(1936, 'Kanagawa', 109),
(1937, 'Kanto', 109),
(1938, 'Kochi', 109),
(1939, 'Kumamoto', 109),
(1940, 'Kyoto', 109),
(1941, 'Mie', 109),
(1942, 'Miyagi', 109),
(1943, 'Miyazaki', 109),
(1944, 'Nagano', 109),
(1945, 'Nagasaki', 109),
(1946, 'Nara', 109),
(1947, 'Niigata', 109),
(1948, 'Oita', 109),
(1949, 'Okayama', 109),
(1950, 'Okinawa', 109),
(1951, 'Osaka', 109),
(1952, 'Saga', 109),
(1953, 'Saitama', 109),
(1954, 'Shiga', 109),
(1955, 'Shimane', 109),
(1956, 'Shizuoka', 109),
(1957, 'Tochigi', 109),
(1958, 'Tokushima', 109),
(1959, 'Tokyo', 109),
(1960, 'Tottori', 109),
(1961, 'Toyama', 109),
(1962, 'Wakayama', 109),
(1963, 'Yamagata', 109),
(1964, 'Yamaguchi', 109),
(1965, 'Yamanashi', 109),
(1966, 'Grouville', 110),
(1967, 'Saint Brelade', 110),
(1968, 'Saint Clement', 110),
(1969, 'Saint Helier', 110),
(1970, 'Saint John', 110),
(1971, 'Saint Lawrence', 110),
(1972, 'Saint Martin', 110),
(1973, 'Saint Mary', 110),
(1974, 'Saint Peter', 110),
(1975, 'Saint Saviour', 110),
(1976, 'Trinity', 110),
(1977, '\'Ajlun', 111),
(1978, 'Amman', 111),
(1979, 'Irbid', 111),
(1980, 'Jarash', 111),
(1981, 'Ma\'an', 111),
(1982, 'Madaba', 111),
(1983, 'al-\'Aqabah', 111),
(1984, 'al-Balqa\'', 111),
(1985, 'al-Karak', 111),
(1986, 'al-Mafraq', 111),
(1987, 'at-Tafilah', 111),
(1988, 'az-Zarqa\'', 111),
(1989, 'Akmecet', 112),
(1990, 'Akmola', 112),
(1991, 'Aktobe', 112),
(1992, 'Almati', 112),
(1993, 'Atirau', 112),
(1994, 'Batis Kazakstan', 112),
(1995, 'Burlinsky Region', 112),
(1996, 'Karagandi', 112),
(1997, 'Kostanay', 112),
(1998, 'Mankistau', 112),
(1999, 'Ontustik Kazakstan', 112),
(2000, 'Pavlodar', 112),
(2001, 'Sigis Kazakstan', 112),
(2002, 'Soltustik Kazakstan', 112),
(2003, 'Taraz', 112),
(2004, 'Central', 113),
(2005, 'Coast', 113),
(2006, 'Eastern', 113),
(2007, 'Nairobi', 113),
(2008, 'North Eastern', 113),
(2009, 'Nyanza', 113),
(2010, 'Rift Valley', 113),
(2011, 'Western', 113),
(2012, 'Abaiang', 114),
(2013, 'Abemana', 114),
(2014, 'Aranuka', 114),
(2015, 'Arorae', 114),
(2016, 'Banaba', 114),
(2017, 'Beru', 114),
(2018, 'Butaritari', 114),
(2019, 'Kiritimati', 114),
(2020, 'Kuria', 114),
(2021, 'Maiana', 114),
(2022, 'Makin', 114),
(2023, 'Marakei', 114),
(2024, 'Nikunau', 114),
(2025, 'Nonouti', 114),
(2026, 'Onotoa', 114),
(2027, 'Phoenix Islands', 114),
(2028, 'Tabiteuea North', 114),
(2029, 'Tabiteuea South', 114),
(2030, 'Tabuaeran', 114),
(2031, 'Tamana', 114),
(2032, 'Tarawa North', 114),
(2033, 'Tarawa South', 114),
(2034, 'Teraina', 114),
(2035, 'Chagangdo', 115),
(2036, 'Hamgyeongbukto', 115),
(2037, 'Hamgyeongnamdo', 115),
(2038, 'Hwanghaebukto', 115),
(2039, 'Hwanghaenamdo', 115),
(2040, 'Kaeseong', 115),
(2041, 'Kangweon', 115),
(2042, 'Nampo', 115),
(2043, 'Pyeonganbukto', 115),
(2044, 'Pyeongannamdo', 115),
(2045, 'Pyeongyang', 115),
(2046, 'Yanggang', 115),
(2047, 'Busan', 116),
(2048, 'Cheju', 116),
(2049, 'Chollabuk', 116),
(2050, 'Chollanam', 116),
(2051, 'Chungbuk', 116),
(2052, 'Chungcheongbuk', 116),
(2053, 'Chungcheongnam', 116),
(2054, 'Chungnam', 116),
(2055, 'Daegu', 116),
(2056, 'Gangwon-do', 116),
(2057, 'Goyang-si', 116),
(2058, 'Gyeonggi-do', 116),
(2059, 'Gyeongsang ', 116),
(2060, 'Gyeongsangnam-do', 116),
(2061, 'Incheon', 116),
(2062, 'Jeju-Si', 116),
(2063, 'Jeonbuk', 116),
(2064, 'Kangweon', 116),
(2065, 'Kwangju', 116),
(2066, 'Kyeonggi', 116),
(2067, 'Kyeongsangbuk', 116),
(2068, 'Kyeongsangnam', 116),
(2069, 'Kyonggi-do', 116),
(2070, 'Kyungbuk-Do', 116),
(2071, 'Kyunggi-Do', 116),
(2072, 'Kyunggi-do', 116),
(2073, 'Pusan', 116),
(2074, 'Seoul', 116),
(2075, 'Sudogwon', 116),
(2076, 'Taegu', 116),
(2077, 'Taejeon', 116),
(2078, 'Taejon-gwangyoksi', 116),
(2079, 'Ulsan', 116),
(2080, 'Wonju', 116),
(2081, 'gwangyoksi', 116),
(2082, 'Al Asimah', 117),
(2083, 'Hawalli', 117),
(2084, 'Mishref', 117),
(2085, 'Qadesiya', 117),
(2086, 'Safat', 117),
(2087, 'Salmiya', 117),
(2088, 'al-Ahmadi', 117),
(2089, 'al-Farwaniyah', 117),
(2090, 'al-Jahra', 117),
(2091, 'al-Kuwayt', 117),
(2092, 'Batken', 118),
(2093, 'Bishkek', 118),
(2094, 'Chui', 118),
(2095, 'Issyk-Kul', 118),
(2096, 'Jalal-Abad', 118),
(2097, 'Naryn', 118),
(2098, 'Osh', 118),
(2099, 'Talas', 118),
(2100, 'Attopu', 119),
(2101, 'Bokeo', 119),
(2102, 'Bolikhamsay', 119),
(2103, 'Champasak', 119),
(2104, 'Houaphanh', 119),
(2105, 'Khammouane', 119),
(2106, 'Luang Nam Tha', 119),
(2107, 'Luang Prabang', 119),
(2108, 'Oudomxay', 119),
(2109, 'Phongsaly', 119),
(2110, 'Saravan', 119),
(2111, 'Savannakhet', 119),
(2112, 'Sekong', 119),
(2113, 'Viangchan Prefecture', 119),
(2114, 'Viangchan Province', 119),
(2115, 'Xaignabury', 119),
(2116, 'Xiang Khuang', 119),
(2117, 'Aizkraukles', 120),
(2118, 'Aluksnes', 120),
(2119, 'Balvu', 120),
(2120, 'Bauskas', 120),
(2121, 'Cesu', 120),
(2122, 'Daugavpils', 120),
(2123, 'Daugavpils City', 120),
(2124, 'Dobeles', 120),
(2125, 'Gulbenes', 120),
(2126, 'Jekabspils', 120),
(2127, 'Jelgava', 120),
(2128, 'Jelgavas', 120),
(2129, 'Jurmala City', 120),
(2130, 'Kraslavas', 120),
(2131, 'Kuldigas', 120),
(2132, 'Liepaja', 120),
(2133, 'Liepajas', 120),
(2134, 'Limbazhu', 120),
(2135, 'Ludzas', 120),
(2136, 'Madonas', 120),
(2137, 'Ogres', 120),
(2138, 'Preilu', 120),
(2139, 'Rezekne', 120),
(2140, 'Rezeknes', 120),
(2141, 'Riga', 120),
(2142, 'Rigas', 120),
(2143, 'Saldus', 120),
(2144, 'Talsu', 120),
(2145, 'Tukuma', 120),
(2146, 'Valkas', 120),
(2147, 'Valmieras', 120),
(2148, 'Ventspils', 120),
(2149, 'Ventspils City', 120),
(2150, 'Beirut', 121),
(2151, 'Jabal Lubnan', 121),
(2152, 'Mohafazat Liban-Nord', 121),
(2153, 'Mohafazat Mont-Liban', 121),
(2154, 'Sidon', 121),
(2155, 'al-Biqa', 121),
(2156, 'al-Janub', 121),
(2157, 'an-Nabatiyah', 121),
(2158, 'ash-Shamal', 121),
(2159, 'Berea', 122),
(2160, 'Butha-Buthe', 122),
(2161, 'Leribe', 122),
(2162, 'Mafeteng', 122),
(2163, 'Maseru', 122),
(2164, 'Mohale\'s Hoek', 122),
(2165, 'Mokhotlong', 122),
(2166, 'Qacha\'s Nek', 122),
(2167, 'Quthing', 122),
(2168, 'Thaba-Tseka', 122),
(2169, 'Bomi', 123),
(2170, 'Bong', 123),
(2171, 'Grand Bassa', 123),
(2172, 'Grand Cape Mount', 123),
(2173, 'Grand Gedeh', 123),
(2174, 'Loffa', 123),
(2175, 'Margibi', 123),
(2176, 'Maryland and Grand Kru', 123),
(2177, 'Montserrado', 123),
(2178, 'Nimba', 123),
(2179, 'Rivercess', 123),
(2180, 'Sinoe', 123),
(2181, 'Ajdabiya', 124);
INSERT INTO `states` (`id`, `name`, `country_id`) VALUES
(2182, 'Fezzan', 124),
(2183, 'Banghazi', 124),
(2184, 'Darnah', 124),
(2185, 'Ghadamis', 124),
(2186, 'Gharyan', 124),
(2187, 'Misratah', 124),
(2188, 'Murzuq', 124),
(2189, 'Sabha', 124),
(2190, 'Sawfajjin', 124),
(2191, 'Surt', 124),
(2192, 'Tarabulus', 124),
(2193, 'Tarhunah', 124),
(2194, 'Tripolitania', 124),
(2195, 'Tubruq', 124),
(2196, 'Yafran', 124),
(2197, 'Zlitan', 124),
(2198, 'al-\'Aziziyah', 124),
(2199, 'al-Fatih', 124),
(2200, 'al-Jabal al Akhdar', 124),
(2201, 'al-Jufrah', 124),
(2202, 'al-Khums', 124),
(2203, 'al-Kufrah', 124),
(2204, 'an-Nuqat al-Khams', 124),
(2205, 'ash-Shati\'', 124),
(2206, 'az-Zawiyah', 124),
(2207, 'Balzers', 125),
(2208, 'Eschen', 125),
(2209, 'Gamprin', 125),
(2210, 'Mauren', 125),
(2211, 'Planken', 125),
(2212, 'Ruggell', 125),
(2213, 'Schaan', 125),
(2214, 'Schellenberg', 125),
(2215, 'Triesen', 125),
(2216, 'Triesenberg', 125),
(2217, 'Vaduz', 125),
(2218, 'Alytaus', 126),
(2219, 'Anyksciai', 126),
(2220, 'Kauno', 126),
(2221, 'Klaipedos', 126),
(2222, 'Marijampoles', 126),
(2223, 'Panevezhio', 126),
(2224, 'Panevezys', 126),
(2225, 'Shiauliu', 126),
(2226, 'Taurages', 126),
(2227, 'Telshiu', 126),
(2228, 'Telsiai', 126),
(2229, 'Utenos', 126),
(2230, 'Vilniaus', 126),
(2231, 'Capellen', 127),
(2232, 'Clervaux', 127),
(2233, 'Diekirch', 127),
(2234, 'Echternach', 127),
(2235, 'Esch-sur-Alzette', 127),
(2236, 'Grevenmacher', 127),
(2237, 'Luxembourg', 127),
(2238, 'Mersch', 127),
(2239, 'Redange', 127),
(2240, 'Remich', 127),
(2241, 'Vianden', 127),
(2242, 'Wiltz', 127),
(2243, 'Macau', 128),
(2244, 'Berovo', 129),
(2245, 'Bitola', 129),
(2246, 'Brod', 129),
(2247, 'Debar', 129),
(2248, 'Delchevo', 129),
(2249, 'Demir Hisar', 129),
(2250, 'Gevgelija', 129),
(2251, 'Gostivar', 129),
(2252, 'Kavadarci', 129),
(2253, 'Kichevo', 129),
(2254, 'Kochani', 129),
(2255, 'Kratovo', 129),
(2256, 'Kriva Palanka', 129),
(2257, 'Krushevo', 129),
(2258, 'Kumanovo', 129),
(2259, 'Negotino', 129),
(2260, 'Ohrid', 129),
(2261, 'Prilep', 129),
(2262, 'Probishtip', 129),
(2263, 'Radovish', 129),
(2264, 'Resen', 129),
(2265, 'Shtip', 129),
(2266, 'Skopje', 129),
(2267, 'Struga', 129),
(2268, 'Strumica', 129),
(2269, 'Sveti Nikole', 129),
(2270, 'Tetovo', 129),
(2271, 'Valandovo', 129),
(2272, 'Veles', 129),
(2273, 'Vinica', 129),
(2274, 'Antananarivo', 130),
(2275, 'Antsiranana', 130),
(2276, 'Fianarantsoa', 130),
(2277, 'Mahajanga', 130),
(2278, 'Toamasina', 130),
(2279, 'Toliary', 130),
(2280, 'Balaka', 131),
(2281, 'Blantyre City', 131),
(2282, 'Chikwawa', 131),
(2283, 'Chiradzulu', 131),
(2284, 'Chitipa', 131),
(2285, 'Dedza', 131),
(2286, 'Dowa', 131),
(2287, 'Karonga', 131),
(2288, 'Kasungu', 131),
(2289, 'Lilongwe City', 131),
(2290, 'Machinga', 131),
(2291, 'Mangochi', 131),
(2292, 'Mchinji', 131),
(2293, 'Mulanje', 131),
(2294, 'Mwanza', 131),
(2295, 'Mzimba', 131),
(2296, 'Mzuzu City', 131),
(2297, 'Nkhata Bay', 131),
(2298, 'Nkhotakota', 131),
(2299, 'Nsanje', 131),
(2300, 'Ntcheu', 131),
(2301, 'Ntchisi', 131),
(2302, 'Phalombe', 131),
(2303, 'Rumphi', 131),
(2304, 'Salima', 131),
(2305, 'Thyolo', 131),
(2306, 'Zomba Municipality', 131),
(2307, 'Johor', 132),
(2308, 'Kedah', 132),
(2309, 'Kelantan', 132),
(2310, 'Kuala Lumpur', 132),
(2311, 'Labuan', 132),
(2312, 'Melaka', 132),
(2313, 'Negeri Johor', 132),
(2314, 'Negeri Sembilan', 132),
(2315, 'Pahang', 132),
(2316, 'Penang', 132),
(2317, 'Perak', 132),
(2318, 'Perlis', 132),
(2319, 'Pulau Pinang', 132),
(2320, 'Sabah', 132),
(2321, 'Sarawak', 132),
(2322, 'Selangor', 132),
(2323, 'Sembilan', 132),
(2324, 'Terengganu', 132),
(2325, 'Alif Alif', 133),
(2326, 'Alif Dhaal', 133),
(2327, 'Baa', 133),
(2328, 'Dhaal', 133),
(2329, 'Faaf', 133),
(2330, 'Gaaf Alif', 133),
(2331, 'Gaaf Dhaal', 133),
(2332, 'Ghaviyani', 133),
(2333, 'Haa Alif', 133),
(2334, 'Haa Dhaal', 133),
(2335, 'Kaaf', 133),
(2336, 'Laam', 133),
(2337, 'Lhaviyani', 133),
(2338, 'Male', 133),
(2339, 'Miim', 133),
(2340, 'Nuun', 133),
(2341, 'Raa', 133),
(2342, 'Shaviyani', 133),
(2343, 'Siin', 133),
(2344, 'Thaa', 133),
(2345, 'Vaav', 133),
(2346, 'Bamako', 134),
(2347, 'Gao', 134),
(2348, 'Kayes', 134),
(2349, 'Kidal', 134),
(2350, 'Koulikoro', 134),
(2351, 'Mopti', 134),
(2352, 'Segou', 134),
(2353, 'Sikasso', 134),
(2354, 'Tombouctou', 134),
(2355, 'Gozo and Comino', 135),
(2356, 'Inner Harbour', 135),
(2357, 'Northern', 135),
(2358, 'Outer Harbour', 135),
(2359, 'South Eastern', 135),
(2360, 'Valletta', 135),
(2361, 'Western', 135),
(2362, 'Castletown', 136),
(2363, 'Douglas', 136),
(2364, 'Laxey', 136),
(2365, 'Onchan', 136),
(2366, 'Peel', 136),
(2367, 'Port Erin', 136),
(2368, 'Port Saint Mary', 136),
(2369, 'Ramsey', 136),
(2370, 'Ailinlaplap', 137),
(2371, 'Ailuk', 137),
(2372, 'Arno', 137),
(2373, 'Aur', 137),
(2374, 'Bikini', 137),
(2375, 'Ebon', 137),
(2376, 'Enewetak', 137),
(2377, 'Jabat', 137),
(2378, 'Jaluit', 137),
(2379, 'Kili', 137),
(2380, 'Kwajalein', 137),
(2381, 'Lae', 137),
(2382, 'Lib', 137),
(2383, 'Likiep', 137),
(2384, 'Majuro', 137),
(2385, 'Maloelap', 137),
(2386, 'Mejit', 137),
(2387, 'Mili', 137),
(2388, 'Namorik', 137),
(2389, 'Namu', 137),
(2390, 'Rongelap', 137),
(2391, 'Ujae', 137),
(2392, 'Utrik', 137),
(2393, 'Wotho', 137),
(2394, 'Wotje', 137),
(2395, 'Fort-de-France', 138),
(2396, 'La Trinite', 138),
(2397, 'Le Marin', 138),
(2398, 'Saint-Pierre', 138),
(2399, 'Adrar', 139),
(2400, 'Assaba', 139),
(2401, 'Brakna', 139),
(2402, 'Dhakhlat Nawadibu', 139),
(2403, 'Hudh-al-Gharbi', 139),
(2404, 'Hudh-ash-Sharqi', 139),
(2405, 'Inshiri', 139),
(2406, 'Nawakshut', 139),
(2407, 'Qidimagha', 139),
(2408, 'Qurqul', 139),
(2409, 'Taqant', 139),
(2410, 'Tiris Zammur', 139),
(2411, 'Trarza', 139),
(2412, 'Black River', 140),
(2413, 'Eau Coulee', 140),
(2414, 'Flacq', 140),
(2415, 'Floreal', 140),
(2416, 'Grand Port', 140),
(2417, 'Moka', 140),
(2418, 'Pamplempousses', 140),
(2419, 'Plaines Wilhelm', 140),
(2420, 'Port Louis', 140),
(2421, 'Riviere du Rempart', 140),
(2422, 'Rodrigues', 140),
(2423, 'Rose Hill', 140),
(2424, 'Savanne', 140),
(2425, 'Mayotte', 141),
(2426, 'Pamanzi', 141),
(2427, 'Aguascalientes', 142),
(2428, 'Baja California', 142),
(2429, 'Baja California Sur', 142),
(2430, 'Campeche', 142),
(2431, 'Chiapas', 142),
(2432, 'Chihuahua', 142),
(2433, 'Coahuila', 142),
(2434, 'Colima', 142),
(2435, 'Distrito Federal', 142),
(2436, 'Durango', 142),
(2437, 'Estado de Mexico', 142),
(2438, 'Guanajuato', 142),
(2439, 'Guerrero', 142),
(2440, 'Hidalgo', 142),
(2441, 'Jalisco', 142),
(2442, 'Mexico', 142),
(2443, 'Michoacan', 142),
(2444, 'Morelos', 142),
(2445, 'Nayarit', 142),
(2446, 'Nuevo Leon', 142),
(2447, 'Oaxaca', 142),
(2448, 'Puebla', 142),
(2449, 'Queretaro', 142),
(2450, 'Quintana Roo', 142),
(2451, 'San Luis Potosi', 142),
(2452, 'Sinaloa', 142),
(2453, 'Sonora', 142),
(2454, 'Tabasco', 142),
(2455, 'Tamaulipas', 142),
(2456, 'Tlaxcala', 142),
(2457, 'Veracruz', 142),
(2458, 'Yucatan', 142),
(2459, 'Zacatecas', 142),
(2460, 'Chuuk', 143),
(2461, 'Kusaie', 143),
(2462, 'Pohnpei', 143),
(2463, 'Yap', 143),
(2464, 'Balti', 144),
(2465, 'Cahul', 144),
(2466, 'Chisinau', 144),
(2467, 'Chisinau Oras', 144),
(2468, 'Edinet', 144),
(2469, 'Gagauzia', 144),
(2470, 'Lapusna', 144),
(2471, 'Orhei', 144),
(2472, 'Soroca', 144),
(2473, 'Taraclia', 144),
(2474, 'Tighina', 144),
(2475, 'Transnistria', 144),
(2476, 'Ungheni', 144),
(2477, 'Fontvieille', 145),
(2478, 'La Condamine', 145),
(2479, 'Monaco-Ville', 145),
(2480, 'Monte Carlo', 145),
(2481, 'Arhangaj', 146),
(2482, 'Bajan-Olgij', 146),
(2483, 'Bajanhongor', 146),
(2484, 'Bulgan', 146),
(2485, 'Darhan-Uul', 146),
(2486, 'Dornod', 146),
(2487, 'Dornogovi', 146),
(2488, 'Dundgovi', 146),
(2489, 'Govi-Altaj', 146),
(2490, 'Govisumber', 146),
(2491, 'Hentij', 146),
(2492, 'Hovd', 146),
(2493, 'Hovsgol', 146),
(2494, 'Omnogovi', 146),
(2495, 'Orhon', 146),
(2496, 'Ovorhangaj', 146),
(2497, 'Selenge', 146),
(2498, 'Suhbaatar', 146),
(2499, 'Tov', 146),
(2500, 'Ulaanbaatar', 146),
(2501, 'Uvs', 146),
(2502, 'Zavhan', 146),
(2503, 'Montserrat', 147),
(2504, 'Agadir', 148),
(2505, 'Casablanca', 148),
(2506, 'Chaouia-Ouardigha', 148),
(2507, 'Doukkala-Abda', 148),
(2508, 'Fes-Boulemane', 148),
(2509, 'Gharb-Chrarda-Beni Hssen', 148),
(2510, 'Guelmim', 148),
(2511, 'Kenitra', 148),
(2512, 'Marrakech-Tensift-Al Haouz', 148),
(2513, 'Meknes-Tafilalet', 148),
(2514, 'Oriental', 148),
(2515, 'Oujda', 148),
(2516, 'Province de Tanger', 148),
(2517, 'Rabat-Sale-Zammour-Zaer', 148),
(2518, 'Sala Al Jadida', 148),
(2519, 'Settat', 148),
(2520, 'Souss Massa-Draa', 148),
(2521, 'Tadla-Azilal', 148),
(2522, 'Tangier-Tetouan', 148),
(2523, 'Taza-Al Hoceima-Taounate', 148),
(2524, 'Wilaya de Casablanca', 148),
(2525, 'Wilaya de Rabat-Sale', 148),
(2526, 'Cabo Delgado', 149),
(2527, 'Gaza', 149),
(2528, 'Inhambane', 149),
(2529, 'Manica', 149),
(2530, 'Maputo', 149),
(2531, 'Maputo Provincia', 149),
(2532, 'Nampula', 149),
(2533, 'Niassa', 149),
(2534, 'Sofala', 149),
(2535, 'Tete', 149),
(2536, 'Zambezia', 149),
(2537, 'Ayeyarwady', 150),
(2538, 'Bago', 150),
(2539, 'Chin', 150),
(2540, 'Kachin', 150),
(2541, 'Kayah', 150),
(2542, 'Kayin', 150),
(2543, 'Magway', 150),
(2544, 'Mandalay', 150),
(2545, 'Mon', 150),
(2546, 'Nay Pyi Taw', 150),
(2547, 'Rakhine', 150),
(2548, 'Sagaing', 150),
(2549, 'Shan', 150),
(2550, 'Tanintharyi', 150),
(2551, 'Yangon', 150),
(2552, 'Caprivi', 151),
(2553, 'Erongo', 151),
(2554, 'Hardap', 151),
(2555, 'Karas', 151),
(2556, 'Kavango', 151),
(2557, 'Khomas', 151),
(2558, 'Kunene', 151),
(2559, 'Ohangwena', 151),
(2560, 'Omaheke', 151),
(2561, 'Omusati', 151),
(2562, 'Oshana', 151),
(2563, 'Oshikoto', 151),
(2564, 'Otjozondjupa', 151),
(2565, 'Yaren', 152),
(2566, 'Bagmati', 153),
(2567, 'Bheri', 153),
(2568, 'Dhawalagiri', 153),
(2569, 'Gandaki', 153),
(2570, 'Janakpur', 153),
(2571, 'Karnali', 153),
(2572, 'Koshi', 153),
(2573, 'Lumbini', 153),
(2574, 'Mahakali', 153),
(2575, 'Mechi', 153),
(2576, 'Narayani', 153),
(2577, 'Rapti', 153),
(2578, 'Sagarmatha', 153),
(2579, 'Seti', 153),
(2580, 'Bonaire', 154),
(2581, 'Curacao', 154),
(2582, 'Saba', 154),
(2583, 'Sint Eustatius', 154),
(2584, 'Sint Maarten', 154),
(2585, 'Amsterdam', 155),
(2586, 'Benelux', 155),
(2587, 'Drenthe', 155),
(2588, 'Flevoland', 155),
(2589, 'Friesland', 155),
(2590, 'Gelderland', 155),
(2591, 'Groningen', 155),
(2592, 'Limburg', 155),
(2593, 'Noord-Brabant', 155),
(2594, 'Noord-Holland', 155),
(2595, 'Overijssel', 155),
(2596, 'South Holland', 155),
(2597, 'Utrecht', 155),
(2598, 'Zeeland', 155),
(2599, 'Zuid-Holland', 155),
(2600, 'Iles', 156),
(2601, 'Nord', 156),
(2602, 'Sud', 156),
(2603, 'Area Outside Region', 157),
(2604, 'Auckland', 157),
(2605, 'Bay of Plenty', 157),
(2606, 'Canterbury', 157),
(2607, 'Christchurch', 157),
(2608, 'Gisborne', 157),
(2609, 'Hawke\'s Bay', 157),
(2610, 'Manawatu-Wanganui', 157),
(2611, 'Marlborough', 157),
(2612, 'Nelson', 157),
(2613, 'Northland', 157),
(2614, 'Otago', 157),
(2615, 'Rodney', 157),
(2616, 'Southland', 157),
(2617, 'Taranaki', 157),
(2618, 'Tasman', 157),
(2619, 'Waikato', 157),
(2620, 'Wellington', 157),
(2621, 'West Coast', 157),
(2622, 'Atlantico Norte', 158),
(2623, 'Atlantico Sur', 158),
(2624, 'Boaco', 158),
(2625, 'Carazo', 158),
(2626, 'Chinandega', 158),
(2627, 'Chontales', 158),
(2628, 'Esteli', 158),
(2629, 'Granada', 158),
(2630, 'Jinotega', 158),
(2631, 'Leon', 158),
(2632, 'Madriz', 158),
(2633, 'Managua', 158),
(2634, 'Masaya', 158),
(2635, 'Matagalpa', 158),
(2636, 'Nueva Segovia', 158),
(2637, 'Rio San Juan', 158),
(2638, 'Rivas', 158),
(2639, 'Agadez', 159),
(2640, 'Diffa', 159),
(2641, 'Dosso', 159),
(2642, 'Maradi', 159),
(2643, 'Niamey', 159),
(2644, 'Tahoua', 159),
(2645, 'Tillabery', 159),
(2646, 'Zinder', 159),
(2647, 'Abia', 160),
(2648, 'Abuja Federal Capital Territor', 160),
(2649, 'Adamawa', 160),
(2650, 'Akwa Ibom', 160),
(2651, 'Anambra', 160),
(2652, 'Bauchi', 160),
(2653, 'Bayelsa', 160),
(2654, 'Benue', 160),
(2655, 'Borno', 160),
(2656, 'Cross River', 160),
(2657, 'Delta', 160),
(2658, 'Ebonyi', 160),
(2659, 'Edo', 160),
(2660, 'Ekiti', 160),
(2661, 'Enugu', 160),
(2662, 'Gombe', 160),
(2663, 'Imo', 160),
(2664, 'Jigawa', 160),
(2665, 'Kaduna', 160),
(2666, 'Kano', 160),
(2667, 'Katsina', 160),
(2668, 'Kebbi', 160),
(2669, 'Kogi', 160),
(2670, 'Kwara', 160),
(2671, 'Lagos', 160),
(2672, 'Nassarawa', 160),
(2673, 'Niger', 160),
(2674, 'Ogun', 160),
(2675, 'Ondo', 160),
(2676, 'Osun', 160),
(2677, 'Oyo', 160),
(2678, 'Plateau', 160),
(2679, 'Rivers', 160),
(2680, 'Sokoto', 160),
(2681, 'Taraba', 160),
(2682, 'Yobe', 160),
(2683, 'Zamfara', 160),
(2684, 'Niue', 161),
(2685, 'Norfolk Island', 162),
(2686, 'Northern Islands', 163),
(2687, 'Rota', 163),
(2688, 'Saipan', 163),
(2689, 'Tinian', 163),
(2690, 'Akershus', 164),
(2691, 'Aust Agder', 164),
(2692, 'Bergen', 164),
(2693, 'Buskerud', 164),
(2694, 'Finnmark', 164),
(2695, 'Hedmark', 164),
(2696, 'Hordaland', 164),
(2697, 'Moere og Romsdal', 164),
(2698, 'Nord Trondelag', 164),
(2699, 'Nordland', 164),
(2700, 'Oestfold', 164),
(2701, 'Oppland', 164),
(2702, 'Oslo', 164),
(2703, 'Rogaland', 164),
(2704, 'Soer Troendelag', 164),
(2705, 'Sogn og Fjordane', 164),
(2706, 'Stavern', 164),
(2707, 'Sykkylven', 164),
(2708, 'Telemark', 164),
(2709, 'Troms', 164),
(2710, 'Vest Agder', 164),
(2711, 'Vestfold', 164),
(2712, 'ÃƒÆ’Ã‚Ëœstfold', 164),
(2713, 'Al Buraimi', 165),
(2714, 'Dhufar', 165),
(2715, 'Masqat', 165),
(2716, 'Musandam', 165),
(2717, 'Rusayl', 165),
(2718, 'Wadi Kabir', 165),
(2719, 'ad-Dakhiliyah', 165),
(2720, 'adh-Dhahirah', 165),
(2721, 'al-Batinah', 165),
(2722, 'ash-Sharqiyah', 165),
(2723, 'Baluchistan', 166),
(2724, 'Federal Capital Area', 166),
(2725, 'Federally administered Tribal ', 166),
(2726, 'North-West Frontier', 166),
(2727, 'Northern Areas', 166),
(2728, 'Punjab', 166),
(2729, 'Sind', 166),
(2730, 'Aimeliik', 167),
(2731, 'Airai', 167),
(2732, 'Angaur', 167),
(2733, 'Hatobohei', 167),
(2734, 'Kayangel', 167),
(2735, 'Koror', 167),
(2736, 'Melekeok', 167),
(2737, 'Ngaraard', 167),
(2738, 'Ngardmau', 167),
(2739, 'Ngaremlengui', 167),
(2740, 'Ngatpang', 167),
(2741, 'Ngchesar', 167),
(2742, 'Ngerchelong', 167),
(2743, 'Ngiwal', 167),
(2744, 'Peleliu', 167),
(2745, 'Sonsorol', 167),
(2746, 'Ariha', 168),
(2747, 'Bayt Lahm', 168),
(2748, 'Bethlehem', 168),
(2749, 'Dayr-al-Balah', 168),
(2750, 'Ghazzah', 168),
(2751, 'Ghazzah ash-Shamaliyah', 168),
(2752, 'Janin', 168),
(2753, 'Khan Yunis', 168),
(2754, 'Nabulus', 168),
(2755, 'Qalqilyah', 168),
(2756, 'Rafah', 168),
(2757, 'Ram Allah wal-Birah', 168),
(2758, 'Salfit', 168),
(2759, 'Tubas', 168),
(2760, 'Tulkarm', 168),
(2761, 'al-Khalil', 168),
(2762, 'al-Quds', 168),
(2763, 'Bocas del Toro', 169),
(2764, 'Chiriqui', 169),
(2765, 'Cocle', 169),
(2766, 'Colon', 169),
(2767, 'Darien', 169),
(2768, 'Embera', 169),
(2769, 'Herrera', 169),
(2770, 'Kuna Yala', 169),
(2771, 'Los Santos', 169),
(2772, 'Ngobe Bugle', 169),
(2773, 'Panama', 169),
(2774, 'Veraguas', 169),
(2775, 'East New Britain', 170),
(2776, 'East Sepik', 170),
(2777, 'Eastern Highlands', 170),
(2778, 'Enga', 170),
(2779, 'Fly River', 170),
(2780, 'Gulf', 170),
(2781, 'Madang', 170),
(2782, 'Manus', 170),
(2783, 'Milne Bay', 170),
(2784, 'Morobe', 170),
(2785, 'National Capital District', 170),
(2786, 'New Ireland', 170),
(2787, 'North Solomons', 170),
(2788, 'Oro', 170),
(2789, 'Sandaun', 170),
(2790, 'Simbu', 170),
(2791, 'Southern Highlands', 170),
(2792, 'West New Britain', 170),
(2793, 'Western Highlands', 170),
(2794, 'Alto Paraguay', 171),
(2795, 'Alto Parana', 171),
(2796, 'Amambay', 171),
(2797, 'Asuncion', 171),
(2798, 'Boqueron', 171),
(2799, 'Caaguazu', 171),
(2800, 'Caazapa', 171),
(2801, 'Canendiyu', 171),
(2802, 'Central', 171),
(2803, 'Concepcion', 171),
(2804, 'Cordillera', 171),
(2805, 'Guaira', 171),
(2806, 'Itapua', 171),
(2807, 'Misiones', 171),
(2808, 'Neembucu', 171),
(2809, 'Paraguari', 171),
(2810, 'Presidente Hayes', 171),
(2811, 'San Pedro', 171),
(2812, 'Amazonas', 172),
(2813, 'Ancash', 172),
(2814, 'Apurimac', 172),
(2815, 'Arequipa', 172),
(2816, 'Ayacucho', 172),
(2817, 'Cajamarca', 172),
(2818, 'Cusco', 172),
(2819, 'Huancavelica', 172),
(2820, 'Huanuco', 172),
(2821, 'Ica', 172),
(2822, 'Junin', 172),
(2823, 'La Libertad', 172),
(2824, 'Lambayeque', 172),
(2825, 'Lima y Callao', 172),
(2826, 'Loreto', 172),
(2827, 'Madre de Dios', 172),
(2828, 'Moquegua', 172),
(2829, 'Pasco', 172),
(2830, 'Piura', 172),
(2831, 'Puno', 172),
(2832, 'San Martin', 172),
(2833, 'Tacna', 172),
(2834, 'Tumbes', 172),
(2835, 'Ucayali', 172),
(2836, 'Batangas', 173),
(2837, 'Bicol', 173),
(2838, 'Bulacan', 173),
(2839, 'Cagayan', 173),
(2840, 'Caraga', 173),
(2841, 'Central Luzon', 173),
(2842, 'Central Mindanao', 173),
(2843, 'Central Visayas', 173),
(2844, 'Cordillera', 173),
(2845, 'Davao', 173),
(2846, 'Eastern Visayas', 173),
(2847, 'Greater Metropolitan Area', 173),
(2848, 'Ilocos', 173),
(2849, 'Laguna', 173),
(2850, 'Luzon', 173),
(2851, 'Mactan', 173),
(2852, 'Metropolitan Manila Area', 173),
(2853, 'Muslim Mindanao', 173),
(2854, 'Northern Mindanao', 173),
(2855, 'Southern Mindanao', 173),
(2856, 'Southern Tagalog', 173),
(2857, 'Western Mindanao', 173),
(2858, 'Western Visayas', 173),
(2859, 'Pitcairn Island', 174),
(2860, 'Biale Blota', 175),
(2861, 'Dobroszyce', 175),
(2862, 'Dolnoslaskie', 175),
(2863, 'Dziekanow Lesny', 175),
(2864, 'Hopowo', 175),
(2865, 'Kartuzy', 175),
(2866, 'Koscian', 175),
(2867, 'Krakow', 175),
(2868, 'Kujawsko-Pomorskie', 175),
(2869, 'Lodzkie', 175),
(2870, 'Lubelskie', 175),
(2871, 'Lubuskie', 175),
(2872, 'Malomice', 175),
(2873, 'Malopolskie', 175),
(2874, 'Mazowieckie', 175),
(2875, 'Mirkow', 175),
(2876, 'Opolskie', 175),
(2877, 'Ostrowiec', 175),
(2878, 'Podkarpackie', 175),
(2879, 'Podlaskie', 175),
(2880, 'Polska', 175),
(2881, 'Pomorskie', 175),
(2882, 'Poznan', 175),
(2883, 'Pruszkow', 175),
(2884, 'Rymanowska', 175),
(2885, 'Rzeszow', 175),
(2886, 'Slaskie', 175),
(2887, 'Stare Pole', 175),
(2888, 'Swietokrzyskie', 175),
(2889, 'Warminsko-Mazurskie', 175),
(2890, 'Warsaw', 175),
(2891, 'Wejherowo', 175),
(2892, 'Wielkopolskie', 175),
(2893, 'Wroclaw', 175),
(2894, 'Zachodnio-Pomorskie', 175),
(2895, 'Zukowo', 175),
(2896, 'Abrantes', 176),
(2897, 'Acores', 176),
(2898, 'Alentejo', 176),
(2899, 'Algarve', 176),
(2900, 'Braga', 176),
(2901, 'Centro', 176),
(2902, 'Distrito de Leiria', 176),
(2903, 'Distrito de Viana do Castelo', 176),
(2904, 'Distrito de Vila Real', 176),
(2905, 'Distrito do Porto', 176),
(2906, 'Lisboa e Vale do Tejo', 176),
(2907, 'Madeira', 176),
(2908, 'Norte', 176),
(2909, 'Paivas', 176),
(2910, 'Arecibo', 177),
(2911, 'Bayamon', 177),
(2912, 'Carolina', 177),
(2913, 'Florida', 177),
(2914, 'Guayama', 177),
(2915, 'Humacao', 177),
(2916, 'Mayaguez-Aguadilla', 177),
(2917, 'Ponce', 177),
(2918, 'Salinas', 177),
(2919, 'San Juan', 177),
(2920, 'Doha', 178),
(2921, 'Jarian-al-Batnah', 178),
(2922, 'Umm Salal', 178),
(2923, 'ad-Dawhah', 178),
(2924, 'al-Ghuwayriyah', 178),
(2925, 'al-Jumayliyah', 178),
(2926, 'al-Khawr', 178),
(2927, 'al-Wakrah', 178),
(2928, 'ar-Rayyan', 178),
(2929, 'ash-Shamal', 178),
(2930, 'Saint-Benoit', 179),
(2931, 'Saint-Denis', 179),
(2932, 'Saint-Paul', 179),
(2933, 'Saint-Pierre', 179),
(2934, 'Alba', 180),
(2935, 'Arad', 180),
(2936, 'Arges', 180),
(2937, 'Bacau', 180),
(2938, 'Bihor', 180),
(2939, 'Bistrita-Nasaud', 180),
(2940, 'Botosani', 180),
(2941, 'Braila', 180),
(2942, 'Brasov', 180),
(2943, 'Bucuresti', 180),
(2944, 'Buzau', 180),
(2945, 'Calarasi', 180),
(2946, 'Caras-Severin', 180),
(2947, 'Cluj', 180),
(2948, 'Constanta', 180),
(2949, 'Covasna', 180),
(2950, 'Dambovita', 180),
(2951, 'Dolj', 180),
(2952, 'Galati', 180),
(2953, 'Giurgiu', 180),
(2954, 'Gorj', 180),
(2955, 'Harghita', 180),
(2956, 'Hunedoara', 180),
(2957, 'Ialomita', 180),
(2958, 'Iasi', 180),
(2959, 'Ilfov', 180),
(2960, 'Maramures', 180),
(2961, 'Mehedinti', 180),
(2962, 'Mures', 180),
(2963, 'Neamt', 180),
(2964, 'Olt', 180),
(2965, 'Prahova', 180),
(2966, 'Salaj', 180),
(2967, 'Satu Mare', 180),
(2968, 'Sibiu', 180),
(2969, 'Sondelor', 180),
(2970, 'Suceava', 180),
(2971, 'Teleorman', 180),
(2972, 'Timis', 180),
(2973, 'Tulcea', 180),
(2974, 'Valcea', 180),
(2975, 'Vaslui', 180),
(2976, 'Vrancea', 180),
(2977, 'Adygeja', 181),
(2978, 'Aga', 181),
(2979, 'Alanija', 181),
(2980, 'Altaj', 181),
(2981, 'Amur', 181),
(2982, 'Arhangelsk', 181),
(2983, 'Astrahan', 181),
(2984, 'Bashkortostan', 181),
(2985, 'Belgorod', 181),
(2986, 'Brjansk', 181),
(2987, 'Burjatija', 181),
(2988, 'Chechenija', 181),
(2989, 'Cheljabinsk', 181),
(2990, 'Chita', 181),
(2991, 'Chukotka', 181),
(2992, 'Chuvashija', 181),
(2993, 'Dagestan', 181),
(2994, 'Evenkija', 181),
(2995, 'Gorno-Altaj', 181),
(2996, 'Habarovsk', 181),
(2997, 'Hakasija', 181),
(2998, 'Hanty-Mansija', 181),
(2999, 'Ingusetija', 181),
(3000, 'Irkutsk', 181),
(3001, 'Ivanovo', 181),
(3002, 'Jamalo-Nenets', 181),
(3003, 'Jaroslavl', 181),
(3004, 'Jevrej', 181),
(3005, 'Kabardino-Balkarija', 181),
(3006, 'Kaliningrad', 181),
(3007, 'Kalmykija', 181),
(3008, 'Kaluga', 181),
(3009, 'Kamchatka', 181),
(3010, 'Karachaj-Cherkessija', 181),
(3011, 'Karelija', 181),
(3012, 'Kemerovo', 181),
(3013, 'Khabarovskiy Kray', 181),
(3014, 'Kirov', 181),
(3015, 'Komi', 181),
(3016, 'Komi-Permjakija', 181),
(3017, 'Korjakija', 181),
(3018, 'Kostroma', 181),
(3019, 'Krasnodar', 181),
(3020, 'Krasnojarsk', 181),
(3021, 'Krasnoyarskiy Kray', 181),
(3022, 'Kurgan', 181),
(3023, 'Kursk', 181),
(3024, 'Leningrad', 181),
(3025, 'Lipeck', 181),
(3026, 'Magadan', 181),
(3027, 'Marij El', 181),
(3028, 'Mordovija', 181),
(3029, 'Moscow', 181),
(3030, 'Moskovskaja Oblast', 181),
(3031, 'Moskovskaya Oblast', 181),
(3032, 'Moskva', 181),
(3033, 'Murmansk', 181),
(3034, 'Nenets', 181),
(3035, 'Nizhnij Novgorod', 181),
(3036, 'Novgorod', 181),
(3037, 'Novokusnezk', 181),
(3038, 'Novosibirsk', 181),
(3039, 'Omsk', 181),
(3040, 'Orenburg', 181),
(3041, 'Orjol', 181),
(3042, 'Penza', 181),
(3043, 'Perm', 181),
(3044, 'Primorje', 181),
(3045, 'Pskov', 181),
(3046, 'Pskovskaya Oblast', 181),
(3047, 'Rjazan', 181),
(3048, 'Rostov', 181),
(3049, 'Saha', 181),
(3050, 'Sahalin', 181),
(3051, 'Samara', 181),
(3052, 'Samarskaya', 181),
(3053, 'Sankt-Peterburg', 181),
(3054, 'Saratov', 181),
(3055, 'Smolensk', 181),
(3056, 'Stavropol', 181),
(3057, 'Sverdlovsk', 181),
(3058, 'Tajmyrija', 181),
(3059, 'Tambov', 181),
(3060, 'Tatarstan', 181),
(3061, 'Tjumen', 181),
(3062, 'Tomsk', 181),
(3063, 'Tula', 181),
(3064, 'Tver', 181),
(3065, 'Tyva', 181),
(3066, 'Udmurtija', 181),
(3067, 'Uljanovsk', 181),
(3068, 'Ulyanovskaya Oblast', 181),
(3069, 'Ust-Orda', 181),
(3070, 'Vladimir', 181),
(3071, 'Volgograd', 181),
(3072, 'Vologda', 181),
(3073, 'Voronezh', 181),
(3074, 'Butare', 182),
(3075, 'Byumba', 182),
(3076, 'Cyangugu', 182),
(3077, 'Gikongoro', 182),
(3078, 'Gisenyi', 182),
(3079, 'Gitarama', 182),
(3080, 'Kibungo', 182),
(3081, 'Kibuye', 182),
(3082, 'Kigali-ngali', 182),
(3083, 'Ruhengeri', 182),
(3084, 'Ascension', 183),
(3085, 'Gough Island', 183),
(3086, 'Saint Helena', 183),
(3087, 'Tristan da Cunha', 183),
(3088, 'Christ Church Nichola Town', 184),
(3089, 'Saint Anne Sandy Point', 184),
(3090, 'Saint George Basseterre', 184),
(3091, 'Saint George Gingerland', 184),
(3092, 'Saint James Windward', 184),
(3093, 'Saint John Capesterre', 184),
(3094, 'Saint John Figtree', 184),
(3095, 'Saint Mary Cayon', 184),
(3096, 'Saint Paul Capesterre', 184),
(3097, 'Saint Paul Charlestown', 184),
(3098, 'Saint Peter Basseterre', 184),
(3099, 'Saint Thomas Lowland', 184),
(3100, 'Saint Thomas Middle Island', 184),
(3101, 'Trinity Palmetto Point', 184),
(3102, 'Anse-la-Raye', 185),
(3103, 'Canaries', 185),
(3104, 'Castries', 185),
(3105, 'Choiseul', 185),
(3106, 'Dennery', 185),
(3107, 'Gros Inlet', 185),
(3108, 'Laborie', 185),
(3109, 'Micoud', 185),
(3110, 'Soufriere', 185),
(3111, 'Vieux Fort', 185),
(3112, 'Miquelon-Langlade', 186),
(3113, 'Saint-Pierre', 186),
(3114, 'Charlotte', 187),
(3115, 'Grenadines', 187),
(3116, 'Saint Andrew', 187),
(3117, 'Saint David', 187),
(3118, 'Saint George', 187),
(3119, 'Saint Patrick', 187),
(3120, 'A\'ana', 188),
(3121, 'Aiga-i-le-Tai', 188),
(3122, 'Atua', 188),
(3123, 'Fa\'asaleleaga', 188),
(3124, 'Gaga\'emauga', 188),
(3125, 'Gagaifomauga', 188),
(3126, 'Palauli', 188),
(3127, 'Satupa\'itea', 188),
(3128, 'Tuamasaga', 188),
(3129, 'Va\'a-o-Fonoti', 188),
(3130, 'Vaisigano', 188),
(3131, 'Acquaviva', 189),
(3132, 'Borgo Maggiore', 189),
(3133, 'Chiesanuova', 189),
(3134, 'Domagnano', 189),
(3135, 'Faetano', 189),
(3136, 'Fiorentino', 189),
(3137, 'Montegiardino', 189),
(3138, 'San Marino', 189),
(3139, 'Serravalle', 189),
(3140, 'Agua Grande', 190),
(3141, 'Cantagalo', 190),
(3142, 'Lemba', 190),
(3143, 'Lobata', 190),
(3144, 'Me-Zochi', 190),
(3145, 'Pague', 190),
(3146, 'Al Khobar', 191),
(3147, 'Aseer', 191),
(3148, 'Ash Sharqiyah', 191),
(3149, 'Asir', 191),
(3150, 'Central Province', 191),
(3151, 'Eastern Province', 191),
(3152, 'Ha\'il', 191),
(3153, 'Jawf', 191),
(3154, 'Jizan', 191),
(3155, 'Makkah', 191),
(3156, 'Najran', 191),
(3157, 'Qasim', 191),
(3158, 'Tabuk', 191),
(3159, 'Western Province', 191),
(3160, 'al-Bahah', 191),
(3161, 'al-Hudud-ash-Shamaliyah', 191),
(3162, 'al-Madinah', 191),
(3163, 'ar-Riyad', 191),
(3164, 'Dakar', 192),
(3165, 'Diourbel', 192),
(3166, 'Fatick', 192),
(3167, 'Kaolack', 192),
(3168, 'Kolda', 192),
(3169, 'Louga', 192),
(3170, 'Saint-Louis', 192),
(3171, 'Tambacounda', 192),
(3172, 'Thies', 192),
(3173, 'Ziguinchor', 192),
(3174, 'Central Serbia', 193),
(3175, 'Kosovo and Metohija', 193),
(3176, 'Vojvodina', 193),
(3177, 'Anse Boileau', 194),
(3178, 'Anse Royale', 194),
(3179, 'Cascade', 194),
(3180, 'Takamaka', 194),
(3181, 'Victoria', 194),
(3182, 'Eastern', 195),
(3183, 'Northern', 195),
(3184, 'Southern', 195),
(3185, 'Western', 195),
(3186, 'Singapore', 196),
(3187, 'Banskobystricky', 197),
(3188, 'Bratislavsky', 197),
(3189, 'Kosicky', 197),
(3190, 'Nitriansky', 197),
(3191, 'Presovsky', 197),
(3192, 'Trenciansky', 197),
(3193, 'Trnavsky', 197),
(3194, 'Zilinsky', 197),
(3195, 'Benedikt', 198),
(3196, 'Gorenjska', 198),
(3197, 'Gorishka', 198),
(3198, 'Jugovzhodna Slovenija', 198),
(3199, 'Koroshka', 198),
(3200, 'Notranjsko-krashka', 198),
(3201, 'Obalno-krashka', 198),
(3202, 'Obcina Domzale', 198),
(3203, 'Obcina Vitanje', 198),
(3204, 'Osrednjeslovenska', 198),
(3205, 'Podravska', 198),
(3206, 'Pomurska', 198),
(3207, 'Savinjska', 198),
(3208, 'Slovenian Littoral', 198),
(3209, 'Spodnjeposavska', 198),
(3210, 'Zasavska', 198),
(3211, 'Pitcairn', 199),
(3212, 'Central', 200),
(3213, 'Choiseul', 200),
(3214, 'Guadalcanal', 200),
(3215, 'Isabel', 200),
(3216, 'Makira and Ulawa', 200),
(3217, 'Malaita', 200),
(3218, 'Rennell and Bellona', 200),
(3219, 'Temotu', 200),
(3220, 'Western', 200),
(3221, 'Awdal', 201),
(3222, 'Bakol', 201),
(3223, 'Banadir', 201),
(3224, 'Bari', 201),
(3225, 'Bay', 201),
(3226, 'Galgudug', 201),
(3227, 'Gedo', 201),
(3228, 'Hiran', 201),
(3229, 'Jubbada Hose', 201),
(3230, 'Jubbadha Dexe', 201),
(3231, 'Mudug', 201),
(3232, 'Nugal', 201),
(3233, 'Sanag', 201),
(3234, 'Shabellaha Dhexe', 201),
(3235, 'Shabellaha Hose', 201),
(3236, 'Togdher', 201),
(3237, 'Woqoyi Galbed', 201),
(3238, 'Eastern Cape', 202),
(3239, 'Free State', 202),
(3240, 'Gauteng', 202),
(3241, 'Kempton Park', 202),
(3242, 'Kramerville', 202),
(3243, 'KwaZulu Natal', 202),
(3244, 'Limpopo', 202),
(3245, 'Mpumalanga', 202),
(3246, 'North West', 202),
(3247, 'Northern Cape', 202),
(3248, 'Parow', 202),
(3249, 'Table View', 202),
(3250, 'Umtentweni', 202),
(3251, 'Western Cape', 202),
(3252, 'South Georgia', 203),
(3253, 'Central Equatoria', 204),
(3254, 'A Coruna', 205),
(3255, 'Alacant', 205),
(3256, 'Alava', 205),
(3257, 'Albacete', 205),
(3258, 'Almeria', 205),
(3259, 'Andalucia', 205),
(3260, 'Asturias', 205),
(3261, 'Avila', 205),
(3262, 'Badajoz', 205),
(3263, 'Balears', 205),
(3264, 'Barcelona', 205),
(3265, 'Bertamirans', 205),
(3266, 'Biscay', 205),
(3267, 'Burgos', 205),
(3268, 'Caceres', 205),
(3269, 'Cadiz', 205),
(3270, 'Cantabria', 205),
(3271, 'Castello', 205),
(3272, 'Catalunya', 205),
(3273, 'Ceuta', 205),
(3274, 'Ciudad Real', 205),
(3275, 'Comunidad Autonoma de Canarias', 205),
(3276, 'Comunidad Autonoma de Cataluna', 205),
(3277, 'Comunidad Autonoma de Galicia', 205),
(3278, 'Comunidad Autonoma de las Isla', 205),
(3279, 'Comunidad Autonoma del Princip', 205),
(3280, 'Comunidad Valenciana', 205),
(3281, 'Cordoba', 205),
(3282, 'Cuenca', 205),
(3283, 'Gipuzkoa', 205),
(3284, 'Girona', 205),
(3285, 'Granada', 205),
(3286, 'Guadalajara', 205),
(3287, 'Guipuzcoa', 205),
(3288, 'Huelva', 205),
(3289, 'Huesca', 205),
(3290, 'Jaen', 205),
(3291, 'La Rioja', 205),
(3292, 'Las Palmas', 205),
(3293, 'Leon', 205),
(3294, 'Lerida', 205),
(3295, 'Lleida', 205),
(3296, 'Lugo', 205),
(3297, 'Madrid', 205),
(3298, 'Malaga', 205),
(3299, 'Melilla', 205),
(3300, 'Murcia', 205),
(3301, 'Navarra', 205),
(3302, 'Ourense', 205),
(3303, 'Pais Vasco', 205),
(3304, 'Palencia', 205),
(3305, 'Pontevedra', 205),
(3306, 'Salamanca', 205),
(3307, 'Santa Cruz de Tenerife', 205),
(3308, 'Segovia', 205),
(3309, 'Sevilla', 205),
(3310, 'Soria', 205),
(3311, 'Tarragona', 205),
(3312, 'Tenerife', 205),
(3313, 'Teruel', 205),
(3314, 'Toledo', 205),
(3315, 'Valencia', 205),
(3316, 'Valladolid', 205),
(3317, 'Vizcaya', 205),
(3318, 'Zamora', 205),
(3319, 'Zaragoza', 205),
(3320, 'Amparai', 206),
(3321, 'Anuradhapuraya', 206),
(3322, 'Badulla', 206),
(3323, 'Boralesgamuwa', 206),
(3324, 'Colombo', 206),
(3325, 'Galla', 206),
(3326, 'Gampaha', 206),
(3327, 'Hambantota', 206),
(3328, 'Kalatura', 206),
(3329, 'Kegalla', 206),
(3330, 'Kilinochchi', 206),
(3331, 'Kurunegala', 206),
(3332, 'Madakalpuwa', 206),
(3333, 'Maha Nuwara', 206),
(3334, 'Malwana', 206),
(3335, 'Mannarama', 206),
(3336, 'Matale', 206),
(3337, 'Matara', 206),
(3338, 'Monaragala', 206),
(3339, 'Mullaitivu', 206),
(3340, 'North Eastern Province', 206),
(3341, 'North Western Province', 206),
(3342, 'Nuwara Eliya', 206),
(3343, 'Polonnaruwa', 206),
(3344, 'Puttalama', 206),
(3345, 'Ratnapuraya', 206),
(3346, 'Southern Province', 206),
(3347, 'Tirikunamalaya', 206),
(3348, 'Tuscany', 206),
(3349, 'Vavuniyawa', 206),
(3350, 'Western Province', 206),
(3351, 'Yapanaya', 206),
(3352, 'kadawatha', 206),
(3353, 'A\'ali-an-Nil', 207),
(3354, 'Bahr-al-Jabal', 207),
(3355, 'Central Equatoria', 207),
(3356, 'Gharb Bahr-al-Ghazal', 207),
(3357, 'Gharb Darfur', 207),
(3358, 'Gharb Kurdufan', 207),
(3359, 'Gharb-al-Istiwa\'iyah', 207),
(3360, 'Janub Darfur', 207),
(3361, 'Janub Kurdufan', 207),
(3362, 'Junqali', 207),
(3363, 'Kassala', 207),
(3364, 'Nahr-an-Nil', 207),
(3365, 'Shamal Bahr-al-Ghazal', 207),
(3366, 'Shamal Darfur', 207),
(3367, 'Shamal Kurdufan', 207),
(3368, 'Sharq-al-Istiwa\'iyah', 207),
(3369, 'Sinnar', 207),
(3370, 'Warab', 207),
(3371, 'Wilayat al Khartum', 207),
(3372, 'al-Bahr-al-Ahmar', 207),
(3373, 'al-Buhayrat', 207),
(3374, 'al-Jazirah', 207),
(3375, 'al-Khartum', 207),
(3376, 'al-Qadarif', 207),
(3377, 'al-Wahdah', 207),
(3378, 'an-Nil-al-Abyad', 207),
(3379, 'an-Nil-al-Azraq', 207),
(3380, 'ash-Shamaliyah', 207),
(3381, 'Brokopondo', 208),
(3382, 'Commewijne', 208),
(3383, 'Coronie', 208),
(3384, 'Marowijne', 208),
(3385, 'Nickerie', 208),
(3386, 'Para', 208),
(3387, 'Paramaribo', 208),
(3388, 'Saramacca', 208),
(3389, 'Wanica', 208),
(3390, 'Svalbard', 209),
(3391, 'Hhohho', 210),
(3392, 'Lubombo', 210),
(3393, 'Manzini', 210),
(3394, 'Shiselweni', 210),
(3395, 'Alvsborgs Lan', 211),
(3396, 'Angermanland', 211),
(3397, 'Blekinge', 211),
(3398, 'Bohuslan', 211),
(3399, 'Dalarna', 211),
(3400, 'Gavleborg', 211),
(3401, 'Gaza', 211),
(3402, 'Gotland', 211),
(3403, 'Halland', 211),
(3404, 'Jamtland', 211),
(3405, 'Jonkoping', 211),
(3406, 'Kalmar', 211),
(3407, 'Kristianstads', 211),
(3408, 'Kronoberg', 211),
(3409, 'Norrbotten', 211),
(3410, 'Orebro', 211),
(3411, 'Ostergotland', 211),
(3412, 'Saltsjo-Boo', 211),
(3413, 'Skane', 211),
(3414, 'Smaland', 211),
(3415, 'Sodermanland', 211),
(3416, 'Stockholm', 211),
(3417, 'Uppsala', 211),
(3418, 'Varmland', 211),
(3419, 'Vasterbotten', 211),
(3420, 'Vastergotland', 211),
(3421, 'Vasternorrland', 211),
(3422, 'Vastmanland', 211),
(3423, 'Vastra Gotaland', 211),
(3424, 'Aargau', 212),
(3425, 'Appenzell Inner-Rhoden', 212),
(3426, 'Appenzell-Ausser Rhoden', 212),
(3427, 'Basel-Landschaft', 212),
(3428, 'Basel-Stadt', 212),
(3429, 'Bern', 212),
(3430, 'Canton Ticino', 212),
(3431, 'Fribourg', 212),
(3432, 'Geneve', 212),
(3433, 'Glarus', 212),
(3434, 'Graubunden', 212),
(3435, 'Heerbrugg', 212),
(3436, 'Jura', 212),
(3437, 'Kanton Aargau', 212),
(3438, 'Luzern', 212),
(3439, 'Morbio Inferiore', 212),
(3440, 'Muhen', 212),
(3441, 'Neuchatel', 212),
(3442, 'Nidwalden', 212),
(3443, 'Obwalden', 212),
(3444, 'Sankt Gallen', 212),
(3445, 'Schaffhausen', 212),
(3446, 'Schwyz', 212),
(3447, 'Solothurn', 212),
(3448, 'Thurgau', 212),
(3449, 'Ticino', 212),
(3450, 'Uri', 212),
(3451, 'Valais', 212),
(3452, 'Vaud', 212),
(3453, 'Vauffelin', 212),
(3454, 'Zug', 212),
(3455, 'Zurich', 212),
(3456, 'Aleppo', 213),
(3457, 'Dar\'a', 213),
(3458, 'Dayr-az-Zawr', 213),
(3459, 'Dimashq', 213),
(3460, 'Halab', 213),
(3461, 'Hamah', 213),
(3462, 'Hims', 213),
(3463, 'Idlib', 213),
(3464, 'Madinat Dimashq', 213),
(3465, 'Tartus', 213),
(3466, 'al-Hasakah', 213),
(3467, 'al-Ladhiqiyah', 213),
(3468, 'al-Qunaytirah', 213),
(3469, 'ar-Raqqah', 213),
(3470, 'as-Suwayda', 213),
(3471, 'Changhwa', 214),
(3472, 'Chiayi Hsien', 214),
(3473, 'Chiayi Shih', 214),
(3474, 'Eastern Taipei', 214),
(3475, 'Hsinchu Hsien', 214),
(3476, 'Hsinchu Shih', 214),
(3477, 'Hualien', 214),
(3478, 'Ilan', 214),
(3479, 'Kaohsiung Hsien', 214),
(3480, 'Kaohsiung Shih', 214),
(3481, 'Keelung Shih', 214),
(3482, 'Kinmen', 214),
(3483, 'Miaoli', 214),
(3484, 'Nantou', 214),
(3485, 'Northern Taiwan', 214),
(3486, 'Penghu', 214),
(3487, 'Pingtung', 214),
(3488, 'Taichung', 214),
(3489, 'Taichung Hsien', 214),
(3490, 'Taichung Shih', 214),
(3491, 'Tainan Hsien', 214),
(3492, 'Tainan Shih', 214),
(3493, 'Taipei Hsien', 214),
(3494, 'Taipei Shih / Taipei Hsien', 214),
(3495, 'Taitung', 214),
(3496, 'Taoyuan', 214),
(3497, 'Yilan', 214),
(3498, 'Yun-Lin Hsien', 214),
(3499, 'Yunlin', 214),
(3500, 'Dushanbe', 215),
(3501, 'Gorno-Badakhshan', 215),
(3502, 'Karotegin', 215),
(3503, 'Khatlon', 215),
(3504, 'Sughd', 215),
(3505, 'Arusha', 216),
(3506, 'Dar es Salaam', 216),
(3507, 'Dodoma', 216),
(3508, 'Iringa', 216),
(3509, 'Kagera', 216),
(3510, 'Kigoma', 216),
(3511, 'Kilimanjaro', 216),
(3512, 'Lindi', 216),
(3513, 'Mara', 216),
(3514, 'Mbeya', 216),
(3515, 'Morogoro', 216),
(3516, 'Mtwara', 216),
(3517, 'Mwanza', 216),
(3518, 'Pwani', 216),
(3519, 'Rukwa', 216),
(3520, 'Ruvuma', 216),
(3521, 'Shinyanga', 216),
(3522, 'Singida', 216),
(3523, 'Tabora', 216),
(3524, 'Tanga', 216),
(3525, 'Zanzibar and Pemba', 216),
(3526, 'Amnat Charoen', 217),
(3527, 'Ang Thong', 217),
(3528, 'Bangkok', 217),
(3529, 'Buri Ram', 217),
(3530, 'Chachoengsao', 217),
(3531, 'Chai Nat', 217),
(3532, 'Chaiyaphum', 217),
(3533, 'Changwat Chaiyaphum', 217),
(3534, 'Chanthaburi', 217),
(3535, 'Chiang Mai', 217),
(3536, 'Chiang Rai', 217),
(3537, 'Chon Buri', 217),
(3538, 'Chumphon', 217),
(3539, 'Kalasin', 217),
(3540, 'Kamphaeng Phet', 217),
(3541, 'Kanchanaburi', 217),
(3542, 'Khon Kaen', 217),
(3543, 'Krabi', 217),
(3544, 'Krung Thep', 217),
(3545, 'Lampang', 217),
(3546, 'Lamphun', 217),
(3547, 'Loei', 217),
(3548, 'Lop Buri', 217),
(3549, 'Mae Hong Son', 217),
(3550, 'Maha Sarakham', 217),
(3551, 'Mukdahan', 217),
(3552, 'Nakhon Nayok', 217),
(3553, 'Nakhon Pathom', 217),
(3554, 'Nakhon Phanom', 217),
(3555, 'Nakhon Ratchasima', 217),
(3556, 'Nakhon Sawan', 217),
(3557, 'Nakhon Si Thammarat', 217),
(3558, 'Nan', 217),
(3559, 'Narathiwat', 217),
(3560, 'Nong Bua Lam Phu', 217),
(3561, 'Nong Khai', 217),
(3562, 'Nonthaburi', 217),
(3563, 'Pathum Thani', 217),
(3564, 'Pattani', 217),
(3565, 'Phangnga', 217),
(3566, 'Phatthalung', 217),
(3567, 'Phayao', 217),
(3568, 'Phetchabun', 217),
(3569, 'Phetchaburi', 217),
(3570, 'Phichit', 217),
(3571, 'Phitsanulok', 217),
(3572, 'Phra Nakhon Si Ayutthaya', 217),
(3573, 'Phrae', 217),
(3574, 'Phuket', 217),
(3575, 'Prachin Buri', 217),
(3576, 'Prachuap Khiri Khan', 217),
(3577, 'Ranong', 217),
(3578, 'Ratchaburi', 217),
(3579, 'Rayong', 217),
(3580, 'Roi Et', 217),
(3581, 'Sa Kaeo', 217),
(3582, 'Sakon Nakhon', 217),
(3583, 'Samut Prakan', 217),
(3584, 'Samut Sakhon', 217),
(3585, 'Samut Songkhran', 217),
(3586, 'Saraburi', 217),
(3587, 'Satun', 217),
(3588, 'Si Sa Ket', 217),
(3589, 'Sing Buri', 217),
(3590, 'Songkhla', 217),
(3591, 'Sukhothai', 217),
(3592, 'Suphan Buri', 217),
(3593, 'Surat Thani', 217),
(3594, 'Surin', 217),
(3595, 'Tak', 217),
(3596, 'Trang', 217),
(3597, 'Trat', 217),
(3598, 'Ubon Ratchathani', 217),
(3599, 'Udon Thani', 217),
(3600, 'Uthai Thani', 217),
(3601, 'Uttaradit', 217),
(3602, 'Yala', 217),
(3603, 'Yasothon', 217),
(3604, 'Centre', 218),
(3605, 'Kara', 218),
(3606, 'Maritime', 218),
(3607, 'Plateaux', 218),
(3608, 'Savanes', 218),
(3609, 'Atafu', 219),
(3610, 'Fakaofo', 219),
(3611, 'Nukunonu', 219),
(3612, 'Eua', 220),
(3613, 'Ha\'apai', 220),
(3614, 'Niuas', 220),
(3615, 'Tongatapu', 220),
(3616, 'Vava\'u', 220),
(3617, 'Arima-Tunapuna-Piarco', 221),
(3618, 'Caroni', 221),
(3619, 'Chaguanas', 221),
(3620, 'Couva-Tabaquite-Talparo', 221),
(3621, 'Diego Martin', 221),
(3622, 'Glencoe', 221),
(3623, 'Penal Debe', 221),
(3624, 'Point Fortin', 221),
(3625, 'Port of Spain', 221),
(3626, 'Princes Town', 221),
(3627, 'Saint George', 221),
(3628, 'San Fernando', 221),
(3629, 'San Juan', 221),
(3630, 'Sangre Grande', 221),
(3631, 'Siparia', 221),
(3632, 'Tobago', 221),
(3633, 'Aryanah', 222),
(3634, 'Bajah', 222),
(3635, 'Bin \'Arus', 222),
(3636, 'Binzart', 222),
(3637, 'Gouvernorat de Ariana', 222),
(3638, 'Gouvernorat de Nabeul', 222),
(3639, 'Gouvernorat de Sousse', 222),
(3640, 'Hammamet Yasmine', 222),
(3641, 'Jundubah', 222),
(3642, 'Madaniyin', 222),
(3643, 'Manubah', 222),
(3644, 'Monastir', 222),
(3645, 'Nabul', 222),
(3646, 'Qabis', 222),
(3647, 'Qafsah', 222),
(3648, 'Qibili', 222),
(3649, 'Safaqis', 222),
(3650, 'Sfax', 222),
(3651, 'Sidi Bu Zayd', 222),
(3652, 'Silyanah', 222),
(3653, 'Susah', 222),
(3654, 'Tatawin', 222),
(3655, 'Tawzar', 222),
(3656, 'Tunis', 222),
(3657, 'Zaghwan', 222),
(3658, 'al-Kaf', 222),
(3659, 'al-Mahdiyah', 222),
(3660, 'al-Munastir', 222),
(3661, 'al-Qasrayn', 222),
(3662, 'al-Qayrawan', 222),
(3663, 'Adana', 223),
(3664, 'Adiyaman', 223),
(3665, 'Afyon', 223),
(3666, 'Agri', 223),
(3667, 'Aksaray', 223),
(3668, 'Amasya', 223),
(3669, 'Ankara', 223),
(3670, 'Antalya', 223),
(3671, 'Ardahan', 223),
(3672, 'Artvin', 223),
(3673, 'Aydin', 223),
(3674, 'Balikesir', 223),
(3675, 'Bartin', 223),
(3676, 'Batman', 223),
(3677, 'Bayburt', 223),
(3678, 'Bilecik', 223),
(3679, 'Bingol', 223),
(3680, 'Bitlis', 223),
(3681, 'Bolu', 223),
(3682, 'Burdur', 223),
(3683, 'Bursa', 223),
(3684, 'Canakkale', 223),
(3685, 'Cankiri', 223),
(3686, 'Corum', 223),
(3687, 'Denizli', 223),
(3688, 'Diyarbakir', 223),
(3689, 'Duzce', 223),
(3690, 'Edirne', 223),
(3691, 'Elazig', 223),
(3692, 'Erzincan', 223),
(3693, 'Erzurum', 223),
(3694, 'Eskisehir', 223),
(3695, 'Gaziantep', 223),
(3696, 'Giresun', 223),
(3697, 'Gumushane', 223),
(3698, 'Hakkari', 223),
(3699, 'Hatay', 223),
(3700, 'Icel', 223),
(3701, 'Igdir', 223),
(3702, 'Isparta', 223),
(3703, 'Istanbul', 223),
(3704, 'Izmir', 223),
(3705, 'Kahramanmaras', 223),
(3706, 'Karabuk', 223),
(3707, 'Karaman', 223),
(3708, 'Kars', 223),
(3709, 'Karsiyaka', 223),
(3710, 'Kastamonu', 223),
(3711, 'Kayseri', 223),
(3712, 'Kilis', 223),
(3713, 'Kirikkale', 223),
(3714, 'Kirklareli', 223),
(3715, 'Kirsehir', 223),
(3716, 'Kocaeli', 223),
(3717, 'Konya', 223),
(3718, 'Kutahya', 223),
(3719, 'Lefkosa', 223),
(3720, 'Malatya', 223),
(3721, 'Manisa', 223),
(3722, 'Mardin', 223),
(3723, 'Mugla', 223),
(3724, 'Mus', 223),
(3725, 'Nevsehir', 223),
(3726, 'Nigde', 223),
(3727, 'Ordu', 223),
(3728, 'Osmaniye', 223),
(3729, 'Rize', 223),
(3730, 'Sakarya', 223),
(3731, 'Samsun', 223),
(3732, 'Sanliurfa', 223),
(3733, 'Siirt', 223),
(3734, 'Sinop', 223),
(3735, 'Sirnak', 223),
(3736, 'Sivas', 223),
(3737, 'Tekirdag', 223),
(3738, 'Tokat', 223),
(3739, 'Trabzon', 223),
(3740, 'Tunceli', 223),
(3741, 'Usak', 223),
(3742, 'Van', 223),
(3743, 'Yalova', 223),
(3744, 'Yozgat', 223),
(3745, 'Zonguldak', 223),
(3746, 'Ahal', 224),
(3747, 'Asgabat', 224),
(3748, 'Balkan', 224),
(3749, 'Dasoguz', 224),
(3750, 'Lebap', 224),
(3751, 'Mari', 224),
(3752, 'Grand Turk', 225),
(3753, 'South Caicos and East Caicos', 225),
(3754, 'Funafuti', 226),
(3755, 'Nanumanga', 226),
(3756, 'Nanumea', 226),
(3757, 'Niutao', 226),
(3758, 'Nui', 226),
(3759, 'Nukufetau', 226),
(3760, 'Nukulaelae', 226),
(3761, 'Vaitupu', 226),
(3762, 'Central', 227),
(3763, 'Eastern', 227),
(3764, 'Northern', 227),
(3765, 'Western', 227),
(3766, 'Cherkas\'ka', 228),
(3767, 'Chernihivs\'ka', 228),
(3768, 'Chernivets\'ka', 228),
(3769, 'Crimea', 228),
(3770, 'Dnipropetrovska', 228),
(3771, 'Donets\'ka', 228),
(3772, 'Ivano-Frankivs\'ka', 228),
(3773, 'Kharkiv', 228),
(3774, 'Kharkov', 228),
(3775, 'Khersonska', 228),
(3776, 'Khmel\'nyts\'ka', 228),
(3777, 'Kirovohrad', 228),
(3778, 'Krym', 228),
(3779, 'Kyyiv', 228),
(3780, 'Kyyivs\'ka', 228),
(3781, 'L\'vivs\'ka', 228),
(3782, 'Luhans\'ka', 228),
(3783, 'Mykolayivs\'ka', 228),
(3784, 'Odes\'ka', 228),
(3785, 'Odessa', 228),
(3786, 'Poltavs\'ka', 228),
(3787, 'Rivnens\'ka', 228),
(3788, 'Sevastopol\'', 228),
(3789, 'Sums\'ka', 228),
(3790, 'Ternopil\'s\'ka', 228),
(3791, 'Volyns\'ka', 228),
(3792, 'Vynnyts\'ka', 228),
(3793, 'Zakarpats\'ka', 228),
(3794, 'Zaporizhia', 228),
(3795, 'Zhytomyrs\'ka', 228),
(3796, 'Abu Zabi', 229),
(3797, 'Ajman', 229),
(3798, 'Dubai', 229),
(3799, 'Ras al-Khaymah', 229),
(3800, 'Sharjah', 229),
(3801, 'Sharjha', 229),
(3802, 'Umm al Qaywayn', 229),
(3803, 'al-Fujayrah', 229),
(3804, 'ash-Shariqah', 229),
(3805, 'Aberdeen', 230),
(3806, 'Aberdeenshire', 230),
(3807, 'Argyll', 230),
(3808, 'Armagh', 230),
(3809, 'Bedfordshire', 230),
(3810, 'Belfast', 230),
(3811, 'Berkshire', 230),
(3812, 'Birmingham', 230),
(3813, 'Brechin', 230),
(3814, 'Bridgnorth', 230),
(3815, 'Bristol', 230),
(3816, 'Buckinghamshire', 230),
(3817, 'Cambridge', 230),
(3818, 'Cambridgeshire', 230),
(3819, 'Channel Islands', 230),
(3820, 'Cheshire', 230),
(3821, 'Cleveland', 230),
(3822, 'Co Fermanagh', 230),
(3823, 'Conwy', 230),
(3824, 'Cornwall', 230),
(3825, 'Coventry', 230),
(3826, 'Craven Arms', 230),
(3827, 'Cumbria', 230),
(3828, 'Denbighshire', 230),
(3829, 'Derby', 230),
(3830, 'Derbyshire', 230),
(3831, 'Devon', 230),
(3832, 'Dial Code Dungannon', 230),
(3833, 'Didcot', 230),
(3834, 'Dorset', 230),
(3835, 'Dunbartonshire', 230),
(3836, 'Durham', 230),
(3837, 'East Dunbartonshire', 230),
(3838, 'East Lothian', 230),
(3839, 'East Midlands', 230),
(3840, 'East Sussex', 230),
(3841, 'East Yorkshire', 230),
(3842, 'England', 230),
(3843, 'Essex', 230),
(3844, 'Fermanagh', 230),
(3845, 'Fife', 230),
(3846, 'Flintshire', 230),
(3847, 'Fulham', 230),
(3848, 'Gainsborough', 230),
(3849, 'Glocestershire', 230),
(3850, 'Gwent', 230),
(3851, 'Hampshire', 230),
(3852, 'Hants', 230),
(3853, 'Herefordshire', 230),
(3854, 'Hertfordshire', 230),
(3855, 'Ireland', 230),
(3856, 'Isle Of Man', 230),
(3857, 'Isle of Wight', 230),
(3858, 'Kenford', 230),
(3859, 'Kent', 230),
(3860, 'Kilmarnock', 230),
(3861, 'Lanarkshire', 230),
(3862, 'Lancashire', 230),
(3863, 'Leicestershire', 230),
(3864, 'Lincolnshire', 230),
(3865, 'Llanymynech', 230),
(3866, 'London', 230),
(3867, 'Ludlow', 230),
(3868, 'Manchester', 230),
(3869, 'Mayfair', 230),
(3870, 'Merseyside', 230),
(3871, 'Mid Glamorgan', 230),
(3872, 'Middlesex', 230),
(3873, 'Mildenhall', 230),
(3874, 'Monmouthshire', 230),
(3875, 'Newton Stewart', 230),
(3876, 'Norfolk', 230),
(3877, 'North Humberside', 230),
(3878, 'North Yorkshire', 230),
(3879, 'Northamptonshire', 230),
(3880, 'Northants', 230),
(3881, 'Northern Ireland', 230),
(3882, 'Northumberland', 230),
(3883, 'Nottinghamshire', 230),
(3884, 'Oxford', 230),
(3885, 'Powys', 230),
(3886, 'Roos-shire', 230),
(3887, 'SUSSEX', 230),
(3888, 'Sark', 230),
(3889, 'Scotland', 230),
(3890, 'Scottish Borders', 230),
(3891, 'Shropshire', 230),
(3892, 'Somerset', 230),
(3893, 'South Glamorgan', 230),
(3894, 'South Wales', 230),
(3895, 'South Yorkshire', 230),
(3896, 'Southwell', 230),
(3897, 'Staffordshire', 230),
(3898, 'Strabane', 230),
(3899, 'Suffolk', 230),
(3900, 'Surrey', 230),
(3901, 'Sussex', 230),
(3902, 'Twickenham', 230),
(3903, 'Tyne and Wear', 230),
(3904, 'Tyrone', 230),
(3905, 'Utah', 230),
(3906, 'Wales', 230),
(3907, 'Warwickshire', 230),
(3908, 'West Lothian', 230),
(3909, 'West Midlands', 230),
(3910, 'West Sussex', 230),
(3911, 'West Yorkshire', 230),
(3912, 'Whissendine', 230),
(3913, 'Wiltshire', 230),
(3914, 'Wokingham', 230),
(3915, 'Worcestershire', 230),
(3916, 'Wrexham', 230),
(3917, 'Wurttemberg', 230),
(3918, 'Yorkshire', 230),
(3919, 'Alabama', 231),
(3920, 'Alaska', 231),
(3921, 'Arizona', 231),
(3922, 'Arkansas', 231),
(3923, 'Byram', 231),
(3924, 'California', 231),
(3925, 'Cokato', 231),
(3926, 'Colorado', 231),
(3927, 'Connecticut', 231),
(3928, 'Delaware', 231),
(3929, 'District of Columbia', 231),
(3930, 'Florida', 231),
(3931, 'Georgia', 231),
(3932, 'Hawaii', 231),
(3933, 'Idaho', 231),
(3934, 'Illinois', 231),
(3935, 'Indiana', 231),
(3936, 'Iowa', 231),
(3937, 'Kansas', 231),
(3938, 'Kentucky', 231),
(3939, 'Louisiana', 231),
(3940, 'Lowa', 231),
(3941, 'Maine', 231),
(3942, 'Maryland', 231),
(3943, 'Massachusetts', 231),
(3944, 'Medfield', 231),
(3945, 'Michigan', 231),
(3946, 'Minnesota', 231),
(3947, 'Mississippi', 231),
(3948, 'Missouri', 231),
(3949, 'Montana', 231),
(3950, 'Nebraska', 231),
(3951, 'Nevada', 231),
(3952, 'New Hampshire', 231),
(3953, 'New Jersey', 231),
(3954, 'New Jersy', 231),
(3955, 'New Mexico', 231),
(3956, 'New York', 231),
(3957, 'North Carolina', 231),
(3958, 'North Dakota', 231),
(3959, 'Ohio', 231),
(3960, 'Oklahoma', 231),
(3961, 'Ontario', 231),
(3962, 'Oregon', 231),
(3963, 'Pennsylvania', 231),
(3964, 'Ramey', 231),
(3965, 'Rhode Island', 231),
(3966, 'South Carolina', 231),
(3967, 'South Dakota', 231),
(3968, 'Sublimity', 231),
(3969, 'Tennessee', 231),
(3970, 'Texas', 231),
(3971, 'Trimble', 231),
(3972, 'Utah', 231),
(3973, 'Vermont', 231),
(3974, 'Virginia', 231),
(3975, 'Washington', 231),
(3976, 'West Virginia', 231),
(3977, 'Wisconsin', 231),
(3978, 'Wyoming', 231),
(3979, 'United States Minor Outlying I', 232),
(3980, 'Artigas', 233),
(3981, 'Canelones', 233),
(3982, 'Cerro Largo', 233),
(3983, 'Colonia', 233),
(3984, 'Durazno', 233),
(3985, 'FLorida', 233),
(3986, 'Flores', 233),
(3987, 'Lavalleja', 233),
(3988, 'Maldonado', 233),
(3989, 'Montevideo', 233),
(3990, 'Paysandu', 233),
(3991, 'Rio Negro', 233),
(3992, 'Rivera', 233),
(3993, 'Rocha', 233),
(3994, 'Salto', 233),
(3995, 'San Jose', 233),
(3996, 'Soriano', 233),
(3997, 'Tacuarembo', 233),
(3998, 'Treinta y Tres', 233),
(3999, 'Andijon', 234),
(4000, 'Buhoro', 234),
(4001, 'Buxoro Viloyati', 234),
(4002, 'Cizah', 234),
(4003, 'Fargona', 234),
(4004, 'Horazm', 234),
(4005, 'Kaskadar', 234),
(4006, 'Korakalpogiston', 234),
(4007, 'Namangan', 234),
(4008, 'Navoi', 234),
(4009, 'Samarkand', 234),
(4010, 'Sirdare', 234),
(4011, 'Surhondar', 234),
(4012, 'Toskent', 234),
(4013, 'Malampa', 235),
(4014, 'Penama', 235),
(4015, 'Sanma', 235),
(4016, 'Shefa', 235),
(4017, 'Tafea', 235),
(4018, 'Torba', 235),
(4019, 'Vatican City State (Holy See)', 236),
(4020, 'Amazonas', 237),
(4021, 'Anzoategui', 237),
(4022, 'Apure', 237),
(4023, 'Aragua', 237),
(4024, 'Barinas', 237),
(4025, 'Bolivar', 237),
(4026, 'Carabobo', 237),
(4027, 'Cojedes', 237),
(4028, 'Delta Amacuro', 237),
(4029, 'Distrito Federal', 237),
(4030, 'Falcon', 237),
(4031, 'Guarico', 237),
(4032, 'Lara', 237),
(4033, 'Merida', 237),
(4034, 'Miranda', 237),
(4035, 'Monagas', 237),
(4036, 'Nueva Esparta', 237),
(4037, 'Portuguesa', 237),
(4038, 'Sucre', 237),
(4039, 'Tachira', 237),
(4040, 'Trujillo', 237),
(4041, 'Vargas', 237),
(4042, 'Yaracuy', 237),
(4043, 'Zulia', 237),
(4044, 'Bac Giang', 238),
(4045, 'Binh Dinh', 238),
(4046, 'Binh Duong', 238),
(4047, 'Da Nang', 238),
(4048, 'Dong Bang Song Cuu Long', 238),
(4049, 'Dong Bang Song Hong', 238),
(4050, 'Dong Nai', 238),
(4051, 'Dong Nam Bo', 238),
(4052, 'Duyen Hai Mien Trung', 238),
(4053, 'Hanoi', 238),
(4054, 'Hung Yen', 238),
(4055, 'Khu Bon Cu', 238),
(4056, 'Long An', 238),
(4057, 'Mien Nui Va Trung Du', 238),
(4058, 'Thai Nguyen', 238),
(4059, 'Thanh Pho Ho Chi Minh', 238),
(4060, 'Thu Do Ha Noi', 238),
(4061, 'Tinh Can Tho', 238),
(4062, 'Tinh Da Nang', 238),
(4063, 'Tinh Gia Lai', 238),
(4064, 'Anegada', 239),
(4065, 'Jost van Dyke', 239),
(4066, 'Tortola', 239),
(4067, 'Saint Croix', 240),
(4068, 'Saint John', 240),
(4069, 'Saint Thomas', 240),
(4070, 'Alo', 241),
(4071, 'Singave', 241),
(4072, 'Wallis', 241),
(4073, 'Bu Jaydur', 242),
(4074, 'Wad-adh-Dhahab', 242),
(4075, 'al-\'Ayun', 242),
(4076, 'as-Samarah', 242),
(4077, '\'Adan', 243),
(4078, 'Abyan', 243),
(4079, 'Dhamar', 243),
(4080, 'Hadramaut', 243),
(4081, 'Hajjah', 243),
(4082, 'Hudaydah', 243),
(4083, 'Ibb', 243),
(4084, 'Lahij', 243),
(4085, 'Ma\'rib', 243),
(4086, 'Madinat San\'a', 243),
(4087, 'Sa\'dah', 243),
(4088, 'Sana', 243),
(4089, 'Shabwah', 243),
(4090, 'Ta\'izz', 243),
(4091, 'al-Bayda', 243),
(4092, 'al-Hudaydah', 243),
(4093, 'al-Jawf', 243),
(4094, 'al-Mahrah', 243),
(4095, 'al-Mahwit', 243),
(4096, 'Central Serbia', 244),
(4097, 'Kosovo and Metohija', 244),
(4098, 'Montenegro', 244),
(4099, 'Republic of Serbia', 244),
(4100, 'Serbia', 244),
(4101, 'Vojvodina', 244),
(4102, 'Central', 245),
(4103, 'Copperbelt', 245),
(4104, 'Eastern', 245),
(4105, 'Luapala', 245),
(4106, 'Lusaka', 245),
(4107, 'North-Western', 245),
(4108, 'Northern', 245),
(4109, 'Southern', 245),
(4110, 'Western', 245),
(4111, 'Bulawayo', 246),
(4112, 'Harare', 246),
(4113, 'Manicaland', 246),
(4114, 'Mashonaland Central', 246),
(4115, 'Mashonaland East', 246),
(4116, 'Mashonaland West', 246),
(4117, 'Masvingo', 246),
(4118, 'Matabeleland North', 246),
(4119, 'Matabeleland South', 246),
(4120, 'Midlands', 246);

-- --------------------------------------------------------

--
-- Table structure for table `static_data`
--

CREATE TABLE `static_data` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(191) DEFAULT NULL,
  `label` varchar(191) DEFAULT NULL,
  `value` varchar(191) DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `static_data`
--

INSERT INTO `static_data` (`id`, `type`, `label`, `value`, `status`, `created_at`, `updated_at`) VALUES
(1, 'plan_type', 'Unlimited', 'unlimited', 1, '2022-04-21 16:23:03', '2022-04-21 16:23:03'),
(2, 'plan_type', 'Limited', 'limited', 1, '2022-04-21 16:23:03', '2022-04-21 16:23:03'),
(3, 'plan_limit_type', 'Service', 'service', 1, '2022-04-21 16:23:03', '2022-04-21 16:23:03'),
(4, 'plan_limit_type', 'Handyman', 'handyman', 1, '2022-04-21 16:23:03', '2022-04-21 16:23:03'),
(5, 'plan_limit_type', 'Featured Service', 'featured_service', 1, '2022-04-21 16:23:03', '2022-04-21 16:23:03');

-- --------------------------------------------------------

--
-- Table structure for table `storecategories`
--

CREATE TABLE `storecategories` (
  `id` int(11) NOT NULL,
  `sub_name` varchar(100) NOT NULL,
  `status` varchar(100) NOT NULL,
  `image` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `storecategories`
--

INSERT INTO `storecategories` (`id`, `sub_name`, `status`, `image`) VALUES
(70, 'Baby and Kids', '1', 'uploads/5591-5852.jpg'),
(71, 'Lighting', '1', 'uploads/6600-8816.jpg'),
(72, 'Salon and Spa', '1', 'uploads/9859-Alvaro (1).jpg'),
(79, 'Bathroom Storage & Organization', '1', 'uploads/7286-24\'\'+Solid+Wood+Rectangular+Adjustable+Folding+Table.webp');

-- --------------------------------------------------------

--
-- Table structure for table `storeproducts`
--

CREATE TABLE `storeproducts` (
  `id` int(11) NOT NULL,
  `subcatg` varchar(255) NOT NULL,
  `catg_sub` text NOT NULL,
  `reff_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `price` varchar(100) NOT NULL,
  `image` text NOT NULL,
  `description` text DEFAULT NULL,
  `status` int(11) NOT NULL,
  `worty` varchar(10) DEFAULT NULL,
  `related` varchar(255) NOT NULL,
  `test` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `storeproducts`
--

INSERT INTO `storeproducts` (`id`, `subcatg`, `catg_sub`, `reff_id`, `name`, `price`, `image`, `description`, `status`, `worty`, `related`, `test`) VALUES
(33, 'Salon and Barber chair', 'Salon and Spa', 32, 'Vegan Leather Salon Chair', '359', 'uploads/9080-Vegan+Leather+Salon+Chair.webp', 'Introducing the Vegan Leather Backwash Shampoo Station, designed to elevate the styling experience for both the stylist and client. Our shampoo station features a padded neckrest and a comfortable seating area that ensures the client\'s maximum relaxation during the shampooing process. The plastic shampoo bowl is wide and deep enough to prevent any water splashing or messes while providing the perfect angle for a thorough wash. Our Shampoo Station is easy to clean and maintain, with a sleek design that adds style and elegance to your salon. And it comes with anchoring bolts to be fixed on the ground if you want it to add more stability. Our shampoo station is a perfect choice for those looking for a little upgrade for either home or business salons!', 1, 'true', 'undefined', '[]'),
(34, 'Salon and Barber chair', 'Salon and Spa', 32, 'Upholstered Salon Chair', '589', 'uploads/4191-Upholstered+Salon+Chair.webp', 'New and in good condition. First-rate metal and leather materials ensure its good durability and comfort. Special treatment on handrails to protect you from falling down. It could sustain up to 150 kg weight. Widely applied in a salon, such as a hair salon.', 1, 'true', 'Vegan Leather Salon Chair', '[{\"id\":33,\"name\":\"Vegan Leather Salon Chair\"}]'),
(47, 'Salon and Barber chair', 'Salon and Spa', 32, 'Fixturedisplays® Washable Electric Hair Clipper Trimmer 15940', '70.94', 'uploads/4810-Hair Clipper.webp', 'Features:\r\n\r\nErgonomic and washable body design, make it easy to use and to clean.\r\n\r\nImported ceramic cutter, silver palladium alloy motor, nickel metal hydride environmental batteries, reduces charging time\r\n\r\nHelp your children and family trim their hair will be an unforgettable experience.\r\n\r\nBuy FixtureDisplays Hair Clipper to help reduce cost of hair cutting and increase family bonding.\r\n\r\nSpecification:Overall Width x Height x Depth: 7 x 0.8 x 2.4 inches;Voltage: 110V;\r\n\r\nPower: 3W;Charging Time: 8 hours;', 1, 'undefined', 'Vegan Leather Salon Chair,Upholstered Salon Chair', '[{\"id\":33,\"name\":\"Vegan Leather Salon Chair\"},{\"id\":34,\"name\":\"Upholstered Salon Chair\"}]'),
(48, 'Salon and Barber chair', 'Salon and Spa', 32, 'Charlain 5-in-1 Hair Dryer and Volumizer Hot Air Brush,Negative Ion Electric Dryer and Curling Iron', '111.99', 'uploads/5702-Hair Dryer.webp', 'The hot air brush dryer for women comes with fouth interchangeable brush attachments that make straightening, curling, volumizing, and scalp massage a breeze. Combining blow drying with styling brushes, can fit different hair lengths and create different styles. Our hot air hair straightener uses advanced negative ion technology and ceramic coating to prevent frizz and static. Thanks to the combination of nylon pin and tufted bristles, our hair dryer brush minimizes tangling and breakage along with helping provide comfortable scalp massages.\r\n\r\n\r\nFeatures:\r\n\r\nThis hair airbrush is lightweight making it easy to tote around anywhere and easy to manoeuvre which is great for your wrists. Let you create salon-worthy results.\r\n\r\nThis hair styler brush is suitable for families, business trips, weddings, and vacations to give you the freedom to style your hair the way you want! also allows you to use it as a gift for friends, family, or anyone else you love.\r\n\r\nThe hair dryer volumizer offers 2 temperature controls and 3-speed settings to give you more control when styling hair. It’s also perfect for use in different seasons for all hair types to help you easily get the hairstyle you’ve always wanted.\r\n\r\nThe hair volumizer styler brush can generate negative ions to condition your hair and nourish damaged hair. The electric blow dryer comb will reduce frizz and static to make your hair shiny and smooth.\r\n\r\nOur multi-functional hot air brush is a perfect combination of drying, straightening, curling, and volumizing. The oval-shaped brush with nylon pin and tufted bristles helps add volume to hair. The ergonomic handle and 360° swivel cord are designed for ease of use during styling. 4-in-1 one-step hair dryer brush for blow drying and hair styling easily creates volume in your hair. \r\n\r\nYou will own a mini hair salon of yourself at home, saving time and money.\r\n A hair dryer brush with double temperature protection and ceramic coating technologies can give constant temperature to prevent hurting your hair. \r\n\r\nThe curling dryer brush volumizer meets US standard safety requirements. Improved noise reduction design can give low noise to provide a comfortable using experience.\r\n\r\nThis is an American plug, not a dual-voltage single 110V.', 1, 'undefined', 'Vegan Leather Salon Chair,Upholstered Salon Chair,Fixturedisplays® Washable Electric Hair Clipper Trimmer 15940', '[{\"id\":33,\"name\":\"Vegan Leather Salon Chair\"},{\"id\":34,\"name\":\"Upholstered Salon Chair\"},{\"id\":47,\"name\":\"Fixturedisplays® Washable Electric Hair Clipper Trimmer 15940\"}]'),
(49, 'Salon and Barber chair', 'Salon and Spa', 32, 'Hair Straightener And Curler', '122.99', 'uploads/3367-Hair Straightener.webp', 'Upgraded 2-IN-1 Hair Styling Tool for straightening and curling hair.The hair flat iron with rounded shape deisgn allows you to create beachy wave, bouncy curls and straight tresses perfectly. Arganic Oil Tourmaline， Fast Heating and Temperature Adjustable Professional Hair Style Gift for Girls and Women Healthy\r\n\r\n\r\nFeatures\r\n\r\nHair Straightener and Curler 2 in 1\r\n\r\nThe rapid heat up\r\n\r\nThe temperature is adjustable in 6 grades\r\n\r\nSuitable size and weight.\r\n\r\nYou can rest assured to use it.\r\n\r\nMount Type: Freestanding\r\n\r\nDrawers Included: No\r\n\r\nCompartments: No\r\n\r\nComposite Wood Product (CWP): No\r\n\r\nPieces Included: Hair Styling Tool × 1 Cloth bag × 1\r\n\r\nNumber of Pieces Included: 2\r\n\r\nFinish: Black/Orange\r\n\r\nCommercial Warranty: Yes\r\n\r\nPrimary Material: Metal\r\n\r\nCountry of Origin - Additional Details: Made in USA of Imported Materials\r\n\r\nPlug-In: Yes\r\n\r\nCanada Product Restriction: No\r\n\r\nDS Metallic: Iron\r\n\r\nSupplier Intended and Approved Use: Residential Use\r\n\r\nUniform Packaging and Labeling Regulations (UPLR) Compliant: Yes\r\n\r\nLife Stage: Adult\r\n\r\nProduct Type: Hair Tool Holder', 1, 'undefined', 'Vegan Leather Salon Chair,Upholstered Salon Chair,Fixturedisplays® Washable Electric Hair Clipper Trimmer 15940,Charlain 5-in-1 Hair Dryer and Volumizer Hot Air Brush,Negative Ion Electric Dryer and Curling Iron', '[{\"id\":33,\"name\":\"Vegan Leather Salon Chair\"},{\"id\":34,\"name\":\"Upholstered Salon Chair\"},{\"id\":47,\"name\":\"Fixturedisplays® Washable Electric Hair Clipper Trimmer 15940\"},{\"id\":48,\"name\":\"Charlain 5-in-1 Hair Dryer and Volumizer Hot Air Brush,Negative Ion Electric Dryer and Curling Iron\"}]'),
(50, 'Salon and Barber chair', 'Salon and Spa', 32, 'Professional Stand Up Bonnet Hair Rolling Base', '146.99', 'uploads/2805-Professional+Stand+Up+Bonnet+Hair+Rolling+Base.webp', 'VIVOHOME Professional 1000W Adjustable Hooded Floor Hair DryerMULTIPLE FUNCTION & PREMIUM MATERIAL & CONSIDERATE DESIGN & SAFE AND SECURE & SIMPLE OPERATIONAre you still bothered by the old single-function hairdryer? The VIVOHOME professional 1000W stand hairdryer will have something exciting for you! This rolling hair dryer stand is a multifunctional machine with hair perm, caring, colouring, heating, drying, and hair setting, which reduces the damage to hair, and more hairstyle problems can be solved compared to the old dryer. It is easy to install and operate with many convenient design points, so you can use it whether by commercial or family.Made of high-quality stainless steel heat elements, advanced rotary backflow technique to ensure the using effect of the dryerWorking temperature can be set from 0-75℃, while the time can be set within 0-60 minutes, and please preheat 30-40 minutes before using the dryer It is designed with convenient height adjust knob, making sure you can easily operate the height of the dryer Suitable for multipurpose use no matter by commercial or family, it is a perfect machine for your hairstyle and easy to operate Convenient universal wheels in the bottom make sure you can move to any places and save you energy.\r\n\r\n\r\nFeatures:\r\n\r\nMULTIPLE FUNCTION - Equipped with a 1000W strong working capacity, this hooded floor hair dryer can meet different needs on hair, such as hair perm, caring, colouring, heating, drying and hair setting; It is suitable for multipurpose use no matter by commercial business or family, which is a perfect machine for your hairstyle.\r\n\r\nPREMIUM MATERIAL - Made of high quality stainless steel heat elements and plastic materials, it is not only pretty but also very durable to use; The fan blades are made with high-class components for smooth, whisper-quiet operation, you can even read books without being interrupted; In addition, there is no peculiar smell coming out when you are using the dryer.\r\n\r\nCONSIDERATE DESIGN - It is designed with unique rotary backflow technique, making sure to heat hair evenly in order to give hair a warm message in a healthy way; The function with adjustable height from 50 to 65 inches can be suitable for different furniture, like sofa and chair; The door on the hood can be opened with the hinge, which is easier for you to enter into the dryer.\r\n\r\nSAFE AND SECURE - The heat emission holes in the back are designed for heat dissipation, which keeps the dryer safe and increase its service life; The support column and the feet with wheels are connected tightly through the feet connection, and there is a long bolt under the feet connection in the bottom, both of which make the dryer more stable and will not move around while using.\r\n\r\nSIMPLE OPERATION - The convenient 2 knob switches with adjustable timer and temperature allow you to accurately set the time and temperature according to different hairstyles that you need; The package includes all the tools, hardware and instruction, which only costs 10 minutes for you to install; The power cord is 6.9ft long enough to move the dryer to different places that you prefer.', 1, 'undefined', 'Vegan Leather Salon Chair,Upholstered Salon Chair,Fixturedisplays® Washable Electric Hair Clipper Trimmer 15940,Charlain 5-in-1 Hair Dryer and Volumizer Hot Air Brush,Negative Ion Electric Dryer and Curling Iron,Hair Straightener And Curler', '[{\"id\":33,\"name\":\"Vegan Leather Salon Chair\"},{\"id\":34,\"name\":\"Upholstered Salon Chair\"},{\"id\":47,\"name\":\"Fixturedisplays® Washable Electric Hair Clipper Trimmer 15940\"},{\"id\":48,\"name\":\"Charlain 5-in-1 Hair Dryer and Volumizer Hot Air Brush,Negative Ion Electric Dryer and Curling Iron\"},{\"id\":49,\"name\":\"Hair Straightener And Curler\"}]'),
(51, 'Salon and Barber chair', 'Salon and Spa', 32, 'Standing Bonnet Hair Dryer With Wheels', '193.99', 'uploads/8490-Standing+Bonnet+Hair+Dryer+With+Wheels (1).webp', '1875W ionic hooded hair dryer with an on/off ionic generator switch and 3 temperature settings, cool, low heat, and high heat help you reach the best results and get your locks silky and glossy after drying. Our reliable standing hair dryer will help you create a perfect hairdo even without visiting the beauty salon. This professional salon hair dryer goes off when lifting the shield, saving energy and preventing accidents when the hair dryer bonnet is not in use.\r\n\r\n\r\nFeatures:\r\n\r\nRolling base for easy movement\r\n\r\nHeight-adjustable tube with clips for an 80” cord\r\n\r\nMultifunctional use for hair drying, hair modelling, hair colouring, hair conditioning, hair treatment, hot perm, spot-caring\r\n\r\nTransparent face shield with lift-for-auto-off switch\r\n\r\nFeatures a removable airflow vent and a filterable air intake grill\r\n\r\nThe ionic power button on the side of the bonnet for easy control', 1, 'undefined', 'undefined', '[]'),
(52, 'Salon and Barber chair', 'Salon and Spa', 32, 'Cristobal Cosmetic Makeup Case Salon Tool Organizer Travel Bag', '214.99', 'uploads/4509-CRISTOBAL COSMETIC CASE.webp', 'This is a newly-designed cosmetic case for carrying the make-up while going out. This beautifully designed makeup organizer comes with fashionable style, elegant colour, and is easily transportable. It is perfect for beauty professionals, students, and hair stylists, as well as for personal use. Besides, this cosmetic case is made of high-quality material, solid and durable in use. So it can be used to hold the make-up tool or cosmetics, such as cosmetic makeup sponges, powder puffs, brushes, and so on.\r\nFeatures\r\nThe unique design of the grip handle makes you comfortable\r\nWith 3 in 1 design, this makeup case is nice to look and easy to use\r\n360 degrees rotate rolling', 1, 'undefined', 'undefined', '[]'),
(53, 'Salon and Barber chair', 'Salon and Spa', 32, 'Aricca Portable Barber Carrying Case Travel Carrying Storage Holder Organizer Cage Box', '125.99', 'uploads/6937-Aricca+Portable+Barber+Carrying+CASE.jpg', 'Portable travel carries display and storage organizer for barber totes, perfect for organizing clippers, trimmers, blades, shears, combs, brushes, and other styling tools. The product has a large capacity to hold 4 different sizes of electric clippers, 8 different sizes of scissors, and 5 different sizes of combs. With a fixed machine position, easy to use, sturdy, and durable. With a password, portable and comfortable.\r\n\r\nFeatures:\r\n\r\nMultifunctional - small boxes can be placed, combs, scissors, clips, hair clippers, water bottles, etc. Large can be used to place hair dryers, electric heaters, etc.\r\n\r\nLarge capacity - can accommodate 4 different sizes of electric scissors, can accommodate 8 different sizes of scissors. Inside can hold fans, electric rods, combs, clothes, and other items, and can hold 5 different sizes of combs.\r\n\r\nHigh quality - High-quality hairdressing toolbox with high-quality leather and exquisite workmanship.\r\n\r\nMetal corner design - thick iron nail reinforcement, so that the box is not deformed, is strong, and is durable. A double password buckle design can better protect the safety of the box\'s contents.\r\n\r\nReasonable design - With a fixed machine position, put the electric shears in, fixed firmly, no longer worry. The initial password is 000, the load-bearing handle is ergonomically designed, portable and comfortable.\r\n\r\nPassword Setting - First, enter the initial password 000; second, press the unlock button on the luggage and do not let go; then, turn the password dial for the password number you want to set. Note: Each number can be set individually.', 1, 'undefined', 'undefined', '[]'),
(54, 'Salon and Barber chair', 'Salon and Spa', 32, 'Aul Portable Barber Stylist Suitcase Travel Carrying Display Case', '109.81', 'uploads/7802-Aul+Portable+Barber+Stylist+Suitcase+Travel+Carrying+Display+Kase.webp', 'This is a portable barber stylist suitcase that you can use to take your tools with you to work at any time. The product has a large capacity, which can accommodate 4 different sizes of electric scissors and 8 different sizes of scissors. Hair dryers, curling irons, combs, and other items can be placed inside, and 5 combs of different sizes can be placed to solve your problem of storage difficulties.\r\n\r\nFeatures:\r\n\r\nPortable travel carrying display and storage organizer attached case for barber stylists. Great to organize clippers, trimmers, blades, shears, combs, brushes, and other styling tools.\r\n\r\nFix the machine position, put the electric clippers in, and fix it firmly, no longer worry about it. The initial password is 000, and the load-bearing handle is ergonomically designed, portable, and comfortable.\r\n\r\nMetal corner design and thick nail reinforcement ensure the box does not deform. The sturdy double password buckle design can better protect the safety of the items inside the box.', 1, 'undefined', 'undefined', '[]'),
(55, 'Salon and Barber chair', 'Salon and Spa', 32, 'Jaxun Barber Tool Case', '115.99', 'uploads/1612-JAXUN - Barber+Tool+Case.webp', 'This portable travel carry display and storage organizer briefcase is perfect for hair stylists. The simple and stylish design looks very premium, and it is made of high-quality materials and is durable. The internal structure is reasonably designed, and the hairdressing tools can be arranged in an orderly manner.\r\n\r\nFeatures:\r\n\r\nHIGH QUALITY MATERIALS: Premium aluminum finish and construction, reinforced steel corners for extra durability, beautiful smooth black finish.\r\n\r\nDESIGN WITH LOCK: The professional barber organizer comes with a 3-digit security number lock to personalize your security lock and protect your belongings. (initial password 000)\r\n\r\nEASY TO CLEAN: The product is made of high-quality materials, with a smooth, wear-resistant surface that is easy to clean.', 1, 'undefined', 'undefined', '[]');

-- --------------------------------------------------------

--
-- Table structure for table `storesubcatgms`
--

CREATE TABLE `storesubcatgms` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `image` text NOT NULL,
  `services` varchar(100) NOT NULL,
  `reff_id` int(11) NOT NULL,
  `featured` varchar(10) DEFAULT NULL,
  `status` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `storesubcatgms`
--

INSERT INTO `storesubcatgms` (`id`, `name`, `image`, `services`, `reff_id`, `featured`, `status`) VALUES
(32, 'Salon and Barber chair', 'uploads/5855-1239.jpg', 'Salon and Spa', 72, 'false', '1'),
(33, 'Shampoo Bowls', 'uploads/8373-Women beauty3 (1).jpg', 'Salon and Spa', 72, 'true', '1'),
(34, 'Massage tables', 'uploads/5337-24\'\'+Solid+Wood+Rectangular+Adjustable+Folding+Table.webp', 'Salon and Spa', 72, 'false', '1'),
(35, 'Towel warmer', 'uploads/6407-Wall+Mount+Electric+Towel+Warmer.webp', 'Salon and Spa', 72, 'true', '1'),
(36, 'Utility carts', 'uploads/8691-33.8\'\'+H+x+16.5\'\'+W+Utility+Cart+with+Wheels.webp', 'Salon and Spa', 72, 'false', '1'),
(37, 'Salon stations', 'uploads/1536-Hair salon1.jpg', 'Salon and Spa', 72, 'true', '1'),
(47, 'Beauty Organizers', 'uploads/1780-19036.jpg', 'Bathroom Storage & Organization', 79, 'false', '1'),
(49, 'Lights', 'uploads/9803-LIGHTS.jpeg', 'Lighting', 71, 'false', '1');

-- --------------------------------------------------------

--
-- Table structure for table `subscription_transactions`
--

CREATE TABLE `subscription_transactions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `subscription_plan_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_id` bigint(20) DEFAULT NULL,
  `amount` double DEFAULT NULL,
  `payment_type` varchar(100) NOT NULL,
  `txn_id` varchar(100) DEFAULT NULL,
  `payment_status` varchar(20) DEFAULT NULL COMMENT 'pending, paid , failed',
  `other_transaction_detail` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `taxes`
--

CREATE TABLE `taxes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT '1' COMMENT 'fixed , percent',
  `value` double DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1 COMMENT '1- Active , 0- InActive',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `taxes`
--

INSERT INTO `taxes` (`id`, `title`, `type`, `value`, `status`, `created_at`, `updated_at`) VALUES
(1, 'GST/HST', 'percent', 5, 1, '2022-05-31 16:16:13', '2022-09-05 15:54:24'),
(2, 'PST/RST/QST', 'percent', 9.975, 1, '2022-05-31 16:16:25', '2022-09-05 15:54:38');

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `id` int(11) NOT NULL,
  `tx_id` varchar(200) NOT NULL,
  `tx_status` varchar(100) NOT NULL,
  `tx_date` varchar(30) NOT NULL,
  `userid` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `username` varchar(191) NOT NULL,
  `stripe_customer_id` varchar(191) DEFAULT NULL,
  `user_device_token` longtext DEFAULT NULL,
  `first_name` varchar(191) DEFAULT NULL,
  `last_name` varchar(191) DEFAULT NULL,
  `full_name` varchar(500) DEFAULT NULL,
  `email` varchar(191) DEFAULT NULL,
  `user_image` varchar(200) DEFAULT NULL,
  `is_email_verified` tinyint(4) NOT NULL DEFAULT 1,
  `is_mobile_verified` tinyint(4) NOT NULL DEFAULT 0,
  `country_code` varchar(5) DEFAULT NULL,
  `mobile` varchar(10) DEFAULT NULL,
  `password` varchar(191) DEFAULT NULL,
  `user_type` varchar(255) DEFAULT NULL,
  `role_id` bigint(20) UNSIGNED DEFAULT NULL,
  `contact_number` varchar(255) DEFAULT NULL,
  `country_id` bigint(20) UNSIGNED DEFAULT NULL,
  `state_id` bigint(20) UNSIGNED DEFAULT NULL,
  `city_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_city` varchar(255) DEFAULT NULL,
  `work_type` varchar(500) DEFAULT NULL COMMENT 'provider type(like electrcian or builder)',
  `address` text DEFAULT NULL,
  `status` tinyint(4) DEFAULT 1,
  `onboarding_step_status` enum('basic_registration_complete','bank_complete','aadhar_complete','pan_complete','sin_complete','completed') NOT NULL DEFAULT 'basic_registration_complete',
  `display_name` varchar(191) DEFAULT NULL,
  `time_zone` varchar(191) NOT NULL DEFAULT 'UTC',
  `last_notification_seen` timestamp NULL DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `lat` text DEFAULT NULL,
  `lng` text DEFAULT NULL,
  `driver_location_geohash` varchar(50) DEFAULT NULL,
  `handymantype_id` bigint(20) UNSIGNED DEFAULT NULL,
  `uid` varchar(191) DEFAULT NULL,
  `service_address_id` bigint(20) UNSIGNED DEFAULT NULL,
  `login_type` varchar(191) DEFAULT NULL,
  `provider_status` enum('online','offline') NOT NULL DEFAULT 'online',
  `provider_offline_reason` text DEFAULT NULL,
  `password_reset_otp` varchar(6) DEFAULT NULL,
  `email_otp` varchar(6) DEFAULT NULL,
  `email_otp_sent_on` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `stripe_customer_id`, `user_device_token`, `first_name`, `last_name`, `full_name`, `email`, `user_image`, `is_email_verified`, `is_mobile_verified`, `country_code`, `mobile`, `password`, `user_type`, `role_id`, `contact_number`, `country_id`, `state_id`, `city_id`, `user_city`, `work_type`, `address`, `status`, `onboarding_step_status`, `display_name`, `time_zone`, `last_notification_seen`, `email_verified_at`, `remember_token`, `lat`, `lng`, `driver_location_geohash`, `handymantype_id`, `uid`, `service_address_id`, `login_type`, `provider_status`, `provider_offline_reason`, `password_reset_otp`, `email_otp`, `email_otp_sent_on`, `created_at`, `updated_at`, `deleted_at`) VALUES
(236, 'user_652f60a6f0971', NULL, NULL, 'Dev', 'Pal', 'Joy Kumar Bera', 'admin@gmail.com', NULL, 0, 0, NULL, '9875614352', '$2y$10$8vAaxGuxLswdzGyw9I7ZrOGCcekxIToQuXyomf6L2xeD/w4VvXoPm', 'admin', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', '2023-12-11 16:10:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, '', NULL, NULL, '2023-12-11 16:10:58', NULL),
(405, 'user_657d66ecc1920', 'cus_PCIJFpuMHhaX0G', NULL, NULL, NULL, 'Prithick', 'prithick@mail.com', NULL, 1, 0, '+1', '8120842044', '$2y$10$5NRqwWzmTM4VuBn7kG.N1O1TMJR5UvRCO3bqFyU/RONP8ARa6uRMC', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(407, 'user_657d68d32262b', 'cus_PCIR6WHCj5PBLd', 'debjoOveQVu8l8I4uhG0lI:APA91bG0rjMyu2iOKFg3uctgWCgBL2wUh-YIqx8wUSaFaEu5-oh83hMCMPI_BDM3uLaA8mqwjatbfrOE_9zuMHNRFVQN3w5Lf2tZstDnnZIHISeyobRerUzneSTQvkmnHHDHYcnyWxNZ', NULL, NULL, 'Test User', 'test@mail.com', NULL, 1, 0, '+1', '8525254625', '$2y$10$seMmccQedGuX/CdQ43hDkeBmsFmH9pzARBLwZJGWDlhNYwt5j8Wiq', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(408, 'provider_657d692306d25', NULL, 'eNAv6E_IT4617O4jkirJ8g:APA91bE4Suiy8UtiLMgnJl3snlTLWCOKUnO0g7faZBhUWlnbyK9fRyvAzlZP3e0NbNm7bf9yQoZG-6uu4vVIz4y6wgnWhg_B7UzH8HFQl5Iv3LyVIGPBjzxPK8EESxunbwwhsD64NWPX', NULL, NULL, 'Nilesh Kumar', 'nileshkumar@gmail.com', NULL, 1, 0, NULL, '7903792110', '$2y$10$iX9fP7aSXvCMxAa8f/9Imed29zfu0ShGq77M5ED0xU8OjWowXpS4G', 'provider', 4, NULL, NULL, NULL, NULL, 'Surat', 'hair spa', NULL, 1, 'completed', NULL, 'UTC', NULL, NULL, NULL, '20.3256', '66.3596', 't7x5wh1t4', NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, '2023-12-20 17:07:38', NULL),
(409, 'user_657daee2ec340', 'cus_PCNGbXY0KTDDVr', NULL, NULL, NULL, 'sc', 'schattaraj200@gmail.com', NULL, 1, 0, '+91', '9475839825', '$2y$10$hgiONhnbNvS303ZFg22dTuh7gsj3hLhX2wm7D1yYUe4eGJWivTMua', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(410, 'user_657de3f169734', 'cus_PCQu9D2dmEXcos', NULL, NULL, NULL, 'Abhiraj', 'abhi@mail.com', NULL, 1, 0, '+1', '7676656545', '$2y$10$AzPpmHgg2qVyHYD42w7M5ejB2uWPVdlxQI3Ve5ixNWikvU/w46qAC', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(411, 'user_657df022b7ec6', 'cus_PCRkdE74fR3Wov', NULL, NULL, NULL, 'Nilesh K', 'nilesh@mail.com', '6590865739a4f_LLTK7rDn6.jpeg', 1, 0, '+1', '7676674647', '$2y$10$CKMA9sX/b/tXc1cjigHx5.do6zxPwBLDuu9bXbyLCEmzE5ruuDnby', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(413, 'user_6581c99538f85', 'cus_PDXZMHLTP7GNHX', NULL, NULL, NULL, 'Amol', 'amol@mail.com', NULL, 1, 0, '+1', '9668882346', '$2y$10$l.e8CnEgc0M6106yaghnO.OxuM4TUJ9CLQfyPAT5szw2/KvGA6E4u', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(414, 'user_6582eb76e1551', 'cus_PDrV1GKXVqY5kd', NULL, NULL, NULL, 'Pravin Patel', 'pravinpatle1699@gmail.com', NULL, 1, 0, '+91', '7498143684', '$2y$10$kKckHUcH.2w1tpO6VisjHu.8Z3mM7rfUWn7.IPQsZlVLSfpJ.Ca5O', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, '355629', NULL, NULL, NULL, NULL, NULL),
(415, 'user_658475aa1c975', 'cus_PEIdDkbPPV99GP', NULL, NULL, NULL, 'Test', 'test@maild.com', NULL, 1, 0, '+1', '9673734646', '$2y$10$AD00eXc8lTrU38dN/sMNreqJeo6lMGqHmNSm/sVdUlAVuvpIhBPLe', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(416, 'provider_6586f50a6872d', NULL, NULL, NULL, NULL, 'Pravin Patel', 'patlepravin08@gmail.com', NULL, 1, 0, NULL, '7507707693', '$2y$10$zk2WkifB.P8wansGqEHaC.MO/eVSF8EvVek7vt.wDvbmFWyi8bwVK', 'provider', 4, NULL, NULL, NULL, NULL, 'nagpur', 'hair spa', NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(417, 'provider_6586f5f520a50', NULL, NULL, NULL, NULL, 'Pravin Patel', 'patlepravin@gmail.com', NULL, 1, 0, NULL, '9230989432', '$2y$10$vYgtj6N.82rpN.crjvat5OJ1BHcTPYNqhaOn8K6OMMOVfjWo2tn.u', 'provider', 4, NULL, NULL, NULL, NULL, 'nagpur', 'hair spa', NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(418, 'user_658c793d346bf', 'cus_PGZptg6oxxupn9', NULL, NULL, NULL, 'Sirajuddin shaik', 's.sirajuddin92@hotmail.com', NULL, 1, 0, '+91', '8074249742', '$2y$10$QfsVSXazoGtsW5ebANsM1eFM6lvDv8U0vHHOoJKZuJjqpWzYFSYIy', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, '123456', '2023-12-27 19:21:34', NULL, NULL, NULL),
(419, 'user_658c7aa81a459', 'cus_PGZvk2jv0MiCyp', NULL, NULL, NULL, 'Siraj', 's.sirajuddin92@hotmqil.com', NULL, 1, 0, '+91', '8074249712', '$2y$10$hFuk/DGZCJObHCVCn0DAXePrhyQWGF9sRjbLKriBIrY5DxoNsNpUa', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, '123456', '2023-12-27 19:27:36', NULL, NULL, NULL),
(420, 'user_658c7c22edbdf', 'cus_PGa1wsQ4DOhAit', NULL, NULL, NULL, 'Nilesh', 'nileshkumar5896@gmail.com', NULL, 1, 0, '+1', '7764973378', '$2y$10$pz9agWsMUqqMz7MopxPCvOseDdz0Eo3Gw7/lI5ZRYxKfnTV4zhUo6', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, '123456', '2023-12-27 19:33:55', NULL, NULL, NULL),
(421, 'user_658c7dbe89348', 'cus_PGa8aRbglK3m1m', NULL, NULL, NULL, 'Tester', 'tester@mail.com', NULL, 1, 0, '+1', '8525885424', '$2y$10$nW3zDJKxU2aPLQXz7UkcpOKF0gOmYZpyRnpKiKaeYgY02jOngLDwO', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(422, 'user_6592f4260b90c', 'cus_PIPzU9N7smf51R', NULL, NULL, NULL, 'test123', 'pravinpatle74@gmail.com', NULL, 1, 0, '+91', '7767878897', '$2y$10$D7etWtMAAcNOI6X/Vs1pNexa466b7AL8H4vCjt8xPMLF98tfaJwxi', 'user', 3, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'basic_registration_complete', NULL, 'UTC', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'online', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_address`
--

CREATE TABLE `user_address` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `apartment` varchar(500) DEFAULT NULL,
  `company_name` varchar(500) DEFAULT NULL,
  `country_name` varchar(20) NOT NULL,
  `street_address` text NOT NULL,
  `city` varchar(100) NOT NULL,
  `province` varchar(100) NOT NULL,
  `zip_code` varchar(6) NOT NULL,
  `country_code` varchar(5) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `email` varchar(255) NOT NULL,
  `additional_information` text DEFAULT NULL,
  `locality` varchar(500) DEFAULT NULL,
  `landmark` text DEFAULT NULL,
  `landmark_type` enum('home','others') NOT NULL DEFAULT 'home',
  `is_defualt` tinyint(4) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_address`
--

INSERT INTO `user_address` (`id`, `user_id`, `first_name`, `last_name`, `apartment`, `company_name`, `country_name`, `street_address`, `city`, `province`, `zip_code`, `country_code`, `phone`, `email`, `additional_information`, `locality`, `landmark`, `landmark_type`, `is_defualt`, `created_at`, `updated_at`) VALUES
(64, 405, 'Prithick', 'Sam', NULL, NULL, 'India', '104, Mkd Street', 'Kolkata', 'West Bengal', '767656', '+1', '8120842044', 'prithick@mail.com', NULL, 'MKd', 'Mkd', 'home', 0, '2023-12-16 09:01:29', '2023-12-16 09:01:29'),
(65, 407, 'Test', 'User', 'Test', NULL, 'India', 'Test', 'Test', 'Assam', '252458', '+1', '8525254625', 'test@mail.com', NULL, 'Test', 'Test', 'home', 0, '2023-12-16 09:08:55', '2023-12-16 09:08:55'),
(66, 410, 'Abhiraj', 'Kumar', 'Ujjaini', NULL, 'India', '108', 'Bangalore', 'Karnataka', '343543', '+1', '7676656545', 'abhi@mail.com', NULL, 'Laxminarayan', 'Ujjaini', 'home', 0, '2023-12-16 17:55:15', '2023-12-16 17:55:15'),
(67, 411, 'Nilesh', 'Kumar', 'Ujjaini', NULL, 'India', '108', 'Bangalore', 'Karnataka', '878887', '+1', '7676674647', 'nilesh@mail.com', NULL, 'Ujjaini', 'Ujjaini', 'home', 0, '2023-12-16 18:47:08', '2023-12-16 18:47:08'),
(69, 413, 'Amol', 'Test', 'Test', NULL, 'India', 'Test', 'Test', 'West Bengal', '394964', '+1', '9668882346', 'amol@mail.com', NULL, 'Test', 'Test', 'home', 0, '2023-12-19 16:51:42', '2023-12-19 16:51:42'),
(70, 414, 'Pravin', 'Patel', 'Test', NULL, 'India', 'test capital GJHGJahu', 'Gondia', 'Maharashtra', '441601', '+91', '7498143684', 'pravinpatle1699@gmail.com', NULL, 'Gondia', 'gyhhh', 'home', 0, '2023-12-23 14:15:26', '2023-12-23 14:15:26'),
(71, 420, 'Nilesh', 'Surat', NULL, NULL, 'India', 'Vnnh', 'Surat', 'Gujarat', '395007', '+1', '7764973378', 'nileshkumar5896@gmail.com', NULL, 'Surat', 'Nmn', 'home', 0, '2023-12-27 19:46:27', '2023-12-27 19:46:27'),
(72, 407, 'Test', 'User', NULL, NULL, 'India', 'Abc', 'Surat', 'Haryana', '9669', '+1', '8525254625', 'test@mail.com', NULL, 'Kolk', 'Abc', 'home', 0, '2023-12-30 04:03:53', '2023-12-30 04:03:53'),
(73, 422, 'Test', 'Testman', NULL, 'Testing', 'India', 'test test test', 'Test Test Test', 'Western Province', '441614', '+1', '7498143684', 'pravinpatle74@gmail.com', 'test', NULL, NULL, 'home', 0, '2024-01-01 17:47:21', '2024-01-01 17:47:21');

-- --------------------------------------------------------

--
-- Table structure for table `user_favourite_services`
--

CREATE TABLE `user_favourite_services` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `service_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `app_settings`
--
ALTER TABLE `app_settings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `bookings_provider_id_foreign` (`provider_id`),
  ADD KEY `bookings_customer_id_foreign` (`customer_id`),
  ADD KEY `bookings_service_id_foreign` (`service_id`),
  ADD KEY `bookings_booking_address_id_foreign` (`booking_address_id`);

--
-- Indexes for table `booking_activities`
--
ALTER TABLE `booking_activities`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `booking_address_mappings`
--
ALTER TABLE `booking_address_mappings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_address_mappings_booking_id_foreign` (`booking_id`);

--
-- Indexes for table `booking_coupon_mappings`
--
ALTER TABLE `booking_coupon_mappings`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `booking_handyman_mappings`
--
ALTER TABLE `booking_handyman_mappings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_handyman_mappings_booking_id_foreign` (`booking_id`),
  ADD KEY `booking_handyman_mappings_handyman_id_foreign` (`handyman_id`);

--
-- Indexes for table `booking_ratings`
--
ALTER TABLE `booking_ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `booking_ratings_service_id_foreign` (`service_id`),
  ADD KEY `booking_ratings_booking_id_foreign` (`booking_id`);

--
-- Indexes for table `booking_statuses`
--
ALTER TABLE `booking_statuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `cities`
--
ALTER TABLE `cities`
  ADD PRIMARY KEY (`id`);

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
-- Indexes for table `coupon_service_mappings`
--
ALTER TABLE `coupon_service_mappings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `coupon_service_mappings_coupon_id_foreign` (`coupon_id`),
  ADD KEY `coupon_service_mappings_service_id_foreign` (`service_id`);

--
-- Indexes for table `documents`
--
ALTER TABLE `documents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `getmap`
--
ALTER TABLE `getmap`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `handyman_payouts`
--
ALTER TABLE `handyman_payouts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `handyman_payouts_handyman_id_foreign` (`handyman_id`);

--
-- Indexes for table `handyman_ratings`
--
ALTER TABLE `handyman_ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `handyman_ratings_handyman_id_foreign` (`handyman_id`),
  ADD KEY `handyman_ratings_customer_id_foreign` (`customer_id`),
  ADD KEY `handyman_ratings_service_id_foreign` (`service_id`),
  ADD KEY `handyman_ratings_booking_id_foreign` (`booking_id`);

--
-- Indexes for table `handyman_types`
--
ALTER TABLE `handyman_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jv_bookings`
--
ALTER TABLE `jv_bookings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_uniq_order_id` (`uniq_order_id`),
  ADD KEY `fk_customer_id_jv_orders` (`customer_id`),
  ADD KEY `fk_provider_id_jv_bookings` (`provider_id`);

--
-- Indexes for table `jv_booking_items`
--
ALTER TABLE `jv_booking_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_order_id_jv_booking_items` (`order_id`);

--
-- Indexes for table `jv_booking_reject_history`
--
ALTER TABLE `jv_booking_reject_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_id_jv_booking_reject_history` (`user_id`),
  ADD KEY `fk_order_id_jv_booking_reject_history` (`order_id`);

--
-- Indexes for table `jv_contact`
--
ALTER TABLE `jv_contact`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jv_customer_cart`
--
ALTER TABLE `jv_customer_cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_uniq_cart_id` (`uniq_cart_id`),
  ADD KEY `fk_customer_id_jv_customer_cart` (`customer_id`);

--
-- Indexes for table `jv_customer_cart_items`
--
ALTER TABLE `jv_customer_cart_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cart_id_jv_customer_cart_items` (`cart_id`);

--
-- Indexes for table `jv_customer_cart_service_items`
--
ALTER TABLE `jv_customer_cart_service_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cart_id_jv_customer_cart_service_items` (`cart_id`),
  ADD KEY `fk_service_id_jv_customer_cart_service_items` (`service_id`);

--
-- Indexes for table `jv_orders`
--
ALTER TABLE `jv_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_uniq_order_id` (`uniq_order_id`),
  ADD KEY `fk_customer_id_jv_orders` (`customer_id`);

--
-- Indexes for table `jv_order_items`
--
ALTER TABLE `jv_order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_order_id_jv_order_items` (`order_id`);

--
-- Indexes for table `jv_product`
--
ALTER TABLE `jv_product`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_sku_jv_product` (`sku`),
  ADD KEY `fk_category_id_jv_product` (`category_id`);

--
-- Indexes for table `jv_product_category`
--
ALTER TABLE `jv_product_category`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_parent_id_jv_product_category` (`parent_id`);

--
-- Indexes for table `jv_product_gallery`
--
ALTER TABLE `jv_product_gallery`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_product_id_jv_product_gallery` (`product_id`);

--
-- Indexes for table `jv_product_price`
--
ALTER TABLE `jv_product_price`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_produt_id_jv_product_price` (`product_id`);

--
-- Indexes for table `jv_product_ratings`
--
ALTER TABLE `jv_product_ratings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_product_id_jv_product_ratings` (`product_id`),
  ADD KEY `fk_customer_id_jv_product_ratings` (`customer_id`);

--
-- Indexes for table `jv_product_tax`
--
ALTER TABLE `jv_product_tax`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_product_id_jv_product_tax` (`product_id`);

--
-- Indexes for table `jv_provider_slots`
--
ALTER TABLE `jv_provider_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_provider_id` (`provider_id`);

--
-- Indexes for table `jv_provider_slot_items`
--
ALTER TABLE `jv_provider_slot_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_slot_time` (`slot_id`,`slot_time`);

--
-- Indexes for table `jv_services`
--
ALTER TABLE `jv_services`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jv_service_categories`
--
ALTER TABLE `jv_service_categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ser_type_id_jv_service_categories` (`ser_type_id`);

--
-- Indexes for table `jv_service_slots`
--
ALTER TABLE `jv_service_slots`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_service_id_jv_service_slots` (`service_id`);

--
-- Indexes for table `jv_service_subcategories`
--
ALTER TABLE `jv_service_subcategories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sub_categories_category_id_foreign` (`category_id`);

--
-- Indexes for table `jv_service_types`
--
ALTER TABLE `jv_service_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jv_wishlist`
--
ALTER TABLE `jv_wishlist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `media_uuid_unique` (`uuid`),
  ADD KEY `media_model_type_model_id_index` (`model_type`,`model_id`);

--
-- Indexes for table `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

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
  ADD KEY `payments_customer_id_foreign` (`customer_id`),
  ADD KEY `payments_booking_id_foreign` (`booking_id`);

--
-- Indexes for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Indexes for table `phone_verifications`
--
ALTER TABLE `phone_verifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `plans`
--
ALTER TABLE `plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `plan_limits`
--
ALTER TABLE `plan_limits`
  ADD PRIMARY KEY (`id`),
  ADD KEY `plan_limits_plan_id_foreign` (`plan_id`);

--
-- Indexes for table `provider_address_mappings`
--
ALTER TABLE `provider_address_mappings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `provider_address_mappings_provider_id_foreign` (`provider_id`);

--
-- Indexes for table `provider_bank_accounts`
--
ALTER TABLE `provider_bank_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_id_provider_bank_accounts` (`user_id`);

--
-- Indexes for table `provider_documents`
--
ALTER TABLE `provider_documents`
  ADD PRIMARY KEY (`id`),
  ADD KEY `provider_documents_provider_id_foreign` (`provider_id`),
  ADD KEY `provider_documents_document_id_foreign` (`document_id`);

--
-- Indexes for table `provider_payouts`
--
ALTER TABLE `provider_payouts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `provider_payouts_provider_id_foreign` (`provider_id`);

--
-- Indexes for table `provider_service_address_mappings`
--
ALTER TABLE `provider_service_address_mappings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `provider_service_address_mappings_service_id_foreign` (`service_id`),
  ADD KEY `provider_service_address_mappings_provider_address_id_foreign` (`provider_address_id`);

--
-- Indexes for table `provider_subscriptions`
--
ALTER TABLE `provider_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `provider_subscriptions_plan_id_foreign` (`plan_id`);

--
-- Indexes for table `provider_taxes`
--
ALTER TABLE `provider_taxes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `provider_taxes_provider_id_foreign` (`provider_id`);

--
-- Indexes for table `provider_types`
--
ALTER TABLE `provider_types`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Indexes for table `service_faqs`
--
ALTER TABLE `service_faqs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `service_faqs_service_id_foreign` (`service_id`);

--
-- Indexes for table `service_proofs`
--
ALTER TABLE `service_proofs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `service_proofs_service_id_foreign` (`service_id`),
  ADD KEY `service_proofs_booking_id_foreign` (`booking_id`),
  ADD KEY `service_proofs_user_id_foreign` (`user_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `settings_key_index` (`key`);

--
-- Indexes for table `sliders`
--
ALTER TABLE `sliders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `states`
--
ALTER TABLE `states`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `static_data`
--
ALTER TABLE `static_data`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `storecategories`
--
ALTER TABLE `storecategories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `storeproducts`
--
ALTER TABLE `storeproducts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `storesubcatgms`
--
ALTER TABLE `storesubcatgms`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subscription_transactions`
--
ALTER TABLE `subscription_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subscription_transactions_subscription_plan_id_foreign` (`subscription_plan_id`);

--
-- Indexes for table `taxes`
--
ALTER TABLE `taxes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_username_unique` (`username`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_service_address_id_foreign` (`service_address_id`),
  ADD KEY `fk_role_id_users` (`role_id`);

--
-- Indexes for table `user_address`
--
ALTER TABLE `user_address`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_user_id_user_address` (`user_id`);

--
-- Indexes for table `user_favourite_services`
--
ALTER TABLE `user_favourite_services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_favourite_services_service_id_foreign` (`service_id`),
  ADD KEY `user_favourite_services_user_id_foreign` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `app_settings`
--
ALTER TABLE `app_settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT for table `booking_activities`
--
ALTER TABLE `booking_activities`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=86;

--
-- AUTO_INCREMENT for table `booking_address_mappings`
--
ALTER TABLE `booking_address_mappings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_coupon_mappings`
--
ALTER TABLE `booking_coupon_mappings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_handyman_mappings`
--
ALTER TABLE `booking_handyman_mappings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `booking_ratings`
--
ALTER TABLE `booking_ratings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `booking_statuses`
--
ALTER TABLE `booking_statuses`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `cities`
--
ALTER TABLE `cities`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `countries`
--
ALTER TABLE `countries`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=247;

--
-- AUTO_INCREMENT for table `coupons`
--
ALTER TABLE `coupons`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `coupon_service_mappings`
--
ALTER TABLE `coupon_service_mappings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `documents`
--
ALTER TABLE `documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `getmap`
--
ALTER TABLE `getmap`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `handyman_payouts`
--
ALTER TABLE `handyman_payouts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `handyman_ratings`
--
ALTER TABLE `handyman_ratings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `handyman_types`
--
ALTER TABLE `handyman_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `jv_bookings`
--
ALTER TABLE `jv_bookings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=105;

--
-- AUTO_INCREMENT for table `jv_booking_items`
--
ALTER TABLE `jv_booking_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=127;

--
-- AUTO_INCREMENT for table `jv_booking_reject_history`
--
ALTER TABLE `jv_booking_reject_history`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `jv_contact`
--
ALTER TABLE `jv_contact`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `jv_customer_cart`
--
ALTER TABLE `jv_customer_cart`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=148;

--
-- AUTO_INCREMENT for table `jv_customer_cart_items`
--
ALTER TABLE `jv_customer_cart_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=131;

--
-- AUTO_INCREMENT for table `jv_customer_cart_service_items`
--
ALTER TABLE `jv_customer_cart_service_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=165;

--
-- AUTO_INCREMENT for table `jv_orders`
--
ALTER TABLE `jv_orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT for table `jv_order_items`
--
ALTER TABLE `jv_order_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=62;

--
-- AUTO_INCREMENT for table `jv_product`
--
ALTER TABLE `jv_product`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `jv_product_category`
--
ALTER TABLE `jv_product_category`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `jv_product_gallery`
--
ALTER TABLE `jv_product_gallery`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `jv_product_price`
--
ALTER TABLE `jv_product_price`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `jv_product_ratings`
--
ALTER TABLE `jv_product_ratings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jv_product_tax`
--
ALTER TABLE `jv_product_tax`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jv_provider_slots`
--
ALTER TABLE `jv_provider_slots`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=428;

--
-- AUTO_INCREMENT for table `jv_provider_slot_items`
--
ALTER TABLE `jv_provider_slot_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `jv_services`
--
ALTER TABLE `jv_services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=104;

--
-- AUTO_INCREMENT for table `jv_service_categories`
--
ALTER TABLE `jv_service_categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `jv_service_slots`
--
ALTER TABLE `jv_service_slots`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `jv_service_subcategories`
--
ALTER TABLE `jv_service_subcategories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `jv_service_types`
--
ALTER TABLE `jv_service_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `jv_wishlist`
--
ALTER TABLE `jv_wishlist`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `media`
--
ALTER TABLE `media`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;

--
-- AUTO_INCREMENT for table `menus`
--
ALTER TABLE `menus`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `payment_gateways`
--
ALTER TABLE `payment_gateways`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=87;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=530;

--
-- AUTO_INCREMENT for table `phone_verifications`
--
ALTER TABLE `phone_verifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `plans`
--
ALTER TABLE `plans`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `plan_limits`
--
ALTER TABLE `plan_limits`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `provider_address_mappings`
--
ALTER TABLE `provider_address_mappings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `provider_bank_accounts`
--
ALTER TABLE `provider_bank_accounts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `provider_documents`
--
ALTER TABLE `provider_documents`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- AUTO_INCREMENT for table `provider_payouts`
--
ALTER TABLE `provider_payouts`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `provider_service_address_mappings`
--
ALTER TABLE `provider_service_address_mappings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `provider_subscriptions`
--
ALTER TABLE `provider_subscriptions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `provider_taxes`
--
ALTER TABLE `provider_taxes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `provider_types`
--
ALTER TABLE `provider_types`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `service_faqs`
--
ALTER TABLE `service_faqs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `service_proofs`
--
ALTER TABLE `service_proofs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `sliders`
--
ALTER TABLE `sliders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `states`
--
ALTER TABLE `states`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4121;

--
-- AUTO_INCREMENT for table `static_data`
--
ALTER TABLE `static_data`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `storecategories`
--
ALTER TABLE `storecategories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `storeproducts`
--
ALTER TABLE `storeproducts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `storesubcatgms`
--
ALTER TABLE `storesubcatgms`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=50;

--
-- AUTO_INCREMENT for table `subscription_transactions`
--
ALTER TABLE `subscription_transactions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `taxes`
--
ALTER TABLE `taxes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=423;

--
-- AUTO_INCREMENT for table `user_address`
--
ALTER TABLE `user_address`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT for table `user_favourite_services`
--
ALTER TABLE `user_favourite_services`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_booking_address_id_foreign` FOREIGN KEY (`booking_address_id`) REFERENCES `provider_address_mappings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_provider_id_foreign` FOREIGN KEY (`provider_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_address_mappings`
--
ALTER TABLE `booking_address_mappings`
  ADD CONSTRAINT `booking_address_mappings_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_handyman_mappings`
--
ALTER TABLE `booking_handyman_mappings`
  ADD CONSTRAINT `booking_handyman_mappings_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_handyman_mappings_handyman_id_foreign` FOREIGN KEY (`handyman_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `booking_ratings`
--
ALTER TABLE `booking_ratings`
  ADD CONSTRAINT `booking_ratings_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `booking_ratings_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `coupon_service_mappings`
--
ALTER TABLE `coupon_service_mappings`
  ADD CONSTRAINT `coupon_service_mappings_coupon_id_foreign` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `coupon_service_mappings_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `handyman_payouts`
--
ALTER TABLE `handyman_payouts`
  ADD CONSTRAINT `handyman_payouts_handyman_id_foreign` FOREIGN KEY (`handyman_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `handyman_ratings`
--
ALTER TABLE `handyman_ratings`
  ADD CONSTRAINT `handyman_ratings_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `handyman_ratings_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `handyman_ratings_handyman_id_foreign` FOREIGN KEY (`handyman_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `handyman_ratings_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_bookings`
--
ALTER TABLE `jv_bookings`
  ADD CONSTRAINT `fk_provider_id_jv_bookings` FOREIGN KEY (`provider_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_booking_items`
--
ALTER TABLE `jv_booking_items`
  ADD CONSTRAINT `fk_order_id_jv_booking_items` FOREIGN KEY (`order_id`) REFERENCES `jv_bookings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_booking_reject_history`
--
ALTER TABLE `jv_booking_reject_history`
  ADD CONSTRAINT `fk_order_id_jv_booking_reject_history` FOREIGN KEY (`order_id`) REFERENCES `jv_bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user_id_jv_booking_reject_history` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_customer_cart`
--
ALTER TABLE `jv_customer_cart`
  ADD CONSTRAINT `fk_customer_id_jv_customer_cart` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_customer_cart_items`
--
ALTER TABLE `jv_customer_cart_items`
  ADD CONSTRAINT `fk_cart_id_jv_customer_cart_items` FOREIGN KEY (`cart_id`) REFERENCES `jv_customer_cart` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_customer_cart_service_items`
--
ALTER TABLE `jv_customer_cart_service_items`
  ADD CONSTRAINT `fk_cart_id_jv_customer_cart_service_items` FOREIGN KEY (`cart_id`) REFERENCES `jv_customer_cart` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_service_id_jv_customer_cart_service_items` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_orders`
--
ALTER TABLE `jv_orders`
  ADD CONSTRAINT `fk_customer_id_jv_orders` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `jv_order_items`
--
ALTER TABLE `jv_order_items`
  ADD CONSTRAINT `fk_order_id_jv_order_items` FOREIGN KEY (`order_id`) REFERENCES `jv_orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_product`
--
ALTER TABLE `jv_product`
  ADD CONSTRAINT `fk_category_id_jv_product` FOREIGN KEY (`category_id`) REFERENCES `jv_product_category` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `jv_product_category`
--
ALTER TABLE `jv_product_category`
  ADD CONSTRAINT `fk_parent_id_jv_product_category` FOREIGN KEY (`parent_id`) REFERENCES `jv_product_category` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `jv_product_gallery`
--
ALTER TABLE `jv_product_gallery`
  ADD CONSTRAINT `fk_product_id_jv_product_gallery` FOREIGN KEY (`product_id`) REFERENCES `jv_product` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_product_price`
--
ALTER TABLE `jv_product_price`
  ADD CONSTRAINT `fk_produt_id_jv_product_price` FOREIGN KEY (`product_id`) REFERENCES `jv_product` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_product_ratings`
--
ALTER TABLE `jv_product_ratings`
  ADD CONSTRAINT `fk_customer_id_jv_product_ratings` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_product_id_jv_product_ratings` FOREIGN KEY (`product_id`) REFERENCES `jv_product` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_product_tax`
--
ALTER TABLE `jv_product_tax`
  ADD CONSTRAINT `fk_product_id_jv_product_tax` FOREIGN KEY (`product_id`) REFERENCES `jv_product` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_provider_slots`
--
ALTER TABLE `jv_provider_slots`
  ADD CONSTRAINT `fk_provider_id` FOREIGN KEY (`provider_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_provider_slot_items`
--
ALTER TABLE `jv_provider_slot_items`
  ADD CONSTRAINT `fk_slot_id_jv_provider_slot_items` FOREIGN KEY (`slot_id`) REFERENCES `jv_provider_slots` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_service_categories`
--
ALTER TABLE `jv_service_categories`
  ADD CONSTRAINT `fk_ser_type_id_jv_service_categories` FOREIGN KEY (`ser_type_id`) REFERENCES `jv_service_types` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `jv_service_slots`
--
ALTER TABLE `jv_service_slots`
  ADD CONSTRAINT `fk_service_id_jv_service_slots` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jv_service_subcategories`
--
ALTER TABLE `jv_service_subcategories`
  ADD CONSTRAINT `sub_categories_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `jv_service_categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `payments_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `plan_limits`
--
ALTER TABLE `plan_limits`
  ADD CONSTRAINT `plan_limits_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `provider_address_mappings`
--
ALTER TABLE `provider_address_mappings`
  ADD CONSTRAINT `provider_address_mappings_provider_id_foreign` FOREIGN KEY (`provider_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `provider_bank_accounts`
--
ALTER TABLE `provider_bank_accounts`
  ADD CONSTRAINT `fk_user_id_provider_bank_accounts` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `provider_documents`
--
ALTER TABLE `provider_documents`
  ADD CONSTRAINT `provider_documents_document_id_foreign` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `provider_documents_provider_id_foreign` FOREIGN KEY (`provider_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `provider_payouts`
--
ALTER TABLE `provider_payouts`
  ADD CONSTRAINT `provider_payouts_provider_id_foreign` FOREIGN KEY (`provider_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `provider_service_address_mappings`
--
ALTER TABLE `provider_service_address_mappings`
  ADD CONSTRAINT `provider_service_address_mappings_provider_address_id_foreign` FOREIGN KEY (`provider_address_id`) REFERENCES `provider_address_mappings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `provider_service_address_mappings_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `provider_subscriptions`
--
ALTER TABLE `provider_subscriptions`
  ADD CONSTRAINT `provider_subscriptions_plan_id_foreign` FOREIGN KEY (`plan_id`) REFERENCES `plans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `provider_taxes`
--
ALTER TABLE `provider_taxes`
  ADD CONSTRAINT `provider_taxes_provider_id_foreign` FOREIGN KEY (`provider_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `service_faqs`
--
ALTER TABLE `service_faqs`
  ADD CONSTRAINT `service_faqs_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `service_proofs`
--
ALTER TABLE `service_proofs`
  ADD CONSTRAINT `service_proofs_booking_id_foreign` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `service_proofs_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `service_proofs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subscription_transactions`
--
ALTER TABLE `subscription_transactions`
  ADD CONSTRAINT `subscription_transactions_subscription_plan_id_foreign` FOREIGN KEY (`subscription_plan_id`) REFERENCES `provider_subscriptions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_role_id_users` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `users_service_address_id_foreign` FOREIGN KEY (`service_address_id`) REFERENCES `provider_address_mappings` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_address`
--
ALTER TABLE `user_address`
  ADD CONSTRAINT `fk_user_id_user_address` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_favourite_services`
--
ALTER TABLE `user_favourite_services`
  ADD CONSTRAINT `user_favourite_services_service_id_foreign` FOREIGN KEY (`service_id`) REFERENCES `jv_services` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_favourite_services_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;