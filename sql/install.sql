
SET client_min_messages = WARNING;

/* create a user to perform the migration */
DROP ROLE IF EXISTS migrator;

CREATE ROLE migrator LOGIN;

/* triggers shouldn't run during replication */
ALTER ROLE migrator SET session_replication_role = replica;

/* create all requisite extensions */
CREATE EXTENSION oracle_fdw;
CREATE EXTENSION db_migrator;
CREATE EXTENSION ora_migrator;

/* create a foreign server and a user mapping */
CREATE SERVER oracle FOREIGN DATA WRAPPER oracle_fdw
   OPTIONS (dbserver '');

CREATE USER MAPPING FOR PUBLIC SERVER oracle
   OPTIONS (user 'testschema1', password 'good_password');

/* give the user the required permissions */
GRANT CREATE ON DATABASE contrib_regression TO migrator;

GRANT USAGE ON FOREIGN SERVER oracle TO migrator;
