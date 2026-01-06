package com.mbtibackend.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                // REST API CORS 설정
                registry.addMapping("/api/**")
                        .allowedOrigins(
//                                "*",
                                "http://localhost:3000", // IOS 테스트 8080
                                "http://localhost:3001",
                                "http://localhost:55170",
                                "http://10.0.2.2:8080" // 안드로이드 핸드폰 테스트
                        )
                        .allowCredentials(true)
//                        .allowCredentials(false)  // * 와 함께 쓸 때는 false여야 함
                        .allowedMethods("GET","POST","PUT","DELETE","PATCH","OPTIONS")
                        .allowedHeaders("*");
            }
        };
    }
}
