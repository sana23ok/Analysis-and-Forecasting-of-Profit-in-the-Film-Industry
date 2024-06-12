CREATE OR REPLACE PROCEDURE load_imdb_scores()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Створення тимчасової таблиці
    CREATE TEMP TABLE IF NOT EXISTS temp_imdb_scores AS SELECT * FROM imdb_scores WITH NO DATA;

    -- Завантаження даних до тимчасової таблиці
    COPY temp_imdb_scores(netflix_id, title, movie_type, description,
                          release_year, age_certification, runtime,
                          imdb_id, imdb_score, imdb_votes, netflix) 
    FROM 'D:\KPI\AD\KR_Data\films_imdb_scores.csv' DELIMITER ',' CSV HEADER;

	-- Вставка лише нових рядків до основної таблиці
	INSERT INTO imdb_scores(netflix_id, title, movie_type, description,
							release_year, age_certification, runtime,
							imdb_id, imdb_score, imdb_votes, netflix)
	SELECT netflix_id, title, movie_type, description,
		   release_year, age_certification, runtime,
		   imdb_id, imdb_score, imdb_votes, netflix
	FROM temp_imdb_scores t
	WHERE NOT EXISTS (
		SELECT 1
		FROM imdb_scores i
		WHERE i.imdb_id = t.imdb_id AND
			  i.netflix_id = t.netflix_id AND 
			  i.title = t.title AND 
			  i.release_year = t.release_year AND
			  i.movie_type = t.movie_type AND
			  i.description = t.description AND
			  i.runtime = t.runtime AND
			  i.age_certification = t.age_certification AND
			  i.imdb_score= t.imdb_score AND
			  i.imdb_votes = t.imdb_votes AND
			  i.netflix = t.netflix
	);

    -- Видалення тимчасової таблиці
    DROP TABLE temp_imdb_scores;
END;
$$;

CALL load_imdb_scores();

CREATE OR REPLACE PROCEDURE load_movies_by_country()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Create a temporary table to hold the data
    CREATE TEMP TABLE IF NOT EXISTS temp_movies_by_country AS SELECT * FROM movies_by_country WITH NO DATA;

    -- Load data into the temporary table
    COPY temp_movies_by_country(netflix_id, title, movie_type, description, 
                                 release_year, age_certification, runtime, 
                                 genres, production_countries, seasons, 
                                 imdb_id, imdb_score, imdb_votes, 
                                 tmdb_popularity, tmdb_score, netflix) 
    FROM 'D:\KPI\AD\KR_Data\titles.csv' 
    DELIMITER ',' CSV HEADER;

    -- Insert only new rows into the main table
    INSERT INTO movies_by_country(netflix_id, title, movie_type, description,
                                   release_year, age_certification, runtime,
                                   genres, production_countries, seasons,
                                   imdb_id, imdb_score, imdb_votes,
                                   tmdb_popularity, tmdb_score, netflix)
    SELECT netflix_id, title, movie_type, description,
           release_year, age_certification, runtime,
           genres, production_countries, seasons,
           imdb_id, imdb_score, imdb_votes,
           tmdb_popularity, tmdb_score, netflix
    FROM temp_movies_by_country t
    WHERE NOT EXISTS (
        SELECT 1
        FROM movies_by_country m
        WHERE m.imdb_id = t.imdb_id AND
              m.netflix_id = t.netflix_id AND 
              m.title = t.title AND 
              m.release_year = t.release_year AND
              m.movie_type = t.movie_type AND
              m.description = t.description AND
              m.runtime = t.runtime AND
              m.age_certification = t.age_certification AND
              m.imdb_score = t.imdb_score AND
              m.imdb_votes = t.imdb_votes AND
              m.netflix = t.netflix
    );

    -- Drop the temporary table
    DROP TABLE temp_movies_by_country;
END;
$$;

CALL load_movies_by_country();


CREATE OR REPLACE PROCEDURE load_movie_financials()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Create a temporary table to hold the data
    CREATE TEMP TABLE IF NOT EXISTS temp_movie_financials AS SELECT * FROM movie_financials WITH NO DATA;

    -- Load data into the temporary table
    COPY temp_movie_financials(movie_title, production_budget, domestic_gross, worldwide_gross) 
    FROM 'D:\KPI\AD\KR_Data\budget.csv' 
    WITH (FORMAT CSV, HEADER);

    -- Insert only new rows into the main table
    INSERT INTO movie_financials(movie_title, production_budget, domestic_gross, worldwide_gross)
    SELECT movie_title, production_budget, domestic_gross, worldwide_gross
    FROM temp_movie_financials t
    WHERE NOT EXISTS (
        SELECT 1
        FROM movie_financials m
        WHERE m.movie_title = t.movie_title and 
		m.production_budget = t.production_budget and
		m.domestic_gross = t.domestic_gross and
		m.worldwide_gross = t.worldwide_gross 
    );

    -- Drop the temporary table
    DROP TABLE temp_movie_financials;
END;
$$;

CALL load_movie_financials();

CREATE OR REPLACE PROCEDURE load_streaming_platforms()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Create a temporary table to hold the data
    CREATE TEMP TABLE IF NOT EXISTS temp_streaming_platforms AS SELECT * FROM streaming_platforms WITH NO DATA;

    -- Load data into the temporary table
    COPY temp_streaming_platforms(title, year, age_certification, rotten_tomatoes_score, netflix, hulu, prime_video, disney_plus) 
    FROM 'D:\KPI\AD\KR_Data\streaming_platforms.csv' 
    WITH (FORMAT CSV, HEADER);

    -- Insert only new rows into the main table
    INSERT INTO streaming_platforms(title, year, age_certification, rotten_tomatoes_score, netflix, hulu, prime_video, disney_plus)
    SELECT title, year, age_certification, rotten_tomatoes_score, netflix, hulu, prime_video, disney_plus
    FROM temp_streaming_platforms t
    WHERE NOT EXISTS (
        SELECT 1
        FROM streaming_platforms s
        WHERE s.title = t.title AND
              s.year = t.year AND
              s.age_certification = t.age_certification AND
              s.rotten_tomatoes_score = t.rotten_tomatoes_score AND
              s.netflix = t.netflix AND
              s.hulu = t.hulu AND
              s.prime_video = t.prime_video AND
              s.disney_plus = t.disney_plus
    );

    -- Drop the temporary table
    DROP TABLE temp_streaming_platforms;
END;
$$;

CALL load_streaming_platforms();


CREATE OR REPLACE PROCEDURE load_people()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Create a temporary table to hold the data
    CREATE TEMP TABLE IF NOT EXISTS temp_people AS SELECT * FROM people WITH NO DATA;

    -- Load data into the temporary table
    COPY temp_people(person_id, netflix_id, full_name, role) 
    FROM 'D:\KPI\AD\KR_Data\credits.csv' 
    WITH (FORMAT CSV, HEADER);

    -- Insert only new rows into the main table
    INSERT INTO people(person_id, netflix_id, full_name, role)
    SELECT person_id, netflix_id, full_name, role
    FROM temp_people t
    WHERE NOT EXISTS (
        SELECT 1
        FROM people p
        WHERE p.person_id = t.person_id
    );

    -- Drop the temporary table
    DROP TABLE temp_people;
END;
$$;

CALL load_people();

CREATE OR REPLACE PROCEDURE fill_dimensions()
LANGUAGE plpgsql
AS $$
BEGIN
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

    -- certification dim
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

    -- netflix dim 
    INSERT INTO netflix_dim(released)
    SELECT DISTINCT CASE WHEN netflix::integer = 1 THEN TRUE ELSE FALSE END
    FROM streaming_platforms;

    -- hulu dim 
    INSERT INTO hulu_dim(released)
    SELECT DISTINCT CASE WHEN hulu::integer = 1 THEN TRUE ELSE FALSE END
    FROM streaming_platforms;

    -- prime_video dim 
    INSERT INTO prime_video_dim(released)
    SELECT DISTINCT CASE WHEN prime_video::integer = 1 THEN TRUE ELSE FALSE END
    FROM streaming_platforms;

    -- disney_plus dim 
    INSERT INTO disney_plus_dim(released)
    SELECT DISTINCT CASE WHEN disney_plus::integer = 1 THEN TRUE ELSE FALSE END
    FROM streaming_platforms;
END;
$$;

CALL fill_dimensions();

CREATE OR REPLACE PROCEDURE fill_movie_relations()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert into movie_genre
    INSERT INTO movie_genre(movie_id, genre_id)
    SELECT md.id as movie_id, gd.id as genre_id
    FROM movies_by_country mbc
    JOIN movie_dim md ON mbc.title = md.title
    JOIN unnest(string_to_array(mbc.genres, ',')) AS genre_name ON TRUE
    JOIN genre_dim gd ON gd.genre = trim(genre_name)
    ON CONFLICT (movie_id, genre_id) DO NOTHING;

    -- Insert into movie_country
    INSERT INTO movie_country (movie_id, country_id)
    SELECT md.id AS movie_id, cd.id AS country_id
    FROM movies_by_country mbc
    JOIN movie_dim md ON mbc.title = md.title
    JOIN unnest(string_to_array(mbc.production_countries, ',')) AS country_name ON TRUE
    JOIN country_dim cd ON cd.country = trim(country_name)
    ON CONFLICT (movie_id, country_id) DO NOTHING;

    -- Insert into person_movie
    INSERT INTO person_movie (movie_id, person_id, role)
    SELECT md.id, pd.id, p.role
    FROM people p
    JOIN person_dim pd ON p.full_name = pd.full_name
    JOIN imdb_scores sc ON p.netflix_id = sc.netflix_id
    JOIN movie_dim md ON sc.title = md.title
    WHERE p.netflix_id IS NOT NULL
    ON CONFLICT (movie_id, person_id, role) DO NOTHING;
END;
$$;

call fill_movie_relations();


CREATE OR REPLACE PROCEDURE load_budget_facts()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Insert only new rows into the budget_facts table
    INSERT INTO budget_facts (movie_id, production_budget, domestic_gross, worldwide_gross)
    SELECT DISTINCT
        m.id, f.production_budget, f.domestic_gross, f.worldwide_gross
    FROM 
        movie_financials f
    JOIN 
        movie_dim m ON f.movie_title = m.title;
END;
$$;

call load_budget_facts();

CREATE OR REPLACE PROCEDURE load_streaming_facts()
LANGUAGE plpgsql
AS $$
BEGIN
		-- Insert only new rows 
	INSERT INTO streaming_facts (movie_id, year_id, age_id, netflix_id, hulu_id, prime_video_id, disney_plus_id)
	SELECT DISTINCT
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
END;
$$;

call load_streaming_facts();


CREATE OR REPLACE PROCEDURE load_movie_facts()
LANGUAGE plpgsql
AS $$
BEGIN
	-- Insert only new rows 
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
	SELECT DISTINCT
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
END;
$$;

call load_movie_facts();


CREATE OR REPLACE FUNCTION trigger_update_imdb_scores()
RETURNS TRIGGER AS $$
BEGIN
    CALL fill_dimensions();
    CALL fill_movie_relations();
    CALL load_movie_facts();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_imdb_scores
AFTER INSERT OR UPDATE OR DELETE ON imdb_scores
FOR EACH STATEMENT
EXECUTE FUNCTION trigger_update_imdb_scores();



CREATE OR REPLACE FUNCTION trigger_update_movies_by_country()
RETURNS TRIGGER AS $$
BEGIN
    CALL fill_dimensions();
    CALL fill_movie_relations();
    CALL load_movie_facts();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_update_movies_by_country
AFTER INSERT OR UPDATE OR DELETE ON movies_by_country
FOR EACH STATEMENT
EXECUTE FUNCTION trigger_update_movies_by_country();



CREATE OR REPLACE FUNCTION trigger_update_movie_financials()
RETURNS TRIGGER AS $$
BEGIN
    CALL load_budget_facts();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_movie_financials
AFTER INSERT OR UPDATE OR DELETE ON movie_financials
FOR EACH STATEMENT
EXECUTE FUNCTION trigger_update_movie_financials();



CREATE OR REPLACE FUNCTION trigger_update_streaming_platforms()
RETURNS TRIGGER AS $$
BEGIN
    CALL fill_dimensions();
    CALL load_streaming_facts();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_streaming_platforms
AFTER INSERT OR UPDATE OR DELETE ON streaming_platforms
FOR EACH STATEMENT
EXECUTE FUNCTION trigger_update_streaming_platforms();



CREATE OR REPLACE FUNCTION trigger_update_people()
RETURNS TRIGGER AS $$
BEGIN
    CALL fill_dimensions();
    CALL fill_movie_relations();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_people
AFTER INSERT OR UPDATE OR DELETE ON people
FOR EACH STATEMENT
EXECUTE FUNCTION trigger_update_people();