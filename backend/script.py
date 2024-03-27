import pandas as pd

ahmad = pd.read_csv('backend/data/ahmad.csv')
brian = pd.read_csv('backend/data/brian.csv')
charles = pd.read_csv('backend/data/charles.csv')
danish = pd.read_csv('backend/data/danish.csv')
emily = pd.read_csv('backend/data/emily.csv')

print(*ahmad['CATEGORY'].unique(), sep=', ')
print(*brian['CATEGORY'].unique(), sep=', ')
print(*charles['CATEGORY'].unique(), sep=', ')
print(*danish['CATEGORY'].unique(), sep=', ')
print(*emily['CATEGORY'].unique(), sep=', ')