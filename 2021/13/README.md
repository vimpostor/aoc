# MySQL (MariaDB)

First install a MySQL compatible database, I recommend the opensource [MariaDB](https://mariadb.org/) implementation.
Then create a database for AoC so that you don't disrupt any production deployments with my cursed Advent of Code SQL query, and finally run it as follows:

```bash
mysql -e 'CREATE DATABASE IF NOT EXISTS aoc; CREATE USER IF NOT EXISTS aoc@localhost; GRANT ALL PRIVILEGES ON aoc.* TO aoc@localhost' # Create database
mysql aoc < main.sql # Run query
mysql -e 'DROP DATABASE aoc; DROP USER aoc@localhost' # Cleanup
```
