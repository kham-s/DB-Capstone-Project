-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDM
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDM
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDM` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDM` ;

-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Customers` (
  `CustomerID` INT NOT NULL,
  `FirstName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Staffs`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Staffs` (
  `StaffId` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Role` VARCHAR(45) NULL,
  PRIMARY KEY (`StaffId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Bookings` (
  `BookingID` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  `StaffID` INT NOT NULL,
  `TableNo` INT NULL,
  `BookingSlot` TIME NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `CustomerID_idx` (`CustomerID` ASC) VISIBLE,
  INDEX `StaffID_idx` (`StaffID` ASC) VISIBLE,
  CONSTRAINT `CustomerID`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemonDM`.`Customers` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `StaffID`
    FOREIGN KEY (`StaffID`)
    REFERENCES `LittleLemonDM`.`Staffs` (`StaffId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`MenuItems`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`MenuItems` (
  `ItemID` INT NOT NULL,
  `Name` VARCHAR(45) NULL,
  `Price` DECIMAL(10,2) NULL,
  PRIMARY KEY (`ItemID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDM`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDM`.`Orders` (
  `BookingID` INT NOT NULL,
  `ItemID` INT NOT NULL,
  `Quantity` INT NULL,
  `BillAmount` DECIMAL(10,2) NULL,
  `DeliveryStatus` VARCHAR(45) NULL,
  PRIMARY KEY (`BookingID`, `ItemID`),
  INDEX `BookingID_idx` (`BookingID` ASC) VISIBLE,
  INDEX `ItemID_idx` (`ItemID` ASC) VISIBLE,
  CONSTRAINT `BookingID`
    FOREIGN KEY (`BookingID`)
    REFERENCES `LittleLemonDM`.`Bookings` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `ItemID`
    FOREIGN KEY (`ItemID`)
    REFERENCES `LittleLemonDM`.`MenuItems` (`ItemID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
