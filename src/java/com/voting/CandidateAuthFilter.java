package com.voting;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class CandidateAuthFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        boolean isLoggedIn = (session != null && session.getAttribute("candidateId") != null);
        
        if (isLoggedIn) {
            // Candidate is logged in, continue with the request
            chain.doFilter(request, response);
        } else {
            // Candidate is not logged in, redirect to candidate login page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/candidate-login.jsp");
        }
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}