from fastapi import FastAPI
import sqlite3
import spacy


# Connect to SQLite database (will create if doesn't exist)
conn = sqlite3.connect('employeeDB.db')
cursor = conn.cursor()

# Create the Employees table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Employees (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,  
    Name VARCHAR(50) NOT NULL,                    
    Department VARCHAR(50) NOT NULL,              
    Salary INTEGER,                         
    Hire_Date DATE                          
);
""")

# Create the Departments table
cursor.execute("""
CREATE TABLE IF NOT EXISTS Departments (
    ID INTEGER PRIMARY KEY AUTOINCREMENT,  
    Name TEXT NOT NULL,                    
    Manager TEXT NOT NULL,                  
    FOREIGN KEY (Manager) REFERENCES Employees(Name)
);
""")

# Insert data into the Employees table
cursor.execute("""
INSERT INTO Employees (Name, Department, Salary, Hire_Date)
VALUES
    ('Alice', 'Sales', 50000, '2021-01-15'),
    ('Bob', 'Engineering', 70000, '2020-06-10'),
    ('Charlie', 'Marketing', 60000, '2022-03-20'),
    ('John', 'Sales', 60000, '2020-01-15'),
    ('Sarah', 'Engineering', 55000, '2019-08-10'),
    ('Michael', 'Sales', 62000, '2021-03-22'),
    ('Emily', 'Marketing', 58000, '2022-05-18'),
    ('David', 'Engineering', 65000, '2018-12-01'),
    ('Olivia', 'Sales', 54000, '2023-02-10'),
    ('James', 'Marketing', 70000, '2017-07-15'),
    ('Sophia', 'Engineering', 59000, '2019-10-30'),
    ('Liam', 'Sales', 61000, '2020-11-05'),
    ('Emma', 'Marketing', 63000, '2022-04-02');
""")

# Insert data into the Departments table
cursor.execute("""
INSERT INTO Departments (Name, Manager)
VALUES
    ('Sales', 'Alice'),
    ('Engineering', 'Bob'),
    ('Marketing', 'Charlie');
""")

# Commit changes and close connection
conn.commit()
conn.close()


app = FastAPI()

# Load SpaCy NLP model
nlp = spacy.blank("en")

# Query templates for database operations
QUERY_TEMPLATES = {
    "employees_in_department": "SELECT DISTINCT Name FROM Employees WHERE LOWER(Department) = ?",
    "manager_of_department": "SELECT DISTINCT Manager FROM Departments WHERE LOWER(Name) = ?",
    "employees_hired_after": "SELECT DISTINCT Name FROM Employees WHERE Hire_Date > ?",
    "total_salary_expense": "SELECT DISTINCT SUM(Salary) FROM Employees WHERE LOWER(Department) = ?"
}

# Helper function for extracting entities
def extract_entities(query: str):
    tokens = query.lower().split()
    departments = ["sales", "engineering", "marketing"]
    department = next((word for word in tokens if word in departments), None)
    date = next((word for word in tokens if "-" in word), None)
    return department, date

# Function to process the query and execute SQL
def process_query(query: str):
    department, date = extract_entities(query)

    if "employees in" in query:
        sql = QUERY_TEMPLATES["employees_in_department"]
        params = (department,)
    elif "manager of" in query:
        sql = QUERY_TEMPLATES["manager_of_department"]
        params = (department,)
    elif "hired after" in query:
        sql = QUERY_TEMPLATES["employees_hired_after"]
        params = (date,)
    elif "total salary expense" in query:
        sql = QUERY_TEMPLATES["total_salary_expense"]
        params = (department,)
    else:
        return "Sorry, I didn't understand your query."
    print(f"Executing SQL: {sql} with parameters: {params}")
    return execute_sql(sql, params)

# Function to execute SQL queries
def execute_sql(sql, params):
    conn = sqlite3.connect("employeeDB.db")
    cursor = conn.cursor()
    cursor.execute(sql, params)
    results = cursor.fetchall()
    conn.close()
    flattened_results = [row[0] for row in results]
    return flattened_results if flattened_results else "No results found."


# Route to test the server
@app.get("/")
def read_root():
    return {"message": "FastAPI server is running!"}

# Route to handle chat queries
@app.get("/query")
def chat_assistant(q: str):
    response = process_query(q)
    return {"response": response}
