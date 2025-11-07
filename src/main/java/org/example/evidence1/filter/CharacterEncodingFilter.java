package org.example.evidence1.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Filtro para configurar la codificación de caracteres UTF-8
 * en todas las peticiones y respuestas HTTP.
 * 
 * Este filtro asegura que todos los datos enviados y recibidos
 * utilicen la codificación UTF-8, evitando problemas con
 * caracteres especiales y acentos.
 */
@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {
    
    private String encoding = "UTF-8";
    private boolean forceEncoding = false;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Obtener parámetros de configuración del web.xml
        String encodingParam = filterConfig.getInitParameter("encoding");
        if (encodingParam != null && !encodingParam.trim().isEmpty()) {
            this.encoding = encodingParam.trim();
        }
        
        String forceEncodingParam = filterConfig.getInitParameter("forceEncoding");
        if (forceEncodingParam != null) {
            this.forceEncoding = Boolean.parseBoolean(forceEncodingParam);
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Configurar encoding para la petición
        if (forceEncoding || httpRequest.getCharacterEncoding() == null) {
            httpRequest.setCharacterEncoding(encoding);
        }
        
        // Configurar encoding para la respuesta
        if (forceEncoding || httpResponse.getCharacterEncoding() == null || 
            httpResponse.getCharacterEncoding().equals("ISO-8859-1")) {
            httpResponse.setCharacterEncoding(encoding);
        }
        
        // Configurar Content-Type para respuestas HTML/JSON si no está establecido
        String contentType = httpResponse.getContentType();
        if (contentType == null || contentType.isEmpty()) {
            String requestURI = httpRequest.getRequestURI();
            if (requestURI.endsWith(".jsp") || requestURI.endsWith(".html")) {
                httpResponse.setContentType("text/html; charset=" + encoding);
            } else if (requestURI.contains("/api/") || 
                      httpRequest.getHeader("Accept") != null && 
                      httpRequest.getHeader("Accept").contains("application/json")) {
                httpResponse.setContentType("application/json; charset=" + encoding);
            }
        }
        
        // Continuar con la cadena de filtros
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Limpieza de recursos si es necesario
    }
}