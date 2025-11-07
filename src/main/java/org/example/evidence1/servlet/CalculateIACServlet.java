package org.example.evidence1.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.example.evidence1.dao.IACDAO;
import org.example.evidence1.dao.UserDAO;
import org.example.evidence1.model.IACResult;
import org.example.evidence1.model.User;
import org.example.evidence1.util.IACCalculator;

import java.io.IOException;

/**
 * Servlet para manejar el cálculo del Índice de Adiposidad Corporal (IAC)
 */
@WebServlet(name = "CalculateIACServlet", urlPatterns = {"/calculate"})
public class CalculateIACServlet extends HttpServlet {
    
    private UserDAO userDAO;
    private IACDAO iacDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
        iacDAO = new IACDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirigir al formulario de cálculo
        response.sendRedirect(request.getContextPath() + "/calculator.jsp");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Obtener parámetros del formulario
            String nombre = request.getParameter("nombre");
            String edadStr = request.getParameter("edad");
            String sexo = request.getParameter("sexo");
            String estaturaStr = request.getParameter("estatura");
            String pesoStr = request.getParameter("peso");
            String caderaStr = request.getParameter("cadera");
            
            // Validar parámetros obligatorios
            if (nombre == null || nombre.trim().isEmpty() ||
                edadStr == null || edadStr.trim().isEmpty() ||
                sexo == null || sexo.trim().isEmpty() ||
                estaturaStr == null || estaturaStr.trim().isEmpty() ||
                caderaStr == null || caderaStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Todos los campos son obligatorios excepto el peso.");
                request.getRequestDispatcher("/calculator.jsp").forward(request, response);
                return;
            }
            
            // Convertir parámetros numéricos
            int edad;
            double estatura;
            double cadera;
            Double peso = null;
            
            try {
                edad = Integer.parseInt(edadStr.trim());
                estatura = Double.parseDouble(estaturaStr.trim());
                cadera = Double.parseDouble(caderaStr.trim());
                
                if (pesoStr != null && !pesoStr.trim().isEmpty()) {
                    peso = Double.parseDouble(pesoStr.trim());
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Por favor, ingrese valores numéricos válidos.");
                request.getRequestDispatcher("/calculator.jsp").forward(request, response);
                return;
            }
            
            // Validar rangos
            if (edad < 1 || edad > 120) {
                request.setAttribute("error", "La edad debe estar entre 1 y 120 años.");
                request.getRequestDispatcher("/calculator.jsp").forward(request, response);
                return;
            }
            
            if (!IACCalculator.validarParametros(cadera, estatura)) {
                request.setAttribute("error", "Los valores de estatura y circunferencia de cadera no son válidos.");
                request.getRequestDispatcher("/calculator.jsp").forward(request, response);
                return;
            }
            
            if (peso != null && (peso <= 0 || peso > 500)) {
                request.setAttribute("error", "El peso debe estar entre 1 y 500 kg.");
                request.getRequestDispatcher("/calculator.jsp").forward(request, response);
                return;
            }
            
            // Buscar o crear usuario
            User user = userDAO.findByName(nombre.trim());
            int userId;
            
            if (user == null) {
                // Crear nuevo usuario
                user = new User(nombre.trim(), edad, sexo.toUpperCase(), estatura, peso);
                userId = userDAO.create(user);
                
                if (userId == -1) {
                    request.setAttribute("error", "Error al crear el usuario en la base de datos.");
                    request.getRequestDispatcher("/calculator.jsp").forward(request, response);
                    return;
                }
                user.setId(userId);
            } else {
                // Actualizar datos del usuario existente
                user.setEdad(edad);
                user.setSexo(sexo.toUpperCase());
                user.setEstatura_m(estatura);
                user.setPeso_kg(peso);
                
                if (!userDAO.update(user)) {
                    request.setAttribute("error", "Error al actualizar los datos del usuario.");
                    request.getRequestDispatcher("/calculator.jsp").forward(request, response);
                    return;
                }
                userId = user.getId();
            }
            
            // Calcular IAC
            double iacValue = IACCalculator.calcularIAC(cadera, estatura);
            String category = IACCalculator.categoria(iacValue, sexo);
            
            // Crear resultado IAC
            IACResult iacResult = new IACResult(userId, cadera, estatura, iacValue, category);
            int resultId = iacDAO.save(iacResult);
            
            if (resultId == -1) {
                request.setAttribute("error", "Error al guardar el resultado del cálculo.");
                request.getRequestDispatcher("/calculator.jsp").forward(request, response);
                return;
            }
            
            iacResult.setId(resultId);
            
            // Guardar datos en la sesión para mostrar en result.jsp
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("iacResult", iacResult);
            session.setAttribute("rangosInfo", IACCalculator.obtenerRangosInfo(sexo));
            
            // Redirigir a la página de resultados
            response.sendRedirect(request.getContextPath() + "/result.jsp");
            
        } catch (Exception e) {
            System.err.println("Error en CalculateIACServlet: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Error interno del servidor. Por favor, inténtelo de nuevo.");
            request.getRequestDispatcher("/calculator.jsp").forward(request, response);
        }
    }
}