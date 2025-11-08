package org.example.evidence1.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import org.example.evidence1.util.IACCalculator;

/**
 * Filtro para validar y normalizar la entrada del cálculo IAC.
 * Si la entrada no es válida, reenvía a calculator.jsp con el mensaje de error.
 * Si es válida, deja parámetros normalizados en atributos para el controlador.
 */
public class IACInputValidationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String nombre = request.getParameter("nombre");
            String edadStr = request.getParameter("edad");
            String sexo = request.getParameter("sexo");
            // Alinear con nombres del formulario en calculator.jsp
            String estaturaStr = request.getParameter("estatura_m");
            String pesoStr = request.getParameter("peso_kg");
            String caderaStr = request.getParameter("hip_cm");

            // Validar obligatorios
            if (isBlank(nombre) || isBlank(edadStr) || isBlank(sexo) || isBlank(estaturaStr) || isBlank(caderaStr)) {
                request.setAttribute("error", "Todos los campos son obligatorios excepto el peso.");
                request.getRequestDispatcher("/WEB-INF/views/calculator.jsp").forward(request, response);
                return;
            }

            // Parseo seguro
            Integer edad;
            Double estatura;
            Double cadera;
            Double peso = null;
            try {
                edad = Integer.parseInt(edadStr.trim());
                estatura = Double.parseDouble(estaturaStr.trim());
                cadera = Double.parseDouble(caderaStr.trim());
                if (!isBlank(pesoStr)) {
                    peso = Double.parseDouble(pesoStr.trim());
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Por favor, ingrese valores numéricos válidos.");
                request.getRequestDispatcher("/WEB-INF/views/calculator.jsp").forward(request, response);
                return;
            }

            // Validación de rangos
            if (edad < 1 || edad > 120) {
                request.setAttribute("error", "La edad debe estar entre 1 y 120 años.");
                request.getRequestDispatcher("/WEB-INF/views/calculator.jsp").forward(request, response);
                return;
            }

            if (!IACCalculator.validarParametros(cadera, estatura)) {
                request.setAttribute("error", "Los valores de estatura y circunferencia de cadera no son válidos.");
                request.getRequestDispatcher("/WEB-INF/views/calculator.jsp").forward(request, response);
                return;
            }

            if (peso != null && (peso <= 0 || peso > 500)) {
                request.setAttribute("error", "El peso debe estar entre 1 y 500 kg.");
                request.getRequestDispatcher("/WEB-INF/views/calculator.jsp").forward(request, response);
                return;
            }

            // Normalizar y exponer atributos para el controlador
            request.setAttribute("nombre", nombre.trim());
            request.setAttribute("edad", edad);
            request.setAttribute("sexo", sexo.toUpperCase());
            request.setAttribute("estatura", estatura);
            request.setAttribute("peso", peso);
            request.setAttribute("cadera", cadera);
        }

        chain.doFilter(req, res);
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}