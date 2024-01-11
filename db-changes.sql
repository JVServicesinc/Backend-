
CREATE TABLE jv_provider_slots(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    provider_id BIGINT UNSIGNED DEFAULT NULL,
    weeekday TINYINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY(id)
);

CREATE TABLE jv_provider_slot_items(
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    slot_id BIGINT UNSIGNED DEFAULT NULL,
   	slot_time TIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY(id),
    CONSTRAINT uniq_slot_time UNIQUE(slot_id,slot_time),
    CONSTRAINT fk_slot_id_jv_provider_slot_items FOREIGN KEY(slot_id) REFERENCES jv_provider_slots(id)
    	ON DELETE CASCADE
    	ON UPDATE NO ACTION
);

ALTER TABLE jv_provider_slots
ADD CONSTRAINT fk_provider_id FOREIGN KEY(provider_id) REFERENCES users(id)
	ON DELETE CASCADE
    ON UPDATE NO ACTION;


DELIMITER //
CREATE TRIGGER set_provider_weekdays AFTER INSERT ON users FOR EACH ROW
BEGIN
  IF NEW.role_id = 4 THEN
  	INSERT INTO jv_provider_slots ( provider_id, weeekday ) 
    	VALUES 
        	(NEW.id, 1),
            (NEW.id, 2),
			(NEW.id, 3),
			(NEW.id, 4),
			(NEW.id, 5),
			(NEW.id, 6),
			(NEW.id, 7);
  END IF;
END //
DELIMITER ;