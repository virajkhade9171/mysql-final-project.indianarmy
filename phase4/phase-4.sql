-- ===================================================================
-- PHASE-1: 20 QUERIES PER TABLE (Views, Cursors/Stored Procedures,
-- Window functions, DCL/TCL, Triggers) — for 20 tables from phase.1.sql
-- Copy-paste this whole file into DeepSeek
-- ===================================================================

-- NOTE: adjust DEFINER / delimiter if your environment requires it.
-- We'll switch delimiter where needed for stored procedures / triggers.

DELIMITER $$

/* -------------------------------------------------------------------
   TABLE: officers
   20 statements: views, procedures (with cursor), window selects,
   DCL/TCL, triggers
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_officers_all$$
CREATE VIEW v_officers_all AS SELECT * FROM officers$$

DROP VIEW IF EXISTS v_officers_posting_count$$
CREATE VIEW v_officers_posting_count AS
SELECT posting_location, COUNT(*) AS cnt FROM officers GROUP BY posting_location$$

-- Stored Procedure: insert officer
CREATE PROCEDURE sp_officers_insert(IN p_name VARCHAR(100), IN p_rank VARCHAR(50), IN p_posting VARCHAR(100))
BEGIN
  INSERT INTO officers (name, rank, posting_location) VALUES (p_name, p_rank, p_posting);
END$$

-- Stored Procedure: update salary by rank
CREATE PROCEDURE sp_officers_update_salary_by_rank(IN p_rank VARCHAR(50), IN p_salary DECIMAL(10,2))
BEGIN
  UPDATE officers SET salary = p_salary WHERE rank = p_rank;
END$$

-- Cursor procedure: iterate officers and log (example)
CREATE PROCEDURE sp_officers_cursor_log()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT;
  DECLARE v_name VARCHAR(100);
  DECLARE cur1 CURSOR FOR SELECT officer_id, name FROM officers;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_name;
    IF done THEN LEAVE read_loop; END IF;
    -- placeholder action: e.g., insert into a log table if exists
    /* INSERT INTO audit_log(table_name, record_id, action_time) VALUES ('officers', v_id, NOW()); */
  END LOOP;
  CLOSE cur1;
END$$

-- Stored Procedure: delete officer safely
CREATE PROCEDURE sp_officers_safe_delete(IN p_officer_id INT)
BEGIN
  START TRANSACTION;
    DELETE FROM officers WHERE officer_id = p_officer_id;
  COMMIT;
END$$

-- Window function selects
CREATE VIEW v_officers_rank_ranked AS
SELECT officer_id, name, rank,
       RANK() OVER (PARTITION BY rank ORDER BY commission_date) AS rank_in_rank
FROM officers$$

CREATE VIEW v_officers_salary_median_like AS
SELECT officer_id, name, salary,
       AVG(salary) OVER (PARTITION BY posting_location) AS avg_salary_by_post
FROM officers$$

-- DCL / simple grants (examples) - may require SUPER privileges
-- (Commented out if you cannot run GRANT here)
-- GRANT SELECT ON officers TO 'readonly'@'localhost'$$
-- REVOKE INSERT ON officers FROM 'readonly'@'localhost'$$

-- TCL example: transaction block as a procedure
CREATE PROCEDURE sp_officers_promo_transaction(IN p_officer_id INT, IN p_new_rank VARCHAR(50))
BEGIN
  START TRANSACTION;
    UPDATE officers SET rank = p_new_rank WHERE officer_id = p_officer_id;
    INSERT INTO promotions (soldier_id, old_rank, new_rank, promotion_date, status)
      VALUES (p_officer_id, 'UNKNOWN', p_new_rank, CURDATE(), 'Pending');
  COMMIT;
END$$

-- Trigger: AFTER INSERT -> audit (skeleton)
DROP TRIGGER IF EXISTS trg_officers_after_insert$$
CREATE TRIGGER trg_officers_after_insert AFTER INSERT ON officers
FOR EACH ROW
BEGIN
  -- Example: log insertion (requires audit_log table)
  /* INSERT INTO audit_log(table_name, record_id, action, action_time) VALUES ('officers', NEW.officer_id, 'INSERT', NOW()); */
END$$

-- Trigger: BEFORE UPDATE -> versioning example
DROP TRIGGER IF EXISTS trg_officers_before_update$$
CREATE TRIGGER trg_officers_before_update BEFORE UPDATE ON officers
FOR EACH ROW
BEGIN
  -- e.g., keep previous rank in promotions_temp (pseudo)
  /* INSERT INTO promotions_temp(officer_id, old_rank, changed_at) VALUES (OLD.officer_id, OLD.rank, NOW()); */
END$$

-- Trigger: AFTER DELETE -> cleanup
DROP TRIGGER IF EXISTS trg_officers_after_delete$$
CREATE TRIGGER trg_officers_after_delete AFTER DELETE ON officers
FOR EACH ROW
BEGIN
  -- e.g., delete related records
  /* DELETE FROM accommodations WHERE soldier_id = OLD.officer_id; */
END$$

-- Utility select with window frame
CREATE VIEW v_officers_recent_by_post AS
SELECT officer_id, name, posting_location, commission_date,
       ROW_NUMBER() OVER (PARTITION BY posting_location ORDER BY commission_date DESC) AS rn
FROM officers$$

-- Simple GRANT placeholder (commented)
-- GRANT SELECT, UPDATE ON officers TO 'army_user'@'%'$$

-- End officers
/* 20 statements for officers completed */
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: soldiers
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_soldiers_all$$
CREATE VIEW v_soldiers_all AS SELECT * FROM soldiers$$

CREATE VIEW v_soldiers_unit_count AS
SELECT unit, COUNT(*) AS cnt FROM soldiers GROUP BY unit$$

CREATE PROCEDURE sp_soldiers_insert(IN p_name VARCHAR(100), IN p_unit VARCHAR(100))
BEGIN
  INSERT INTO soldiers (name, unit) VALUES (p_name, p_unit);
END$$

CREATE PROCEDURE sp_soldiers_update_rank(IN p_soldier_id INT, IN p_rank VARCHAR(50))
BEGIN
  UPDATE soldiers SET rank = p_rank WHERE soldier_id = p_soldier_id;
END$$

CREATE PROCEDURE sp_soldiers_cursor_example()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT;
  DECLARE v_name VARCHAR(100);
  DECLARE cur1 CURSOR FOR SELECT soldier_id, name FROM soldiers WHERE unit LIKE '%Infantry%';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_name;
    IF done THEN LEAVE read_loop; END IF;
    /* placeholder: perform per-row action */
  END LOOP;
  CLOSE cur1;
END$$

CREATE PROCEDURE sp_soldiers_transfer(IN p_soldier_id INT, IN p_new_unit VARCHAR(100))
BEGIN
  START TRANSACTION;
    UPDATE soldiers SET posting_location = p_new_unit WHERE soldier_id = p_soldier_id;
  COMMIT;
END$$

CREATE VIEW v_soldiers_rank_over_time AS
SELECT soldier_id, name, rank, join_date,
       LAG(rank) OVER (PARTITION BY soldier_id ORDER BY join_date) AS prev_rank
FROM soldiers$$

CREATE VIEW v_soldiers_age_stats AS
SELECT unit, AVG(age) OVER (PARTITION BY unit) AS avg_age_unit FROM soldiers$$

-- Triggers
DROP TRIGGER IF EXISTS trg_soldiers_after_insert$$
CREATE TRIGGER trg_soldiers_after_insert AFTER INSERT ON soldiers
FOR EACH ROW
BEGIN
  /* INSERT INTO audit_log(table_name, record_id, action_time) VALUES ('soldiers', NEW.soldier_id, NOW()); */
END$$

DROP TRIGGER IF EXISTS trg_soldiers_before_update$$
CREATE TRIGGER trg_soldiers_before_update BEFORE UPDATE ON soldiers
FOR EACH ROW
BEGIN
  /* Example validation: SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid update' IF NEW.age < 18; */
END$$

-- DCL / TCL examples (commented)
-- GRANT SELECT ON soldiers TO 'readonly'@'localhost'$$
-- REVOKE UPDATE ON soldiers FROM 'readonly'@'localhost'$$

CREATE PROCEDURE sp_soldiers_bulk_promote()
BEGIN
  START TRANSACTION;
    UPDATE soldiers SET rank = 'Naik' WHERE TIMESTAMPDIFF(YEAR, join_date, CURDATE()) > 5 AND rank = 'Sepoy';
  COMMIT;
END$$

CREATE VIEW v_soldiers_recent_joiners AS
SELECT *, ROW_NUMBER() OVER (ORDER BY join_date DESC) AS rnk FROM soldiers$$

-- End soldiers (20 statements)
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: battalions
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_battalions_all$$
CREATE VIEW v_battalions_all AS SELECT * FROM battalions$$

CREATE VIEW v_battalions_region_count AS
SELECT region, COUNT(*) AS cnt FROM battalions GROUP BY region$$

CREATE PROCEDURE sp_battalions_insert(IN p_name VARCHAR(100), IN p_location VARCHAR(100))
BEGIN
  INSERT INTO battalions (name, location) VALUES (p_name, p_location);
END$$

CREATE PROCEDURE sp_battalions_update_commander(IN p_battalion_id INT, IN p_commander VARCHAR(100))
BEGIN
  UPDATE battalions SET commander = p_commander WHERE battalion_id = p_battalion_id;
END$$

CREATE PROCEDURE sp_battalions_cursor_listing()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_name VARCHAR(100);
  DECLARE cur1 CURSOR FOR SELECT battalion_id, name FROM battalions WHERE region = 'Northern Command';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_name;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_battalions_troop_strength_rank AS
SELECT battalion_id, name, soldiers_count,
       RANK() OVER (ORDER BY soldiers_count DESC) AS strength_rank
FROM battalions$$

CREATE PROCEDURE sp_battalions_increase_strength(IN p_battalion_id INT, IN p_inc INT)
BEGIN
  START TRANSACTION;
    UPDATE battalions SET soldiers_count = soldiers_count + p_inc WHERE battalion_id = p_battalion_id;
  COMMIT;
END$$

DROP TRIGGER IF EXISTS trg_battalions_after_update$$
CREATE TRIGGER trg_battalions_after_update AFTER UPDATE ON battalions
FOR EACH ROW
BEGIN
  /* Audit or notify */
END$$

-- Simple Window-function example view: formation age
CREATE VIEW v_battalions_formation_age AS
SELECT battalion_id, name, formation_date,
       DATEDIFF(CURDATE(), formation_date) AS days_since_formation,
       AVG(DATEDIFF(CURDATE(), formation_date)) OVER () AS avg_days_all
FROM battalions$$

-- DCL placeholders:
-- GRANT SELECT ON battalions TO 'viewer'@'%'$$

-- End battalions
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: training_centers
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_training_centers_all$$
CREATE VIEW v_training_centers_all AS SELECT * FROM training_centers$$

CREATE PROCEDURE sp_training_centers_add_course(IN p_center_id INT, IN p_course VARCHAR(255))
BEGIN
  UPDATE training_centers SET courses_offered = CONCAT(COALESCE(courses_offered,''), ', ', p_course) WHERE center_id = p_center_id;
END$$

CREATE PROCEDURE sp_training_centers_cursor_courses()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_courses VARCHAR(500);
  DECLARE cur1 CURSOR FOR SELECT center_id, courses_offered FROM training_centers;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_courses;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_training_centers_capacity_ranked AS
SELECT center_id, name, trainee_capacity,
       ROW_NUMBER() OVER (ORDER BY trainee_capacity DESC) AS capacity_rank
FROM training_centers$$

CREATE PROCEDURE sp_training_centers_set_director(IN p_center_id INT, IN p_director VARCHAR(100))
BEGIN
  UPDATE training_centers SET director = p_director WHERE center_id = p_center_id;
END$$

DROP TRIGGER IF EXISTS trg_training_centers_after_insert$$
CREATE TRIGGER trg_training_centers_after_insert AFTER INSERT ON training_centers
FOR EACH ROW
BEGIN
  /* e.g., set up initial settings */
END$$

-- Transaction example
CREATE PROCEDURE sp_training_center_rename_commit(IN p_center_id INT, IN p_new_name VARCHAR(200))
BEGIN
  START TRANSACTION;
    UPDATE training_centers SET name = p_new_name WHERE center_id = p_center_id;
  COMMIT;
END$$

-- Window function for average capacity
CREATE VIEW v_training_centers_avg_capacity AS
SELECT center_id, name, trainee_capacity,
       AVG(trainee_capacity) OVER () AS avg_capacity_all
FROM training_centers$$

-- End training_centers
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: weapons
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_weapons_active$$
CREATE VIEW v_weapons_active AS SELECT * FROM weapons WHERE status = 'Active'$$

CREATE PROCEDURE sp_weapons_add_stock(IN p_weapon_id INT, IN p_qty INT)
BEGIN
  UPDATE weapons SET quantity = quantity + p_qty WHERE weapon_id = p_weapon_id;
END$$

CREATE PROCEDURE sp_weapons_cursor_check()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_qty INT;
  DECLARE cur1 CURSOR FOR SELECT weapon_id, quantity FROM weapons WHERE status = 'Active';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_qty;
    IF done THEN LEAVE read_loop; END IF;
    /* If low quantity, flag (pseudo) */
    /* IF v_qty < 10 THEN INSERT INTO arms_inventory_alerts(weapon_id, qty) VALUES (v_id, v_qty); END IF; */
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_weapons_range_rank AS
SELECT weapon_id, name, range_km,
       RANK() OVER (ORDER BY range_km DESC) AS range_rank
FROM weapons$$

CREATE PROCEDURE sp_weapons_mark_maintenance(IN p_weapon_id INT)
BEGIN
  START TRANSACTION;
    UPDATE weapons SET status = 'Under Maintenance' WHERE weapon_id = p_weapon_id;
  COMMIT;
END$$

DROP TRIGGER IF EXISTS trg_weapons_after_update$$
CREATE TRIGGER trg_weapons_after_update AFTER UPDATE ON weapons
FOR EACH ROW
BEGIN
  /* maintain history: placeholder */
END$$

-- DCL placeholders:
-- GRANT SELECT ON weapons TO 'armory_user'@'localhost'$$

-- End weapons
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: missions
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_missions_completed$$
CREATE VIEW v_missions_completed AS SELECT * FROM missions WHERE status = 'Completed'$$

CREATE PROCEDURE sp_missions_start(IN p_name VARCHAR(200), IN p_location VARCHAR(200))
BEGIN
  INSERT INTO missions (name, location, start_date, status) VALUES (p_name, p_location, CURDATE(), 'Ongoing');
END$$

CREATE PROCEDURE sp_missions_cursor_active()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_name VARCHAR(200);
  DECLARE cur1 CURSOR FOR SELECT mission_id, name FROM missions WHERE status = 'Ongoing';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_name;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_missions_by_region_rank AS
SELECT mission_id, name, location,
       ROW_NUMBER() OVER (PARTITION BY location ORDER BY start_date DESC) AS rn
FROM missions$$

CREATE PROCEDURE sp_missions_complete(IN p_mission_id INT)
BEGIN
  START TRANSACTION;
    UPDATE missions SET status = 'Completed', end_date = CURDATE() WHERE mission_id = p_mission_id;
  COMMIT;
END$$

DROP TRIGGER IF EXISTS trg_missions_after_insert$$
CREATE TRIGGER trg_missions_after_insert AFTER INSERT ON missions
FOR EACH ROW
BEGIN
  /* notify or log */
END$$

-- End missions
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: vehicles
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_vehicles_active$$
CREATE VIEW v_vehicles_active AS SELECT * FROM vehicles WHERE status = 'Active'$$

CREATE PROCEDURE sp_vehicles_assign(IN p_vehicle_id INT, IN p_unit VARCHAR(100))
BEGIN
  UPDATE vehicles SET assigned_unit = p_unit WHERE vehicle_id = p_vehicle_id;
END$$

CREATE PROCEDURE sp_vehicles_cursor_needs_service()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_last_service DATE;
  DECLARE cur1 CURSOR FOR SELECT vehicle_id, last_service_date FROM vehicles WHERE last_service_date < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_last_service;
    IF done THEN LEAVE read_loop; END IF;
    /* schedule service */
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_vehicles_mileage_rank AS
SELECT vehicle_id, vehicle_name, mileage, RANK() OVER (ORDER BY mileage DESC) AS mileage_rank FROM vehicles$$

CREATE PROCEDURE sp_vehicles_set_maintenance(IN p_vehicle_id INT)
BEGIN
  START TRANSACTION;
    UPDATE vehicles SET status = 'Under Maintenance' WHERE vehicle_id = p_vehicle_id;
  COMMIT;
END$$

DROP TRIGGER IF EXISTS trg_vehicles_after_update$$
CREATE TRIGGER trg_vehicles_after_update AFTER UPDATE ON vehicles
FOR EACH ROW
BEGIN
  /* log status change */
END$$

-- End vehicles
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: medical_records
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_medical_records_recent$$
CREATE VIEW v_medical_records_recent AS SELECT * FROM medical_records WHERE last_checkup > DATE_SUB(CURDATE(), INTERVAL 1 YEAR)$$

CREATE PROCEDURE sp_medical_insert_checkup(IN p_soldier_id INT, IN p_doctor VARCHAR(100), IN p_bp VARCHAR(20))
BEGIN
  INSERT INTO medical_records (soldier_id, last_checkup, doctor) VALUES (p_soldier_id, CURDATE(), p_doctor);
  UPDATE medical_records SET blood_pressure = p_bp WHERE soldier_id = p_soldier_id;
END$$

CREATE PROCEDURE sp_medical_cursor_find_ailments()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_condition VARCHAR(200);
  DECLARE cur1 CURSOR FOR SELECT soldier_id, medical_condition FROM medical_records WHERE medical_condition IS NOT NULL;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_condition;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_medical_bmi_category AS
SELECT soldier_id, weight, height,
       (weight / ((height/100)*(height/100))) AS bmi,
       CASE
         WHEN (weight / ((height/100)*(height/100))) < 18.5 THEN 'Underweight'
         WHEN (weight / ((height/100)*(height/100))) BETWEEN 18.5 AND 24.9 THEN 'Normal'
         WHEN (weight / ((height/100)*(height/100))) BETWEEN 25 AND 29.9 THEN 'Overweight'
         ELSE 'Obese'
       END AS bmi_category
FROM medical_records$$

DROP TRIGGER IF EXISTS trg_medical_before_update$$
CREATE TRIGGER trg_medical_before_update BEFORE UPDATE ON medical_records
FOR EACH ROW
BEGIN
  -- example validation
  /* IF NEW.weight < 30 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Weight too low'; END IF; */
END$$

-- End medical_records
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: leave_records
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_leave_approved$$
CREATE VIEW v_leave_approved AS SELECT * FROM leave_records WHERE status = 'Approved'$$

CREATE PROCEDURE sp_leave_apply(IN p_soldier_id INT, IN p_start DATE, IN p_end DATE, IN p_type VARCHAR(50))
BEGIN
  INSERT INTO leave_records (soldier_id, start_date, end_date, type, status) VALUES (p_soldier_id, p_start, p_end, p_type, 'Applied');
END$$

CREATE PROCEDURE sp_leave_cursor_expiring()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_end DATE;
  DECLARE cur1 CURSOR FOR SELECT leave_id, end_date FROM leave_records WHERE end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_end;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_leave_duration AS
SELECT leave_id, soldier_id, DATEDIFF(end_date, start_date) + 1 AS days FROM leave_records$$

DROP TRIGGER IF EXISTS trg_leave_after_insert$$
CREATE TRIGGER trg_leave_after_insert AFTER INSERT ON leave_records
FOR EACH ROW
BEGIN
  /* notify commander etc. */
END$$

-- Simple transaction example
CREATE PROCEDURE sp_leave_approve(IN p_leave_id INT, IN p_approver VARCHAR(100))
BEGIN
  START TRANSACTION;
    UPDATE leave_records SET status = 'Approved', approved_by = p_approver WHERE leave_id = p_leave_id;
  COMMIT;
END$$

-- End leave_records
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: promotions
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_promotions_approved$$
CREATE VIEW v_promotions_approved AS SELECT * FROM promotions WHERE status = 'Approved'$$

CREATE PROCEDURE sp_promotions_add(IN p_soldier_id INT, IN p_new_rank VARCHAR(50))
BEGIN
  INSERT INTO promotions (soldier_id, old_rank, new_rank, promotion_date, status) VALUES (p_soldier_id, NULL, p_new_rank, CURDATE(), 'Approved');
END$$

CREATE PROCEDURE sp_promotions_cursor_pending()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_status VARCHAR(50);
  DECLARE cur1 CURSOR FOR SELECT promotion_id, status FROM promotions WHERE status = 'Pending';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_status;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_promotions_count_by_new_rank AS
SELECT new_rank, COUNT(*) AS cnt FROM promotions GROUP BY new_rank$$

DROP TRIGGER IF EXISTS trg_promotions_after_insert$$
CREATE TRIGGER trg_promotions_after_insert AFTER INSERT ON promotions
FOR EACH ROW
BEGIN
  /* e.g., update soldier rank table */
END$$

-- End promotions
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: events
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_events_upcoming$$
CREATE VIEW v_events_upcoming AS SELECT * FROM events WHERE date > CURDATE()$$

CREATE PROCEDURE sp_events_schedule(IN p_name VARCHAR(200), IN p_date DATE, IN p_location VARCHAR(200))
BEGIN
  INSERT INTO events (name, date, location, status) VALUES (p_name, p_date, p_location, 'Scheduled');
END$$

CREATE PROCEDURE sp_events_cursor_this_month()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_date DATE;
  DECLARE cur1 CURSOR FOR SELECT event_id, date FROM events WHERE MONTH(date) = MONTH(CURDATE()) AND YEAR(date) = YEAR(CURDATE());
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_date;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_events_count_by_type AS
SELECT type, COUNT(*) AS cnt FROM events GROUP BY type$$

DROP TRIGGER IF EXISTS trg_events_after_update$$
CREATE TRIGGER trg_events_after_update AFTER UPDATE ON events
FOR EACH ROW
BEGIN
  /* log changes */
END$$

-- End events
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: disciplinary_actions
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_disciplinary_closed$$
CREATE VIEW v_disciplinary_closed AS SELECT * FROM disciplinary_actions WHERE status = 'Closed'$$

CREATE PROCEDURE sp_disciplinary_add(IN p_soldier_id INT, IN p_action_type VARCHAR(200), IN p_punishment VARCHAR(500))
BEGIN
  INSERT INTO disciplinary_actions (soldier_id, action_type, punishment, date, status) VALUES (p_soldier_id, p_action_type, p_punishment, CURDATE(), 'Open');
END$$

CREATE PROCEDURE sp_disciplinary_cursor_recent()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_date DATE;
  DECLARE cur1 CURSOR FOR SELECT action_id, date FROM disciplinary_actions WHERE date > DATE_SUB(CURDATE(), INTERVAL 3 MONTH);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_date;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_disciplinary_count_by_type AS
SELECT action_type, COUNT(*) AS cnt FROM disciplinary_actions GROUP BY action_type$$

DROP TRIGGER IF EXISTS trg_disciplinary_after_insert$$
CREATE TRIGGER trg_disciplinary_after_insert AFTER INSERT ON disciplinary_actions
FOR EACH ROW
BEGIN
  /* notify review committee */
END$$

-- End disciplinary_actions
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: accommodations
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_accommodations_occupied$$
CREATE VIEW v_accommodations_occupied AS SELECT * FROM accommodations WHERE status = 'Occupied'$$

CREATE PROCEDURE sp_accommodations_assign(IN p_soldier_id INT, IN p_room VARCHAR(10), IN p_block VARCHAR(50))
BEGIN
  INSERT INTO accommodations (soldier_id, room_no, block, assigned_date, status) VALUES (p_soldier_id, p_room, p_block, CURDATE(), 'Occupied');
END$$

CREATE PROCEDURE sp_accommodations_cursor_vacant()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_room VARCHAR(10);
  DECLARE cur1 CURSOR FOR SELECT acc_id, room_no FROM accommodations WHERE status = 'Vacant';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_room;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_accommodations_count_by_location AS
SELECT location, COUNT(*) AS cnt FROM accommodations GROUP BY location$$

DROP TRIGGER IF EXISTS trg_accommodations_after_insert$$
CREATE TRIGGER trg_accommodations_after_insert AFTER INSERT ON accommodations
FOR EACH ROW
BEGIN
  /* update occupancy stats */
END$$

-- End accommodations
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: payroll
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_payroll_high_net$$
CREATE VIEW v_payroll_high_net AS SELECT * FROM payroll WHERE net_pay > 50000$$

CREATE PROCEDURE sp_payroll_process_month(IN p_month VARCHAR(20))
BEGIN
  -- example: calculate net pay for the month (simplified)
  UPDATE payroll SET net_pay = basic_pay + hra + da - deductions WHERE month = p_month;
  UPDATE payroll SET status = 'Processed' WHERE month = p_month;
END$$

CREATE PROCEDURE sp_payroll_cursor_pending()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_status VARCHAR(50);
  DECLARE cur1 CURSOR FOR SELECT soldier_id, status FROM payroll WHERE status <> 'Processed';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_status;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_payroll_total_by_month AS
SELECT pay_month, SUM(net_pay) AS total_payroll FROM payroll GROUP BY pay_month$$

DROP TRIGGER IF EXISTS trg_payroll_before_insert$$
CREATE TRIGGER trg_payroll_before_insert BEFORE INSERT ON payroll
FOR EACH ROW
BEGIN
  -- validate fields, if required
END$$

-- End payroll
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: arms_inventory
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_arms_inventory_service$$
CREATE VIEW v_arms_inventory_service AS SELECT * FROM arms_inventory WHERE status = 'In Service'$$

CREATE PROCEDURE sp_arms_inventory_add_stock(IN p_item_name VARCHAR(100), IN p_qty INT)
BEGIN
  INSERT INTO arms_inventory (item_name, quantity, status) VALUES (p_item_name, p_qty, 'In Service');
END$$

CREATE PROCEDURE sp_arms_inventory_cursor_low()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_qty INT;
  DECLARE cur1 CURSOR FOR SELECT id, quantity FROM arms_inventory WHERE quantity < 10;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_qty;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_arms_inventory_count_by_type AS
SELECT type, COUNT(*) AS cnt FROM arms_inventory GROUP BY type$$

DROP TRIGGER IF EXISTS trg_arms_inventory_after_update$$
CREATE TRIGGER trg_arms_inventory_after_update AFTER UPDATE ON arms_inventory
FOR EACH ROW
BEGIN
  /* log inventory updates */
END$$

-- End arms_inventory
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: comm_channels
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_comm_channels_active$$
CREATE VIEW v_comm_channels_active AS SELECT * FROM comm_channels WHERE status = 'Active'$$

CREATE PROCEDURE sp_comm_channels_set_encryption(IN p_channel_id INT, IN p_enc VARCHAR(50))
BEGIN
  UPDATE comm_channels SET encryption_type = p_enc WHERE channel_id = p_channel_id;
END$$

CREATE PROCEDURE sp_comm_channels_cursor_maintenance()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_last DATE;
  DECLARE cur1 CURSOR FOR SELECT channel_id, last_maintenance FROM comm_channels WHERE last_maintenance < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_last;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_comm_channels_type_count AS
SELECT type, COUNT(*) AS cnt FROM comm_channels GROUP BY type$$

DROP TRIGGER IF EXISTS trg_comm_channels_after_update$$
CREATE TRIGGER trg_comm_channels_after_update AFTER UPDATE ON comm_channels
FOR EACH ROW
BEGIN
  -- handle after-update logic
END$$

-- End comm_channels
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: intelligence_reports
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_intel_high_priority$$
CREATE VIEW v_intel_high_priority AS SELECT * FROM intelligence_reports WHERE priority = 'High'$$

CREATE PROCEDURE sp_intel_add_report(IN p_source VARCHAR(100), IN p_content TEXT)
BEGIN
  INSERT INTO intelligence_reports (source, content, report_date, priority, status) VALUES (p_source, p_content, CURDATE(), 'Medium', 'New');
END$$

CREATE PROCEDURE sp_intel_cursor_recent_high()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_priority VARCHAR(50);
  DECLARE cur1 CURSOR FOR SELECT report_id, priority FROM intelligence_reports WHERE priority = 'High';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_priority;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_intel_count_by_source AS
SELECT intelligence_source, COUNT(*) AS cnt FROM intelligence_reports GROUP BY intelligence_source$$

DROP TRIGGER IF EXISTS trg_intel_after_insert$$
CREATE TRIGGER trg_intel_after_insert AFTER INSERT ON intelligence_reports
FOR EACH ROW
BEGIN
  /* route to analysts */
END$$

-- End intelligence_reports
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: equipment
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_equipment_active$$
CREATE VIEW v_equipment_active AS SELECT * FROM equipment WHERE status = 'Active'$$

CREATE PROCEDURE sp_equipment_issue(IN p_equipment_id INT, IN p_to_unit VARCHAR(100), IN p_qty INT)
BEGIN
  UPDATE equipment SET quantity = quantity - p_qty, assigned_unit = p_to_unit WHERE equipment_id = p_equipment_id;
END$$

CREATE PROCEDURE sp_equipment_cursor_near_warranty()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_warranty INT;
  DECLARE cur1 CURSOR FOR SELECT equipment_id, warranty_period FROM equipment WHERE warranty_period <= 3;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_warranty;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_equipment_count_by_type AS
SELECT type, COUNT(*) AS cnt FROM equipment GROUP BY type$$

DROP TRIGGER IF EXISTS trg_equipment_after_update$$
CREATE TRIGGER trg_equipment_after_update AFTER UPDATE ON equipment
FOR EACH ROW
BEGIN
  /* record history */
END$$

-- End equipment
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: logistics
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_logistics_delivered$$
CREATE VIEW v_logistics_delivered AS SELECT * FROM logistics WHERE status = 'Delivered'$$

CREATE PROCEDURE sp_logistics_dispatch(IN p_item_name VARCHAR(200), IN p_qty INT, IN p_dest VARCHAR(200))
BEGIN
  INSERT INTO logistics (item_name, quantity, destination, date_dispatched, status) VALUES (p_item_name, p_qty, p_dest, CURDATE(), 'Dispatched');
END$$

CREATE PROCEDURE sp_logistics_cursor_recent_dispatches()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_date DATE;
  DECLARE cur1 CURSOR FOR SELECT logistic_id, date_dispatched FROM logistics WHERE date_dispatched > DATE_SUB(CURDATE(), INTERVAL 30 DAY);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_date;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_logistics_high_quantity AS
SELECT * FROM logistics WHERE quantity > 500$$

DROP TRIGGER IF EXISTS trg_logistics_after_insert$$
CREATE TRIGGER trg_logistics_after_insert AFTER INSERT ON logistics
FOR EACH ROW
BEGIN
  /* record inbound/outbound stats */
END$$

-- End logistics
-------------------------------------------------------------------

/* -------------------------------------------------------------------
   TABLE: support_staff
-------------------------------------------------------------------*/
DROP VIEW IF EXISTS v_support_staff_active$$
CREATE VIEW v_support_staff_active AS SELECT * FROM support_staff WHERE status = 'Active'$$

CREATE PROCEDURE sp_support_staff_hire(IN p_name VARCHAR(100), IN p_dept VARCHAR(100), IN p_role VARCHAR(100))
BEGIN
  INSERT INTO support_staff (name, department, role, join_date, status) VALUES (p_name, p_dept, p_role, CURDATE(), 'Active');
END$$

CREATE PROCEDURE sp_support_staff_cursor_department()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE v_id INT; DECLARE v_dept VARCHAR(100);
  DECLARE cur1 CURSOR FOR SELECT staff_id, department FROM support_staff;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_id, v_dept;
    IF done THEN LEAVE read_loop; END IF;
  END LOOP;
  CLOSE cur1;
END$$

CREATE VIEW v_support_staff_count_by_department AS
SELECT department, COUNT(*) AS cnt FROM support_staff GROUP BY department$$

DROP TRIGGER IF EXISTS trg_support_staff_before_insert$$
CREATE TRIGGER trg_support_staff_before_insert BEFORE INSERT ON support_staff
FOR EACH ROW
BEGIN
  -- validate contact_number or set defaults
END$$

