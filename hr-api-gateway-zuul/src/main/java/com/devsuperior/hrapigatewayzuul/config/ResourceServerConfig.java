package com.devsuperior.hrapigatewayzuul.config;

import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity;
import org.springframework.security.config.web.server.ServerHttpSecurity;
import org.springframework.security.web.server.SecurityWebFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource;

@Configuration
@EnableWebFluxSecurity
public class ResourceServerConfig {

	private static final String[] PUBLIC = { "/hr-oauth/**", "/actuator/**" };

	private static final String[] OPERATOR = { "/hr-worker/**" };

	private static final String[] ADMIN = { "/hr-payroll/**", "/hr-user/**" };

	@Bean
	public SecurityWebFilterChain securityWebFilterChain(ServerHttpSecurity http) {
		return http
			.authorizeExchange(exchange -> exchange
				.pathMatchers(PUBLIC).permitAll()
				.pathMatchers(HttpMethod.GET, OPERATOR).hasAnyAuthority("SCOPE_operator", "SCOPE_admin")
				.pathMatchers(ADMIN).hasAuthority("SCOPE_admin")
				.anyExchange().authenticated())
			.oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
			.cors(cors -> cors.configurationSource(corsConfigurationSource()))
			.csrf(ServerHttpSecurity.CsrfSpec::disable)
			.build();
	}

	@Bean
	public UrlBasedCorsConfigurationSource corsConfigurationSource() {
		CorsConfiguration corsConfig = new CorsConfiguration();
		corsConfig.setAllowedOriginPatterns(List.of("*"));
		corsConfig.setAllowedMethods(List.of("POST", "GET", "PUT", "DELETE", "PATCH"));
		corsConfig.setAllowCredentials(true);
		corsConfig.setAllowedHeaders(List.of("Authorization", "Content-Type"));

		UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
		source.registerCorsConfiguration("/**", corsConfig);
		return source;
	}
}
