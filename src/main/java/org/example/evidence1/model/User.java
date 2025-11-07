package org.example.evidence1.model;

import java.sql.Timestamp;

/**
 * Clase modelo para representar un usuario en el sistema IAC
 */
public class User {
    private int id;
    private String nombre;
    private int edad;
    private String sexo; // 'M', 'F', 'O'
    private double estatura_m;
    private Double peso_kg; // Opcional
    private Timestamp created_at;

    // Constructor vacío
    public User() {}

    // Constructor con parámetros principales
    public User(String nombre, int edad, String sexo, double estatura_m, Double peso_kg) {
        this.nombre = nombre;
        this.edad = edad;
        this.sexo = sexo;
        this.estatura_m = estatura_m;
        this.peso_kg = peso_kg;
    }

    // Constructor completo
    public User(int id, String nombre, int edad, String sexo, double estatura_m, Double peso_kg, Timestamp created_at) {
        this.id = id;
        this.nombre = nombre;
        this.edad = edad;
        this.sexo = sexo;
        this.estatura_m = estatura_m;
        this.peso_kg = peso_kg;
        this.created_at = created_at;
    }

    // Getters y Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getEdad() {
        return edad;
    }

    public void setEdad(int edad) {
        this.edad = edad;
    }

    public String getSexo() {
        return sexo;
    }

    public void setSexo(String sexo) {
        this.sexo = sexo;
    }

    public double getEstatura_m() {
        return estatura_m;
    }

    public void setEstatura_m(double estatura_m) {
        this.estatura_m = estatura_m;
    }

    public Double getPeso_kg() {
        return peso_kg;
    }

    public void setPeso_kg(Double peso_kg) {
        this.peso_kg = peso_kg;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", nombre='" + nombre + '\'' +
                ", edad=" + edad +
                ", sexo='" + sexo + '\'' +
                ", estatura_m=" + estatura_m +
                ", peso_kg=" + peso_kg +
                ", created_at=" + created_at +
                '}';
    }
}