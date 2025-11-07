-- =====================================================
-- DATOS DE PRUEBA PARA CALCULADORA IAC
-- Índice de Adiposidad Corporal (IAC)
-- =====================================================

-- Usar la base de datos
USE iac_app;

-- =====================================================
-- DATOS DE USUARIOS DE PRUEBA
-- =====================================================

-- Limpiar datos existentes (opcional, solo para desarrollo)
-- DELETE FROM iac_results;
-- DELETE FROM users;
-- ALTER TABLE users AUTO_INCREMENT = 1;
-- ALTER TABLE iac_results AUTO_INCREMENT = 1;

-- Insertar usuarios de prueba
INSERT INTO users (nombre, edad, sexo, estatura_m, peso_kg) VALUES
-- Usuarios masculinos
('Juan Pérez García', 25, 'M', 1.75, 70.5),
('Carlos Rodríguez López', 32, 'M', 1.80, 85.2),
('Miguel Ángel Fernández', 28, 'M', 1.68, 75.0),
('Roberto Silva Martín', 45, 'M', 1.77, 90.3),
('Diego Morales Castro', 35, 'M', 1.82, 78.8),

-- Usuarios femeninos
('María González Ruiz', 30, 'F', 1.65, 60.2),
('Ana Sofía Martínez', 27, 'F', 1.70, 65.5),
('Carmen López Herrera', 42, 'F', 1.62, 70.8),
('Isabel Jiménez Vega', 38, 'F', 1.68, 58.9),
('Patricia Sánchez Díaz', 33, 'F', 1.72, 68.4),

-- Usuarios con género otro
('Alex Rivera Moreno', 29, 'O', 1.74, 72.1),
('Jordan Taylor Smith', 31, 'O', 1.69, 66.7),

-- Usuarios adicionales para pruebas
('Pedro Ramírez Torres', 50, 'M', 1.73, 95.6),
('Lucía Vargas Mendoza', 24, 'F', 1.58, 52.3),
('Fernando Castro Ruiz', 39, 'M', 1.85, 88.9);

-- =====================================================
-- DATOS DE RESULTADOS IAC DE PRUEBA
-- =====================================================

-- Resultados para Juan Pérez García (ID: 1)
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
(1, 95.5, 1.75, 11.32, 'Normal', '2024-01-15 10:30:00'),
(1, 97.2, 1.75, 12.15, 'Normal', '2024-02-20 14:45:00'),
(1, 98.8, 1.75, 12.93, 'Normal', '2024-03-25 09:15:00');

-- Resultados para María González Ruiz (ID: 6)
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
(6, 98.3, 1.65, 15.87, 'Normal', '2024-01-10 11:20:00'),
(6, 100.1, 1.65, 17.12, 'Normal', '2024-02-14 16:30:00'),
(6, 102.5, 1.65, 18.78, 'Sobrepeso', '2024-03-18 13:45:00'),
(6, 101.8, 1.65, 18.30, 'Normal', '2024-04-22 10:10:00');

-- Resultados para Carlos Rodríguez López (ID: 2)
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
(2, 102.7, 1.80, 12.45, 'Normal', '2024-01-08 15:25:00'),
(2, 105.3, 1.80, 13.67, 'Normal', '2024-02-12 12:40:00');

-- Resultados para Ana Sofía Martínez (ID: 7)
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
(7, 96.8, 1.70, 13.18, 'Normal', '2024-01-20 09:50:00'),
(7, 99.2, 1.70, 14.41, 'Normal', '2024-03-05 14:15:00'),
(7, 101.5, 1.70, 15.58, 'Normal', '2024-04-10 11:30:00');

-- Resultados para Roberto Silva Martín (ID: 4) - Casos de sobrepeso
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
(4, 108.5, 1.77, 16.89, 'Sobrepeso', '2024-02-01 08:45:00'),
(4, 110.2, 1.77, 17.55, 'Sobrepeso', '2024-03-15 16:20:00');

-- Resultados para Carmen López Herrera (ID: 8) - Casos variados
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
(8, 105.8, 1.62, 22.45, 'Sobrepeso', '2024-01-25 13:10:00'),
(8, 108.3, 1.62, 24.18, 'Obesidad', '2024-02-28 10:35:00'),
(8, 106.9, 1.62, 23.21, 'Sobrepeso', '2024-04-05 15:50:00');

-- Resultados para Alex Rivera Moreno (ID: 11)
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
(11, 99.7, 1.74, 13.95, 'Normal', '2024-02-18 12:25:00'),
(11, 101.3, 1.74, 14.77, 'Normal', '2024-03-22 09:40:00');

-- Resultados para Lucía Vargas Mendoza (ID: 14) - Usuario joven
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
(14, 88.5, 1.58, 12.34, 'Normal', '2024-03-01 14:20:00'),
(14, 89.8, 1.58, 13.24, 'Normal', '2024-04-15 11:45:00');

-- Resultados para Fernando Castro Ruiz (ID: 15) - Usuario mayor
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
(15, 112.4, 1.85, 15.23, 'Normal', '2024-01-30 16:10:00'),
(15, 114.8, 1.85, 16.58, 'Sobrepeso', '2024-03-08 13:30:00');

-- =====================================================
-- DATOS ADICIONALES PARA PRUEBAS ESPECÍFICAS
-- =====================================================

-- Casos extremos para pruebas
INSERT INTO iac_results (user_id, hip_cm, height_m, iac_value, category, calculated_at) VALUES
-- Caso de IAC muy bajo
(3, 85.2, 1.68, 8.45, 'Bajo', '2024-01-12 10:15:00'),
-- Caso de IAC alto (obesidad)
(13, 118.7, 1.73, 21.89, 'Obesidad', '2024-02-05 14:50:00'),
-- Más casos normales
(5, 103.6, 1.82, 12.78, 'Normal', '2024-02-22 11:25:00'),
(9, 94.3, 1.68, 12.87, 'Normal', '2024-03-10 15:40:00'),
(10, 100.8, 1.72, 14.23, 'Normal', '2024-04-01 09:55:00'),
(12, 97.5, 1.69, 13.67, 'Normal', '2024-03-28 12:30:00');

-- =====================================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- =====================================================

-- Mostrar resumen de usuarios creados
SELECT 
    'Usuarios creados' as tipo,
    COUNT(*) as cantidad,
    COUNT(CASE WHEN sexo = 'M' THEN 1 END) as masculinos,
    COUNT(CASE WHEN sexo = 'F' THEN 1 END) as femeninos,
    COUNT(CASE WHEN sexo = 'O' THEN 1 END) as otros
FROM users;

-- Mostrar resumen de resultados IAC creados
SELECT 
    'Resultados IAC creados' as tipo,
    COUNT(*) as cantidad,
    COUNT(CASE WHEN category = 'Bajo' THEN 1 END) as bajo,
    COUNT(CASE WHEN category = 'Normal' THEN 1 END) as normal,
    COUNT(CASE WHEN category = 'Sobrepeso' THEN 1 END) as sobrepeso,
    COUNT(CASE WHEN category = 'Obesidad' THEN 1 END) as obesidad
FROM iac_results;

-- Mostrar usuarios con más cálculos
SELECT 
    u.nombre,
    COUNT(r.id) as total_calculos,
    MIN(r.iac_value) as iac_minimo,
    MAX(r.iac_value) as iac_maximo,
    AVG(r.iac_value) as iac_promedio
FROM users u
LEFT JOIN iac_results r ON u.id = r.user_id
GROUP BY u.id, u.nombre
HAVING COUNT(r.id) > 0
ORDER BY total_calculos DESC, u.nombre;

-- =====================================================
-- MENSAJE DE CONFIRMACIÓN
-- =====================================================
SELECT 'Datos de prueba insertados exitosamente en la base de datos IAC' as status;