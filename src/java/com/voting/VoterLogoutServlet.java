package com.voting;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

public class VoterLogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Remove all session attributes
            session.removeAttribute("voterId");
            session.removeAttribute("voterName");
            // Invalidate the session completely
            session.invalidate();
        }
        
        // Prevent caching of protected pages
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        
        // Redirect to voter login page
        response.sendRedirect("voter-login.jsp");
    }
}