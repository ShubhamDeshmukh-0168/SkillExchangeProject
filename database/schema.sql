-- SkillExchangeProject - MySQL schema (Amazon RDS for MySQL)
-- Run this once against your RDS database before starting the app.
-- Column order/names here match exactly what the DAO classes expect
-- (DatabaseDAO/RegistrationDAO, LoginDAO, FetchAllUsersDAO, UpdateUserProfileDao, etc.)

CREATE DATABASE IF NOT EXISTS skillexchange;
USE skillexchange;

CREATE TABLE skillexchangeusers (
    firstname     VARCHAR(50)   NOT NULL,
    lastname      VARCHAR(50),
    username      VARCHAR(50)   PRIMARY KEY,
    password      VARCHAR(100)  NOT NULL,
    email         VARCHAR(100),
    phonenumber   BIGINT,
    skilltoteach  VARCHAR(200),
    skilltolearn  VARCHAR(200),
    rating        INT           DEFAULT 0,
    profilepic    LONGBLOB
);
