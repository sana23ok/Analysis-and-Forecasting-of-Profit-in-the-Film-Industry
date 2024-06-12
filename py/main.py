# read cvs file
import pandas as pd


def contains_positive_values(df, column_name):
    if column_name not in df.columns:
        raise ValueError(f"Column '{column_name}' does not exist in the DataFrame.")

    # Перевірка, чи колонка містить додатні значення
    return (df[column_name] > 0).any()


def calculate_score(df, column_name):
    return df[column_name].apply(
        lambda x: float(x.split('/')[0]) / float(x.split('/')[1]) if isinstance(x, str) else x)


def get_countries(df):
    countries = df['production_countries'].unique()
    print(countries)


def replace_country_code(df, old_name, new_name):
    df['production_countries'] = df['production_countries'].replace(old_name, new_name)
    return df


def delete_brackets(df, column_name):
    return df[column_name].str.replace('[\'\[\]]', '', regex=True)


def modify_imdb_films(df):
    # Replace NaN with the mean value in the "imdb_votes" column
    mean_imdb_votes = df['imdb_votes'].mean()
    df['imdb_votes'] = df['imdb_votes'].fillna(mean_imdb_votes)

    # Replace NaN with 'Unknown' in the "description" column
    df['description'] = df['description'].fillna('Unknown')

    # Replace NaN with 'UR' in the "age_certification" column
    df['age_certification'] = df['age_certification'].fillna('UR')

    # Convert values in the "imdb_votes" column to integer type
    df['imdb_votes'] = df['imdb_votes'].astype(int)

    # Add a new column 'netflix' with value 1
    df['netflix'] = 1

    # Remove the column named "index"
    df.drop(columns=['index'], inplace=True)


def modify_data_by_country(df):
    # Remove rows where the 'imdb_id' or 'title' columns have NaN values
    df.dropna(subset=['imdb_id', 'title'], inplace=True)

    # Fill missing values in 'imdb_votes' column with mean
    mean_imdb_votes = df['imdb_votes'].mean()
    df['imdb_votes'] = df['imdb_votes'].fillna(mean_imdb_votes)

    # Fill missing values in 'description' column with 'Unknown'
    df['description'] = df['description'].fillna('Unknown')

    # Fill missing values in 'age_certification' column with 'UR'
    df['age_certification'] = df['age_certification'].fillna('UR')

    # Fill missing values in 'seasons' column with 0
    df['seasons'] = df['seasons'].fillna(0)

    # Fill missing values in 'imdb_score' column with mean
    mean_imdb_score = df['imdb_score'].mean()
    df['imdb_score'] = df['imdb_score'].fillna(mean_imdb_score)

    # Fill missing values in 'tmdb_popularity' column with mean
    mean_tmdb_popularity = df['tmdb_popularity'].mean()
    df['tmdb_popularity'] = df['tmdb_popularity'].fillna(mean_tmdb_popularity)

    # Fill missing values in 'tmdb_score' column with mean
    mean_tmdb_score = df['tmdb_score'].mean()
    df['tmdb_score'] = df['tmdb_score'].fillna(mean_tmdb_score)


def netflix_true(df):
    df['netflix'] = 1


def check_data(df):
    df.info()

    df.describe(include='all')

    # Оцінка відсутніх даних
    missing_data = df.isnull()
    for column in missing_data.columns.values.tolist():
        print(column)
        print(missing_data[column].value_counts())
        print("")

    # Check if there are any NaN values in the entire DataFrame
    any_nan = df.isna().any().any()

    # Print the result
    print(any_nan)


# ------ prepare IMDB movies data ------

# Read the CSV file
df_imdb = pd.read_csv('data/raw_data/netflix1.csv', encoding='utf-8')
# Display the DataFrame
# print(df_imdb)

check_data(df_imdb)

modify_imdb_films(df_imdb)
netflix_true(df_imdb)

check_data(df_imdb)

# save IMDB films to csv
df_imdb.to_csv('films_imdb_scores.csv', index=False)

# ------ prepare movies by country data ------
df_countries = pd.read_csv('data/raw_data/titles.csv', encoding='utf-8')

check_data(df_countries)

modify_data_by_country(df_countries)

# Видалення апострофів та символів '[' та ']'
df_countries['production_countries'] = delete_brackets(df_countries, 'production_countries')
df_countries['genres'] = delete_brackets(df_countries, 'genres')

# Перетворення типів
df_countries['seasons'] = df_countries['seasons'].astype(int)
df_countries['imdb_votes'] = df_countries['imdb_votes'].astype(int)

# Перевірка та перейменування країн
# get_countries(df_countries)
# ['production_countries'] = replace_country_code(df_countries, 'Lebanon', 'LB')

netflix_true(df_countries)

check_data(df_countries)

# Display the DataFrame
# print(df)

# Netflix IMDB Scores
df_countries.to_csv('titles.csv', index=False)
#
# ------ prepare movies by budget data ------

# Read the CSV file
df_budget = pd.read_csv('data/raw_data/top_4000_movies_data.csv', encoding='utf-8')

df_budget.drop(columns=['Release Date'], inplace=True)

# Заповнити NaN значення середнім значенням
mean_production_budget = df_budget['Production Budget'].mean()
df_budget['Production Budget'] = df_budget['Production Budget'].fillna(mean_production_budget)

mean_domestic_gross = df_budget['Domestic Gross'].mean()
df_budget['Domestic Gross'] = df_budget['Domestic Gross'].fillna(mean_domestic_gross)

mean_worldwide_gross = df_budget['Worldwide Gross'].mean()
df_budget['Worldwide Gross'] = df_budget['Worldwide Gross'].fillna(mean_worldwide_gross)

print(contains_positive_values(df_budget, 'Production Budget'))

check_data(df_budget)

df_budget.to_csv('budget.csv', index=False)

# ------ prepare movies by platforms data ------

df_platforms = pd.read_csv('data/raw_data/MoviesOnStreamingPlatforms.csv', encoding='utf-8')

# Видаляємо стовпець "Unnamed: 0"
df_platforms.drop(columns=['Unnamed: 0'], inplace=True)
df_platforms.drop(columns=['ID'], inplace=True)
df_platforms.drop(columns=['Type'], inplace=True)

# Розділити значення "98/100" на чисельник та знаменник тільки для строкових значень
df_platforms['Rotten Tomatoes'] = calculate_score(df_platforms, 'Rotten Tomatoes')

# Заповнити NaN значення середнім значенням
mean_rotten_tomatoes = df_platforms['Rotten Tomatoes'].mean()
df_platforms['Rotten Tomatoes'] = df_platforms['Rotten Tomatoes'].fillna(mean_rotten_tomatoes)

# Замінити значення NaN у стовпці "Age" на "Unrated" без параметра inplace
df_platforms['Age'] = df_platforms['Age'].fillna('Unrated')

check_data(df_platforms)

df_platforms.to_csv('streaming_platforms.csv', index=False)

# ------ prepare movies by credits data ------
df_credits = pd.read_csv('data/raw_data/credits.csv', encoding='utf-8')

df_credits.drop(columns=['character'], inplace=True)

check_data(df_credits)

# Netflix IMDB Scores
df_credits.to_csv('credits.csv', index=False)
