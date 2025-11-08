package org.example.evidence1.controller;

import org.example.evidence1.dao.IACDAO;
import org.example.evidence1.dao.UserDAO;
import org.example.evidence1.model.IACResult;
import org.example.evidence1.model.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller
@RequestMapping("/history")
public class HistoryController {

    private final IACDAO iacDAO;
    private final UserDAO userDAO;

    public HistoryController() {
        this.iacDAO = new IACDAO();
        this.userDAO = new UserDAO();
    }

    @GetMapping
    public String getHistory(HttpServletRequest request, Model model) {
        String action = request.getParameter("action");
        if (action == null) action = "user";
        switch (action) {
            case "all":
                return showAllHistory(model);
            case "byName":
                return showHistoryByUserName(request, model);
            case "user":
            default:
                return showUserHistory(request, model);
        }
    }

    @PostMapping
    public String postHistory(HttpServletRequest request, Model model) {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            return deleteResult(request, model);
        }
        return getHistory(request, model);
    }

    private String showUserHistory(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
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
            model.addAttribute("user", currentUser);
            model.addAttribute("iacResults", results);
            model.addAttribute("totalResults", totalResults);
            if (!results.isEmpty()) {
                IACResult lastResult = results.get(0);
                double avgIAC = results.stream().mapToDouble(IACResult::getIac_value).average().orElse(0.0);
                model.addAttribute("lastResult", lastResult);
                model.addAttribute("averageIAC", Math.round(avgIAC * 100.0) / 100.0);
            }
        } else {
            model.addAttribute("error", "No se encontró información del usuario. Por favor, inicie sesión o registrese.");
        }
        return "history"; // /history.jsp
    }

    private String showAllHistory(Model model) {
        List<IACResult> allResults = iacDAO.findAll();
        model.addAttribute("allResults", allResults);
        model.addAttribute("isAdminView", true);
        for (IACResult result : allResults) {
            User user = userDAO.findById(result.getUserId());
            if (user != null) {
                result.setCategory(result.getCategory() + " (" + user.getNombre() + ")");
            }
        }
        return "history";
    }

    private String showHistoryByUserName(HttpServletRequest request, Model model) {
        String userName = request.getParameter("userName");
        if (userName == null || userName.trim().isEmpty()) {
            model.addAttribute("error", "Nombre de usuario requerido.");
            return "history";
        }
        User user = userDAO.findByName(userName.trim());
        if (user != null) {
            List<IACResult> results = iacDAO.findByUser(user.getId());
            int totalResults = iacDAO.countByUser(user.getId());
            model.addAttribute("user", user);
            model.addAttribute("iacResults", results);
            model.addAttribute("totalResults", totalResults);
            model.addAttribute("searchedUser", true);
            if (!results.isEmpty()) {
                IACResult lastResult = results.get(0);
                double avgIAC = results.stream().mapToDouble(IACResult::getIac_value).average().orElse(0.0);
                model.addAttribute("lastResult", lastResult);
                model.addAttribute("averageIAC", Math.round(avgIAC * 100.0) / 100.0);
            }
        } else {
            model.addAttribute("error", "Usuario '" + userName + "' no encontrado.");
        }
        return "history";
    }

    private String deleteResult(HttpServletRequest request, Model model) {
        String resultIdStr = request.getParameter("resultId");
        if (resultIdStr == null || resultIdStr.trim().isEmpty()) {
            model.addAttribute("error", "ID de resultado requerido.");
            return showUserHistory(request, model);
        }
        try {
            int resultId = Integer.parseInt(resultIdStr.trim());
            IACResult result = iacDAO.findById(resultId);
            if (result == null) {
                model.addAttribute("error", "Resultado no encontrado.");
                return showUserHistory(request, model);
            }
            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("currentUser");
            boolean isAdmin = "admin".equals(request.getParameter("admin"));
            if (currentUser == null || (currentUser.getId() != result.getUserId() && !isAdmin)) {
                model.addAttribute("error", "No tiene permisos para eliminar este resultado.");
                return showUserHistory(request, model);
            }
            if (iacDAO.delete(resultId)) {
                model.addAttribute("success", "Resultado eliminado exitosamente.");
            } else {
                model.addAttribute("error", "Error al eliminar el resultado.");
            }
        } catch (NumberFormatException e) {
            model.addAttribute("error", "ID de resultado inválido.");
        } catch (Exception e) {
            model.addAttribute("error", "Error interno del servidor.");
        }
        if ("admin".equals(request.getParameter("admin"))) {
            return showAllHistory(model);
        }
        return showUserHistory(request, model);
    }
}