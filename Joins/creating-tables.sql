-- Create the 'cities' table
CREATE TABLE cities (
  name VARCHAR PRIMARY KEY,
  country_code VARCHAR,
  city_proper_pop         REAL,
  metroarea_pop           REAL,
  urbanarea_pop           REAL
);

-- Create the 'countries' table
CREATE TABLE countries (
  code                  VARCHAR     PRIMARY KEY,
  name                  VARCHAR,
  continent             VARCHAR,
  region                VARCHAR,
  surface_area          REAL,
  indep_year            INTEGER,
  local_name            VARCHAR,
  gov_form              VARCHAR,
  capital               VARCHAR,
  cap_long              REAL,
  cap_lat               REAL
);

-- Create the 'languages' table
CREATE TABLE languages (
  lang_id               SERIAL     PRIMARY KEY,
  code                  VARCHAR,
  name                  VARCHAR,
  percent               REAL,
  official              BOOLEAN
);

-- Create the 'economies' table
CREATE TABLE economies (
  econ_id               SERIAL     PRIMARY KEY,
  code                  VARCHAR,
  year                  INTEGER,
  income_group          VARCHAR,
  gdp_percapita         REAL,
  gross_savings         REAL,
  inflation_rate        REAL,
  total_investment      REAL,
  unemployment_rate     REAL,
  exports               REAL,
  imports               REAL
);

-- Create the 'currencies' table
CREATE TABLE currencies (
  curr_id               SERIAL     PRIMARY KEY,
  code                  VARCHAR,
  basic_unit            VARCHAR,
  curr_code             VARCHAR,
  frac_unit             VARCHAR,
  frac_perbasic         REAL
);

-- Create the 'populations' table
CREATE TABLE populations (
  pop_id                SERIAL     PRIMARY KEY,
  country_code          VARCHAR,
  year                  INTEGER,
  fertility_rate        REAL,
  life_expectancy       REAL,
  size                  REAL
);

-- Create the 'economies2015' table
CREATE TABLE economies2015 (
  code                  VARCHAR     PRIMARY KEY,
  year                  INTEGER,
  income_group          VARCHAR,
  gross_savings         REAL
);

-- Create the 'economies2019' table
CREATE TABLE economies2019 (
  code                  VARCHAR     PRIMARY KEY,
  year                  INTEGER,
  income_group          VARCHAR,
  gross_savings         REAL
);

-- Create the 'countries_plus' table
CREATE TABLE eu_countries (
  code                  VARCHAR     PRIMARY KEY,
  name                  VARCHAR
);
-- Run this script in psql
-- Connect to the database
\c your_database_name

-- Create the 'states' table without primary key and foreign key
CREATE TABLE states (
    country VARCHAR,
    continent VARCHAR,
    indep_year INTEGER
);

-- Create the 'presidents' table without primary key and foreign key
CREATE TABLE presidents (
    country VARCHAR,
    continent VARCHAR,
    president VARCHAR
);

-- Create the 'prime_ministers' table without primary key and foreign key
CREATE TABLE prime_ministers (
    country VARCHAR,
    continent VARCHAR,
    prime_minister VARCHAR
);

-- Create the 'prime_minister_terms' table without primary key and foreign key
CREATE TABLE prime_minister_terms (
    prime_minister VARCHAR,
    pm_start INTEGER
);

-- Create the 'monarchs' table without primary key and foreign key
CREATE TABLE monarchs (
    country VARCHAR,
    continent VARCHAR,
    monarch VARCHAR
);

-- Copy data from CSV files into the tables using \copy command
\copy states (country, continent, indep_year) FROM '/Users/piusmutuma/Downloads/leaders/states.csv' DELIMITER ',' CSV HEADER;

\copy presidents (country, continent, president) FROM '/Users/piusmutuma/Downloads/leaders/presidents.csv' DELIMITER ',' CSV HEADER;

\copy prime_ministers (country, continent, prime_minister) FROM '/Users/piusmutuma/Downloads/leaders/prime_ministers.csv' DELIMITER ',' CSV HEADER;

\copy prime_minister_terms (prime_minister, pm_start) FROM '/Users/piusmutuma/Downloads/leaders/prime_minister_terms.csv' DELIMITER ',' CSV HEADER;

\copy monarchs (country, continent, monarch) FROM '/Users/piusmutuma/Downloads/leaders/monarchs.csv' DELIMITER ',' CSV HEADER;
