<%
    // Security Check: If user is not logged in, kick them out
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return;
    }
%>
<%@ page import="com.aiplatform.dao.*, com.aiplatform.model.User, java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) { response.sendRedirect("login.jsp"); return; }

    UserDAO userDAO = new UserDAO(); List<User> users = userDAO.getAllUsers();
    ResourceDAO resourceDAO = new ResourceDAO(); List<String[]> resources = resourceDAO.getAllResources();
    ProjectDAO projectDAO = new ProjectDAO(); List<String[]> projects = projectDAO.getAllProjects();
    UsageDAO usageDAO = new UsageDAO(); List<String[]> logs = usageDAO.getUsageStats();

    // NEW: Fetch ALL Datasets
    DatasetDAO datasetDAO = new DatasetDAO();
    List<String[]> allDatasets = datasetDAO.getAllDatasets();

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Admin Dashboard | Team Visionary</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .sidebar { height: 100vh; position: fixed; top: 0; left: 0; width: 250px; background-color: #212529; color: white; padding: 20px; z-index: 100;}
        .sidebar a { color: #adb5bd; text-decoration: none; display: block; padding: 10px; margin-bottom: 5px; border-radius: 5px; }
        .sidebar a:hover, .sidebar a.active { background-color: #0d6efd; color: white; }
        .main-content { margin-left: 250px; padding: 30px; padding-bottom: 60px; }
        .card { border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 20px; }
        .card-header { background-color: white; border-bottom: 1px solid #eee; font-weight: bold; color: #333; }
        .stat-card { border-left: 4px solid #0d6efd; }
        .footer { position: fixed; bottom: 0; left: 250px; right: 0; background: #fff; padding: 15px; text-align: center; border-top: 1px solid #eee; color: #6c757d; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h5 class="mb-4"><i class="fas fa-brain text-primary"></i> Team Visionary</h5>
        <a href="#" class="active"><i class="fas fa-tachometer-alt me-2"></i> Dashboard</a>
        <a href="#users"><i class="fas fa-users me-2"></i> Users</a>
        <a href="#resources"><i class="fas fa-server me-2"></i> Resources</a>
        <a href="#datasets"><i class="fas fa-database me-2"></i> Datasets</a> <a href="#projects"><i class="fas fa-project-diagram me-2"></i> Projects</a>
        <a href="logout.jsp" class="mt-5 text-danger"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
    </div>

    <div class="main-content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3>System Overview</h3>
            <span class="text-muted">Welcome, <%= user.getName() %></span>
        </div>
        <% if(msg != null) { %>
            <div class="alert alert-success alert-dismissible fade show"><i class="fas fa-check-circle me-2"></i> <%= msg %> <button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>
        <% } %>

        <div class="row mb-4">
            <% for(String[] log : logs) { %>
            <div class="col-md-4"><div class="card stat-card p-3"><h6 class="text-muted"><%= log[0] %></h6><h3><%= log[1] %>% <small class="text-muted fs-6">Usage</small></h3><div class="progress" style="height: 5px;"><div class="progress-bar" style="width: <%= log[1] %>%"></div></div></div></div>
            <% } %>
        </div>

        <div class="card" id="users">
            <div class="card-header">User Management</div>
            <div class="card-body">
                <form action="admin/action" method="post" class="row g-3 mb-4">
                    <input type="hidden" name="action" value="addUser">
                    <div class="col-md-3"><input type="text" name="name" class="form-control" placeholder="Full Name" required></div>
                    <div class="col-md-3"><input type="email" name="email" class="form-control" placeholder="Email" required></div>
                    <div class="col-md-3"><select name="role" class="form-select"><option value="RESEARCHER">Researcher</option><option value="ADMIN">Admin</option></select></div>
                    <div class="col-md-3"><button type="submit" class="btn btn-primary w-100"><i class="fas fa-plus"></i> Create User</button></div>
                </form>
                <table class="table table-hover"><thead class="table-light"><tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Action</th></tr></thead><tbody><% for(User u : users) { %><tr><td><%= u.getId() %></td><td><%= u.getName() %></td><td><%= u.getEmail() %></td><td><span class="badge bg-secondary"><%= u.getRole() %></span></td><td><form action="admin/action" method="post"><input type="hidden" name="action" value="deleteUser"><input type="hidden" name="id" value="<%= u.getId() %>"><button class="btn btn-sm btn-outline-danger"><i class="fas fa-trash"></i></button></form></td></tr><% } %></tbody></table>
            </div>
        </div>

        <div class="card" id="resources">
            <div class="card-header">Resource Management</div>
            <div class="card-body">
                <form action="admin/action" method="post" class="row g-3 mb-3"><input type="hidden" name="action" value="addResource"><div class="col-md-4"><input type="text" name="type" class="form-control" placeholder="Type (e.g. GPU A100)" required></div><div class="col-md-4"><input type="text" name="capacity" class="form-control" placeholder="Capacity (e.g. 80GB)" required></div><div class="col-md-4"><button type="submit" class="btn btn-success w-100">Add Resource</button></div></form>
                <table class="table table-bordered"><thead><tr><th>ID</th><th>Type</th><th>Capacity</th><th>Status</th></tr></thead><tbody><% for(String[] r : resources) { %><tr><td><%= r[0] %></td><td><%= r[1] %></td><td><%= r[2] %></td><td class="text-success"><%= r[3] %></td></tr><% } %></tbody></table>
            </div>
        </div>

        <div class="card" id="datasets">
            <div class="card-header text-white bg-secondary">Global Dataset Management</div>
            <div class="card-body">
                <table class="table table-hover align-middle">
                    <thead><tr><th>ID</th><th>Dataset Name</th><th>Uploaded By</th><th>File</th><th>Description</th><th class="text-center">Admin Actions</th></tr></thead>
                    <tbody>
                        <% for(String[] d : allDatasets) { %>
                        <tr>
                            <td>#<%= d[0] %></td>
                            <td class="fw-bold"><%= d[1] %></td>
                            <td><span class="badge bg-info text-dark"><i class="fas fa-user"></i> <%= d[4] %></span></td>
                            <td><a href="uploads/<%= d[3] %>" target="_blank" class="text-decoration-none"><i class="fas fa-file-download text-primary me-1"></i> <%= d[3] %></a></td>
                            <td><%= d[2] %></td>
                            <td class="text-center">
                                <button class="btn btn-sm btn-outline-warning me-1" onclick="openEditModal('<%= d[0] %>', '<%= d[1] %>', '<%= d[2] %>')"><i class="fas fa-edit"></i></button>
                                <form action="admin/action" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="deleteDataset">
                                    <input type="hidden" name="id" value="<%= d[0] %>">
                                    <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Admin Delete: Are you sure?');"><i class="fas fa-trash"></i></button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="card" id="projects">
            <div class="card-header">Project Management</div>
            <div class="card-body">
                <form action="admin/action" method="post" class="input-group mb-3"><input type="hidden" name="action" value="addProject"><input type="text" name="title" class="form-control" placeholder="Project Title" required><input type="text" name="description" class="form-control" placeholder="Project Description" required><button class="btn btn-primary" type="submit">Create Project</button></form>
                <ul class="list-group list-group-flush"><% for(String[] p : projects) { %><li class="list-group-item d-flex justify-content-between align-items-center"><div><strong><%= p[1] %></strong><br><small class="text-muted"><%= p[2] %></small></div><span class="badge bg-primary rounded-pill">ID: <%= p[0] %></span></li><% } %></ul>
            </div>
        </div>
    </div>

    <div class="footer">&copy; <%= java.time.Year.now().getValue() %> <strong>Team Visionary</strong>. All Rights Reserved.</div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="admin/action" method="post">
                    <input type="hidden" name="action" value="updateDataset">
                    <input type="hidden" name="id" id="edit-id">
                    <div class="modal-header"><h5 class="modal-title">Admin Edit Dataset</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                    <div class="modal-body">
                        <div class="mb-3"><label>Dataset Name</label><input type="text" name="name" id="edit-name" class="form-control" required></div>
                        <div class="mb-3"><label>Description</label><textarea name="description" id="edit-desc" class="form-control" rows="3"></textarea></div>
                    </div>
                    <div class="modal-footer"><button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button><button type="submit" class="btn btn-primary">Save Changes</button></div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function openEditModal(id, name, desc) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-name').value = name;
            document.getElementById('edit-desc').value = desc;
            var myModal = new bootstrap.Modal(document.getElementById('editModal'));
            myModal.show();
        }
    </script>
</body>
</html>