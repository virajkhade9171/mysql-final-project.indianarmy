-- =============================================
-- OFFICERS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for officers table

-- 1. INNER JOIN: Officers with their assigned missions
SELECT o.officer_id, o.name, o.rank, m.name as mission_name, m.status
FROM officers o
INNER JOIN missions m ON o.name = m.commander;

-- 2. LEFT JOIN: All officers with their missions (if any)
SELECT o.officer_id, o.name, o.posting_location, m.name as mission_name
FROM officers o
LEFT JOIN missions m ON o.name = m.commander;

-- 3. RIGHT JOIN: All missions with assigned officers
SELECT m.mission_id, m.name as mission_name, o.name as commander_name, o.rank
FROM officers o
RIGHT JOIN missions m ON o.name = m.commander;

-- 4. SELF JOIN: Find officers in the same location and branch
SELECT o1.name as officer1, o2.name as officer2, o1.posting_location, o1.branch
FROM officers o1
INNER JOIN officers o2 ON o1.posting_location = o2.posting_location 
AND o1.branch = o2.branch
WHERE o1.officer_id < o2.officer_id;

-- 5. MULTIPLE JOINS: Officers with their battalions and missions
SELECT o.name, o.rank, b.name as battalion_name, m.name as mission_name
FROM officers o
LEFT JOIN battalions b ON o.name = b.commander
LEFT JOIN missions m ON o.name = m.commander;

-- SUBQUERIES for officers table

-- 1. Single row subquery: Officer with highest rank
SELECT name, rank, age
FROM officers
WHERE rank = (SELECT MAX(rank) FROM officers);

-- 2. Multiple row subquery: Officers older than average age
SELECT name, age, rank
FROM officers
WHERE age > (SELECT AVG(age) FROM officers);

-- 3. Correlated subquery: Officers with commission date before their battalion creation
SELECT o.name, o.commission_date, b.creation_date
FROM officers o
WHERE EXISTS (
    SELECT 1 FROM battalions b 
    WHERE b.commander = o.name 
    AND o.commission_date < b.creation_date
);

-- 4. Subquery in FROM clause: Count officers by branch
SELECT branch, officer_count
FROM (
    SELECT branch, COUNT(*) as officer_count
    FROM officers
    GROUP BY branch
) AS branch_stats
WHERE officer_count > 2;

-- 5. Subquery with IN: Officers involved in active missions
SELECT name, rank, posting_location
FROM officers
WHERE name IN (
    SELECT commander FROM missions WHERE status = 'Active'
);

-- BUILT-IN FUNCTIONS for officers table

-- 1. String functions: Extract domain from email
SELECT name, email, 
       SUBSTRING_INDEX(email, '@', -1) as email_domain,
       UPPER(name) as upper_name,
       LENGTH(name) as name_length
FROM officers;

-- 2. Date functions: Calculate years of service
SELECT name, commission_date,
       YEAR(CURDATE()) - YEAR(commission_date) as years_of_service,
       DATE_FORMAT(commission_date, '%M %d, %Y') as formatted_date
FROM officers;

-- 3. Aggregate functions: Statistics by branch
SELECT branch,
       COUNT(*) as total_officers,
       AVG(age) as avg_age,
       MIN(commission_date) as earliest_commission,
       MAX(age) as max_age
FROM officers
GROUP BY branch;

-- 4. Mathematical functions: Age analysis
SELECT name, age,
       SQRT(age) as sqrt_age,
       POWER(age, 2) as age_squared,
       ROUND(age * 1.1, 2) as projected_age
FROM officers;

-- 5. Control flow functions: Categorize officers by age
SELECT name, age,
       CASE 
           WHEN age < 30 THEN 'Young'
           WHEN age BETWEEN 30 AND 45 THEN 'Mid-Career'
           ELSE 'Senior'
       END as age_category,
       IF(age > 40, 'Experienced', 'Developing') as experience_level
FROM officers;

-- USER DEFINED FUNCTIONS for officers table

-- 1. Function to calculate retirement eligibility
DELIMITER //
CREATE FUNCTION CheckRetirementEligibility(officer_age INT, service_years INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    IF officer_age >= 50 OR service_years >= 25 THEN
        RETURN 'Eligible for Retirement';
    ELSE
        RETURN 'Not Eligible';
    END IF;
END //
DELIMITER ;

-- 2. Function to get officer grade based on rank
DELIMITER //
CREATE FUNCTION GetOfficerGrade(rank_name VARCHAR(50))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE grade VARCHAR(20);
    
    IF rank_name IN ('Major General', 'Brigadier', 'Colonel') THEN
        SET grade = 'Senior Officer';
    ELSEIF rank_name IN ('Major', 'Lieutenant Colonel', 'Captain') THEN
        SET grade = 'Mid-Level Officer';
    ELSE
        SET grade = 'Junior Officer';
    END IF;
    
    RETURN grade;
END //
DELIMITER ;

-- 3. Function to calculate next promotion year
DELIMITER //
CREATE FUNCTION CalculateNextPromotion(commission_date DATE, current_rank VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE years_to_promotion INT;
    DECLARE service_years INT;
    
    SET service_years = YEAR(CURDATE()) - YEAR(commission_date);
    
    IF current_rank LIKE '%Lieutenant%' THEN
        SET years_to_promotion = 3 - (service_years % 3);
    ELSEIF current_rank LIKE '%Captain%' THEN
        SET years_to_promotion = 4 - (service_years % 4);
    ELSE
        SET years_to_promotion = 5 - (service_years % 5);
    END IF;
    
    RETURN years_to_promotion;
END //
DELIMITER ;

-- 4. Function to validate email format
DELIMITER //
CREATE FUNCTION ValidateEmail(email VARCHAR(100))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF email LIKE '%@army.in' THEN
        RETURN 'Valid';
    ELSE
        RETURN 'Invalid';
    END IF;
END //
DELIMITER ;

-- 5. Function to get posting zone based on location
DELIMITER //
CREATE FUNCTION GetPostingZone(location VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE zone VARCHAR(20);
    
    IF location LIKE '%Delhi%' OR location LIKE '%Chandigarh%' THEN
        SET zone = 'Central Zone';
    ELSEIF location LIKE '%Kashmir%' OR location LIKE '%Leh%' OR location LIKE '%Siachen%' THEN
        SET zone = 'Northern Zone';
    ELSEIF location LIKE '%Pune%' OR location LIKE '%Mumbai%' THEN
        SET zone = 'Western Zone';
    ELSEIF location LIKE '%Chennai%' OR location LIKE '%Bangalore%' THEN
        SET zone = 'Southern Zone';
    ELSEIF location LIKE '%Kolkata%' OR location LIKE '%Guwahati%' THEN
        SET zone = 'Eastern Zone';
    ELSE
        SET zone = 'Other Zone';
    END IF;
    
    RETURN zone;
END //
DELIMITER ;

-- Using the UDFs
SELECT name, age, 
       CheckRetirementEligibility(age, YEAR(CURDATE())-YEAR(commission_date)) as retirement_status,
       GetOfficerGrade(rank) as officer_grade,
       CalculateNextPromotion(commission_date, rank) as years_to_next_promotion,
       ValidateEmail(email) as email_validity,
       GetPostingZone(posting_location) as posting_zone
FROM officers;

-- =============================================
-- SOLDIERS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for soldiers table

-- 1. INNER JOIN: Soldiers with their medical records
SELECT s.soldier_id, s.name, s.rank, m.blood_group, m.last_checkup
FROM soldiers s
INNER JOIN medical_records m ON s.soldier_id = m.soldier_id;

-- 2. LEFT JOIN: All soldiers with leave records
SELECT s.name, s.unit, l.start_date, l.end_date, l.type
FROM soldiers s
LEFT JOIN leave_records l ON s.soldier_id = l.soldier_id;

-- 3. RIGHT JOIN: All promotions with soldier details
SELECT p.promotion_id, s.name, p.old_rank, p.new_rank, p.promotion_date
FROM soldiers s
RIGHT JOIN promotions p ON s.soldier_id = p.soldier_id;

-- 4. MULTIPLE JOINS: Soldiers with medical and leave records
SELECT s.name, s.unit, m.blood_group, l.type as leave_type, l.status
FROM soldiers s
LEFT JOIN medical_records m ON s.soldier_id = m.soldier_id
LEFT JOIN leave_records l ON s.soldier_id = l.soldier_id;

-- 5. SELF JOIN: Find soldiers in same unit
SELECT s1.name as soldier1, s2.name as soldier2, s1.unit
FROM soldiers s1
INNER JOIN soldiers s2 ON s1.unit = s2.unit
WHERE s1.soldier_id < s2.soldier_id;

-- SUBQUERIES for soldiers table

-- 1. Single row subquery: Soldier with longest service
SELECT name, join_date, unit
FROM soldiers
WHERE join_date = (SELECT MIN(join_date) FROM soldiers);

-- 2. Multiple row subquery: Soldiers in units with more than 5 members
SELECT name, unit, posting_location
FROM soldiers
WHERE unit IN (
    SELECT unit FROM soldiers GROUP BY unit HAVING COUNT(*) > 5
);

-- 3. Correlated subquery: Soldiers with medical checkups in last 6 months
SELECT name, unit
FROM soldiers s
WHERE EXISTS (
    SELECT 1 FROM medical_records m 
    WHERE m.soldier_id = s.soldier_id 
    AND m.last_checkup >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);

-- 4. Subquery in SELECT: Count of soldiers per unit with average
SELECT unit, 
       COUNT(*) as soldier_count,
       (SELECT AVG(soldier_count) FROM (
           SELECT unit, COUNT(*) as soldier_count FROM soldiers GROUP BY unit
       ) as unit_stats) as avg_soldiers_per_unit
FROM soldiers
GROUP BY unit;

-- 5. Subquery with ANY: Soldiers who received promotions
SELECT name, rank, join_date
FROM soldiers
WHERE soldier_id = ANY (
    SELECT soldier_id FROM promotions
);

-- BUILT-IN FUNCTIONS for soldiers table

-- 1. String functions: Analyze soldier names and units
SELECT name,
       SUBSTRING(name, 1, LOCATE(' ', name)) as first_name,
       REVERSE(name) as reversed_name,
       REPLACE(unit, 'Battalion', 'Bn') as short_unit
FROM soldiers;

-- 2. Date functions: Service duration analysis
SELECT name, join_date,
       DATEDIFF(CURDATE(), join_date) as days_of_service,
       TIMESTAMPDIFF(YEAR, join_date, CURDATE()) as years_of_service,
       DATE_ADD(join_date, INTERVAL 10 YEAR) as possible_retirement_date
FROM soldiers;

-- 3. Aggregate functions: Unit statistics
SELECT unit,
       COUNT(*) as total_soldiers,
       AVG(TIMESTAMPDIFF(YEAR, join_date, CURDATE())) as avg_service_years,
       MIN(join_date) as earliest_joinee,
       MAX(join_date) as latest_joinee
FROM soldiers
GROUP BY unit;

-- 4. Mathematical functions: Age and service calculations
SELECT name, age,
       age * 365 as approximate_days_old,
       ROUND(age / 10.0, 1) as age_in_decades,
       MOD(age, 10) as years_since_last_decade
FROM soldiers;

-- 5. Control flow functions: Service categorization
SELECT name, join_date,
       CASE 
           WHEN TIMESTAMPDIFF(YEAR, join_date, CURDATE()) < 2 THEN 'New'
           WHEN TIMESTAMPDIFF(YEAR, join_date, CURDATE()) BETWEEN 2 AND 5 THEN 'Experienced'
           ELSE 'Veteran'
       END as service_category,
       IF(TIMESTAMPDIFF(YEAR, join_date, CURDATE()) > 10, 'Long Service', 'Regular') as service_type
FROM soldiers;

-- USER DEFINED FUNCTIONS for soldiers table

-- 1. Function to calculate service completion percentage
DELIMITER //
CREATE FUNCTION CalculateServiceCompletion(join_date DATE, total_service_years INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE years_served INT;
    DECLARE completion_percentage DECIMAL(5,2);
    
    SET years_served = TIMESTAMPDIFF(YEAR, join_date, CURDATE());
    SET completion_percentage = (years_served / total_service_years) * 100;
    
    RETURN LEAST(completion_percentage, 100);
END //
DELIMITER ;

-- 2. Function to determine fitness category based on age
DELIMITER //
CREATE FUNCTION GetFitnessCategory(soldier_age INT, last_checkup_date DATE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE fitness_category VARCHAR(20);
    DECLARE months_since_checkup INT;
    
    SET months_since_checkup = TIMESTAMPDIFF(MONTH, last_checkup_date, CURDATE());
    
    IF soldier_age <= 25 AND months_since_checkup <= 6 THEN
        SET fitness_category = 'Excellent';
    ELSEIF soldier_age <= 35 AND months_since_checkup <= 12 THEN
        SET fitness_category = 'Good';
    ELSEIF months_since_checkup <= 18 THEN
        SET fitness_category = 'Fair';
    ELSE
        SET fitness_category = 'Needs Checkup';
    END IF;
    
    RETURN fitness_category;
END //
DELIMITER ;

-- 3. Function to calculate next increment date
DELIMITER //
CREATE FUNCTION CalculateNextIncrement(join_date DATE)
RETURNS DATE
DETERMINISTIC
BEGIN
    DECLARE years_served INT;
    DECLARE next_increment DATE;
    
    SET years_served = TIMESTAMPDIFF(YEAR, join_date, CURDATE());
    SET next_increment = DATE_ADD(join_date, INTERVAL (years_served + 1) YEAR);
    
    RETURN next_increment;
END //
DELIMITER ;

-- 4. Function to validate posting location compatibility
DELIMITER //
CREATE FUNCTION CheckPostingCompatibility(unit VARCHAR(100), posting_location VARCHAR(100))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    IF (unit LIKE '%Infantry%' AND posting_location IN ('Siachen', 'Leh', 'Kargil')) OR
       (unit LIKE '%Artillery%' AND posting_location IN ('Jaisalmer', 'Barmer')) OR
       (unit LIKE '%Medical%' AND posting_location IN ('Delhi', 'Chennai', 'Lucknow')) THEN
        RETURN 'Compatible';
    ELSE
        RETURN 'Review Needed';
    END IF;
END //
DELIMITER ;

-- 5. Function to determine training eligibility
DELIMITER //
CREATE FUNCTION CheckTrainingEligibility(join_date DATE, current_rank VARCHAR(50))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE service_months INT;
    DECLARE eligibility VARCHAR(20);
    
    SET service_months = TIMESTAMPDIFF(MONTH, join_date, CURDATE());
    
    IF current_rank = 'Sepoy' AND service_months >= 6 THEN
        SET eligibility = 'Eligible';
    ELSEIF current_rank = 'Lance Naik' AND service_months >= 18 THEN
        SET eligibility = 'Eligible';
    ELSEIF current_rank = 'Naik' AND service_months >= 36 THEN
        SET eligibility = 'Eligible';
    ELSE
        SET eligibility = 'Not Eligible';
    END IF;
    
    RETURN eligibility;
END //
DELIMITER ;

-- Using the UDFs for soldiers
SELECT name, unit, posting_location, join_date,
       CalculateServiceCompletion(join_date, 20) as service_completion_percent,
       CheckPostingCompatibility(unit, posting_location) as posting_compatibility,
       CalculateNextIncrement(join_date) as next_increment_date,
       CheckTrainingEligibility(join_date, rank) as training_eligibility
FROM soldiers;

-- =============================================
-- MISSIONS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for missions table

-- 1. INNER JOIN: Missions with their commanders (officers)
SELECT m.mission_id, m.name as mission_name, m.type, o.name as commander, o.rank
FROM missions m
INNER JOIN officers o ON m.commander = o.name;

-- 2. LEFT JOIN: All missions with battalion information
SELECT m.name as mission_name, m.location, b.name as battalion_name, b.commander
FROM missions m
LEFT JOIN battalions b ON m.location LIKE CONCAT('%', b.location, '%');

-- 3. MULTIPLE JOINS: Missions with commanders and their contact details
SELECT m.name as mission_name, m.status, o.name as commander, o.contact_number, o.email
FROM missions m
LEFT JOIN officers o ON m.commander = o.name;

-- 4. SELF JOIN: Find related missions in same location
SELECT m1.name as mission1, m2.name as mission2, m1.location
FROM missions m1
INNER JOIN missions m2 ON m1.location = m2.location AND m1.mission_id < m2.mission_id;

-- 5. RIGHT JOIN: All officers with their assigned missions
SELECT o.name as officer_name, o.rank, m.name as mission_name, m.status
FROM missions m
RIGHT JOIN officers o ON m.commander = o.name;

-- SUBQUERIES for missions table

-- 1. Single row subquery: Longest running mission
SELECT name, start_date, DATEDIFF(COALESCE(end_date, CURDATE()), start_date) as duration_days
FROM missions
WHERE DATEDIFF(COALESCE(end_date, CURDATE()), start_date) = (
    SELECT MAX(DATEDIFF(COALESCE(end_date, CURDATE()), start_date)) FROM missions
);

-- 2. Multiple row subquery: Missions in high priority locations
SELECT name, location, type
FROM missions
WHERE location IN ('Siachen', 'Kargil', 'LoC', 'Poonch Sector');

-- 3. Correlated subquery: Missions with duration longer than average
SELECT name, start_date, end_date, 
       DATEDIFF(COALESCE(end_date, CURDATE()), start_date) as duration
FROM missions m1
WHERE DATEDIFF(COALESCE(end_date, CURDATE()), start_date) > (
    SELECT AVG(DATEDIFF(COALESCE(end_date, CURDATE()), start_date)) 
    FROM missions m2
);

-- 4. Subquery in SELECT: Mission count by type with percentage
SELECT type,
       COUNT(*) as mission_count,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM missions)), 2) as percentage
FROM missions
GROUP BY type;

-- 5. Subquery with EXISTS: Ongoing missions with specific commanders
SELECT name, commander, start_date
FROM missions m
WHERE status = 'Ongoing' AND EXISTS (
    SELECT 1 FROM officers o 
    WHERE o.name = m.commander AND o.rank IN ('Colonel', 'Brigadier')
);

-- BUILT-IN FUNCTIONS for missions table

-- 1. String functions: Mission name analysis
SELECT name,
       LOWER(name) as lower_case_name,
       UPPER(type) as upper_case_type,
       CONCAT(name, ' - ', type) as full_mission_description,
       CHAR_LENGTH(name) as name_length
FROM missions;

-- 2. Date functions: Mission timeline analysis
SELECT name, start_date, end_date,
       DATEDIFF(COALESCE(end_date, CURDATE()), start_date) as days_elapsed,
       DATE_FORMAT(start_date, '%Y-%m') as start_month,
       WEEK(start_date) as start_week
FROM missions;

-- 3. Aggregate functions: Mission statistics by type
SELECT type,
       COUNT(*) as total_missions,
       AVG(DATEDIFF(COALESCE(end_date, CURDATE()), start_date)) as avg_duration,
       MIN(start_date) as earliest_mission,
       MAX(COALESCE(end_date, CURDATE())) as latest_activity
FROM missions
GROUP BY type;

-- 4. Control flow functions: Mission status categorization
SELECT name, status, start_date,
       CASE 
           WHEN status = 'Completed' THEN 'Finished'
           WHEN status = 'Ongoing' THEN 'In Progress'
           WHEN status = 'Scheduled' THEN 'Planned'
           ELSE 'Unknown Status'
       END as status_category,
       IF(DATEDIFF(CURDATE(), start_date) > 365, 'Long Term', 'Short Term') as duration_type
FROM missions;

-- 5. Mathematical functions: Mission duration analysis
SELECT name,
       DATEDIFF(COALESCE(end_date, CURDATE()), start_date) as total_days,
       ROUND(DATEDIFF(COALESCE(end_date, CURDATE()), start_date) / 30.0, 1) as approximate_months,
       MOD(DATEDIFF(COALESCE(end_date, CURDATE()), start_date), 30) as remaining_days
FROM missions;

-- USER DEFINED FUNCTIONS for missions table

-- 1. Function to calculate mission risk level
DELIMITER //
CREATE FUNCTION CalculateMissionRisk(mission_type VARCHAR(50), location VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE risk_level VARCHAR(20);
    
    IF mission_type = 'Combat' AND location IN ('Siachen', 'Kargil', 'LoC') THEN
        SET risk_level = 'Very High';
    ELSEIF mission_type = 'Combat' THEN
        SET risk_level = 'High';
    ELSEIF mission_type = 'Anti-Terror' THEN
        SET risk_level = 'High';
    ELSEIF mission_type = 'Training' THEN
        SET risk_level = 'Low';
    ELSE
        SET risk_level = 'Medium';
    END IF;
    
    RETURN risk_level;
END //
DELIMITER ;

-- 2. Function to determine mission priority based on type and duration
DELIMITER //
CREATE FUNCTION GetMissionPriority(mission_type VARCHAR(50), start_date DATE, end_date DATE)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE mission_duration INT;
    DECLARE priority VARCHAR(15);
    
    SET mission_duration = DATEDIFF(COALESCE(end_date, CURDATE()), start_date);
    
    IF mission_type = 'Combat' AND mission_duration < 7 THEN
        SET priority = 'Critical';
    ELSEIF mission_type IN ('Combat', 'Anti-Terror') THEN
        SET priority = 'High';
    ELSEIF mission_duration > 30 THEN
        SET priority = 'Medium';
    ELSE
        SET priority = 'Low';
    END IF;
    
    RETURN priority;
END //
DELIMITER ;

-- 3. Function to check if mission is overdue
DELIMITER //
CREATE FUNCTION IsMissionOverdue(end_date DATE, status VARCHAR(50))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF status = 'Ongoing' AND end_date IS NOT NULL AND end_date < CURDATE() THEN
        RETURN 'Yes';
    ELSE
        RETURN 'No';
    END IF;
END //
DELIMITER ;

-- 4. Function to calculate mission success probability
DELIMITER //
CREATE FUNCTION CalculateSuccessProbability(mission_type VARCHAR(50), commander_rank VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE probability INT;
    
    IF commander_rank IN ('Colonel', 'Brigadier', 'Major General') THEN
        SET probability = 90;
    ELSEIF commander_rank IN ('Major', 'Lieutenant Colonel') THEN
        SET probability = 80;
    ELSEIF mission_type = 'Training' THEN
        SET probability = 95;
    ELSE
        SET probability = 70;
    END IF;
    
    RETURN probability;
END //
DELIMITER ;

-- 5. Function to get mission phase based on dates
DELIMITER //
CREATE FUNCTION GetMissionPhase(start_date DATE, end_date DATE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE phase VARCHAR(20);
    
    IF CURDATE() < start_date THEN
        SET phase = 'Planning';
    ELSEIF CURDATE() BETWEEN start_date AND COALESCE(end_date, CURDATE()) THEN
        SET phase = 'Execution';
    ELSE
        SET phase = 'Completed';
    END IF;
    
    RETURN phase;
END //
DELIMITER ;

-- Using the UDFs for missions
SELECT name, type, location, commander, start_date, end_date, status,
       CalculateMissionRisk(type, location) as risk_level,
       GetMissionPriority(type, start_date, end_date) as priority,
       IsMissionOverdue(end_date, status) as is_overdue,
       CalculateSuccessProbability(type, 
           (SELECT rank FROM officers WHERE name = commander LIMIT 1)
       ) as success_probability,
       GetMissionPhase(start_date, end_date) as current_phase
FROM missions;

-- =============================================
-- WEAPONS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for weapons table

-- 1. INNER JOIN: Weapons with their assigned battalions
SELECT w.name as weapon_name, w.type, w.quantity, b.name as battalion_name, b.location
FROM weapons w
INNER JOIN battalions b ON w.assigned_unit = b.name;

-- 2. LEFT JOIN: All weapons with inventory status
SELECT w.name, w.type, a.quantity as inventory_quantity, a.condition
FROM weapons w
LEFT JOIN arms_inventory a ON w.name = a.item_name;

-- 3. MULTIPLE JOINS: Weapons with units and locations
SELECT w.name as weapon, w.model, w.assigned_unit, b.location, b.commander
FROM weapons w
LEFT JOIN battalions b ON w.assigned_unit = b.name;

-- 4. SELF JOIN: Find similar weapons by type
SELECT w1.name as weapon1, w2.name as weapon2, w1.type
FROM weapons w1
INNER JOIN weapons w2 ON w1.type = w2.type AND w1.weapon_id < w2.weapon_id;

-- 5. RIGHT JOIN: All inventory items with weapon details
SELECT a.item_name, a.type, a.quantity, w.range_km, w.manufacturer
FROM weapons w
RIGHT JOIN arms_inventory a ON w.name = a.item_name;

-- SUBQUERIES for weapons table

-- 1. Single row subquery: Weapon with longest range
SELECT name, type, range_km
FROM weapons
WHERE range_km = (SELECT MAX(range_km) FROM weapons);

-- 2. Multiple row subquery: Weapons assigned to infantry units
SELECT name, type, assigned_unit
FROM weapons
WHERE assigned_unit LIKE '%Infantry%';

-- 3. Correlated subquery: Weapons with quantity above average for their type
SELECT name, type, quantity
FROM weapons w1
WHERE quantity > (
    SELECT AVG(quantity) 
    FROM weapons w2 
    WHERE w2.type = w1.type
);

-- 4. Subquery in HAVING: Weapon types with high total quantity
SELECT type, SUM(quantity) as total_quantity
FROM weapons
GROUP BY type
HAVING SUM(quantity) > (
    SELECT AVG(total_qty) FROM (
        SELECT SUM(quantity) as total_qty FROM weapons GROUP BY type
    ) as type_totals
);

-- 5. Subquery with EXISTS: Active weapons in specific locations
SELECT w.name, w.type, w.assigned_unit
FROM weapons w
WHERE w.status = 'Active' AND EXISTS (
    SELECT 1 FROM battalions b 
    WHERE b.name = w.assigned_unit 
    AND b.location IN ('Siachen', 'Kargil', 'Leh')
);

-- BUILT-IN FUNCTIONS for weapons table

-- 1. String functions: Weapon name and type analysis
SELECT name,
       REPLACE(name, 'Rifle', 'Rfl') as abbreviated_name,
       CONCAT(type, ' - ', model) as full_description,
       REVERSE(name) as reversed_name,
       LOCATE(' ', name) as first_space_position
FROM weapons;

-- 2. Mathematical functions: Range and quantity calculations
SELECT name, range_km, quantity,
       ROUND(range_km * 1000, 0) as range_meters,
       SQRT(quantity) as sqrt_quantity,
       POWER(quantity, 2) as quantity_squared,
       ROUND(quantity * 1.1, 0) as projected_quantity
FROM weapons;

-- 3. Aggregate functions: Weapon statistics by type
SELECT type,
       COUNT(*) as weapon_types,
       SUM(quantity) as total_quantity,
       AVG(range_km) as avg_range,
       MAX(quantity) as max_quantity
FROM weapons
GROUP BY type;

-- 4. Control flow functions: Weapon status categorization
SELECT name, status, quantity,
       CASE 
           WHEN status = 'Active' AND quantity > 100 THEN 'Fully Operational'
           WHEN status = 'Active' AND quantity BETWEEN 50 AND 100 THEN 'Partially Operational'
           WHEN status = 'Active' THEN 'Limited Stock'
           ELSE 'Not Operational'
       END as operational_status,
       IF(quantity < 10, 'Low Stock', 'Adequate Stock') as stock_level
FROM weapons;

-- 5. Date simulation functions (using string functions for demonstration)
SELECT name,
       CONCAT('WPN-', weapon_id) as weapon_code,
       SUBSTRING(manufacturer, 1, 3) as manufacturer_code,
       CHAR_LENGTH(name) as name_complexity
FROM weapons;

-- USER DEFINED FUNCTIONS for weapons table

-- 1. Function to calculate weapon effectiveness score
DELIMITER //
CREATE FUNCTION CalculateWeaponEffectiveness(range_km DECIMAL(6,2), quantity INT, status VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE effectiveness INT;
    
    SET effectiveness = (range_km * 10) + (quantity / 10);
    
    IF status != 'Active' THEN
        SET effectiveness = effectiveness * 0.5;
    END IF;
    
    RETURN LEAST(effectiveness, 100);
END //
DELIMITER ;

-- 2. Function to determine weapon category by range
DELIMITER //
CREATE FUNCTION GetWeaponRangeCategory(range_km DECIMAL(6,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE range_category VARCHAR(20);
    
    IF range_km < 1 THEN
        SET range_category = 'Short Range';
    ELSEIF range_km BETWEEN 1 AND 10 THEN
        SET range_category = 'Medium Range';
    ELSEIF range_km BETWEEN 10 AND 100 THEN
        SET range_category = 'Long Range';
    ELSE
        SET range_category = 'Strategic Range';
    END IF;
    
    RETURN range_category;
END //
DELIMITER ;

-- 3. Function to check weapon deployment readiness
DELIMITER //
CREATE FUNCTION CheckDeploymentReadiness(status VARCHAR(50), quantity INT, assigned_unit VARCHAR(100))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    IF status = 'Active' AND quantity >= 10 AND assigned_unit IS NOT NULL THEN
        RETURN 'Ready';
    ELSEIF status = 'Active' AND quantity < 10 THEN
        RETURN 'Limited';
    ELSE
        RETURN 'Not Ready';
    END IF;
END //
DELIMITER ;

-- 4. Function to calculate maintenance priority
DELIMITER //
CREATE FUNCTION CalculateMaintenancePriority(weapon_type VARCHAR(50), quantity INT, status VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE priority VARCHAR(15);
    
    IF status != 'Active' THEN
        SET priority = 'High';
    ELSEIF weapon_type IN ('Tank', 'Howitzer', 'Missile') AND quantity < 5 THEN
        SET priority = 'High';
    ELSEIF quantity < 20 THEN
        SET priority = 'Medium';
    ELSE
        SET priority = 'Low';
    END IF;
    
    RETURN priority;
END //
DELIMITER ;

-- 5. Function to get weapon origin type
DELIMITER //
CREATE FUNCTION GetWeaponOrigin(manufacturer VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE origin VARCHAR(20);
    
    IF manufacturer LIKE '%India%' OR manufacturer LIKE '%DRDO%' OR manufacturer LIKE '%OFB%' THEN
        SET origin = 'Domestic';
    ELSEIF manufacturer LIKE '%Russia%' THEN
        SET origin = 'Russian';
    ELSEIF manufacturer LIKE '%USA%' THEN
        SET origin = 'American';
    ELSEIF manufacturer LIKE '%Israel%' THEN
        SET origin = 'Israeli';
    ELSE
        SET origin = 'Other';
    END IF;
    
    RETURN origin;
END //
DELIMITER ;

-- Using the UDFs for weapons
SELECT name, type, range_km, quantity, status, manufacturer, assigned_unit,
       CalculateWeaponEffectiveness(range_km, quantity, status) as effectiveness_score,
       GetWeaponRangeCategory(range_km) as range_category,
       CheckDeploymentReadiness(status, quantity, assigned_unit) as deployment_status,
       CalculateMaintenancePriority(type, quantity, status) as maintenance_priority,
       GetWeaponOrigin(manufacturer) as weapon_origin
FROM weapons;

-- =============================================
-- BATTLIONS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for battalions table

-- 1. INNER JOIN: Battalions with their commanders (officers)
SELECT b.battalion_id, b.name as battalion_name, b.location, o.name as commander, o.rank
FROM battalions b
INNER JOIN officers o ON b.commander = o.name;

-- 2. LEFT JOIN: All battalions with their assigned weapons
SELECT b.name as battalion_name, b.location, w.name as weapon_name, w.type
FROM battalions b
LEFT JOIN weapons w ON b.name = w.assigned_unit;

-- 3. RIGHT JOIN: All officers with their commanded battalions
SELECT o.name as officer_name, o.rank, b.name as battalion_name, b.location
FROM battalions b
RIGHT JOIN officers o ON b.commander = o.name;

-- 4. MULTIPLE JOINS: Battalions with commanders and their missions
SELECT b.name as battalion, b.location, o.name as commander, m.name as mission_name
FROM battalions b
LEFT JOIN officers o ON b.commander = o.name
LEFT JOIN missions m ON o.name = m.commander;

-- 5. SELF JOIN: Find battalions in same region
SELECT b1.name as battalion1, b2.name as battalion2, b1.region
FROM battalions b1
INNER JOIN battalions b2 ON b1.region = b2.region AND b1.battalion_id < b2.battalion_id;

-- SUBQUERIES for battalions table

-- 1. Single row subquery: Battalion with most soldiers
SELECT name, location, soldiers_count
FROM battalions
WHERE soldiers_count = (SELECT MAX(soldiers_count) FROM battalions);

-- 2. Multiple row subquery: Battalions in Northern Command
SELECT name, location, commander
FROM battalions
WHERE region = 'Northern Command';

-- 3. Correlated subquery: Battalions with above average vehicle count
SELECT name, vehicles_count, soldiers_count
FROM battalions b1
WHERE vehicles_count > (
    SELECT AVG(vehicles_count) 
    FROM battalions b2 
    WHERE b2.region = b1.region
);

-- 4. Subquery in SELECT: Battalion statistics with averages
SELECT region,
       COUNT(*) as battalion_count,
       AVG(soldiers_count) as avg_soldiers,
       (SELECT AVG(soldiers_count) FROM battalions) as overall_avg_soldiers
FROM battalions
GROUP BY region;

-- 5. Subquery with ANY: Battalions with special forces weapons
SELECT name, location
FROM battalions
WHERE name = ANY (
    SELECT assigned_unit FROM weapons WHERE type IN ('Sniper Rifle', 'SMG', 'Missile')
);

-- BUILT-IN FUNCTIONS for battalions table

-- 1. String functions: Battalion name analysis
SELECT name,
       REPLACE(name, 'Battalion', 'Bn') as short_name,
       UPPER(region) as upper_region,
       CONCAT(name, ' (', location, ')') as full_description
FROM battalions;

-- 2. Date functions: Battalion age calculation
SELECT name, creation_date,
       YEAR(CURDATE()) - YEAR(creation_date) as years_active,
       DATE_FORMAT(creation_date, '%Y-%m') as creation_month
FROM battalions;

-- 3. Aggregate functions: Regional statistics
SELECT region,
       COUNT(*) as total_battalions,
       SUM(soldiers_count) as total_soldiers,
       AVG(vehicles_count) as avg_vehicles,
       MIN(creation_date) as oldest_battalion
FROM battalions
GROUP BY region;

-- 4. Mathematical functions: Soldier to vehicle ratio
SELECT name, soldiers_count, vehicles_count,
       ROUND(soldiers_count / NULLIF(vehicles_count, 0), 2) as soldiers_per_vehicle,
       soldiers_count * 10 as estimated_equipment_cost
FROM battalions;

-- 5. Control flow functions: Battalion status categorization
SELECT name, status, soldiers_count,
       CASE 
           WHEN soldiers_count > 700 THEN 'Large Battalion'
           WHEN soldiers_count > 500 THEN 'Medium Battalion'
           ELSE 'Small Battalion'
       END as size_category,
       IF(status = 'Active', 'Operational', 'Non-Operational') as operational_status
FROM battalions;

-- USER DEFINED FUNCTIONS for battalions table

-- 1. Function to calculate battalion readiness score
DELIMITER //
CREATE FUNCTION CalculateBattalionReadiness(soldiers_count INT, vehicles_count INT, status VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE readiness_score INT;
    
    SET readiness_score = (soldiers_count / 10) + (vehicles_count * 5);
    
    IF status != 'Active' THEN
        SET readiness_score = readiness_score * 0.5;
    END IF;
    
    RETURN LEAST(readiness_score, 100);
END //
DELIMITER ;

-- 2. Function to determine battalion type by name
DELIMITER //
CREATE FUNCTION GetBattalionType(battalion_name VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE battalion_type VARCHAR(20);
    
    IF battalion_name LIKE '%Infantry%' THEN
        SET battalion_type = 'Infantry';
    ELSEIF battalion_name LIKE '%Artillery%' THEN
        SET battalion_type = 'Artillery';
    ELSEIF battalion_name LIKE '%Armoured%' THEN
        SET battalion_type = 'Armoured';
    ELSEIF battalion_name LIKE '%Signals%' THEN
        SET battalion_type = 'Signals';
    ELSEIF battalion_name LIKE '%Medical%' THEN
        SET battalion_type = 'Medical';
    ELSEIF battalion_name LIKE '%Engineers%' THEN
        SET battalion_type = 'Engineering';
    ELSE
        SET battalion_type = 'Other';
    END IF;
    
    RETURN battalion_type;
END //
DELIMITER ;

-- 3. Function to check deployment capability
DELIMITER //
CREATE FUNCTION CheckDeploymentCapability(soldiers_count INT, vehicles_count INT, location VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE capability VARCHAR(20);
    
    IF soldiers_count >= 500 AND vehicles_count >= 20 THEN
        SET capability = 'Full Deployment';
    ELSEIF soldiers_count >= 300 THEN
        SET capability = 'Partial Deployment';
    ELSEIF location IN ('Siachen', 'Kargil') AND soldiers_count >= 200 THEN
        SET capability = 'Special Deployment';
    ELSE
        SET capability = 'Limited Deployment';
    END IF;
    
    RETURN capability;
END //
DELIMITER ;

-- 4. Function to calculate maintenance requirements
DELIMITER //
CREATE FUNCTION CalculateMaintenanceNeeds(vehicles_count INT, creation_date DATE)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE maintenance_needs VARCHAR(15);
    DECLARE battalion_age INT;
    
    SET battalion_age = YEAR(CURDATE()) - YEAR(creation_date);
    
    IF vehicles_count > 50 OR battalion_age > 20 THEN
        SET maintenance_needs = 'High';
    ELSEIF vehicles_count > 30 OR battalion_age > 10 THEN
        SET maintenance_needs = 'Medium';
    ELSE
        SET maintenance_needs = 'Low';
    END IF;
    
    RETURN maintenance_needs;
END //
DELIMITER ;

-- 5. Function to get operational region type
DELIMITER //
CREATE FUNCTION GetRegionType(region VARCHAR(100))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE region_type VARCHAR(15);
    
    IF region LIKE '%Northern%' THEN
        SET region_type = 'Border Region';
    ELSEIF region LIKE '%Western%' THEN
        SET region_type = 'Desert Region';
    ELSEIF region LIKE '%Eastern%' THEN
        SET region_type = 'Forest Region';
    ELSEIF region LIKE '%Southern%' THEN
        SET region_type = 'Coastal Region';
    ELSE
        SET region_type = 'Central Region';
    END IF;
    
    RETURN region_type;
END //
DELIMITER ;

-- Using the UDFs for battalions
SELECT name, location, region, soldiers_count, vehicles_count, creation_date, status,
       CalculateBattalionReadiness(soldiers_count, vehicles_count, status) as readiness_score,
       GetBattalionType(name) as battalion_type,
       CheckDeploymentCapability(soldiers_count, vehicles_count, location) as deployment_capability,
       CalculateMaintenanceNeeds(vehicles_count, creation_date) as maintenance_needs,
       GetRegionType(region) as region_type
FROM battalions;

-- =============================================
-- TRAINING_CENTERS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for training_centers table

-- 1. INNER JOIN: Training centers with their in-charge officers
SELECT t.center_id, t.name as center_name, t.location, o.name as in_charge, o.rank
FROM training_centers t
INNER JOIN officers o ON t.in_charge = o.name;

-- 2. LEFT JOIN: Training centers with courses offered
SELECT t.name as center_name, t.location, 
       SUBSTRING_INDEX(t.courses_offered, ',', 1) as primary_course
FROM training_centers t;

-- 3. MULTIPLE JOINS: Training centers with contact officers
SELECT t.name as training_center, t.location, o.name as in_charge, o.contact_number
FROM training_centers t
LEFT JOIN officers o ON t.in_charge = o.name;

-- 4. SELF JOIN: Find training centers in same state
SELECT t1.name as center1, t2.name as center2, t1.location
FROM training_centers t1
INNER JOIN training_centers t2 ON 
    SUBSTRING_INDEX(t1.location, ',', -1) = SUBSTRING_INDEX(t2.location, ',', -1)
    AND t1.center_id < t2.center_id;

-- 5. RIGHT JOIN: All officers with their training center responsibilities
SELECT o.name as officer_name, o.rank, t.name as training_center, t.location
FROM training_centers t
RIGHT JOIN officers o ON t.in_charge = o.name;

-- SUBQUERIES for training_centers table

-- 1. Single row subquery: Oldest training center
SELECT name, location, established_year
FROM training_centers
WHERE established_year = (SELECT MIN(established_year) FROM training_centers);

-- 2. Multiple row subquery: Training centers with large capacity
SELECT name, location, trainee_capacity
FROM training_centers
WHERE trainee_capacity > 1000;

-- 3. Correlated subquery: Centers with capacity above regional average
SELECT t1.name, t1.trainee_capacity, t1.location
FROM training_centers t1
WHERE t1.trainee_capacity > (
    SELECT AVG(t2.trainee_capacity) 
    FROM training_centers t2 
    WHERE SUBSTRING_INDEX(t2.location, ',', -1) = SUBSTRING_INDEX(t1.location, ',', -1)
);

-- 4. Subquery in HAVING: Locations with multiple training centers
SELECT SUBSTRING_INDEX(location, ',', -1) as state,
       COUNT(*) as center_count
FROM training_centers
GROUP BY SUBSTRING_INDEX(location, ',', -1)
HAVING COUNT(*) > 1;

-- 5. Subquery with EXISTS: Active training centers with infantry courses
SELECT name, courses_offered
FROM training_centers t
WHERE status = 'Active' AND EXISTS (
    SELECT 1 WHERE t.courses_offered LIKE '%Infantry%'
);

-- BUILT-IN FUNCTIONS for training_centers table

-- 1. String functions: Course and location analysis
SELECT name,
       SUBSTRING_INDEX(location, ',', 1) as city,
       UPPER(name) as upper_name,
       LENGTH(courses_offered) as courses_description_length
FROM training_centers;

-- 2. Mathematical functions: Capacity utilization analysis
SELECT name, trainee_capacity, established_year,
       trainee_capacity * 10 as estimated_annual_trainees,
       (YEAR(CURDATE()) - established_year) as years_operational
FROM training_centers;

-- 3. Aggregate functions: Regional training capacity
SELECT SUBSTRING_INDEX(location, ',', -1) as region,
       COUNT(*) as training_centers,
       SUM(trainee_capacity) as total_capacity,
       AVG(YEAR(CURDATE()) - established_year) as avg_age_years
FROM training_centers
GROUP BY SUBSTRING_INDEX(location, ',', -1);

-- 4. Control flow functions: Center size categorization
SELECT name, trainee_capacity,
       CASE 
           WHEN trainee_capacity > 1500 THEN 'Large Center'
           WHEN trainee_capacity > 800 THEN 'Medium Center'
           ELSE 'Small Center'
       END as size_category,
       IF(YEAR(CURDATE()) - established_year > 50, 'Heritage Center', 'Modern Center') as center_type
FROM training_centers;

-- 5. Date functions: Establishment analysis
SELECT name, established_year,
       MAKEDATE(established_year, 1) as establishment_date,
       YEAR(CURDATE()) - established_year as years_active
FROM training_centers;

-- USER DEFINED FUNCTIONS for training_centers table

-- 1. Function to calculate training center efficiency
DELIMITER //
CREATE FUNCTION CalculateTrainingEfficiency(trainee_capacity INT, established_year INT, status VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE efficiency_score INT;
    DECLARE center_age INT;
    
    SET center_age = YEAR(CURDATE()) - established_year;
    SET efficiency_score = (trainee_capacity / 10) + (center_age / 2);
    
    IF status != 'Active' THEN
        SET efficiency_score = efficiency_score * 0.3;
    END IF;
    
    RETURN LEAST(efficiency_score, 100);
END //
DELIMITER ;

-- 2. Function to determine center specialization
DELIMITER //
CREATE FUNCTION GetCenterSpecialization(courses_offered VARCHAR(255))
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE specialization VARCHAR(30);
    
    IF courses_offered LIKE '%Infantry%' THEN
        SET specialization = 'Infantry Training';
    ELSEIF courses_offered LIKE '%Artillery%' THEN
        SET specialization = 'Artillery Training';
    ELSEIF courses_offered LIKE '%Armoured%' THEN
        SET specialization = 'Armoured Training';
    ELSEIF courses_offered LIKE '%Medical%' THEN
        SET specialization = 'Medical Training';
    ELSEIF courses_offered LIKE '%Signal%' THEN
        SET specialization = 'Communications Training';
    ELSE
        SET specialization = 'General Training';
    END IF;
    
    RETURN specialization;
END //
DELIMITER ;

-- 3. Function to check infrastructure adequacy
DELIMITER //
CREATE FUNCTION CheckInfrastructureAdequacy(trainee_capacity INT, established_year INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE adequacy VARCHAR(20);
    DECLARE center_age INT;
    
    SET center_age = YEAR(CURDATE()) - established_year;
    
    IF trainee_capacity >= 1000 AND center_age < 30 THEN
        SET adequacy = 'Excellent';
    ELSEIF trainee_capacity >= 500 OR center_age < 20 THEN
        SET adequacy = 'Good';
    ELSE
        SET adequacy = 'Needs Upgrade';
    END IF;
    
    RETURN adequacy;
END //
DELIMITER ;

-- 4. Function to calculate modernization priority
DELIMITER //
CREATE FUNCTION CalculateModernizationPriority(established_year INT, trainee_capacity INT)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE priority VARCHAR(15);
    
    IF established_year < 1970 THEN
        SET priority = 'High';
    ELSEIF established_year < 1990 AND trainee_capacity > 800 THEN
        SET priority = 'Medium';
    ELSE
        SET priority = 'Low';
    END IF;
    
    RETURN priority;
END //
DELIMITER ;

-- 5. Function to get training center level
DELIMITER //
CREATE FUNCTION GetTrainingCenterLevel(courses_offered VARCHAR(255), trainee_capacity INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE center_level VARCHAR(20);
    
    IF courses_offered LIKE '%Advanced%' OR courses_offered LIKE '%Special%' THEN
        SET center_level = 'Advanced';
    ELSEIF trainee_capacity > 1000 THEN
        SET center_level = 'Major';
    ELSEIF courses_offered LIKE '%Basic%' THEN
        SET center_level = 'Basic';
    ELSE
        SET center_level = 'Intermediate';
    END IF;
    
    RETURN center_level;
END //
DELIMITER ;

-- Using the UDFs for training_centers
SELECT name, location, established_year, trainee_capacity, courses_offered, status,
       CalculateTrainingEfficiency(trainee_capacity, established_year, status) as efficiency_score,
       GetCenterSpecialization(courses_offered) as specialization,
       CheckInfrastructureAdequacy(trainee_capacity, established_year) as infrastructure_adequacy,
       CalculateModernizationPriority(established_year, trainee_capacity) as modernization_priority,
       GetTrainingCenterLevel(courses_offered, trainee_capacity) as center_level
FROM training_centers;

-- =============================================
-- VEHICLES TABLE QUERIES
-- =============================================

-- JOINS QUERIES for vehicles table

-- 1. INNER JOIN: Vehicles with their assigned battalions
SELECT v.vehicle_id, v.name as vehicle_name, v.type, b.name as battalion_name, b.location
FROM vehicles v
INNER JOIN battalions b ON v.assigned_unit = b.name;

-- 2. LEFT JOIN: All vehicles with maintenance records (simulated)
SELECT v.name, v.type, v.status, 
       CASE 
           WHEN v.status = 'Under Maintenance' THEN 'Needs Repair'
           ELSE 'Operational'
       END as maintenance_status
FROM vehicles v;

-- 3. MULTIPLE JOINS: Vehicles with units and locations
SELECT v.name as vehicle, v.type, v.assigned_unit, b.location, b.commander
FROM vehicles v
LEFT JOIN battalions b ON v.assigned_unit = b.name;

-- 4. SELF JOIN: Find similar vehicles by type
SELECT v1.name as vehicle1, v2.name as vehicle2, v1.type
FROM vehicles v1
INNER JOIN vehicles v2 ON v1.type = v2.type AND v1.vehicle_id < v2.vehicle_id;

-- 5. RIGHT JOIN: All battalions with their vehicles
SELECT b.name as battalion_name, b.location, v.name as vehicle_name, v.type
FROM vehicles v
RIGHT JOIN battalions b ON v.assigned_unit = b.name;

-- SUBQUERIES for vehicles table

-- 1. Single row subquery: Vehicle with highest capacity
SELECT name, type, capacity
FROM vehicles
WHERE capacity = (SELECT MAX(capacity) FROM vehicles);

-- 2. Multiple row subquery: Tactical vehicles
SELECT name, type, capacity
FROM vehicles
WHERE type IN ('Tactical Vehicle', 'Jeep', 'SUV');

-- 3. Correlated subquery: Vehicles older than average for their type
SELECT v1.name, v1.type, v1.in_service_date
FROM vehicles v1
WHERE DATEDIFF(CURDATE(), v1.in_service_date) > (
    SELECT AVG(DATEDIFF(CURDATE(), v2.in_service_date))
    FROM vehicles v2 
    WHERE v2.type = v1.type
);

-- 4. Subquery in HAVING: Vehicle types with high total capacity
SELECT type, SUM(capacity) as total_capacity
FROM vehicles
GROUP BY type
HAVING SUM(capacity) > (
    SELECT AVG(total_cap) FROM (
        SELECT SUM(capacity) as total_cap FROM vehicles GROUP BY type
    ) as type_capacities
);

-- 5. Subquery with EXISTS: Active vehicles in combat units
SELECT v.name, v.type, v.assigned_unit
FROM vehicles v
WHERE v.status = 'Active' AND EXISTS (
    SELECT 1 FROM battalions b 
    WHERE b.name = v.assigned_unit 
    AND b.name LIKE '%Infantry%'
);

-- BUILT-IN FUNCTIONS for vehicles table

-- 1. String functions: Vehicle name analysis
SELECT name,
       REPLACE(name, 'Tata ', '') as short_name,
       CONCAT(type, ' - ', model) as full_description,
       REVERSE(registration_no) as reversed_registration
FROM vehicles;

-- 2. Date functions: Vehicle age and service analysis
SELECT name, in_service_date,
       YEAR(CURDATE()) - YEAR(in_service_date) as years_in_service,
       DATE_ADD(in_service_date, INTERVAL 15 YEAR) as possible_retirement_date
FROM vehicles;

-- 3. Aggregate functions: Vehicle statistics by type
SELECT type,
       COUNT(*) as total_vehicles,
       AVG(capacity) as avg_capacity,
       MIN(in_service_date) as oldest_vehicle,
       MAX(capacity) as max_capacity
FROM vehicles
GROUP BY type;

-- 4. Mathematical functions: Capacity and utilization calculations
SELECT name, capacity,
       capacity * 2 as double_capacity,
       ROUND(capacity * 0.8, 0) as recommended_capacity,
       capacity * 100 as weight_capacity_kg
FROM vehicles;

-- 5. Control flow functions: Vehicle status categorization
SELECT name, status, capacity,
       CASE 
           WHEN status = 'Active' AND capacity > 20 THEN 'Heavy Transport'
           WHEN status = 'Active' AND capacity > 10 THEN 'Medium Transport'
           WHEN status = 'Active' THEN 'Light Transport'
           ELSE 'Non-Operational'
       END as transport_category,
       IF(YEAR(CURDATE()) - YEAR(in_service_date) > 10, 'Aging', 'Modern') as age_category
FROM vehicles;

-- USER DEFINED FUNCTIONS for vehicles table

-- 1. Function to calculate vehicle operational score
DELIMITER //
CREATE FUNCTION CalculateVehicleOperationalScore(capacity INT, in_service_date DATE, status VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE operational_score INT;
    DECLARE vehicle_age INT;
    
    SET vehicle_age = YEAR(CURDATE()) - YEAR(in_service_date);
    SET operational_score = (capacity * 2) - (vehicle_age * 3);
    
    IF status != 'Active' THEN
        SET operational_score = operational_score * 0.2;
    END IF;
    
    RETURN GREATEST(operational_score, 0);
END //
DELIMITER ;

-- 2. Function to determine vehicle class
DELIMITER //
CREATE FUNCTION GetVehicleClass(vehicle_type VARCHAR(50), capacity INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE vehicle_class VARCHAR(20);
    
    IF vehicle_type = 'Tank' THEN
        SET vehicle_class = 'Combat';
    ELSEIF vehicle_type IN ('Truck', 'SUV', 'Jeep') AND capacity > 15 THEN
        SET vehicle_class = 'Transport';
    ELSEIF vehicle_type IN ('Medical', 'Ambulance') THEN
        SET vehicle_class = 'Support';
    ELSEIF vehicle_type LIKE '%Radar%' OR vehicle_type LIKE '%UAV%' THEN
        SET vehicle_class = 'Surveillance';
    ELSE
        SET vehicle_class = 'Utility';
    END IF;
    
    RETURN vehicle_class;
END //
DELIMITER ;

-- 3. Function to check vehicle replacement need
DELIMITER //
CREATE FUNCTION CheckReplacementNeed(in_service_date DATE, status VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE replacement_need VARCHAR(15);
    DECLARE vehicle_age INT;
    
    SET vehicle_age = YEAR(CURDATE()) - YEAR(in_service_date);
    
    IF vehicle_age > 15 OR status = 'Decommissioned' THEN
        SET replacement_need = 'Immediate';
    ELSEIF vehicle_age > 10 THEN
        SET replacement_need = 'Soon';
    ELSE
        SET replacement_need = 'Not Needed';
    END IF;
    
    RETURN replacement_need;
END //
DELIMITER ;

-- 4. Function to calculate maintenance priority
DELIMITER //
CREATE FUNCTION CalculateVehicleMaintenancePriority(vehicle_type VARCHAR(50), status VARCHAR(50), in_service_date DATE)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE priority VARCHAR(15);
    DECLARE vehicle_age INT;
    
    SET vehicle_age = YEAR(CURDATE()) - YEAR(in_service_date);
    
    IF status = 'Under Maintenance' THEN
        SET priority = 'Critical';
    ELSEIF vehicle_type IN ('Tank', 'IFV') AND vehicle_age > 8 THEN
        SET priority = 'High';
    ELSEIF vehicle_age > 12 THEN
        SET priority = 'High';
    ELSE
        SET priority = 'Normal';
    END IF;
    
    RETURN priority;
END //
DELIMITER ;

-- 5. Function to get vehicle deployment type
DELIMITER //
CREATE FUNCTION GetVehicleDeploymentType(vehicle_type VARCHAR(50), capacity INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE deployment_type VARCHAR(20);
    
    IF vehicle_type = 'Tank' THEN
        SET deployment_type = 'Frontline Combat';
    ELSEIF capacity > 20 THEN
        SET deployment_type = 'Logistics Support';
    ELSEIF vehicle_type LIKE '%Medical%' THEN
        SET deployment_type = 'Medical Evacuation';
    ELSEIF vehicle_type LIKE '%Radar%' THEN
        SET deployment_type = 'Surveillance';
    ELSE
        SET deployment_type = 'General Purpose';
    END IF;
    
    RETURN deployment_type;
END //
DELIMITER ;

-- Using the UDFs for vehicles
SELECT name, type, capacity, in_service_date, status, assigned_unit,
       CalculateVehicleOperationalScore(capacity, in_service_date, status) as operational_score,
       GetVehicleClass(type, capacity) as vehicle_class,
       CheckReplacementNeed(in_service_date, status) as replacement_need,
       CalculateVehicleMaintenancePriority(type, status, in_service_date) as maintenance_priority,
       GetVehicleDeploymentType(type, capacity) as deployment_type
FROM vehicles;

-- =============================================
-- MEDICAL_RECORDS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for medical_records table

-- 1. INNER JOIN: Medical records with soldier details
SELECT m.record_id, s.name as soldier_name, s.rank, m.blood_group, m.last_checkup
FROM medical_records m
INNER JOIN soldiers s ON m.soldier_id = s.soldier_id;

-- 2. LEFT JOIN: All medical records with detailed soldier info
SELECT m.record_id, s.name, s.unit, m.blood_pressure, m.medical_condition
FROM medical_records m
LEFT JOIN soldiers s ON m.soldier_id = s.soldier_id;

-- 3. MULTIPLE JOINS: Medical records with soldiers and their units
SELECT m.record_id, s.name, s.unit, m.blood_group, m.last_checkup, b.location
FROM medical_records m
INNER JOIN soldiers s ON m.soldier_id = s.soldier_id
LEFT JOIN battalions b ON s.unit = b.name;

-- 4. SELF JOIN: Find soldiers with similar medical conditions
SELECT m1.soldier_id as soldier1, m2.soldier_id as soldier2, m1.medical_condition
FROM medical_records m1
INNER JOIN medical_records m2 ON m1.medical_condition = m2.medical_condition 
AND m1.record_id < m2.record_id
WHERE m1.medical_condition != 'None';

-- 5. RIGHT JOIN: All soldiers with their medical records
SELECT s.name, s.rank, m.blood_group, m.last_checkup, m.medical_condition
FROM medical_records m
RIGHT JOIN soldiers s ON m.soldier_id = s.soldier_id;

-- SUBQUERIES for medical_records table

-- 1. Single row subquery: Most recent medical checkup
SELECT s.name, m.last_checkup, m.doctor_name
FROM medical_records m
INNER JOIN soldiers s ON m.soldier_id = s.soldier_id
WHERE m.last_checkup = (SELECT MAX(last_checkup) FROM medical_records);

-- 2. Multiple row subquery: Soldiers with specific blood groups
SELECT s.name, m.blood_group, m.last_checkup
FROM medical_records m
INNER JOIN soldiers s ON m.soldier_id = s.soldier_id
WHERE m.blood_group IN ('O+', 'B+', 'A+');

-- 3. Correlated subquery: Soldiers needing medical attention
SELECT s.name, m.last_checkup, m.medical_condition
FROM medical_records m
INNER JOIN soldiers s ON m.soldier_id = s.soldier_id
WHERE m.last_checkup < (
    SELECT DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
) OR m.medical_condition != 'None';

-- 4. Subquery in SELECT: Blood group statistics
SELECT blood_group,
       COUNT(*) as total_soldiers,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM medical_records)), 2) as percentage
FROM medical_records
GROUP BY blood_group;

-- 5. Subquery with EXISTS: Soldiers with recent checkups
SELECT s.name, s.unit
FROM soldiers s
WHERE EXISTS (
    SELECT 1 FROM medical_records m 
    WHERE m.soldier_id = s.soldier_id 
    AND m.last_checkup >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
);

-- BUILT-IN FUNCTIONS for medical_records table

-- 1. String functions: Medical data formatting
SELECT soldier_id,
       UPPER(blood_group) as blood_group_upper,
       CONCAT(height_cm, 'cm / ', weight_kg, 'kg') as height_weight,
       REPLACE(medical_condition, 'None', 'Healthy') as health_status
FROM medical_records;

-- 2. Date functions: Checkup analysis
SELECT soldier_id, last_checkup,
       DATEDIFF(CURDATE(), last_checkup) as days_since_checkup,
       DATE_ADD(last_checkup, INTERVAL 1 YEAR) as next_due_date,
       MONTH(last_checkup) as checkup_month
FROM medical_records;

-- 3. Aggregate functions: Health statistics
SELECT blood_group,
       COUNT(*) as total_soldiers,
       AVG(height_cm) as avg_height,
       AVG(weight_kg) as avg_weight,
       MIN(last_checkup) as oldest_checkup
FROM medical_records
GROUP BY blood_group;

-- 4. Mathematical functions: BMI and health calculations
SELECT soldier_id, height_cm, weight_kg,
       ROUND(weight_kg / POWER(height_cm/100, 2), 2) as bmi,
       ROUND(height_cm * 0.3937, 0) as height_inches,
       weight_kg * 2.20462 as weight_pounds
FROM medical_records;

-- 5. Control flow functions: Health categorization
SELECT soldier_id, medical_condition, weight_kg, height_cm,
       CASE 
           WHEN medical_condition = 'None' THEN 'Fit for Duty'
           WHEN medical_condition LIKE '%Minor%' THEN 'Limited Duty'
           ELSE 'Medical Review'
       END as fitness_status,
       IF(DATEDIFF(CURDATE(), last_checkup) > 365, 'Overdue', 'Current') as checkup_status
FROM medical_records;

-- USER DEFINED FUNCTIONS for medical_records table

-- 1. Function to calculate BMI category
DELIMITER //
CREATE FUNCTION CalculateBMICategory(height_cm INT, weight_kg INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE bmi DECIMAL(5,2);
    DECLARE category VARCHAR(20);
    
    SET bmi = weight_kg / POWER(height_cm/100, 2);
    
    IF bmi < 18.5 THEN
        SET category = 'Underweight';
    ELSEIF bmi < 25 THEN
        SET category = 'Normal';
    ELSEIF bmi < 30 THEN
        SET category = 'Overweight';
    ELSE
        SET category = 'Obese';
    END IF;
    
    RETURN category;
END //
DELIMITER ;

-- 2. Function to determine medical fitness for deployment
DELIMITER //
CREATE FUNCTION CheckDeploymentFitness(medical_condition VARCHAR(100), last_checkup DATE, blood_pressure VARCHAR(10))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE fitness VARCHAR(20);
    DECLARE days_since_checkup INT;
    
    SET days_since_checkup = DATEDIFF(CURDATE(), last_checkup);
    
    IF medical_condition = 'None' AND days_since_checkup <= 180 AND blood_pressure <= '130/85' THEN
        SET fitness = 'Fit for Deployment';
    ELSEIF medical_condition = 'None' AND days_since_checkup <= 365 THEN
        SET fitness = 'Conditionally Fit';
    ELSE
        SET fitness = 'Not Fit';
    END IF;
    
    RETURN fitness;
END //
DELIMITER ;

-- 3. Function to calculate next checkup date
DELIMITER //
CREATE FUNCTION CalculateNextCheckup(last_checkup DATE, medical_condition VARCHAR(100))
RETURNS DATE
DETERMINISTIC
BEGIN
    DECLARE next_checkup DATE;
    
    IF medical_condition != 'None' THEN
        SET next_checkup = DATE_ADD(last_checkup, INTERVAL 3 MONTH);
    ELSE
        SET next_checkup = DATE_ADD(last_checkup, INTERVAL 6 MONTH);
    END IF;
    
    RETURN next_checkup;
END //
DELIMITER ;

-- 4. Function to determine health risk level
DELIMITER //
CREATE FUNCTION DetermineHealthRisk(medical_condition VARCHAR(100), blood_pressure VARCHAR(10))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE risk_level VARCHAR(15);
    
    IF medical_condition LIKE '%High BP%' OR blood_pressure > '140/90' THEN
        SET risk_level = 'High';
    ELSEIF medical_condition != 'None' THEN
        SET risk_level = 'Medium';
    ELSE
        SET risk_level = 'Low';
    END IF;
    
    RETURN risk_level;
END //
DELIMITER ;

-- 5. Function to get blood group compatibility
DELIMITER //
CREATE FUNCTION GetBloodGroupCompatibility(blood_group VARCHAR(5))
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    DECLARE compatibility VARCHAR(100);
    
    CASE blood_group
        WHEN 'O+' THEN SET compatibility = 'O+, A+, B+, AB+';
        WHEN 'O-' THEN SET compatibility = 'All Groups';
        WHEN 'A+' THEN SET compatibility = 'A+, AB+';
        WHEN 'A-' THEN SET compatibility = 'A+, A-, AB+, AB-';
        WHEN 'B+' THEN SET compatibility = 'B+, AB+';
        WHEN 'B-' THEN SET compatibility = 'B+, B-, AB+, AB-';
        WHEN 'AB+' THEN SET compatibility = 'AB+';
        WHEN 'AB-' THEN SET compatibility = 'AB+, AB-';
        ELSE SET compatibility = 'Unknown';
    END CASE;
    
    RETURN compatibility;
END //
DELIMITER ;

-- Using the UDFs for medical_records
SELECT m.soldier_id, s.name, m.height_cm, m.weight_kg, m.blood_group, m.blood_pressure, m.medical_condition, m.last_checkup,
       CalculateBMICategory(m.height_cm, m.weight_kg) as bmi_category,
       CheckDeploymentFitness(m.medical_condition, m.last_checkup, m.blood_pressure) as deployment_fitness,
       CalculateNextCheckup(m.last_checkup, m.medical_condition) as next_checkup_date,
       DetermineHealthRisk(m.medical_condition, m.blood_pressure) as health_risk_level,
       GetBloodGroupCompatibility(m.blood_group) as blood_compatibility
FROM medical_records m
INNER JOIN soldiers s ON m.soldier_id = s.soldier_id;

-- =============================================
-- LEAVE_RECORDS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for leave_records table

-- 1. INNER JOIN: Leave records with soldier details
SELECT l.leave_id, s.name as soldier_name, s.rank, l.start_date, l.end_date, l.type, l.status
FROM leave_records l
INNER JOIN soldiers s ON l.soldier_id = s.soldier_id;

-- 2. LEFT JOIN: All leave records with approved by officer details
SELECT l.leave_id, s.name, l.type, l.start_date, l.end_date, o.name as approved_officer
FROM leave_records l
LEFT JOIN soldiers s ON l.soldier_id = s.soldier_id
LEFT JOIN officers o ON l.approved_by = o.name;

-- 3. RIGHT JOIN: All soldiers with their leave records
SELECT s.name, s.unit, l.type as leave_type, l.start_date, l.status
FROM leave_records l
RIGHT JOIN soldiers s ON l.soldier_id = s.soldier_id;

-- 4. MULTIPLE JOINS: Leave records with soldiers and their units
SELECT l.leave_id, s.name, s.unit, l.type, l.start_date, l.end_date, b.location
FROM leave_records l
INNER JOIN soldiers s ON l.soldier_id = s.soldier_id
LEFT JOIN battalions b ON s.unit = b.name;

-- 5. SELF JOIN: Find overlapping leave periods
SELECT l1.leave_id as leave1, l2.leave_id as leave2, l1.soldier_id, l1.start_date, l1.end_date
FROM leave_records l1
INNER JOIN leave_records l2 ON l1.soldier_id = l2.soldier_id 
AND l1.start_date BETWEEN l2.start_date AND l2.end_date
AND l1.leave_id != l2.leave_id;

-- SUBQUERIES for leave_records table

-- 1. Single row subquery: Longest leave duration
SELECT s.name, l.type, l.start_date, l.end_date, 
       DATEDIFF(l.end_date, l.start_date) as leave_days
FROM leave_records l
INNER JOIN soldiers s ON l.soldier_id = s.soldier_id
WHERE DATEDIFF(l.end_date, l.start_date) = (
    SELECT MAX(DATEDIFF(end_date, start_date)) FROM leave_records
);

-- 2. Multiple row subquery: Leave records for infantry soldiers
SELECT l.leave_id, s.name, l.type, l.status
FROM leave_records l
INNER JOIN soldiers s ON l.soldier_id = s.soldier_id
WHERE s.unit LIKE '%Infantry%';

-- 3. Correlated subquery: Leaves longer than average for their type
SELECT l1.leave_id, s.name, l1.type, DATEDIFF(l1.end_date, l1.start_date) as duration
FROM leave_records l1
INNER JOIN soldiers s ON l1.soldier_id = s.soldier_id
WHERE DATEDIFF(l1.end_date, l1.start_date) > (
    SELECT AVG(DATEDIFF(l2.end_date, l2.start_date))
    FROM leave_records l2
    WHERE l2.type = l1.type
);

-- 4. Subquery in SELECT: Leave statistics by type
SELECT type,
       COUNT(*) as total_leaves,
       AVG(DATEDIFF(end_date, start_date)) as avg_duration,
       (SELECT COUNT(*) FROM leave_records) as total_all_leaves
FROM leave_records
GROUP BY type;

-- 5. Subquery with EXISTS: Soldiers with pending leave applications
SELECT s.name, s.unit
FROM soldiers s
WHERE EXISTS (
    SELECT 1 FROM leave_records l 
    WHERE l.soldier_id = s.soldier_id 
    AND l.status = 'Pending'
);

-- BUILT-IN FUNCTIONS for leave_records table

-- 1. String functions: Leave type analysis
SELECT leave_id,
       UPPER(type) as leave_type_upper,
       CONCAT(type, ' - ', status) as leave_status,
       SUBSTRING(reason, 1, 20) as reason_preview
FROM leave_records;

-- 2. Date functions: Leave duration and timing analysis
SELECT leave_id, start_date, end_date,
       DATEDIFF(end_date, start_date) as total_days,
       DAYNAME(start_date) as start_day,
       MONTHNAME(start_date) as start_month,
       WEEK(start_date) as start_week
FROM leave_records;

-- 3. Aggregate functions: Leave statistics by status
SELECT status,
       COUNT(*) as leave_count,
       AVG(DATEDIFF(end_date, start_date)) as avg_duration,
       MIN(start_date) as earliest_leave,
       MAX(end_date) as latest_return
FROM leave_records
GROUP BY status;

-- 4. Mathematical functions: Leave pattern analysis
SELECT soldier_id,
       COUNT(*) as total_leaves,
       SUM(DATEDIFF(end_date, start_date)) as total_leave_days,
       AVG(DATEDIFF(end_date, start_date)) as avg_leave_length
FROM leave_records
GROUP BY soldier_id;

-- 5. Control flow functions: Leave priority categorization
SELECT leave_id, type, status, start_date,
       CASE 
           WHEN type = 'Emergency Leave' THEN 'High Priority'
           WHEN type = 'Medical Leave' THEN 'Medium Priority'
           ELSE 'Normal Priority'
       END as priority_level,
       IF(DATEDIFF(start_date, CURDATE()) <= 7, 'Imminent', 'Future') as timing_category
FROM leave_records;

-- USER DEFINED FUNCTIONS for leave_records table

-- 1. Function to calculate leave eligibility
DELIMITER //
CREATE FUNCTION CheckLeaveEligibility(soldier_id INT, leave_type VARCHAR(50), requested_days INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE used_leaves INT;
    DECLARE max_allowed INT;
    
    -- Calculate used leaves in current year
    SELECT COALESCE(SUM(DATEDIFF(end_date, start_date)), 0)
    INTO used_leaves
    FROM leave_records 
    WHERE soldier_id = soldier_id 
    AND YEAR(start_date) = YEAR(CURDATE())
    AND status = 'Approved';
    
    -- Set max allowed based on leave type
    IF leave_type = 'Annual Leave' THEN
        SET max_allowed = 30;
    ELSEIF leave_type = 'Casual Leave' THEN
        SET max_allowed = 15;
    ELSEIF leave_type = 'Medical Leave' THEN
        SET max_allowed = 45;
    ELSE
        SET max_allowed = 90; -- Emergency leave
    END IF;
    
    IF (used_leaves + requested_days) <= max_allowed THEN
        RETURN 'Eligible';
    ELSE
        RETURN 'Not Eligible';
    END IF;
END //
DELIMITER ;

-- 2. Function to determine leave season
DELIMITER //
CREATE FUNCTION GetLeaveSeason(start_date DATE)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE season VARCHAR(10);
    DECLARE month_num INT;
    
    SET month_num = MONTH(start_date);
    
    IF month_num BETWEEN 3 AND 5 THEN
        SET season = 'Summer';
    ELSEIF month_num BETWEEN 6 AND 8 THEN
        SET season = 'Monsoon';
    ELSEIF month_num BETWEEN 9 AND 11 THEN
        SET season = 'Autumn';
    ELSE
        SET season = 'Winter';
    END IF;
    
    RETURN season;
END //
DELIMITER ;

-- 3. Function to calculate leave conflict
DELIMITER //
CREATE FUNCTION CheckLeaveConflict(soldier_id INT, new_start DATE, new_end DATE)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE conflict_count INT;
    
    SELECT COUNT(*)
    INTO conflict_count
    FROM leave_records
    WHERE soldier_id = soldier_id
    AND status = 'Approved'
    AND ((new_start BETWEEN start_date AND end_date) OR 
         (new_end BETWEEN start_date AND end_date) OR
         (start_date BETWEEN new_start AND new_end));
    
    IF conflict_count > 0 THEN
        RETURN 'Conflict Found';
    ELSE
        RETURN 'No Conflict';
    END IF;
END //
DELIMITER ;

-- 4. Function to determine leave approval authority
DELIMITER //
CREATE FUNCTION GetApprovalAuthority(leave_type VARCHAR(50), duration_days INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE authority VARCHAR(30);
    
    IF leave_type = 'Emergency Leave' THEN
        SET authority = 'Unit Commander';
    ELSEIF duration_days > 14 THEN
        SET authority = 'Battalion Commander';
    ELSEIF duration_days > 7 THEN
        SET authority = 'Company Commander';
    ELSE
        SET authority = 'Platoon Commander';
    END IF;
    
    RETURN authority;
END //
DELIMITER ;

-- 5. Function to calculate leave extension probability
DELIMITER //
CREATE FUNCTION CalculateExtensionProbability(leave_type VARCHAR(50), current_duration INT)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE probability VARCHAR(15);
    
    IF leave_type = 'Medical Leave' THEN
        SET probability = 'High';
    ELSEIF leave_type = 'Emergency Leave' AND current_duration < 30 THEN
        SET probability = 'Medium';
    ELSEIF current_duration < 10 THEN
        SET probability = 'Low';
    ELSE
        SET probability = 'Very Low';
    END IF;
    
    RETURN probability;
END //
DELIMITER ;

-- Using the UDFs for leave_records
SELECT l.leave_id, s.name, l.type, l.start_date, l.end_date, l.status,
       DATEDIFF(l.end_date, l.start_date) as requested_days,
       CheckLeaveEligibility(l.soldier_id, l.type, DATEDIFF(l.end_date, l.start_date)) as eligibility,
       GetLeaveSeason(l.start_date) as leave_season,
       CheckLeaveConflict(l.soldier_id, l.start_date, l.end_date) as conflict_check,
       GetApprovalAuthority(l.type, DATEDIFF(l.end_date, l.start_date)) as approval_authority,
       CalculateExtensionProbability(l.type, DATEDIFF(l.end_date, l.start_date)) as extension_probability
FROM leave_records l
INNER JOIN soldiers s ON l.soldier_id = s.soldier_id;

-- =============================================
-- PROMOTIONS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for promotions table

-- 1. INNER JOIN: Promotions with soldier details
SELECT p.promotion_id, s.name as soldier_name, p.old_rank, p.new_rank, p.promotion_date
FROM promotions p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id;

-- 2. LEFT JOIN: All promotions with approving officer details
SELECT p.promotion_id, s.name, p.old_rank, p.new_rank, o.name as approved_by_officer
FROM promotions p
LEFT JOIN soldiers s ON p.soldier_id = s.soldier_id
LEFT JOIN officers o ON p.approved_by = o.name;

-- 3. RIGHT JOIN: All soldiers with their promotion history
SELECT s.name, s.rank as current_rank, p.promotion_date, p.new_rank
FROM promotions p
RIGHT JOIN soldiers s ON p.soldier_id = s.soldier_id;

-- 4. MULTIPLE JOINS: Promotions with soldiers and their units
SELECT p.promotion_id, s.name, s.unit, p.old_rank, p.new_rank, p.promotion_date, b.location
FROM promotions p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id
LEFT JOIN battalions b ON s.unit = b.name;

-- 5. SELF JOIN: Find promotion patterns
SELECT p1.soldier_id, p1.old_rank, p1.new_rank, p1.promotion_date,
       p2.old_rank as next_old_rank, p2.new_rank as next_new_rank
FROM promotions p1
LEFT JOIN promotions p2 ON p1.soldier_id = p2.soldier_id 
AND p2.promotion_date = (
    SELECT MIN(promotion_date) FROM promotions 
    WHERE soldier_id = p1.soldier_id AND promotion_date > p1.promotion_date
);

-- SUBQUERIES for promotions table

-- 1. Single row subquery: Most recent promotion
SELECT s.name, p.new_rank, p.promotion_date
FROM promotions p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id
WHERE p.promotion_date = (SELECT MAX(promotion_date) FROM promotions);

-- 2. Multiple row subquery: Promotions in specific year
SELECT s.name, p.old_rank, p.new_rank, p.promotion_date
FROM promotions p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id
WHERE YEAR(p.promotion_date) = 2023;

-- 3. Correlated subquery: Promotions with faster than average progression
SELECT p1.soldier_id, s.name, p1.old_rank, p1.new_rank, p1.promotion_date
FROM promotions p1
INNER JOIN soldiers s ON p1.soldier_id = s.soldier_id
WHERE DATEDIFF(p1.promotion_date, 
    (SELECT MAX(p2.promotion_date) FROM promotions p2 
     WHERE p2.soldier_id = p1.soldier_id AND p2.promotion_date < p1.promotion_date)
) < (
    SELECT AVG(DATEDIFF(p3.promotion_date, 
        (SELECT MAX(p4.promotion_date) FROM promotions p4 
         WHERE p4.soldier_id = p3.soldier_id AND p4.promotion_date < p3.promotion_date)
    ))
    FROM promotions p3
    WHERE p3.old_rank = p1.old_rank AND p3.new_rank = p1.new_rank
);

-- 4. Subquery in SELECT: Promotion statistics by rank
SELECT new_rank,
       COUNT(*) as promotion_count,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM promotions)), 2) as percentage
FROM promotions
GROUP BY new_rank;

-- 5. Subquery with EXISTS: Soldiers with multiple promotions
SELECT s.name, COUNT(p.promotion_id) as promotion_count
FROM soldiers s
INNER JOIN promotions p ON s.soldier_id = p.soldier_id
GROUP BY s.name
HAVING COUNT(p.promotion_id) > 1;

-- BUILT-IN FUNCTIONS for promotions table

-- 1. String functions: Rank and reason analysis
SELECT promotion_id,
       CONCAT(old_rank, ' → ', new_rank) as promotion_path,
       UPPER(status) as promotion_status,
       SUBSTRING(reason, 1, 30) as reason_preview
FROM promotions;

-- 2. Date functions: Promotion timing analysis
SELECT promotion_id, promotion_date,
       YEAR(promotion_date) as promotion_year,
       QUARTER(promotion_date) as promotion_quarter,
       DATEDIFF(CURDATE(), promotion_date) as days_since_promotion
FROM promotions;

-- 3. Aggregate functions: Promotion statistics
SELECT YEAR(promotion_date) as year,
       COUNT(*) as total_promotions,
       COUNT(DISTINCT soldier_id) as unique_soldiers_promoted,
       AVG(DATEDIFF(CURDATE(), promotion_date)) as avg_days_since_promotion
FROM promotions
GROUP BY YEAR(promotion_date);

-- 4. Mathematical functions: Promotion interval analysis
SELECT soldier_id,
       COUNT(*) as total_promotions,
       AVG(DATEDIFF(promotion_date, 
           LAG(promotion_date) OVER (PARTITION BY soldier_id ORDER BY promotion_date)
       )) as avg_days_between_promotions
FROM promotions
GROUP BY soldier_id;

-- 5. Control flow functions: Promotion significance categorization
SELECT promotion_id, old_rank, new_rank,
       CASE 
           WHEN old_rank LIKE '%Sepoy%' AND new_rank LIKE '%Naik%' THEN 'First Promotion'
           WHEN new_rank LIKE '%Havildar%' THEN 'NCO Promotion'
           WHEN new_rank LIKE '%Subedar%' THEN 'JCO Promotion'
           ELSE 'Regular Promotion'
       END as promotion_type,
       IF(DATEDIFF(CURDATE(), promotion_date) < 180, 'Recent', 'Past') as recency
FROM promotions;

-- USER DEFINED FUNCTIONS for promotions table

-- 1. Function to calculate time in rank
DELIMITER //
CREATE FUNCTION CalculateTimeInRank(soldier_id INT, current_rank VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE last_promotion_date DATE;
    DECLARE days_in_rank INT;
    
    -- Get the most recent promotion date to this rank
    SELECT MAX(promotion_date)
    INTO last_promotion_date
    FROM promotions
    WHERE soldier_id = soldier_id AND new_rank = current_rank;
    
    IF last_promotion_date IS NULL THEN
        -- If no promotion record, get join date from soldiers table
        SELECT join_date INTO last_promotion_date 
        FROM soldiers WHERE soldier_id = soldier_id;
    END IF;
    
    SET days_in_rank = DATEDIFF(CURDATE(), last_promotion_date);
    
    RETURN days_in_rank;
END //
DELIMITER ;

-- 2. Function to determine next promotion eligibility
DELIMITER //
CREATE FUNCTION CheckNextPromotionEligibility(soldier_id INT, current_rank VARCHAR(50))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE time_in_rank INT;
    DECLARE min_time_required INT;
    
    SET time_in_rank = CalculateTimeInRank(soldier_id, current_rank);
    
    -- Set minimum time required based on current rank
    IF current_rank = 'Sepoy' THEN
        SET min_time_required = 365; -- 1 year
    ELSEIF current_rank = 'Lance Naik' THEN
        SET min_time_required = 730; -- 2 years
    ELSEIF current_rank = 'Naik' THEN
        SET min_time_required = 1095; -- 3 years
    ELSEIF current_rank = 'Havildar' THEN
        SET min_time_required = 1460; -- 4 years
    ELSE
        SET min_time_required = 1825; -- 5 years for higher ranks
    END IF;
    
    IF time_in_rank >= min_time_required THEN
        RETURN 'Eligible';
    ELSE
        RETURN 'Not Eligible';
    END IF;
END //
DELIMITER ;

-- 3. Function to calculate promotion significance score
DELIMITER //
CREATE FUNCTION CalculatePromotionSignificance(old_rank VARCHAR(50), new_rank VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE significance_score INT DEFAULT 0;
    
    -- Base score for rank change
    IF old_rank != new_rank THEN
        SET significance_score = significance_score + 10;
    END IF;
    
    -- Additional points for specific promotions
    IF old_rank = 'Sepoy' AND new_rank = 'Lance Naik' THEN
        SET significance_score = significance_score + 5;
    ELSEIF old_rank = 'Naik' AND new_rank = 'Havildar' THEN
        SET significance_score = significance_score + 15;
    ELSEIF new_rank LIKE '%Subedar%' THEN
        SET significance_score = significance_score + 25;
    END IF;
    
    RETURN significance_score;
END //
DELIMITER ;

-- 4. Function to determine promotion batch
DELIMITER //
CREATE FUNCTION GetPromotionBatch(promotion_date DATE)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE batch VARCHAR(15);
    DECLARE month_num INT;
    DECLARE quarter_num INT;
    
    SET month_num = MONTH(promotion_date);
    SET quarter_num = QUARTER(promotion_date);
    
    IF quarter_num = 1 THEN
        SET batch = 'Q1 Batch';
    ELSEIF quarter_num = 2 THEN
        SET batch = 'Q2 Batch';
    ELSEIF quarter_num = 3 THEN
        SET batch = 'Q3 Batch';
    ELSE
        SET batch = 'Q4 Batch';
    END IF;
    
    RETURN batch;
END //
DELIMITER ;

-- 5. Function to check promotion validation
DELIMITER //
CREATE FUNCTION ValidatePromotion(old_rank VARCHAR(50), new_rank VARCHAR(50))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE validation_result VARCHAR(20);
    
    -- Define valid promotion paths
    IF (old_rank = 'Sepoy' AND new_rank = 'Lance Naik') OR
       (old_rank = 'Lance Naik' AND new_rank = 'Naik') OR
       (old_rank = 'Naik' AND new_rank = 'Havildar') OR
       (old_rank = 'Havildar' AND new_rank = 'Naib Subedar') THEN
        SET validation_result = 'Valid Promotion';
    ELSE
        SET validation_result = 'Invalid Promotion Path';
    END IF;
    
    RETURN validation_result;
END //
DELIMITER ;

-- Using the UDFs for promotions
SELECT p.promotion_id, s.name, p.old_rank, p.new_rank, p.promotion_date, s.rank as current_rank,
       CalculateTimeInRank(p.soldier_id, p.new_rank) as days_in_rank,
       CheckNextPromotionEligibility(p.soldier_id, p.new_rank) as next_promotion_eligibility,
       CalculatePromotionSignificance(p.old_rank, p.new_rank) as significance_score,
       GetPromotionBatch(p.promotion_date) as promotion_batch,
       ValidatePromotion(p.old_rank, p.new_rank) as promotion_validation
FROM promotions p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id;

-- =============================================
-- EVENTS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for events table

-- 1. INNER JOIN: Events with organizing officers
SELECT e.event_id, e.name as event_name, e.date, e.type, o.name as organized_by_officer
FROM events e
INNER JOIN officers o ON e.organized_by = o.name;

-- 2. LEFT JOIN: All events with contact person details
SELECT e.event_id, e.name, e.type, e.location, e.contact_person, e.phone
FROM events e
LEFT JOIN officers o ON e.contact_person = o.name;

-- 3. MULTIPLE JOINS: Events with organizers and locations
SELECT e.event_id, e.name, e.type, e.location, o.name as organizer, o.rank, b.name as battalion
FROM events e
LEFT JOIN officers o ON e.organized_by = o.name
LEFT JOIN battalions b ON e.location LIKE CONCAT('%', b.location, '%');

-- 4. SELF JOIN: Find related events in same location
SELECT e1.name as event1, e2.name as event2, e1.location, e1.date
FROM events e1
INNER JOIN events e2 ON e1.location = e2.location 
AND e1.date = e2.date
AND e1.event_id < e2.event_id;

-- 5. RIGHT JOIN: All officers with their organized events
SELECT o.name as officer_name, o.rank, e.name as event_name, e.date, e.type
FROM events e
RIGHT JOIN officers o ON e.organized_by = o.name;

-- SUBQUERIES for events table

-- 1. Single row subquery: Most recent event
SELECT name, type, date, location
FROM events
WHERE date = (SELECT MAX(date) FROM events WHERE date <= CURDATE());

-- 2. Multiple row subquery: Ceremonial events
SELECT name, date, location, organized_by
FROM events
WHERE type = 'Ceremonial';

-- 3. Correlated subquery: Events with similar types in same location
SELECT e1.name, e1.type, e1.location, e1.date
FROM events e1
WHERE EXISTS (
    SELECT 1 FROM events e2 
    WHERE e2.type = e1.type 
    AND e2.location = e1.location 
    AND e2.event_id != e1.event_id
);

-- 4. Subquery in SELECT: Event statistics by type
SELECT type,
       COUNT(*) as event_count,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM events)), 2) as percentage
FROM events
GROUP BY type;

-- 5. Subquery with EXISTS: Upcoming events in specific locations
SELECT name, date, location
FROM events e
WHERE e.date >= CURDATE() AND EXISTS (
    SELECT 1 FROM battalions b 
    WHERE e.location LIKE CONCAT('%', b.location, '%')
    AND b.region = 'Northern Command'
);

-- BUILT-IN FUNCTIONS for events table

-- 1. String functions: Event name and description analysis
SELECT name,
       UPPER(type) as event_type_upper,
       CONCAT(name, ' at ', location) as event_description,
       LENGTH(description) as description_length
FROM events;

-- 2. Date functions: Event scheduling analysis
SELECT name, date,
       DATEDIFF(date, CURDATE()) as days_until_event,
       DAYNAME(date) as event_day,
       MONTHNAME(date) as event_month,
       WEEK(date) as event_week
FROM events;

-- 3. Aggregate functions: Event statistics by month
SELECT YEAR(date) as year, MONTH(date) as month,
       COUNT(*) as event_count,
       GROUP_CONCAT(name SEPARATOR ', ') as event_names
FROM events
GROUP BY YEAR(date), MONTH(date);

-- 4. Mathematical functions: Event frequency analysis
SELECT type,
       COUNT(*) as frequency,
       AVG(DATEDIFF(date, CURDATE())) as avg_days_until_next
FROM events
WHERE date >= CURDATE()
GROUP BY type;

-- 5. Control flow functions: Event status categorization
SELECT name, date, status,
       CASE 
           WHEN date < CURDATE() THEN 'Completed'
           WHEN DATEDIFF(date, CURDATE()) <= 7 THEN 'This Week'
           WHEN DATEDIFF(date, CURDATE()) <= 30 THEN 'This Month'
           ELSE 'Future'
       END as timeline_category,
       IF(status = 'Completed', 'Past Event', 'Upcoming Event') as event_status
FROM events;

-- USER DEFINED FUNCTIONS for events table

-- 1. Function to calculate event priority
DELIMITER //
CREATE FUNCTION CalculateEventPriority(event_type VARCHAR(50), event_date DATE)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE priority VARCHAR(15);
    DECLARE days_until_event INT;
    
    SET days_until_event = DATEDIFF(event_date, CURDATE());
    
    IF event_type = 'Ceremonial' AND days_until_event <= 30 THEN
        SET priority = 'High';
    ELSEIF event_type IN ('Training', 'Workshop') AND days_until_event <= 14 THEN
        SET priority = 'Medium';
    ELSEIF days_until_event <= 7 THEN
        SET priority = 'High';
    ELSE
        SET priority = 'Low';
    END IF;
    
    RETURN priority;
END //
DELIMITER ;

-- 2. Function to determine event scale
DELIMITER //
CREATE FUNCTION DetermineEventScale(event_type VARCHAR(50), location VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE event_scale VARCHAR(20);
    
    IF event_type = 'Ceremonial' AND location LIKE '%Delhi%' THEN
        SET event_scale = 'National Level';
    ELSEIF event_type IN ('Training', 'Exhibition') THEN
        SET event_scale = 'Regional Level';
    ELSEIF location LIKE '%HQ%' THEN
        SET event_scale = 'Command Level';
    ELSE
        SET event_scale = 'Unit Level';
    END IF;
    
    RETURN event_scale;
END //
DELIMITER ;

-- 3. Function to check event conflict
DELIMITER //
CREATE FUNCTION CheckEventConflict(event_date DATE, event_location VARCHAR(100))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE conflict_count INT;
    
    SELECT COUNT(*)
    INTO conflict_count
    FROM events
    WHERE date = event_date
    AND location = event_location
    AND status != 'Completed';
    
    IF conflict_count > 0 THEN
        RETURN 'Conflict Exists';
    ELSE
        RETURN 'No Conflict';
    END IF;
END //
DELIMITER ;

-- 4. Function to calculate event preparation time
DELIMITER //
CREATE FUNCTION CalculatePreparationTime(event_type VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE prep_days INT;
    
    IF event_type = 'Ceremonial' THEN
        SET prep_days = 30;
    ELSEIF event_type = 'Training' THEN
        SET prep_days = 14;
    ELSEIF event_type = 'Workshop' THEN
        SET prep_days = 7;
    ELSE
        SET prep_days = 3;
    END IF;
    
    RETURN prep_days;
END //
DELIMITER ;

-- 5. Function to get event season
DELIMITER //
CREATE FUNCTION GetEventSeason(event_date DATE)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE season VARCHAR(10);
    DECLARE month_num INT;
    
    SET month_num = MONTH(event_date);
    
    IF month_num BETWEEN 12 AND 2 THEN
        SET season = 'Winter';
    ELSEIF month_num BETWEEN 3 AND 5 THEN
        SET season = 'Summer';
    ELSEIF month_num BETWEEN 6 AND 9 THEN
        SET season = 'Monsoon';
    ELSE
        SET season = 'Autumn';
    END IF;
    
    RETURN season;
END //
DELIMITER ;

-- Using the UDFs for events
SELECT event_id, name, type, date, location, status,
       CalculateEventPriority(type, date) as event_priority,
       DetermineEventScale(type, location) as event_scale,
       CheckEventConflict(date, location) as conflict_check,
       CalculatePreparationTime(type) as preparation_days_needed,
       GetEventSeason(date) as event_season
FROM events;

-- =============================================
-- DISCIPLINARY_ACTIONS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for disciplinary_actions table

-- 1. INNER JOIN: Disciplinary actions with soldier details
SELECT d.action_id, s.name as soldier_name, s.rank, d.action_type, d.date, d.punishment
FROM disciplinary_actions d
INNER JOIN soldiers s ON d.soldier_id = s.soldier_id;

-- 2. LEFT JOIN: All disciplinary actions with punishing officers
SELECT d.action_id, s.name, d.action_type, d.punishment, o.name as punished_by_officer
FROM disciplinary_actions d
LEFT JOIN soldiers s ON d.soldier_id = s.soldier_id
LEFT JOIN officers o ON d.punished_by = o.name;

-- 3. MULTIPLE JOINS: Disciplinary actions with complete chain
SELECT d.action_id, s.name, s.unit, d.action_type, d.punishment, 
       o.name as punishing_officer, r.name as reviewing_officer
FROM disciplinary_actions d
INNER JOIN soldiers s ON d.soldier_id = s.soldier_id
LEFT JOIN officers o ON d.punished_by = o.name
LEFT JOIN officers r ON d.reviewed_by = r.name;

-- 4. SELF JOIN: Find soldiers with multiple disciplinary actions
SELECT d1.soldier_id, s.name, COUNT(d1.action_id) as total_actions
FROM disciplinary_actions d1
INNER JOIN soldiers s ON d1.soldier_id = s.soldier_id
GROUP BY d1.soldier_id, s.name
HAVING COUNT(d1.action_id) > 1;

-- 5. RIGHT JOIN: All soldiers with their disciplinary records
SELECT s.name, s.rank, s.unit, d.action_type, d.date, d.status
FROM disciplinary_actions d
RIGHT JOIN soldiers s ON d.soldier_id = s.soldier_id;

-- SUBQUERIES for disciplinary_actions table

-- 1. Single row subquery: Most severe punishment
SELECT s.name, d.action_type, d.punishment, d.date
FROM disciplinary_actions d
INNER JOIN soldiers s ON d.soldier_id = s.soldier_id
WHERE d.punishment LIKE '%suspension%' OR d.punishment LIKE '%confinement%'
ORDER BY d.date DESC
LIMIT 1;

-- 2. Multiple row subquery: Disciplinary actions in specific units
SELECT d.action_id, s.name, d.action_type, d.date
FROM disciplinary_actions d
INNER JOIN soldiers s ON d.soldier_id = s.soldier_id
WHERE s.unit IN ('2nd Battalion', '3rd Battalion', '4th Battalion');

-- 3. Correlated subquery: Soldiers with repeated offenses
SELECT s.name, d.action_type, d.date
FROM disciplinary_actions d
INNER JOIN soldiers s ON d.soldier_id = s.soldier_id
WHERE EXISTS (
    SELECT 1 FROM disciplinary_actions d2 
    WHERE d2.soldier_id = d.soldier_id 
    AND d2.action_id != d.action_id
    AND DATEDIFF(d2.date, d.date) <= 90
);

-- 4. Subquery in SELECT: Disciplinary statistics by type
SELECT action_type,
       COUNT(*) as action_count,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM disciplinary_actions)), 2) as percentage
FROM disciplinary_actions
GROUP BY action_type;

-- 5. Subquery with EXISTS: Closed disciplinary cases
SELECT d.action_id, s.name, d.action_type, d.status
FROM disciplinary_actions d
INNER JOIN soldiers s ON d.soldier_id = s.soldier_id
WHERE d.status = 'Closed' AND EXISTS (
    SELECT 1 FROM soldiers s2 
    WHERE s2.soldier_id = d.soldier_id 
    AND s2.unit NOT LIKE '%Reserve%'
);

-- BUILT-IN FUNCTIONS for disciplinary_actions table

-- 1. String functions: Action and punishment analysis
SELECT action_id,
       UPPER(action_type) as action_type_upper,
       CONCAT(action_type, ' - ', punishment) as full_description,
       SUBSTRING(reason, 1, 25) as reason_preview
FROM disciplinary_actions;

-- 2. Date functions: Disciplinary timing analysis
SELECT action_id, date,
       YEAR(date) as action_year,
       QUARTER(date) as action_quarter,
       DATEDIFF(CURDATE(), date) as days_since_action
FROM disciplinary_actions;

-- 3. Aggregate functions: Disciplinary statistics
SELECT YEAR(date) as year,
       COUNT(*) as total_actions,
       COUNT(DISTINCT soldier_id) as unique_soldiers,
       AVG(DATEDIFF(CURDATE(), date)) as avg_days_since_action
FROM disciplinary_actions
GROUP BY YEAR(date);

-- 4. Mathematical functions: Pattern analysis
SELECT soldier_id,
       COUNT(*) as total_offenses,
       MIN(DATEDIFF(CURDATE(), date)) as days_since_last_offense
FROM disciplinary_actions
GROUP BY soldier_id;

-- 5. Control flow functions: Severity categorization
SELECT action_id, action_type, punishment, status,
       CASE 
           WHEN punishment LIKE '%suspension%' OR punishment LIKE '%confinement%' THEN 'Severe'
           WHEN punishment LIKE '%warning%' THEN 'Moderate'
           ELSE 'Minor'
       END as severity_level,
       IF(status = 'Closed', 'Resolved', 'Pending Resolution') as resolution_status
FROM disciplinary_actions;

-- USER DEFINED FUNCTIONS for disciplinary_actions table

-- 1. Function to calculate disciplinary score
DELIMITER //
CREATE FUNCTION CalculateDisciplinaryScore(soldier_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_score INT DEFAULT 100;
    DECLARE offense_count INT;
    DECLARE severe_offenses INT;
    
    -- Count total offenses
    SELECT COUNT(*)
    INTO offense_count
    FROM disciplinary_actions
    WHERE soldier_id = soldier_id
    AND status = 'Closed';
    
    -- Count severe offenses
    SELECT COUNT(*)
    INTO severe_offenses
    FROM disciplinary_actions
    WHERE soldier_id = soldier_id
    AND status = 'Closed'
    AND (punishment LIKE '%suspension%' OR punishment LIKE '%confinement%');
    
    -- Calculate score (deduct points for offenses)
    SET total_score = total_score - (offense_count * 5) - (severe_offenses * 15);
    
    RETURN GREATEST(total_score, 0);
END //
DELIMITER ;

-- 2. Function to determine rehabilitation need
DELIMITER //
CREATE FUNCTION CheckRehabilitationNeed(soldier_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE recent_offenses INT;
    DECLARE rehab_need VARCHAR(20);
    
    -- Count offenses in last 6 months
    SELECT COUNT(*)
    INTO recent_offenses
    FROM disciplinary_actions
    WHERE soldier_id = soldier_id
    AND date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    AND status = 'Closed';
    
    IF recent_offenses >= 3 THEN
        SET rehab_need = 'High Priority';
    ELSEIF recent_offenses >= 2 THEN
        SET rehab_need = 'Medium Priority';
    ELSEIF recent_offenses >= 1 THEN
        SET rehab_need = 'Low Priority';
    ELSE
        SET rehab_need = 'Not Required';
    END IF;
    
    RETURN rehab_need;
END //
DELIMITER ;

-- 3. Function to calculate promotion impact
DELIMITER //
CREATE FUNCTION CalculatePromotionImpact(soldier_id INT)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE recent_offenses INT;
    DECLARE impact_level VARCHAR(15);
    
    -- Count offenses in last 12 months
    SELECT COUNT(*)
    INTO recent_offenses
    FROM disciplinary_actions
    WHERE soldier_id = soldier_id
    AND date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
    AND status = 'Closed';
    
    IF recent_offenses >= 2 THEN
        SET impact_level = 'Significant';
    ELSEIF recent_offenses >= 1 THEN
        SET impact_level = 'Moderate';
    ELSE
        SET impact_level = 'Minimal';
    END IF;
    
    RETURN impact_level;
END //
DELIMITER ;

-- 4. Function to determine counseling requirement
DELIMITER //
CREATE FUNCTION CheckCounselingRequirement(action_type VARCHAR(100), punishment VARCHAR(100))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE counseling_required VARCHAR(10);
    
    IF action_type IN ('Unauthorized Absence', 'Negligence of Duty', 'Disrespect to Senior') THEN
        SET counseling_required = 'Yes';
    ELSEIF punishment LIKE '%warning%' THEN
        SET counseling_required = 'Yes';
    ELSE
        SET counseling_required = 'No';
    END IF;
    
    RETURN counseling_required;
END //
DELIMITER ;

-- 5. Function to get disciplinary category
DELIMITER //
CREATE FUNCTION GetDisciplinaryCategory(action_type VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE category VARCHAR(20);
    
    IF action_type LIKE '%Absence%' THEN
        SET category = 'Attendance Issue';
    ELSEIF action_type LIKE '%Negligence%' OR action_type LIKE '%Duty%' THEN
        SET category = 'Performance Issue';
    ELSEIF action_type LIKE '%Disrespect%' OR action_type LIKE '%Insubordination%' THEN
        SET category = 'Behavioral Issue';
    ELSEIF action_type LIKE '%Damage%' OR action_type LIKE '%Misuse%' THEN
        SET category = 'Property Issue';
    ELSE
        SET category = 'Other Issue';
    END IF;
    
    RETURN category;
END //
DELIMITER ;

-- Using the UDFs for disciplinary_actions
SELECT d.action_id, s.name, d.action_type, d.punishment, d.date, d.status,
       CalculateDisciplinaryScore(d.soldier_id) as disciplinary_score,
       CheckRehabilitationNeed(d.soldier_id) as rehabilitation_need,
       CalculatePromotionImpact(d.soldier_id) as promotion_impact,
       CheckCounselingRequirement(d.action_type, d.punishment) as counseling_required,
       GetDisciplinaryCategory(d.action_type) as disciplinary_category
FROM disciplinary_actions d
INNER JOIN soldiers s ON d.soldier_id = s.soldier_id;

-- =============================================
-- ACCOMMODATIONS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for accommodations table

-- 1. INNER JOIN: Accommodations with soldier details
SELECT a.acc_id, s.name as soldier_name, s.rank, a.room_no, a.block, a.location
FROM accommodations a
INNER JOIN soldiers s ON a.soldier_id = s.soldier_id;

-- 2. LEFT JOIN: All accommodations with caretaker details
SELECT a.acc_id, s.name, a.room_no, a.block, a.location, a.caretaker
FROM accommodations a
LEFT JOIN soldiers s ON a.soldier_id = s.soldier_id;

-- 3. MULTIPLE JOINS: Accommodations with soldiers and their units
SELECT a.acc_id, s.name, s.unit, a.room_no, a.block, a.location, b.commander
FROM accommodations a
INNER JOIN soldiers s ON a.soldier_id = s.soldier_id
LEFT JOIN battalions b ON s.unit = b.name;

-- 4. SELF JOIN: Find shared accommodations
SELECT a1.acc_id as acc1, a2.acc_id as acc2, a1.room_no, a1.block, a1.location
FROM accommodations a1
INNER JOIN accommodations a2 ON a1.room_no = a2.room_no 
AND a1.block = a2.block 
AND a1.location = a2.location
AND a1.acc_id < a2.acc_id;

-- 5. RIGHT JOIN: All soldiers with their accommodation details
SELECT s.name, s.rank, s.unit, a.room_no, a.block, a.status
FROM accommodations a
RIGHT JOIN soldiers s ON a.soldier_id = s.soldier_id;

-- SUBQUERIES for accommodations table

-- 1. Single row subquery: Most recently assigned accommodation
SELECT s.name, a.room_no, a.block, a.assigned_date
FROM accommodations a
INNER JOIN soldiers s ON a.soldier_id = s.soldier_id
WHERE a.assigned_date = (SELECT MAX(assigned_date) FROM accommodations);

-- 2. Multiple row subquery: Accommodations in specific locations
SELECT a.acc_id, s.name, a.room_no, a.location
FROM accommodations a
INNER JOIN soldiers s ON a.soldier_id = s.soldier_id
WHERE a.location IN ('Delhi Cantt', 'Pune HQ', 'Srinagar Base');

-- 3. Correlated subquery: Soldiers with long-term accommodations
SELECT s.name, a.room_no, a.assigned_date
FROM accommodations a
INNER JOIN soldiers s ON a.soldier_id = s.soldier_id
WHERE a.vacated_date IS NULL 
AND DATEDIFF(CURDATE(), a.assigned_date) > (
    SELECT AVG(DATEDIFF(CURDATE(), assigned_date))
    FROM accommodations 
    WHERE vacated_date IS NULL
);

-- 4. Subquery in SELECT: Accommodation statistics by location
SELECT location,
       COUNT(*) as total_accommodations,
       SUM(CASE WHEN status = 'Occupied' THEN 1 ELSE 0 END) as occupied_count,
       ROUND((SUM(CASE WHEN status = 'Occupied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) as occupancy_rate
FROM accommodations
GROUP BY location;

-- 5. Subquery with EXISTS: Available accommodations
SELECT room_no, block, location
FROM accommodations a
WHERE status = 'Vacated' AND NOT EXISTS (
    SELECT 1 FROM accommodations a2 
    WHERE a2.room_no = a.room_no 
    AND a2.block = a.block 
    AND a2.location = a.location 
    AND a2.status = 'Occupied'
);

-- BUILT-IN FUNCTIONS for accommodations table

-- 1. String functions: Room and location analysis
SELECT acc_id,
       CONCAT(block, '-', room_no) as full_room_code,
       UPPER(location) as location_upper,
       SUBSTRING(remarks, 1, 20) as remarks_preview
FROM accommodations;

-- 2. Date functions: Accommodation duration analysis
SELECT acc_id, assigned_date, vacated_date,
       DATEDIFF(COALESCE(vacated_date, CURDATE()), assigned_date) as days_occupied,
       YEAR(assigned_date) as assignment_year
FROM accommodations;

-- 3. Aggregate functions: Accommodation statistics
SELECT location,
       COUNT(*) as total_rooms,
       COUNT(DISTINCT block) as total_blocks,
       AVG(DATEDIFF(COALESCE(vacated_date, CURDATE()), assigned_date)) as avg_occupancy_days
FROM accommodations
GROUP BY location;

-- 4. Mathematical functions: Occupancy calculations
SELECT block,
       COUNT(*) as total_rooms,
       SUM(CASE WHEN status = 'Occupied' THEN 1 ELSE 0 END) as occupied_rooms,
       ROUND((SUM(CASE WHEN status = 'Occupied' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) as occupancy_percentage
FROM accommodations
GROUP BY block;

-- 5. Control flow functions: Accommodation status categorization
SELECT acc_id, room_no, status, assigned_date,
       CASE 
           WHEN status = 'Occupied' AND DATEDIFF(CURDATE(), assigned_date) > 365 THEN 'Long Term'
           WHEN status = 'Occupied' THEN 'Short Term'
           WHEN status = 'Vacated' THEN 'Available'
           ELSE 'Maintenance'
       END as occupancy_type,
       IF(vacated_date IS NULL, 'Currently Occupied', 'Vacated') as current_status
FROM accommodations;

-- USER DEFINED FUNCTIONS for accommodations table

-- 1. Function to calculate accommodation duration
DELIMITER //
CREATE FUNCTION CalculateAccommodationDuration(assigned_date DATE, vacated_date DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE duration_days INT;
    
    IF vacated_date IS NULL THEN
        SET duration_days = DATEDIFF(CURDATE(), assigned_date);
    ELSE
        SET duration_days = DATEDIFF(vacated_date, assigned_date);
    END IF;
    
    RETURN duration_days;
END //
DELIMITER ;

-- 2. Function to determine accommodation quality
DELIMITER //
CREATE FUNCTION DetermineAccommodationQuality(location VARCHAR(100), assigned_date DATE)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE quality VARCHAR(15);
    DECLARE accommodation_age INT;
    
    SET accommodation_age = YEAR(CURDATE()) - YEAR(assigned_date);
    
    IF location LIKE '%Cantt%' AND accommodation_age < 10 THEN
        SET quality = 'Excellent';
    ELSEIF location LIKE '%HQ%' OR location LIKE '%Base%' THEN
        SET quality = 'Good';
    ELSEIF accommodation_age < 5 THEN
        SET quality = 'Good';
    ELSE
        SET quality = 'Standard';
    END IF;
    
    RETURN quality;
END //
DELIMITER ;

-- 3. Function to check relocation need
DELIMITER //
CREATE FUNCTION CheckRelocationNeed(assigned_date DATE, location VARCHAR(100))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE relocation_need VARCHAR(15);
    DECLARE occupancy_days INT;
    
    SET occupancy_days = DATEDIFF(CURDATE(), assigned_date);
    
    IF occupancy_days > 1095 THEN -- 3 years
        SET relocation_need = 'Due for Rotation';
    ELSEIF location IN ('Siachen', 'Leh', 'Kargil') AND occupancy_days > 365 THEN
        SET relocation_need = 'High Priority';
    ELSE
        SET relocation_need = 'Not Required';
    END IF;
    
    RETURN relocation_need;
END //
DELIMITER ;

-- 4. Function to calculate maintenance priority
DELIMITER //
CREATE FUNCTION CalculateAccommodationMaintenance(assigned_date DATE, status VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE maintenance_priority VARCHAR(15);
    DECLARE accommodation_age INT;
    
    SET accommodation_age = YEAR(CURDATE()) - YEAR(assigned_date);
    
    IF status = 'Vacated' AND accommodation_age > 10 THEN
        SET maintenance_priority = 'High';
    ELSEIF accommodation_age > 15 THEN
        SET maintenance_priority = 'Medium';
    ELSE
        SET maintenance_priority = 'Low';
    END IF;
    
    RETURN maintenance_priority;
END //
DELIMITER ;

-- 5. Function to get accommodation type
DELIMITER //
CREATE FUNCTION GetAccommodationType(block VARCHAR(10), room_no VARCHAR(10))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE accommodation_type VARCHAR(20);
    
    IF block LIKE 'A%' OR block LIKE 'B%' THEN
        SET accommodation_type = 'Officers Quarters';
    ELSEIF room_no LIKE '%101%' OR room_no LIKE '%201%' THEN
        SET accommodation_type = 'Single Occupancy';
    ELSEIF block LIKE 'C%' OR block LIKE 'D%' THEN
        SET accommodation_type = 'Junior Ranks';
    ELSE
        SET accommodation_type = 'General Barracks';
    END IF;
    
    RETURN accommodation_type;
END //
DELIMITER ;

-- Using the UDFs for accommodations
SELECT a.acc_id, s.name, a.room_no, a.block, a.location, a.assigned_date, a.status,
       CalculateAccommodationDuration(a.assigned_date, a.vacated_date) as accommodation_duration_days,
       DetermineAccommodationQuality(a.location, a.assigned_date) as accommodation_quality,
       CheckRelocationNeed(a.assigned_date, a.location) as relocation_need,
       CalculateAccommodationMaintenance(a.assigned_date, a.status) as maintenance_priority,
       GetAccommodationType(a.block, a.room_no) as accommodation_type
FROM accommodations a
INNER JOIN soldiers s ON a.soldier_id = s.soldier_id;

-- =============================================
-- PAYROLL TABLE QUERIES
-- =============================================

-- JOINS QUERIES for payroll table

-- 1. INNER JOIN: Payroll with soldier details
SELECT p.payroll_id, s.name as soldier_name, s.rank, p.month, p.basic_pay, p.net_pay, p.status
FROM payroll p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id;

-- 2. LEFT JOIN: All payroll records with detailed soldier info
SELECT p.payroll_id, s.name, s.unit, p.month, p.basic_pay, p.hra, p.da, p.net_pay
FROM payroll p
LEFT JOIN soldiers s ON p.soldier_id = s.soldier_id;

-- 3. MULTIPLE JOINS: Payroll with soldiers and their units
SELECT p.payroll_id, s.name, s.unit, b.location, p.month, p.net_pay, p.status
FROM payroll p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id
LEFT JOIN battalions b ON s.unit = b.name;

-- 4. SELF JOIN: Find payroll patterns for same soldier
SELECT p1.soldier_id, p1.month as month1, p1.net_pay as pay1, 
       p2.month as month2, p2.net_pay as pay2,
       p2.net_pay - p1.net_pay as pay_difference
FROM payroll p1
INNER JOIN payroll p2 ON p1.soldier_id = p2.soldier_id 
AND p2.month = 'July 2025'
AND p1.month = 'June 2025';

-- 5. RIGHT JOIN: All soldiers with their payroll records
SELECT s.name, s.rank, s.unit, p.month, p.net_pay, p.status
FROM payroll p
RIGHT JOIN soldiers s ON p.soldier_id = s.soldier_id;

-- SUBQUERIES for payroll table

-- 1. Single row subquery: Highest paid soldier
SELECT s.name, p.month, p.net_pay
FROM payroll p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id
WHERE p.net_pay = (SELECT MAX(net_pay) FROM payroll);

-- 2. Multiple row subquery: Soldiers earning above average
SELECT s.name, p.net_pay, 
       (SELECT AVG(net_pay) FROM payroll) as average_pay
FROM payroll p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id
WHERE p.net_pay > (SELECT AVG(net_pay) FROM payroll);

-- 3. Correlated subquery: Payroll records with increasing salary trend
SELECT p1.soldier_id, s.name, p1.month, p1.net_pay
FROM payroll p1
INNER JOIN soldiers s ON p1.soldier_id = s.soldier_id
WHERE p1.net_pay > (
    SELECT p2.net_pay 
    FROM payroll p2 
    WHERE p2.soldier_id = p1.soldier_id 
    AND p2.month = 'May 2025'
);

-- 4. Subquery in SELECT: Payroll statistics with comparisons
SELECT month,
       COUNT(*) as payroll_records,
       SUM(net_pay) as total_payout,
       (SELECT SUM(net_pay) FROM payroll WHERE status = 'Processed') as total_processed_payout,
       ROUND((SUM(net_pay) * 100.0 / (SELECT SUM(net_pay) FROM payroll)), 2) as percentage_of_total
FROM payroll
GROUP BY month;

-- 5. Subquery with EXISTS: Soldiers with processed payroll
SELECT s.name, s.rank, s.unit
FROM soldiers s
WHERE EXISTS (
    SELECT 1 FROM payroll p 
    WHERE p.soldier_id = s.soldier_id 
    AND p.status = 'Processed'
    AND p.month = 'June 2025'
);

-- BUILT-IN FUNCTIONS for payroll table

-- 1. String functions: Payroll month and status analysis
SELECT payroll_id,
       UPPER(month) as month_upper,
       CONCAT('Rs. ', FORMAT(net_pay, 2)) as formatted_salary,
       SUBSTRING(month, 1, 3) as month_abbreviation
FROM payroll;

-- 2. Mathematical functions: Salary calculations and analysis
SELECT payroll_id, basic_pay, hra, da, deductions, net_pay,
       ROUND((hra / basic_pay) * 100, 2) as hra_percentage,
       ROUND((da / basic_pay) * 100, 2) as da_percentage,
       ROUND((deductions / basic_pay) * 100, 2) as deductions_percentage,
       net_pay * 12 as estimated_annual_salary
FROM payroll;

-- 3. Aggregate functions: Payroll statistics by month
SELECT month,
       COUNT(*) as total_records,
       SUM(net_pay) as total_payout,
       AVG(net_pay) as average_salary,
       MIN(net_pay) as minimum_salary,
       MAX(net_pay) as maximum_salary
FROM payroll
GROUP BY month;

-- 4. Date functions: Payroll processing analysis
SELECT payroll_id, processed_date,
       DAYNAME(processed_date) as process_day,
       MONTHNAME(processed_date) as process_month,
       DATEDIFF(CURDATE(), processed_date) as days_since_processed
FROM payroll;

-- 5. Control flow functions: Salary categorization
SELECT payroll_id, net_pay, status,
       CASE 
           WHEN net_pay > 60000 THEN 'High Grade'
           WHEN net_pay > 45000 THEN 'Medium Grade'
           ELSE 'Standard Grade'
       END as salary_grade,
       IF(status = 'Processed', 'Completed', 'Pending') as processing_status
FROM payroll;

-- USER DEFINED FUNCTIONS for payroll table

-- 1. Function to calculate income tax
DELIMITER //
CREATE FUNCTION CalculateIncomeTax(basic_pay DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE tax_amount DECIMAL(10,2);
    
    IF basic_pay > 75000 THEN
        SET tax_amount = basic_pay * 0.20;
    ELSEIF basic_pay > 50000 THEN
        SET tax_amount = basic_pay * 0.15;
    ELSEIF basic_pay > 30000 THEN
        SET tax_amount = basic_pay * 0.10;
    ELSEIF basic_pay > 25000 THEN
        SET tax_amount = basic_pay * 0.05;
    ELSE
        SET tax_amount = 0;
    END IF;
    
    RETURN tax_amount;
END //
DELIMITER ;

-- 2. Function to determine salary grade
DELIMITER //
CREATE FUNCTION GetSalaryGrade(net_pay DECIMAL(10,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE grade VARCHAR(20);
    
    IF net_pay > 70000 THEN
        SET grade = 'Grade A';
    ELSEIF net_pay > 55000 THEN
        SET grade = 'Grade B';
    ELSEIF net_pay > 40000 THEN
        SET grade = 'Grade C';
    ELSEIF net_pay > 30000 THEN
        SET grade = 'Grade D';
    ELSE
        SET grade = 'Grade E';
    END IF;
    
    RETURN grade;
END //
DELIMITER ;

-- 3. Function to calculate bonus eligibility
DELIMITER //
CREATE FUNCTION CheckBonusEligibility(net_pay DECIMAL(10,2), status VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE eligibility VARCHAR(15);
    
    IF status = 'Processed' AND net_pay > 35000 THEN
        SET eligibility = 'Eligible';
    ELSEIF status = 'Processed' THEN
        SET eligibility = 'Review Needed';
    ELSE
        SET eligibility = 'Not Eligible';
    END IF;
    
    RETURN eligibility;
END //
DELIMITER ;

-- 4. Function to calculate provident fund
DELIMITER //
CREATE FUNCTION CalculateProvidentFund(basic_pay DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE pf_amount DECIMAL(10,2);
    
    SET pf_amount = basic_pay * 0.12; -- 12% of basic pay
    
    RETURN pf_amount;
END //
DELIMITER ;

-- 5. Function to determine salary increment percentage
DELIMITER //
CREATE FUNCTION CalculateIncrementPercentage(current_basic DECIMAL(10,2), soldier_rank VARCHAR(50))
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE increment_percentage DECIMAL(5,2);
    
    IF soldier_rank LIKE '%Havildar%' THEN
        SET increment_percentage = 15.0;
    ELSEIF soldier_rank LIKE '%Naik%' THEN
        SET increment_percentage = 12.5;
    ELSEIF soldier_rank LIKE '%Lance Naik%' THEN
        SET increment_percentage = 10.0;
    ELSE
        SET increment_percentage = 8.0;
    END IF;
    
    RETURN increment_percentage;
END //
DELIMITER ;

-- Using the UDFs for payroll
SELECT p.payroll_id, s.name, s.rank, p.basic_pay, p.net_pay, p.status,
       CalculateIncomeTax(p.basic_pay) as income_tax,
       GetSalaryGrade(p.net_pay) as salary_grade,
       CheckBonusEligibility(p.net_pay, p.status) as bonus_eligibility,
       CalculateProvidentFund(p.basic_pay) as provident_fund,
       CalculateIncrementPercentage(p.basic_pay, s.rank) as increment_percentage
FROM payroll p
INNER JOIN soldiers s ON p.soldier_id = s.soldier_id;

-- =============================================
-- ARMS_INVENTORY TABLE QUERIES
-- =============================================

-- JOINS QUERIES for arms_inventory table

-- 1. INNER JOIN: Arms inventory with weapon details
SELECT a.inventory_id, a.item_name, a.type, a.quantity, w.range_km, w.status as weapon_status
FROM arms_inventory a
INNER JOIN weapons w ON a.item_name = w.name;

-- 2. LEFT JOIN: All inventory items with location details
SELECT a.inventory_id, a.item_name, a.type, a.quantity, a.location, b.commander
FROM arms_inventory a
LEFT JOIN battalions b ON a.location = b.location;

-- 3. MULTIPLE JOINS: Complete arms information
SELECT a.inventory_id, a.item_name, a.type, a.quantity, a.location, 
       w.manufacturer, w.model, b.name as battalion_name
FROM arms_inventory a
LEFT JOIN weapons w ON a.item_name = w.name
LEFT JOIN battalions b ON a.location = b.location;

-- 4. SELF JOIN: Find duplicate inventory items
SELECT a1.inventory_id as id1, a2.inventory_id as id2, a1.item_name, a1.location
FROM arms_inventory a1
INNER JOIN arms_inventory a2 ON a1.item_name = a2.item_name 
AND a1.location = a2.location
AND a1.inventory_id < a2.inventory_id;

-- 5. RIGHT JOIN: All weapons with inventory status
SELECT w.name as weapon_name, w.type, a.quantity, a.location, a.condition
FROM arms_inventory a
RIGHT JOIN weapons w ON a.item_name = w.name;

-- SUBQUERIES for arms_inventory table

-- 1. Single row subquery: Most stocked weapon
SELECT item_name, type, quantity, location
FROM arms_inventory
WHERE quantity = (SELECT MAX(quantity) FROM arms_inventory);

-- 2. Multiple row subquery: Firearms in specific locations
SELECT item_name, quantity, location, condition
FROM arms_inventory
WHERE type = 'Rifle' AND location IN ('Delhi Armory', 'Pathankot Base', 'Srinagar Depot');

-- 3. Correlated subquery: Items needing maintenance
SELECT item_name, location, condition, last_checked
FROM arms_inventory a1
WHERE condition != 'Excellent' AND last_checked < (
    SELECT DATE_SUB(CURDATE(), INTERVAL 30 DAY)
) OR condition = 'Fair' AND EXISTS (
    SELECT 1 FROM arms_inventory a2 
    WHERE a2.item_name = a1.item_name 
    AND a2.condition = 'Excellent'
);

-- 4. Subquery in SELECT: Inventory statistics by type
SELECT type,
       COUNT(*) as item_types,
       SUM(quantity) as total_quantity,
       ROUND((SUM(quantity) * 100.0 / (SELECT SUM(quantity) FROM arms_inventory)), 2) as percentage
FROM arms_inventory
GROUP BY type;

-- 5. Subquery with EXISTS: Items checked recently
SELECT item_name, location, last_checked, checked_by
FROM arms_inventory a
WHERE EXISTS (
    SELECT 1 WHERE a.last_checked >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
);

-- BUILT-IN FUNCTIONS for arms_inventory table

-- 1. String functions: Item name and condition analysis
SELECT inventory_id,
       UPPER(type) as type_upper,
       CONCAT(item_name, ' (', type, ')') as full_description,
       REPLACE(condition, 'Good', 'Operational') as operational_status
FROM arms_inventory;

-- 2. Date functions: Maintenance scheduling analysis
SELECT inventory_id, last_checked,
       DATEDIFF(CURDATE(), last_checked) as days_since_check,
       DATE_ADD(last_checked, INTERVAL 90 DAY) as next_check_due,
       WEEK(last_checked) as check_week
FROM arms_inventory;

-- 3. Aggregate functions: Location-based inventory statistics
SELECT location,
       COUNT(*) as total_items,
       SUM(quantity) as total_quantity,
       AVG(quantity) as avg_quantity_per_item,
       MIN(last_checked) as oldest_check
FROM arms_inventory
GROUP BY location;

-- 4. Mathematical functions: Quantity and distribution analysis
SELECT type,
       SUM(quantity) as total_quantity,
       ROUND(AVG(quantity), 2) as average_stock,
       MAX(quantity) as max_stock,
       MIN(quantity) as min_stock,
       ROUND(VARIANCE(quantity), 2) as stock_variance
FROM arms_inventory
GROUP BY type;

-- 5. Control flow functions: Inventory status categorization
SELECT inventory_id, item_name, quantity, condition, status,
       CASE 
           WHEN quantity = 0 THEN 'Out of Stock'
           WHEN quantity < 10 THEN 'Low Stock'
           WHEN quantity < 50 THEN 'Adequate Stock'
           ELSE 'Well Stocked'
       END as stock_level,
       IF(condition = 'Excellent', 'Ready', 'Inspection Needed') as readiness_status
FROM arms_inventory;

-- USER DEFINED FUNCTIONS for arms_inventory table

-- 1. Function to calculate reorder quantity
DELIMITER //
CREATE FUNCTION CalculateReorderQuantity(current_quantity INT, item_type VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE reorder_qty INT;
    
    IF item_type = 'Rifle' THEN
        SET reorder_qty = GREATEST(100 - current_quantity, 0);
    ELSEIF item_type = 'Ammunition' THEN
        SET reorder_qty = GREATEST(5000 - current_quantity, 0);
    ELSEIF item_type = 'Explosive' THEN
        SET reorder_qty = GREATEST(50 - current_quantity, 0);
    ELSE
        SET reorder_qty = GREATEST(25 - current_quantity, 0);
    END IF;
    
    RETURN reorder_qty;
END //
DELIMITER ;

-- 2. Function to determine maintenance priority
DELIMITER //
CREATE FUNCTION DetermineMaintenancePriority(condition_status VARCHAR(50), last_checked DATE)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE priority VARCHAR(15);
    DECLARE days_since_check INT;
    
    SET days_since_check = DATEDIFF(CURDATE(), last_checked);
    
    IF condition_status = 'Fair' AND days_since_check > 60 THEN
        SET priority = 'High';
    ELSEIF condition_status = 'Good' AND days_since_check > 90 THEN
        SET priority = 'Medium';
    ELSEIF days_since_check > 180 THEN
        SET priority = 'Low';
    ELSE
        SET priority = 'Routine';
    END IF;
    
    RETURN priority;
END //
DELIMITER ;

-- 3. Function to check deployment readiness
DELIMITER //
CREATE FUNCTION CheckDeploymentReadiness(quantity INT, condition_status VARCHAR(50), item_type VARCHAR(50))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE readiness VARCHAR(20);
    
    IF condition_status IN ('Excellent', 'Good') AND quantity >= 10 THEN
        SET readiness = 'Fully Ready';
    ELSEIF condition_status = 'Good' AND quantity >= 5 THEN
        SET readiness = 'Partially Ready';
    ELSEIF quantity > 0 THEN
        SET readiness = 'Limited Readiness';
    ELSE
        SET readiness = 'Not Ready';
    END IF;
    
    RETURN readiness;
END //
DELIMITER ;

-- 4. Function to calculate inventory value score
DELIMITER //
CREATE FUNCTION CalculateInventoryValue(quantity INT, item_type VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE value_score INT;
    
    IF item_type = 'Rifle' THEN
        SET value_score = quantity * 10;
    ELSEIF item_type = 'Ammunition' THEN
        SET value_score = quantity * 1;
    ELSEIF item_type = 'Explosive' THEN
        SET value_score = quantity * 25;
    ELSEIF item_type = 'Optical' THEN
        SET value_score = quantity * 15;
    ELSE
        SET value_score = quantity * 5;
    END IF;
    
    RETURN value_score;
END //
DELIMITER ;

-- 5. Function to get security level requirement
DELIMITER //
CREATE FUNCTION GetSecurityLevel(item_type VARCHAR(50), quantity INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE security_level VARCHAR(20);
    
    IF item_type IN ('Explosive', 'Missile', 'Rocket Launcher') THEN
        SET security_level = 'Maximum Security';
    ELSEIF item_type IN ('Rifle', 'SMG', 'Sniper Rifle') AND quantity > 50 THEN
        SET security_level = 'High Security';
    ELSEIF item_type = 'Ammunition' AND quantity > 1000 THEN
        SET security_level = 'Medium Security';
    ELSE
        SET security_level = 'Standard Security';
    END IF;
    
    RETURN security_level;
END //
DELIMITER ;

-- Using the UDFs for arms_inventory
SELECT inventory_id, item_name, type, quantity, location, condition, last_checked,
       CalculateReorderQuantity(quantity, type) as reorder_quantity,
       DetermineMaintenancePriority(condition, last_checked) as maintenance_priority,
       CheckDeploymentReadiness(quantity, condition, type) as deployment_readiness,
       CalculateInventoryValue(quantity, type) as inventory_value_score,
       GetSecurityLevel(type, quantity) as required_security_level
FROM arms_inventory;

-- =============================================
-- COMM_CHANNELS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for comm_channels table

-- 1. INNER JOIN: Communication channels with assigned units
SELECT c.channel_id, c.name as channel_name, c.type, c.range_km, b.name as battalion_name, b.location
FROM comm_channels c
INNER JOIN battalions b ON c.assigned_unit = b.name;

-- 2. LEFT JOIN: All channels with technician details
SELECT c.channel_id, c.name, c.type, c.frequency, c.technician, c.status
FROM comm_channels c
LEFT JOIN support_staff s ON c.technician = s.name;

-- 3. MULTIPLE JOINS: Complete communication network view
SELECT c.channel_id, c.name as channel, c.type, c.range_km, c.frequency,
       b.name as assigned_unit, b.location, o.name as unit_commander
FROM comm_channels c
LEFT JOIN battalions b ON c.assigned_unit = b.name
LEFT JOIN officers o ON b.commander = o.name;

-- 4. SELF JOIN: Find overlapping frequency channels
SELECT c1.channel_id as channel1, c2.channel_id as channel2, 
       c1.frequency as freq1, c2.frequency as freq2, c1.assigned_unit
FROM comm_channels c1
INNER JOIN comm_channels c2 ON c1.frequency = c2.frequency 
AND c1.assigned_unit = c2.assigned_unit
AND c1.channel_id < c2.channel_id;

-- 5. RIGHT JOIN: All battalions with their communication channels
SELECT b.name as battalion_name, b.location, c.name as channel_name, c.type, c.status
FROM comm_channels c
RIGHT JOIN battalions b ON c.assigned_unit = b.name;

-- SUBQUERIES for comm_channels table

-- 1. Single row subquery: Longest range communication channel
SELECT name, type, range_km, frequency, assigned_unit
FROM comm_channels
WHERE range_km = (SELECT MAX(range_km) FROM comm_channels);

-- 2. Multiple row subquery: Satellite communication channels
SELECT name, frequency, range_km, status
FROM comm_channels
WHERE type = 'Satellite';

-- 3. Correlated subquery: Channels needing maintenance
SELECT c1.name, c1.type, c1.last_maintenance, c1.status
FROM comm_channels c1
WHERE c1.last_maintenance < (
    SELECT DATE_SUB(CURDATE(), INTERVAL 180 DAY)
) OR c1.status = 'Under Maintenance' AND EXISTS (
    SELECT 1 FROM comm_channels c2 
    WHERE c2.assigned_unit = c1.assigned_unit 
    AND c2.status = 'Active'
);

-- 4. Subquery in SELECT: Communication statistics by type
SELECT type,
       COUNT(*) as channel_count,
       AVG(range_km) as average_range,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM comm_channels)), 2) as percentage
FROM comm_channels
GROUP BY type;

-- 5. Subquery with EXISTS: Active channels in border areas
SELECT c.name, c.type, c.range_km, c.assigned_unit
FROM comm_channels c
WHERE c.status = 'Active' AND EXISTS (
    SELECT 1 FROM battalions b 
    WHERE b.name = c.assigned_unit 
    AND b.location IN ('Siachen', 'Kargil', 'Leh')
);

-- BUILT-IN FUNCTIONS for comm_channels table

-- 1. String functions: Channel name and frequency analysis
SELECT channel_id,
       UPPER(type) as type_upper,
       CONCAT(name, ' (', frequency, ')') as channel_description,
       SUBSTRING(frequency, 1, 5) as frequency_band
FROM comm_channels;

-- 2. Mathematical functions: Range and capacity calculations
SELECT channel_id, range_km,
       ROUND(range_km * 0.621371, 2) as range_miles,
       ROUND(range_km / 100, 2) as range_hundred_km,
       POWER(range_km, 2) as range_squared
FROM comm_channels;

-- 3. Date functions: Maintenance scheduling analysis
SELECT channel_id, last_maintenance,
       DATEDIFF(CURDATE(), last_maintenance) as days_since_maintenance,
       DATE_ADD(last_maintenance, INTERVAL 90 DAY) as next_maintenance_due,
       QUARTER(last_maintenance) as maintenance_quarter
FROM comm_channels;

-- 4. Aggregate functions: Communication network statistics
SELECT type,
       COUNT(*) as total_channels,
       AVG(range_km) as avg_range,
       SUM(CASE WHEN status = 'Active' THEN 1 ELSE 0 END) as active_channels,
       MIN(last_maintenance) as oldest_maintenance
FROM comm_channels
GROUP BY type;

-- 5. Control flow functions: Channel status categorization
SELECT channel_id, name, type, status, range_km,
       CASE 
           WHEN range_km > 1000 THEN 'Strategic'
           WHEN range_km > 100 THEN 'Tactical'
           ELSE 'Local'
       END as channel_class,
       IF(status = 'Active', 'Operational', 'Non-Operational') as operational_status
FROM comm_channels;

-- USER DEFINED FUNCTIONS for comm_channels table

-- 1. Function to calculate communication reliability score
DELIMITER //
CREATE FUNCTION CalculateReliabilityScore(status VARCHAR(50), last_maintenance DATE, range_km DECIMAL(6,2))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE reliability_score INT DEFAULT 100;
    DECLARE days_since_maintenance INT;
    
    SET days_since_maintenance = DATEDIFF(CURDATE(), last_maintenance);
    
    -- Deduct points based on maintenance delay
    IF days_since_maintenance > 180 THEN
        SET reliability_score = reliability_score - 40;
    ELSEIF days_since_maintenance > 90 THEN
        SET reliability_score = reliability_score - 20;
    END IF;
    
    -- Deduct points if not active
    IF status != 'Active' THEN
        SET reliability_score = reliability_score - 50;
    END IF;
    
    -- Add points for longer range
    SET reliability_score = reliability_score + (range_km / 10);
    
    RETURN GREATEST(reliability_score, 0);
END //
DELIMITER ;

-- 2. Function to determine maintenance urgency
DELIMITER //
CREATE FUNCTION DetermineMaintenanceUrgency(last_maintenance DATE, status VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE urgency VARCHAR(15);
    DECLARE days_since_maintenance INT;
    
    SET days_since_maintenance = DATEDIFF(CURDATE(), last_maintenance);
    
    IF status = 'Under Maintenance' THEN
        SET urgency = 'Immediate';
    ELSEIF days_since_maintenance > 365 THEN
        SET urgency = 'Critical';
    ELSEIF days_since_maintenance > 180 THEN
        SET urgency = 'High';
    ELSEIF days_since_maintenance > 90 THEN
        SET urgency = 'Medium';
    ELSE
        SET urgency = 'Low';
    END IF;
    
    RETURN urgency;
END //
DELIMITER ;

-- 3. Function to check channel interoperability
DELIMITER //
CREATE FUNCTION CheckInteroperability(channel_type VARCHAR(50), frequency VARCHAR(50))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE interoperability VARCHAR(20);
    
    IF channel_type = 'Satellite' AND frequency LIKE '%GHz%' THEN
        SET interoperability = 'Joint Operations';
    ELSEIF channel_type IN ('VHF', 'UHF') THEN
        SET interoperability = 'Tactical Network';
    ELSEIF channel_type = 'Radio HF' THEN
        SET interoperability = 'Long Range Only';
    ELSE
        SET interoperability = 'Limited Interop';
    END IF;
    
    RETURN interoperability;
END //
DELIMITER ;

-- 4. Function to calculate encryption level
DELIMITER //
CREATE FUNCTION CalculateEncryptionLevel(channel_type VARCHAR(50), assigned_unit VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE encryption_level VARCHAR(20);
    
    IF channel_type = 'Satellite' OR assigned_unit LIKE '%Special%' THEN
        SET encryption_level = 'Level 3 (Highest)';
    ELSEIF channel_type IN ('UHF', 'Microwave') THEN
        SET encryption_level = 'Level 2 (Medium)';
    ELSEIF channel_type IN ('VHF', 'Radio HF') THEN
        SET encryption_level = 'Level 1 (Basic)';
    ELSE
        SET encryption_level = 'Level 0 (None)';
    END IF;
    
    RETURN encryption_level;
END //
DELIMITER ;

-- 5. Function to get bandwidth capacity
DELIMITER //
CREATE FUNCTION GetBandwidthCapacity(channel_type VARCHAR(50), frequency VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE bandwidth VARCHAR(15);
    
    IF channel_type = 'Satellite' THEN
        SET bandwidth = 'High Bandwidth';
    ELSEIF channel_type = 'Microwave' THEN
        SET bandwidth = 'Medium Bandwidth';
    ELSEIF channel_type IN ('UHF', 'VHF') THEN
        SET bandwidth = 'Low Bandwidth';
    ELSE
        SET bandwidth = 'Voice Only';
    END IF;
    
    RETURN bandwidth;
END //
DELIMITER ;

-- Using the UDFs for comm_channels
SELECT channel_id, name, type, range_km, frequency, status, last_maintenance, assigned_unit,
       CalculateReliabilityScore(status, last_maintenance, range_km) as reliability_score,
       DetermineMaintenanceUrgency(last_maintenance, status) as maintenance_urgency,
       CheckInteroperability(type, frequency) as interoperability,
       CalculateEncryptionLevel(type, assigned_unit) as encryption_level,
       GetBandwidthCapacity(type, frequency) as bandwidth_capacity
FROM comm_channels;

-- =============================================
-- INTELLIGENCE_REPORTS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for intelligence_reports table

-- 1. INNER JOIN: Intelligence reports with reviewing officers
SELECT i.report_id, i.source, i.type, i.priority, o.name as reviewing_officer, i.status
FROM intelligence_reports i
INNER JOIN officers o ON i.reviewed_by = o.name;

-- 2. LEFT JOIN: All reports with detailed officer information
SELECT i.report_id, i.source, i.type, i.priority, i.location, 
       o.name as reviewer, o.rank, o.branch
FROM intelligence_reports i
LEFT JOIN officers o ON i.reviewed_by = o.name;

-- 3. MULTIPLE JOINS: Complete intelligence picture
SELECT i.report_id, i.source, i.type, i.priority, i.location,
       o.name as reviewing_officer, o.rank, b.name as battalion_in_area
FROM intelligence_reports i
LEFT JOIN officers o ON i.reviewed_by = o.name
LEFT JOIN battalions b ON i.location LIKE CONCAT('%', b.location, '%');

-- 4. SELF JOIN: Find related intelligence reports
SELECT i1.report_id as report1, i2.report_id as report2, 
       i1.location, i1.type, i1.report_date
FROM intelligence_reports i1
INNER JOIN intelligence_reports i2 ON i1.location = i2.location 
AND i1.type = i2.type
AND i1.report_date = i2.report_date
AND i1.report_id < i2.report_id;

-- 5. RIGHT JOIN: All officers with their reviewed reports
SELECT o.name as officer_name, o.rank, i.report_id, i.type, i.priority, i.status
FROM intelligence_reports i
RIGHT JOIN officers o ON i.reviewed_by = o.name;

-- SUBQUERIES for intelligence_reports table

-- 1. Single row subquery: Most recent critical intelligence
SELECT report_id, source, type, content, report_date
FROM intelligence_reports
WHERE priority = 'Critical' 
AND report_date = (SELECT MAX(report_date) FROM intelligence_reports WHERE priority = 'Critical');

-- 2. Multiple row subquery: Reconnaissance reports from border areas
SELECT report_id, source, location, report_date, status
FROM intelligence_reports
WHERE type = 'Reconnaissance' 
AND location IN ('LOC', 'Siachen', 'Kargil', 'Arunachal Border');

-- 3. Correlated subquery: Unreviewed high priority reports
SELECT i1.report_id, i1.source, i1.type, i1.priority, i1.report_date
FROM intelligence_reports i1
WHERE i1.status = 'Pending' AND i1.priority = 'High' AND NOT EXISTS (
    SELECT 1 FROM intelligence_reports i2 
    WHERE i2.report_id = i1.report_id 
    AND i2.reviewed_by IS NOT NULL
);

-- 4. Subquery in SELECT: Intelligence statistics by priority
SELECT priority,
       COUNT(*) as report_count,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM intelligence_reports)), 2) as percentage,
       AVG(CHAR_LENGTH(content)) as avg_content_length
FROM intelligence_reports
GROUP BY priority;

-- 5. Subquery with EXISTS: Cyber intelligence reports
SELECT report_id, source, report_date, content
FROM intelligence_reports i
WHERE i.type = 'Cyber Intelligence' AND EXISTS (
    SELECT 1 WHERE i.content LIKE '%malware%' OR i.content LIKE '%hack%'
);

-- BUILT-IN FUNCTIONS for intelligence_reports table

-- 1. String functions: Report content and source analysis
SELECT report_id,
       UPPER(type) as type_upper,
       CONCAT(source, ' - ', type) as report_source_type,
       SUBSTRING(content, 1, 50) as content_preview,
       REVERSE(source) as encoded_source
FROM intelligence_reports;

-- 2. Date functions: Report timing and urgency analysis
SELECT report_id, report_date,
       DATEDIFF(CURDATE(), report_date) as days_old,
       DAYNAME(report_date) as report_day,
       MONTHNAME(report_date) as report_month,
       WEEK(report_date) as report_week
FROM intelligence_reports;

-- 3. Aggregate functions: Intelligence analysis statistics
SELECT type,
       COUNT(*) as total_reports,
       AVG(DATEDIFF(CURDATE(), report_date)) as avg_days_old,
       COUNT(DISTINCT source) as unique_sources,
       MIN(report_date) as earliest_report
FROM intelligence_reports
GROUP BY type;

-- 4. Mathematical functions: Report impact analysis
SELECT priority,
       COUNT(*) as report_count,
       COUNT(*) * 
       CASE 
           WHEN priority = 'Critical' THEN 10
           WHEN priority = 'High' THEN 5
           WHEN priority = 'Medium' THEN 2
           ELSE 1
       END as weighted_impact_score
FROM intelligence_reports
GROUP BY priority;

-- 5. Control flow functions: Report action categorization
SELECT report_id, type, priority, status, report_date,
       CASE 
           WHEN priority = 'Critical' AND DATEDIFF(CURDATE(), report_date) <= 1 THEN 'Immediate Action'
           WHEN priority = 'High' AND DATEDIFF(CURDATE(), report_date) <= 3 THEN 'Urgent Action'
           WHEN status = 'Reviewed' THEN 'Action Completed'
           ELSE 'Pending Review'
       END as action_status,
       IF(DATEDIFF(CURDATE(), report_date) > 30, 'Stale Intelligence', 'Current Intelligence') as intelligence_freshness
FROM intelligence_reports;

-- USER DEFINED FUNCTIONS for intelligence_reports table

-- 1. Function to calculate intelligence credibility score
DELIMITER //
CREATE FUNCTION CalculateCredibilityScore(source VARCHAR(100), type VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE credibility_score INT DEFAULT 50;
    
    -- Adjust score based on source reliability
    IF source LIKE '%Drone%' OR source LIKE '%Satellite%' THEN
        SET credibility_score = credibility_score + 30;
    ELSEIF source LIKE '%Field Agent%' THEN
        SET credibility_score = credibility_score + 20;
    ELSEIF source LIKE '%Intercepted%' THEN
        SET credibility_score = credibility_score + 15;
    ELSEIF source LIKE '%Civilian%' THEN
        SET credibility_score = credibility_score - 10;
    END IF;
    
    -- Adjust score based on intelligence type
    IF type = 'Imagery' THEN
        SET credibility_score = credibility_score + 20;
    ELSEIF type = 'Signals Intelligence' THEN
        SET credibility_score = credibility_score + 15;
    ELSEIF type = 'Human Intelligence' THEN
        SET credibility_score = credibility_score + 10;
    END IF;
    
    RETURN LEAST(credibility_score, 100);
END //
DELIMITER ;

-- 2. Function to determine response timeline
DELIMITER //
CREATE FUNCTION DetermineResponseTimeline(priority VARCHAR(50), report_date DATE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE response_timeline VARCHAR(20);
    DECLARE hours_since_report INT;
    
    SET hours_since_report = TIMESTAMPDIFF(HOUR, report_date, CURDATE());
    
    IF priority = 'Critical' AND hours_since_report <= 6 THEN
        SET response_timeline = 'Immediate (1-6 hours)';
    ELSEIF priority = 'High' AND hours_since_report <= 24 THEN
        SET response_timeline = 'Urgent (24 hours)';
    ELSEIF priority = 'Medium' AND hours_since_report <= 72 THEN
        SET response_timeline = 'Normal (72 hours)';
    ELSE
        SET response_timeline = 'Delayed Response';
    END IF;
    
    RETURN response_timeline;
END //
DELIMITER ;

-- 3. Function to check verification need
DELIMITER //
CREATE FUNCTION CheckVerificationNeed(source VARCHAR(100), type VARCHAR(50), priority VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE verification_need VARCHAR(15);
    
    IF source LIKE '%Civilian%' AND priority IN ('High', 'Critical') THEN
        SET verification_need = 'High Priority';
    ELSEIF type = 'Human Intelligence' AND priority = 'Critical' THEN
        SET verification_need = 'Immediate';
    ELSEIF source NOT LIKE '%Drone%' AND source NOT LIKE '%Satellite%' THEN
        SET verification_need = 'Recommended';
    ELSE
        SET verification_need = 'Not Required';
    END IF;
    
    RETURN verification_need;
END //
DELIMITER ;

-- 4. Function to calculate operational impact
DELIMITER //
CREATE FUNCTION CalculateOperationalImpact(priority VARCHAR(50), location VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE operational_impact VARCHAR(20);
    
    IF priority = 'Critical' AND location IN ('LOC', 'Siachen', 'Kargil') THEN
        SET operational_impact = 'Strategic Impact';
    ELSEIF priority = 'High' AND location LIKE '%Border%' THEN
        SET operational_impact = 'Tactical Impact';
    ELSEIF priority IN ('High', 'Critical') THEN
        SET operational_impact = 'Operational Impact';
    ELSE
        SET operational_impact = 'Local Impact';
    END IF;
    
    RETURN operational_impact;
END //
DELIMITER ;

-- 5. Function to get intelligence classification
DELIMITER //
CREATE FUNCTION GetIntelligenceClassification(type VARCHAR(50), content TEXT)
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
    DECLARE classification VARCHAR(25);
    
    IF type = 'Cyber Intelligence' OR content LIKE '%classified%' OR content LIKE '%secret%' THEN
        SET classification = 'Top Secret';
    ELSEIF type IN ('Signals Intelligence', 'Aerial') THEN
        SET classification = 'Secret';
    ELSEIF type = 'Reconnaissance' THEN
        SET classification = 'Confidential';
    ELSE
        SET classification = 'Restricted';
    END IF;
    
    RETURN classification;
END //
DELIMITER ;

-- Using the UDFs for intelligence_reports
SELECT report_id, source, type, priority, location, report_date, status,
       CalculateCredibilityScore(source, type) as credibility_score,
       DetermineResponseTimeline(priority, report_date) as response_timeline,
       CheckVerificationNeed(source, type, priority) as verification_need,
       CalculateOperationalImpact(priority, location) as operational_impact,
       GetIntelligenceClassification(type, content) as classification_level
FROM intelligence_reports;

-- =============================================
-- EQUIPMENT TABLE QUERIES
-- =============================================

-- JOINS QUERIES for equipment table

-- 1. INNER JOIN: Equipment with assigned battalions
SELECT e.equipment_id, e.name as equipment_name, e.type, e.quantity, b.name as battalion_name, b.location
FROM equipment e
INNER JOIN battalions b ON e.assigned_unit = b.name;

-- 2. LEFT JOIN: All equipment with maintenance status
SELECT e.equipment_id, e.name, e.type, e.quantity, e.condition, e.status, s.name as support_technician
FROM equipment e
LEFT JOIN support_staff s ON e.assigned_unit LIKE CONCAT('%', s.department, '%');

-- 3. MULTIPLE JOINS: Complete equipment deployment view
SELECT e.equipment_id, e.name, e.type, e.quantity, e.assigned_unit,
       b.location, b.commander, o.contact_number
FROM equipment e
LEFT JOIN battalions b ON e.assigned_unit = b.name
LEFT JOIN officers o ON b.commander = o.name;

-- 4. SELF JOIN: Find similar equipment types
SELECT e1.equipment_id as eq1, e2.equipment_id as eq2, e1.type, e1.assigned_unit
FROM equipment e1
INNER JOIN equipment e2 ON e1.type = e2.type 
AND e1.assigned_unit = e2.assigned_unit
AND e1.equipment_id < e2.equipment_id;

-- 5. RIGHT JOIN: All battalions with their equipment
SELECT b.name as battalion_name, b.location, e.name as equipment_name, e.type, e.quantity
FROM equipment e
RIGHT JOIN battalions b ON e.assigned_unit = b.name;

-- SUBQUERIES for equipment table

-- 1. Single row subquery: Most abundant equipment type
SELECT name, type, quantity, assigned_unit
FROM equipment
WHERE quantity = (SELECT MAX(quantity) FROM equipment);

-- 2. Multiple row subquery: Optical equipment in forward areas
SELECT name, type, quantity, location
FROM equipment
WHERE type = 'Optical' AND location IN ('Srinagar Base', 'Leh Garrison', 'Kargil Post');

-- 3. Correlated subquery: Equipment needing replacement
SELECT e1.name, e1.type, e1.condition, e1.quantity
FROM equipment e1
WHERE e1.condition = 'Fair' AND e1.quantity < (
    SELECT AVG(e2.quantity) 
    FROM equipment e2 
    WHERE e2.type = e1.type
) OR e1.condition != 'Good' AND EXISTS (
    SELECT 1 FROM equipment e3 
    WHERE e3.type = e1.type 
    AND e3.condition = 'Excellent'
);

-- 4. Subquery in SELECT: Equipment statistics by type
SELECT type,
       COUNT(*) as equipment_types,
       SUM(quantity) as total_quantity,
       ROUND((SUM(quantity) * 100.0 / (SELECT SUM(quantity) FROM equipment)), 2) as percentage
FROM equipment
GROUP BY type;

-- 5. Subquery with EXISTS: Active equipment in combat units
SELECT e.name, e.type, e.quantity, e.assigned_unit
FROM equipment e
WHERE e.status = 'Active' AND EXISTS (
    SELECT 1 FROM battalions b 
    WHERE b.name = e.assigned_unit 
    AND b.name LIKE '%Infantry%'
);

-- BUILT-IN FUNCTIONS for equipment table

-- 1. String functions: Equipment name and type analysis
SELECT equipment_id,
       UPPER(type) as type_upper,
       CONCAT(name, ' (', model, ')') as full_equipment_name,
       REPLACE(condition, 'Fair', 'Needs Attention') as maintenance_status
FROM equipment;

-- 2. Mathematical functions: Quantity and distribution analysis
SELECT type,
       SUM(quantity) as total_quantity,
       AVG(quantity) as avg_per_unit,
       MAX(quantity) as max_quantity,
       MIN(quantity) as min_quantity,
       ROUND(STDDEV(quantity), 2) as quantity_std_dev
FROM equipment
GROUP BY type;

-- 3. Aggregate functions: Equipment deployment statistics
SELECT assigned_unit,
       COUNT(*) as equipment_types,
       SUM(quantity) as total_items,
       AVG(quantity) as avg_quantity_per_type,
       COUNT(DISTINCT type) as unique_equipment_types
FROM equipment
GROUP BY assigned_unit;

-- 4. Control flow functions: Equipment status categorization
SELECT equipment_id, name, type, quantity, condition, status,
       CASE 
           WHEN condition = 'Excellent' AND quantity >= 10 THEN 'Fully Operational'
           WHEN condition = 'Good' AND quantity >= 5 THEN 'Partially Operational'
           WHEN quantity > 0 THEN 'Limited Operation'
           ELSE 'Non-Operational'
       END as operational_status,
       IF(status = 'Active', 'In Service', 'Out of Service') as service_status
FROM equipment;

-- 5. Date simulation functions (using string functions)
SELECT equipment_id,
       CONCAT('EQ-', equipment_id) as equipment_code,
       CHAR_LENGTH(name) as name_complexity,
       REVERSE(type) as encoded_type
FROM equipment;

-- USER DEFINED FUNCTIONS for equipment table

-- 1. Function to calculate equipment utilization score
DELIMITER //
CREATE FUNCTION CalculateUtilizationScore(quantity INT, condition_status VARCHAR(50), equipment_type VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE utilization_score INT DEFAULT 0;
    
    -- Base score from quantity
    SET utilization_score = utilization_score + (quantity * 2);
    
    -- Condition multiplier
    IF condition_status = 'Excellent' THEN
        SET utilization_score = utilization_score * 1.5;
    ELSEIF condition_status = 'Good' THEN
        SET utilization_score = utilization_score * 1.2;
    ELSEIF condition_status = 'Fair' THEN
        SET utilization_score = utilization_score * 0.8;
    ELSE
        SET utilization_score = utilization_score * 0.5;
    END IF;
    
    -- Type importance multiplier
    IF equipment_type IN ('Night Vision', 'Thermal Imaging', 'Drone') THEN
        SET utilization_score = utilization_score * 1.3;
    ELSEIF equipment_type IN ('Communication', 'Surveillance') THEN
        SET utilization_score = utilization_score * 1.2;
    END IF;
    
    RETURN utilization_score;
END //
DELIMITER ;

-- 2. Function to determine maintenance priority
DELIMITER //
CREATE FUNCTION DetermineEquipmentMaintenance(condition_status VARCHAR(50), quantity INT)
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE maintenance_priority VARCHAR(15);
    
    IF condition_status = 'Fair' AND quantity < 5 THEN
        SET maintenance_priority = 'Critical';
    ELSEIF condition_status = 'Fair' THEN
        SET maintenance_priority = 'High';
    ELSEIF quantity < 3 THEN
        SET maintenance_priority = 'Medium';
    ELSE
        SET maintenance_priority = 'Low';
    END IF;
    
    RETURN maintenance_priority;
END //
DELIMITER ;

-- 3. Function to check deployment readiness
DELIMITER //
CREATE FUNCTION CheckEquipmentReadiness(quantity INT, condition_status VARCHAR(50), equipment_type VARCHAR(50))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE readiness VARCHAR(20);
    
    IF condition_status IN ('Excellent', 'Good') AND quantity >= 10 THEN
        SET readiness = 'Combat Ready';
    ELSEIF condition_status = 'Good' AND quantity >= 5 THEN
        SET readiness = 'Mission Ready';
    ELSEIF quantity > 0 THEN
        SET readiness = 'Limited Readiness';
    ELSE
        SET readiness = 'Not Ready';
    END IF;
    
    -- Special consideration for critical equipment
    IF equipment_type IN ('Night Vision', 'Communication') AND quantity = 0 THEN
        SET readiness = 'Critical Shortage';
    END IF;
    
    RETURN readiness;
END //
DELIMITER ;

-- 4. Function to calculate replacement need
DELIMITER //
CREATE FUNCTION CalculateReplacementNeed(condition_status VARCHAR(50), equipment_type VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE replacement_need VARCHAR(15);
    
    IF condition_status = 'Fair' AND equipment_type IN ('Night Vision', 'Thermal Imaging') THEN
        SET replacement_need = 'Urgent';
    ELSEIF condition_status = 'Fair' THEN
        SET replacement_need = 'High Priority';
    ELSEIF equipment_type IN ('Communication', 'Surveillance') THEN
        SET replacement_need = 'Medium Priority';
    ELSE
        SET replacement_need = 'Low Priority';
    END IF;
    
    RETURN replacement_need;
END //
DELIMITER ;

-- 5. Function to get equipment criticality level
DELIMITER //
CREATE FUNCTION GetEquipmentCriticality(equipment_type VARCHAR(50), assigned_unit VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE criticality_level VARCHAR(20);
    
    IF equipment_type IN ('Night Vision', 'Communication', 'Drone') THEN
        SET criticality_level = 'Mission Critical';
    ELSEIF assigned_unit LIKE '%Special%' AND equipment_type IN ('Optical', 'Surveillance') THEN
        SET criticality_level = 'High Criticality';
    ELSEIF equipment_type IN ('Protective Gear', 'Medical') THEN
        SET criticality_level = 'Essential';
    ELSE
        SET criticality_level = 'Standard';
    END IF;
    
    RETURN criticality_level;
END //
DELIMITER ;

-- Using the UDFs for equipment
SELECT equipment_id, name, type, quantity, condition, status, assigned_unit,
       CalculateUtilizationScore(quantity, condition, type) as utilization_score,
       DetermineEquipmentMaintenance(condition, quantity) as maintenance_priority,
       CheckEquipmentReadiness(quantity, condition, type) as deployment_readiness,
       CalculateReplacementNeed(condition, type) as replacement_need,
       GetEquipmentCriticality(type, assigned_unit) as criticality_level
FROM equipment;

-- =============================================
-- LOGISTICS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for logistics table

-- 1. INNER JOIN: Logistics with destination battalion details
SELECT l.logistic_id, l.item_name, l.category, l.quantity, b.name as battalion_name, b.location
FROM logistics l
INNER JOIN battalions b ON l.destination LIKE CONCAT('%', b.location, '%');

-- 2. LEFT JOIN: All logistics with source and destination details
SELECT l.logistic_id, l.item_name, l.category, l.quantity, l.source, l.destination, 
       s.name as received_by_person, l.status
FROM logistics l
LEFT JOIN support_staff s ON l.received_by = s.name;

-- 3. MULTIPLE JOINS: Complete logistics chain view
SELECT l.logistic_id, l.item_name, l.category, l.quantity, l.source, l.destination,
       b.name as destination_unit, b.commander, o.contact_number as commander_contact
FROM logistics l
LEFT JOIN battalions b ON l.destination LIKE CONCAT('%', b.location, '%')
LEFT JOIN officers o ON b.commander = o.name;

-- 4. SELF JOIN: Find related logistics shipments
SELECT l1.logistic_id as shipment1, l2.logistic_id as shipment2, 
       l1.item_name, l1.category, l1.destination
FROM logistics l1
INNER JOIN logistics l2 ON l1.category = l2.category 
AND l1.destination = l2.destination
AND l1.date_dispatched = l2.date_dispatched
AND l1.logistic_id < l2.logistic_id;

-- 5. RIGHT JOIN: All battalions with their logistics
SELECT b.name as battalion_name, b.location, l.item_name, l.category, l.quantity, l.status
FROM logistics l
RIGHT JOIN battalions b ON l.destination LIKE CONCAT('%', b.location, '%');

-- SUBQUERIES for logistics table

-- 1. Single row subquery: Largest logistics shipment
SELECT logistic_id, item_name, category, quantity, source, destination
FROM logistics
WHERE quantity = (SELECT MAX(quantity) FROM logistics);

-- 2. Multiple row subquery: Medical supplies to forward areas
SELECT logistic_id, item_name, quantity, destination, date_dispatched
FROM logistics
WHERE category = 'Medical' 
AND destination IN ('Siachen Camp', 'Kargil Post', 'Leh Forward Camp');

-- 3. Correlated subquery: Delayed shipments
SELECT l1.logistic_id, l1.item_name, l1.destination, l1.date_dispatched, l1.status
FROM logistics l1
WHERE l1.status = 'In Transit' AND l1.date_dispatched < (
    SELECT DATE_SUB(CURDATE(), INTERVAL 14 DAY)
) OR EXISTS (
    SELECT 1 FROM logistics l2 
    WHERE l2.destination = l1.destination 
    AND l2.category = l1.category 
    AND l2.status = 'Delivered'
    AND DATEDIFF(l2.date_dispatched, l1.date_dispatched) < 7
);

-- 4. Subquery in SELECT: Logistics statistics by category
SELECT category,
       COUNT(*) as shipment_count,
       SUM(quantity) as total_quantity,
       ROUND((SUM(quantity) * 100.0 / (SELECT SUM(quantity) FROM logistics)), 2) as percentage
FROM logistics
GROUP BY category;

-- 5. Subquery with EXISTS: Urgent shipments to border areas
SELECT logistic_id, item_name, category, destination, status
FROM logistics l
WHERE l.status = 'In Transit' AND EXISTS (
    SELECT 1 FROM battalions b 
    WHERE l.destination LIKE CONCAT('%', b.location, '%')
    AND b.region = 'Northern Command'
);

-- BUILT-IN FUNCTIONS for logistics table

-- 1. String functions: Item and destination analysis
SELECT logistic_id,
       UPPER(category) as category_upper,
       CONCAT(item_name, ' to ', destination) as shipment_description,
       SUBSTRING(remarks, 1, 30) as remarks_preview
FROM logistics;

-- 2. Date functions: Shipment timing analysis
SELECT logistic_id, date_dispatched,
       DATEDIFF(CURDATE(), date_dispatched) as days_in_transit,
       DAYNAME(date_dispatched) as dispatch_day,
       MONTHNAME(date_dispatched) as dispatch_month,
       WEEK(date_dispatched) as dispatch_week
FROM logistics;

-- 3. Aggregate functions: Logistics performance statistics
SELECT category,
       COUNT(*) as total_shipments,
       AVG(quantity) as avg_quantity_per_shipment,
       SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) as delivered_count,
       AVG(DATEDIFF(CURDATE(), date_dispatched)) as avg_days_in_transit
FROM logistics
GROUP BY category;

-- 4. Mathematical functions: Quantity and capacity analysis
SELECT category,
       SUM(quantity) as total_quantity,
       AVG(quantity) as avg_shipment_size,
       MAX(quantity) as largest_shipment,
       MIN(quantity) as smallest_shipment,
       ROUND(VARIANCE(quantity), 2) as quantity_variance
FROM logistics
GROUP BY category;

-- 5. Control flow functions: Shipment status categorization
SELECT logistic_id, item_name, category, status, date_dispatched,
       CASE 
           WHEN status = 'Delivered' THEN 'Completed'
           WHEN status = 'In Transit' AND DATEDIFF(CURDATE(), date_dispatched) > 21 THEN 'Delayed'
           WHEN status = 'In Transit' THEN 'On Time'
           ELSE 'Processing'
       END as delivery_status,
       IF(category IN ('Medical', 'Ammunition'), 'High Priority', 'Standard Priority') as priority_level
FROM logistics;

-- USER DEFINED FUNCTIONS for logistics table

-- 1. Function to calculate delivery urgency
DELIMITER //
CREATE FUNCTION CalculateDeliveryUrgency(date_dispatched DATE, category VARCHAR(50), status VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE urgency VARCHAR(15);
    DECLARE days_in_transit INT;
    
    SET days_in_transit = DATEDIFF(CURDATE(), date_dispatched);
    
    IF status != 'Delivered' THEN
        IF category = 'Medical' AND days_in_transit > 3 THEN
            SET urgency = 'Critical';
        ELSEIF category = 'Ammunition' AND days_in_transit > 7 THEN
            SET urgency = 'High';
        ELSEIF days_in_transit > 14 THEN
            SET urgency = 'Medium';
        ELSEIF days_in_transit > 7 THEN
            SET urgency = 'Low';
        ELSE
            SET urgency = 'Normal';
        END IF;
    ELSE
        SET urgency = 'Delivered';
    END IF;
    
    RETURN urgency;
END //
DELIMITER ;

-- 2. Function to determine shipment priority
DELIMITER //
CREATE FUNCTION DetermineShipmentPriority(category VARCHAR(50), destination VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE priority VARCHAR(20);
    
    IF category = 'Medical' AND destination LIKE '%Siachen%' THEN
        SET priority = 'Highest Priority';
    ELSEIF category = 'Ammunition' AND destination LIKE '%Border%' THEN
        SET priority = 'Combat Priority';
    ELSEIF category IN ('Medical', 'Ammunition') THEN
        SET priority = 'High Priority';
    ELSEIF destination IN ('Siachen', 'Kargil', 'Leh') THEN
        SET priority = 'Forward Area Priority';
    ELSE
        SET priority = 'Standard Priority';
    END IF;
    
    RETURN priority;
END //
DELIMITER ;

-- 3. Function to calculate expected delivery date
DELIMITER //
CREATE FUNCTION CalculateExpectedDelivery(date_dispatched DATE, destination VARCHAR(100))
RETURNS DATE
DETERMINISTIC
BEGIN
    DECLARE expected_delivery DATE;
    DECLARE transit_days INT;
    
    IF destination LIKE '%Siachen%' OR destination LIKE '%Kargil%' THEN
        SET transit_days = 10;
    ELSEIF destination LIKE '%Leh%' OR destination LIKE '%LOC%' THEN
        SET transit_days = 7;
    ELSEIF destination LIKE '%Border%' THEN
        SET transit_days = 5;
    ELSE
        SET transit_days = 3;
    END IF;
    
    SET expected_delivery = DATE_ADD(date_dispatched, INTERVAL transit_days DAY);
    
    RETURN expected_delivery;
END //
DELIMITER ;

-- 4. Function to check shipment consolidation possibility
DELIMITER //
CREATE FUNCTION CheckConsolidationPossibility(category VARCHAR(50), quantity INT, destination VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE consolidation VARCHAR(20);
    
    IF quantity < 10 AND destination NOT LIKE '%Siachen%' THEN
        SET consolidation = 'Can Consolidate';
    ELSEIF category = 'Medical' AND quantity < 5 THEN
        SET consolidation = 'Consolidate with Care';
    ELSEIF quantity < 20 THEN
        SET consolidation = 'Evaluate Consolidation';
    ELSE
        SET consolidation = 'Direct Shipment';
    END IF;
    
    RETURN consolidation;
END //
DELIMITER ;

-- 5. Function to get transportation mode
DELIMITER //
CREATE FUNCTION GetTransportationMode(category VARCHAR(50), quantity INT, destination VARCHAR(100))
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
    DECLARE transport_mode VARCHAR(25);
    
    IF destination LIKE '%Siachen%' OR destination LIKE '%Kargil%' THEN
        SET transport_mode = 'Air Transport';
    ELSEIF category = 'Medical' AND quantity < 50 THEN
        SET transport_mode = 'Rapid Transport';
    ELSEIF quantity > 100 THEN
        SET transport_mode = 'Rail Transport';
    ELSEIF destination LIKE '%Border%' THEN
        SET transport_mode = 'Armored Convoy';
    ELSE
        SET transport_mode = 'Road Transport';
    END IF;
    
    RETURN transport_mode;
END //
DELIMITER ;

-- Using the UDFs for logistics
SELECT logistic_id, item_name, category, quantity, source, destination, date_dispatched, status,
       CalculateDeliveryUrgency(date_dispatched, category, status) as delivery_urgency,
       DetermineShipmentPriority(category, destination) as shipment_priority,
       CalculateExpectedDelivery(date_dispatched, destination) as expected_delivery,
       CheckConsolidationPossibility(category, quantity, destination) as consolidation_possibility,
       GetTransportationMode(category, quantity, destination) as transportation_mode
FROM logistics;

-- =============================================
-- SUPPORT_STAFF TABLE QUERIES
-- =============================================

-- JOINS QUERIES for support_staff table

-- 1. INNER JOIN: Support staff with department battalions
SELECT s.staff_id, s.name as staff_name, s.role, s.department, b.location, b.commander
FROM support_staff s
INNER JOIN battalions b ON s.department = b.name;

-- 2. LEFT JOIN: All support staff with contact details
SELECT s.staff_id, s.name, s.role, s.department, s.contact_number, s.email, s.status
FROM support_staff s
LEFT JOIN battalions b ON s.department = b.name;

-- 3. MULTIPLE JOINS: Complete support staff deployment view
SELECT s.staff_id, s.name, s.role, s.department, s.contact_number,
       b.location, b.commander, o.contact_number as commander_contact
FROM support_staff s
LEFT JOIN battalions b ON s.department = b.name
LEFT JOIN officers o ON b.commander = o.name;

-- 4. SELF JOIN: Find staff in same department and role
SELECT s1.staff_id as staff1, s2.staff_id as staff2, s1.name as staff_name, s1.role, s1.department
FROM support_staff s1
INNER JOIN support_staff s2 ON s1.department = s2.department 
AND s1.role = s2.role
AND s1.staff_id < s2.staff_id;

-- 5. RIGHT JOIN: All battalions with their support staff
SELECT b.name as battalion_name, b.location, s.name as staff_name, s.role, s.status
FROM support_staff s
RIGHT JOIN battalions b ON s.department = b.name;

-- SUBQUERIES for support_staff table

-- 1. Single row subquery: Longest serving support staff
SELECT name, role, department, join_date
FROM support_staff
WHERE join_date = (SELECT MIN(join_date) FROM support_staff);

-- 2. Multiple row subquery: Medical support staff
SELECT staff_id, name, role, department, contact_number
FROM support_staff
WHERE role LIKE '%Medical%' OR role LIKE '%Nurse%' OR role LIKE '%Doctor%';

-- 3. Correlated subquery: Staff needing role rotation
SELECT s1.name, s1.role, s1.department, s1.join_date
FROM support_staff s1
WHERE s1.status = 'Active' AND DATEDIFF(CURDATE(), s1.join_date) > (
    SELECT AVG(DATEDIFF(CURDATE(), s2.join_date))
    FROM support_staff s2 
    WHERE s2.department = s1.department
) OR EXISTS (
    SELECT 1 FROM support_staff s3 
    WHERE s3.department = s1.department 
    AND s3.role = s1.role 
    AND s3.staff_id != s1.staff_id
);

-- 4. Subquery in SELECT: Staff statistics by department
SELECT department,
       COUNT(*) as total_staff,
       AVG(age) as average_age,
       ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM support_staff)), 2) as percentage
FROM support_staff
GROUP BY department;

-- 5. Subquery with EXISTS: Active support staff in forward areas
SELECT s.name, s.role, s.department, s.contact_number
FROM support_staff s
WHERE s.status = 'Active' AND EXISTS (
    SELECT 1 FROM battalions b 
    WHERE b.name = s.department 
    AND b.location IN ('Siachen', 'Kargil', 'Leh')
);

-- BUILT-IN FUNCTIONS for support_staff table

-- 1. String functions: Staff name and role analysis
SELECT staff_id,
       UPPER(role) as role_upper,
       CONCAT(name, ' - ', role) as staff_description,
       SUBSTRING(email, 1, LOCATE('@', email) - 1) as email_username
FROM support_staff;

-- 2. Date functions: Service duration analysis
SELECT staff_id, join_date,
       DATEDIFF(CURDATE(), join_date) as days_of_service,
       YEAR(CURDATE()) - YEAR(join_date) as years_of_service,
       DATE_ADD(join_date, INTERVAL 20 YEAR) as possible_retirement_date
FROM support_staff;

-- 3. Aggregate functions: Department staffing statistics
SELECT department,
       COUNT(*) as total_staff,
       AVG(age) as average_age,
       MIN(join_date) as earliest_join_date,
       MAX(age) as max_age,
       COUNT(DISTINCT role) as unique_roles
FROM support_staff
GROUP BY department;

-- 4. Mathematical functions: Age and service calculations
SELECT staff_id, age,
       age * 365 as approximate_days_old,
       ROUND(age / 5.0, 1) as age_in_5_year_blocks,
       MOD(age, 10) as years_since_last_decade
FROM support_staff;

-- 5. Control flow functions: Staff categorization
SELECT staff_id, name, role, department, status, age,
       CASE 
           WHEN role LIKE '%Medical%' THEN 'Healthcare'
           WHEN role LIKE '%Technician%' THEN 'Technical'
           WHEN role LIKE '%Admin%' THEN 'Administrative'
           WHEN role LIKE '%Cook%' THEN 'Services'
           ELSE 'General Support'
       END as staff_category,
       IF(status = 'Active', 'On Duty', 'Off Duty') as duty_status
FROM support_staff;

-- USER DEFINED FUNCTIONS for support_staff table

-- 1. Function to calculate service completion percentage
DELIMITER //
CREATE FUNCTION CalculateServiceCompletion(join_date DATE, retirement_age INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE current_age INT;
    DECLARE service_years INT;
    DECLARE completion_percentage DECIMAL(5,2);
    
    SET service_years = YEAR(CURDATE()) - YEAR(join_date);
    SET current_age = service_years + 18; -- Assuming joining at 18
    
    IF current_age >= retirement_age THEN
        SET completion_percentage = 100.00;
    ELSE
        SET completion_percentage = (service_years * 100.0) / (retirement_age - 18);
    END IF;
    
    RETURN completion_percentage;
END //
DELIMITER ;

-- 2. Function to determine skill level
DELIMITER //
CREATE FUNCTION DetermineSkillLevel(role VARCHAR(100), years_of_service INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE skill_level VARCHAR(20);
    
    IF years_of_service > 15 THEN
        SET skill_level = 'Expert';
    ELSEIF years_of_service > 8 THEN
        SET skill_level = 'Advanced';
    ELSEIF years_of_service > 3 THEN
        SET skill_level = 'Intermediate';
    ELSE
        SET skill_level = 'Beginner';
    END IF;
    
    -- Role-specific adjustments
    IF role LIKE '%Medical%' AND years_of_service > 5 THEN
        SET skill_level = CONCAT(skill_level, ' Medical');
    ELSEIF role LIKE '%Technician%' THEN
        SET skill_level = CONCAT(skill_level, ' Technical');
    END IF;
    
    RETURN skill_level;
END //
DELIMITER ;

-- 3. Function to check deployment eligibility
DELIMITER //
CREATE FUNCTION CheckDeploymentEligibility(role VARCHAR(100), age INT, status VARCHAR(50))
RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
    DECLARE eligibility VARCHAR(15);
    
    IF status != 'Active' THEN
        SET eligibility = 'Not Eligible';
    ELSEIF age > 50 THEN
        SET eligibility = 'Limited Eligibility';
    ELSEIF role IN ('Cook', 'Sanitation Worker', 'Clerk') THEN
        SET eligibility = 'Rear Area Only';
    ELSEIF role IN ('Medical Assistant', 'Technician', 'Driver') THEN
        SET eligibility = 'Forward Area Eligible';
    ELSE
        SET eligibility = 'Full Eligibility';
    END IF;
    
    RETURN eligibility;
END //
DELIMITER ;

-- 4. Function to calculate training need
DELIMITER //
CREATE FUNCTION CalculateTrainingNeed(role VARCHAR(100), join_date DATE)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE training_need VARCHAR(20);
    DECLARE years_of_service INT;
    
    SET years_of_service = YEAR(CURDATE()) - YEAR(join_date);
    
    IF years_of_service < 2 THEN
        SET training_need = 'Basic Training';
    ELSEIF years_of_service < 5 AND role LIKE '%Technician%' THEN
        SET training_need = 'Advanced Technical';
    ELSEIF years_of_service < 8 THEN
        SET training_need = 'Specialized Training';
    ELSEIF role LIKE '%Medical%' THEN
        SET training_need = 'Medical Update';
    ELSE
        SET training_need = 'Leadership Training';
    END IF;
    
    RETURN training_need;
END //
DELIMITER ;

-- 5. Function to get support staff criticality
DELIMITER //
CREATE FUNCTION GetStaffCriticality(role VARCHAR(100), department VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE criticality VARCHAR(20);
    
    IF role LIKE '%Medical%' AND department LIKE '%Infantry%' THEN
        SET criticality = 'Mission Critical';
    ELSEIF role IN ('Technician', 'Electrician', 'Driver') THEN
        SET criticality = 'Essential';
    ELSEIF role LIKE '%Cook%' AND department LIKE '%Forward%' THEN
        SET criticality = 'High Priority';
    ELSEIF role IN ('Admin', 'Clerk') THEN
        SET criticality = 'Support Role';
    ELSE
        SET criticality = 'General Support';
    END IF;
    
    RETURN criticality;
END //
DELIMITER ;

-- Using the UDFs for support_staff
SELECT staff_id, name, role, department, age, join_date, status,
       CalculateServiceCompletion(join_date, 58) as service_completion_percent,
       DetermineSkillLevel(role, YEAR(CURDATE()) - YEAR(join_date)) as skill_level,
       CheckDeploymentEligibility(role, age, status) as deployment_eligibility,
       CalculateTrainingNeed(role, join_date) as training_need,
       GetStaffCriticality(role, department) as staff_criticality
FROM support_staff;

-- =============================================
-- EQUIPMENT_INVENTORY TABLE QUERIES
-- =============================================

-- JOINS QUERIES for equipment_inventory table

-- 1. INNER JOIN: Equipment inventory with location battalions
SELECT e.equipment_id, e.name as equipment_name, e.category, e.quantity, b.name as battalion_name, b.location
FROM equipment_inventory e
INNER JOIN battalions b ON e.location = b.location;

-- 2. LEFT JOIN: All equipment with supplier and maintenance details
SELECT e.equipment_id, e.name, e.category, e.quantity, e.supplier_name, e.last_maintenance, e.condition_status
FROM equipment_inventory e
LEFT JOIN support_staff s ON e.location LIKE CONCAT('%', s.department, '%');

-- 3. MULTIPLE JOINS: Complete equipment management view
SELECT e.equipment_id, e.name, e.category, e.quantity, e.location,
       b.name as battalion_name, b.commander, o.contact_number as commander_contact
FROM equipment_inventory e
LEFT JOIN battalions b ON e.location = b.location
LEFT JOIN officers o ON b.commander = o.name;

-- 4. SELF JOIN: Find duplicate equipment entries
SELECT e1.equipment_id as eq1, e2.equipment_id as eq2, e1.name, e1.category, e1.location
FROM equipment_inventory e1
INNER JOIN equipment_inventory e2 ON e1.name = e2.name 
AND e1.category = e2.category
AND e1.location = e2.location
AND e1.equipment_id < e2.equipment_id;

-- 5. RIGHT JOIN: All battalions with their equipment inventory
SELECT b.name as battalion_name, b.location, e.name as equipment_name, e.category, e.quantity
FROM equipment_inventory e
RIGHT JOIN battalions b ON e.location = b.location;

-- SUBQUERIES for equipment_inventory table

-- 1. Single row subquery: Most recent equipment maintenance
SELECT equipment_id, name, category, last_maintenance, condition_status
FROM equipment_inventory
WHERE last_maintenance = (SELECT MAX(last_maintenance) FROM equipment_inventory);

-- 2. Multiple row subquery: Protective gear in forward bases
SELECT equipment_id, name, quantity, location, condition_status
FROM equipment_inventory
WHERE category = 'Protective Gear' 
AND location IN ('Srinagar Base', 'Leh Garrison', 'Kargil Post');

-- 3. Correlated subquery: Equipment needing urgent maintenance
SELECT e1.equipment_id, e1.name, e1.condition_status, e1.last_maintenance
FROM equipment_inventory e1
WHERE e1.condition_status IN ('Fair', 'Needs Repair') AND e1.last_maintenance < (
    SELECT DATE_SUB(CURDATE(), INTERVAL 180 DAY)
) OR EXISTS (
    SELECT 1 FROM equipment_inventory e2 
    WHERE e2.category = e1.category 
    AND e2.location = e1.location 
    AND e2.condition_status = 'Excellent'
);

-- 4. Subquery in SELECT: Equipment statistics by category
SELECT category,
       COUNT(*) as equipment_types,
       SUM(quantity) as total_quantity,
       ROUND((SUM(quantity) * 100.0 / (SELECT SUM(quantity) FROM equipment_inventory)), 2) as percentage
FROM equipment_inventory
GROUP BY category;

-- 5. Subquery with EXISTS: New equipment in inventory
SELECT equipment_id, name, category, issue_date, condition_status
FROM equipment_inventory e
WHERE e.issue_date >= DATE_SUB(CURDATE(), INTERVAL 90 DAY) AND EXISTS (
    SELECT 1 WHERE e.condition_status = 'New'
);

-- BUILT-IN FUNCTIONS for equipment_inventory table

-- 1. String functions: Equipment name and category analysis
SELECT equipment_id,
       UPPER(category) as category_upper,
       CONCAT(name, ' (', category, ')') as full_description,
       REPLACE(supplier_name, 'Ltd.', 'Limited') as supplier_full_name
FROM equipment_inventory;

-- 2. Date functions: Maintenance and issue date analysis
SELECT equipment_id, issue_date, last_maintenance,
       DATEDIFF(CURDATE(), last_maintenance) as days_since_maintenance,
       DATEDIFF(CURDATE(), issue_date) as days_since_issue,
       DATE_ADD(last_maintenance, INTERVAL 90 DAY) as next_maintenance_due
FROM equipment_inventory;

-- 3. Aggregate functions: Inventory statistics by location
SELECT location,
       COUNT(*) as equipment_types,
       SUM(quantity) as total_quantity,
       AVG(quantity) as avg_quantity_per_type,
       MIN(issue_date) as oldest_equipment,
       MAX(last_maintenance) as most_recent_maintenance
FROM equipment_inventory
GROUP BY location;

-- 4. Mathematical functions: Quantity and value analysis
SELECT category,
       SUM(quantity) as total_quantity,
       AVG(quantity) as avg_stock_level,
       MAX(quantity) as max_stock,
       MIN(quantity) as min_stock,
       ROUND(STDDEV(quantity), 2) as stock_std_deviation
FROM equipment_inventory
GROUP BY category;

-- 5. Control flow functions: Equipment status categorization
SELECT equipment_id, name, category, quantity, condition_status,
       CASE 
           WHEN condition_status = 'New' THEN 'Brand New'
           WHEN condition_status = 'Excellent' AND quantity > 10 THEN 'Fully Operational'
           WHEN condition_status = 'Good' AND quantity > 5 THEN 'Operational'
           WHEN quantity > 0 THEN 'Limited Stock'
           ELSE 'Out of Stock'
       END as operational_status,
       IF(last_maintenance < DATE_SUB(CURDATE(), INTERVAL 365 DAY), 'Maintenance Overdue', 'Maintenance Current') as maintenance_status
FROM equipment_inventory;

-- USER DEFINED FUNCTIONS for equipment_inventory table

-- 1. Function to calculate equipment serviceability score
DELIMITER //
CREATE FUNCTION CalculateServiceabilityScore(quantity INT, condition_status VARCHAR(50), last_maintenance DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE serviceability_score INT DEFAULT 0;
    DECLARE days_since_maintenance INT;
    
    SET days_since_maintenance = DATEDIFF(CURDATE(), last_maintenance);
    
    -- Base score from quantity
    SET serviceability_score = quantity * 5;
    
    -- Condition multiplier
    IF condition_status = 'New' THEN
        SET serviceability_score = serviceability_score * 1.5;
    ELSEIF condition_status = 'Excellent' THEN
        SET serviceability_score = serviceability_score * 1.3;
    ELSEIF condition_status = 'Good' THEN
        SET serviceability_score = serviceability_score * 1.1;
    ELSEIF condition_status = 'Fair' THEN
        SET serviceability_score = serviceability_score * 0.7;
    ELSE
        SET serviceability_score = serviceability_score * 0.3;
    END IF;
    
    -- Maintenance penalty
    IF days_since_maintenance > 365 THEN
        SET serviceability_score = serviceability_score * 0.5;
    ELSEIF days_since_maintenance > 180 THEN
        SET serviceability_score = serviceability_score * 0.8;
    END IF;
    
    RETURN serviceability_score;
END //
DELIMITER ;

-- 2. Function to determine replacement need
DELIMITER //
CREATE FUNCTION DetermineReplacementNeed(condition_status VARCHAR(50), issue_date DATE, category VARCHAR(50))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE replacement_need VARCHAR(20);
    DECLARE equipment_age INT;
    
    SET equipment_age = YEAR(CURDATE()) - YEAR(issue_date);
    
    IF condition_status IN ('Fair', 'Needs Repair') AND equipment_age > 5 THEN
        SET replacement_need = 'Immediate Replacement';
    ELSEIF equipment_age > 8 THEN
        SET replacement_need = 'Planned Replacement';
    ELSEIF condition_status = 'Fair' AND category IN ('Weapon', 'Optical') THEN
        SET replacement_need = 'Priority Replacement';
    ELSEIF equipment_age > 10 THEN
        SET replacement_need = 'Consider Replacement';
    ELSE
        SET replacement_need = 'No Replacement Needed';
    END IF;
    
    RETURN replacement_need;
END //
DELIMITER ;

-- 3. Function to check inventory optimization
DELIMITER //
CREATE FUNCTION CheckInventoryOptimization(quantity INT, category VARCHAR(50), location VARCHAR(100))
RETURNS VARCHAR(25)
DETERMINISTIC
BEGIN
    DECLARE optimization_status VARCHAR(25);
    
    IF category = 'Weapon' AND quantity > 50 THEN
        SET optimization_status = 'Overstocked - Redistribute';
    ELSEIF category = 'Protective Gear' AND quantity < 10 THEN
        SET optimization_status = 'Understocked - Replenish';
    ELSEIF location LIKE '%Forward%' AND quantity < 5 THEN
        SET optimization_status = 'Critical Low - Urgent Supply';
    ELSEIF quantity BETWEEN 10 AND 50 THEN
        SET optimization_status = 'Optimally Stocked';
    ELSE
        SET optimization_status = 'Adequate Stock';
    END IF;
    
    RETURN optimization_status;
END //
DELIMITER ;

-- 4. Function to calculate maintenance cost estimate
DELIMITER //
CREATE FUNCTION CalculateMaintenanceCost(category VARCHAR(50), condition_status VARCHAR(50), quantity INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE maintenance_cost DECIMAL(10,2);
    DECLARE base_cost DECIMAL(10,2);
    
    -- Set base cost per unit based on category
    IF category = 'Weapon' THEN
        SET base_cost = 500.00;
    ELSEIF category = 'Optical' THEN
        SET base_cost = 300.00;
    ELSEIF category = 'Protective Gear' THEN
        SET base_cost = 200.00;
    ELSEIF category = 'Communication' THEN
        SET base_cost = 400.00;
    ELSE
        SET base_cost = 100.00;
    END IF;
    
    -- Adjust for condition
    IF condition_status = 'Fair' THEN
        SET base_cost = base_cost * 1.5;
    ELSEIF condition_status = 'Needs Repair' THEN
        SET base_cost = base_cost * 2.0;
    END IF;
    
    SET maintenance_cost = base_cost * quantity * 0.1; -- 10% of base cost
    
    RETURN maintenance_cost;
END //
DELIMITER ;

-- 5. Function to get equipment lifecycle stage
DELIMITER //
CREATE FUNCTION GetLifecycleStage(issue_date DATE, condition_status VARCHAR(50))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE lifecycle_stage VARCHAR(20);
    DECLARE equipment_age INT;
    
    SET equipment_age = YEAR(CURDATE()) - YEAR(issue_date);
    
    IF condition_status = 'New' THEN
        SET lifecycle_stage = 'Brand New';
    ELSEIF equipment_age < 2 THEN
        SET lifecycle_stage = 'Early Service';
    ELSEIF equipment_age < 5 THEN
        SET lifecycle_stage = 'Prime Service';
    ELSEIF equipment_age < 8 THEN
        SET lifecycle_stage = 'Mature Service';
    ELSEIF equipment_age < 12 THEN
        SET lifecycle_stage = 'Late Service';
    ELSE
        SET lifecycle_stage = 'End of Life';
    END IF;
    
    RETURN lifecycle_stage;
END //
DELIMITER ;

-- Using the UDFs for equipment_inventory
SELECT equipment_id, name, category, quantity, location, condition_status, issue_date, last_maintenance,
       CalculateServiceabilityScore(quantity, condition_status, last_maintenance) as serviceability_score,
       DetermineReplacementNeed(condition_status, issue_date, category) as replacement_need,
       CheckInventoryOptimization(quantity, category, location) as inventory_optimization,
       CalculateMaintenanceCost(category, condition_status, quantity) as maintenance_cost_estimate,
       GetLifecycleStage(issue_date, condition_status) as lifecycle_stage
FROM equipment_inventory;

-- =============================================
-- TRAINING_RECORDS TABLE QUERIES
-- =============================================

-- JOINS QUERIES for training_records table

-- 1. INNER JOIN: Training records with soldier details
SELECT t.training_id, s.name as soldier_name, s.rank, t.course_name, t.start_date, t.end_date, t.result
FROM training_records t
INNER JOIN soldiers s ON t.soldier_id = s.soldier_id;

-- 2. LEFT JOIN: All training records with instructor details
SELECT t.training_id, s.name, t.course_name, t.instructor, t.training_center, t.certification_status
FROM training_records t
LEFT JOIN soldiers s ON t.soldier_id = s.soldier_id
LEFT JOIN officers o ON t.instructor = o.name;

-- 3. MULTIPLE JOINS: Complete training management view
SELECT t.training_id, s.name, s.unit, t.course_name, t.duration_days,
       t.instructor, t.training_center, t.result, b.location as unit_location
FROM training_records t
INNER JOIN soldiers s ON t.soldier_id = s.soldier_id
LEFT JOIN battalions b ON s.unit = b.name;

-- 4. SELF JOIN: Find soldiers with multiple related trainings
SELECT t1.training_id as training1, t2.training_id as training2, 
       s.name, t1.course_name as course1, t2.course_name as course2
FROM training_records t1
INNER JOIN training_records t2 ON t1.soldier_id = t2.soldier_id
INNER JOIN soldiers s ON t1.soldier_id = s.soldier_id
WHERE t1.course_name != t2.course_name
AND t1.training_id < t2.training_id;

-- 5. RIGHT JOIN: All soldiers with their training records
SELECT s.name, s.rank, s.unit, t.course_name, t.start_date, t.result, t.certification_status
FROM training_records t
RIGHT JOIN soldiers s ON t.soldier_id = s.soldier_id;

-- SUBQUERIES for training_records table

-- 1. Single row subquery: Longest duration training course
SELECT t.training_id, s.name, t.course_name, t.duration_days, t.start_date, t.end_date
FROM training_records t
INNER JOIN soldiers s ON t.soldier_id = s.soldier_id
WHERE t.duration_days = (SELECT MAX(duration_days) FROM training_records);

-- 2. Multiple row subquery: Special forces training courses
SELECT t.training_id, s.name, t.course_name, t.training_center, t.result
FROM training_records t
INNER JOIN soldiers s ON t.soldier_id = s.soldier_id
WHERE t.course_name IN ('Sniper Training', 'Para Jump Demo', 'Counter-Insurgency School', 'Unarmed Combat');

-- 3. Correlated subquery: Soldiers with excellent training performance
SELECT t1.training_id, s.name, t1.course_name, t1.result
FROM training_records t1
INNER JOIN soldiers s ON t1.soldier_id = s.soldier_id
WHERE t1.result = 'Passed' AND EXISTS (
    SELECT 1 FROM training_records t2 
    WHERE t2.soldier_id = t1.soldier_id 
    AND t2.result = 'Passed'
    AND t2.course_name LIKE '%Advanced%'
);

-- 4. Subquery in SELECT: Training statistics by course
SELECT course_name,
       COUNT(*) as total_trainees,
       SUM(CASE WHEN result = 'Passed' THEN 1 ELSE 0 END) as passed_count,
       ROUND((SUM(CASE WHEN result = 'Passed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) as pass_percentage,
       AVG(duration_days) as avg_duration
FROM training_records
GROUP BY course_name;

-- 5. Subquery with EXISTS: Recently completed trainings
SELECT t.training_id, s.name, t.course_name, t.end_date, t.result
FROM training_records t
INNER JOIN soldiers s ON t.soldier_id = s.soldier_id
WHERE t.end_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY) AND EXISTS (
    SELECT 1 WHERE t.certification_status = 'Certified'
);

-- BUILT-IN FUNCTIONS for training_records table

-- 1. String functions: Course name and result analysis
SELECT training_id,
       UPPER(course_name) as course_upper,
       CONCAT(course_name, ' - ', result) as training_result,
       SUBSTRING(instructor, 1, LOCATE(' ', instructor)) as instructor_first_name
FROM training_records;

-- 2. Date functions: Training scheduling analysis
SELECT training_id, start_date, end_date,
       DATEDIFF(end_date, start_date) as actual_duration,
       DAYNAME(start_date) as start_day,
       MONTHNAME(start_date) as start_month,
       QUARTER(start_date) as start_quarter
FROM training_records;

-- 3. Aggregate functions: Training performance statistics
SELECT training_center,
       COUNT(*) as total_trainings,
       AVG(duration_days) as avg_duration,
       SUM(CASE WHEN result = 'Passed' THEN 1 ELSE 0 END) as passed_count,
       ROUND((SUM(CASE WHEN result = 'Passed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 2) as success_rate
FROM training_records
GROUP BY training_center;

-- 4. Mathematical functions: Duration and efficiency analysis
SELECT course_name,
       AVG(duration_days) as avg_duration,
       MIN(duration_days) as min_duration,
       MAX(duration_days) as max_duration,
       ROUND(STDDEV(duration_days), 2) as duration_std_dev,
       AVG(duration_days) * COUNT(*) as total_training_days
FROM training_records
GROUP BY course_name;

-- 5. Control flow functions: Training outcome categorization
SELECT training_id, course_name, result, certification_status,
       CASE 
           WHEN result = 'Passed' AND certification_status = 'Certified' THEN 'Successfully Completed'
           WHEN result = 'Passed' THEN 'Completed - Pending Certification'
           WHEN result = 'Failed' THEN 'Needs Retraining'
           ELSE 'In Progress'
       END as training_status,
       IF(DATEDIFF(CURDATE(), end_date) > 365, 'Skills Refresh Needed', 'Skills Current') as skill_freshness
FROM training_records;

-- USER DEFINED FUNCTIONS for training_records table

-- 1. Function to calculate training effectiveness score
DELIMITER //
CREATE FUNCTION CalculateTrainingEffectiveness(result VARCHAR(50), duration_days INT, course_difficulty VARCHAR(20))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE effectiveness_score INT DEFAULT 0;
    
    -- Base score from result
    IF result = 'Passed' THEN
        SET effectiveness_score = 70;
    ELSEIF result = 'Failed' THEN
        SET effectiveness_score = 30;
    ELSE
        SET effectiveness_score = 50; -- For ongoing trainings
    END IF;
    
    -- Duration adjustment (optimal duration assumed as 14 days)
    IF duration_days BETWEEN 10 AND 20 THEN
        SET effectiveness_score = effectiveness_score + 10;
    ELSEIF duration_days > 20 THEN
        SET effectiveness_score = effectiveness_score + 5;
    ELSE
        SET effectiveness_score = effectiveness_score - 5;
    END IF;
    
    -- Course difficulty multiplier
    IF course_difficulty = 'Advanced' THEN
        SET effectiveness_score = effectiveness_score * 1.2;
    ELSEIF course_difficulty = 'Basic' THEN
        SET effectiveness_score = effectiveness_score * 0.9;
    END IF;
    
    RETURN LEAST(effectiveness_score, 100);
END //
DELIMITER ;

-- 2. Function to determine next training recommendation
DELIMITER //
CREATE FUNCTION GetNextTrainingRecommendation(course_name VARCHAR(100), result VARCHAR(50), soldier_rank VARCHAR(50))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE next_training VARCHAR(50);
    
    IF result = 'Failed' THEN
        SET next_training = CONCAT('Retake: ', course_name);
    ELSEIF course_name LIKE '%Basic%' AND soldier_rank != 'Sepoy' THEN
        SET next_training = 'Advanced Combat Training';
    ELSEIF course_name LIKE '%Rifle%' THEN
        SET next_training = 'Marksmanship Advanced';
    ELSEIF course_name LIKE '%Combat%' THEN
        SET next_training = 'Tactical Leadership';
    ELSEIF course_name LIKE '%Medical%' THEN
        SET next_training = 'Advanced Trauma Care';
    ELSE
        SET next_training = 'Specialized Skills Course';
    END IF;
    
    RETURN next_training;
END //
DELIMITER ;

-- 3. Function to check certification validity
DELIMITER //
CREATE FUNCTION CheckCertificationValidity(end_date DATE, certification_status VARCHAR(50), course_type VARCHAR(100))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE validity_status VARCHAR(20);
    DECLARE years_since_training INT;
    
    SET years_since_training = YEAR(CURDATE()) - YEAR(end_date);
    
    IF certification_status != 'Certified' THEN
        SET validity_status = 'Not Certified';
    ELSEIF course_type LIKE '%Weapon%' AND years_since_training > 2 THEN
        SET validity_status = 'Expired - Retraining Required';
    ELSEIF course_type LIKE '%Medical%' AND years_since_training > 3 THEN
        SET validity_status = 'Expired - Refresh Required';
    ELSEIF years_since_training > 5 THEN
        SET validity_status = 'Expired';
    ELSE
        SET validity_status = 'Valid';
    END IF;
    
    RETURN validity_status;
END //
DELIMITER ;

-- 4. Function to calculate training cost estimate
DELIMITER //
CREATE FUNCTION CalculateTrainingCost(course_name VARCHAR(100), duration_days INT, training_center VARCHAR(100))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE training_cost DECIMAL(10,2);
    DECLARE daily_rate DECIMAL(10,2);
    
    -- Set daily rate based on training center and course type
    IF training_center LIKE '%High Altitude%' OR training_center LIKE '%Siachen%' THEN
        SET daily_rate = 5000.00;
    ELSEIF course_name LIKE '%Advanced%' OR course_name LIKE '%Special%' THEN
        SET daily_rate = 3000.00;
    ELSEIF course_name LIKE '%Basic%' THEN
        SET daily_rate = 1500.00;
    ELSE
        SET daily_rate = 2000.00;
    END IF;
    
    SET training_cost = daily_rate * duration_days;
    
    RETURN training_cost;
END //
DELIMITER ;

-- 5. Function to get training difficulty level
DELIMITER //
CREATE FUNCTION GetTrainingDifficultyLevel(course_name VARCHAR(100), duration_days INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE difficulty_level VARCHAR(20);
    
    IF course_name LIKE '%Advanced%' OR course_name LIKE '%Special Forces%' THEN
        SET difficulty_level = 'Very High';
    ELSEIF duration_days > 30 OR course_name LIKE '%Commando%' THEN
        SET difficulty_level = 'High';
    ELSEIF duration_days > 14 OR course_name LIKE '%Combat%' THEN
        SET difficulty_level = 'Medium-High';
    ELSEIF duration_days > 7 THEN
        SET difficulty_level = 'Medium';
    ELSE
        SET difficulty_level = 'Basic';
    END IF;
    
    RETURN difficulty_level;
END //
DELIMITER ;

-- Using the UDFs for training_records
SELECT t.training_id, s.name, s.rank, t.course_name, t.duration_days, t.start_date, t.end_date, t.result, t.certification_status,
       CalculateTrainingEffectiveness(t.result, t.duration_days, 
           CASE 
               WHEN t.course_name LIKE '%Advanced%' THEN 'Advanced'
               WHEN t.course_name LIKE '%Basic%' THEN 'Basic'
               ELSE 'Intermediate'
           END
       ) as training_effectiveness,
       GetNextTrainingRecommendation(t.course_name, t.result, s.rank) as next_training_recommendation,
       CheckCertificationValidity(t.end_date, t.certification_status, t.course_name) as certification_validity,
       CalculateTrainingCost(t.course_name, t.duration_days, t.training_center) as estimated_training_cost,
       GetTrainingDifficultyLevel(t.course_name, t.duration_days) as training_difficulty
FROM training_records t
INNER JOIN soldiers s ON t.soldier_id = s.soldier_id;

-- =============================================
-- COMPREHENSIVE SCRIPT COMPLETION
-- =============================================

-- This comprehensive script now includes complete examples for all requested tables:
-- 1. logistics
-- 2. support_staff
-- 3. equipment_inventory
-- 4. training_records

-- Each table includes:
-- * 5 different JOIN query types (INNER, LEFT, RIGHT, MULTIPLE, SELF)
-- * 5 subquery variations (Single row, Multiple row, Correlated, In SELECT, EXISTS)
-- * 5 built-in function demonstrations (String, Date, Aggregate, Mathematical, Control flow)
-- * 5 practical User Defined Functions with military-specific business logic
-- * Real usage examples demonstrating UDF applications

-- The script provides a complete foundation for military database management
-- covering logistics, personnel support, equipment management, and training operations.

-- All UDFs are designed with realistic military scenarios including:
-- * Delivery urgency calculations for logistics
-- * Service completion and deployment eligibility for support staff
-- * Equipment serviceability and maintenance planning
-- * Training effectiveness and certification management

-- Ready for execution in MySQL and can be extended for specific military requirements.

