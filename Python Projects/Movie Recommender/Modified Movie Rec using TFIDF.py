import numpy as np
import pandas as pd
import ast
import sklearn
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# load the csv files
credits_df = pd.read_csv("E:\VS Code Projects\Movie_Rec\credits.csv")
movies_df = pd.read_csv("E:\VS Code Projects\Movie_Rec\movies.csv")

# merge the two dataframes and select relevant columns
movies_df = movies_df.merge(credits_df, on='title')
movies_df = movies_df[['movie_id','title','overview','genres','keywords','cast','crew']]

# drop rows with missing values
movies_df.dropna(inplace=True)

# helper function to convert a string representation of a list of dictionaries to a list of names
def convert(obj):
    L = []
    for i in ast.literal_eval(obj):
        L.append(i['name'])
    return L

# convert the 'genres' and 'keywords' columns to lists of names
movies_df['genres'] = movies_df['genres'].apply(convert)
movies_df['keywords'] = movies_df['keywords'].apply(convert)

# helper function to convert a string representation of a list of dictionaries to a list of 3 names
def convert3(obj):
    L = []
    counter = 0
    for i in ast.literal_eval(obj):
        if counter != 3:
            L.append(i['name'])
            counter += 1 
        else:
            break
    return L

# convert the 'cast' column to a list of 3 names
movies_df['cast'] = movies_df['cast'].apply(convert3)

# helper function to get a list of directors from a string representation of a list of dictionaries
def fetch_director(obj):
    L = []
    for i in ast.literal_eval(obj):
        if i['job'] == 'Director':
            L.append(i['name'])
    return L

# get a list of directors from the 'crew' column
movies_df['crew'] = movies_df['crew'].apply(fetch_director)

# format the column names
movies_df.columns = movies_df.columns.str.title()
movies_df.rename(columns = lambda x: x.replace("_", " "), inplace=True)

# combine relevant columns into a single 'Tags' column
movies_df['Overview'] = movies_df['Overview'].apply(lambda x:x.split())
movies_df['Tags'] = movies_df['Overview']+movies_df['Genres']+movies_df['Keywords']+movies_df['Cast'] 

# create a new dataframe with only the movie id, title, and 'Tags' columns
new_df = movies_df[['Movie Id','Title','Tags']]

# Formatting the 'Tags' column to a single string of lowercase words
new_df['Tags'] = new_df['Tags'].astype(str).str.replace(r'\[|\]|,', '', regex=True)
new_df['Tags'] = new_df['Tags'].str.replace("'", "")
new_df['Tags'] = new_df['Tags'].apply(lambda x:x.lower())

from sklearn.feature_extraction.text import TfidfVectorizer
tfidf = TfidfVectorizer(stop_words='english')

# Fit and transform the 'Tags' column using the TF-IDF vectorizer
tags_tfidf = tfidf.fit_transform(new_df['Tags'])

# Calculate the cosine similarity
similarity = cosine_similarity(tags_tfidf)

# Define the recommendation function
def recommend(movie, n=5):
    # Get the index of the movie
    movie_index = new_df[new_df['Title'] == movie].index[0]
    # Get the distances from the movie to other movies
    distances = similarity[movie_index]
    # Sort the distances in descending order and get the indices of the n closest movies
    closest_movies = np.argsort(distances)[::-1][1:n + 1]
    # Print the titles of the closest movies
    for i in closest_movies:
        print(new_df.iloc[i]['Title'])

# Test the recommendation function
recommend('')



