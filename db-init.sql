/* 336 Project Relational Schema
  Cullin Poresky, Ethan Murad, Urvish Patel */

CREATE DATABASE IF NOT EXISTS AuctionSite;
USE AuctionSite;

DROP TABLE IF EXISTS `User`;
DROP TABLE IF EXISTS Authentication;
DROP TABLE IF EXISTS Email;
DROP TABLE IF EXISTS Email_To;
DROP TABLE IF EXISTS Email_Attachment;
DROP TABLE IF EXISTS Token;
DROP TABLE IF EXISTS End_User;
DROP TABLE IF EXISTS Alert;
DROP TABLE IF EXISTS Alert_Keyword;
DROP TABLE IF EXISTS Customer_Rep;
DROP TABLE IF EXISTS `Admin`;
DROP TABLE IF EXISTS Help_Category;
DROP TABLE IF EXISTS Help_Ticket;
DROP TABLE IF EXISTS Ticket_Attachment;
DROP TABLE IF EXISTS Bid;
DROP TABLE IF EXISTS Auction;
DROP TABLE IF EXISTS Item;
DROP TABLE IF EXISTS Gpu;
DROP TABLE IF EXISTS Screen;
DROP TABLE IF EXISTS Cpu;
DROP TABLE IF EXISTS Ram;
DROP TABLE IF EXISTS Keyword;
DROP TABLE IF EXISTS Kw_Screen_Res;
DROP TABLE IF EXISTS Kw_Screen_Model;
DROP TABLE IF EXISTS Kw_Screen_Type;
DROP TABLE IF EXISTS Kw_Screen_Size;
DROP TABLE IF EXISTS Kw_Screen_Brand;
DROP TABLE IF EXISTS Kw_Cpu_Brand;
DROP TABLE IF EXISTS Kw_Cpu_Size;
DROP TABLE IF EXISTS Kw_Cpu_Model;
DROP TABLE IF EXISTS Kw_Cpu_Vram_Type;
DROP TABLE IF EXISTS Kw_Cpu_Core_Count;
DROP TABLE IF EXISTS Kw_Cpu_Clock_Speed;
DROP TABLE IF EXISTS Kw_Gpu_Brand;
DROP TABLE IF EXISTS Kw_Gpu_Model;
DROP TABLE IF EXISTS Kw_Gpu_Vram_Type;
DROP TABLE IF EXISTS Kw_Gpu_Vram_Amount;
DROP TABLE IF EXISTS Kw_Ram_Clock_Speed;
DROP TABLE IF EXISTS Kw_Ram_Size;
DROP TABLE IF EXISTS Kw_Ram_Type;
DROP TABLE IF EXISTS Kw_Hdd_Size;
DROP TABLE IF EXISTS Kw_Hdd_Speed;
DROP TABLE IF EXISTS Kw_Battery_Life;
DROP TABLE IF EXISTS Kw_Ssd_Size;
DROP TABLE IF EXISTS Kw_Item_Model;
DROP TABLE IF EXISTS Kw_Item_Mfr;
DROP TABLE IF EXISTS Kw_Item_Length;
DROP TABLE IF EXISTS Kw_Item_Width;
DROP TABLE IF EXISTS Kw_Item_Height;
DROP TABLE IF EXISTS Kw_Item_Weight;




CREATE TABLE `User` (
  `uuid` BINARY(16) PRIMARY KEY,
  `username` VARCHAR(30) UNIQUE NOT NULL,
  `email_address` VARCHAR(60) UNIQUE NOT NULL,
  `push` BOOLEAN NOT NULL DEFAULT 1
);

CREATE TABLE Authentication (
  `uuid` BINARY(16) PRIMARY KEY REFERENCES `User`(uuid),
  `pass_hash` VARCHAR(50) NOT NULL,
  `salt` VARCHAR(50) NOT NULL
);

CREATE TABLE Email (
  `email_id` INT PRIMARY KEY AUTO_INCREMENT,
  `subject` VARCHAR(100),
  `content` TEXT,
  `timestamp` DATETIME NOT NULL,
  `from` VARCHAR(60) NOT NULL REFERENCES `User`(`email_address`),
  `to` VARCHAR(60) NOT NULL REFERENCES `User`(`email_address`) -- primary recipient
);

CREATE TABLE Email_To ( -- all recipients 
  `email_id` INT PRIMARY KEY REFERENCES Email(`email_id`),
  `to` VARCHAR(60) NOT NULL REFERENCES `User`(`email_address`)
);

CREATE TABLE Email_Attachment (
  `attachment_id` INT PRIMARY KEY AUTO_INCREMENT,
  `email_id` INT NOT NULL REFERENCES Email(email_id),
  `attachment` BLOB NOT NULL
);

CREATE TABLE Token (
  `token_id` INT PRIMARY KEY,
  `expiry` DATETIME NOT NULL,
  `user` BINARY(16) NOT NULL REFERENCES `User`(`uuid`)
);

CREATE TABLE End_User (
  `uuid` BINARY(16) PRIMARY KEY REFERENCES `User`(`uuid`),
  `num_sold` INT DEFAULT 0,
  `num_bought` INT DEFAULT 0
);

CREATE TABLE Alert (
  `alert_id` INT PRIMARY KEY AUTO_INCREMENT,
  `alert_for` BINARY(16) NOT NULL REFERENCES `User`(`uuid`),
  `active` BOOLEAN NOT NULL
);

CREATE TABLE Alert_Keyword (
  `keyword_id` INT REFERENCES Keyword(`keyword_id`),
  `alert_id` INT REFERENCES Alert(`alert_id`),
  PRIMARY KEY (`keyword_id`, `alert_id`)
);

CREATE TABLE Customer_Rep (
   `uuid` BINARY(16) PRIMARY KEY REFERENCES `User`(`uuid`)
);

CREATE TABLE `Admin` (
  `uuid` BINARY(16) PRIMARY KEY REFERENCES `User`(`uuid`)
);

CREATE TABLE Help_Category (
  `category` VARCHAR(30) PRIMARY KEY
);

CREATE TABLE Help_Ticket (
  `ticket_id` INT PRIMARY KEY AUTO_INCREMENT,
  `status` ENUM('unassigned', 'assigned', 'resolved_closed', 'inactive_closed') NOT NULL,
  `title` VARCHAR(100),
  `content` TEXT NOT NULL,
  `category` VARCHAR(30) NOT NULL REFERENCES Help_Category(`category`),
  `created` DATETIME NOT NULL,
  `last_updated` DATETIME NOT NULL,
  `submitted_by` BINARY(16) NOT NULL REFERENCES End_User(`uuid`),
  `assigned_to` BINARY(16) REFERENCES Customer_Rep(`uuid`)
);

CREATE TABLE Ticket_Attachment (
  `attachment_id` INT PRIMARY KEY AUTO_INCREMENT,
  `ticket_id` INT NOT NULL REFERENCES Help_Ticket(ticket_id),
  `attachment` BLOB NOT NULL
);

CREATE TABLE Bid (
  `bid_id` INT PRIMARY KEY AUTO_INCREMENT,
  `timestamp` DATETIME NOT NULL,
  `amount` INT NOT NULL,
  `user` BINARY(16) NOT NULL REFERENCES `User`(`uuid`),
  `auction` INT NOT NULL REFERENCES Auction(`auction_id`)
);

CREATE TABLE Auction (
  `auction_id` INT PRIMARY KEY AUTO_INCREMENT,
  `begin_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `bid_increment` INT NOT NULL,
  `minimum_price` INT,
  `description` TEXT NOT NULL,
  `start_price` INT NOT NULL,
  `title` VARCHAR(100) NOT NULL,
  `picture` BLOB,
  `seller` BINARY(16) NOT NULL REFERENCES End_User(`uuid`),
  `item_id` INT NOT NULL REFERENCES Item(`item_id`),
  `top_bid_id` INT REFERENCES Bid(`bid_id`),
  `finished` BOOLEAN NOT NULL,
  `buyer` BINARY(16) REFERENCES End_User(`uuid`)
);

CREATE TABLE Item (
  `item_id` INT PRIMARY KEY AUTO_INCREMENT,
  `length` INT REFERENCES Kw_Item_Length(`keyword_id`),
  `width` INT REFERENCES Kw_Item_Width(`keyword_id`),
  `height` INT REFERENCES Kw_Item_Height(`keyword_id`),
  `mfr` INT REFERENCES Kw_Item_Mfr(`keyword_id`),
  `weight` INT REFERENCES Kw_Item_Weight(`keyword_id`),
  `item_model` INT REFERENCES Kw_Item_Model(`keyword_id`),
  `battery_life` INT REFERENCES Kw_Battery_Life(`keyword_id`),
  `ssd_size` INT REFERENCES Kw_Ssd_Size(`keyword_id`),
  `hdd_size` INT REFERENCES Kw_Hdd_Size(`keyword_id`),
  `hdd_speed` INT REFERENCES Kw_Hdd_Speed(`keyword_id`)
);

CREATE TABLE Gpu (
  `gpu_id` INT PRIMARY KEY AUTO_INCREMENT,
  `item_id` INT NOT NULL REFERENCES Item(`item_id`),
  `gpu_brand` INT NOT NULL REFERENCES Kw_Gpu_Brand(`keyword_id`),
  `gpu_model` INT NOT NULL REFERENCES Kw_Gpu_Model(`keyword_id`),
  `gpu_vram_type` INT NOT NULL REFERENCES Kw_Gpu_Vram_Type(`keyword_id`),
  `gpu_vram_amount` INT NOT NULL REFERENCES Kw_Gpu_Vram_Amount(`keyword_id`)
);

CREATE TABLE Screen (
  `screen_id` INT PRIMARY KEY AUTO_INCREMENT,
  `item_id` INT NOT NULL REFERENCES Item(`item_id`),
  `screen_res` INT NOT NULL REFERENCES Kw_Screen_Res(`keyword_id`),
  `screen_model` INT REFERENCES Kw_Screen_Model(`keyword_id`),
  `screen_type` INT REFERENCES Kw_Screen_Type(`keyword_id`),
  `screen_brand` INT REFERENCES Kw_Screen_Brand(`keyword_id`),
  `screen_size` INT REFERENCES Kw_Screen_Size(`keyword_id`)
);

CREATE TABLE Cpu (
  `cpu_id` INT PRIMARY KEY AUTO_INCREMENT,
  `item_id` INT NOT NULL REFERENCES Item(`item_id`),
  `cpu_brand` INT NOT NULL REFERENCES Kw_Cpu_Brand(`keyword_id`),
  `cpu_size` INT REFERENCES Kw_Cpu_Size(`keyword_id`),
  `cpu_model` INT NOT NULL REFERENCES Kw_Cpu_Model(`keyword_id`),
  `cpu_vram_type` INT REFERENCES Kw_Cpu_Vram_Type(`keyword_id`),
  `cpu_core_count` INT REFERENCES Kw_Cpu_Core_Count(`keyword_id`),
  `cpu_clock_speed` INT REFERENCES Kw_Cpu_Clock_Speed(`keyword_id`)
);

CREATE TABLE Ram (
  `ram_id` INT PRIMARY KEY AUTO_INCREMENT,
  `item_id` INT NOT NULL REFERENCES Item(`item_id`),
  `ram_clock_speed` INT REFERENCES Kw_Ram_Clock_Speed(`keyword_id`),
  `ram_size` INT NOT NULL REFERENCES Kw_Ram_Size(`keyword_id`),
  `ram_type` INT NOT NULL REFERENCES Kw_Ram_Type(`keyword_id`)
);

CREATE TABLE Keyword (
  `keyword_id` INT PRIMARY KEY AUTO_INCREMENT,
  `keyword` VARCHAR(80)
);

CREATE TABLE Kw_Screen_Res (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Screen_Model (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Screen_Type (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Screen_Size (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Screen_Brand (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Cpu_Brand (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Cpu_Size (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Cpu_Model (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Cpu_Vram_Type (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Cpu_Core_Count (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Cpu_Clock_Speed (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Gpu_Brand (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Gpu_Model (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Gpu_Vram_Type (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Gpu_Vram_Amount (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Ram_Clock_Speed (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Ram_Size (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Ram_Type (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Hdd_Size (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Hdd_Speed (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Battery_Life (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Ssd_Size (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Item_Model (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Item_Mfr (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Item_Length (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Item_Width (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Item_Height (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);

CREATE TABLE Kw_Item_Weight (
  `keyword_id` INT PRIMARY KEY REFERENCES Keyword(`keyword_id`)
);