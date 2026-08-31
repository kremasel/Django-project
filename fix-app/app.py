import os
import time
import psycopg2
from datetime import datetime
from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

DB_HOST = os.environ.get('DB_HOST', 'postgres-cluster-rw')
DB_NAME = os.environ.get('DB_NAME', 'tododb')
DB_USER = os.environ.get('DB_USER', 'app')
DB_PASS = os.environ.get('DB_PASS', 'app-password')
DB_PORT = os.environ.get('DB_PORT', '5432')

def get_db_connection():
    retries = 5
    while retries > 0:
        try:
            return psycopg2.connect(
                host=DB_HOST,
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASS,
                port=DB_PORT
            )
        except psycopg2.OperationalError as e:
            retries -= 1
            time.sleep(2)
    raise Exception("DB Bağlantı Hatası!")

def init_db():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('''
            CREATE TABLE IF NOT EXISTS todos (
                id SERIAL PRIMARY KEY,
                title VARCHAR(255) NOT NULL,
                is_completed BOOLEAN DEFAULT FALSE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                start_time VARCHAR(50),
                end_time VARCHAR(50),
                completed_at VARCHAR(50)
            );
        ''')
        cur.execute('ALTER TABLE todos ADD COLUMN IF NOT EXISTS start_time VARCHAR(50);')
        cur.execute('ALTER TABLE todos ADD COLUMN IF NOT EXISTS end_time VARCHAR(50);')
        cur.execute('ALTER TABLE todos ADD COLUMN IF NOT EXISTS completed_at VARCHAR(50);')
        conn.commit()
        cur.close()
        conn.close()
        print("PostgreSQL Tablosu ve Kolonları Başarıyla Hazırlandı.")
    except Exception as e:
        print(f"Init DB Hatası: {e}")

@app.route('/')
def index():
    todos = []
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT id, title, is_completed, start_time, end_time, completed_at FROM todos ORDER BY id DESC;')
        rows = cur.fetchall()
        for row in rows:
            todos.append({
                'id': row[0],
                'title': row[1],
                'completed': row[2],
                'start_time': row[3] if row[3] else '',
                'end_time': row[4] if row[4] else '',
                'completed_at': row[5] if row[5] else ''
            })
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Index Sorgu Hatası: {e}")
    return render_template('index.html', todos=todos)

@app.route('/add', methods=['POST'])
def add_todo():
    title = request.form.get('title')
    start_time = request.form.get('start_time', '')
    end_time = request.form.get('end_time', '')

    def format_dt(dt_str):
        if not dt_str:
            return ''
        try:
            dt = datetime.strptime(dt_str, '%Y-%m-%dT%H:%M')
            return dt.strftime('%d.%m.%Y %H:%M')
        except Exception:
            return dt_str

    f_start = format_dt(start_time)
    f_end = format_dt(end_time)

    if title:
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute(
                'INSERT INTO todos (title, is_completed, start_time, end_time) VALUES (%s, %s, %s, %s);',
                (title, False, f_start, f_end)
            )
            conn.commit()
            cur.close()
            conn.close()
        except Exception as e:
            print(f"Ekleme Hatası: {e}")
    return redirect(url_for('index'))

@app.route('/toggle/<int:id>', methods=['POST', 'GET'])
def toggle_todo(id):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('SELECT is_completed FROM todos WHERE id = %s;', (id,))
        row = cur.fetchone()
        if row:
            new_status = not row[0]
            comp_at = datetime.now().strftime('%d.%m.%Y %H:%M') if new_status else ''
            cur.execute('UPDATE todos SET is_completed = %s, completed_at = %s WHERE id = %s;', (new_status, comp_at, id))
            conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Toggle Hatası: {e}")
    return redirect(url_for('index'))

@app.route('/delete/<int:id>', methods=['POST', 'GET'])
def delete_todo(id):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('DELETE FROM todos WHERE id = %s;', (id,))
        conn.commit()
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Silme Hatası: {e}")
    return redirect(url_for('index'))

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000)
