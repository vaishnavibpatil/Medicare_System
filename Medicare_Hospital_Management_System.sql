CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    DOB DATE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15)
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

CREATE TABLE Treatments (
    TreatmentID INT PRIMARY KEY,
    PatientID INT,
    StaffID INT,
    TreatmentDate DATE,
    Cost DECIMAL(10, 2) CHECK (Cost >= 0),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

INSERT INTO Patients (PatientID, Name, DOB, Email, Phone) VALUES (1, 'John Doe', TO_DATE('1985-05-15', 'YYYY-MM-DD'), 'john.doe@example.com', '555-0101');
INSERT INTO Patients (PatientID, Name, DOB, Email, Phone) VALUES (2, 'Jane Smith', TO_DATE('1990-06-20', 'YYYY-MM-DD'), 'jane.smith@example.com', '555-0102');
INSERT INTO Patients (PatientID, Name, DOB, Email, Phone) VALUES (3, 'Alice Johnson', TO_DATE('1975-09-25', 'YYYY-MM-DD'), 'alice.j@example.com', '555-0103');
INSERT INTO Patients (PatientID, Name, DOB, Email, Phone) VALUES (4, 'Bob Brown', TO_DATE('1982-01-30', 'YYYY-MM-DD'), 'bob.brown@example.com', '555-0104');
INSERT INTO Patients (PatientID, Name, DOB, Email, Phone) VALUES (5, 'Eve White', TO_DATE('1995-12-12', 'YYYY-MM-DD'), 'eve.white@example.com', '555-0105');

SELECT * FROM Patients;

INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (1, 'Cardiology');
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (2, 'Neurology');
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (3, 'Orthopedics');

SELECT * FROM Departments;

INSERT INTO Staff (StaffID, Name, Role, DepartmentID) VALUES (1, 'Dr. Smith', 'Cardiologist', 1);
INSERT INTO Staff (StaffID, Name, Role, DepartmentID) VALUES (2, 'Dr. Jones', 'Neurologist', 2);
INSERT INTO Staff (StaffID, Name, Role, DepartmentID) VALUES (3, 'Dr. Brown', 'Orthopedic Surgeon', 3);
INSERT INTO Staff (StaffID, Name, Role, DepartmentID) VALUES (4, 'Nurse Kelly', 'Nurse', 1);
INSERT INTO Staff (StaffID, Name, Role, DepartmentID) VALUES (5, 'Nurse Taylor', 'Nurse', 2);

SELECT * FROM Staff;

INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (1, 1, 1, TO_DATE('2023-01-10', 'YYYY-MM-DD'), 500);
INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (2, 2, 2, TO_DATE('2023-02-15', 'YYYY-MM-DD'), 1500);
INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (3, 3, 3, TO_DATE('2023-03-20', 'YYYY-MM-DD'), 750);
INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (4, 4, 1, TO_DATE('2023-04-05', 'YYYY-MM-DD'), 200);
INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (5, 5, 2, TO_DATE('2023-05-30', 'YYYY-MM-DD'), 1200);
INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (6, 1, 3, TO_DATE('2023-06-10', 'YYYY-MM-DD'), 300);
INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (7, 2, 1, TO_DATE('2023-07-01', 'YYYY-MM-DD'), 800);
INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (8, 3, 2, TO_DATE('2023-07-15', 'YYYY-MM-DD'), 950);
INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (9, 4, 1, TO_DATE('2023-08-20', 'YYYY-MM-DD'), 1100);
INSERT INTO Treatments (TreatmentID, PatientID, StaffID, TreatmentDate, Cost) VALUES (10, 5, 3, TO_DATE('2023-09-25', 'YYYY-MM-DD'), 650);

SELECT * FROM Treatments;

UPDATE Treatments
SET Cost = 800
WHERE TreatmentID = 3;

DELETE from Treatments WHERE PatientID = 1;
DELETE from Patients WHERE PatientID = 1;


SELECT
    p.PatientID,
    p.Name AS PatientName,
    t.TreatmentID,
    t.TreatmentDate,
    t.Cost,
    s.StaffID,
    s.Name AS StaffName,
    s.Role AS StaffRole
FROM
    Patients p
JOIN
    Treatments t ON p.PatientID = t.PatientID
JOIN
    Staff s ON t.StaffID = s.StaffID
ORDER BY
    p.PatientID, t.TreatmentDate;


SELECT
    t.TreatmentID,
    p.Name AS PatientName,
    s.Name AS StaffName,
    d.DepartmentName,
    t.TreatmentDate,
    t.Cost
FROM
    Treatments t
JOIN
    Patients p ON t.PatientID = p.PatientID
JOIN
    Staff s ON t.StaffID = s.StaffID
LEFT JOIN
    Departments d ON s.DepartmentID = d.DepartmentID
ORDER BY
    t.TreatmentID;
    
    
SELECT DISTINCT
    p.PatientID,
    p.Name AS PatientName
FROM
    Patients p
JOIN
    Treatments t ON p.PatientID = t.PatientID
WHERE
    t.StaffID IN (
        SELECT s.StaffID
        FROM Staff s
        WHERE s.DepartmentID = 1
    );

SELECT
    s.StaffID,
    s.Name AS StaffName,
    s.Role AS StaffRole
FROM
    Staff s
WHERE
    (SELECT COUNT(DISTINCT t.PatientID)
        FROM Treatments t
        WHERE t.StaffID = s.StaffID) > 3;


SELECT
    p.PatientID,
    p.Name AS PatientName,
    SUM(t.Cost) AS TotalTreatmentCost
FROM
    Patients p
JOIN
    Treatments t ON p.PatientID = t.PatientID
GROUP BY
    p.PatientID, p.Name
HAVING
    SUM(t.Cost) >= 1000;



