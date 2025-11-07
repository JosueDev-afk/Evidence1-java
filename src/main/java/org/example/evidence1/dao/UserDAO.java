package org.example.evidence1.dao;

import org.example.evidence1.db.DBConnection;
import org.example.evidence1.model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase DAO para operaciones CRUD de usuarios
 */
public class UserDAO {
    
    private DBConnection dbConnection;
    
    public UserDAO() {
        this.dbConnection = DBConnection.getInstance();
    }
    
    /**
     * Crea un nuevo usuario en la base de datos
     * @param user usuario a crear
     * @return ID del usuario creado, -1 si hay error
     */
    public int create(User user) {
        String sql = "INSERT INTO users (nombre, edad, sexo, estatura_m, peso_kg) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setString(1, user.getNombre());
            statement.setInt(2, user.getEdad());
            statement.setString(3, user.getSexo());
            statement.setDouble(4, user.getEstatura_m());
            
            if (user.getPeso_kg() != null) {
                statement.setDouble(5, user.getPeso_kg());
            } else {
                statement.setNull(5, Types.DECIMAL);
            }
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al crear usuario: " + e.getMessage());
        }
        
        return -1;
    }
    
    /**
     * Busca un usuario por ID
     * @param id ID del usuario
     * @return Usuario encontrado o null si no existe
     */
    public User findById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToUser(resultSet);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al buscar usuario por ID: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Busca un usuario por nombre
     * @param nombre nombre del usuario
     * @return Usuario encontrado o null si no existe
     */
    public User findByName(String nombre) {
        String sql = "SELECT * FROM users WHERE nombre = ? LIMIT 1";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, nombre);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToUser(resultSet);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al buscar usuario por nombre: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Obtiene todos los usuarios
     * @return Lista de usuarios
     */
    public List<User> findAll() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            
            while (resultSet.next()) {
                users.add(mapResultSetToUser(resultSet));
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener todos los usuarios: " + e.getMessage());
        }
        
        return users;
    }
    
    /**
     * Actualiza un usuario existente
     * @param user usuario con datos actualizados
     * @return true si se actualizó correctamente, false en caso contrario
     */
    public boolean update(User user) {
        String sql = "UPDATE users SET nombre = ?, edad = ?, sexo = ?, estatura_m = ?, peso_kg = ? WHERE id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setString(1, user.getNombre());
            statement.setInt(2, user.getEdad());
            statement.setString(3, user.getSexo());
            statement.setDouble(4, user.getEstatura_m());
            
            if (user.getPeso_kg() != null) {
                statement.setDouble(5, user.getPeso_kg());
            } else {
                statement.setNull(5, Types.DECIMAL);
            }
            
            statement.setInt(6, user.getId());
            
            return statement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al actualizar usuario: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Elimina un usuario por ID
     * @param id ID del usuario a eliminar
     * @return true si se eliminó correctamente, false en caso contrario
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            return statement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar usuario: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Mapea un ResultSet a un objeto User
     * @param resultSet ResultSet de la consulta
     * @return objeto User
     * @throws SQLException si hay error al acceder a los datos
     */
    private User mapResultSetToUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setId(resultSet.getInt("id"));
        user.setNombre(resultSet.getString("nombre"));
        user.setEdad(resultSet.getInt("edad"));
        user.setSexo(resultSet.getString("sexo"));
        user.setEstatura_m(resultSet.getDouble("estatura_m"));
        
        Double peso = resultSet.getDouble("peso_kg");
        if (resultSet.wasNull()) {
            user.setPeso_kg(null);
        } else {
            user.setPeso_kg(peso);
        }
        
        user.setCreated_at(resultSet.getTimestamp("created_at"));
        
        return user;
    }
}