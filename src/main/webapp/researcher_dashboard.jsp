<%
    // Security Check: If user is not logged in, kick them out
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp?error=unauthorized");
        return;
    }
%>
<%@ page import="com.aiplatform.dao.*, com.aiplatform.model.User, java.util.List" %>
<%
    // 1. Security Check
    User user = (User) session.getAttribute("user");
    if (user == null || !"RESEARCHER".equals(user.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. Fetch Datasets
    DatasetDAO datasetDAO = new DatasetDAO();
    List<String[]> datasets = datasetDAO.getMyDatasets(user.getId());

    // 3. Fetch Experiments (Triggers the time-check simulation first)
    ExperimentDAO expDAO = new ExperimentDAO();
    List<String[]> experiments = expDAO.getMyExperiments(user.getId());

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Researcher Lab | Team Visionary</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; padding-bottom: 60px; position: relative; min-height: 100vh;}
        .navbar { background-color: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 24px; }
        .card-header { background: transparent; border-bottom: 1px solid #f0f0f0; padding: 20px; font-weight: 600; font-size: 1.1rem; }
        .btn-upload { background: #6f42c1; color: white; }
        .btn-upload:hover { background: #59359a; color: white; }
        .footer { position: absolute; bottom: 0; width: 100%; height: 60px; line-height: 60px; background: #fff; text-align: center; border-top: 1px solid #eee; color: #6c757d; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light px-4">
        <a class="navbar-brand fw-bold text-primary" href="#"><i class="fas fa-brain"></i> Team Visionary Lab</a>
        <div class="ms-auto d-flex align-items-center">
            <span class="me-3 text-secondary">Dr. <%= user.getName() %></span>
            <a href="logout.jsp" class="btn btn-outline-danger btn-sm">Logout</a>
        </div>
    </nav>

    <div class="container py-4">
        <% if(msg != null) { %>
            <div class="alert alert-info text-center shadow-sm alert-dismissible fade show">
                <%= msg %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <div class="col-lg-4">

                <div class="card">
                    <div class="card-header text-purple"><i class="fas fa-database me-2"></i> Upload Dataset</div>
                    <div class="card-body">
                        <form action="researcher/action" method="post" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="uploadDataset">

                            <div class="mb-3">
                                <label class="form-label">Dataset Name</label>
                                <input type="text" name="name" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Select File</label>
                                <input type="file" name="file" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea name="description" class="form-control" rows="2"></textarea>
                            </div>

                            <button class="btn btn-upload w-100">Upload</button>
                        </form>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header text-primary"><i class="fas fa-users me-2"></i> Collaborate</div>
                    <div class="card-body">
                        <form action="researcher/action" method="post">
                            <input type="hidden" name="action" value="collaborate">
                            <div class="input-group mb-2">
                                <input type="text" name="project" class="form-control" placeholder="Project ID">
                                <input type="email" name="email" class="form-control" placeholder="User Email">
                            </div>
                            <button class="btn btn-primary w-100 btn-sm">Invite</button>
                        </form>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header"><i class="fas fa-user-cog me-2"></i> Profile</div>
                    <div class="card-body">
                        <form action="researcher/action" method="post">
                            <input type="hidden" name="action" value="updateProfile">
                            <input type="text" name="name" value="<%= user.getName() %>" class="form-control mb-2">
                            <input type="password" name="password" placeholder="New Password" class="form-control mb-2">
                            <button class="btn btn-secondary w-100 btn-sm">Update</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">

                <div class="card border-primary mb-4" style="border-width: 2px;">
                    <div class="card-body d-flex align-items-center justify-content-between bg-light rounded">
                        <div>
                            <h5 class="mb-1"><i class="fas fa-robot text-primary"></i> Train New Model</h5>
                            <small>Select architecture and hyper-parameters</small>
                        </div>
                        <form action="researcher/action" method="post" class="d-flex gap-2">
                            <input type="hidden" name="action" value="trainModel">
                            <select name="model" class="form-select" style="width: 150px;">
                                <option>ResNet-50</option>
                                <option>YOLOv8</option>
                                <option>BERT</option>
                            </select>
                            <input type="text" name="params" class="form-control" placeholder="Epochs=100" style="width: 150px;" required>
                            <button class="btn btn-primary">Start</button>
                        </form>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header border-warning text-warning bg-light">
                        <i class="fas fa-microchip me-2"></i> Active Training Jobs
                    </div>
                    <div class="card-body p-0">
                        <table class="table mb-0" id="activeJobsTable">
                            <thead><tr><th>ID</th><th>Model</th><th>Params</th><th>Status</th><th>Est. Time</th></tr></thead>
                            <tbody>
                                <%
                                boolean hasActive = false;
                                for(String[] e : experiments) {
                                    if(e[3].contains("Training")) {
                                        hasActive = true;
                                %>
                                <tr class="training-row">
                                    <td>#<%= e[0] %></td>
                                    <td><%= e[1] %></td>
                                    <td><small class="text-muted"><%= e[2] %></small></td>
                                    <td><span class="badge bg-warning text-dark"><i class="fas fa-spinner fa-spin"></i> Training...</span></td>
                                    <td><small class="text-muted">~15 sec</small></td>
                                </tr>
                                <%  }
                                }
                                if(!hasActive) { %>
                                    <tr><td colspan="5" class="text-center text-muted p-3">No models currently training.</td></tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card mb-4">
                    <div class="card-header text-success bg-light">
                        <i class="fas fa-history me-2"></i> Experiment History
                    </div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0">
                            <thead><tr><th>ID</th><th>Model</th><th>Params</th><th>Status</th><th>Accuracy Score</th></tr></thead>
                            <tbody>
                                <% for(String[] e : experiments) {
                                    if(!e[3].contains("Training")) {
                                %>
                                <tr>
                                    <td>#<%= e[0] %></td>
                                    <td><%= e[1] %></td>
                                    <td><small class="text-muted"><%= e[2] %></small></td>
                                    <td><span class="badge bg-success"><i class="fas fa-check-circle"></i> Completed</span></td>
                                    <td><strong class="text-dark"><%= e[4] %></strong></td>
                                </tr>
                                <%  }
                                } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">My Datasets</div>
                    <div class="card-body p-0">
                        <table class="table table-hover mb-0">
                            <thead><tr><th>Name</th><th>File (Click to View)</th><th>Description</th><th class="text-center">Actions</th></tr></thead>
                            <tbody>
                                <% for(String[] d : datasets) { %>
                                <tr>
                                    <td class="fw-bold"><%= d[1] %></td>
                                    <td>
                                        <a href="uploads/<%= d[3] %>" target="_blank" class="text-decoration-none">
                                            <i class="fas fa-file-download text-primary me-1"></i> <%= d[3] %>
                                        </a>
                                    </td>
                                    <td><%= d[2] %></td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-warning me-1"
                                            onclick="openEditModal('<%= d[0] %>', '<%= d[1] %>', '<%= d[2] %>')">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <form action="researcher/action" method="post" style="display:inline;">
                                            <input type="hidden" name="action" value="deleteDataset">
                                            <input type="hidden" name="id" value="<%= d[0] %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" onclick="return confirm('Delete this dataset?');">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <div class="footer">
        &copy; <%= java.time.Year.now().getValue() %> <strong>Team Visionary</strong>. All Rights Reserved.
    </div>

    <div class="modal fade" id="editModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="researcher/action" method="post">
                    <input type="hidden" name="action" value="updateDataset">
                    <input type="hidden" name="id" id="edit-id">
                    <div class="modal-header">
                        <h5 class="modal-title">Edit Dataset</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label>Dataset Name</label>
                            <input type="text" name="name" id="edit-name" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label>Description</label>
                            <textarea name="description" id="edit-desc" class="form-control" rows="3"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </div>
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

    <script>
        // Check if the page has a 'training-row' class (added in the loop above)
        if (document.querySelector('.training-row')) {
            console.log("Training in progress... Auto-refreshing in 5s");
            setTimeout(function() {
                window.location.reload();
            }, 5000); // 5000ms = 5 seconds
        }
    </script>
</body>
</html>