-- parsing
CREATE TABLE IF NOT EXISTS dots (x int, y int, CONSTRAINT UNIQUE (x, y));
LOAD DATA LOCAL INFILE 'input.txt' into table dots fields terminated by ',' (x,y);
DELETE FROM dots WHERE y IS NULL;
CREATE TABLE IF NOT EXISTS folds (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, dir CHAR(1), centre int);
LOAD DATA LOCAL INFILE 'input.txt' into table folds fields terminated by '=' LINES starting by 'fold along ' (dir, centre);

DELIMITER //
CREATE PROCEDURE IF NOT EXISTS main()
BEGIN
	DECLARE lastx INT;
	DECLARE l CHAR(64);

	-- folding (not at home)
	WHILE (SELECT COUNT(*) FROM folds) > 0 DO
		SELECT id,dir,centre INTO @i,@d,@c FROM folds WHERE id = (SELECT min(id) FROM folds);
		DELETE FROM folds ORDER BY id LIMIT 1;
		IF @d = 'x' THEN
			UPDATE IGNORE dots SET x = 2 * @c - x WHERE x > @c;
			DELETE FROM dots WHERE x > @c;
		ELSE
			UPDATE IGNORE dots SET y = 2 * @c - y WHERE y > @c;
			DELETE FROM dots WHERE y > @c;
		END IF;
		IF @i = 1 THEN
			SELECT 'Part 1' as '';
			SELECT COUNT(*) FROM dots;
		END IF;
	END WHILE;

	-- serialize the code
	CREATE TABLE IF NOT EXISTS code (y int NOT NULL PRIMARY KEY, line CHAR(64));
	WHILE (SELECT COUNT(*) from dots) > 0 DO
		SET lastx = 0;
		SET l = '';
		SELECT y INTO @y FROM dots WHERE y = (SELECT min(y) FROM dots) LIMIT 1;
		WHILE (SELECT COUNT(*) FROM dots WHERE y = @y) > 0 DO
			SELECT x INTO @x FROM dots WHERE y = @y ORDER BY x ASC LIMIT 1;
			DELETE FROM dots WHERE (x = @x) AND (y = @y);
			WHILE lastx < @x - 1 DO
				SET l = (SELECT CONCAT(l, '_'));
				SET lastx = lastx + 1;
			END WHILE;
			SET l = (SELECT CONCAT(l, '@'));
			SET lastx = @x;
		END WHILE;
		INSERT INTO code(y, line) VALUES(@y, REPLACE(l, '_', ' '));
	END WHILE;
	SELECT 'Part 2' as '';
	SELECT * FROM code;
END;
//
DELIMITER ;

CALL main();
