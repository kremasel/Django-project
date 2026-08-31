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
            conn = psycopg2.connect(
                host=DB_HOST,
                database=DB_NAME,
                user=DB_USER,
                password=DB_PASS,
                port=DB_PORT
            )
            return conn
        except psycopg2.OperationalError as e:
            retries -= 1
            print(f"Veritabanına bağlanılamadı. Kalan deneme: {retries}. Hata: {e}")
            time.sleep(3)
    raise Exception("Veritabanı bağlantısı kurulamadı!")

def init_db():
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Tablo yoksa oluştur
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
        
        # Mevcut tablo varsa yeni kolonları güvenle ekle (Migration)
        cur.execute('''
            ALTER TABLE todos ADD COLUMN IF NOT EXISTS start_time VARCHAR(50);
            ALTER TABLE todos ADD COLUMN IF NOT EXISTS end_time VARCHAR(50);
            ALTER TABLE todos ADD COLUMN IF NOT EXISTS completed_at VARCHAR(50);
        ''')
        
        conn.commit()
        cur.close()
        conn.close()
        print("PostgreSQL Tablosu ve Kolonları Başarıyla Hazırlandı.")
    except Exception as e:
        print(f"Tablo oluşturma hatası: {e}")

@app.route('/')
def index():
    todos = []
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute('''
            SELECT id, title, is_completed, created_at, start_time, end_time, completed_at 
            FROM todos ORDER BY id DESC;
        ''')
        rows = cur.fetchall()
        
        # HTML ile uyumlu dictionary yapısına dönüştür
        for row in rows:
            todos.append({
                'id': row[0],
                'title': row[1],
                'completed': row[2],
                'created_at': row[3],
                'start_time': row[4],
                'end_time': row[5],
                'completed_at': row[6]
            })
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Sorgu hatası: {e}")
    return render_template('index.html', tasks=todos)

@app.route('/add', methods=['POST'])
def add_todo():
    title = request.form.get('title')
    start_time = request.form.get('start_time')
    end_time = request.form.get('end_time')

    # datetime-local formatını (YYYY-MM-DDTHH:MM) okunan formata çevir
    def format_dt(dt_str):
        if not dt_str:
            return None
        try:
            dt = datetime.strptime(dt_str, '%Y-%m-%dT%H:%M')
            return dt.strftime('%d.%m.%Y %H:%M')
        except ValueError:
            return dt_str

    formatted_start = format_dt(start_time)
    formatted_end = format_dt(end_time)

    if title:
        try:
            conn = get_db_connection()
            cur = conn.cursor()
            cur.execute(
                'INSERT INTO todos (title, start_time, end_time) VALUES (%s, %s, %s);',
                (title, formatted_start, formatted_end)
            )
            conn.commit()
            cur.close()
            conn.close()
        except Exception as e:
            print(f"Ekleme hatası: {e}")
    return redirect(url_for('index'))

@app.route('/toggle/<int:id>', methods=['POST'])
def toggle_todo(id):
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Görevin mevcut durumunu al
        cur.execute('SELECT is_completed FROM todos WHERE id = %s;', (id,))
        row = cur.fetchone()
        
        if row:
            current_status = row[0]
            new_status = not current_status
            
            # Tamamlandıysa şu anki zamanı bas, tik kaldırılırsa zamanı sıfırla
            completed_at = datetime.now().strftime('%d.%m.%Y %H:%M') if new_status else None
            
            cur.execute(
                'UPDATE todos SET is_completed = %s, completed_at = %s WHERE id = %s;',
                (new_status, completed_at, id)
            )
            conn.commit()
            
        cur.close()
        conn.close()
    except Exception as e:
        print(f"Güncelleme hatası: {e}")
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
        print(f"Silme hatası: {e}")
    return redirect(url_for('index'))

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)