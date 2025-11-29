package com.aiplatform.controller;

import com.aiplatform.dao.UserDAO;
import com.aiplatform.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

// This URL "/login" matches the form action in login.jsp
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Get data from the form
        String email = request.getParameter("email");
        String pass = request.getParameter("password");

        // 2. Check database
        UserDAO userDAO = new UserDAO();
        User user = userDAO.login(email, pass);

        if (user != null) {
            // 3. Login Success: Create a Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());

            // 4. Redirect based on Role
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("researcher_dashboard.jsp");
            }
        } else {
            // 5. Login Failed
            response.sendRedirect("login.jsp?error=Invalid Credentials");
        }
    }
}