package com.aiplatform.controller;

import com.aiplatform.dao.*;
import com.aiplatform.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@WebServlet("/researcher/action")
@MultipartConfig
public class ResearcherController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String msg = "";

        // 1. DATASET UPLOAD
        if ("uploadDataset".equals(action)) {
            DatasetDAO dao = new DatasetDAO();
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            Part filePart = request.getPart("file");
            String fileName = filePart.getSubmittedFileName();

            // Save File to Server
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            try (InputStream input = filePart.getInputStream()) {
                Files.copy(input, new File(uploadPath + File.separator + fileName).toPath(), StandardCopyOption.REPLACE_EXISTING);
            } catch (Exception e) { e.printStackTrace(); }

            // Save to DB
            boolean success = dao.addDataset(name, description, fileName, user.getId());
            msg = success ? "Dataset Uploaded Successfully!" : "Upload Failed";
        }

        // 2. MODEL TRAINING
        else if ("trainModel".equals(action)) {
            ExperimentDAO dao = new ExperimentDAO();
            boolean success = dao.startTraining(user.getId(), request.getParameter("model"), request.getParameter("params"));
            msg = success ? "Training Started..." : "Failed to start training";
        }

        // 3. COLLABORATION
        else if ("collaborate".equals(action)) {
            String email = request.getParameter("email");
            String projIdStr = request.getParameter("project");
            if (projIdStr != null && !projIdStr.isEmpty()) {
                int projectId = Integer.parseInt(projIdStr);
                UserDAO userDAO = new UserDAO();
                int friendId = userDAO.getUserIdByEmail(email);
                if (friendId != -1) {
                    ProjectDAO projectDAO = new ProjectDAO();
                    boolean success = projectDAO.addProjectMember(projectId, friendId);
                    msg = success ? "Collaborator Added Successfully!" : "Failed to add member";
                } else { msg = "User with email " + email + " not found!"; }
            }
        }

        // 4. PROFILE UPDATE
        else if ("updateProfile".equals(action)) {
            String newName = request.getParameter("name");
            String newPass = request.getParameter("password");
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.updateProfile(user.getId(), newName, newPass);
            if (success) {
                User updatedUser = new User(user.getId(), newName, user.getEmail(), user.getRole());
                session.setAttribute("user", updatedUser);
                msg = "Profile Updated Successfully!";
            }
        }

        // 5. NEW: DELETE DATASET
        else if ("deleteDataset".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            DatasetDAO dao = new DatasetDAO();
            boolean success = dao.deleteDataset(id);
            msg = success ? "Dataset Deleted Successfully!" : "Delete Failed.";
        }

        // 6. NEW: UPDATE DATASET
        else if ("updateDataset".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String desc = request.getParameter("description");
            DatasetDAO dao = new DatasetDAO();
            boolean success = dao.updateDataset(id, name, desc);
            msg = success ? "Dataset Updated Successfully!" : "Update Failed.";
        }

        response.sendRedirect("../researcher_dashboard.jsp?msg=" + msg);
    }
}