-- fast delete a lot of old history data whith restore disk space
-- intervals in days
SET @history_interval = 7;
SET @trends_interval = 90;

DELETE FROM alerts WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
DELETE FROM acknowledges WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);
DELETE FROM events WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@history_interval * 24 * 60 * 60);

ALTER TABLE history RENAME TO history_backup;
CREATE TABLE history LIKE history_backup;
INSERT INTO history SELECT * FROM history_backup WHERE clock > UNIX_TIMESTAMP(NOW() - INTERVAL @history_interval DAY);
ALTER TABLE history_log RENAME TO history_log_backup;
CREATE TABLE history_log LIKE history_log_backup;
INSERT INTO history_log SELECT * FROM history_log_backup WHERE clock > UNIX_TIMESTAMP(NOW() - INTERVAL @history_interval DAY);
ALTER TABLE history_str RENAME TO history_str_backup;
CREATE TABLE history_str LIKE history_str_backup;
INSERT INTO history_str SELECT * FROM history_str_backup WHERE clock > UNIX_TIMESTAMP(NOW() - INTERVAL @history_interval DAY);
ALTER TABLE history_text RENAME TO history_text_backup;
CREATE TABLE history_text LIKE history_text_backup;
INSERT INTO history_text SELECT * FROM history_text_backup WHERE clock > UNIX_TIMESTAMP(NOW() - INTERVAL @history_interval DAY);
ALTER TABLE history_uint RENAME TO history_uint_backup;
CREATE TABLE history_uint LIKE history_uint_backup;
INSERT INTO history_uint SELECT * FROM history_uint_backup WHERE clock > UNIX_TIMESTAMP(NOW() - INTERVAL @history_interval DAY);

-- delete old data
DROP TABLE history_backup;
DROP TABLE history_log_backup;
DROP TABLE history_str_backup;
DROP TABLE history_text_backup;
DROP TABLE history_uint_backup;


DELETE FROM trends WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@trends_interval * 24 * 60 * 60);
DELETE FROM trends_uint WHERE (UNIX_TIMESTAMP(NOW()) - clock) > (@trends_interval * 24 * 60 * 60);
