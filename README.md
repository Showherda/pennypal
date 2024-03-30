Tech stack:
1. PostgreSQL

ERD: https://lucid.app/lucidchart/4fa64863-e7df-421e-bc1a-3c93f9f5af2b/edit?invitationId=inv_652af2e8-b2e0-4e81-bdfa-ce2137d218ab

Future updates:
1. Test different database schema
2. Consider whether to generate graphs on the client side
3. If we store graphs on the server side, consider storing only file paths in the db
4. Possible migration: turn transaction_category, transaction_detail, and payment_method columns in transactions table into numerical datatype
5. Turn role column in conversations table into numerical datatype
6. Set foreign keys in db
7. put prompts in db
8. finetuning a model
9. more prompt engineering
10. gamification: award users with points if they meet budgets
11. suggest questions to user
12. need to update schema

How to run:
1. start the postgres database
2. add the code to the server using the combined_data.csv and exploration.py inside data/
3. python backend\script.py (FastAPI Server)
4. Start Android Virtual Device (Pixel 5, API 33 used)
5. Run app\pennypal\lib\main.dart