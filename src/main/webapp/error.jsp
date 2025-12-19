<%@ page isErrorPage="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>System Error - Team Visionary</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light d-flex align-items-center justify-content-center min-vh-100">
    <div class="text-center">
        <i class="fas fa-exclamation-triangle fa-5x text-warning mb-4"></i>
        <h1 class="display-4 fw-bold text-dark">Oops!</h1>
        <p class="lead text-muted">Something unexpected happened or the page doesn't exist.</p>

        <div class="card shadow-sm mx-auto p-3 mt-4" style="max-width: 600px;">
            <p class="text-danger mb-0">
                <strong>Error Details:</strong> <%= exception != null ? exception.getMessage() : "Unknown Error (404)" %>
            </p>
        </div>

        <a href="login.jsp" class="btn btn-primary btn-lg mt-4">
            <i class="fas fa-home me-2"></i> Return to Safety
        </a>
    </div>
</body>
</html>