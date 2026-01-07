package com.mbtibackend.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    /*
    Edge Chrome
    1. debug print 사용해서 개발자가 작성한 데이터나 기능 결과 확인 가능하다.
    2. 테스트 종료하고 나면 웹사이트가 필요하지 않지만 상황에 따라
       테스트 모드 웹사이트를 배포용 웹사이트로 사용할 수도 있다.
    3. 개발자가 개발하기 위한 테스트 모드이기 때문에
       실행할 때마다 서버 포트가 변경되기 때문에 일일이 수정해야 한다.
       (변경되지 않도록 서버 포트를 고정적으로 설정할 수 있다.

     */
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
