package org.example.evidence1.model;

import java.sql.Timestamp;

/**
 * Clase modelo para representar un resultado de cálculo IAC
 */
public class IACResult {
    private int id;
    private int userId;
    private double hip_cm;
    private double height_m;
    private double iac_value;
    private String category;
    private Timestamp calculated_at;

    // Constructor vacío
    public IACResult() {}

    // Constructor con parámetros principales
    public IACResult(int userId, double hip_cm, double height_m, double iac_value, String category) {
        this.userId = userId;
        this.hip_cm = hip_cm;
        this.height_m = height_m;
        this.iac_value = iac_value;
        this.category = category;
    }

    // Constructor completo
    public IACResult(int id, int userId, double hip_cm, double height_m, double iac_value, String category, Timestamp calculated_at) {
        this.id = id;
        this.userId = userId;
        this.hip_cm = hip_cm;
        this.height_m = height_m;
        this.iac_value = iac_value;
        this.category = category;
        this.calculated_at = calculated_at;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public double getHip_cm() {
        return hip_cm;
    }

    public void setHip_cm(double hip_cm) {
        this.hip_cm = hip_cm;
    }

    public double getHeight_m() {
        return height_m;
    }

    public void setHeight_m(double height_m) {
        this.height_m = height_m;
    }

    public double getIac_value() {
        return iac_value;
    }

    public void setIac_value(double iac_value) {
        this.iac_value = iac_value;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public Timestamp getCalculated_at() {
        return calculated_at;
    }

    public void setCalculated_at(Timestamp calculated_at) {
        this.calculated_at = calculated_at;
    }

    @Override
    public String toString() {
        return "IACResult{" +
                "id=" + id +
                ", userId=" + userId +
                ", hip_cm=" + hip_cm +
                ", height_m=" + height_m +
                ", iac_value=" + iac_value +
                ", category='" + category + '\'' +
                ", calculated_at=" + calculated_at +
                '}';
    }
}