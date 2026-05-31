# Recheck whether the conversion to int in SQL (::int)
# rounded the result or took the integer part.
# The script should be called from the root folder of the project.

import pandas as pd
import json


def extract_budget(details: str):
    dict_details = json.loads(details)
    return int(dict_details['budget'])


df = pd.read_csv('./dat/movies.csv')

movies_animation = df[df['genre'] == 'Animation']
budgets_animation = movies_animation['additional_info'].apply(extract_budget)

print(f"-- Version of pandas: {pd.__version__}")  # 2.1.1
print(f"-- Indices and budgets of animation movies:")
print(budgets_animation.head(10))
"""
11     45000000
13     30000000
18    175000000
20    175000000
21     94000000
22     92000000
23    115000000

{ 1st rows correspond, OK! }
"""


print(f"Of type {type(budgets_animation)}")  # <'pandas.core.series.Series'>
print(f"and size: {budgets_animation.shape}")  # (7,)
print("Indices start from 0 (pandas default) in this test, and are not used.")

print("----")
print(f"Mean budget: {budgets_animation.mean()}")
# -------------> 103714285.71428572
# result of SQL: 103714286 , OK (rounded to nearest int)
