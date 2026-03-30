package com.fluentia;

import com.fluentia.config.DotEnvLoader;
import com.fluentia.config.FluentiaProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@SpringBootApplication
@EnableConfigurationProperties(FluentiaProperties.class)
public class FluentiaBackendApplication {

	public static void main(String[] args) {
		DotEnvLoader.load();
		SpringApplication.run(FluentiaBackendApplication.class, args);
	}

	@Bean
	public WebMvcConfigurer corsConfigurer() {
		return new WebMvcConfigurer() {
			@Override
			public void addCorsMappings(CorsRegistry registry) {
				registry.addMapping("/**")
						.allowedOrigins("http://localhost:5173", "http://localhost:3000")
						.allowedMethods("*")
						.allowedHeaders("*");
			}
		};
	}

}
