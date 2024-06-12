create table movie_dim(
	id SERIAL PRIMARY KEY,
	title VARCHAR(50)
);

ALTER TABLE movie_dim
ALTER COLUMN title TYPE VARCHAR(255);


create table type_dim(
	id SERIAL PRIMARY KEY,
	type VARCHAR(50)
);


create table year_dim(
	id SERIAL PRIMARY KEY,
	year int
);


create table certification_dim(
	id SERIAL PRIMARY KEY,
	cert VARCHAR(50)
);


create table age_restrictions_dim(
	id SERIAL PRIMARY KEY,
	age VARCHAR(50)
);


create table genre_dim(
	id SERIAL PRIMARY KEY,
	genre VARCHAR(50)
);


create table country_dim(
	id SERIAL PRIMARY KEY,
	country VARCHAR(50)
);


create table seasons_dim(
	id SERIAL PRIMARY KEY,
	seasons int
);


create table hulu_dim(
	id SERIAL PRIMARY KEY,
	released BOOLEAN
);


create table prime_video_dim(
	id SERIAL PRIMARY KEY,
	released BOOLEAN
);


create table disney_plus_dim(
	id SERIAL PRIMARY KEY,
	released BOOLEAN
);


create table netflix_dim(
	id SERIAL PRIMARY KEY,
	released BOOLEAN
);


create table person_dim(
	id SERIAL PRIMARY KEY,
	full_name varchar(255),
	prev_name varchar(255)
);


CREATE TABLE movie_genre (
    movie_id INT,
    genre_id INT,
    PRIMARY KEY (movie_id, genre_id),
    FOREIGN KEY (movie_id) REFERENCES movie_dim(id),
    FOREIGN KEY (genre_id) REFERENCES genre_dim(id)
);


CREATE TABLE movie_country (
    movie_id INT,
    country_id INT,
    PRIMARY KEY (movie_id, country_id),
    FOREIGN KEY (movie_id) REFERENCES movie_dim(id),
    FOREIGN KEY (country_id) REFERENCES country_dim(id)
);

create table person_movie(
    movie_id INT,
    person_id INT,
	role VARCHAR(255),
    PRIMARY KEY (movie_id, person_id, role),
    FOREIGN KEY (movie_id) REFERENCES movie_dim(id),
    FOREIGN KEY (person_id) REFERENCES person_dim(id)
)

create table movie_facts(
	id serial primary key,
	movie_id int references movie_dim(id),
	movie_type int references type_dim(id),
	year_id int references year_dim(id),
	cert_id int references certification_dim(id),
	seasons_id int references seasons_dim(id),
	description text,
 	runtime int,
	imdb_score NUMERIC(5,2),
    imdb_votes INTEGER,
    tmdb_popularity NUMERIC(10,2),
    tmdb_score NUMERIC(5,2)
)

create table streaming_facts(
	id serial primary key,
	movie_id int references movie_dim(id),
	year_id int references year_dim(id),
	age_id int references age_restrictions_dim(id),
	netflix_id int references netflix_dim(id),
	hulu_id int references hulu_dim(id),
	prime_video_id int references prime_video_dim(id),
	disney_plus_id int references disney_plus_dim(id)
);

create table budget_facts(
	id serial primary key,
	movie_id int references movie_dim(id),
    production_budget BIGINT,
    domestic_gross BIGINT,
    worldwide_gross BIGINT
);
