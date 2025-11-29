<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Team Visionary | Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.98);
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 420px;
            text-align: center;
        }
        .logo-icon { font-size: 3.5rem; color: #2a5298; margin-bottom: 10px; }
        .logo-text { color: #1e3c72; font-weight: 700; margin-bottom: 5px; letter-spacing: -0.5px;}
        .btn-primary {
            background: linear-gradient(to right, #2a5298, #1e3c72);
            border: none;
            padding: 12px;
            font-weight: 600;
            border-radius: 10px;
            transition: all 0.3s ease;
        }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(42, 82, 152, 0.4); }
        .form-control { border-radius: 10px; padding: 12px; background-color: #f8f9fa; border: 1px solid #e9ecef;}
        .form-control:focus { box-shadow: none; border-color: #2a5298; background-color: #fff;}

        /* --- NEW SLIDER/TAB STYLES --- */
        .role-toggle-container {
            background-color: #f0f2f5;
            border-radius: 30px;
            padding: 5px;
            margin-bottom: 25px;
            box-shadow: inset 0 2px 5px rgba(0,0,0,0.05);
        }
        .nav-pills .nav-link {
            color: #6c757d;
            border-radius: 25px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .nav-pills .nav-link.active {
            background-color: #2a5298;
            color: white;
            box-shadow: 0 4px 10px rgba(42, 82, 152, 0.3);
        }
        .tab-pane { animation: fadeIn 0.3s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
    <div class="login-card">
        <i class="fas fa-brain logo-icon"></i>
        <h2 class="logo-text">Team Visionary</h2>
        <p class="text-muted mb-4">AI Research & Development Platform</p>

        <div class="role-toggle-container">
            <ul class="nav nav-pills nav-fill" id="pills-tab" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="pills-admin-tab" data-bs-toggle="pill" data-bs-target="#pills-form" type="button" role="tab">
                        <i class="fas fa-user-shield me-2"></i>Admin
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="pills-researcher-tab" data-bs-toggle="pill" data-bs-target="#pills-form" type="button" role="tab">
                        <i class="fas fa-user-graduate me-2"></i>Researcher
                    </button>
                </li>
            </ul>
        </div>

        <div class="tab-content" id="pills-tabContent">
            <div class="tab-pane fade show active" id="pills-form" role="tabpanel">
                <form action="login" method="post" class="text-start">
                    <div class="mb-3">
                        <label class="form-label fw-bold text-secondary small">Email Address</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="fas fa-envelope"></i></span>
                            <input type="email" name="email" class="form-control border-start-0 ps-0" placeholder="name@example.com" required>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold text-secondary small">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0 text-muted"><i class="fas fa-lock"></i></span>
                            <input type="password" name="password" class="form-control border-start-0 ps-0" placeholder="••••••••" required>
                        </div>
                    </div>
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary">Sign In</button>
                    </div>
                    <div class="mt-3 text-center" style="min-height: 25px;">
                        <span class="text-danger small fw-bold">${param.error}</span>
                    </div>
                </form>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>