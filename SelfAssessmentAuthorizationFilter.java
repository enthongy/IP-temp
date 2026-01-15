package smilespace.filter;

import java.util.logging.Logger;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class SelfAssessmentAuthorizationFilter implements HandlerInterceptor {
    private static final Logger logger = Logger.getLogger(SelfAssessmentAuthorizationFilter.class.getName());
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        logger.info("SelfAssessmentAuthorizationInterceptor checking access to: " + requestURI);
        
        // Only intercept management URLs
        if (!(requestURI.contains("/self-assessment/manage") || 
              requestURI.contains("/self-assessment/delete") || 
              requestURI.contains("/self-assessment/export") ||
              requestURI.contains("/self-assessment/details") ||
              requestURI.contains("/self-assessment/history"))) {
            return true;
        }
        
        HttpSession session = request.getSession(false);
        
        // Check if user is logged in
        if (session == null || session.getAttribute("userId") == null) {
            logger.warning("User not logged in, redirecting to login page");
            String loginPage = contextPath + "/login";
            response.sendRedirect(loginPage);
            return false;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        
        // Check authorization: only professional, admin, or faculty can access management
        if (!isAuthorized(userRole)) {
            logger.warning("User with role " + userRole + " not authorized for: " + requestURI);
            response.sendRedirect(contextPath + "/dashboard?error=unauthorized");
            return false;
        }
        
        return true;
    }
    
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, 
                          Object handler, ModelAndView modelAndView) throws Exception {
        // Post-handle logic if needed
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, 
                               Object handler, Exception ex) throws Exception {
        // After completion logic if needed
    }
    
    private boolean isAuthorized(String userRole) {
        return "professional".equals(userRole) || "admin".equals(userRole) || "faculty".equals(userRole);
    }
}