import numpy as np
import pandas as pd

credits_df = pd.read_csv("E:\VS Code Projects\Movie_Rec\credits.csv")
movies_df = pd.read_csv("E:\VS Code Projects\Movie_Rec\movies.csv")

movies_df = movies_df.merge(credits_df, on='title')
movies_df = movies_df[['movie_id','title','overview','genres','keywords','cast','crew']]

movies_df.isnull().sum()
movies_df.dropna(inplace=True)

import ast
def convert(obj):
    L=[]
    for i in ast.literal_eval(obj):
        L.append(i['name'])
    return L
    
movies_df['genres'] = movies_df['genres'].apply(convert)
movies_df['keywords'] = movies_df['keywords'].apply(convert)

def convert3(obj):
    L=[]
    counter = 0
    for i in ast.literal_eval(obj):
        if counter != 3:
            L.append(i['name'])
            counter += 1 
        else:
            break
        return L

movies_df['cast'] = movies_df['cast'].apply(convert3)

def fetch_director(obj):
    L = []
    for i in ast.literal_eval(obj):
        if i['job'] == 'Director':
            L.append(i['name'])
    return L

movies_df['crew'] = movies_df['crew'].apply(fetch_director)

movies_df.columns = movies_df.columns.str.title()
movies_df.rename(columns = lambda x: x.replace("_", " "), inplace=True)

movies_df['Overview'] = movies_df['Overview'].apply(lambda x:x.split())
movies_df['Tags'] = movies_df['Overview']+movies_df['Genres']+movies_df['Keywords']+movies_df['Cast'] 

new_df = movies_df[['Movie Id','Title','Tags']]


new_df['Tags'] = new_df['Tags'].astype(str).str.replace(r'\[|\]|,', '', regex=True)
new_df['Tags'] = new_df['Tags'].str.replace("'", "")
new_df['Tags'] = new_df['Tags'].apply(lambda X:X.lower())

#feature ext using count vectoriser
import sklearn
from sklearn.feature_extraction.text import CountVectorizer
cv = CountVectorizer(max_features=5000, stop_words = 'english')

cv.fit_transform(new_df['Tags']).toarray().shape
vectors = cv.fit_transform(new_df['Tags']).toarray()
cv.get_feature_names_out

import nltk
from nltk.stem.porter import PorterStemmer
ps = PorterStemmer()

def stem(text):
    y=[]
    for i in text.split():
        y.append(ps.stem(i))
    return " ".join(y)

new_df['Tags'] = new_df['Tags'].apply(stem)

from sklearn.metrics.pairwise import cosine_similarity
similarity = cosine_similarity(vectors)
sorted(list(enumerate(similarity[0])), reverse=True, key=lambda x:x[1])[1:6]

def recommend(movie):
    movie_index = new_df[new_df['Title']==movie].index[0]
    distances = similarity[movie_index]
    movies_list = sorted(list(enumerate(distances)), reverse=True, key=lambda x:x[1])[1:6]
    for i in movies_list:
        print(new_df.iloc[i[0]].Title)

recommend('')






