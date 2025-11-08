package org.example.evidence1.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.example.evidence1.dao.UserDAO;
import org.example.evidence1.model.User;

import java.io.IOException;
import java.util.List;

/**
 * Servlet para manejar operaciones relacionadas con usuarios
 */
@WebServlet(name = "UserServlet", urlPatterns = {"/user-legacy"})
public class UserServlet extends HttpServlet {
    
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "register";
        }
        
        switch (action) {
            case "register":
                showRegisterForm(request, response);
                break;
            case "list":
                listUsers(request, response);
                break;
            case "find":
                findUser(request, response);
                break;
            case "profile":
                showUserProfile(request, response);
                break;
            default:
                showRegisterForm(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "create";
        }
        
        switch (action) {
            case "create":
                createUser(request, response);
                break;
            case "update":
                updateUser(request, response);
                break;
            case "login":
                loginUser(request, response);
                break;
            default:
                createUser(request, response);
                break;
        }
    }
    
    /**
     * Muestra el formulario de registro
     */
    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }
    
    /**
     * Crea un nuevo usuario
     */
    private void createUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Obtener parámetros del formulario
            String nombre = request.getParameter("nombre");
            String edadStr = request.getParameter("edad");
            String sexo = request.getParameter("sexo");
            String estaturaStr = request.getParameter("estatura");
            String pesoStr = request.getParameter("peso");
            
            // Validar parámetros obligatorios
            if (nombre == null || nombre.trim().isEmpty() ||
                edadStr == null || edadStr.trim().isEmpty() ||
                sexo == null || sexo.trim().isEmpty() ||
                estaturaStr == null || estaturaStr.trim().isEmpty()) {
                
                request.setAttribute("error", "Todos los campos son obligatorios excepto el peso.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            // Verificar si el usuario ya existe
            if (userDAO.findByName(nombre.trim()) != null) {
                request.setAttribute("error", "Ya existe un usuario con ese nombre.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            // Convertir parámetros numéricos
            int edad;
            double estatura;
            Double peso = null;
            
            try {
                edad = Integer.parseInt(edadStr.trim());
                estatura = Double.parseDouble(estaturaStr.trim());
                
                if (pesoStr != null && !pesoStr.trim().isEmpty()) {
                    peso = Double.parseDouble(pesoStr.trim());
                }
                
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Por favor, ingrese valores numéricos válidos.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            // Validar rangos
            if (edad < 1 || edad > 120) {
                request.setAttribute("error", "La edad debe estar entre 1 y 120 años.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            if (estatura <= 0 || estatura > 3.0) {
                request.setAttribute("error", "La estatura debe estar entre 0.1 y 3.0 metros.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            if (peso != null && (peso <= 0 || peso > 500)) {
                request.setAttribute("error", "El peso debe estar entre 1 y 500 kg.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            // Crear usuario
            User user = new User(nombre.trim(), edad, sexo.toUpperCase(), estatura, peso);
            int userId = userDAO.create(user);
            
            if (userId != -1) {
                user.setId(userId);
                
                // Guardar usuario en la sesión
                HttpSession session = request.getSession();
                session.setAttribute("currentUser", user);
                
                request.setAttribute("success", "Usuario registrado exitosamente.");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/WEB-INF/views/calculator.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Error al registrar el usuario.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error en createUser: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Error interno del servidor.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Actualiza un usuario existente
     */
    private void updateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            String userIdStr = request.getParameter("userId");
            
            if (userIdStr == null || userIdStr.trim().isEmpty()) {
                request.setAttribute("error", "ID de usuario requerido.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            int userId = Integer.parseInt(userIdStr);
            User existingUser = userDAO.findById(userId);
            
            if (existingUser == null) {
                request.setAttribute("error", "Usuario no encontrado.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
                return;
            }
            
            // Obtener nuevos datos
            String nombre = request.getParameter("nombre");
            String edadStr = request.getParameter("edad");
            String sexo = request.getParameter("sexo");
            String estaturaStr = request.getParameter("estatura");
            String pesoStr = request.getParameter("peso");
            
            // Actualizar solo los campos que no estén vacíos
            if (nombre != null && !nombre.trim().isEmpty()) {
                existingUser.setNombre(nombre.trim());
            }
            
            if (edadStr != null && !edadStr.trim().isEmpty()) {
                int edad = Integer.parseInt(edadStr.trim());
                if (edad >= 1 && edad <= 120) {
                    existingUser.setEdad(edad);
                }
            }
            
            if (sexo != null && !sexo.trim().isEmpty()) {
                existingUser.setSexo(sexo.toUpperCase());
            }
            
            if (estaturaStr != null && !estaturaStr.trim().isEmpty()) {
                double estatura = Double.parseDouble(estaturaStr.trim());
                if (estatura > 0 && estatura <= 3.0) {
                    existingUser.setEstatura_m(estatura);
                }
            }
            
            if (pesoStr != null && !pesoStr.trim().isEmpty()) {
                double peso = Double.parseDouble(pesoStr.trim());
                if (peso > 0 && peso <= 500) {
                    existingUser.setPeso_kg(peso);
                }
            }
            
            // Actualizar en la base de datos
            if (userDAO.update(existingUser)) {
                // Actualizar en la sesión si es el usuario actual
                HttpSession session = request.getSession();
                User currentUser = (User) session.getAttribute("currentUser");
                if (currentUser != null && currentUser.getId() == userId) {
                    session.setAttribute("currentUser", existingUser);
                }
                
                request.setAttribute("success", "Usuario actualizado exitosamente.");
                request.setAttribute("user", existingUser);
            } else {
                request.setAttribute("error", "Error al actualizar el usuario.");
            }
            
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error en updateUser: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Error interno del servidor.");
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
    
    /**
     * Simula un login simple por nombre
     */
    private void loginUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nombre = request.getParameter("nombre");
        
        if (nombre == null || nombre.trim().isEmpty()) {
            request.setAttribute("error", "Nombre requerido para iniciar sesión.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        User user = userDAO.findByName(nombre.trim());
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            
            response.sendRedirect(request.getContextPath() + "/calculator.jsp");
        } else {
            request.setAttribute("error", "Usuario no encontrado.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    /**
     * Lista todos los usuarios
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<User> users = userDAO.findAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }
    
    /**
     * Busca un usuario específico
     */
    private void findUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nombre = request.getParameter("nombre");
        String idStr = request.getParameter("id");
        
        User user = null;
        
        if (nombre != null && !nombre.trim().isEmpty()) {
            user = userDAO.findByName(nombre.trim());
        } else if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(idStr.trim());
                user = userDAO.findById(id);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de usuario inválido.");
            }
        }
        
        if (user != null) {
            request.setAttribute("foundUser", user);
        } else {
            request.setAttribute("error", "Usuario no encontrado.");
        }
        
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }
    
    /**
     * Muestra el perfil del usuario actual
     */
    private void showUserProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser != null) {
            // Obtener datos actualizados de la base de datos
            User updatedUser = userDAO.findById(currentUser.getId());
            if (updatedUser != null) {
                session.setAttribute("currentUser", updatedUser);
                request.setAttribute("user", updatedUser);
            }
        }
        
        request.getRequestDispatcher("/profile.jsp").forward(request, response);
    }
}