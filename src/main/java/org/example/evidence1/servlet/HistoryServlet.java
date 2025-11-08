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

import java.io.IOException;
import java.util.List;

/**
 * Servlet para manejar el historial de cálculos IAC
 */
@WebServlet(name = "HistoryServlet", urlPatterns = {"/history"})
public class HistoryServlet extends HttpServlet {
    
    private IACDAO iacDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        iacDAO = new IACDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "user";
        }
        
        switch (action) {
            case "user":
                showUserHistory(request, response);
                break;
            case "all":
                showAllHistory(request, response);
                break;
            case "byName":
                showHistoryByUserName(request, response);
                break;
            case "delete":
                deleteResult(request, response);
                break;
            default:
                showUserHistory(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            deleteResult(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    /**
     * Muestra el historial del usuario actual en sesión
     */
    private void showUserHistory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser == null) {
            // Si no hay usuario en sesión, intentar obtener por nombre
            String userName = request.getParameter("userName");
            if (userName != null && !userName.trim().isEmpty()) {
                currentUser = userDAO.findByName(userName.trim());
                if (currentUser != null) {
                    session.setAttribute("currentUser", currentUser);
                }
            }
        }
        
        if (currentUser != null) {
            List<IACResult> results = iacDAO.findByUser(currentUser.getId());
            int totalResults = iacDAO.countByUser(currentUser.getId());
            
            request.setAttribute("user", currentUser);
            request.setAttribute("iacResults", results);
            request.setAttribute("totalResults", totalResults);
            
            // Obtener estadísticas básicas
            if (!results.isEmpty()) {
                IACResult lastResult = results.get(0); // Ya están ordenados por fecha DESC
                double avgIAC = results.stream()
                    .mapToDouble(IACResult::getIac_value)
                    .average()
                    .orElse(0.0);
                
                request.setAttribute("lastResult", lastResult);
                request.setAttribute("averageIAC", Math.round(avgIAC * 100.0) / 100.0);
            }
            
        } else {
            request.setAttribute("error", "No se encontró información del usuario. Por favor, inicie sesión o registrese.");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/history.jsp").forward(request, response);
    }
    
    /**
     * Muestra el historial de todos los usuarios (para administradores)
     */
    private void showAllHistory(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<IACResult> allResults = iacDAO.findAll();
        request.setAttribute("allResults", allResults);
        request.setAttribute("isAdminView", true);
        
        // Obtener información de usuarios para cada resultado
        for (IACResult result : allResults) {
            User user = userDAO.findById(result.getUserId());
            if (user != null) {
                // Agregar el nombre del usuario como atributo temporal
                result.setCategory(result.getCategory() + " (" + user.getNombre() + ")");
            }
        }
        
        request.getRequestDispatcher("/WEB-INF/views/history.jsp").forward(request, response);
    }
    
    /**
     * Muestra el historial de un usuario específico por nombre
     */
    private void showHistoryByUserName(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userName = request.getParameter("userName");
        
        if (userName == null || userName.trim().isEmpty()) {
            request.setAttribute("error", "Nombre de usuario requerido.");
            request.getRequestDispatcher("/history.jsp").forward(request, response);
            return;
        }
        
        User user = userDAO.findByName(userName.trim());
        
        if (user != null) {
            List<IACResult> results = iacDAO.findByUser(user.getId());
            int totalResults = iacDAO.countByUser(user.getId());
            
            request.setAttribute("user", user);
            request.setAttribute("iacResults", results);
            request.setAttribute("totalResults", totalResults);
            request.setAttribute("searchedUser", true);
            
            // Obtener estadísticas básicas
            if (!results.isEmpty()) {
                IACResult lastResult = results.get(0);
                double avgIAC = results.stream()
                    .mapToDouble(IACResult::getIac_value)
                    .average()
                    .orElse(0.0);
                
                request.setAttribute("lastResult", lastResult);
                request.setAttribute("averageIAC", Math.round(avgIAC * 100.0) / 100.0);
            }
            
        } else {
            request.setAttribute("error", "Usuario '" + userName + "' no encontrado.");
        }
        
        request.getRequestDispatcher("/WEB-INF/views/history.jsp").forward(request, response);
    }
    
    /**
     * Elimina un resultado específico
     */
    private void deleteResult(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String resultIdStr = request.getParameter("resultId");
        
        if (resultIdStr == null || resultIdStr.trim().isEmpty()) {
            request.setAttribute("error", "ID de resultado requerido.");
            showUserHistory(request, response);
            return;
        }
        
        try {
            int resultId = Integer.parseInt(resultIdStr.trim());
            
            // Verificar que el resultado existe y obtener información del usuario
            IACResult result = iacDAO.findById(resultId);
            
            if (result == null) {
                request.setAttribute("error", "Resultado no encontrado.");
                showUserHistory(request, response);
                return;
            }
            
            // Verificar permisos: solo el propietario o admin puede eliminar
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            boolean isAdmin = "admin".equals(request.getParameter("admin"));
            
            if (currentUser == null || (currentUser.getId() != result.getUserId() && !isAdmin)) {
                request.setAttribute("error", "No tiene permisos para eliminar este resultado.");
                showUserHistory(request, response);
                return;
            }
            
            // Eliminar el resultado
            if (iacDAO.delete(resultId)) {
                request.setAttribute("success", "Resultado eliminado exitosamente.");
            } else {
                request.setAttribute("error", "Error al eliminar el resultado.");
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID de resultado inválido.");
        } catch (Exception e) {
            System.err.println("Error al eliminar resultado: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error interno del servidor.");
        }
        
        // Redirigir de vuelta al historial
        if ("admin".equals(request.getParameter("admin"))) {
            showAllHistory(request, response);
        } else {
            showUserHistory(request, response);
        }
    }
}