--**********************************************************************************************--
-- Title: Assigment08 - Final Milestone 02
-- Author: NFang
-- Desc: This file demonstrates how to create a prototype database and ; 
--       tables, constraints, views, stored procedures, and permissions
-- Change Log: When,Who,What
-- 03/03/2020, NFang, Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment08DB_NFang')
	 Begin 
	  Alter Database [Assignment08DB_NFang] set Single_user With Rollback Immediate;
	  Drop Database Assignment08DB_NFang;
	 End
	Create Database Assignment08DB_NFang;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment08DB_NFang;

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

-- Test insert stored proc into the clinics table
Declare @Status int;
Exec @Status = pInsClinics
    @ClinicName = 'Queens'
    ,@ClinicPhoneNumber = '888-888-8888'
    ,@ClinicAddress = '8 Aloha Street'
    ,@ClinicCity = 'Honolulu'
    ,@ClinicState = 'HI'
    ,@ClinicZipCode = '96817'
    ;
Select Case @Status
  When +1 Then 'Insert to Clinics successful.'
  When -1 Then 'Insert to Clinics failed.'
  End as [pInsClinics Status];
Select * FROM vClinics Where ClinicID = @@IDENTITY;
GO

-- Test update stored proc into the clinics table
Declare @Status int;
Exec @Status = pUpdClinics
    @ClinicID = '1'
    ,@ClinicName = 'Queens Hospital'
    ,@ClinicPhoneNumber = '808-000-0000'
    ,@ClinicAddress = '808 Aloha Street'
    ,@ClinicCity = 'Honolulu'
    ,@ClinicState = 'HI'
    ,@ClinicZipCode = '96817'
    ;
Select Case @Status
  When +1 Then 'Update to Clinics successful.'
  When -1 Then 'Update to Clinics failed.'
  End as [pUpdClinics Status];
GO
-- Test delete stored proc for the clinics table 
Declare @Status int;
Exec @Status = pDelClinics
    @ClinicID = 1
    ;
Select Case @Status
  When +1 Then 'Delete from Clinics successful.'
  When -1 Then 'Delete from Clinics failed.'
  End as [pDelClinics Status];
GO

-- Test insert stored proc into the Patients table
Declare @Status int;
Exec @Status = pInsPatients
     @PatientFirstName = 'J'
    ,@PatientLastName = 'Smith'
    ,@PatientPhoneNumber = '111-111-1111'
    ,@PatientAddress = '1 Mahalo Street'
    ,@PatientCity = 'Honolulu'
    ,@PatientState = 'HI'
    ,@PatientZipCode = '96817-0000'
    ;
Select Case @Status
  When +1 Then 'Insert to Patients successful.'
  When -1 Then 'Insert to Patients failed.'
  End as [pInsPatients Status];
Select * FROM vPatients Where PatientID = @@IDENTITY;
GO
-- Test update stored proc into the patients table
Declare @Status int;
Exec @Status = pUpdPatients
    @PatientID = 1
    ,@PatientFirstName = 'J'
    ,@PatientLastName = 'Smith'
    ,@PatientPhoneNumber = '222-222-2222'
    ,@PatientAddress = '2 Mahalo Street'
    ,@PatientCity = 'Honolulu'
    ,@PatientState = 'HI'
    ,@PatientZipCode = '96817-1111'
    ;
Select Case @Status
  When +1 Then 'Update to Patients successful.'
  When -1 Then 'Update to Patients failed.'
  End as [pUpdPatients Status];
GO
-- Test delete stored proc from the patients table
Declare @Status int;
Exec @Status = pDelPatients
    @PatientID = 1
    ;
Select Case @Status
  When +1 Then 'Delete from Patients successful.'
  When -1 Then 'Delete from Patients failed.'
  End as [pDelPatients Status];
GO

-- Test insert stored proc into the Doctors table 
Declare @Status int;
Exec @Status = pInsDoctors
    @DoctorFirstName = 'J'
    ,@DoctorLastName = 'Doe'
    ,@DoctorPhoneNumber = '333-333-3333'
    ,@DoctorAddress = '3 Nui Street'
    ,@DoctorCity = 'Honolulu'
    ,@DoctorState = 'HI'
    ,@DoctorZipCode = '96817-3333'
    ;
Select Case @Status
  When +1 Then 'Insert to Doctors successful.'
  When -1 Then 'Insert to Doctors failed.'
  End as [pInsDoctors Status];
Select * FROM vDoctors Where DoctorID = @@IDENTITY;
GO

-- Test update stored proc into the patients table
Declare @Status int;
Exec @Status = pUpdDoctors
    @DoctorID = 1
    ,@DoctorFirstName ='J'
    ,@DoctorLastName = 'Doe'
    ,@DoctorPhoneNumber = '000-000-3333'
    ,@DoctorAddress = '333 Nui Street'
    ,@DoctorCity = 'Honolulu'
    ,@DoctorState = 'HI'
    ,@DoctorZipCode = '96817-0000'
    ;
Select Case @Status
  When +1 Then 'Update to Doctors successful.'
  When -1 Then 'Update to Doctors failed.'
  End as [pUpdDoctors Status];
GO
-- Test delete stored proc from the Doctors table
Declare @Status int;
Exec @Status = pDelDoctors
    @DoctorID = 1
    ;
Select Case @Status
  When +1 Then 'Delete from Doctors successful.'
  When -1 Then 'Delete from Doctors failed.'
  End as [pDelDoctors Status];
GO

-- Test insert stored proc into the Appointments table 
Declare @Status int;
Exec @Status = pInsAppointments
    @AppointmentDateTime = '01/01/1998'
    ,@AppointmentPatientID = 1
    ,@AppointmentDoctorID = 1
    ,@AppointmentClinicID = 1
    ;
Select Case @Status
  When +1 Then 'Insert to Appointments successful.'
  When -1 Then 'Insert to Appointments failed.'
  End as [pInsAppointments Status];
Select * FROM vAppointments Where AppointmentID = @@IDENTITY;
GO

-- Test update stored proc into the Appointments table
Declare @Status int;
Exec @Status = pUpdAppointments
    @AppointmentID = 1
    ,@AppointmentDateTime = '02/02/2000'
    ,@AppointmentPatientID = 2
    ,@AppointmentDoctorID = 2
    ,@AppointmentClinicID = 2
    ;
Select Case @Status
  When +1 Then 'Update to Appointments successful.'
  When -1 Then 'Update to Appointments failed.'
  End as [pUpdAppointments Status];
GO
-- Test delete stored proc for the Appointments table 
Declare @Status int;
Exec @Status = pDelAppointments
    @AppointmentID = 1
    ;
Select Case @Status
  When +1 Then 'Delete from Appointments successful.'
  When -1 Then 'Delete from Appointments failed.'
  End as [pDelAppointments Status];
GO

-- Import starter generic data into the clinics table 
Exec pInsClinics
    @ClinicName = 'Queen'
    ,@ClinicPhoneNumber = '808-000-0000'
    ,@ClinicAddress = '808 Aloha Street'
    ,@ClinicCity = 'Honolulu'
    ,@ClinicState = 'HI'
    ,@ClinicZipCode = '96817'
    ;
GO


-- Import starter generic data into the patients table
Exec pInsPatients
    @PatientFirstName = 'J'
    ,@PatientLastName = 'Smith' 
    ,@PatientPhoneNumber = '333-333-3333'
    ,@PatientAddress = '2 Mahalo Street'
    ,@PatientCity = 'Honolulu'
    ,@PatientState = 'HI'
    ,@PatientZipCode = '96817'
    ;
GO

-- Import starter generic data into the doctors table 
Exec pInsDoctors
    @DoctorFirstName = 'J'
    ,@DoctorLastName = 'Doe'
    ,@DoctorPhoneNumber = '000-000-3333'
    ,@DoctorAddress = '3 Nui Street'
    ,@DoctorCity = 'Honolulu'
    ,@DoctorState = 'HI'
    ,@DoctorZipCode = '96817'
    ;
GO

Exec pInsAppointments
    @AppointmentDateTime = '01/02/1998'
    ,@AppointmentPatientID = 1
    ,@AppointmentDoctorID = 1
    ,@AppointmentClinicID = 1
    ;
GO
