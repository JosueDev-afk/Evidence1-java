package org.example.evidence1.controller;

import org.example.evidence1.dao.IACDAO;
import org.example.evidence1.model.IACResult;
import org.example.evidence1.util.IACCalculator;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/iac")
public class IacRestController {

    private final IACDAO iacDAO;

    public IacRestController() {
        this.iacDAO = new IACDAO();
    }

    @GetMapping
    public List<IACResult> getAll() {
        return iacDAO.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<IACResult> getById(@PathVariable int id) {
        IACResult result = iacDAO.findById(id);
        if (result == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(result);
    }

    @GetMapping("/user/{userId}")
    public List<IACResult> getByUser(@PathVariable int userId) {
        return iacDAO.findByUser(userId);
    }

    // DTO para creación/actualización
    public static class IacCreateRequest {
        public Integer userId;
        public Double hip_cm;
        public Double height_m;
        public String sexo; // requerido para categoría
    }

    @PostMapping
    public ResponseEntity<IACResult> create(@RequestBody IacCreateRequest body) {
        if (body == null || body.userId == null || body.hip_cm == null || body.height_m == null || body.sexo == null) {
            return ResponseEntity.badRequest().build();
        }
        double iacValue = IACCalculator.calcularIAC(body.hip_cm, body.height_m);
        String category = IACCalculator.categoria(iacValue, body.sexo);
        IACResult toSave = new IACResult(body.userId, body.hip_cm, body.height_m, iacValue, category);
        int id = iacDAO.save(toSave);
        if (id == -1) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
        toSave.setId(id);
        return ResponseEntity.status(HttpStatus.CREATED).body(toSave);
    }

    @PutMapping("/{id}")
    public ResponseEntity<IACResult> update(@PathVariable int id, @RequestBody IacCreateRequest body) {
        if (body == null || body.userId == null || body.hip_cm == null || body.height_m == null || body.sexo == null) {
            return ResponseEntity.badRequest().build();
        }
        IACResult existing = iacDAO.findById(id);
        if (existing == null) return ResponseEntity.notFound().build();
        double iacValue = IACCalculator.calcularIAC(body.hip_cm, body.height_m);
        String category = IACCalculator.categoria(iacValue, body.sexo);
        existing.setUserId(body.userId);
        existing.setHip_cm(body.hip_cm);
        existing.setHeight_m(body.height_m);
        existing.setIac_value(iacValue);
        existing.setCategory(category);
        // Realizar UPDATE
        boolean ok = updateIac(existing);
        if (!ok) return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        return ResponseEntity.ok(existing);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable int id) {
        boolean ok = iacDAO.delete(id);
        return ok ? ResponseEntity.noContent().build() : ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
    }

    // Método auxiliar de actualización mientras el DAO no lo tiene
    private boolean updateIac(IACResult result) {
        // Implementación temporal usando JDBC directo desde DAO: agregar método si existe.
        // Para mantener el encapsulamiento, usaremos una sentencia preparada aquí.
        // Alternativamente, se podría extender IACDAO; dejamos esta vía simple.
        try {
            var conn = org.example.evidence1.db.DBConnection.getInstance().getConnection();
            try (var ps = conn.prepareStatement("UPDATE iac_results SET user_id=?, hip_cm=?, height_m=?, iac_value=?, category=? WHERE id=?")) {
                ps.setInt(1, result.getUserId());
                ps.setDouble(2, result.getHip_cm());
                ps.setDouble(3, result.getHeight_m());
                ps.setDouble(4, result.getIac_value());
                ps.setString(5, result.getCategory());
                ps.setInt(6, result.getId());
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            System.err.println("Error al actualizar resultado IAC: " + e.getMessage());
            return false;
        }
    }
}