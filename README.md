## Author
Kulikov Bogdan, BSE 204

## Description
This is the solution to the 7th homework.
It contains `docker-compose` file, that launches database, runs migrations over it and then seeds the database with dummy data.
I'm using `pgmigrate` tool to run migrations. It allows for versioning and simplifies the migration process.

For seeding I wrote a small script, that uses `peewee` ORM library for python.
It gives a lot of agility, but keeps things simple.

**NOTE**: when seeder is run, it truncates previous data to avoid collisions.

Additional comments describe my decisions with the chosen stack.


SQL requests (2 part of the homework) are in `sql.pdf` file.
