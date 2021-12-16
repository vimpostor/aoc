-- MySQL is absolutely cursed, seriously don't try this at home, this was a pain to write.
-- Here are some of the highlights:
-- WTF MYSQL WHEN I CREATE A PROCEDURE I HAVE TO USE ANOTHER DELIMITER THAN ; BECAUSE MYSQL WOULD TERMINATE THE ENTIRE PROCEDURE ON THE FIRST ;
-- This is why I change the delimiter to // before the procedure begins, then I can use ; inside the procedure. After the procedure I have to change the delimiter back to ; 🦀🦀🦀
-- You can't declare MySQL variables outside of a procedure, which is why I had to use a procedure in the first place
-- You can declare local variables only at the start of the procedure, every other place threw syntax errors on me
-- Oh right, syntax errors, I almost forgot about that painful part. MYSQL DOESN'T EVEN TELL YOU WHAT THE SYNTAX ERROR IS, "You have AN eRrOr In youR SQL SyNtAx; ChECK THE MaNuAl thAT CORreSPONdS to yoUR mARiAdb Server vErsioN FOR tHE RIght synTaX TO usE", are you fucking serious???
-- But hey, at least MySQL tells you the line where the syntax error is, right? Wrong! Sometimes (especially when working inside procedures), the given line number is completely wrong.
-- I once literally had to do binary search for my syntax error linenumber, by commenting out half of my code.
-- The whole serializing the (x,y) array to an ASCII art string was pain.
-- I was unable to get MariaDB to print out \n as linebreaks, so instead I wrote each line of the string into a separate row of a table and printed out the table in table form, which will print a linebreak on its own for each row.

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
