CREATE TABLE imdb_scores (
    id SERIAL PRIMARY KEY,
	netflix_id VARCHAR(50),
    title VARCHAR(255),
    movie_type VARCHAR(50),
    description TEXT,
    release_year INTEGER,
    age_certification VARCHAR(10),
    runtime INTEGER,
    imdb_id VARCHAR(50),
    imdb_score NUMERIC(5,2),
    imdb_votes INTEGER,
    netflix BOOLEAN
);


COPY imdb_scores(netflix_id, title, movie_type, description,
				 release_year, age_certification, runtime,
				 imdb_id, imdb_score, imdb_votes, netflix) 
FROM 'D:\KPI\AD\KR_Data\films_imdb_scores.csv' 
DELIMITER ',' CSV HEADER;

CREATE TABLE movies_by_country (
    id SERIAL PRIMARY KEY,
	netflix_id VARCHAR(50),
    title VARCHAR(255),
    movie_type VARCHAR(50),
    description TEXT,
    release_year INTEGER,
    age_certification VARCHAR(10),
    runtime INTEGER,
    genres VARCHAR(255),
    production_countries VARCHAR(255),
    seasons INTEGER,
    imdb_id VARCHAR(20),
    imdb_score NUMERIC(5,2),
    imdb_votes INTEGER,
    tmdb_popularity NUMERIC(10,2),
    tmdb_score NUMERIC(5,2),
    netflix BOOLEAN
);

COPY movies_by_country(netflix_id, title, movie_type, description, 
					   release_year, age_certification, runtime, 
					   genres, production_countries, seasons, 
					   imdb_id, imdb_score, imdb_votes, 
					   tmdb_popularity, tmdb_score, netflix) 
FROM 'D:\KPI\AD\KR_Data\titles.csv' 
DELIMITER ',' CSV HEADER


CREATE TABLE people (
	id SERIAL PRIMARY KEY,
    person_id VARCHAR(50),
    netflix_id VARCHAR(50),
    full_name VARCHAR(255),
    role VARCHAR(255)
);

COPY people(person_id, netflix_id, full_name, role) 
FROM 'D:\KPI\AD\KR_Data\credits.csv' 
WITH (FORMAT CSV, HEADER);


CREATE TABLE movie_financials (
    id SERIAL PRIMARY KEY,
    movie_title VARCHAR(255),
    production_budget BIGINT,
    domestic_gross BIGINT,
    worldwide_gross BIGINT
);

COPY movie_financials(movie_title, production_budget, domestic_gross, worldwide_gross) 
FROM 'D:\KPI\AD\KR_Data\budget.csv' 
WITH (FORMAT CSV, HEADER);

CREATE TABLE streaming_platforms (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    year INTEGER,
    age_certification VARCHAR(50),
    rotten_tomatoes_score FLOAT,
    netflix INTEGER,
    hulu INTEGER,
    prime_video INTEGER,
    disney_plus INTEGER
);

ALTER TABLE streaming_platforms
ALTER COLUMN netflix TYPE BOOLEAN
USING CASE WHEN netflix = 1 THEN TRUE ELSE FALSE END;

ALTER TABLE streaming_platforms
ALTER COLUMN hulu TYPE BOOLEAN
USING CASE WHEN hulu = 1 THEN TRUE ELSE FALSE END;

ALTER TABLE streaming_platforms
ALTER COLUMN prime_video TYPE BOOLEAN
USING CASE WHEN prime_video = 1 THEN TRUE ELSE FALSE END;

ALTER TABLE streaming_platforms
ALTER COLUMN disney_plus TYPE BOOLEAN
USING CASE WHEN disney_plus = 1 THEN TRUE ELSE FALSE END;

COPY streaming_platforms(title, year, age_certification, rotten_tomatoes_score, netflix, hulu, prime_video, disney_plus)
FROM 'D:\KPI\AD\KR_Data\streaming_platforms.csv' 
WITH (FORMAT CSV, HEADER);
