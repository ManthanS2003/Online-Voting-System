package com.voting;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Check if it's admin or voter based on session attributes
            boolean isAdmin = session.getAttribute("adminId") != null;
            
            // Invalidate the session
            session.invalidate();
            
            // Redirect based on user type
            if (isAdmin) {
                response.sendRedirect("admin-login.jsp");
            } else {
                response.sendRedirect("voter-login.jsp");
            }
        } else {
            // If no session, redirect to home page
            response.sendRedirect("index.html");
        }
    }
}