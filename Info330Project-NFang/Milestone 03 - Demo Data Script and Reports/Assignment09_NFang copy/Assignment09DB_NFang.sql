--**********************************************************************************************--
-- Title: Assigment09 - Final Milestone 03
-- Author: NFang
-- Desc: Fills database by importing sample data and creates sample views
-- Change Log: When,Who,What
-- 03/10/2020, NFang, Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment09DB_NFang')
	 Begin 
	  Alter Database [Assignment09DB_NFang] set Single_user With Rollback Immediate;
	  Drop Database Assignment09DB_NFang;
	 End
	Create Database Assignment09DB_NFang;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment09DB_NFang;

--Code From Assignment08/Milestone02
--Database creation code

-- Create clinics table with inputted data types and configurations
Create Table Clinics
 ([ClinicID] [int] IDENTITY(1,1) NOT NULL
  ,[ClinicName] [NVARCHAR](100) NOT NULL
  ,[ClinicPhoneNumber] [NVARCHAR](100) NOT NULL
  ,[ClinicAddress] [NVARCHAR](100) NOT NULL
  ,[ClinicCity] [NVARCHAR](100) NOT NULL
  ,[ClinicState] [NVARCHAR](2) NOT NULL
  ,[ClinicZipCode] [NVARCHAR](10) NOT NULL
 )

-- Add constraints to the clinics table
ALTER TABLE Clinics
  ADD CONSTRAINT pkClinics
    PRIMARY KEY (ClinicID);
GO

ALTER TABLE Clinics
  ADD CONSTRAINT ukClinics
    Unique (ClinicName);
GO

ALTER TABLE Clinics
  ADD CONSTRAINT ckClinics
    CHECK (ClinicPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    CHECK (ClinicZipCode like '[0-9][0-9][0-9][0-9][0-9]' or 
           ClinicZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
GO

-- Create patients table with inputted data types and configurations
CREATE TABLE Patients
 ([PatientID] [int] IDENTITY(1,1) NOT NULL
  ,[PatientFirstName] [NVARCHAR](100) NOT NULL
  ,[PatientLastName] [NVARCHAR](100) NOT NULL
  ,[PatientPhoneNumber] [NVARCHAR](100) NOT NULL
  ,[PatientAddress] [NVARCHAR](100) NOT NULL
  ,[PatientCity] [NVARCHAR](100) NOT NULL
  ,[PatientState] [NVARCHAR](2) NOT NULL
  ,[PatientZipCode] [NVARCHAR](10) NOT NULL
 )

-- Add constraints to the clinics table
ALTER TABLE Patients
  ADD CONSTRAINT pkPatients
    PRIMARY KEY (PatientID);
GO

ALTER TABLE Patients
  ADD CONSTRAINT ckPatients
    CHECK (PatientPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    CHECK (PatientZipCode like '[0-9][0-9][0-9][0-9][0-9]' or 
           PatientZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
GO

-- Create doctors table with inputted data types and configurations
CREATE TABLE Doctors
 ([DoctorID] [int] IDENTITY(1,1) NOT NULL
  ,[DoctorFirstName] [NVARCHAR](100) NOT NULL
  ,[DoctorLastName] [NVARCHAR](100) NOT NULL
  ,[DoctorPhoneNumber] [NVARCHAR](100) NOT NULL
  ,[DoctorAddress] [NVARCHAR](100) NOT NULL
  ,[DoctorCity] [NVARCHAR](100) NOT NULL
  ,[DoctorState] [NVARCHAR](2) NOT NULL
  ,[DoctorZipCode] [NVARCHAR](10) NOT NULL
 )

 -- Add constraints to the doctors table 
ALTER TABLE Doctors
  ADD CONSTRAINT pkDoctors
    PRIMARY KEY (DoctorID);
GO

ALTER TABLE Doctors
  ADD CONSTRAINT ckDoctors
    CHECK (DoctorPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    CHECK (DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]' or 
           DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
GO

-- Create appointments table with inputted data types and configurations
CREATE TABLE Appointments
 ([AppointmentID] [int] IDENTITY(1,1) NOT NULL
  ,[AppointmentDateTime] [DATETIME] NOT NULL
  ,[AppointmentPatientID] [int] NOT NULL
  ,[AppointmentDoctorID] [int] NOT NULL
  ,[AppointmentClinicID] [int] NOT NULL
 )

 -- Add constraints to the appointments table 
ALTER TABLE Appointments
  ADD CONSTRAINT pkAppointments
    PRIMARY KEY (AppointmentID);
GO

ALTER TABLE Appointments
  ADD CONSTRAINT fkAppointmentsToPatients
    FOREIGN KEY (AppointmentPatientID) REFERENCES Patients(PatientID);
GO
ALTER TABLE Appointments
  ADD CONSTRAINT fkAppointmentsToDoctors
    FOREIGN KEY (AppointmentDoctorID) REFERENCES Doctors(DoctorID);
GO
ALTER TABLE Appointments
  ADD CONSTRAINT fkAppointmentsToClinics
    FOREIGN KEY (AppointmentClinicID) REFERENCES Clinics(ClinicID);
GO

-- Create an abstraction later for the clinics table by creating a viewing table
CREATE VIEW vClinics
  AS 
    SELECT
    ClinicID,
    ClinicName,
    ClinicPhoneNumber,
    ClinicAddress,
    ClinicCity,
    ClinicState,
    ClinicZipCode
  FROM dbo.Clinics
GO
SELECT * FROM vClinics
GO

-- Create an abstraction later for the patients table by creating a viewing table
CREATE VIEW vPatients
  AS 
    SELECT
    PatientID,
    PatientFirstName,
    PatientLastName,
    PatientPhoneNumber,
    PatientAddress,
    PatientCity,
    PatientState,
    PatientZipCode
  FROM dbo.Patients
GO
SELECT * FROM vPatients
GO

-- Create an abstraction later for the doctors table by creating a viewing table
CREATE VIEW vDoctors
  AS 
    SELECT
    DoctorID,
    DoctorFirstName,
    DoctorLastName,
    DoctorPhoneNumber,
    DoctorAddress,
    DoctorCity,
    DoctorState,
    DoctorZipCode
  FROM dbo.Doctors
GO
SELECT * FROM vDoctors
GO

-- Create an abstraction later for the appointments table by creating a viewing table
CREATE VIEW vAppointments
  AS
    SELECT
    AppointmentID,
    AppointmentDateTime,
    AppointmentPatientID,
    AppointmentDoctorID,
    AppointmentClinicID
  FROM dbo.Appointments
GO
SELECT * FROM vAppointments
GO

-- Create an abstraction later for the appointments table by creating a viewing table
-- Base viewing table combining data from all 3 tables
-- Joined by primary and foreign key constraints
CREATE VIEW vAppointmentsByPatientsDoctorsAndClinics
  AS
    SELECT
    AppointmentID,
    format(A.AppointmentDateTime, 'MM/DD/YYYY') as [AppointmentDate],
    format(A.AppointmentDateTime, 'hh:mm') as [AppointmentTime],
    PatientID,
    concat(P.PatientFirstName, ' ', P.PatientLastName) as [PatientName],
    PatientPhoneNumber,
    PatientAddress,
    PatientCity,
    PatientState,
    PatientZipCode,
    DoctorID,
    concat(D.DoctorFirstName, ' ', D.DoctorLastName) as [DoctorName],
    DoctorPhoneNumber,
    DoctorAddress,
    DoctorCity,
    DoctorState,
    DoctorZipCode,
    ClinicID,
    ClinicName,
    ClinicPhoneNumber,
    ClinicAddress,
    ClinicCity,
    ClinicState,
    ClinicZipCode
  FROM Appointments as A
  FULL JOIN Patients as P
    ON A.AppointmentPatientID = P.PatientID
  FULL JOIN Doctors as D
    ON A.AppointmentDoctorID = D.DoctorID
  FULL JOIN Clinics as C
    ON A.AppointmentClinicID = C.ClinicID
GO
Select * From vAppointmentsByPatientsDoctorsAndClinics
Go

-- Adding stored procedures
-- Create a stored procedure to insert data into the clinics table
CREATE PROCEDURE pInsClinics
    (@ClinicName NVARCHAR(100)
    ,@ClinicPhoneNumber NVARCHAR(100)
    ,@ClinicAddress NVARCHAR(100)
    ,@ClinicCity NVARCHAR(100)
    ,@ClinicState NVARCHAR(2)
    ,@ClinicZipCode NVARCHAR(10)
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   INSERT into Clinics(ClinicName, ClinicPhoneNumber, ClinicAddress, 
            ClinicCity, ClinicState, ClinicZipCode)
        VALUES (@ClinicName, @ClinicPhoneNumber, @ClinicAddress, 
            @ClinicCity, @ClinicState, @ClinicZipCode)
   Commit TRANSACTION
   Set @RC = +1
  End TRY
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO  

-- Creates a stored procedure to update the data on the clinics table 
Create PROCEDURE pUpdClinics
    (@ClinicID int
    ,@ClinicName NVARCHAR(100)
    ,@ClinicPhoneNumber NVARCHAR(100)
    ,@ClinicAddress NVARCHAR(100)
    ,@ClinicCity NVARCHAR(100)
    ,@ClinicState NVARCHAR(2)
    ,@ClinicZipCode NVARCHAR(10)
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code -- 
    UPDATE Clinics
    SET ClinicName = @ClinicName,
     ClinicPhoneNumber = @ClinicPhoneNumber,
     ClinicAddress = @ClinicAddress,
     ClinicCity = @ClinicCity,
     ClinicState = @ClinicState,
     ClinicZipCode = @ClinicZipCode
    WHERE ClinicID = @ClinicID
   Commit TRANSACTION
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO

-- Creates a stored procedure to delete data from the clinics table, 
-- Where ClinicID = @ClinicID
Create PROCEDURE pDelClinics
    (@ClinicID int
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code -- 
    Delete 
    From Clinics
    WHERE ClinicID = @ClinicID
    --
   Commit TRANSACTION
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO

-- Create a stored procedure to insert data into the patients table
CREATE PROCEDURE pInsPatients
    (@PatientFirstName NVARCHAR(100)
    ,@PatientLastName NVARCHAR(100)
    ,@PatientPhoneNumber NVARCHAR(100)
    ,@PatientAddress NVARCHAR(100)
    ,@PatientCity NVARCHAR(100)
    ,@PatientState NVARCHAR(2)
    ,@PatientZipCode NVARCHAR(10)
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   INSERT into Patients(PatientFirstName, PatientLastName, PatientPhoneNumber, 
            PatientAddress, PatientCity, PatientState, PatientZipCode)
        VALUES (@PatientFirstName, @PatientLastName, @PatientPhoneNumber, 
            @PatientAddress, @PatientCity, @PatientState, @PatientZipCode)
   Commit TRANSACTION
   Set @RC = +1
  End TRY
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO  

-- Creates a stored procedure to update the data on the patients table 
Create PROCEDURE pUpdPatients
    (@PatientID int
    ,@PatientFirstName NVARCHAR(100)
    ,@PatientLastName NVARCHAR(100)
    ,@PatientPhoneNumber NVARCHAR(100)
    ,@PatientAddress NVARCHAR(100)
    ,@PatientCity NVARCHAR(100)
    ,@PatientState NVARCHAR(2)
    ,@PatientZipCode NVARCHAR(10)
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code -- 
    UPDATE Patients
    SET PatientFirstName = @PatientFirstName,
     PatientLastName = @PatientLastName,
     PatientPhoneNumber = @PatientPhoneNumber,
     PatientAddress = @PatientAddress,
     PatientCity = @PatientCity,
     PatientState = @PatientState,
     PatientZipCode = @PatientZipCode
    WHERE PatientID = @PatientID
   Commit TRANSACTION
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO

-- Creates a stored procedure to delete data from the patients table, 
-- Where PatientID = @PatientID
Create PROCEDURE pDelPatients
    (@PatientID int
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code -- 
    Delete
    From Patients
    WHERE PatientID = @PatientID
    --
   Commit TRANSACTION
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO

-- Create a stored procedure to insert data into the doctors table
CREATE PROCEDURE pInsDoctors
    (@DoctorFirstName NVARCHAR(100)
    ,@DoctorLastName NVARCHAR(100)
    ,@DoctorPhoneNumber NVARCHAR(100)
    ,@DoctorAddress NVARCHAR(100)
    ,@DoctorCity NVARCHAR(100)
    ,@DoctorState NVARCHAR(2)
    ,@DoctorZipCode NVARCHAR(10)
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   INSERT into Doctors(DoctorFirstName, DoctorLastName, DoctorPhoneNumber, 
            DoctorAddress, DoctorCity, DoctorState, DoctorZipCode)
        VALUES (@DoctorFirstName, @DoctorLastName, @DoctorPhoneNumber, 
            @DoctorAddress, @DoctorCity, @DoctorState, @DoctorZipCode)
   Commit TRANSACTION
   Set @RC = +1
  End TRY
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO  

-- Creates a stored procedure to update the data on the doctors table 
Create PROCEDURE pUpdDoctors
    (@DoctorID int
    ,@DoctorFirstName NVARCHAR(100)
    ,@DoctorLastName NVARCHAR(100)
    ,@DoctorPhoneNumber NVARCHAR(100)
    ,@DoctorAddress NVARCHAR(100)
    ,@DoctorCity NVARCHAR(100)
    ,@DoctorState NVARCHAR(2)
    ,@DoctorZipCode NVARCHAR(10)
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code -- 
    UPDATE Doctors
    SET DoctorFirstName = @DoctorFirstName,
     DoctorLastName = @DoctorLastName,
     DoctorPhoneNumber = @DoctorPhoneNumber,
     DoctorAddress = @DoctorAddress,
     DoctorCity = @DoctorCity,
     DoctorState = @DoctorState,
     DoctorZipCode = @DoctorZipCode
    WHERE DoctorID = @DoctorID
   Commit TRANSACTION
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO

-- Creates a stored procedure to delete data from the doctors table, 
-- Where DoctorID = @DoctorID
Create PROCEDURE pDelDoctors
    (@DoctorID int
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code -- 
    Delete 
    From Doctors
    WHERE DoctorID = @DoctorID
   -- 
   Commit TRANSACTION
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO

-- Create a stored procedure to insert data into the appointments table
CREATE PROCEDURE pInsAppointments
    (@AppointmentDateTime DATETIME
    ,@AppointmentPatientID int
    ,@AppointmentDoctorID int 
    ,@AppointmentClinicID int 
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   INSERT into Appointments(AppointmentDateTime, AppointmentPatientID, 
            AppointmentDoctorID, AppointmentClinicID)
        VALUES (@AppointmentDateTime, @AppointmentPatientID, 
            @AppointmentDoctorID, @AppointmentClinicID)
   Commit TRANSACTION
   Set @RC = +1
  End TRY
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO  

-- Creates a stored procedure to update the data on the appointments table 
CREATE PROCEDURE pUpdAppointments
    (@AppointmentID int
    ,@AppointmentDateTime DATETIME
    ,@AppointmentPatientID int
    ,@AppointmentDoctorID int 
    ,@AppointmentClinicID int 
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   Update Appointments
   Set AppointmentDateTime = @AppointmentDateTime, 
    AppointmentPatientID = @AppointmentPatientID, 
    AppointmentDoctorID = @AppointmentDoctorID, 
    AppointmentClinicID = @AppointmentClinicID
   Where AppointmentID = @AppointmentID 
   Commit TRANSACTION
   Set @RC = +1
  End TRY
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO  

-- Creates a stored procedure to delete data from the doctors table, 
-- Where AppointmentID = @AppointmentID
CREATE PROCEDURE pDelAppointments
    (@AppointmentID int
    )
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   Delete 
   From Appointments
   Where AppointmentID = @AppointmentID 
   --
   Commit TRANSACTION
   Set @RC = +1
  End TRY
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
GO  

-- Set Permissions 
-- Deny public permission to the original tables 
DENY Select, INSERT, UPDATE, DELETE on Clinics TO PUBLIC
DENY Select, INSERT, UPDATE, DELETE on Patients TO PUBLIC
DENY Select, INSERT, UPDATE, DELETE on Doctors TO PUBLIC
DENY Select, INSERT, UPDATE, DELETE on Appointments TO PUBLIC

-- Allow public select access to the view tables 
GRANT SELECT ON vClinics TO PUBLIC
GRANT SELECT ON vPatients TO PUBLIC
GRANT SELECT ON vDoctors TO PUBLIC
GRANT SELECT ON vAppointments TO PUBLIC
GRANT SELECT ON vAppointmentsByPatientsDoctorsAndClinics TO PUBLIC

-- Allow public execute access to stored procedures for the Clinics table 
Grant Execute On pInsClinics To Public;
Grant Execute On pUpdClinics To Public;
Grant Execute On pDelClinics To Public;

-- Allow public execute access to stored procedures for the Patients table 
Grant Execute On pInsPatients To Public;
Grant Execute On pUpdPatients To Public;
Grant Execute On pDelPatients To Public;

-- Allow public execute access to stored procedures for the Doctors table 
Grant Execute On pInsDoctors To Public;
Grant Execute On pUpdDoctors To Public;
Grant Execute On pDelDoctors To Public;

-- Allow public execute access to stored procedures for the Appointments table 
Grant Execute On pInsAppointments To Public;
Grant Execute On pUpdAppointments To Public;
Grant Execute On pDelAppointments To Public;

--< Test Views and Stored Procedures >--
Select * From Clinics
GO
Select * From Patients
GO
Select * From Doctors
GO
Select * From Appointments
GO

Select * From vClinics
GO
Select * From vPatients
GO
Select * From vDoctors
GO
Select * From vAppointments
GO
Select * From vAppointmentsByPatientsDoctorsAndClinics
GO

---- Code from Assignment08 creating the database
---- Sample Data from Mockaroo

insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Ode', 'Ragsdale', '619-429-4069', '699 Spaight Point', 'San Diego', 'CA', '92145');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Laure', 'Darbishire', '209-876-0230', '498 Kings Court', 'Modesto', 'CA', '95397');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Danice', 'Dewane', '208-726-5844', '8566 Stoughton Center', 'Boise', 'ID', '83722');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Charlot', 'Bullus', '316-160-2557', '8341 Mayer Center', 'Wichita', 'KS', '67220');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Louella', 'Mance', '719-800-7408', '75 David Lane', 'Colorado Springs', 'CO', '80920');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Ari', 'Dengel', '701-462-8957', '2142 Londonderry Pass', 'Grand Forks', 'ND', '58207');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Kaylee', 'Hillyatt', '402-317-8857', '06181 Grasskamp Avenue', 'Omaha', 'NE', '68144');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Frederica', 'Wanne', '901-717-5095', '6680 Harbort Terrace', 'Memphis', 'TN', '38168');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Colan', 'Vickerstaff', '515-345-9989', '64 Hoffman Circle', 'Des Moines', 'IA', '50347');
insert into Doctors (DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode) values ('Jeannie', 'Schaumaker', '360-164-2691', '4690 Delladonna Crossing', 'Seattle', 'WA', '98109');
Select * FROM vDoctors
GO

insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Viva', '432-516-8593', '9739 Acker Court', 'Midland', 'TX', '79710');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Transcof', '716-468-6784', '6701 Summit Road', 'Buffalo', 'NY', '14233');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Treeflex', '310-938-1204', '32 Badeau Lane', 'Torrance', 'CA', '90505');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Stringtough', '571-821-9287', '175 Amoth Pass', 'Alexandria', 'VA', '22313');
insert into Clinics (ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode) values ('Bigtax', '210-483-9959', '82 Declaration Avenue', 'San Antonio', 'TX', '78265');
Select * From vClinics
GO

insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Rasla', 'Hanhard', '713-572-7328', '633 Forest Dale Point', 'Houston', 'TX', '77288');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Katleen', 'Pharoah', '312-258-8702', '3112 Glendale Park', 'Chicago', 'IL', '60609');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Holden', 'Grinham', '414-725-8444', '5 Crowley Hill', 'Milwaukee', 'WI', '53225');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Lyell', 'Whorlow', '951-670-9484', '35239 Welch Lane', 'Moreno Valley', 'CA', '92555');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Danita', 'Flecknoe', '609-697-0141', '3244 Fuller Crossing', 'Trenton', 'NJ', '08638');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Vickie', 'Gorghetto', '814-265-2830', '3 Thackeray Alley', 'Erie', 'PA', '16505');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Cornall', 'Lamblot', '339-384-3308', '720 Gale Plaza', 'Woburn', 'MA', '01813');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Rutger', 'Barff', '323-553-1539', '70053 Arapahoe Pass', 'Long Beach', 'CA', '90805');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Tobit', 'Fraulo', '626-723-0950', '1 Artisan Point', 'Pasadena', 'CA', '91125');
insert into Patients (PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode) values ('Arabel', 'LAbbet', '605-252-0389', '11286 Sherman Junction', 'Sioux Falls', 'SD', '57110');
Select * From vPatients
GO

insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('04/16/2019 13:45', 1, 1, 1);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('09/22/2019 13:19', 2, 2, 2);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('09/19/2019 17:34', 3, 3, 3);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('10/16/2019 12:12', 4, 4, 4);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('08/04/2019 13:35', 5, 5, 5);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('11/11/2019 15:36', 6, 6, 1);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('08/24/2019 12:14', 7, 7, 2);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('04/17/2019 13:35', 8, 8, 3);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('04/01/2019 12:25', 9, 9, 4);
insert into Appointments (AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID) values ('03/18/2019 12:30', 10, 10, 5)
Select * From vAppointments
Go

Select * From vAppointmentsByPatientsDoctorsAndClinics
GO

-- 3/10, NFang, Create other views
CREATE VIEW vAppointmentsByPatientsAndDoctors
  AS
    SELECT
    AppointmentID,
    format(A.AppointmentDateTime, 'MM/DD/YYYY') as [AppointmentDate],
    format(A.AppointmentDateTime, 'hh:mm') as [AppointmentTime],
    PatientID,
    concat(P.PatientFirstName, ' ', P.PatientLastName) as [PatientName],
    PatientPhoneNumber,
    PatientAddress,
    PatientCity,
    PatientState,
    PatientZipCode,
    DoctorID,
    concat(D.DoctorFirstName, ' ', D.DoctorLastName) as [DoctorName],
    DoctorPhoneNumber,
    DoctorAddress,
    DoctorCity,
    DoctorState,
    DoctorZipCode
  FROM Appointments as A
  FULL JOIN Patients as P
    ON A.AppointmentPatientID = P.PatientID
  FULL JOIN Doctors as D
    ON A.AppointmentDoctorID = D.DoctorID
GO
Select * From vAppointmentsByPatientsAndDoctors
Go

CREATE VIEW vAppointmentsByClinics
  AS
    SELECT
    AppointmentID,
    format(A.AppointmentDateTime, 'MM/DD/YYYY') as [AppointmentDate],
    format(A.AppointmentDateTime, 'hh:mm') as [AppointmentTime],
    ClinicID,
    ClinicName,
    ClinicPhoneNumber,
    ClinicAddress,
    ClinicCity,
    ClinicState,
    ClinicZipCode
  FROM Appointments as A
  FULL JOIN Clinics as C
    ON A.AppointmentClinicID = C.ClinicID
GO
Select * From vAppointmentsByClinics
Go
