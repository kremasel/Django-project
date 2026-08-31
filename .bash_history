sudo apt update && curl -sfL https://get.k3s.io | sh -
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> ~/.bashrc
kubectl apply --server-side -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.20/releases/cnpg-1.20.0.yaml
kubectl get nodes
kubectl apply -f k8s/
kubectl apply --server-side -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.20/releases/cnpg-1.20.0.yaml
kubectl create namespace todo-production
kubectl apply -f k8s/
kubectl apply --server-side -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.20/releases/cnpg-1.20.0.yaml
kubectl create namespace todo-production --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f k8s/
kubectl apply -f k8s/03-postgres-cluster.yaml
kubectl get cluster -n todo-production
kubectl get all -n todo-production 
sudo docker build -t todo-app-v2:latest .
sudo k3s ctr image pull docker.io/library/ubuntu:latest
sudo buildah bud -t todo-app-v2:latest . 2>/dev/null || sudo nerdctl --namespace k8s.io build -t todo-app-v2:latest .
sudo apt update && sudo apt install -y docker.io
sudo docker build -t todo-app-v2:latest .
sudo k3s ctr images import <(sudo docker save todo-app-v2:latest)
sudo docker save todo-app-v2:latest | sudo k3s ctr images import -
kubectl rollout restart deployment todo-app-deployment -n todo-production
kubectl get pods -n todo-production
sudo docker save todo-app-v2:latest | sudo k3s ctr -n k8s.io images import -
kubectl apply -f k8s/04-app-deployment.yaml
kubectl rollout restart deployment todo-app-deployment -n todo-production
kubectl get pods -n todo-production
kubectl get svc -n todo-production
kubectl port-forward --address 0.0.0.0 svc/todo-app-service 80:5000 -n todo-production
kubectl port-forward --address 0.0.0.0 svc/todo-app-service 80:32353 -n todo-production
sudo kubectl port-forward --address 0.0.0.0 svc/todo-app-service 80:80 -n todo-production
sudo docker build -t todo-app-v2:latest .
sudo docker save todo-app-v2:latest | sudo k3s ctr -n k8s.io images import -
kubectl rollout restart deployment todo-app-deployment -n todo-production
scp -i last-key.pem app.py templates/index.html ubuntu@43.229.94.155:~/
sudo docker build -t todo-app-v2:latest .
sudo docker save todo-app-v2:latest | sudo k3s ctr -n k8s.io images import -
kubectl rollout restart deployment todo-app-deployment -n todo-production
sudo docker build -t todo-app-v2:latest .
sudo docker save todo-app-v2:latest | sudo k3s ctr -n k8s.io images import -
kubectl rollout restart deployment todo-app-deployment -n todo-production
sudo docker build -t todo-app-v3:latest .
sudo docker save todo-app-v3:latest | sudo k3s ctr -n k8s.io images import -
kubectl set image deployment/todo-app-deployment todo-app=todo-app-v3:latest -n todo-production
kubectl rollout status deployment/todo-app-deployment -n todo-production
sudo docker build -t todo-app-v4:latest .
sudo docker save todo-app-v4:latest | sudo k3s ctr -n k8s.io images import -
kubectl set image deployment/todo-app-deployment todo-app=todo-app-v4:latest -n todo-production
kubectl delete pods -l app=todo-app -n todo-production
sudo docker build -t todo-app-v4:latest .
sudo docker save todo-app-v4:latest | sudo k3s ctr -n k8s.io images import -
kubectl set image deployment/todo-app-deployment todo-app=todo-app-v4:latest -n todo-production
kubectl delete pods -l app=todo-app -n todo-production
sudo docker build -t todo-app-v6:latest .
sudo docker save todo-app-v6:latest | sudo k3s ctr -n k8s.io images import -
kubectl set image deployment/todo-app-deployment todo-app=todo-app-v6:latest -n todo-production
kubectl delete pods -l app=todo-app -n todo-production
mkdir -p ~/fix-app/templates
cd ~/fix-app
cat << 'EOF' > templates/index.html
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>vMind Task Center</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-header-orange { background-color: #ff6600; color: white; border-radius: 15px 15px 0 0 !important; }
        .badge-pill { border-radius: 20px; padding: 6px 12px; font-weight: 600; }
        .task-card { border-radius: 12px; border: 1px solid #e2e8f0; background-color: white; }
        .check-btn { width: 36px; height: 36px; border-radius: 50%; border: 2px solid #cbd5e1; background: transparent; cursor: pointer; }
        .check-btn.completed { background-color: #10b981; border-color: #10b981; color: white; }
    </style>
</head>
<body class="py-5">
<div class="container" style="max-width: 750px;">
    <div class="card shadow-lg border-0" style="border-radius: 15px;">
        <div class="card-header card-header-orange p-4 text-center">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="badge bg-white text-dark badge-pill"><i class="bi bi-cpu me-1"></i> Kubernetes Native</span>
                <span class="badge bg-dark badge-pill"><i class="bi bi-database me-1"></i> PostgreSQL Operator</span>
            </div>
            <h2 class="fw-bold mb-1"><i class="bi bi-cloud-upload me-2"></i>vMind Task Center</h2>
            <p class="mb-0 opacity-75">Cloud Infrastructure & Automated S3 Backup Pipeline</p>
        </div>
        <div class="card-body p-4">
            <div class="row g-3 mb-4 text-center">
                <div class="col-6">
                    <div class="p-3 bg-light rounded-3">
                        <small class="text-muted fw-bold d-block mb-1">TOPLAM GÖREV</small>
                        <h3 class="fw-bold mb-0">{{ todos|length if todos else 0 }}</h3>
                    </div>
                </div>
                <div class="col-6">
                    <div class="p-3 bg-light rounded-3">
                        <small class="text-muted fw-bold d-block mb-1">S3 BACKUP STATUS</small>
                        <span class="text-success fw-bold"><i class="bi bi-shield-check me-1"></i>Aktif (Betap)</span>
                    </div>
                </div>
            </div>

            <!-- FORM -->
            <form action="/add" method="POST" class="mb-4 p-3 border rounded-3 bg-light">
                <div class="mb-3">
                    <label class="form-label fw-bold text-dark">Görev Başlığı:</label>
                    <input type="text" name="title" class="form-control form-control-lg" placeholder="vMind bulut altyapısı için yeni görev..." required>
                </div>
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-secondary mb-1">📅 Başlangıç Tarihi & Saati:</label>
                        <input type="datetime-local" name="start_time" class="form-control" style="border: 2px solid #ff6600;">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-secondary mb-1">🏁 Planlanan Bitiş Tarihi:</label>
                        <input type="datetime-local" name="end_time" class="form-control" style="border: 2px solid #ff6600;">
                    </div>
                </div>
                <button class="btn btn-warning text-white fw-bold w-100 py-2" type="submit" style="background-color: #ff6600; border: none;">
                    <i class="bi bi-plus-circle me-1"></i> Görevi Kaydet
                </button>
            </form>

            <!-- LISTE -->
            <div class="task-list d-flex flex-column gap-3">
                {% for task in todos %}
                <div class="task-card p-3 d-flex align-items-center justify-content-between">
                    <form action="/toggle/{{ task.id }}" method="POST" class="m-0">
                        <button type="submit" class="check-btn {{ 'completed' if task.completed }}">
                            <i class="bi bi-check-lg"></i>
                        </button>
                    </form>
                    <div class="ms-3 flex-grow-1">
                        <div class="fw-bold text-dark fs-6 {{ 'text-decoration-line-through text-muted' if task.completed }}">{{ task.title }}</div>
                        <div class="d-flex flex-wrap align-items-center gap-2 mt-1" style="font-size: 0.82rem;">
                            <span class="text-muted"><i class="bi bi-clock me-1"></i>ID: #{{ task.id }}</span>
                            {% if task.start_time or task.end_time %}
                            <span class="badge bg-primary text-white">
                                📅 {{ task.start_time if task.start_time else '—' }} ➔ {{ task.end_time if task.end_time else '—' }}
                            </span>
                            {% endif %}
                            {% if task.completed and task.completed_at %}
                            <span class="badge bg-success text-white">
                                ✅ Tamamlandı: {{ task.completed_at }}
                            </span>
                            {% endif %}
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-warning text-dark px-3">Production</span>
                        <a href="/delete/{{ task.id }}" class="btn btn-link text-danger p-0 ms-2"><i class="bi bi-trash fs-5"></i></a>
                    </div>
                </div>
                {% endfor %}
            </div>
        </div>
        <div class="card-footer bg-dark text-white p-3 d-flex justify-content-around text-center" style="border-radius: 0 0 15px 15px;">
            <small><i class="bi bi-hdd-network text-warning me-1"></i> Persistent Volume: 5GB</small>
            <small><i class="bi bi-cloud-arrow-up text-info me-1"></i> Object Storage: S3 PortVMind</small>
        </div>
    </div>
</div>
</body>
</html>
EOF

cat << 'EOF' > templates/index.html
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>vMind Task Center</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-header-orange { background-color: #ff6600; color: white; border-radius: 15px 15px 0 0 !important; }
        .badge-pill { border-radius: 20px; padding: 6px 12px; font-weight: 600; }
        .task-card { border-radius: 12px; border: 1px solid #e2e8f0; background-color: white; }
        .check-btn { width: 36px; height: 36px; border-radius: 50%; border: 2px solid #cbd5e1; background: transparent; cursor: pointer; }
        .check-btn.completed { background-color: #10b981; border-color: #10b981; color: white; }
    </style>
</head>
<body class="py-5">
<div class="container" style="max-width: 750px;">
    <div class="card shadow-lg border-0" style="border-radius: 15px;">
        <div class="card-header card-header-orange p-4 text-center">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="badge bg-white text-dark badge-pill"><i class="bi bi-cpu me-1"></i> Kubernetes Native</span>
                <span class="badge bg-dark badge-pill"><i class="bi bi-database me-1"></i> PostgreSQL Operator</span>
            </div>
            <h2 class="fw-bold mb-1"><i class="bi bi-cloud-upload me-2"></i>vMind Task Center</h2>
            <p class="mb-0 opacity-75">Cloud Infrastructure & Automated S3 Backup Pipeline</p>
        </div>
        <div class="card-body p-4">
            <div class="row g-3 mb-4 text-center">
                <div class="col-6">
                    <div class="p-3 bg-light rounded-3">
                        <small class="text-muted fw-bold d-block mb-1">TOPLAM GÖREV</small>
                        <h3 class="fw-bold mb-0">{{ todos|length if todos else 0 }}</h3>
                    </div>
                </div>
                <div class="col-6">
                    <div class="p-3 bg-light rounded-3">
                        <small class="text-muted fw-bold d-block mb-1">S3 BACKUP STATUS</small>
                        <span class="text-success fw-bold"><i class="bi bi-shield-check me-1"></i>Aktif (Betap)</span>
                    </div>
                </div>
            </div>

            <!-- FORM -->
            <form action="/add" method="POST" class="mb-4 p-3 border rounded-3 bg-light">
                <div class="mb-3">
                    <label class="form-label fw-bold text-dark">Görev Başlığı:</label>
                    <input type="text" name="title" class="form-control form-control-lg" placeholder="vMind bulut altyapısı için yeni görev..." required>
                </div>
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-secondary mb-1">📅 Başlangıç Tarihi & Saati:</label>
                        <input type="datetime-local" name="start_time" class="form-control" style="border: 2px solid #ff6600;">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-secondary mb-1">🏁 Planlanan Bitiş Tarihi:</label>
                        <input type="datetime-local" name="end_time" class="form-control" style="border: 2px solid #ff6600;">
                    </div>
                </div>
                <button class="btn btn-warning text-white fw-bold w-100 py-2" type="submit" style="background-color: #ff6600; border: none;">
                    <i class="bi bi-plus-circle me-1"></i> Görevi Kaydet
                </button>
            </form>

            <!-- LISTE -->
            <div class="task-list d-flex flex-column gap-3">
                {% for task in todos %}
                <div class="task-card p-3 d-flex align-items-center justify-content-between">
                    <form action="/toggle/{{ task.id }}" method="POST" class="m-0">
                        <button type="submit" class="check-btn {{ 'completed' if task.completed }}">
                            <i class="bi bi-check-lg"></i>
                        </button>
                    </form>
                    <div class="ms-3 flex-grow-1">
                        <div class="fw-bold text-dark fs-6 {{ 'text-decoration-line-through text-muted' if task.completed }}">{{ task.title }}</div>
                        <div class="d-flex flex-wrap align-items-center gap-2 mt-1" style="font-size: 0.82rem;">
                            <span class="text-muted"><i class="bi bi-clock me-1"></i>ID: #{{ task.id }}</span>
                            {% if task.start_time or task.end_time %}
                            <span class="badge bg-primary text-white">
                                📅 {{ task.start_time if task.start_time else '—' }} ➔ {{ task.end_time if task.end_time else '—' }}
                            </span>
                            {% endif %}
                            {% if task.completed and task.completed_at %}
                            <span class="badge bg-success text-white">
                                ✅ Tamamlandı: {{ task.completed_at }}
                            </span>
                            {% endif %}
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-warning text-dark px-3">Production</span>
                        <a href="/delete/{{ task.id }}" class="btn btn-link text-danger p-0 ms-2"><i class="bi bi-trash fs-5"></i></a>
                    </div>
                </div>
                {% endfor %}
            </div>
        </div>
        <div class="card-footer bg-dark text-white p-3 d-flex justify-content-around text-center" style="border-radius: 0 0 15px 15px;">
            <small><i class="bi bi-hdd-network text-warning me-1"></i> Persistent Volume: 5GB</small>
            <small><i class="bi bi-cloud-arrow-up text-info me-1"></i> Object Storage: S3 PortVMind</small>
        </div>
    </div>
</div>
</body>
</html>
EOF

cat << 'EOF' > Dockerfile
FROM python:3.9-slim
WORKDIR /app
RUN pip install --no-cache-dir flask psycopg2-binary
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
EOF

cp ~/todo-app/app.py . 2>/dev/null || cp ~/app.py .
sudo docker build -t todo-app-fix:v99 .
sudo docker save todo-app-fix:v99 | sudo k3s ctr -n k8s.io images import -
kubectl set image deployment/todo-app-deployment todo-app=todo-app-fix:v99 -n todo-production
cd ..
sudo docker build -t todo-app-fix:v100 .
sudo docker save todo-app-fix:v100 | sudo k3s ctr -n k8s.io images import -
kubectl set image deployment/todo-app-deployment todo-app=todo-app-fix:v100 -n todo-production
kubectl delete pods -l app=todo-app -n todo-production
cd fix-app
sudo docker build -t todo-app-fix:v101 .
sudo docker save todo-app-fix:v101 | sudo k3s ctr -n k8s.io images import -
kubectl set image deployment/todo-app-deployment todo-app=todo-app-fix:v101 -n todo-production
kubectl delete pods -l app=todo-app -n todo-production
kubectl logs -f deployment/todo-app-deployment -n todo-production --tail=50
cat << 'EOF' > app.py
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
EOF

cat << 'EOF' > templates/index.html
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>vMind Task Center</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .card-header-orange { background-color: #ff6600; color: white; border-radius: 15px 15px 0 0 !important; }
        .badge-pill { border-radius: 20px; padding: 6px 12px; font-weight: 600; }
        .task-card { border-radius: 12px; border: 1px solid #e2e8f0; background-color: white; }
        .check-btn { width: 36px; height: 36px; border-radius: 50%; border: 2px solid #cbd5e1; background: transparent; cursor: pointer; display: flex; align-items: center; justify-content: center; }
        .check-btn.completed { background-color: #10b981; border-color: #10b981; color: white; }
    </style>
</head>
<body class="py-5">

<div class="container" style="max-width: 750px;">
    <div class="card shadow-lg border-0" style="border-radius: 15px;">
        
        <div class="card-header card-header-orange p-4 text-center">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="badge bg-white text-dark badge-pill"><i class="bi bi-cpu me-1"></i> Kubernetes Native</span>
                <span class="badge bg-dark badge-pill"><i class="bi bi-database me-1"></i> PostgreSQL Operator</span>
            </div>
            <h2 class="fw-bold mb-1"><i class="bi bi-cloud-upload me-2"></i>vMind Task Center</h2>
            <p class="mb-0 opacity-75">Cloud Infrastructure & Automated S3 Backup Pipeline</p>
        </div>

        <div class="card-body p-4">
            
            <div class="row g-3 mb-4 text-center">
                <div class="col-6">
                    <div class="p-3 bg-light rounded-3">
                        <small class="text-muted fw-bold d-block mb-1">TOPLAM GÖREV</small>
                        <h3 class="fw-bold mb-0">{{ todos|length }}</h3>
                    </div>
                </div>
                <div class="col-6">
                    <div class="p-3 bg-light rounded-3">
                        <small class="text-muted fw-bold d-block mb-1">S3 BACKUP STATUS</small>
                        <span class="text-success fw-bold"><i class="bi bi-shield-check me-1"></i>Aktif (Betap)</span>
                    </div>
                </div>
            </div>

            <!-- GÖREV EKLEME FORMU -->
            <form action="/add" method="POST" class="mb-4 p-3 border rounded-3 bg-light">
                <div class="mb-3">
                    <label class="form-label fw-bold text-dark">Görev Başlığı:</label>
                    <input type="text" name="title" class="form-control form-control-lg" placeholder="vMind bulut altyapısı için yeni görev..." required>
                </div>
                
                <div class="row g-3 mb-3">
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-secondary mb-1">📅 Başlangıç Tarihi & Saati:</label>
                        <input type="datetime-local" name="start_time" class="form-control" style="border: 2px solid #ff6600;">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-secondary mb-1">🏁 Planlanan Bitiş Tarihi:</label>
                        <input type="datetime-local" name="end_time" class="form-control" style="border: 2px solid #ff6600;">
                    </div>
                </div>

                <button class="btn btn-warning text-white fw-bold w-100 py-2" type="submit" style="background-color: #ff6600; border: none;">
                    <i class="bi bi-plus-circle me-1"></i> Görevi Kaydet
                </button>
            </form>

            <!-- GÖREV LİSTESİ -->
            <div class="task-list d-flex flex-column gap-3">
                {% for task in todos %}
                <div class="task-card p-3 d-flex align-items-center justify-content-between">
                    
                    <!-- Tik Atma / Tamamlama -->
                    <form action="/toggle/{{ task.id }}" method="POST" class="m-0">
                        <button type="submit" class="check-btn {{ 'completed' if task.completed }}">
                            <i class="bi bi-check-lg"></i>
                        </button>
                    </form>

                    <!-- Detaylar -->
                    <div class="ms-3 flex-grow-1">
                        <div class="fw-bold text-dark fs-6 {{ 'text-decoration-line-through text-muted' if task.completed }}">{{ task.title }}</div>
                        
                        <div class="d-flex flex-wrap align-items-center gap-2 mt-1" style="font-size: 0.82rem;">
                            <span class="text-muted"><i class="bi bi-clock me-1"></i>ID: #{{ task.id }}</span>
                            
                            <span class="badge bg-primary text-white">
                                📅 {{ task.start_time if task.start_time else '—' }} ➔ {{ task.end_time if task.end_time else '—' }}
                            </span>

                            {% if task.completed and task.completed_at %}
                            <span class="badge bg-success text-white">
                                ✅ Tamamlandı: {{ task.completed_at }}
                            </span>
                            {% endif %}
                        </div>
                    </div>

                    <!-- Silme -->
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge bg-warning text-dark px-3">Production</span>
                        <a href="/delete/{{ task.id }}" class="btn btn-link text-danger p-0 ms-2"><i class="bi bi-trash fs-5"></i></a>
                    </div>

                </div>
                {% endfor %}
            </div>

        </div>

        <div class="card-footer bg-dark text-white p-3 d-flex justify-content-around text-center" style="border-radius: 0 0 15px 15px;">
            <small><i class="bi bi-hdd-network text-warning me-1"></i> Persistent Volume: 5GB</small>
            <small><i class="bi bi-cloud-arrow-up text-info me-1"></i> Object Storage: S3 PortVMind</small>
        </div>

    </div>
</div>

</body>
</html>
EOF

sudo docker build -t todo-app-fix:v200 .
sudo docker save todo-app-fix:v200 | sudo k3s ctr -n k8s.io images import -
kubectl set image deployment/todo-app-deployment todo-app=todo-app-fix:v200 -n todo-production
kubectl delete pods -l app=todo-app -n todo-production
mkdir -p ~/.kube
nano ~/.kube/config
chmod 600 ~/.kube/config
kubectl get nodes
nano ~/.kube/config
chmod 600 ~/.kube/config
kubectl get nodes
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
source ~/.bashrc
kubectl get nodes
sudo systemctl status jenkins
sudo docker ps -a
kubectl --kubeconfig=/etc/rancher/k3s/k3s.yaml get pods -A
sudo ss -tulpn
