/* 
multi
line
comment
*/

-- --------------------------------------------------- daavase quries---------------------------------------------------------------
-- to create dtavbase consulting fire management

create database indianarmy;

-- ---------------------------------------------------- database analysis-------------------------------------------------

-- table 1. officers
CREATE TABLE officers (
    officer_id INT PRIMARY KEY,
    name VARCHAR(100),
    rank VARCHAR(50),
    age INT,
    gender CHAR(1),
    commission_date DATE,
    posting_location VARCHAR(100),
    branch VARCHAR(50),
    contact_number VARCHAR(15),
    email VARCHAR(100)
);

-- insert. 20 record into officers
INSERT INTO officers 
VALUES
(1, 'Rajeev Sharma', 'Colonel', 45, 'M', '2005-06-01', 'Delhi HQ', 'Infantry', '9876543210', 'rajeev.sharma@army.in'),
(2, 'Anita Desai', 'Major', 38, 'F', '2010-08-15', 'Jaipur Base', 'Signals', '9812345678', 'anita.desai@army.in'),
(3, 'Vikram Singh', 'Lieutenant', 28, 'M', '2018-03-25', 'Kashmir Post', 'Artillery', '9898765432', 'vikram.singh@army.in'),
(4, 'Priya Mehra', 'Captain', 32, 'F', '2015-10-12', 'Chennai Base', 'Medical', '9776543210', 'priya.mehra@army.in'),
(5, 'Amit Khanna', 'Major', 40, 'M', '2008-01-05', 'Pune Base', 'Infantry', '9751234567', 'amit.khanna@army.in'),
(6, 'Rohit Verma', 'Colonel', 48, 'M', '2000-11-30', 'Kargil HQ', 'Armoured', '9823412345', 'rohit.verma@army.in'),
(7, 'Sneha Reddy', 'Lieutenant', 27, 'F', '2020-06-20', 'Srinagar HQ', 'Signals', '9711111222', 'sneha.reddy@army.in'),
(8, 'Deepak Nair', 'Major General', 52, 'M', '1995-09-01', 'Delhi HQ', 'Administration', '9800012345', 'deepak.nair@army.in'),
(9, 'Ramesh Patil', 'Brigadier', 50, 'M', '1997-07-19', 'Mumbai Base', 'Artillery', '9785612345', 'ramesh.patil@army.in'),
(10, 'Kiran Joshi', 'Captain', 33, 'F', '2013-05-22', 'Kolkata HQ', 'Medical', '9898123456', 'kiran.joshi@army.in'),
(11, 'Siddharth Rao', 'Lieutenant Colonel', 42, 'M', '2006-02-28', 'Jodhpur Post', 'Infantry', '9734217890', 'siddharth.rao@army.in'),
(12, 'Neha Sharma', 'Major', 35, 'F', '2011-09-10', 'Ahmedabad Camp', 'Engineering', '9763412567', 'neha.sharma@army.in'),
(13, 'Harshad Patel', 'Captain', 31, 'M', '2014-07-01', 'Leh Base', 'Signals', '9743219876', 'harshad.patel@army.in'),
(14, 'Sunil Gupta', 'Colonel', 46, 'M', '2004-04-14', 'Nagpur HQ', 'Infantry', '9723456987', 'sunil.gupta@army.in'),
(15, 'Meera Das', 'Lieutenant', 26, 'F', '2021-01-18', 'Shimla Post', 'Medical', '9734517890', 'meera.das@army.in'),
(16, 'Naveen Bhat', 'Major', 39, 'M', '2009-12-25', 'Guwahati Base', 'Armoured', '9756123789', 'naveen.bhat@army.in'),
(17, 'Alok Tiwari', 'Lieutenant Colonel', 44, 'M', '2003-03-05', 'Bhopal HQ', 'Engineering', '9798765432', 'alok.tiwari@army.in'),
(18, 'Ritika Sinha', 'Captain', 34, 'F', '2012-11-14', 'Dehradun HQ', 'Medical', '9709876543', 'ritika.sinha@army.in'),
(19, 'Ajay Kumar', 'Brigadier', 49, 'M', '1998-05-23', 'Pathankot Base', 'Infantry', '9712349876', 'ajay.kumar@army.in'),
(20, 'Tanya Roy', 'Lieutenant', 25, 'F', '2022-08-01', 'Imphal Post', 'Signals', '9701234567', 'tanya.roy@army.in');
select * from officers;
 
drop table  officers;

 truncate table officers ;
 
-- table 2. soldiers

CREATE TABLE soldiers (
    soldier_id INT PRIMARY KEY,
    name VARCHAR(100),
    rank VARCHAR(50),
    age INT,
    gender CHAR(1),
    join_date DATE,
    unit VARCHAR(100),
    posting_location VARCHAR(100),
    contact_number VARCHAR(15),
    email VARCHAR(100)
);

-- insert. 20 record into soldiers
INSERT INTO soldiers 
VALUES
(1, 'Amit Verma', 29, 'M', 'Havildar', '2nd Battalion', '2015-08-01', 'Siachen', '9887654321', 'O+'),
(2, 'Rahul Singh', 32, 'M', 'Naik', '3rd Battalion', '2013-05-20', 'Leh', '9765432109', 'B+'),
(3, 'Suresh Kumar', 30, 'M', 'Lance Naik', '4th Battalion', '2016-04-10', 'Kargil', '9876543212', 'A+'),
(4, 'Ravi Yadav', 27, 'M', 'Sepoy', '1st Battalion', '2018-09-01', 'Jammu', '9812345678', 'O-'),
(5, 'Karan Thakur', 34, 'M', 'Havildar', '5th Battalion', '2011-03-15', 'Leh', '9756432189', 'B+'),
(6, 'Pankaj Rawat', 26, 'M', 'Sepoy', '2nd Battalion', '2019-11-12', 'Manali', '9778899001', 'AB+'),
(7, 'Ajay Saini', 31, 'M', 'Naik', '6th Battalion', '2014-07-25', 'Dehradun', '9787654321', 'A-'),
(8, 'Vijay Chauhan', 28, 'M', 'Sepoy', '3rd Battalion', '2017-02-17', 'Kolkata', '9765124789', 'B-'),
(9, 'Rohit Patil', 29, 'M', 'Lance Naik', '1st Battalion', '2016-06-30', 'Ahmedabad', '9745234567', 'O+'),
(10, 'Nitin Das', 33, 'M', 'Havildar', '4th Battalion', '2012-12-05', 'Chennai', '9734567890', 'A+'),
(11, 'Abhishek Rana', 25, 'M', 'Sepoy', '7th Battalion', '2020-01-01', 'Nagpur', '9723456789', 'AB-'),
(12, 'Sanjay Jadhav', 30, 'M', 'Naik', '5th Battalion', '2015-10-10', 'Pune', '9712349876', 'B+'),
(13, 'Mahesh Gowda', 27, 'M', 'Sepoy', '6th Battalion', '2018-03-28', 'Bangalore', '9709876543', 'O+'),
(14, 'Rakesh Meena', 31, 'M', 'Lance Naik', '2nd Battalion', '2014-09-09', 'Srinagar', '9698765432', 'A+'),
(15, 'Dinesh Singh', 29, 'M', 'Naik', '3rd Battalion', '2016-11-11', 'Ladakh', '9687654321', 'B-'),
(16, 'Manoj Kumar', 26, 'M', 'Sepoy', '1st Battalion', '2019-07-04', 'Shimla', '9676543210', 'O-'),
(17, 'Prakash Joshi', 32, 'M', 'Havildar', '5th Battalion', '2013-05-21', 'Jalandhar', '9665432190', 'AB+'),
(18, 'Sunil Rathore', 28, 'M', 'Lance Naik', '4th Battalion', '2017-08-19', 'Imphal', '9654321879', 'B+'),
(19, 'Ashok Pandey', 30, 'M', 'Naik', '6th Battalion', '2015-02-14', 'Lucknow', '9643218765', 'A-'),
(20, 'Gaurav Mishra', 27, 'M', 'Sepoy', '7th Battalion', '2021-06-01', 'Guwahati', '9632187654', 'O+');
select * from soldiers;
 
drop table soldiers ;

 truncate table soldiers;
 
-- table 3. battalions
CREATE TABLE battalions (
    battalion_id INT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    commander VARCHAR(100),
    soldiers_count INT,
    vehicles_count INT,
    creation_date DATE,
    region VARCHAR(100),
    status VARCHAR(50),
    remarks TEXT
);

-- insert. 20 record into battalions
INSERT INTO battalions 
VALUES
(1, '1st Infantry Battalion', 'Srinagar', 'Col. Rajeev Sharma', 800, 40, '1985-06-15', 'Northern Command', 'Active', 'Deployed for high-altitude security.'),
(2, '2nd Artillery Battalion', 'Leh', 'Col. Manish Rathi', 700, 35, '1990-03-20', 'Northern Command', 'Active', 'Supports artillery operations in border areas.'),
(3, '3rd Armoured Battalion', 'Jaisalmer', 'Col. Rohit Verma', 650, 50, '1995-11-30', 'Western Command', 'Active', 'Desert warfare unit.'),
(4, '4th Signals Battalion', 'Chandigarh', 'Lt. Col. Neha Sharma', 500, 25, '2001-04-10', 'Western Command', 'Active', 'Handles communication and tech systems.'),
(5, '5th Engineers Battalion', 'Pune', 'Col. Alok Tiwari', 550, 20, '1998-12-05', 'Southern Command', 'Active', 'Construction and demolitions team.'),
(6, '6th Medical Battalion', 'Delhi Cantt', 'Col. Priya Mehra', 400, 10, '2003-08-21', 'Central Command', 'Active', 'Medical and trauma care in field camps.'),
(7, '7th Infantry Battalion', 'Siachen', 'Col. Vikas Sharma', 750, 30, '2005-10-12', 'Northern Command', 'Active', 'Mountain warfare and glacier patrols.'),
(8, '8th Infantry Battalion', 'Udhampur', 'Lt. Col. Ravi Chauhan', 720, 28, '2000-07-01', 'Northern Command', 'Active', 'Involved in counter-insurgency.'),
(9, '9th Artillery Battalion', 'Barmer', 'Col. Naresh Joshi', 680, 38, '1992-09-17', 'Western Command', 'Active', 'Heavy artillery fire support.'),
(10, '10th Armoured Battalion', 'Bathinda', 'Col. Akshay Jadhav', 600, 60, '1997-01-30', 'Western Command', 'Active', 'Tank operations in border sectors.'),
(11, '11th Signals Battalion', 'Hyderabad', 'Lt. Col. Sneha Reddy', 510, 18, '2006-05-12', 'Southern Command', 'Active', 'Supports tech infrastructure in south.'),
(12, '12th Engineers Battalion', 'Nagpur', 'Lt. Col. Deepak Nair', 540, 22, '1994-10-04', 'Central Command', 'Active', 'Fortification and obstacle clearance.'),
(13, '13th Medical Battalion', 'Lucknow', 'Col. Ritika Sinha', 430, 8, '2008-02-18', 'Central Command', 'Active', 'Manages regional hospitals and trauma.'),
(14, '14th Infantry Battalion', 'Kargil', 'Col. Suresh Yadav', 790, 32, '1987-11-03', 'Northern Command', 'Active', 'Deployed for LAC security patrols.'),
(15, '15th Infantry Battalion', 'Pathankot', 'Col. Bhupendra Rana', 730, 36, '1991-04-28', 'Western Command', 'Active', 'Quick reaction force.'),
(16, '16th Artillery Battalion', 'Ganganagar', 'Col. Mohit Pandey', 670, 33, '1993-08-08', 'Western Command', 'Active', 'Long-range artillery units.'),
(17, '17th Signals Battalion', 'Bhopal', 'Lt. Col. Tanya Roy', 490, 16, '2009-12-15', 'Central Command', 'Active', 'Encrypted communications operations.'),
(18, '18th Engineers Battalion', 'Ranchi', 'Col. Sunil Gupta', 560, 19, '1996-06-25', 'Eastern Command', 'Active', 'Bridge building and combat engineering.'),
(19, '19th Armoured Battalion', 'Jodhpur', 'Col. Harshad Patel', 620, 55, '2002-03-11', 'Western Command', 'Active', 'Tank defense and heavy vehicle squad.'),
(20, '20th Infantry Battalion', 'Imphal', 'Col. Ajay Kumar', 710, 34, '2004-09-29', 'Eastern Command', 'Active', 'Patrolling and border enforcement.');

select * from battalions ;
 
drop table battalions ;

 truncate table battalions;

-- table 4. training_centers
CREATE TABLE training_centers (
    center_id INT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    established_year INT,
    in_charge VARCHAR(100),
    trainee_capacity INT,
    courses_offered VARCHAR(255),
    contact_email VARCHAR(100),
    phone_number VARCHAR(15),
    status VARCHAR(50)
);
-- insert. 20 record into training_centers
INSERT INTO training_centers
 VALUES
(1, 'Infantry School Mhow', 'Mhow, Madhya Pradesh', 1947, 'Brig. S. Thakur', 1500, 'Infantry Tactics, Jungle Warfare', 'infantry.mhow@army.in', '07312456789', 'Active'),
(2, 'Artillery School Devlali', 'Devlali, Maharashtra', 1924, 'Maj. Gen. P. Desai', 1300, 'Artillery Gunnery, Survey', 'artillery.devlali@army.in', '02532567891', 'Active'),
(3, 'Armoured Corps Centre', 'Ahmednagar, Maharashtra', 1923, 'Col. A. Kulkarni', 1000, 'Tank Operations, Armoured Warfare', 'armoured.ahmednagar@army.in', '02412234567', 'Active'),
(4, 'Army Airborne Training School', 'Agra, Uttar Pradesh', 1985, 'Col. V. Mehta', 800, 'Paratrooper Training, Freefall', 'airborne.agra@army.in', '05622489012', 'Active'),
(5, 'Counter-Insurgency School', 'Vairengte, Mizoram', 1970, 'Brig. R. Sharma', 900, 'CI Ops, Guerrilla Tactics', 'ci.vairengte@army.in', '03892478901', 'Active'),
(6, 'High Altitude Warfare School', 'Gulmarg, J&K', 1948, 'Col. N. Singh', 700, 'Snow Warfare, Avalanche Rescue', 'haws.gulmarg@army.in', '01954234566', 'Active'),
(7, 'Army Medical Corps Training College', 'Lucknow, Uttar Pradesh', 1962, 'Brig. Dr. A. Menon', 600, 'Battlefield Medicine, Emergency Surgery', 'amc.lucknow@army.in', '05222435678', 'Active'),
(8, 'Army Education Corps Training College', 'Pachmarhi, Madhya Pradesh', 1949, 'Col. M. Rathi', 500, 'Military Instruction, Pedagogy', 'aec.pachmarhi@army.in', '07480231245', 'Active'),
(9, 'College of Military Engineering', 'Pune, Maharashtra', 1943, 'Maj. Gen. R. Iyer', 2000, 'Bridging, Mine Warfare', 'cme.pune@army.in', '02025677899', 'Active'),
(10, 'Signal Training Centre', 'Jabalpur, Madhya Pradesh', 1955, 'Col. T. Roy', 1000, 'Radio Ops, Satellite Comms', 'signals.jabalpur@army.in', '07612567890', 'Active'),
(11, 'Army Aviation Training School', 'Nasik, Maharashtra', 2000, 'Col. D. Yadav', 450, 'Chopper Piloting, UAV Ops', 'aviation.nasik@army.in', '02532456789', 'Active'),
(12, 'Army Intelligence School', 'Pune, Maharashtra', 1976, 'Col. H. Das', 400, 'Reconnaissance, Cyber Intel', 'intel.pune@army.in', '02024238900', 'Active'),
(13, 'Army Physical Training School', 'Pune, Maharashtra', 1944, 'Lt. Col. G. Patil', 350, 'Combat Fitness, Endurance Training', 'pt.pune@army.in', '02024455678', 'Active'),
(14, 'Army School of Signals', 'Jabalpur, MP', 1911, 'Maj. Gen. R. Pandey', 1200, 'Signal Planning, EW', 'sigs.jabalpur@army.in', '07612345670', 'Active'),
(15, 'Army Training Command (ARTRAC)', 'Shimla, Himachal Pradesh', 1991, 'Lt. Gen. V. Chauhan', 1100, 'All-Arms Coordination, Doctrine Dev.', 'artrac.shimla@army.in', '01772654321', 'Active'),
(16, 'Army Cadet College Wing', 'Dehradun, Uttarakhand', 1960, 'Col. A. Rawat', 600, 'Officer Commission Prep', 'acc.dehradun@army.in', '01352647891', 'Active'),
(17, 'Junior Leaders Academy', 'Bareilly, Uttar Pradesh', 1958, 'Brig. Y. Sinha', 550, 'Junior Command Courses', 'jla.bareilly@army.in', '05812456789', 'Active'),
(18, 'Army Air Defence College', 'Gopalpur, Odisha', 1989, 'Maj. Gen. K. Das', 900, 'Missile Systems, Radar Ops', 'aad.gopalpur@army.in', '06802456789', 'Active'),
(19, 'Military Intelligence School', 'Ahmednagar, Maharashtra', 1981, 'Col. Z. Sheikh', 400, 'Surveillance, Interrogation', 'mi.ahmednagar@army.in', '02412222222', 'Active'),
(20, 'Army Law College', 'Pune, Maharashtra', 2017, 'Brig. J. Deshmukh', 300, 'Military Law, Court Martial Procedure', 'lawcollege.pune@army.in', '02024440000', 'Active');
select * from training_centers;
 
drop table  training_centers;

 truncate table training_centers;

-- table 5. weapons

CREATE TABLE weapons (
    weapon_id INT PRIMARY KEY,
    name VARCHAR(100),
    type VARCHAR(50),
    model VARCHAR(50),
    manufacturer VARCHAR(100),
    range_km DECIMAL(6,2),
    quantity INT,
    assigned_unit VARCHAR(100),
    status VARCHAR(50),
    remarks TEXT
);
-- insert. 20 record into weapons

INSERT INTO weapons 
VALUES
(1, 'INSAS Rifle', 'Rifle', '1B1', 'OFB India', 0.40, 500, '2nd Infantry Battalion', 'Active', 'Standard issue for infantry troops'),
(2, 'T-90 Bhishma', 'Tank', 'T-90S', 'Russia/India', 5.00, 60, '3rd Armoured Battalion', 'Active', 'Main battle tank in active deployment'),
(3, 'AK-47', 'Rifle', 'AKM', 'Russia', 0.35, 100, '4th Infantry Battalion', 'Active', 'Used for counter-insurgency ops'),
(4, 'Bofors FH77', 'Howitzer', '155mm', 'Sweden', 30.00, 20, '2nd Artillery Battalion', 'Active', 'Long-range artillery support'),
(5, 'Pinaka MBRL', 'Rocket Launcher', 'Mark-1', 'DRDO India', 40.00, 12, '5th Artillery Battalion', 'Active', 'Multi-barrel rocket launcher system'),
(6, 'Nag ATGM', 'Missile', 'ATGM', 'DRDO India', 4.00, 30, 'Anti-Tank Unit Alpha', 'Active', 'Used against enemy tanks'),
(7, 'Dhanush Howitzer', 'Howitzer', '155mm', 'OFB India', 38.00, 15, '6th Artillery Battalion', 'Active', 'Indigenous upgraded Bofors version'),
(8, 'AK-203', 'Rifle', 'Kalashnikov', 'India-Russia', 0.40, 600, '1st Infantry Battalion', 'In Procurement', 'To replace INSAS'),
(9, 'BrahMos', 'Cruise Missile', 'Block-I', 'India-Russia', 290.00, 8, 'Strategic Missile Command', 'Active', 'Supersonic cruise missile'),
(10, 'Arjun Mk1A', 'Tank', 'Mk1A', 'DRDO India', 4.50, 40, '4th Armoured Battalion', 'Trial Phase', 'Next-gen Indian tank'),
(11, 'MP-5', 'SMG', 'MP5-N', 'Germany', 0.15, 50, 'Special Forces Unit', 'Active', 'Used for CQB operations'),
(12, 'SIG716', 'Rifle', 'SIG716i', 'USA', 0.60, 200, 'Mountain Warfare Unit', 'Active', 'High altitude deployment'),
(13, 'IWI Tavor', 'Rifle', 'X95', 'Israel', 0.50, 150, 'Para SF Battalion', 'Active', 'Standard SF weapon'),
(14, 'M777 Ultra-Light Howitzer', 'Howitzer', '155mm', 'USA', 24.70, 25, 'High Altitude Artillery Unit', 'Active', 'Deployed in mountainous terrain'),
(15, 'SPG Dragunov', 'Sniper Rifle', 'SVD', 'Russia', 0.80, 70, 'Sniper Unit Delta', 'Active', 'Marksman sniper teams'),
(16, 'QBU-88', 'Sniper Rifle', '5.8mm', 'China (captured)', 0.80, 5, 'Intelligence Unit', 'In Testing', 'Captured during ops'),
(17, 'Carl Gustaf', 'Rocket Launcher', 'M4', 'Sweden', 0.25, 120, 'Anti-Tank Unit Bravo', 'Active', 'Man-portable rocket system'),
(18, 'RPG-7', 'Launcher', 'RPG-7V2', 'Russia', 0.30, 100, 'Urban Combat Unit', 'Active', 'Used in insurgency-prone zones'),
(19, 'SVD Dragunov', 'Sniper Rifle', '7.62mm', 'Russia', 1.00, 60, 'Recon Unit Foxtrot', 'Active', 'Long-range target elimination'),
(20, 'AK-74', 'Rifle', 'AK-74M', 'Russia', 0.45, 300, '5th Infantry Battalion', 'Reserve', 'Used in training and reserve units');
select * from weapons  ;
 
drop table weapons ;

 truncate table weapons ;

-- table 6. missions
CREATE TABLE missions (
    mission_id INT PRIMARY KEY,
    name VARCHAR(100),
    type VARCHAR(50),
    start_date DATE,
    end_date DATE,
    location VARCHAR(100),
    commander VARCHAR(100),
    objective TEXT,
    status VARCHAR(50),
    remarks TEXT
);

-- insert. 20 record into  missions 
INSERT INTO missions 
VALUES
(1, 'Operation Snowstorm', 'Combat', '2022-12-01', '2023-01-15', 'Siachen Glacier', 'Col. Rajeev Sharma', 'Secure strategic posts at high altitude.', 'Completed', 'Successful with minimal casualties.'),
(2, 'Operation Sand Dune', 'Training', '2023-03-05', '2023-03-20', 'Jaisalmer', 'Lt. Col. Manish Rathi', 'Desert warfare and mobility exercises.', 'Completed', 'Joint exercise with artillery units.'),
(3, 'Operation Trident Shield', 'Reconnaissance', '2023-04-01', '2023-04-10', 'LoC, Poonch Sector', 'Col. Vikram Singh', 'Gather intel on enemy movement.', 'Completed', 'Vital intel collected.'),
(4, 'Operation Vayu Shakti', 'Air Support', '2023-06-01', '2023-06-03', 'Pokhran', 'Col. A. Khanna', 'Coordinate air-ground attack simulation.', 'Completed', 'Joint exercise with IAF.'),
(5, 'Operation Iron Wall', 'Defensive', '2022-10-20', '2022-11-15', 'Ladakh', 'Col. R. Verma', 'Establish and fortify border defenses.', 'Completed', 'New bunkers constructed.'),
(6, 'Operation Clean Sweep', 'Anti-Terror', '2023-02-01', '2023-02-12', 'Kupwara', 'Lt. Col. Sneha Reddy', 'Flush out terrorist hideouts.', 'Completed', 'High-risk but successful op.'),
(7, 'Operation Swift Justice', 'Rescue', '2023-05-10', '2023-05-12', 'Himachal Flood Zone', 'Col. Priya Mehra', 'Rescue civilians trapped in landslide.', 'Completed', 'Army-medical team deployed.'),
(8, 'Operation Red Alert', 'Combat', '2023-07-01', NULL, 'Nagaland', 'Brig. R. Patil', 'Neutralize insurgent camps.', 'Ongoing', 'Infiltration attempts being tracked.'),
(9, 'Exercise Yudh Abhyas', 'Training', '2023-09-15', '2023-10-01', 'Uttrakhand', 'Col. Siddharth Rao', 'Joint India-US military drill.', 'Scheduled', 'Preparations underway.'),
(10, 'Operation Eastern Shield', 'Border Patrol', '2023-01-01', '2023-01-31', 'Arunachal Pradesh', 'Col. Kiran Joshi', 'Enhanced patrolling of eastern borders.', 'Completed', 'Low-level skirmishes encountered.'),
(11, 'Operation Mountain Hawk', 'Surveillance', '2023-08-01', '2023-08-14', 'Kargil', 'Col. Harshad Patel', 'Deploy UAVs for surveillance.', 'Completed', 'Visual confirmation of enemy movement.'),
(12, 'Operation Black Thunder', 'Anti-Terror', '2023-06-10', '2023-06-20', 'Punjab Border', 'Col. Sunil Gupta', 'Counter-smuggling and arms recovery.', 'Completed', 'Explosives and weapons seized.'),
(13, 'Operation Silent Strike', 'Special Forces', '2023-05-01', '2023-05-04', 'PoK Border', 'Maj. Vikram Rathore', 'Surgical strike on terror camps.', 'Completed', 'Executed with precision.'),
(14, 'Operation Desert Flame', 'Tank Warfare', '2023-11-01', '2023-11-14', 'Barmer', 'Col. Mohit Pandey', 'Tank battalion maneuver training.', 'Scheduled', 'Part of annual exercise.'),
(15, 'Operation Sea Breeze', 'Naval Coordination', '2023-07-15', '2023-07-20', 'Andaman & Nicobar', 'Col. A. Tiwari', 'Army-Navy amphibious ops.', 'Completed', 'First-of-its-kind training.'),
(16, 'Operation Lightning Strike', 'Combat', '2023-04-10', '2023-04-18', 'LoC, Rajouri', 'Col. Naveen Bhat', 'Rapid response to cross-border fire.', 'Completed', 'Successful containment.'),
(17, 'Operation White Flag', 'Peacekeeping', '2023-03-01', '2023-03-30', 'UN Mission - Congo', 'Brig. Deepak Nair', 'UN peacekeeping deployment.', 'Completed', 'International praise received.'),
(18, 'Operation Iron Net', 'Cyber Defense', '2023-08-10', '2023-08-15', 'Army HQ Delhi', 'Col. Neha Sharma', 'Simulated cyberattack and defense drill.', 'Completed', 'Upgraded cyber protocols.'),
(19, 'Operation Green Hills', 'Environmental', '2023-06-01', '2023-06-30', 'Northeast Forest Regions', 'Col. Meera Das', 'Reforestation & patrol roads building.', 'Completed', 'CSR activity completed.'),
(20, 'Operation Northern Thunder', 'Artillery Drill', '2023-10-10', '2023-10-20', 'Leh', 'Col. R. Sinha', 'High-altitude firing practice.', 'Scheduled', 'Joint artillery coordination planned.');
select * from missions ;
 
drop table missions ;

 truncate table missions;
-- table 7. vehicles
CREATE TABLE vehicles (
    vehicle_id INT PRIMARY KEY,
    name VARCHAR(100),
    type VARCHAR(50),
    model VARCHAR(50),
    registration_no VARCHAR(50),
    capacity INT,
    status VARCHAR(50),
    assigned_unit VARCHAR(100),
    in_service_date DATE,
    remarks TEXT
);
-- insert. 20 record into vehicles 
INSERT INTO vehicles 
VALUES
(1, 'Tata LPTA 713 TC', 'Truck', 'LPTA', 'IND-ARMY-1001', 24, 'Active', '2nd Infantry Battalion', '2015-04-20', 'Used for troop transport'),
(2, 'Maruti Gypsy', 'Jeep', 'King HT', 'IND-ARMY-1002', 4, 'Active', 'HQ Logistics Unit', '2014-01-15', 'Used for officer movement'),
(3, 'T-90 Bhishma', 'Tank', 'T-90S', 'IND-ARMY-1003', 3, 'Active', '3rd Armoured Battalion', '2017-10-12', 'Main battle tank'),
(4, 'BMP-2 Sarath', 'IFV', 'Sarath MkII', 'IND-ARMY-1004', 8, 'Active', 'Mechanized Infantry Unit', '2016-07-01', 'Infantry fighting vehicle'),
(5, 'Scorpio Commando', 'SUV', '4x4', 'IND-ARMY-1005', 6, 'Active', 'Signals Unit Alpha', '2018-03-22', 'Field operations vehicle'),
(6, 'Ashok Leyland Stallion', 'Truck', '4x4', 'IND-ARMY-1006', 25, 'Active', 'Supply Unit Bravo', '2013-06-05', 'Logistics vehicle'),
(7, 'Mahindra Axe', 'Tactical Vehicle', 'AXE', 'IND-ARMY-1007', 4, 'Active', 'Special Forces', '2019-11-08', 'Light tactical deployment'),
(8, 'Dhanush Tractor', 'Artillery Tractor', 'DHT-77', 'IND-ARMY-1008', 2, 'Active', '4th Artillery Battalion', '2020-01-12', 'Pulls artillery guns'),
(9, 'ALM GAZ 3308', 'Utility Truck', 'Sadko', 'IND-ARMY-1009', 12, 'Inactive', 'Reserve Unit', '2011-12-25', 'Pending maintenance'),
(10, 'BEML Tatra', 'Heavy Truck', '8x8', 'IND-ARMY-1010', 35, 'Active', 'Rocket Launcher Unit', '2016-04-04', 'Carries Pinaka systems'),
(11, 'Tata Xenon', 'Pickup', '4x2', 'IND-ARMY-1011', 2, 'Active', 'Medical Response Team', '2017-07-15', 'Quick evacuation support'),
(12, 'Shaktiman Truck', 'Cargo Truck', 'Mk3', 'IND-ARMY-1012', 20, 'Decommissioned', 'NA', '2000-05-20', 'Out of service'),
(13, 'Tata Mine Protected Vehicle', 'MRAP', 'MPV', 'IND-ARMY-1013', 10, 'Active', 'Anti-Insurgency Unit', '2022-03-10', 'IED blast-resistant'),
(14, 'Storme GS800', 'SUV', 'Safari Storme', 'IND-ARMY-1014', 5, 'Active', 'Command Unit', '2019-08-20', 'Replacement for Gypsy'),
(15, 'DRDO Ambulance', 'Medical', 'Type-3', 'IND-ARMY-1015', 6, 'Active', 'Field Hospital Team', '2021-06-01', 'Advanced life support'),
(16, 'K9 Vajra-T', 'SP Gun', '155mm', 'IND-ARMY-1016', 5, 'Active', '9th Artillery Battalion', '2020-12-11', 'Self-propelled artillery'),
(17, 'Tracked Recovery Vehicle', 'Support', 'T-72 Based', 'IND-ARMY-1017', 3, 'Active', 'Armoured Repair Unit', '2015-05-30', 'Tank recovery missions'),
(18, 'Rajak UAV Carrier', 'Drone Support', 'UAV-Mount', 'IND-ARMY-1018', 2, 'Active', 'Drone Unit Echo', '2022-02-15', 'For drone launching and tracking'),
(19, 'Water Bowser Truck', 'Utility', '12KL', 'IND-ARMY-1019', 10, 'Active', 'Logistics Unit', '2016-08-25', 'Used for water transport'),
(20, 'Mobile Radar Vehicle', 'Surveillance', 'Radar-SR2', 'IND-ARMY-1020', 4, 'Active', 'Signal Intelligence Unit', '2021-09-01', 'Mounted radar systems');
select * from vehicles;
 
drop table  vehicles;

 truncate table vehicles;


-- table 8. medical_records

CREATE TABLE medical_records (
    record_id INT PRIMARY KEY,
    soldier_id INT,
    height VARCHAR(10),
    weight VARCHAR(10),
    blood_group VARCHAR(5),
    eye_sight VARCHAR(10),
    last_checkup DATE,
    allergies VARCHAR(100),
    injuries VARCHAR(100),
    doctor VARCHAR(100)
);


-- insert. 20 record into medical_records
INSERT INTO medical_records
 VALUES
(1, 1, '5\'10"', '70kg', 'O+', '6/6', '2024-12-01', 'None', 'None', 'Dr. A. Sharma'),
(2, 2, '5\'8"', '68kg', 'B+', '6/9', '2025-01-15', 'Dust', 'Minor ankle sprain', 'Dr. P. Verma'),
(3, 3, '5\'9"', '72kg', 'A+', '6/6', '2024-11-20', 'Pollen', 'Fractured wrist (healed)', 'Dr. N. Iyer'),
(4, 4, '5\'7"', '65kg', 'O-', '6/6', '2025-02-05', 'None', 'None', 'Dr. K. Rathi'),
(5, 5, '6\'0"', '75kg', 'B+', '6/12', '2025-03-10', 'Peanuts', 'None', 'Dr. S. Rao'),
(6, 6, '5\'6"', '60kg', 'AB+', '6/6', '2025-01-28', 'Penicillin', 'Burn scar (minor)', 'Dr. V. Das'),
(7, 7, '5\'9"', '69kg', 'A-', '6/6', '2024-12-22', 'None', 'Dislocated shoulder (recovered)', 'Dr. R. Mehta'),
(8, 8, '5\'11"', '80kg', 'B-', '6/6', '2025-03-02', 'None', 'Leg cramp episodes', 'Dr. A. Sinha'),
(9, 9, '5\'8"', '67kg', 'O+', '6/9', '2025-02-17', 'Shellfish', 'None', 'Dr. D. Reddy'),
(10, 10, '6\'1"', '82kg', 'A+', '6/6', '2025-01-10', 'None', 'Knee surgery (2019)', 'Dr. M. Sharma'),
(11, 11, '5\'7"', '64kg', 'AB-', '6/6', '2025-01-21', 'None', 'Shrapnel injury (minor)', 'Dr. J. Thakur'),
(12, 12, '5\'10"', '70kg', 'B+', '6/6', '2025-03-12', 'Latex', 'None', 'Dr. A. Nanda'),
(13, 13, '5\'9"', '74kg', 'O+', '6/6', '2024-11-15', 'None', 'Twisted knee (recovered)', 'Dr. T. Kumar'),
(14, 14, '5\'8"', '68kg', 'A+', '6/9', '2024-12-30', 'None', 'None', 'Dr. R. Joshi'),
(15, 15, '5\'10"', '71kg', 'B-', '6/6', '2025-01-06', 'Eggs', 'Back pain (recurring)', 'Dr. S. Rao'),
(16, 16, '5\'6"', '63kg', 'O-', '6/6', '2025-02-14', 'None', 'None', 'Dr. K. Bhatia'),
(17, 17, '6\'0"', '78kg', 'AB+', '6/6', '2024-12-05', 'None', 'Fractured toe', 'Dr. M. Pillai'),
(18, 18, '5\'9"', '69kg', 'B+', '6/6', '2025-03-08', 'Bee stings', 'None', 'Dr. L. Chakraborty'),
(19, 19, '5\'7"', '66kg', 'A-', '6/6', '2025-01-30', 'None', 'Bruised ribs', 'Dr. N. Sharma'),
(20, 20, '5\'11"', '76kg', 'O+', '6/6', '2025-03-18', 'None', 'Muscle strain', 'Dr. G. Desai');
select * from medical_records;
 
drop table  medical_records;

 truncate table medical_records;
 
 
-- table 9. leave_records

CREATE TABLE leave_records (
    leave_id INT PRIMARY KEY,
    soldier_id INT,
    start_date DATE,
    end_date DATE,
    type VARCHAR(50),
    approved_by VARCHAR(100),
    reason TEXT,
    status VARCHAR(50),
    application_date DATE,
    remarks TEXT
);

-- insert. 20 record into leave_records 
INSERT INTO leave_records VALUES
(1, 1, '2025-01-10', '2025-01-20', 'Annual Leave', 'Col. Rajeev Sharma', 'Family visit', 'Approved', '2024-12-15', 'Leave granted for 10 days'),
(2, 2, '2025-02-05', '2025-02-12', 'Medical Leave', 'Lt. Col. Manish Rathi', 'Knee pain treatment', 'Approved', '2025-01-28', 'Medical certificate attached'),
(3, 3, '2025-03-01', '2025-03-07', 'Casual Leave', 'Col. Vikram Singh', 'Personal work', 'Approved', '2025-02-20', 'No remarks'),
(4, 4, '2024-12-24', '2025-01-02', 'Annual Leave', 'Col. A. Khanna', 'Festive season with family', 'Approved', '2024-12-01', 'Return on time'),
(5, 5, '2025-03-15', '2025-03-18', 'Emergency Leave', 'Lt. Col. R. Verma', 'Father hospitalized', 'Approved', '2025-03-14', 'Urgent leave granted'),
(6, 6, '2025-01-01', '2025-01-10', 'Sick Leave', 'Col. S. Rao', 'Recurring fever', 'Approved', '2024-12-28', 'Medical leave approved'),
(7, 7, '2025-04-01', '2025-04-05', 'Casual Leave', 'Lt. Col. Sneha Reddy', 'Marriage in family', 'Approved', '2025-03-20', 'Leave granted'),
(8, 8, '2025-02-20', '2025-02-28', 'Annual Leave', 'Col. Priya Mehra', 'Home visit', 'Approved', '2025-01-30', '10 days leave sanctioned'),
(9, 9, '2025-03-10', '2025-03-12', 'Casual Leave', 'Col. D. Reddy', 'Government paperwork', 'Approved', '2025-03-01', 'Short leave'),
(10, 10, '2025-01-15', '2025-01-25', 'Medical Leave', 'Col. M. Sharma', 'Post-surgery recovery', 'Approved', '2025-01-10', 'Doctor note attached'),
(11, 11, '2025-03-20', '2025-03-22', 'Emergency Leave', 'Col. J. Thakur', 'Family accident', 'Approved', '2025-03-18', 'Granted immediately'),
(12, 12, '2025-02-01', '2025-02-03', 'Casual Leave', 'Col. A. Nanda', 'Travel for local function', 'Approved', '2025-01-25', 'Short leave granted'),
(13, 13, '2025-04-10', '2025-04-20', 'Annual Leave', 'Col. T. Kumar', 'Annual vacation', 'Pending', '2025-03-25', 'Awaiting final approval'),
(14, 14, '2025-03-05', '2025-03-08', 'Casual Leave', 'Col. R. Joshi', 'Bank/legal paperwork', 'Approved', '2025-02-28', 'Normal routine'),
(15, 15, '2025-02-15', '2025-02-22', 'Medical Leave', 'Col. S. Rao', 'Chronic back pain', 'Approved', '2025-02-10', 'Medical file updated'),
(16, 16, '2025-01-20', '2025-01-23', 'Casual Leave', 'Col. K. Bhatia', 'Family function', 'Approved', '2025-01-15', 'Leave granted'),
(17, 17, '2025-04-01', '2025-04-10', 'Annual Leave', 'Col. M. Pillai', 'Home visit after 8 months', 'Approved', '2025-03-10', '10 days approved'),
(18, 18, '2025-03-25', '2025-03-30', 'Emergency Leave', 'Col. L. Chakraborty', 'Flood in home village', 'Approved', '2025-03-24', 'Leave sanctioned on emergency basis'),
(19, 19, '2025-02-10', '2025-02-15', 'Sick Leave', 'Col. N. Sharma', 'Viral infection', 'Approved', '2025-02-08', 'Approved with certificate'),
(20, 20, '2025-01-05', '2025-01-10', 'Casual Leave', 'Col. G. Desai', 'Personal matters', 'Approved', '2024-12-25', 'Returned early from leave');

select * from leave_records;
 
drop table leave_records ;

 truncate table leave_records;


-- table 10. promotions

CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY,
    soldier_id INT,
    old_rank VARCHAR(50),
    new_rank VARCHAR(50),
    promotion_date DATE,
    approved_by VARCHAR(100),
    remarks TEXT,
    document_link VARCHAR(255),
    reason TEXT,
    status VARCHAR(50)
);

-- insert. 20 record into promotions 

INSERT INTO promotions
 VALUES
(1, 1, 'Sepoy', 'Lance Naik', '2022-03-15', 'Col. Rajeev Sharma', 'Good performance in field duties', 'docs/promotion1.pdf', 'Exemplary service', 'Approved'),
(2, 2, 'Lance Naik', 'Naik', '2021-11-10', 'Lt. Col. Manish Rathi', 'Leadership during training missions', 'docs/promotion2.pdf', 'Leadership potential', 'Approved'),
(3, 3, 'Naik', 'Havildar', '2023-01-25', 'Col. Vikram Singh', 'Outstanding physical fitness', 'docs/promotion3.pdf', 'Fitness excellence', 'Approved'),
(4, 4, 'Sepoy', 'Lance Naik', '2022-07-12', 'Col. A. Khanna', 'Field intelligence contribution', 'docs/promotion4.pdf', 'Exceptional intel work', 'Approved'),
(5, 5, 'Havildar', 'Naib Subedar', '2023-05-01', 'Lt. Col. R. Verma', 'Long-term service promotion', 'docs/promotion5.pdf', 'Seniority-based', 'Approved'),
(6, 6, 'Naik', 'Havildar', '2023-02-14', 'Col. S. Rao', 'Excellent logistics management', 'docs/promotion6.pdf', 'Logistics planning', 'Approved'),
(7, 7, 'Sepoy', 'Lance Naik', '2024-01-10', 'Lt. Col. Sneha Reddy', 'Saved lives in flood rescue', 'docs/promotion7.pdf', 'Bravery in rescue', 'Approved'),
(8, 8, 'Lance Naik', 'Naik', '2022-09-30', 'Col. Priya Mehra', 'Commendation by battalion commander', 'docs/promotion8.pdf', 'Meritorious conduct', 'Approved'),
(9, 9, 'Naik', 'Havildar', '2023-10-18', 'Col. D. Reddy', 'Instructor recommendation', 'docs/promotion9.pdf', 'Training excellence', 'Approved'),
(10, 10, 'Havildar', 'Naib Subedar', '2024-02-28', 'Col. M. Sharma', 'Team leadership during combat', 'docs/promotion10.pdf', 'Operational leadership', 'Approved'),
(11, 11, 'Lance Naik', 'Naik', '2023-08-19', 'Col. J. Thakur', 'Consistent marksmanship record', 'docs/promotion11.pdf', 'Shooting skills', 'Approved'),
(12, 12, 'Naik', 'Havildar', '2023-06-03', 'Col. A. Nanda', 'Disciplined service history', 'docs/promotion12.pdf', 'Seniority & discipline', 'Approved'),
(13, 13, 'Sepoy', 'Lance Naik', '2024-05-20', 'Col. T. Kumar', 'Quick response in counter-attack', 'docs/promotion13.pdf', 'Action in field', 'Approved'),
(14, 14, 'Naik', 'Havildar', '2023-03-09', 'Col. R. Joshi', 'Commended during joint ops', 'docs/promotion14.pdf', 'Operational coordination', 'Approved'),
(15, 15, 'Havildar', 'Naib Subedar', '2024-04-17', 'Col. S. Rao', 'Promoted after internal review', 'docs/promotion15.pdf', 'Board clearance', 'Approved'),
(16, 16, 'Lance Naik', 'Naik', '2023-09-25', 'Col. K. Bhatia', 'Recommended by unit commander', 'docs/promotion16.pdf', 'Unit recommendation', 'Approved'),
(17, 17, 'Naik', 'Havildar', '2024-02-01', 'Col. M. Pillai', 'Special award in artillery operations', 'docs/promotion17.pdf', 'Artillery accuracy', 'Approved'),
(18, 18, 'Havildar', 'Naib Subedar', '2023-12-30', 'Col. L. Chakraborty', 'Mentoring junior troops', 'docs/promotion18.pdf', 'Training contribution', 'Approved'),
(19, 19, 'Lance Naik', 'Naik', '2022-06-05', 'Col. N. Sharma', 'Clean service record', 'docs/promotion19.pdf', 'Service discipline', 'Approved'),
(20, 20, 'Sepoy', 'Lance Naik', '2023-11-11', 'Col. G. Desai', 'Volunteer in high-risk mission', 'docs/promotion20.pdf', 'Courage under fire', 'Approved');
select * from promotions ;
 
drop table  promotions;

 truncate table promotions;

-- table 11. events

CREATE TABLE events (
    event_id INT PRIMARY KEY,
    name VARCHAR(100),
    date DATE,
    location VARCHAR(100),
    organized_by VARCHAR(100),
    type VARCHAR(50),
    description TEXT,
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    status VARCHAR(50)
);
-- insert. 20 record into  events

INSERT INTO events 
VALUES
(1, 'Republic Day Parade', '2025-01-26', 'New Delhi', 'Army HQ', 'Ceremonial', 'Annual parade showcasing Indian military strength.', 'Col. S. Raghavan', '9812345670', 'Completed'),
(2, 'Annual Blood Donation Camp', '2025-03-15', 'Command Hospital, Pune', 'Medical Corps', 'Social', 'Voluntary blood donation by soldiers and officers.', 'Dr. Neha Patil', '9823456781', 'Completed'),
(3, 'Army Day Celebrations', '2025-01-15', 'Chandimandir Cantonment', 'Western Command', 'Ceremonial', 'Celebration with drill displays and honors.', 'Maj. Arjun Mehta', '9876543210', 'Completed'),
(4, 'Weapons Display Expo', '2025-02-20', 'Jaisalmer Training Ground', 'Artillery Regiment', 'Exhibition', 'Public demonstration of artillery systems.', 'Col. K. Jain', '9901234567', 'Completed'),
(5, 'Combined Field Training', '2025-04-05', 'Deolali', 'Southern Command', 'Training', 'Joint exercise between infantry and artillery.', 'Lt. Col. M. Rana', '9845612378', 'Scheduled'),
(6, 'Annual Athletics Meet', '2025-03-10', 'Secunderabad', 'Army Sports Wing', 'Sports', 'Track and field events for troops.', 'Capt. S. Malik', '9932123456', 'Completed'),
(7, 'Disaster Management Drill', '2025-02-05', 'Kolkata', 'Engineering Corps', 'Simulation', 'Flood relief and rescue demo.', 'Maj. P. Ghosh', '9873214560', 'Completed'),
(8, 'Martyrs Remembrance Ceremony', '2025-07-26', 'Kargil Memorial, Dras', 'Northern Command', 'Ceremonial', 'Tribute to soldiers lost in Kargil War.', 'Col. N. Sharma', '9812312345', 'Upcoming'),
(9, 'Cultural Night', '2025-01-30', 'Leh Base Camp', '6th Infantry', 'Recreational', 'Music, dance, and skits by soldiers.', 'Sgt. A. Pandey', '9765432101', 'Completed'),
(10, 'Junior Leaders Conference', '2025-05-20', 'Delhi Cantt.', 'Infantry School', 'Workshop', 'Leadership development for junior officers.', 'Lt. K. Iyer', '9753124875', 'Scheduled'),
(11, 'Yoga & Wellness Camp', '2025-06-21', 'Shimla Garrison', 'Medical Corps', 'Health', 'International Yoga Day celebrations.', 'Dr. A. Batra', '9912233445', 'Scheduled'),
(12, 'Annual Firing Competition', '2025-04-15', 'Mhow Firing Range', 'Rifle Regt.', 'Training', 'Shooting competition among battalions.', 'Maj. D. Rathore', '9801122334', 'Scheduled'),
(13, 'Women in Army Seminar', '2025-03-08', 'Chennai HQ', 'Army Welfare Org.', 'Awareness', 'Celebration of women’s role in armed forces.', 'Col. R. Kaur', '9841123344', 'Completed'),
(14, 'War Memorial Clean-Up Drive', '2025-05-01', 'India Gate, Delhi', 'Army Veterans Wing', 'Social', 'Volunteers maintain and clean war memorial.', 'Capt. T. Bhalla', '9912121234', 'Completed'),
(15, 'Cybersecurity Awareness Workshop', '2025-06-10', 'Army Cyber Cell, Pune', 'Signals Corps', 'Training', 'Modern cyber defense strategies.', 'Lt. N. Bhosale', '9870012345', 'Scheduled'),
(16, 'Para Jump Demo', '2025-02-25', 'Agra Airfield', 'Parachute Regt.', 'Exhibition', 'Demo jump by elite paratroopers.', 'Maj. Y. Thakur', '9823123123', 'Completed'),
(17, 'Dog Squad Competition', '2025-05-18', 'Meerut', 'Remount Veterinary Corps', 'Sports', 'Obstacle courses for army dogs.', 'Capt. V. Pawar', '9898989898', 'Completed'),
(18, 'First Aid & CPR Training', '2025-04-25', 'Military Hospital Lucknow', 'Medical Corps', 'Workshop', 'Emergency care and CPR demo.', 'Dr. M. Reddy', '9811191111', 'Completed'),
(19, 'Veterans Meet', '2025-06-30', 'Bhopal', 'Army Welfare Association', 'Social', 'Honoring retired army personnel.', 'Col. J. Thomas', '9789789789', 'Upcoming'),
(20, 'Recruitment Rally', '2025-08-01', 'Patna', 'Recruitment Board', 'Recruitment', 'Open physical and written test.', 'Maj. B. Yadav', '9900011111', 'Scheduled');
select * from events ;
 
drop table events  ;

 truncate table events ;

-- table 12. disciplinary_actions

CREATE TABLE disciplinary_actions (
    action_id INT PRIMARY KEY,
    soldier_id INT,
    action_type VARCHAR(100),
    reason TEXT,
    date DATE,
    punished_by VARCHAR(100),
    punishment TEXT,
    status VARCHAR(50),
    remarks TEXT,
    reviewed_by VARCHAR(100)
);

-- insert. 20 record into disciplinary_actions

INSERT INTO disciplinary_actions 
VALUES
(1, 1, 'Unauthorized Absence', 'Absent without leave for 3 days', '2024-12-05', 'Col. Rajeev Sharma', '3 days confinement', 'Closed', 'Soldier warned', 'Brig. V. Kumar'),
(2, 2, 'Negligence of Duty', 'Failure to report post on time', '2025-01-15', 'Lt. Col. Manish Rathi', 'Written warning', 'Closed', 'No repeat offense', 'Col. S. Rao'),
(3, 3, 'Disrespect to Senior', 'Raised voice during briefing', '2025-02-10', 'Col. Vikram Singh', 'Apology letter and counseling', 'Closed', 'Apologized', 'Col. A. Khanna'),
(4, 4, 'Damage to Property', 'Accidental damage to vehicle', '2025-01-28', 'Col. R. Verma', 'Pay deduction for repair', 'Closed', 'Resolved', 'Col. D. Mehta'),
(5, 5, 'Misconduct', 'Verbal abuse during training', '2025-03-05', 'Col. S. Rao', '5 days suspension', 'Closed', 'Filed in record', 'Brig. P. Sharma'),
(6, 6, 'Unauthorized Use of Equipment', 'Used radio without clearance', '2024-11-20', 'Lt. Col. Sneha Reddy', 'Formal warning issued', 'Closed', 'No damage caused', 'Col. M. Joshi'),
(7, 7, 'Sleeping on Duty', 'Caught sleeping during patrol', '2025-02-01', 'Col. Priya Mehra', '2 days extra duty', 'Closed', 'Admitted mistake', 'Col. R. Iyer'),
(8, 8, 'Absent from Parade', 'Skipped morning drill', '2025-01-05', 'Col. R. Patil', 'Verbal reprimand', 'Closed', 'Recorded in log', 'Col. T. Kapoor'),
(9, 9, 'Rough Behavior', 'Pushed fellow soldier', '2025-03-01', 'Col. D. Reddy', 'Counseling session', 'Closed', 'Apologized', 'Col. H. Malhotra'),
(10, 10, 'Late Reporting', 'Late for combat simulation', '2025-01-20', 'Col. M. Sharma', 'Warning issued', 'Closed', 'First instance', 'Col. V. Singh'),
(11, 11, 'Carelessness', 'Left weapon unattended', '2025-03-10', 'Col. J. Thakur', '1 day detention', 'Closed', 'Security risk addressed', 'Col. L. Dutta'),
(12, 12, 'Improper Dress Code', 'Wore incomplete uniform', '2024-12-18', 'Col. A. Nanda', 'Minor warning', 'Closed', 'Corrected on spot', 'Col. P. Bhandari'),
(13, 13, 'Insubordination', 'Refused to follow drill order', '2025-02-15', 'Col. T. Kumar', '7-day suspension', 'Closed', 'Reinstated after review', 'Brig. Y. Sharma'),
(14, 14, 'Disrespect During Assembly', 'Inattentive during address', '2025-01-30', 'Col. R. Joshi', 'Apology letter', 'Closed', 'Noted for behavior correction', 'Col. A. Khan'),
(15, 15, 'Improper Use of Language', 'Used foul language in mess', '2025-03-12', 'Col. S. Rao', 'Verbal reprimand', 'Closed', 'Behavior monitored', 'Col. R. Kapoor'),
(16, 16, 'Use of Mobile on Duty', 'Texting during patrol', '2025-02-28', 'Col. K. Bhatia', 'Mobile confiscated for 3 days', 'Closed', 'Phone returned', 'Col. H. Sharma'),
(17, 17, 'Mess Violation', 'Wasted food repeatedly', '2025-01-11', 'Col. M. Pillai', 'Mess privilege warning', 'Closed', 'Warned about discipline', 'Col. R. Nair'),
(18, 18, 'Delayed Roll Call', 'Came late to camp headcount', '2025-03-03', 'Col. L. Chakraborty', 'Verbal warning', 'Closed', 'No follow-up issues', 'Col. V. Shetty'),
(19, 19, 'Neglecting Equipment Care', 'Rifle found dirty', '2025-02-07', 'Col. N. Sharma', '1 hour additional cleaning duty', 'Closed', 'Improved since', 'Col. J. Pillai'),
(20, 20, 'Violating Safety Protocols', 'No helmet in active zone', '2025-01-17', 'Col. G. Desai', 'Safety briefing repeat', 'Closed', 'Noted for compliance', 'Col. A. Dey');
select * from disciplinary_actions;
 
drop table disciplinary_actions;

 truncate table disciplinary_actions;
-- table 13. accommodations

CREATE TABLE accommodations (
    acc_id INT PRIMARY KEY,
    soldier_id INT,
    room_no VARCHAR(10),
    block VARCHAR(10),
    location VARCHAR(100),
    assigned_date DATE,
    vacated_date DATE,
    status VARCHAR(50),
    remarks TEXT,
    caretaker VARCHAR(100)
);
-- insert. 20 record into accommodations 

INSERT INTO accommodations 
VALUES
(1, 1, 'A101', 'Block A', 'Delhi Cantt', '2022-01-10', NULL, 'Occupied', 'Single occupancy', 'Mr. Rajiv Bhatia'),
(2, 2, 'B203', 'Block B', 'Pune HQ', '2023-03-15', NULL, 'Occupied', 'Shared with 1 soldier', 'Mr. Ajay Joshi'),
(3, 3, 'C105', 'Block C', 'Srinagar Base', '2021-07-01', '2024-06-15', 'Vacated', 'Vacated after transfer', 'Mr. Suresh Yadav'),
(4, 4, 'D304', 'Block D', 'Leh Garrison', '2022-11-20', NULL, 'Occupied', 'Shared quarters', 'Mr. Deepak Rao'),
(5, 5, 'A201', 'Block A', 'Jaipur Base', '2023-05-01', NULL, 'Occupied', 'Allotted after promotion', 'Mr. Mohan Das'),
(6, 6, 'E112', 'Block E', 'Lucknow Cantonment', '2021-12-01', '2024-03-25', 'Vacated', 'Moved to medical quarters', 'Mr. Harish Patil'),
(7, 7, 'B306', 'Block B', 'Delhi Cantt', '2023-06-10', NULL, 'Occupied', 'Temporary assignment', 'Mr. Rajiv Bhatia'),
(8, 8, 'F101', 'Block F', 'Hyderabad Regimental Center', '2024-01-01', NULL, 'Occupied', 'Single accommodation', 'Mr. Vikram Naik'),
(9, 9, 'C204', 'Block C', 'Nagpur Logistics Base', '2022-05-20', NULL, 'Occupied', 'Shared with logistics team', 'Mr. Ramesh Gaikwad'),
(10, 10, 'G102', 'Block G', 'Siliguri Army Camp', '2021-10-10', '2024-10-01', 'Vacated', 'Due to retirement', 'Mr. Prakash Menon'),
(11, 11, 'A302', 'Block A', 'Udhampur HQ', '2023-02-05', NULL, 'Occupied', 'Newly renovated', 'Mr. Vinay Kulkarni'),
(12, 12, 'H205', 'Block H', 'Bhopal Infantry School', '2024-03-15', NULL, 'Occupied', 'Fresh assignment', 'Mr. Ashok Sharma'),
(13, 13, 'I106', 'Block I', 'Chennai Army Quarters', '2022-08-01', NULL, 'Occupied', 'Shared with 2 others', 'Mr. Naveen Dutta'),
(14, 14, 'J101', 'Block J', 'Jalandhar Regimental Center', '2021-06-10', '2023-10-15', 'Vacated', 'Completed training period', 'Mr. Rishi Verma'),
(15, 15, 'K303', 'Block K', 'Amritsar Signal Base', '2022-02-20', NULL, 'Occupied', 'Two-man accommodation', 'Mr. Harpreet Singh'),
(16, 16, 'L110', 'Block L', 'Chandigarh Army Base', '2023-09-01', NULL, 'Occupied', 'Allotted after posting', 'Mr. Devendra Pillai'),
(17, 17, 'M211', 'Block M', 'Agra Cantonment', '2023-07-05', NULL, 'Occupied', 'Assigned for 1 year', 'Mr. Pravin Raj'),
(18, 18, 'N101', 'Block N', 'Guwahati Frontier Base', '2024-02-15', NULL, 'Occupied', 'Newly constructed', 'Mr. Arun Tyagi'),
(19, 19, 'O301', 'Block O', 'Pathankot Air Defense Unit', '2022-04-12', NULL, 'Occupied', 'Family quarters nearby', 'Mr. Krishna Bansal'),
(20, 20, 'P202', 'Block P', 'Ahmedabad Signal Unit', '2024-06-01', NULL, 'Occupied', 'For technical staff', 'Mr. Satyajit Mohan');
select * from accommodations;
 
drop table  accommodations;

 truncate table accommodations;

-- table 14. payroll
CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY,
    soldier_id INT,
    month VARCHAR(20),
    basic_pay DECIMAL(10,2),
    hra DECIMAL(10,2),
    da DECIMAL(10,2),
    deductions DECIMAL(10,2),
    net_pay DECIMAL(10,2),
    status VARCHAR(50),
    processed_date DATE
);


-- insert. 20 record into payroll
INSERT INTO payroll
 VALUES
(1, 1, 'June 2025', 40000.00, 8000.00, 6000.00, 2000.00, 52000.00, 'Processed', '2025-06-30'),
(2, 2, 'June 2025', 38000.00, 7500.00, 5800.00, 1800.00, 49500.00, 'Processed', '2025-06-30'),
(3, 3, 'June 2025', 42000.00, 8200.00, 6300.00, 2300.00, 54200.00, 'Processed', '2025-06-30'),
(4, 4, 'June 2025', 37000.00, 7000.00, 5600.00, 1500.00, 48100.00, 'Processed', '2025-06-30'),
(5, 5, 'June 2025', 46000.00, 9000.00, 6900.00, 3000.00, 61900.00, 'Processed', '2025-06-30'),
(6, 6, 'June 2025', 39000.00, 7600.00, 5800.00, 1800.00, 50600.00, 'Processed', '2025-06-30'),
(7, 7, 'June 2025', 41000.00, 7900.00, 6000.00, 1700.00, 53200.00, 'Processed', '2025-06-30'),
(8, 8, 'June 2025', 43000.00, 8500.00, 6400.00, 2200.00, 55700.00, 'Processed', '2025-06-30'),
(9, 9, 'June 2025', 39500.00, 7700.00, 5900.00, 1900.00, 51200.00, 'Processed', '2025-06-30'),
(10, 10, 'June 2025', 48000.00, 9500.00, 7200.00, 2500.00, 62200.00, 'Processed', '2025-06-30'),
(11, 11, 'June 2025', 37000.00, 7100.00, 5600.00, 1600.00, 50100.00, 'Processed', '2025-06-30'),
(12, 12, 'June 2025', 38500.00, 7400.00, 5700.00, 1700.00, 49900.00, 'Processed', '2025-06-30'),
(13, 13, 'June 2025', 40000.00, 8000.00, 6000.00, 2000.00, 52000.00, 'Processed', '2025-06-30'),
(14, 14, 'June 2025', 37500.00, 7200.00, 5500.00, 1500.00, 48700.00, 'Processed', '2025-06-30'),
(15, 15, 'June 2025', 45500.00, 8900.00, 6800.00, 2800.00, 60400.00, 'Processed', '2025-06-30'),
(16, 16, 'June 2025', 39000.00, 7600.00, 5800.00, 1800.00, 50600.00, 'Processed', '2025-06-30'),
(17, 17, 'June 2025', 43500.00, 8600.00, 6450.00, 2200.00, 56450.00, 'Processed', '2025-06-30'),
(18, 18, 'June 2025', 40500.00, 7900.00, 6000.00, 2000.00, 52400.00, 'Processed', '2025-06-30'),
(19, 19, 'June 2025', 38000.00, 7500.00, 5800.00, 1800.00, 49500.00, 'Processed', '2025-06-30'),
(20, 20, 'June 2025', 42000.00, 8200.00, 6200.00, 2100.00, 56300.00, 'Processed', '2025-06-30');

select * from payroll;
 
drop table payroll;

 truncate table payroll;
-- table 15. arms_inventory
CREATE TABLE arms_inventory (
    inventory_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    type VARCHAR(50),
    quantity INT,
    location VARCHAR(100),
    condition VARCHAR(50),
    last_checked DATE,
    checked_by VARCHAR(100),
    remarks TEXT,
    status VARCHAR(50)
);
-- insert. 20 record into arms_inventory
INSERT INTO arms_inventory
 VALUES
(1, 'INSAS Rifle', 'Rifle', 150, 'Delhi Armory', 'Good', '2025-06-25', 'Col. V. Bhatnagar', 'Standard issue rifle', 'In Service'),
(2, 'AK-47', 'Assault Rifle', 200, 'Pathankot Base', 'Good', '2025-06-10', 'Maj. R. Singh', 'Used for border patrol', 'In Service'),
(3, 'Dragunov Sniper', 'Sniper Rifle', 20, 'Srinagar Depot', 'Excellent', '2025-06-20', 'Lt. K. Malhotra', 'Limited use', 'In Service'),
(4, 'Glock 17', 'Pistol', 100, 'Mumbai HQ', 'Good', '2025-06-22', 'Capt. S. Nair', 'Officer issue', 'In Service'),
(5, 'Light Machine Gun (LMG)', 'Machine Gun', 75, 'Leh Arsenal', 'Fair', '2025-06-05', 'Maj. A. Shekhawat', 'Some units under maintenance', 'In Service'),
(6, 'Grenade Launcher', 'Launcher', 50, 'Chandigarh Storage', 'Good', '2025-06-14', 'Col. D. Pillai', 'Fully operational', 'In Service'),
(7, 'Tavor X95', 'Assault Rifle', 80, 'Pune Armory', 'Good', '2025-06-28', 'Lt. Col. R. Thakur', 'Special Forces use', 'In Service'),
(8, 'MP5', 'SMG', 60, 'Delhi Commando Wing', 'Excellent', '2025-06-18', 'Maj. P. Yadav', 'Counter-terror ops', 'In Service'),
(9, 'Smoke Grenades', 'Explosive', 500, 'Field Depot - Agra', 'Good', '2025-06-30', 'Capt. I. Reddy', 'Regular drills', 'In Service'),
(10, 'Hand Grenades', 'Explosive', 600, 'Jaipur Logistics Center', 'Good', '2025-06-15', 'Col. A. Sharma', 'Secure storage', 'In Service'),
(11, 'SIG Sauer P226', 'Pistol', 90, 'Ambala Cantonment', 'Fair', '2025-06-12', 'Lt. K. Meena', 'Officer issue', 'In Service'),
(12, 'Carl Gustav', 'Launcher', 30, 'Border Unit - Punjab', 'Good', '2025-06-08', 'Maj. V. Sinha', 'Anti-tank rounds available', 'In Service'),
(13, '9mm Ammo', 'Ammunition', 5000, 'Kolkata Depot', 'Good', '2025-06-03', 'Col. T. Banerjee', 'For pistols/SMGs', 'In Stock'),
(14, '5.56mm Ammo', 'Ammunition', 7000, 'Hyderabad Logistics', 'Excellent', '2025-06-26', 'Capt. A. Gupta', 'Rifle ammunition', 'In Stock'),
(15, '7.62mm Ammo', 'Ammunition', 8000, 'Jodhpur Armory', 'Good', '2025-06-19', 'Lt. Col. S. Chauhan', 'Used for LMGs', 'In Stock'),
(16, 'Rocket Propelled Grenade', 'Launcher', 15, 'Eastern Sector Arsenal', 'Fair', '2025-06-11', 'Col. N. Rao', 'Limited usage', 'Restricted'),
(17, 'Anti-Personnel Mines', 'Explosive', 100, 'Sikkim Field Store', 'Excellent', '2025-06-01', 'Maj. B. Thapa', 'Emergency use only', 'Restricted'),
(18, 'Stun Grenades', 'Explosive', 300, 'Special Ops Depot', 'Good', '2025-06-27', 'Capt. R. Kohli', 'Training and live use', 'In Service'),
(19, 'INSAS Magazines', 'Accessory', 1200, 'Delhi Logistics', 'Good', '2025-06-23', 'Lt. S. Rathi', 'Rifle compatible', 'In Stock'),
(20, 'Binoculars (Night Vision)', 'Optical', 100, 'North Command HQ', 'Excellent', '2025-06-17', 'Col. Y. Deshmukh', 'Recon missions', 'In Service');
select * from arms_inventory;
 
drop table arms_inventory;

 truncate table arms_inventory;

-- table 16. comm_channels

CREATE TABLE comm_channels (
    channel_id INT PRIMARY KEY,
    name VARCHAR(100),
    type VARCHAR(50),
    range_km DECIMAL(6,2),
    frequency VARCHAR(50),
    assigned_unit VARCHAR(100),
    status VARCHAR(50),
    last_maintenance DATE,
    technician VARCHAR(100),
    remarks TEXT
);

-- insert. 20 record into comm_channels
INSERT INTO comm_channels 
VALUES
(1, 'Alpha-1', 'Radio HF', 100.50, '3.5 MHz', 'Infantry Unit 21', 'Active', '2025-06-10', 'Hav. R. Thakur', 'Used for base-to-base relay'),
(2, 'Bravo-2', 'Satellite', 3000.00, '12 GHz', 'Command HQ North', 'Active', '2025-06-05', 'Tech. A. Kumar', 'High-bandwidth secure line'),
(3, 'Charlie-3', 'VHF', 50.00, '136 MHz', 'Signal Corps Delhi', 'Under Maintenance', '2025-06-20', 'Sgt. P. Reddy', 'Transmission delay reported'),
(4, 'Delta-4', 'UHF', 30.00, '400 MHz', 'Special Forces Unit', 'Active', '2025-06-15', 'Hav. N. Singh', 'Encrypted voice link'),
(5, 'Echo-5', 'Radio HF', 120.00, '4.1 MHz', 'Border Unit West', 'Inactive', '2025-05-25', 'Tech. B. Mehra', 'Awaiting antenna replacement'),
(6, 'Foxtrot-6', 'Microwave', 15.00, '18 GHz', 'Artillery Comm Line', 'Active', '2025-06-18', 'Hav. V. Iyer', 'Direct line to fire control'),
(7, 'Golf-7', 'VHF', 60.00, '150 MHz', 'Infantry Battalion 7', 'Active', '2025-06-22', 'Sgt. D. Nair', 'New batteries installed'),
(8, 'Hotel-8', 'UHF', 40.00, '410 MHz', 'Base Ops Sikkim', 'Active', '2025-06-14', 'Tech. R. Paul', 'Optimized after terrain scan'),
(9, 'India-9', 'Satellite', 5000.00, '14 GHz', 'Central Command', 'Active', '2025-06-01', 'Lt. K. Narayan', 'Primary command uplink'),
(10, 'Juliet-10', 'VHF', 70.00, '145 MHz', 'Engineer Regiment', 'Active', '2025-06-12', 'Hav. J. Shah', 'Routine check passed'),
(11, 'Kilo-11', 'Radio HF', 90.00, '3.9 MHz', 'Logistics Convoy Comm', 'Active', '2025-06-26', 'Sgt. F. Alam', 'Convoy tested'),
(12, 'Lima-12', 'UHF', 25.00, '435 MHz', 'Signal Unit Nashik', 'Inactive', '2025-05-18', 'Tech. R. Naik', 'Spare parts ordered'),
(13, 'Mike-13', 'Microwave', 10.00, '22 GHz', 'Mobile HQ', 'Active', '2025-06-28', 'Sgt. T. Das', 'Perfect condition'),
(14, 'November-14', 'VHF', 45.00, '138 MHz', 'Medical Corps Ops', 'Active', '2025-06-20', 'Hav. L. Joshi', 'Patient transport line'),
(15, 'Oscar-15', 'Radio HF', 80.00, '3.8 MHz', 'Kargil Forward Base', 'Active', '2025-06-09', 'Tech. M. Kulkarni', 'Tested during snowstorm'),
(16, 'Papa-16', 'UHF', 33.00, '420 MHz', 'Recon Unit 3', 'Active', '2025-06-13', 'Sgt. A. Singh', 'Operated in forest terrain'),
(17, 'Quebec-17', 'Satellite', 2800.00, '13 GHz', 'Training Command Comm', 'Active', '2025-06-07', 'Lt. R. Varma', 'Used for remote lectures'),
(18, 'Romeo-18', 'Microwave', 12.00, '19 GHz', 'Army Aviation Comm', 'Active', '2025-06-03', 'Hav. D. Patel', 'Helipad comms stable'),
(19, 'Sierra-19', 'VHF', 48.00, '148 MHz', 'Quick Response Team', 'Active', '2025-06-25', 'Sgt. Z. Khan', 'Line verified during drills'),
(20, 'Tango-20', 'UHF', 38.00, '418 MHz', 'Northern Border Ops', 'Active', '2025-06-11', 'Tech. G. Rawat', 'Backup channel enabled');

select * from comm_channels;
 
drop table  comm_channels;

 truncate tablecomm_channels;
 
-- table 17. intelligence_reports
CREATE TABLE intelligence_reports (
    report_id INT PRIMARY KEY,
    source VARCHAR(100),
    type VARCHAR(50),
    content TEXT,
    report_date DATE,
    reviewed_by VARCHAR(100),
    status VARCHAR(50),
    location VARCHAR(100),
    priority VARCHAR(50),
    remarks TEXT
);


-- insert. 20 record into  intelligence_reports

INSERT INTO intelligence_reports
 VALUES
(1, 'Field Agent A21', 'Reconnaissance', 'Observed movement of enemy vehicles near LOC.', '2025-06-01', 'Col. V. Sharma', 'Reviewed', 'Poonch, J&K', 'High', 'Recommended increased surveillance'),
(2, 'Drone Surveillance Unit', 'Aerial', 'Captured thermal signatures at night patrol zones.', '2025-06-03', 'Maj. R. Iyer', 'Reviewed', 'Arunachal Border', 'Medium', 'No immediate threat'),
(3, 'Intercepted Communication', 'Signals Intelligence', 'Encoded radio transmissions intercepted on 4.7 MHz.', '2025-06-05', 'Capt. A. Mehra', 'Under Analysis', 'Punjab Sector', 'High', 'Decrypting required'),
(4, 'Satellite Image Analysis', 'Imagery', 'Detected construction activity near disputed zone.', '2025-06-07', 'Col. T. Patel', 'Reviewed', 'Eastern Ladakh', 'Critical', 'Possible encampment setup'),
(5, 'Informant X-12', 'Human Intelligence', 'Reported unusual supply movement through mountain passes.', '2025-06-08', 'Maj. P. Rajan', 'Reviewed', 'Kupwara', 'High', 'Needs confirmation'),
(6, 'Patrol Report Bravo-9', 'Reconnaissance', 'New fencing observed across the ridge line.', '2025-06-10', 'Lt. Col. D. Nayak', 'Reviewed', 'Baramulla', 'Medium', 'Possible forward post'),
(7, 'Cyber Monitoring Unit', 'Cyber Intelligence', 'Suspicious login attempts on army email servers.', '2025-06-11', 'Col. A. Khurana', 'Mitigated', 'Cyber Command HQ', 'High', 'Password reset issued'),
(8, 'Intercepted Message - RAW', 'Signals Intelligence', 'Intercepted message suggests movement near border outpost.', '2025-06-12', 'Capt. I. Rawat', 'Pending', 'Manipur', 'High', 'Joint review with paramilitary'),
(9, 'Drone Recon B7', 'Aerial', 'No unusual movement detected.', '2025-06-13', 'Maj. N. Ghosh', 'Reviewed', 'Jaisalmer', 'Low', 'Routine check'),
(10, 'Local Intelligence Cell', 'Human Intelligence', 'Civilians reported foreign accent voices at night.', '2025-06-14', 'Col. S. Malhotra', 'Pending', 'Tawang', 'Medium', 'Possible infiltrators'),
(11, 'Border Patrol Zeta-3', 'Reconnaissance', 'Tracks found leading into forest from border.', '2025-06-15', 'Maj. J. Thakur', 'Reviewed', 'Pathankot', 'High', 'Search operation launched'),
(12, 'Military Attaché', 'Foreign Source', 'Confirmed diplomatic visit to rival border post.', '2025-06-16', 'Col. B. Desai', 'Reviewed', 'New Delhi (Embassy)', 'Low', 'Info noted'),
(13, 'Intercepted Email', 'Cyber Intelligence', 'Email with sensitive keywords flagged.', '2025-06-17', 'Tech. R. Pillai', 'Escalated', 'Cyber Cell South', 'High', 'Forensic team alerted'),
(14, 'Seismic Sensor Data', 'Technical Intelligence', 'Unusual vibration patterns detected underground.', '2025-06-18', 'Col. Y. Bansal', 'Under Analysis', 'Dras', 'Medium', 'May indicate tunnel digging'),
(15, 'RAW Liaison Brief', 'Foreign Source', 'Meeting recorded between known targets.', '2025-06-19', 'Maj. A. Narang', 'Reviewed', 'Kathua', 'High', 'Joint op planned'),
(16, 'Civilian Report', 'Open Source', 'Villagers saw armed men crossing field at dawn.', '2025-06-20', 'Capt. K. Sen', 'Pending', 'Rajouri', 'High', 'Investigation ongoing'),
(17, 'Field Scout Log', 'Reconnaissance', 'Detected campsite remains.', '2025-06-21', 'Lt. R. Chauhan', 'Reviewed', 'Pithoragarh', 'Medium', 'Photos attached'),
(18, 'Intercepted Satellite Feed', 'Imagery', 'Detected mobile tower setup across border.', '2025-06-22', 'Col. M. Pradhan', 'Reviewed', 'Silchar Sector', 'Medium', 'Increased communication suspected'),
(19, 'Spy Network Update', 'Human Intelligence', 'Confirmed convoy departure at 0400 hrs.', '2025-06-23', 'Maj. V. Rao', 'Classified', 'Kargil Region', 'High', 'Actionable intel shared'),
(20, 'Cyber Threat Analysis', 'Cyber Intelligence', 'Malware detected attempting to access classified files.', '2025-06-24', 'Tech. N. Dey', 'Neutralized', 'Signals HQ', 'Critical', 'Threat blocked');
select * from intelligence_reports;
 
drop table intelligence_reports;

 truncate table  intelligence_reports;
-- table 18. equipment

CREATE TABLE equipment (
    equipment_id INT PRIMARY KEY,
    name VARCHAR(100),
    type VARCHAR(50),
    model VARCHAR(50),
    quantity INT,
    location VARCHAR(100),
    assigned_unit VARCHAR(100),
    condition VARCHAR(50),
    status VARCHAR(50),
    remarks TEXT
);
-- insert. 20 record into equipment
INSERT INTO equipment 
VALUES
(1, 'Night Vision Goggles', 'Optical', 'NVG-MKIII', 120, 'Delhi Depot', 'Infantry Unit 5', 'Good', 'Active', 'Used for night patrols'),
(2, 'Thermal Imaging Scope', 'Surveillance', 'TIS-X2', 60, 'Srinagar Base', 'Special Forces', 'Excellent', 'Active', 'Long-range thermal visibility'),
(3, 'Ballistic Helmet', 'Protective Gear', 'BH-PATKA', 300, 'Pune Storage', 'Signal Corps', 'Good', 'Active', 'Standard protection'),
(4, 'Kevlar Vest', 'Protective Gear', 'KV-9000', 200, 'Pathankot Armory', 'Border Patrol', 'Good', 'Active', 'Lightweight and durable'),
(5, 'Radio Set', 'Communication', 'ICOM V90', 150, 'Jammu Warehouse', 'Engineering Unit', 'Fair', 'Under Maintenance', 'Battery issues reported'),
(6, 'Drone (Recon)', 'Surveillance', 'DRN-EYE', 25, 'Eastern Command', 'Recon Team A', 'Excellent', 'Active', 'Real-time video feed'),
(7, 'Mine Detector', 'Detection', 'MD-TIGER', 40, 'Rajasthan Field Unit', 'Engineer Battalion', 'Good', 'Active', 'For minefield clearance'),
(8, 'Portable Generator', 'Power Supply', 'GEN-5KW', 35, 'Leh Garrison', 'HQ Support', 'Fair', 'Under Maintenance', 'Fuel leakage reported'),
(9, 'Tactical Backpack', 'Gear', 'TAC-GEARX', 500, 'Hyderabad Depot', 'Infantry Unit 9', 'Good', 'Active', 'Includes hydration pack'),
(10, 'Binoculars', 'Optical', 'BNCL-VISIONX', 100, 'Guwahati Storage', 'Scout Unit', 'Excellent', 'Active', 'High zoom and clarity'),
(11, 'Satellite Phone', 'Communication', 'SATPHN-XT1', 50, 'Command HQ', 'Commanders Only', 'Excellent', 'Active', 'Used for remote comms'),
(12, 'Explosive Disposal Kit', 'EOD Equipment', 'EDK-V2', 10, 'Central Logistics', 'Bomb Squad', 'Good', 'Active', 'Includes defusal tools'),
(13, 'Tactical Gloves', 'Protective Gear', 'TG-MILSPEC', 350, 'Training Academy', 'Cadets', 'Good', 'Active', 'For combat training'),
(14, 'First Aid Kit', 'Medical', 'FAK-ARMY', 200, 'Medical Unit Stock', 'Infantry Units', 'Good', 'Active', 'Includes trauma care tools'),
(15, 'Bulletproof Shield', 'Protective Gear', 'BPS-TITAN', 20, 'Counterterror Ops Base', 'Strike Force', 'Excellent', 'Active', 'Lightweight composite'),
(16, 'Field Laptop', 'Electronics', 'FLPT-ARMY', 70, 'Cyber Unit Delhi', 'Cyber Intelligence', 'Good', 'Active', 'Encrypted communication enabled'),
(17, 'Camouflage Net', 'Field Gear', 'CAMO-NET-22', 90, 'Logistics Base Chennai', 'Infantry', 'Fair', 'Active', 'Worn-out segments reported'),
(18, 'Weather Monitoring Kit', 'Environmental', 'WMK-RADAR', 12, 'Artillery HQ', 'Support Staff', 'Excellent', 'Active', 'Predicts terrain weather'),
(19, 'Hydration System', 'Field Gear', 'HYDR-PACKX', 250, 'Canteen Store Depot', 'All Units', 'Good', 'Active', 'Mandatory for high-altitude units'),
(20, 'Laser Rangefinder', 'Optical', 'LRF-TGT100', 30, 'Target Training Camp', 'Marksmanship Unit', 'Excellent', 'Active', 'High precision for snipers');
select * from equipment;
 
drop table  equipment;

 truncate table equipment;


-- table 19. logistics

CREATE TABLE logistics (
    logistic_id INT PRIMARY KEY,
    item_name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    source VARCHAR(100),
    destination VARCHAR(100),
    date_dispatched DATE,
    received_by VARCHAR(100),
    status VARCHAR(50),
    remarks TEXT
);
 
-- insert. 20 record into logistics

INSERT INTO logistics 
VALUES
(1, 'Ration Packs', 'Food Supply', 2000, 'Delhi Central Depot', 'Srinagar Base', '2025-06-01', 'Capt. A. Rawat', 'Delivered', 'For 30-day deployment'),
(2, 'Fuel Drums', 'Fuel', 500, 'Pathankot Fuel Yard', 'Leh Forward Camp', '2025-06-03', 'Maj. S. Khan', 'Delivered', 'Winter reserve stock'),
(3, 'Ammunition Crates', 'Ammunition', 100, 'Jammu Armory', 'Rajouri Line Post', '2025-06-05', 'Lt. R. Meena', 'In Transit', 'Requires high security'),
(4, 'Medical Kits', 'Medical', 300, 'Ambala Medical Depot', 'Udhampur HQ', '2025-06-06', 'Dr. P. Sharma', 'Delivered', 'Emergency stockpile'),
(5, 'Tent Kits', 'Shelter', 100, 'Bangalore Logistics Base', 'Siachen Camp', '2025-06-07', 'Capt. K. Iyer', 'Dispatched', 'Extreme weather use'),
(6, 'Spare Tyres', 'Vehicle Parts', 50, 'Chennai Transport Unit', 'Kargil Mechanic Unit', '2025-06-08', 'Sgt. T. Yadav', 'Delivered', 'For transport trucks'),
(7, 'Bulletproof Vests', 'Protective Gear', 150, 'Pune Central Depot', 'Kupwara Infantry Camp', '2025-06-10', 'Maj. V. Kulkarni', 'Delivered', 'New procurement batch'),
(8, 'Satellite Phones', 'Communication', 30, 'Signals HQ Delhi', 'Eastern Command Base', '2025-06-12', 'Lt. Col. N. Singh', 'Delivered', 'For unit commanders'),
(9, 'Water Bottles', 'Field Supply', 5000, 'Canteen Supply Division', 'Leh Supply Point', '2025-06-13', 'Capt. B. Sinha', 'Delivered', 'Hot zone resupply'),
(10, 'Generator Sets', 'Power Equipment', 20, 'Lucknow HQ', 'Manipur Forward Camp', '2025-06-14', 'Maj. R. Ghosh', 'In Transit', 'Backup power'),
(11, 'Uniforms', 'Clothing', 800, 'Textile Supply Wing', 'Tawang Outpost', '2025-06-15', 'Sgt. D. Lal', 'Delivered', 'Winter uniform batch'),
(12, 'Mortar Shells', 'Ammunition', 60, 'Mumbai Ordnance Factory', 'Silchar Arsenal', '2025-06-17', 'Capt. J. Shah', 'Delivered', 'Checked for safety'),
(13, 'Medical Stretchers', 'Medical', 100, 'Hyderabad Base Hospital', 'Field Hospital Unit', '2025-06-18', 'Nurse V. Desai', 'Delivered', 'Operation readiness'),
(14, 'Camouflage Nets', 'Field Equipment', 200, 'Nagpur Depot', 'Jaipur Infantry School', '2025-06-19', 'Lt. R. Thakur', 'Delivered', 'For training camps'),
(15, 'Vehicle Batteries', 'Vehicle Parts', 40, 'Goa Motor Division', 'Ahmedabad Transport HQ', '2025-06-20', 'Tech. A. Chauhan', 'Delivered', 'Routine replacement'),
(16, 'Rifles (INSAS)', 'Weapons', 90, 'Delhi Ordnance Supply', 'North Sector Battalion', '2025-06-21', 'Maj. A. Jadhav', 'Delivered', 'Checked and signed'),
(17, 'Cold Weather Gear', 'Clothing', 300, 'Shimla Logistics', 'Tawang Post', '2025-06-22', 'Sgt. B. Rana', 'Delivered', 'Snow patrol needs'),
(18, 'Handheld Radios', 'Communication', 120, 'Signals Command', 'Border Patrol Unit', '2025-06-23', 'Capt. M. Nayyar', 'Delivered', 'Frequency checked'),
(19, 'Barricades', 'Field Supply', 40, 'Engineering Stores', 'Siliguri Checkpoint', '2025-06-24', 'Lt. R. Kapoor', 'Delivered', 'For border security'),
(20, 'Fuel Canisters', 'Fuel', 600, 'Field Depot - Bhopal', 'Eastern Motor Pool', '2025-06-25', 'Maj. H. Tyagi', 'In Transit', 'Urgent delivery');

select * from logistics ;
 
drop table loistics ;

 truncate table loistics;

-- table 20. support_staff

CREATE TABLE support_staff (
    staff_id INT PRIMARY KEY,
    name VARCHAR(100),
    role VARCHAR(100),
    department VARCHAR(100),
    age INT,
    gender CHAR(1),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    join_date DATE,
    status VARCHAR(50)
);

-- insert. 20 record into support_staff

INSERT INTO support_staff 
VALUES
(1, 'Ravi Deshmukh', 'Cook', 'Catering', 42, 'M', '9876543210', 'ravi.deshmukh@army.in', '2010-05-12', 'Active'),
(2, 'Sunita Joshi', 'Medical Assistant', 'Medical', 35, 'F', '9867543210', 'sunita.joshi@army.in', '2012-03-15', 'Active'),
(3, 'Mahesh Sharma', 'Driver', 'Transport', 38, 'M', '9856432109', 'mahesh.sharma@army.in', '2015-08-20', 'Active'),
(4, 'Pooja Nair', 'Clerk', 'Admin', 30, 'F', '9845321098', 'pooja.nair@army.in', '2018-02-10', 'Active'),
(5, 'Rajeev Verma', 'Technician', 'Engineering', 45, 'M', '9834210987', 'rajeev.verma@army.in', '2009-07-18', 'Active'),
(6, 'Anita Mehta', 'Nurse', 'Medical', 32, 'F', '9823109876', 'anita.mehta@army.in', '2016-09-23', 'On Leave'),
(7, 'Imran Khan', 'Sanitation Worker', 'Maintenance', 40, 'M', '9812098765', 'imran.khan@army.in', '2014-04-05', 'Active'),
(8, 'Sneha Kulkarni', 'Data Entry Operator', 'IT', 28, 'F', '9801987654', 'sneha.kulkarni@army.in', '2021-01-14', 'Active'),
(9, 'Prakash Thapa', 'Helper', 'Logistics', 36, 'M', '9790876543', 'prakash.thapa@army.in', '2013-12-01', 'Active'),
(10, 'Neha Raut', 'Receptionist', 'Admin', 29, 'F', '9780765432', 'neha.raut@army.in', '2020-06-25', 'Active'),
(11, 'Dinesh Patil', 'Electrician', 'Engineering', 41, 'M', '9770654321', 'dinesh.patil@army.in', '2011-11-19', 'Active'),
(12, 'Lata Bhosale', 'Medical Assistant', 'Medical', 34, 'F', '9760543210', 'lata.bhosale@army.in', '2017-08-30', 'Active'),
(13, 'Rakesh Jha', 'Technician', 'Signals', 39, 'M', '9750432109', 'rakesh.jha@army.in', '2013-03-03', 'On Leave'),
(14, 'Meena Yadav', 'Canteen Attendant', 'Catering', 37, 'F', '9740321098', 'meena.yadav@army.in', '2010-10-11', 'Active'),
(15, 'Suresh Pawar', 'Storekeeper', 'Logistics', 44, 'M', '9730210987', 'suresh.pawar@army.in', '2008-05-22', 'Active'),
(16, 'Aarti Shinde', 'Cleaner', 'Maintenance', 31, 'F', '9720109876', 'aarti.shinde@army.in', '2019-09-12', 'Active'),
(17, 'Nitin Rao', 'Security Assistant', 'Security', 46, 'M', '9710098765', 'nitin.rao@army.in', '2007-07-07', 'Retired'),
(18, 'Gayatri Pillai', 'Clerk', 'Admin', 33, 'F', '9700987654', 'gayatri.pillai@army.in', '2016-12-19', 'Active'),
(19, 'Manoj Jain', 'IT Assistant', 'IT', 29, 'M', '9690876543', 'manoj.jain@army.in', '2022-04-01', 'Active'),
(20, 'Bhavna Desai', 'Cook', 'Catering', 36, 'F', '9680765432', 'bhavna.desai@army.in', '2011-06-15', 'Active');

select * from support_staff ;
 
drop table  support_staff ;

 truncate table support_staff ;
 



-- table 21. medical_records 

CREATE TABLE medical_records (
    record_id INT PRIMARY KEY,
    soldier_id INT,
    height_cm INT,
    weight_kg INT,
    blood_pressure VARCHAR(10),
    blood_group VARCHAR(5),
    eyesight VARCHAR(20),
    medical_condition VARCHAR(100),
    last_checkup DATE,
    doctor_name VARCHAR(100)
);
INSERT INTO medical_records (
    record_id, soldier_id, height_cm, weight_kg, blood_pressure, blood_group,
    eyesight, medical_condition, last_checkup, doctor_name
) VALUES
(1, 1, 175, 70, '120/80', 'B+', '6/6', 'None', '2024-01-10', 'Dr. R.K. Verma'),
(2, 2, 168, 65, '118/78', 'O+', '6/6', 'Asthma', '2024-02-15', 'Dr. P. Singh'),
(3, 3, 180, 72, '122/82', 'A+', '6/9', 'None', '2024-03-12', 'Dr. Neha Saini'),
(4, 4, 170, 68, '125/85', 'B-', '6/6', 'Fractured Arm', '2023-11-22', 'Dr. A.K. Joshi'),
(5, 5, 165, 60, '117/76', 'AB+', '6/6', 'None', '2024-04-02', 'Dr. D. Rawat'),
(6, 6, 177, 75, '130/88', 'O-', '6/6', 'High BP', '2024-05-30', 'Dr. Arvind Rathi'),
(7, 7, 172, 66, '120/80', 'A-', '6/6', 'None', '2024-06-01', 'Dr. S.K. Sharma'),
(8, 8, 179, 73, '118/79', 'O+', '6/9', 'Knee Injury', '2023-12-18', 'Dr. N. Verma'),
(9, 9, 169, 67, '116/75', 'B+', '6/6', 'Migraine', '2024-02-11', 'Dr. Preeti Nair'),
(10, 10, 176, 71, '123/83', 'AB-', '6/6', 'None', '2024-01-25', 'Dr. H. Mehra'),
(11, 11, 181, 78, '121/80', 'A+', '6/6', 'None', '2024-03-01', 'Dr. Jaya Bhatt'),
(12, 12, 178, 74, '119/78', 'O-', '6/6', 'Back Pain', '2023-10-20', 'Dr. Anil Kapoor'),
(13, 13, 166, 64, '122/80', 'B+', '6/6', 'None', '2024-04-15', 'Dr. Reena Sharma'),
(14, 14, 174, 69, '124/82', 'O+', '6/6', 'High BP', '2024-06-20', 'Dr. Arvind Rathi'),
(15, 15, 170, 65, '115/75', 'A-', '6/9', 'None', '2024-02-05', 'Dr. D. Rawat'),
(16, 16, 173, 70, '121/79', 'AB+', '6/6', 'None', '2023-12-30', 'Dr. K. Nair'),
(17, 17, 182, 80, '135/90', 'B+', '6/6', 'High BP', '2024-05-18', 'Dr. R.K. Verma'),
(18, 18, 167, 62, '117/76', 'A+', '6/6', 'None', '2024-01-15', 'Dr. P. Singh'),
(19, 19, 171, 68, '120/80', 'O+', '6/9', 'Knee Pain', '2023-11-10', 'Dr. A.K. Joshi'),
(20, 20, 175, 72, '122/82', 'B-', '6/6', 'None', '2024-03-22', 'Dr. Neha Saini');

select * from medical_records;
 
drop table  medical_records ;

 truncate table medical_records ;
-- table 22.equipment_inventory 

CREATE TABLE equipment_inventory (
    equipment_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    quantity INT,
    location VARCHAR(100),
    issue_date DATE,
    condition_status VARCHAR(50),
    supplier_name VARCHAR(100),
    serial_number VARCHAR(100),
    last_maintenance DATE
);

INSERT INTO equipment_inventory (
    equipment_id, name, category, quantity, location, issue_date,
    condition_status, supplier_name, serial_number, last_maintenance
) VALUES

(1, 'INSAS Rifle', 'Weapon', 50, 'Delhi Cantonment', '2023-01-10', 'Good', 'Ordnance Factory Board', 'RF-DEL-001', '2024-01-05'),
(2, 'Bulletproof Jacket', 'Protective Gear', 100, 'Jammu Base', '2022-11-15', 'Excellent', 'DRDO', 'BPJ-JMU-002', '2023-12-20'),
(3, 'Night Vision Goggles', 'Optics', 30, 'Srinagar HQ', '2023-03-01', 'Good', 'Tata Advanced Systems', 'NVG-SR-003', '2024-02-28'),
(4, 'AK-47 Rifle', 'Weapon', 20, 'Pathankot Depot', '2021-06-12', 'Needs Repair', 'Imported Supplier', 'AK47-PK-004', '2023-07-10'),
(5, 'Combat Helmet', 'Protective Gear', 70, 'Delhi Cantonment', '2023-04-05', 'Good', 'MKU Ltd.', 'CH-DEL-005', '2024-01-15'),
(6, 'Radio Set VHF', 'Communication', 40, 'Leh Base', '2022-12-10', 'Excellent', 'BEL India', 'RS-LEH-006', '2023-11-10'),
(7, 'Field Tent', 'Shelter', 25, 'Jaisalmer Post', '2021-10-20', 'Good', 'Army Workshop', 'FT-JSL-007', '2023-09-25'),
(8, 'Thermal Scope', 'Optics', 15, 'Kupwara Post', '2023-01-18', 'New', 'Tata Advanced Systems', 'TS-KWP-008', '2024-01-20'),
(9, 'Walkie Talkie', 'Communication', 60, 'Jaipur Command', '2022-09-14', 'Good', 'Motorola', 'WT-JPR-009', '2023-10-01'),
(10, 'Grenade Launcher', 'Weapon', 10, 'Ambala Depot', '2021-05-12', 'Functional', 'OFB', 'GL-AMB-010', '2022-12-30'),
(11, 'Binoculars', 'Optics', 80, 'Siachen Base', '2023-07-22', 'Good', 'MKU Ltd.', 'BN-SCH-011', '2024-06-15'),
(12, 'Camouflage Net', 'Utility', 100, 'Jodhpur HQ', '2022-03-10', 'Excellent', 'DRDO', 'CN-JDP-012', '2023-12-10'),
(13, 'Medical Kit', 'Medical', 200, 'Delhi Medical Store', '2023-08-01', 'New', 'Red Cross India', 'MK-DEL-013', '2024-06-30'),
(14, 'Ammunition Box', 'Utility', 75, 'Srinagar HQ', '2021-12-05', 'Functional', 'OFB', 'AB-SR-014', '2023-09-01'),
(15, 'Mine Detector', 'Engineering', 12, 'Manipur Outpost', '2022-04-19', 'Good', 'Bharat Dynamics', 'MD-MNP-015', '2023-10-18'),
(16, 'Battery Pack', 'Electronics', 90, 'Jalandhar Base', '2023-05-30', 'Excellent', 'Amaron', 'BP-JAL-016', '2024-05-01'),
(17, 'Ration Kit', 'Logistics', 300, 'Chandigarh HQ', '2023-02-11', 'New', 'CSD Canteen', 'RK-CHD-017', '2024-02-10'),
(18, 'First Aid Tent', 'Medical', 5, 'Delhi Medical Store', '2022-08-15', 'Good', 'Red Cross India', 'FAT-DEL-018', '2023-08-10'),
(19, 'Portable Stove', 'Utility', 40, 'Kargil Post', '2023-03-27', 'Good', 'Local Vendor', 'PS-KGL-019', '2024-03-01'),
(20, 'Gas Mask', 'Protective Gear', 50, 'Siliguri Base', '2021-07-01', 'Needs Replacement', 'DRDO', 'GM-SLG-020', '2023-06-20');

select * from quipment_inventory ;
 
drop table equipment_inventory ;

 truncate table equipment_inventory;

-- table 23. training_records


 CREATE TABLE training_records (
    training_id INT PRIMARY KEY,
    soldier_id INT,
    course_name VARCHAR(100),
    duration_days INT,
    start_date DATE,
    end_date DATE,
    result VARCHAR(50),
    instructor VARCHAR(100),
    training_center VARCHAR(100),
    certification_status VARCHAR(50)
);

INSERT INTO training_records (
    training_id, soldier_id, course_name, duration_days, start_date,
    end_date, result, instructor, training_center, certification_status
) VALUES
(1, 1, 'Basic Combat Training', 45, '2023-01-01', '2023-02-15', 'Passed', 'Capt. R. Thakur', 'OTA Chennai', 'Certified'),
(2, 2, 'Weapons Handling', 30, '2023-03-01', '2023-03-31', 'Passed', 'Maj. A. Mehta', 'Infantry School Mhow', 'Certified'),
(3, 3, 'Map Reading & Navigation', 20, '2023-04-10', '2023-04-30', 'Passed', 'Lt. K. Nair', 'Jabalpur Center', 'Certified'),
(4, 4, 'Physical Endurance Training', 25, '2023-05-01', '2023-05-26', 'Passed', 'Capt. S. Rawat', 'Pune Camp', 'Certified'),
(5, 5, 'Mountain Warfare', 40, '2023-06-01', '2023-07-10', 'Passed', 'Col. A. Sharma', 'High Altitude Warfare School', 'Certified'),
(6, 6, 'Basic First Aid', 15, '2023-07-20', '2023-08-04', 'Passed', 'Dr. P. Sen', 'Delhi Field Hospital', 'Certified'),
(7, 7, 'Night Combat Training', 28, '2023-08-10', '2023-09-07', 'Passed', 'Maj. B. Kaul', 'Ambala Camp', 'Certified'),
(8, 8, 'Camouflage & Stealth', 18, '2023-09-15', '2023-10-03', 'Passed', 'Capt. H. Chauhan', 'Army Base Kupwara', 'Certified'),
(9, 9, 'Survival Techniques', 35, '2023-10-10', '2023-11-14', 'Passed', 'Col. R. Bhatt', 'Siachen Training School', 'Certified'),
(10, 10, 'Signals and Communication', 30, '2023-12-01', '2023-12-31', 'Passed', 'Maj. D. Naidu', 'Signal Regiment Pune', 'Certified'),
(11, 11, 'Urban Warfare Training', 25, '2024-01-05', '2024-01-30', 'Passed', 'Lt. Gen. A. Menon', 'Secunderabad Base', 'Certified'),
(12, 12, 'Sniper Training', 40, '2024-02-01', '2024-03-12', 'Passed', 'Capt. R. Singh', 'Infantry School Mhow', 'Certified'),
(13, 13, 'Anti-Terrorism Drills', 22, '2024-03-15', '2024-04-06', 'Passed', 'Maj. V. Chauhan', 'NSG Training Camp', 'Certified'),
(14, 14, 'Weapon Assembly & Maintenance', 18, '2024-04-10', '2024-04-28', 'Passed', 'Sub. R. Pandey', 'Army Tech Workshop', 'Certified'),
(15, 15, 'Parade and Discipline', 10, '2024-05-01', '2024-05-11', 'Passed', 'Capt. S. Jaiswal', 'Rajputana Rifles Depot', 'Certified'),
(16, 16, 'Anti-Mine Operations', 30, '2024-05-15', '2024-06-14', 'Passed', 'Lt. K. Suresh', 'Engineers Training Center', 'Certified'),
(17, 17, 'Jungle Warfare', 36, '2024-06-20', '2024-07-26', 'Passed', 'Col. B. Reddy', 'Counter Insurgency School', 'Certified'),
(18, 18, 'Marksmanship', 15, '2024-08-01', '2024-08-16', 'Passed', 'Capt. M. Bhattacharya', 'Artillery School Nashik', 'Certified'),
(19, 19, 'Vehicle Maintenance', 20, '2024-08-20', '2024-09-09', 'Passed', 'Maj. A. Zaveri', 'Mechanized Infantry Center', 'Certified'),
(20, 20, 'Unarmed Combat', 12, '2024-09-15', '2024-09-27', 'Passed', 'Lt. R. Kale', 'OTA Gaya', 'Certified');

select * from training_records;
 
drop table  training_records;

 truncate table training_records ;
