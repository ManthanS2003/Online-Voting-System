package com.voting;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class AdminAuthFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        boolean isLoggedIn = (session != null && session.getAttribute("adminId") != null);
        
        if (isLoggedIn) {
            // Admin is logged in, continue with the request
            chain.doFilter(request, response);
        } else {
            // Admin is not logged in, redirect to admin login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/admin-login.jsp");
        }
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}