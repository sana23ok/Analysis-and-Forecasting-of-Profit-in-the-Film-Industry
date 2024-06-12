# Analysis and Forecasting of Profit in the Film Industry

This repository contains the course project "Analysis and Forecasting of Profit in the Film Industry." The main objective of this project is to create a data warehouse for comprehensive analysis and forecasting in the film industry, followed by conducting detailed data analysis and predictive modeling.

## Overview

This data warehouse is designed for comprehensive analysis and forecasting in the film industry.
It stores detailed information about movies, including budgets, box office earnings, 
genres, release years, certifications, and streaming platform availability. By integrating 
various dimensions and facts, it enables in-depth insights into financial performance, 
audience demographics, and streaming trends, facilitating strategic decision-making and 
predictive analytics.

![Data Warehouse Diagram](img/WareHouse (2).png)

## Data

The dataset contains the following columns:
- `title`: Title of the movie
- `genre`: Genre of the movie
- `country`: Country where the movie was produced
- `movie_type`: Type of the movie (e.g., MOVIE, SERIES)
- `year`: Release year
- `cert`: Certification of the movie
- `seasons`: Number of seasons (for series)
- `runtime`: Runtime in minutes
- `imdb_score`: IMDb score
- `imdb_votes`: Number of votes on IMDb
- `tmdb_popularity`: Popularity score on TMDb
- `tmdb_score`: Score on TMDb
- `age`: Age rating
- `netflix_release`: Availability on Netflix
- `hulu_release`: Availability on Hulu
- `prime_video_release`: Availability on Prime Video
- `disney_plus_release`: Availability on Disney+
- `production_budget`: Production budget
- `domestic_gross`: Domestic gross earnings
- `worldwide_gross`: Worldwide gross earnings

## Data Analysis

The analysis includes various visualizations and statistical tests to understand the data distribution and relationships between different variables:

1. **Distribution Plots**:
   - Genre
   - Country (Top 20)
   - Movie Type
   - Certification
   - Age Rating

2. **Streaming Platform Analysis**:
   - Distribution of releases on Netflix, Hulu, Prime Video, and Disney+

3. **Box Plots**:
   - Worldwide gross by country (Top 20)
   - Worldwide gross by genre

4. **Correlation Analysis**:
   - Heatmap showing correlations between numeric variables

5. **ANOVA Tests**:
   - Analysis of variance for various categorical variables to understand their impact on worldwide gross earnings.

## Predictive Modeling

Several regression models were trained and tested to forecast movie profits based on features such as IMDb votes and production budget:

- **Linear Regression**
- **Polynomial Regression**
- **Ridge Regression**
- **K-Nearest Neighbors (KNN)**
- **Random Forest**

### Model Performance

The models were evaluated using Mean Squared Error (MSE) and the coefficient of determination (R²).
The Random Forest model demonstrated the best performance with the lowest MSE and highest R²:

- **Random Forest**: MSE - 0.041, R² - 0.985

The Random Forest model is recommended for its superior predictive accuracy in forecasting movie profits.

## Conclusion

This project provides a robust framework for analyzing and predicting financial outcomes in the film industry. The data warehouse facilitates detailed analysis, and the predictive models, particularly the Random Forest model, offer reliable profit forecasts.

## Requirements

- Python 3.x
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Scikit-learn
- SciPy
