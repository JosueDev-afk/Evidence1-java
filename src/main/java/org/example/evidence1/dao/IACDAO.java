package org.example.evidence1.dao;

import org.example.evidence1.db.DBConnection;
import org.example.evidence1.model.IACResult;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase DAO para operaciones CRUD de resultados IAC
 */
public class IACDAO {
    
    private DBConnection dbConnection;
    
    public IACDAO() {
        this.dbConnection = DBConnection.getInstance();
    }
    
    /**
     * Guarda un resultado IAC en la base de datos
     * @param iacResult resultado IAC a guardar
     * @return ID del resultado creado, -1 si hay error
     */
    public int save(IACResult iacResult) {
        String sql = "INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            statement.setInt(1, iacResult.getUserId());
            statement.setDouble(2, iacResult.getHip_cm());
            statement.setDouble(3, iacResult.getHeight_m());
            statement.setDouble(4, iacResult.getIac_value());
            statement.setString(5, iacResult.getCategory());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al guardar resultado IAC: " + e.getMessage());
        }
        
        return -1;
    }
    
    /**
     * Busca todos los resultados IAC de un usuario específico
     * @param userId ID del usuario
     * @return Lista de resultados IAC del usuario
     */
    public List<IACResult> findByUser(int userId) {
        List<IACResult> results = new ArrayList<>();
        String sql = "SELECT * FROM iac_results WHERE user_id = ? ORDER BY calculated_at DESC";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, userId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    results.add(mapResultSetToIACResult(resultSet));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al buscar resultados IAC por usuario: " + e.getMessage());
        }
        
        return results;
    }
    
    /**
     * Busca un resultado IAC por ID
     * @param id ID del resultado
     * @return Resultado IAC encontrado o null si no existe
     */
    public IACResult findById(int id) {
        String sql = "SELECT * FROM iac_results WHERE id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToIACResult(resultSet);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al buscar resultado IAC por ID: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Obtiene todos los resultados IAC
     * @return Lista de todos los resultados IAC
     */
    public List<IACResult> findAll() {
        List<IACResult> results = new ArrayList<>();
        String sql = "SELECT * FROM iac_results ORDER BY calculated_at DESC";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            
            while (resultSet.next()) {
                results.add(mapResultSetToIACResult(resultSet));
            }
            
        } catch (SQLException e) {
            System.err.println("Error al obtener todos los resultados IAC: " + e.getMessage());
        }
        
        return results;
    }
    
    /**
     * Obtiene el último resultado IAC de un usuario
     * @param userId ID del usuario
     * @return Último resultado IAC del usuario o null si no tiene resultados
     */
    public IACResult findLastByUser(int userId) {
        String sql = "SELECT * FROM iac_results WHERE user_id = ? ORDER BY calculated_at DESC LIMIT 1";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, userId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return mapResultSetToIACResult(resultSet);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al buscar último resultado IAC del usuario: " + e.getMessage());
        }
        
        return null;
    }
    
    /**
     * Elimina un resultado IAC por ID
     * @param id ID del resultado a eliminar
     * @return true si se eliminó correctamente, false en caso contrario
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM iac_results WHERE id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            return statement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error al eliminar resultado IAC: " + e.getMessage());
        }
        
        return false;
    }
    
    /**
     * Obtiene el conteo de resultados por usuario
     * @param userId ID del usuario
     * @return Número de resultados del usuario
     */
    public int countByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM iac_results WHERE user_id = ?";
        
        try (Connection connection = dbConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, userId);
            
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error al contar resultados IAC del usuario: " + e.getMessage());
        }
        
        return 0;
    }
    
    /**
     * Mapea un ResultSet a un objeto IACResult
     * @param resultSet ResultSet de la consulta
     * @return objeto IACResult
     * @throws SQLException si hay error al acceder a los datos
     */
    private IACResult mapResultSetToIACResult(ResultSet resultSet) throws SQLException {
        IACResult iacResult = new IACResult();
        iacResult.setId(resultSet.getInt("id"));
        iacResult.setUserId(resultSet.getInt("user_id"));
        iacResult.setHip_cm(resultSet.getDouble("hip_cm"));
        iacResult.setHeight_m(resultSet.getDouble("height_m"));
        iacResult.setIac_value(resultSet.getDouble("iac_value"));
        iacResult.setCategory(resultSet.getString("category"));
        iacResult.setCalculated_at(resultSet.getTimestamp("calculated_at"));
        
        return iacResult;
    }
}