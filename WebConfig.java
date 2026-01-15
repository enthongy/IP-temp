package smilespace.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import smilespace.filter.FeedbackAuthorizationFilter;
import smilespace.filter.SelfAssessmentAuthorizationFilter;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {
    "smilespace.controller",
    "smilespace.filter"
})
public class WebConfig implements WebMvcConfigurer {
    
    @Bean
    public FeedbackAuthorizationFilter feedbackAuthorizationFilter() {
        return new FeedbackAuthorizationFilter();
    }
    
    @Bean
    public SelfAssessmentAuthorizationFilter selfAssessmentAuthorizationFilter() {
        return new SelfAssessmentAuthorizationFilter();
    }
    
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // Feedback module interceptors
        registry.addInterceptor(feedbackAuthorizationFilter())
                .addPathPatterns("/feedback/analytics/**")
                .addPathPatterns("/feedback/reply/**")
                .addPathPatterns("/feedback/resolve/**")
                .addPathPatterns("/feedback/report/**")
                .addPathPatterns("/feedback/export/**")
                .excludePathPatterns("/feedback")
                .excludePathPatterns("/feedback/submit");
        
        // Self-assessment module interceptors
        registry.addInterceptor(selfAssessmentAuthorizationFilter())
                .addPathPatterns("/self-assessment/manage/**")
                .addPathPatterns("/self-assessment/delete/**")
                .addPathPatterns("/self-assessment/export/**")
                .addPathPatterns("/self-assessment/details/**")
                .addPathPatterns("/self-assessment/history/**")
                .excludePathPatterns("/self-assessment")
                .excludePathPatterns("/self-assessment/submit")
                .excludePathPatterns("/self-assessment/result/**");
    }
    
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) { 
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/modules/");
        resolver.setSuffix(".jsp");
        registry.viewResolver(resolver);
    }
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Serve uploaded files
        String uploadPath = System.getProperty("user.dir") + "/uploads/";
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + uploadPath);
        
        // CSS resources
        registry.addResourceHandler("/css/**")
                .addResourceLocations("/css/");
        
        // JavaScript resources
        registry.addResourceHandler("/js/**")
                .addResourceLocations("/js/");
        
        // General images
        registry.addResourceHandler("/images/**")
                .addResourceLocations("/images/");

        // Module Specific resources
        registry.addResourceHandler("/modules/**")
                .addResourceLocations("/WEB-INF/views/modules/");
        
        // Static resources
        registry.addResourceHandler("/static/**")
                .addResourceLocations("/static/");
        
        // WebJars for Bootstrap, jQuery, etc.
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/");
        
        // Font Awesome
        registry.addResourceHandler("/fontawesome/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/font-awesome/6.0.0/");
        
        // Google Fonts (proxy to avoid mixed content issues)
        registry.addResourceHandler("/fonts/**")
                .addResourceLocations("classpath:/static/fonts/");
    }
}