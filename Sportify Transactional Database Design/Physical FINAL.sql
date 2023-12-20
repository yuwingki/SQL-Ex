Physical FINAL.sql
DROP TABLE IF EXISTS PremiumSubscription;

DROP TABLE IF EXISTS customer;

DROP TABLE IF EXISTS demographics;


CREATE TABLE customer (
  customer_id VARCHAR(11) NOT NULL PRIMARY KEY,
  first_name VARCHAR(105) NOT NULL,
  middle_initial CHAR(1),
  last_name VARCHAR(105) NOT NULL,
  Sign_up_Date DATE,
  email VARCHAR(105)
);

CREATE TABLE demographics (
  customer_id VARCHAR(11) FOREIGN KEY REFERENCES customer(customer_id),
  age INT,
  ethnicity VARCHAR(50) CHECK (ethnicity IN ('American Indian or Alaska Native', 'Asian', 'Black or African American', 'Hispanic or Latino', 'Native Hawaiian or Other Pacific Islander', 'White')),
  gender VARCHAR(6) CHECK (gender IN ('male', 'female')),
	PRIMARY KEY (age, ethnicity, gender)
);

CREATE TABLE PremiumSubscription (
    customer_id VARCHAR(11) FOREIGN KEY REFERENCES customer(customer_id),
		subscription_id VARCHAR(11) PRIMARY KEY,
    first_name VARCHAR(105),
    middle_initial CHAR(1),
    last_name VARCHAR(105),
    Street VARCHAR(105),
    city VARCHAR(105),
    state CHAR(2),
    zip_code CHAR(5),
    country VARCHAR(105)
);


INSERT INTO customer (customer_id, first_name, middle_initial, last_name, Sign_up_Date, email) VALUES 
('CUST001', 'John', 'D', 'Doe', '2022-01-01', 'johndoe@example.com'),
('CUST002', 'Jane', 'E', 'Doe', '2022-01-02', 'janedoe@example.com'),
('CUST003', 'Mark', 'F', 'Smith', '2022-01-03', 'marksmith@example.com'),
('CUST004', 'Alice', 'G', 'Johnson', '2022-01-04', 'alicejohnson@example.com'),
('CUST005', 'Bob', 'H', 'Williams', '2022-01-05', 'bobwilliams@example.com'),
('CUST006', 'Sarah', 'I', 'Brown', '2022-01-06', 'sarahbrown@example.com'),
('CUST007', 'David', 'J', 'Jones', '2022-01-07', 'davidjones@example.com'),
('CUST008', 'Mary', 'K', 'Miller', '2022-01-08', 'marymiller@example.com'),
('CUST009', 'Michael', 'L', 'Davis', '2022-01-09', 'michaeldavis@example.com'),
('CUST010', 'Amanda', 'M', 'Taylor', '2022-01-10', 'amandataylor@example.com'),
('CUST011', 'James', 'N', 'Anderson', '2022-01-11', 'jamesanderson@example.com'),
('CUST012', 'Emily', 'O', 'Wilson', '2022-01-12', 'emilywilson@example.com'),
('CUST013', 'Daniel', 'P', 'Moore', '2022-01-13', 'danielmoore@example.com'),
('CUST014', 'Jessica', 'Q', 'Jackson', '2022-01-14', 'jessicajackson@example.com'),
('CUST015', 'William', 'R', 'Martin', '2022-01-15', 'williammartin@example.com'),
('CUST016', 'Olivia', 'S', 'Lee', '2022-01-16', 'olivialeee@example.com'),
('CUST017', 'Joseph', 'T', 'Clark', '2022-01-17', 'josephclark@example.com'),
('CUST018', 'Ashley', 'U', 'Lewis', '2022-01-18', 'ashleylewis@example.com'),
('CUST019', 'Christopher', 'V', 'Robinson', '2022-01-19', 'christopherrobinson@example.com'),
('CUST020', 'Samantha', 'W', 'Walker', '2022-01-20', 'samanthawalker@example.com');



INSERT INTO demographics (customer_id, age, ethnicity, gender) VALUES 
  ('CUST001', 32, 'White', 'male'),
  ('CUST002', 24, 'Black or African American', 'female'),
  ('CUST003', 41, 'White', 'male'),
  ('CUST004', 19, 'Hispanic or Latino', 'male'),
  ('CUST005', 29, 'Asian', 'female'),
  ('CUST006', 36, 'White', 'male'),
  ('CUST007', 45, 'White', 'female'),
  ('CUST008', 27, 'Black or African American', 'male'),
  ('CUST009', 22, 'Hispanic or Latino', 'male'),
  ('CUST010', 52, 'White', 'female'),
  ('CUST011', 18, 'Black or African American', 'male'),
  ('CUST012', 33, 'Asian', 'male'),
  ('CUST013', 30, 'White', 'female'),
  ('CUST014', 48, 'White', 'male'),
  ('CUST015', 39, 'Hispanic or Latino', 'female'),
  ('CUST016', 25, 'Asian', 'male'),
  ('CUST017', 29, 'White', 'female'),
  ('CUST018', 21, 'Black or African American', 'male'),
  ('CUST019', 40, 'White', 'female'),
  ('CUST020', 27, 'Hispanic or Latino', 'male');


INSERT INTO PremiumSubscription (customer_id, subscription_id, first_name, middle_initial, last_name, Street, city, state, zip_code, country)
VALUES 
('CUST001', '12222278901', 'John', 'D', 'Doe', '123 Main St', 'Anytown', 'CA', '12345', 'USA'),
('CUST002', '23450082212', 'Jane', 'E', 'Smith', '456 Oak Ave', 'Anycity', 'NY', '23456', 'USA'),
('CUST006', '32220890123', 'Sarah', 'I', 'Brown', '789 Pine St', 'Anystate', 'FL', '34567', 'USA'),
('CUST008', '45008921234', 'Mary', 'K', 'Miller', '101 Elm St', 'Anycity', 'TX', '45678', 'USA'),
('CUST009','56022212345', 'Michael', 'L', 'Davis', '246 Maple Ave', 'Anytown', 'MA', '56789', 'USA'),
('CUST010', '60090123456', 'Amanda', 'M', 'Taylor', '369 Walnut St', 'Anystate', 'WA', '67890', 'USA'),
('CUST016', '70001234567', 'Olivia', 'S', 'Lee', '4712 Birch Blvd', 'Anytown', 'CA', '78901', 'USA'),
('CUST019', '89002342678', 'Christopher', 'V', 'Robinson', '7890 Cedar Dr', 'Anycity', 'NY', '89012', 'USA')


SELECT * FROM [dbo].[customer]

SELECT * FROM [dbo].[demographics]

SELECT * FROM [dbo].[PremiumSubscription]