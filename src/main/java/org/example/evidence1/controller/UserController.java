package org.example.evidence1.controller;

import org.example.evidence1.dao.UserDAO;
import org.example.evidence1.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class UserController {

    private final UserDAO userDAO;

    public UserController() {
        this.userDAO = new UserDAO();
    }

    @GetMapping
    public String showRegisterForm() {
        return "register";
    }

    @PostMapping
    public String createOrUpdate(HttpServletRequest request, Model model) {
        String action = request.getParameter("action");
        if (action == null) action = "create";
        switch (action) {
            case "update":
                return update(request, model);
            case "login":
                return login(request, model);
            case "create":
            default:
                return create(request, model);
        }
    }

    private String create(HttpServletRequest request, Model model) {
        try {
            String nombre = request.getParameter("nombre");
            String edadStr = request.getParameter("edad");
            String sexo = request.getParameter("sexo");
            String estaturaStr = request.getParameter("estatura");
            String pesoStr = request.getParameter("peso");

            if (isBlank(nombre) || isBlank(edadStr) || isBlank(sexo) || isBlank(estaturaStr)) {
                model.addAttribute("error", "Todos los campos son obligatorios excepto el peso.");
                return "register";
            }

            if (userDAO.findByName(nombre.trim()) != null) {
                model.addAttribute("error", "Ya existe un usuario con ese nombre.");
                return "register";
            }

            int edad = Integer.parseInt(edadStr.trim());
            double estatura = Double.parseDouble(estaturaStr.trim());
            Double peso = isBlank(pesoStr) ? null : Double.parseDouble(pesoStr.trim());

            if (edad < 1 || edad > 120) {
                model.addAttribute("error", "La edad debe estar entre 1 y 120 años.");
                return "register";
            }
            if (estatura <= 0 || estatura > 3.0) {
                model.addAttribute("error", "La estatura debe estar entre 0.1 y 3.0 metros.");
                return "register";
            }
            if (peso != null && (peso <= 0 || peso > 500)) {
                model.addAttribute("error", "El peso debe estar entre 1 y 500 kg.");
                return "register";
            }

            User user = new User(nombre.trim(), edad, sexo.toUpperCase(), estatura, peso);
            int userId = userDAO.create(user);
            if (userId == -1) {
                model.addAttribute("error", "Error al registrar el usuario.");
                return "register";
            }
            user.setId(userId);
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            model.addAttribute("user", user);
            model.addAttribute("success", "Usuario registrado exitosamente.");
            return "calculator";
        } catch (Exception e) {
            model.addAttribute("error", "Error interno del servidor.");
            return "register";
        }
    }

    private String update(HttpServletRequest request, Model model) {
        try {
            String userIdStr = request.getParameter("userId");
            if (isBlank(userIdStr)) {
                model.addAttribute("error", "ID de usuario requerido.");
                return "register";
            }
            int userId = Integer.parseInt(userIdStr);
            User existingUser = userDAO.findById(userId);
            if (existingUser == null) {
                model.addAttribute("error", "Usuario no encontrado.");
                return "register";
            }
            String nombre = request.getParameter("nombre");
            String edadStr = request.getParameter("edad");
            String sexo = request.getParameter("sexo");
            String estaturaStr = request.getParameter("estatura");
            String pesoStr = request.getParameter("peso");

            if (!isBlank(nombre)) existingUser.setNombre(nombre.trim());
            if (!isBlank(edadStr)) {
                int edad = Integer.parseInt(edadStr.trim());
                if (edad >= 1 && edad <= 120) existingUser.setEdad(edad);
            }
            if (!isBlank(sexo)) existingUser.setSexo(sexo.toUpperCase());
            if (!isBlank(estaturaStr)) {
                double estatura = Double.parseDouble(estaturaStr.trim());
                if (estatura > 0 && estatura <= 3.0) existingUser.setEstatura_m(estatura);
            }
            if (!isBlank(pesoStr)) {
                double peso = Double.parseDouble(pesoStr.trim());
                if (peso > 0 && peso <= 500) existingUser.setPeso_kg(peso);
            }

            if (!userDAO.update(existingUser)) {
                model.addAttribute("error", "Error al actualizar el usuario.");
                return "register";
            }
            model.addAttribute("success", "Usuario actualizado exitosamente.");
            model.addAttribute("user", existingUser);
            return "register";
        } catch (Exception e) {
            model.addAttribute("error", "Error interno del servidor.");
            return "register";
        }
    }

    private String login(HttpServletRequest request, Model model) {
        try {
            String nombre = request.getParameter("nombre");
            if (isBlank(nombre)) {
                model.addAttribute("error", "Nombre requerido.");
                return "register";
            }
            User user = userDAO.findByName(nombre.trim());
            if (user == null) {
                model.addAttribute("error", "Usuario no encontrado.");
                return "register";
            }
            request.getSession().setAttribute("currentUser", user);
            return "calculator";
        } catch (Exception e) {
            model.addAttribute("error", "Error interno del servidor.");
            return "register";
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
