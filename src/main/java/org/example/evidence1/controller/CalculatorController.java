package org.example.evidence1.controller;

import org.example.evidence1.dao.IACDAO;
import org.example.evidence1.dao.UserDAO;
import org.example.evidence1.model.IACResult;
import org.example.evidence1.model.User;
import org.example.evidence1.util.IACCalculator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping
public class CalculatorController {

    private final UserDAO userDAO;
    private final IACDAO iacDAO;

    public CalculatorController() {
        this.userDAO = new UserDAO();
        this.iacDAO = new IACDAO();
    }

    @GetMapping("/calculator")
    public String showCalculator() {
        return "calculator"; // /calculator.jsp
    }

    @GetMapping("/calculate")
    public String getCalculate() {
        // Canonicaliza accesos directos a /calculate hacia la vista del formulario
        return "calculator";
    }

    @PostMapping("/calculate")
    public String calculate(HttpServletRequest request, Model model) {
        try {
            // Parámetros validados por el filtro y expuestos como atributos
            String nombre = (String) request.getAttribute("nombre");
            Integer edad = (Integer) request.getAttribute("edad");
            String sexo = (String) request.getAttribute("sexo");
            Double estatura = (Double) request.getAttribute("estatura");
            Double peso = (Double) request.getAttribute("peso");
            Double cadera = (Double) request.getAttribute("cadera");

            if (nombre == null || edad == null || sexo == null || estatura == null || cadera == null) {
                model.addAttribute("error", "Parámetros inválidos.");
                return "calculator";
            }

            // Buscar o crear usuario
            User user = userDAO.findByName(nombre);
            int userId;
            if (user == null) {
                user = new User(nombre, edad, sexo, estatura, peso);
                userId = userDAO.create(user);
                if (userId == -1) {
                    model.addAttribute("error", "Error al crear el usuario.");
                    return "calculator";
                }
                user.setId(userId);
            } else {
                user.setEdad(edad);
                user.setSexo(sexo);
                user.setEstatura_m(estatura);
                user.setPeso_kg(peso);
                if (!userDAO.update(user)) {
                    model.addAttribute("error", "Error al actualizar usuario.");
                    return "calculator";
                }
                userId = user.getId();
            }

            // Calcular IAC
            double iacValue = IACCalculator.calcularIAC(cadera, estatura);
            String category = IACCalculator.categoria(iacValue, sexo);

            IACResult iacResult = new IACResult(userId, cadera, estatura, iacValue, category);
            int resultId = iacDAO.save(iacResult);
            if (resultId == -1) {
                model.addAttribute("error", "Error al guardar el resultado.");
                return "calculator";
            }
            iacResult.setId(resultId);

            // Sesión y rangos
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("iacResult", iacResult);
            session.setAttribute("rangosInfo", IACCalculator.obtenerRangosInfo(sexo));

            return "result"; // /result.jsp
        } catch (Exception e) {
            model.addAttribute("error", "Error interno del servidor.");
            return "calculator";
        }
    }
}