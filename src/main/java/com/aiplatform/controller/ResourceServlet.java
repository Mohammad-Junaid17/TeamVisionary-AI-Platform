package com.aiplatform.controller;

import com.aiplatform.dao.ResourceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/resource")
public class ResourceServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Security Check: Is the user logged in and is he an Admin?
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect("../login.jsp");
            return;
        }

        // 2. Get data from form
        String type = request.getParameter("type");
        String capacity = request.getParameter("capacity");

        // 3. Save to Database
        ResourceDAO dao = new ResourceDAO();
        dao.addResource(type, capacity);

        // 4. Go back to dashboard
        response.sendRedirect("../admin_dashboard.jsp");
    }
}