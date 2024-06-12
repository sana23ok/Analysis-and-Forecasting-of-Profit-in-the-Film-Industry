--TRUNCATE TABLE year_dim CASCADE;

-- title dim
INSERT INTO movie_dim(title)
SELECT DISTINCT title
FROM (
    SELECT title
    FROM movies_by_country
    UNION
    SELECT title
    FROM imdb_scores
) AS combined;

-- type dim
INSERT INTO type_dim (type)
SELECT DISTINCT movie_type
FROM imdb_scores;

-- year dim
INSERT INTO year_dim(year)
SELECT DISTINCT release_year
FROM (
    SELECT release_year
    FROM movies_by_country
    UNION
    SELECT release_year
    FROM imdb_scores
) AS combined;

-- age restriction dim
INSERT INTO certification_dim(cert)
SELECT DISTINCT age_certification
FROM (
    SELECT age_certification
    FROM movies_by_country
    UNION
    SELECT age_certification
    FROM imdb_scores
) AS combined;

-- age restrictions dim
INSERT INTO age_restrictions_dim(age)
SELECT DISTINCT age_certification
FROM streaming_platforms;

-- seasons dim
INSERT INTO seasons_dim(seasons)
SELECT DISTINCT seasons
FROM movies_by_country;

-- netflix dim 
INSERT INTO netflix_dim(released)
SELECT DISTINCT netflix
FROM streaming_platforms;

-- hulu dim 
INSERT INTO hulu_dim(released)
SELECT DISTINCT CASE WHEN hulu = 1 THEN TRUE ELSE FALSE END
FROM streaming_platforms;

-- prime_video dim 
INSERT INTO prime_video_dim(released)
SELECT DISTINCT CASE WHEN prime_video = 1 THEN TRUE ELSE FALSE END
FROM streaming_platforms;

-- disney_plus dim 
INSERT INTO disney_plus_dim(released)
SELECT DISTINCT CASE WHEN disney_plus = 1 THEN TRUE ELSE FALSE END
FROM streaming_platforms;

-- person dim
INSERT INTO person_dim(full_name)
SELECT DISTINCT full_name
FROM people;

-- genre dim
INSERT INTO genre_dim (genre)
SELECT DISTINCT TRIM(unnest(string_to_array(genres, ','))) AS genre
FROM movies_by_country;

-- county dim
INSERT INTO country_dim(country)
SELECT DISTINCT TRIM(unnest(string_to_array(production_countries, ','))) AS country
FROM movies_by_country;

-- Inserting data into movie_facts table
INSERT INTO movie_facts
(
	movie_id, 
	movie_type, 
	year_id, 
	cert_id, 
	seasons_id, 
	description, 
	runtime, 
	imdb_score, 
	imdb_votes, 
	tmdb_popularity, 
	tmdb_score
)
SELECT 
    md.id AS movie_id,
    td.id AS movie_type,
    yd.id AS year_id,
    cd.id AS cert_id,
    sd.id AS seasons_id,
    mbc.description,
    mbc.runtime,
    mbc.imdb_score,
    mbc.imdb_votes,
    mbc.tmdb_popularity,
    mbc.tmdb_score
FROM 
    movies_by_country mbc
JOIN 
    movie_dim md ON mbc.title = md.title
JOIN 
    type_dim td ON mbc.movie_type = td.type
JOIN 
    year_dim yd ON mbc.release_year = yd.year
JOIN 
    certification_dim cd ON mbc.age_certification = cd.cert
JOIN 
    seasons_dim sd ON mbc.seasons = sd.seasons;
	
	

INSERT INTO streaming_facts (movie_id, year_id, age_id, netflix_id, hulu_id, prime_video_id, disney_plus_id)
SELECT 
	m.id, y.id, a.id, n.id, h.id, p.id, d.id
FROM 
	streaming_platforms s
JOIN
	movie_dim m ON s.title = m.title
JOIN
	year_dim y ON s.year = y.year
JOIN
	age_restrictions_dim a ON s.age_certification = a.age
JOIN 
	netflix_dim n ON s.netflix = n.released
JOIN 
	hulu_dim h ON s.hulu = h.released
JOIN 
	prime_video_dim p ON s.prime_video = p.released
JOIN
	disney_plus_dim d ON s.disney_plus = d.released;
	
	
INSERT INTO budget_facts (movie_id, production_budget, domestic_gross, worldwide_gross)
SELECT
	m.id, f.production_budget, f.domestic_gross, f.worldwide_gross
FROM 
	movie_financials f
JOIN 
	movie_dim m ON f.movie_title = m.title;
	
-- many-to-many 
INSERT INTO movie_genre(movie_id, genre_id)
SELECT md.id as movie_id, gd.id as genre_id
FROM movies_by_country mbc
JOIN movie_dim md ON mbc.title = md.title
JOIN unnest(string_to_array(mbc.genres, ',')) AS genre_name ON TRUE
JOIN genre_dim gd ON gd.genre = trim(genre_name)
ON CONFLICT (movie_id, genre_id) DO NOTHING;

INSERT INTO movie_country (movie_id, country_id)
SELECT md.id AS movie_id, cd.id AS country_id
FROM movies_by_country mbc
JOIN movie_dim md ON mbc.title = md.title
JOIN unnest(string_to_array(mbc.production_countries, ',')) AS country_name ON TRUE
JOIN country_dim cd ON cd.country = trim(country_name)
ON CONFLICT (movie_id, country_id) DO NOTHING;

INSERT INTO person_movie (movie_id, person_id, role)
SELECT md.id, pd.id, p.role
FROM people p
JOIN person_dim pd ON p.full_name = pd.full_name
JOIN imdb_scores sc ON p.netflix_id = sc.netflix_id
JOIN movie_dim md ON sc.title = md.title
WHERE p.netflix_id IS NOT NULL
ON CONFLICT (movie_id, person_id, role) DO NOTHING;



