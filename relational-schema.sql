CREATE DATABASE AuctionSite;
USE AuctionSite;


CREATE TABLE User (
	`uuid` INT PRIMARY KEY AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL,
    `pass_hash` int NOT NULL,
    `email_address` VARCHAR(60) NOT NULL,
    `push` BOOLEAN NOT NULL
);

CREATE TABLE Email (
	`email_id` INT PRIMARY KEY AUTO_INCREMENT,
    `subject` VARCHAR(100),
    `content` TEXT,
    `timestamp` DATETIME NOT NULL,
    `from` VARCHAR(60) NOT NULL REFERENCES User(`email_address`)
);

CREATE TABLE Email_To (											-- TODO: Email must have at least 1 Email_To associated with it but we havent learned how to do this yet
	`email_id` INT PRIMARY KEY REFERENCES Email(`email_id`),
    `to` VARCHAR(60) NOT NULL REFERENCES User(`email_address`)
);

CREATE TABLE Token (
	`token_id` INT PRIMARY KEY,
    `expiry` DATETIME NOT NULL,
    `user` INT NOT NULL REFERENCES User(`uuid`)
);

CREATE TABLE End_User (
	`uuid` INT PRIMARY KEY REFERENCES User(`uuid`),
	`num_sold` INT DEFAULT 0,
    `num_bought` INT DEFAULT 0
);

CREATE TABLE CR (
	`uuid` INT PRIMARY KEY REFERENCES User(`uuid`)
);

CREATE TABLE Admin (
	`uuid` INT PRIMARY KEY REFERENCES User(`uuid`)
);

CREATE TABLE Help_Category (
	`category` VARCHAR(30) PRIMARY KEY
);

CREATE TABLE Help_Ticket (
	`ticket_id` INT PRIMARY KEY AUTO_INCREMENT,
    `status` ENUM('unassigned', 'assigned', 'completed') NOT NULL,
    `title` VARCHAR(100),
    `content` TEXT,													-- TODO content should also be able to store pictures
    `category` VARCHAR(30) NOT NULL REFERENCES Help_Category(`category`),
    `submitted_by` INT NOT NULL REFERENCES End_User(`uuid`)
);

CREATE TABLE Ticket_Assigned_To (
	`ticket` INT REFERENCES Help_Ticket(`ticket_id`),
    `assigned_to` INT REFERENCES CR(`uuid`),
    PRIMARY KEY (`ticket`, `assigned_to`)
);


