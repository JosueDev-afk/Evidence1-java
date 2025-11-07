-- =====================================================
-- ESQUEMA DE BASE DE DATOS PARA CALCULADORA IAC
-- Índice de Adiposidad Corporal (IAC)
-- =====================================================

-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS iac_app 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Usar la base de datos
USE iac_app;

-- =====================================================
-- TABLA DE USUARIOS
-- =====================================================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    edad INT CHECK (edad > 0 AND edad <= 150),
    sexo ENUM('M','F','O') NOT NULL,
    estatura_m DECIMAL(4,2) CHECK (estatura_m > 0 AND estatura_m <= 3.0),
    peso_kg DECIMAL(5,2) CHECK (peso_kg > 0 AND peso_kg <= 1000),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Índices para mejorar rendimiento
    INDEX idx_nombre (nombre),
    INDEX idx_sexo (sexo),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- TABLA DE RESULTADOS IAC
-- =====================================================
CREATE TABLE IF NOT EXISTS iac_results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    hip_cm DECIMAL(6,2) NOT NULL CHECK (hip_cm > 0 AND hip_cm <= 500),
    height_m DECIMAL(4,2) NOT NULL CHECK (height_m > 0 AND height_m <= 3.0),
    iac_value DECIMAL(5,2) NOT NULL,
    category VARCHAR(50) NOT NULL,
    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Clave foránea con cascada
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Índices para mejorar rendimiento
    INDEX idx_user_id (user_id),
    INDEX idx_category (category),
    INDEX idx_calculated_at (calculated_at),
    INDEX idx_user_date (user_id, calculated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- VISTA PARA CONSULTAS COMBINADAS
-- =====================================================
CREATE OR REPLACE VIEW user_iac_history AS
SELECT 
    u.id as user_id,
    u.nombre,
    u.edad,
    u.sexo,
    u.estatura_m,
    u.peso_kg,
    r.id as result_id,
    r.hip_cm,
    r.height_m,
    r.iac_value,
    r.category,
    r.calculated_at,
    -- Campos calculados adicionales
    CASE 
        WHEN r.category = 'Bajo' THEN 1
        WHEN r.category = 'Normal' THEN 2
        WHEN r.category = 'Sobrepeso' THEN 3
        WHEN r.category = 'Obesidad' THEN 4
        ELSE 0
    END as category_order,
    -- Ranking de resultados por usuario
    ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY r.calculated_at DESC) as result_rank
FROM users u
LEFT JOIN iac_results r ON u.id = r.user_id
ORDER BY u.nombre, r.calculated_at DESC;

-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS
-- =====================================================

-- Procedimiento para obtener estadísticas de usuario
DELIMITER //
CREATE PROCEDURE GetUserStatistics(IN p_user_id INT)
BEGIN
    SELECT 
        COUNT(*) as total_calculations,
        MIN(iac_value) as min_iac,
        MAX(iac_value) as max_iac,
        AVG(iac_value) as avg_iac,
        MIN(calculated_at) as first_calculation,
        MAX(calculated_at) as last_calculation,
        COUNT(DISTINCT category) as different_categories
    FROM iac_results 
    WHERE user_id = p_user_id;
END //
DELIMITER ;

-- Procedimiento para limpiar datos antiguos (opcional)
DELIMITER //
CREATE PROCEDURE CleanOldData(IN days_old INT)
BEGIN
    DELETE FROM iac_results 
    WHERE calculated_at < DATE_SUB(NOW(), INTERVAL days_old DAY);
END //
DELIMITER ;

-- =====================================================
-- TRIGGERS PARA AUDITORÍA
-- =====================================================

-- Trigger para actualizar timestamp en users
DELIMITER //
CREATE TRIGGER update_user_timestamp 
    BEFORE UPDATE ON users
    FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
END //
DELIMITER ;

-- =====================================================
-- COMENTARIOS DE DOCUMENTACIÓN
-- =====================================================

-- Agregar comentarios a las tablas
ALTER TABLE users COMMENT = 'Tabla de usuarios del sistema de cálculo IAC';
ALTER TABLE iac_results COMMENT = 'Tabla de resultados de cálculos IAC realizados';

-- Agregar comentarios a las columnas importantes
ALTER TABLE users MODIFY COLUMN nombre VARCHAR(100) NOT NULL COMMENT 'Nombre completo del usuario';
ALTER TABLE users MODIFY COLUMN sexo ENUM('M','F','O') NOT NULL COMMENT 'Sexo: M=Masculino, F=Femenino, O=Otro';
ALTER TABLE users MODIFY COLUMN estatura_m DECIMAL(4,2) COMMENT 'Estatura en metros (ej: 1.75)';
ALTER TABLE users MODIFY COLUMN peso_kg DECIMAL(5,2) COMMENT 'Peso en kilogramos (opcional)';

ALTER TABLE iac_results MODIFY COLUMN hip_cm DECIMAL(6,2) NOT NULL COMMENT 'Circunferencia de cadera en centímetros';
ALTER TABLE iac_results MODIFY COLUMN height_m DECIMAL(4,2) NOT NULL COMMENT 'Estatura en metros usada en el cálculo';
ALTER TABLE iac_results MODIFY COLUMN iac_value DECIMAL(5,2) NOT NULL COMMENT 'Valor calculado del IAC';
ALTER TABLE iac_results MODIFY COLUMN category VARCHAR(50) NOT NULL COMMENT 'Categoría del IAC (Bajo, Normal, Sobrepeso, Obesidad)';

-- =====================================================
-- MENSAJE DE CONFIRMACIÓN
-- =====================================================
SELECT 'Esquema de base de datos IAC creado exitosamente' as status;