                                                             -- Petpals

-- 1. Provide a SQL script that initializes the database for the Pet Adoption Platform ”PetPals”.
create database if not exists petpals;
use petpals;


-- 2. Create tables for pets, shelters, donations, adoption events, and participants.

-- Pets table
create table if not exists pets(
petID int primary key,
Name varchar (50) not null, 
age int not null, 
breed varchar(30) not null, 
type varchar(20) not null, 
availableforadoption bit not null
);

-- Shelters table
create table if not exists shelters(
shelterID int primary key, 
Name varchar(50) not null,
location varchar(50) not null
);

-- Donations table
create table if not exists donations(
donationId int primary Key, 
DonorName varchar(30) not null,
DonationType varchar(20) check(DonationType in('cash','Item')),
DonationAmount decimal(10,2) check(DonationAmount>=0),
DonationItem varchar(30) not null, 
DonationDate datetime not null
);

-- AdoptionEvents table
create table if not exists AdoptionEvents(
EventID int primary key, 
Eventname varchar(30) not null,
EventDate datetime not null,
Location varchar(30) not null
);

-- participants table
create table if not exists Participants (
ParticipantID int primary key, 
ParticipantName varchar(20) not null,
ParticipantType varchar(20) not null check (ParticipantType IN ('Shelter', 'Adopter')),
EventID int not null,
FOREIGN KEY (EventID) REFERENCES AdoptionEvents(EventID) ON DELETE CASCADE
);

-- 3. Define appropriate primary keys, foreign keys, and constraints. 

-- we have already defined appropriate primary keys, foreign key and constraints successfully.

-- 4. Ensure the script handles potential errors, such as if the database or tables already exist.

-- The database and Each table handle the potential errors.

-- 5. Write an SQL query that retrieves a list of available pets (those marked as available for adoption) from the "Pets" table. 
-- Include the pet's name, age, breed, and type in the result set. Ensure that the query filters out pets that are not available for adoption

-- Insert some datas to each table
INSERT INTO Pets (PetID, Name, Age, Breed, Type, AvailableForAdoption) VALUES
(101, 'Buddy', 2, 'Labrador', 'Dog', 1),
(102, 'Kitty', 3, 'Persian', 'Cat', 1),
(103, 'Rocky', 5, 'German Shepherd', 'Dog', 0),
(104, 'Snowy', 1, 'Siberian Husky', 'Dog', 1),
(105, 'Whiskers', 4, 'Bengal', 'Cat', 1);

INSERT INTO Shelters (ShelterID, Name, Location) VALUES
(1, 'Happy Paws Shelter', 'Chennai'),
(2, 'Purrfect Home', 'Bangalore'),
(3, 'Furry Friends', 'Hyderabad'),
(4, 'Tail Waggers', 'Mumbai'),
(5, 'Safe Haven', 'Delhi');

INSERT INTO Donations (DonationID, DonorName, DonationType, DonationAmount, DonationItem, DonationDate) VALUES
(201, 'Alice', 'Cash', 5000.00, 'Cash Donation', '2024-03-10 10:30:00'),
(202, 'Bob', 'Item', '2000.00', 'Dog Food', '2024-03-12 15:45:00'),
(203, 'Charlie', 'Cash', 2000.00, 'Cash Donation', '2024-03-14 09:20:00'),
(204, 'David', 'Item', 9000.00, 'Cat Toys', '2024-03-15 11:10:00'),
(205, 'Emma', 'Cash', 7000.00, 'Cash Donation', '2024-03-18 14:00:00');
 
INSERT INTO AdoptionEvents (EventID, EventName, EventDate, Location) VALUES
(301, 'Pet Fair 2024', '2024-04-10 10:00:00', 'Chennai'),
(302, 'Adoption Drive', '2024-05-15 11:00:00', 'Bangalore'),
(303, 'Rescue Meet', '2024-06-20 09:30:00', 'Hyderabad'),
(304, 'Furry Friends Day', '2024-07-25 13:00:00', 'Mumbai'),
(305, 'Happy Tails Event', '2024-08-30 12:00:00', 'Delhi');

INSERT INTO Participants (ParticipantID, ParticipantName, ParticipantType, EventID) VALUES
(501, 'Happy Paws Shelter', 'Shelter', 301),
(502, 'Purrfect Home', 'Shelter', 302),
(503, 'John Doe', 'Adopter', 303),
(504, 'Jane Smith', 'Adopter', 304),
(505, 'Tail Waggers', 'Shelter', 305);

select name,age,breed from pets where availableforadoption=1;  

-- 6. Write an SQL query that retrieves the names of participants (shelters and adopters) registered for a specific adoption event.
-- Use a parameter to specify the event ID. Ensure that the query joins the necessary tables to retrieve the participant names and types.

SET @var=303;
select p.participantName,P.participantType from participants p join adoptionevents a on p.eventId=a.eventId
where p.eventId=@var;

-- 7. Create a stored procedure in SQL that allows a shelter to update its information (name and location) in the "Shelters" table.
--  Use parameters to pass the shelter ID and the new information.
-- Ensure that the procedure performs the update and handles potential errors, such as an invalid shelter ID.

Delimiter //
create procedure Updateshelters(in U_shelterID int,in U_Name varchar(30),in U_location varchar(30))
begin
	update shelters set name=U_name, location=U_location where shelterID=U_shelterID;
end// 
delimiter ;

call Updateshelters(2,'MotherTeresa','Assam');

-- 8. Write an SQL query that calculates and retrieves the total donation amount for each shelter (by shelter name) from the "Donations" table. 
-- The result should include the shelter name and the total donation amount. 
-- Ensure that the query handles cases where a shelter has received no donations.

--  there was no Shelterid column int the Donations table, 
-- so i've added shelterId to the Donations table to join the shelter and donations table.

alter table Donations add column ShelterID int;
alter table Donations Add constraint fk_shelter_donations 
FOREIGN KEY (ShelterID) REFERENCES Shelters(ShelterID);

UPDATE Donations SET ShelterID = 1 WHERE DonationID = 201;UPDATE Donations SET ShelterID = 2 WHERE DonationID = 202;
UPDATE Donations SET ShelterID = 3 WHERE DonationID = 203;UPDATE Donations SET ShelterID = 4 WHERE DonationID = 204;
UPDATE Donations SET ShelterID = 5 WHERE DonationID = 205;

select name, sum(donationAmount) as donation from shelters s join donations d on s.shelterID=d.shelterID group by s.name;


-- 9. Write an SQL query that retrieves the names of pets from the "Pets" table that do not have an owner (i.e., where "OwnerID" is null). 
-- Include the pet's name, age, breed, and type in the result set.

-- There is no column called ownerId. Assuming there is ownerId in pets table
select name, age , breed, type from pets where ownerId is null;  


-- 10. Write an SQL query that retrieves the total donation amount for each month and year (e.g., January 2023) from the "Donations" table. 
-- The result should include the month-year and the corresponding total donation amount. 
-- Ensure that the query handles cases where no donations were made in a specific month-year.

select date_format(donationdate, '%M %Y') as monthyear, coalesce(sum(donationamount),0) as totaldonation from donations
group by monthyear;


-- 11. Retrieve a list of distinct breeds for all pets that are either aged between 1 and 3 years or older than 5 years.
select distinct(breed) from pets where (age between 1 and 3) OR age>5;  

-- 12. Retrieve a list of pets and their respective shelters where the pets are currently available for adoption.

--  there was no Shelterid column int the pets table, 
-- so i've added shelterId to the pets table to join the shelter and pets table.
alter table pets add column ShelterID int;
alter table pets Add constraint fk_shelter_pets 
FOREIGN KEY (ShelterID) REFERENCES Shelters(ShelterID);

UPDATE pets SET ShelterID = 1 WHERE petID = 101;UPDATE pets SET ShelterID = 2 WHERE petID = 102;
UPDATE pets SET ShelterID = 3 WHERE petID = 103;UPDATE pets SET ShelterID = 4 WHERE petID = 104;
UPDATE pets SET ShelterID = 5 WHERE petID = 105;

select p.name as petname , s.name as sheltername from pets p join shelters s on p.shelterId=s.shelterId where p.availableforadoption=1;

-- 13. Find the total number of participants in events organized by shelters located in specific city. Example: City=Chennai

set @City = 'Chennai';
SELECT COUNT(*) AS TotalParticipants FROM Participants p JOIN Shelters s ON p.ParticipantName = s.Name
WHERE s.Location=@city;

-- 14. Retrieve a list of unique breeds for pets with ages between 1 and 5 years.
select distinct(breed) from pets where age between 1 and 5;    

-- 15. Find the pets that have not been adopted by selecting their information from the 'Pet' table

-- Assuming available means not adopted
SELECT * FROM Pets WHERE AvailableForAdoption = 1;   

-- 16. Retrieve the names of all adopted pets along with the adopter's name from the 'Adoption' and 'User' tables.

-- Assuming there's an Adoption table and User table
SELECT p.Name AS AdoptedPetName, u.Name AS AdopterName FROM Adoption a JOIN Pets p ON a.PetID = p.PetID
JOIN Users u ON a.UserID = u.UserID;

-- 17. Retrieve a list of all shelters along with the count of pets currently available for adoption in each shelter

select s.name as sheltername, count(p.petID) as petcount from shelters s left join pets p on s.shelterID=p.shelterId
where p.availableforadoption=1 group by s.name;

-- 18. Find pairs of pets from the same shelter that have the same breed.
SELECT p1.Name AS Pet1, p2.Name AS Pet2, p1.Breed
FROM Pets p1
JOIN Pets p2 ON p1.ShelterID = p2.ShelterID AND p1.PetID <> p2.PetID
WHERE p1.Breed = p2.Breed;

select p1.name as pet1 , p2.name as pet2 , p1.breed from pets p1 join pets p2 on p1.shelterId = p2.shelterID and p1.petID<>p2.petID
where p1.breed=p2.breed;

-- 19. List all possible combinations of shelters and adoption events.
select s.name as s_name , e.eventname as e_name from shelters s cross join adoptionevents e;

-- 20. Determine the shelter that has the highest number of adopted pets.

select s.shelterid, s.name as sheltername, count(p.petid) as adoptedpets from shelters s join pets p on s.shelterid =p.shelterid
where p.availableforadoption =0 group by s.shelterid, s.name 
order by adoptedpets desc limit 1;
