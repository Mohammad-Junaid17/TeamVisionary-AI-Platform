<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Team Visionary</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">

    <div class="container d-flex justify-content-center align-items-center min-vh-100">

        <div class="card shadow-lg p-4" style="width: 400px; border-radius: 15px;">
            <div class="text-center mb-4">
                <i class="fas fa-brain fa-3x text-primary mb-2"></i>
                <h3 class="fw-bold">Team Visionary</h3>
                <p class="text-muted">AI Research Platform</p>
            </div>

            <form action="login" method="post" onsubmit="return validateForm()">

                <div class="mb-3 text-center">
                    <div class="btn-group" role="group" aria-label="Role Select">
                        <input type="radio" class="btn-check" name="role" id="admin" value="admin" checked>
                        <label class="btn btn-outline-primary" for="admin">Admin</label>

                        <input type="radio" class="btn-check" name="role" id="researcher" value="researcher">
                        <label class="btn btn-outline-primary" for="researcher">Researcher</label>
                    </div>
                </div>

                <div class="form-floating mb-3">
                    <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                    <label for="email">Email Address</label>
                    <div id="emailError" class="text-danger small mt-1" style="display:none;">Invalid email format</div>
                </div>

                <div class="form-floating mb-3">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                    <label for="password">Password</label>
                    <div id="passwordError" class="text-danger small mt-1" style="display:none;">Password must be at least 6 chars</div>
                </div>

                <div class="d-grid gap-2">
                    <button type="submit" class="btn btn-primary btn-lg">Access Portal</button>
                </div>
            </form>

            <div class="text-center mt-3">
                <small class="text-muted">Protected by TeamVisionary Security</small>
            </div>
        </div>
    </div>

    <script>
        function validateForm() {
            let email = document.getElementById("email").value;
            let password = document.getElementById("password").value;
            let isValid = true;

            // 1. Email Regex Validation
            const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailPattern.test(email)) {
                document.getElementById("emailError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("emailError").style.display = "none";
            }

            // 2. Password Length Validation
            if (password.length < 6) {
                document.getElementById("passwordError").style.display = "block";
                isValid = false;
            } else {
                document.getElementById("passwordError").style.display = "none";
            }

            return isValid;
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>