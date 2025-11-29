package com.aiplatform.controller;

import com.aiplatform.dao.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/action")
public class AdminController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String message = "";

        // 1. User Management Actions
        if ("addUser".equals(action)) {
            UserDAO dao = new UserDAO();
            boolean success = dao.addUser(request.getParameter("name"), request.getParameter("email"), "123456", request.getParameter("role"));
            message = success ? "User Created Successfully!" : "Failed to create user.";
        }
        else if ("deleteUser".equals(action)) {
            UserDAO dao = new UserDAO();
            dao.deleteUser(Integer.parseInt(request.getParameter("id")));
            message = "User Deleted.";
        }

        // 2. Resource Management Actions
        else if ("addResource".equals(action)) {
            ResourceDAO dao = new ResourceDAO();
            boolean success = dao.addResource(request.getParameter("type"), request.getParameter("capacity"));
            message = success ? "Resource Added!" : "Failed to add resource.";
        }

        // 3. Project Management Actions
        else if ("addProject".equals(action)) {
            ProjectDAO dao = new ProjectDAO();
            boolean success = dao.addProject(request.getParameter("title"), request.getParameter("description"));
            message = success ? "Project Created!" : "Failed to create project.";
        }

        // 4. NEW: Dataset Management Actions (Admin Control)
        else if ("deleteDataset".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            DatasetDAO dao = new DatasetDAO();
            boolean success = dao.deleteDataset(id);
            message = success ? "Dataset Deleted by Admin." : "Delete Failed.";
        }
        else if ("updateDataset".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String desc = request.getParameter("description");
            DatasetDAO dao = new DatasetDAO();
            boolean success = dao.updateDataset(id, name, desc);
            message = success ? "Dataset Updated by Admin." : "Update Failed.";
        }

        response.sendRedirect("../admin_dashboard.jsp?msg=" + message);
    }
}