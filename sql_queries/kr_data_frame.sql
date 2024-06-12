CREATE TABLE movies_data AS
SELECT DISTINCT
    md.title,
    gd.genre,
    cd.country,
    td.type AS movie_type,
    yd.year,
    certd.cert,
    sd.seasons,
    mf.runtime,
    mf.imdb_score,
    mf.imdb_votes,
    mf.tmdb_popularity,
    mf.tmdb_score,
    ard.age,
    nd.released as netflix_release,
    hd.released as hulu_release,
    pvd.released as prime_video_release,
    dpd.released as disney_plus_release,
    bf.production_budget,
    bf.domestic_gross,
    bf.worldwide_gross
FROM 
    movie_genre g
JOIN 
    movie_dim md ON md.id = g.movie_id
JOIN 
    genre_dim gd ON gd.id = g.genre_id
JOIN 
    movie_country c ON g.movie_id = c.movie_id
JOIN 
    country_dim cd ON cd.id = c.country_id
JOIN 
    movie_facts mf ON mf.movie_id = md.id
JOIN 
    type_dim td ON td.id = mf.movie_type
JOIN 
    year_dim yd ON yd.id = mf.year_id
JOIN 
    certification_dim certd ON certd.id = mf.cert_id
JOIN 
    seasons_dim sd ON sd.id = mf.seasons_id
JOIN 
    streaming_facts sf ON sf.movie_id = md.id
JOIN 
    age_restrictions_dim ard ON ard.id = sf.age_id
JOIN 
    netflix_dim nd ON nd.id = sf.netflix_id
JOIN 
    hulu_dim hd ON hd.id = sf.hulu_id
JOIN 
    prime_video_dim pvd ON pvd.id = sf.prime_video_id
JOIN 
    disney_plus_dim dpd ON dpd.id = sf.disney_plus_id
LEFT JOIN
    budget_facts bf ON bf.movie_id = md.id
ORDER BY md.title;

COPY movies_data TO 'D:\KPI\AD\KR_Data\movies_data.csv' 
WITH (FORMAT CSV, HEADER);



CREATE TABLE movies_data_u AS
SELECT DISTINCT
    title,
    movie_type,
    year,
    cert,
    seasons,
    runtime,
    imdb_score,
    imdb_votes,
    tmdb_popularity,
    tmdb_score,
    age,
    netflix_release,
    hulu_release,
    prime_video_release,
    disney_plus_release,
    production_budget,
    domestic_gross,
    worldwide_gross
FROM 
    movies_data;

COPY movies_data_u TO 'D:\KPI\AD\KR_Data\movies_data_u.csv' 
WITH (FORMAT CSV, HEADER);




----
CREATE TABLE data_frame AS
SELECT DISTINCT
    md.title,
    gd.genre,
    cd.country,
    td.type AS movie_type,
    yd.year,
    certd.cert,
    sd.seasons,
    mf.runtime,
    mf.imdb_score,
    mf.imdb_votes,
    mf.tmdb_popularity,
    mf.tmdb_score,
    ard.age,
    nd.released as netflix_release,
    hd.released as hulu_release,
    pvd.released as prime_video_release,
    dpd.released as disney_plus_release,
    bf.production_budget,
    bf.domestic_gross,
    bf.worldwide_gross
FROM 
    movie_genre g
JOIN 
    movie_dim md ON md.id = g.movie_id
JOIN 
    genre_dim gd ON gd.id = g.genre_id
JOIN 
    movie_country c ON g.movie_id = c.movie_id
JOIN 
    country_dim cd ON cd.id = c.country_id
JOIN 
    movie_facts mf ON mf.movie_id = md.id
JOIN 
    type_dim td ON td.id = mf.movie_type
JOIN 
    year_dim yd ON yd.id = mf.year_id
JOIN 
    certification_dim certd ON certd.id = mf.cert_id
JOIN 
    seasons_dim sd ON sd.id = mf.seasons_id
JOIN 
    streaming_facts sf ON sf.movie_id = md.id
JOIN 
    age_restrictions_dim ard ON ard.id = sf.age_id
JOIN 
    netflix_dim nd ON nd.id = sf.netflix_id
JOIN 
    hulu_dim hd ON hd.id = sf.hulu_id
JOIN 
    prime_video_dim pvd ON pvd.id = sf.prime_video_id
JOIN 
    disney_plus_dim dpd ON dpd.id = sf.disney_plus_id
LEFT JOIN
    budget_facts bf ON bf.movie_id = md.id
ORDER BY md.title;

truncate table data_frame;

select * from data_frame;

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'data_frame';

ALTER TABLE data_frame ALTER COLUMN production_budget TYPE numeric;
ALTER TABLE data_frame ALTER COLUMN domestic_gross TYPE numeric;
ALTER TABLE data_frame ALTER COLUMN worldwide_gross TYPE numeric;

COPY data_frame(
title,
genre,
country,
movie_type,
year,
cert,
seasons,
runtime,
imdb_score,
imdb_votes,
tmdb_popularity,
tmdb_score,
age,
netflix_release,
hulu_release,
prime_video_release,
disney_plus_release,
production_budget,
domestic_gross,
worldwide_gross) 
FROM 'D:/KPI/AD/KR_Data/df.csv' 
DELIMITER ',' CSV HEADER;

select * from data_frame;

ALTER TABLE data_frame drop COLUMN actor;
ALTER TABLE data_frame drop COLUMN director;


-- Створення нової таблиці `data_frame_extended`
CREATE TABLE data_frame_extended AS
SELECT df.*, pd.full_name AS actor_or_director, pm.role
FROM data_frame df
JOIN movie_dim md ON df.title = md.title
JOIN person_movie pm ON md.id = pm.movie_id
JOIN person_dim pd ON pm.person_id = pd.id
WHERE pm.role IN ('ACTOR', 'DIRECTOR');

select * from data_frame_extended;
ALTER TABLE data_frame_extended drop COLUMN actor;
ALTER TABLE data_frame_extended drop COLUMN director;

select distinct(title) from data_frame;
select distinct(title) from data_frame_extended;
