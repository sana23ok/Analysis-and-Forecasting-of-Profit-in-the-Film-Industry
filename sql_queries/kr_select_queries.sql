SELECT md.title, b.production_budget, b.domestic_gross, b.worldwide_gross
FROM budget_facts b
JOIN movie_facts mf ON mf.movie_id = b.movie_id
JOIN movie_dim md ON mf.movie_id = md.id;
