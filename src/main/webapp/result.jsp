<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resultado IAC - Tu Índice de Adiposidad Corporal</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        
        .container {
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            color: white;
            margin-bottom: 30px;
        }
        
        .header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .header p {
            font-size: 1.1rem;
            opacity: 0.9;
        }
        
        .result-container {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 20px;
        }
        
        .user-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 30px;
            border-left: 4px solid #667eea;
        }
        
        .user-info h2 {
            color: #667eea;
            margin-bottom: 15px;
            font-size: 1.5rem;
        }
        
        .user-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .user-detail {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .user-detail:last-child {
            border-bottom: none;
        }
        
        .user-detail strong {
            color: #495057;
        }
        
        .result-main {
            text-align: center;
            margin: 40px 0;
        }
        
        .iac-value {
            font-size: 4rem;
            font-weight: bold;
            margin: 20px 0;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }
        
        .iac-unit {
            font-size: 1.5rem;
            color: #6c757d;
            margin-left: 10px;
        }
        
        .category-badge {
            display: inline-block;
            padding: 15px 30px;
            border-radius: 50px;
            font-size: 1.3rem;
            font-weight: bold;
            margin: 20px 0;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        .category-bajo {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
        }
        
        .category-normal {
            background: linear-gradient(45deg, #17a2b8, #20c997);
            color: white;
        }
        
        .category-sobrepeso {
            background: linear-gradient(45deg, #ffc107, #fd7e14);
            color: white;
        }
        
        .category-obesidad {
            background: linear-gradient(45deg, #dc3545, #e83e8c);
            color: white;
        }
        
        .calculation-details {
            background: #e3f2fd;
            border-radius: 10px;
            padding: 25px;
            margin: 30px 0;
            border-left: 4px solid #2196f3;
        }
        
        .calculation-details h3 {
            color: #1976d2;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }
        
        .formula-breakdown {
            font-family: 'Courier New', monospace;
            background: white;
            padding: 15px;
            border-radius: 8px;
            margin: 15px 0;
            font-size: 1.1rem;
            line-height: 1.8;
        }
        
        .interpretation {
            background: #fff3cd;
            border-radius: 10px;
            padding: 25px;
            margin: 30px 0;
            border-left: 4px solid #ffc107;
        }
        
        .interpretation h3 {
            color: #856404;
            margin-bottom: 15px;
            font-size: 1.3rem;
        }
        
        .interpretation p {
            color: #856404;
            margin-bottom: 10px;
        }
        
        .ranges-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .ranges-table th,
        .ranges-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .ranges-table th {
            background: #667eea;
            color: white;
            font-weight: 600;
        }
        
        .ranges-table tr:hover {
            background: #f8f9fa;
        }
        
        .current-category {
            background: #fff3cd !important;
            font-weight: bold;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 40px;
        }
        
        .btn {
            display: inline-block;
            padding: 15px 25px;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
            text-align: center;
            transition: all 0.3s ease;
            font-size: 1rem;
            border: none;
            cursor: pointer;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-success {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
        }
        
        .btn-info {
            background: linear-gradient(45deg, #17a2b8, #6f42c1);
            color: white;
        }
        
        .btn-secondary {
            background: linear-gradient(45deg, #6c757d, #495057);
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .timestamp {
            text-align: center;
            color: #6c757d;
            font-style: italic;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }
            
            .result-container {
                padding: 25px;
            }
            
            .iac-value {
                font-size: 3rem;
            }
            
            .user-details {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Resultado de tu IAC</h1>
            <p>Tu Índice de Adiposidad Corporal ha sido calculado</p>
        </div>
        
        <div class="result-container">
            <c:if test="${not empty user}">
                <div class="user-info">
                    <h2>👤 Información del Usuario</h2>
                    <div class="user-details">
                        <div class="user-detail">
                            <span>Nombre:</span>
                            <strong>${user.nombre}</strong>
                        </div>
                        <div class="user-detail">
                            <span>Edad:</span>
                            <strong>${user.edad} años</strong>
                        </div>
                        <div class="user-detail">
                            <span>Sexo:</span>
                            <strong>
                                <c:choose>
                                    <c:when test="${user.sexo == 'M'}">Masculino</c:when>
                                    <c:when test="${user.sexo == 'F'}">Femenino</c:when>
                                    <c:otherwise>Otro</c:otherwise>
                                </c:choose>
                            </strong>
                        </div>
                        <div class="user-detail">
                            <span>Estatura:</span>
                            <strong><fmt:formatNumber value="${user.estatura_m}" pattern="#0.00"/> m</strong>
                        </div>
                        <c:if test="${not empty user.peso_kg and user.peso_kg > 0}">
                            <div class="user-detail">
                                <span>Peso:</span>
                                <strong><fmt:formatNumber value="${user.peso_kg}" pattern="#0.0"/> kg</strong>
                            </div>
                        </c:if>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${not empty iacResult}">
                <div class="result-main">
                    <h2>Tu Índice de Adiposidad Corporal</h2>
                    <div class="iac-value category-${iacResult.category.toLowerCase()}">
                        <fmt:formatNumber value="${iacResult.iac_value}" pattern="#0.00"/>
                        <span class="iac-unit">%</span>
                    </div>
                    
                    <div class="category-badge category-${iacResult.category.toLowerCase()}">
                        ${iacResult.category}
                    </div>
                </div>
                
                <div class="calculation-details">
                    <h3>📊 Detalles del Cálculo</h3>
                    <p><strong>Fórmula utilizada:</strong> IAC = (Circunferencia de Cadera / Estatura^1.5) - 18</p>
                    
                    <div class="formula-breakdown">
                        IAC = (<fmt:formatNumber value="${iacResult.hip_cm}" pattern="#0.0"/> cm / <fmt:formatNumber value="${iacResult.height_m}" pattern="#0.00"/> m^1.5) - 18<br>
                        IAC = (<fmt:formatNumber value="${iacResult.hip_cm}" pattern="#0.0"/> / <fmt:formatNumber value="${iacResult.height_m * Math.sqrt(iacResult.height_m)}" pattern="#0.000"/>) - 18<br>
                        IAC = <fmt:formatNumber value="${iacResult.hip_cm / (iacResult.height_m * Math.sqrt(iacResult.height_m))}" pattern="#0.00"/> - 18<br>
                        IAC = <fmt:formatNumber value="${iacResult.iac_value}" pattern="#0.00"/>%
                    </div>
                    
                    <p><strong>Circunferencia de Cadera:</strong> <fmt:formatNumber value="${iacResult.hip_cm}" pattern="#0.0"/> cm</p>
                    <p><strong>Estatura:</strong> <fmt:formatNumber value="${iacResult.height_m}" pattern="#0.00"/> m</p>
                </div>
                
                <div class="interpretation">
                    <h3>🎯 Interpretación de tu Resultado</h3>
                    <c:choose>
                        <c:when test="${iacResult.category == 'Bajo'}">
                            <p>Tu IAC indica un nivel de adiposidad corporal <strong>bajo</strong>. Esto sugiere que tienes un porcentaje de grasa corporal menor al rango normal.</p>
                            <p><strong>Recomendación:</strong> Considera consultar con un profesional de la salud para evaluar si necesitas aumentar tu masa corporal de manera saludable.</p>
                        </c:when>
                        <c:when test="${iacResult.category == 'Normal'}">
                            <p>¡Excelente! Tu IAC se encuentra en el rango <strong>normal</strong>. Esto indica que tienes un porcentaje de grasa corporal saludable.</p>
                            <p><strong>Recomendación:</strong> Mantén tus hábitos saludables de alimentación y ejercicio para conservar este nivel óptimo.</p>
                        </c:when>
                        <c:when test="${iacResult.category == 'Sobrepeso'}">
                            <p>Tu IAC indica <strong>sobrepeso</strong>. Esto sugiere que tienes un porcentaje de grasa corporal ligeramente elevado.</p>
                            <p><strong>Recomendación:</strong> Considera adoptar hábitos más saludables como ejercicio regular y una dieta balanceada. Consulta con un profesional de la salud.</p>
                        </c:when>
                        <c:when test="${iacResult.category == 'Obesidad'}">
                            <p>Tu IAC indica <strong>obesidad</strong>. Esto sugiere un porcentaje de grasa corporal significativamente elevado.</p>
                            <p><strong>Recomendación:</strong> Es importante que consultes con un profesional de la salud para desarrollar un plan personalizado de pérdida de peso y mejora de la salud.</p>
                        </c:when>
                    </c:choose>
                </div>
                
                <h3>📋 Rangos de Referencia del IAC</h3>
                <table class="ranges-table">
                    <thead>
                        <tr>
                            <th>Categoría</th>
                            <th>Hombres</th>
                            <th>Mujeres</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="${iacResult.category == 'Bajo' ? 'current-category' : ''}">
                            <td><strong>Bajo</strong></td>
                            <td>≤ 8%</td>
                            <td>≤ 21%</td>
                        </tr>
                        <tr class="${iacResult.category == 'Normal' ? 'current-category' : ''}">
                            <td><strong>Normal</strong></td>
                            <td>8.1% - 21%</td>
                            <td>21.1% - 33%</td>
                        </tr>
                        <tr class="${iacResult.category == 'Sobrepeso' ? 'current-category' : ''}">
                            <td><strong>Sobrepeso</strong></td>
                            <td>21.1% - 26%</td>
                            <td>33.1% - 39%</td>
                        </tr>
                        <tr class="${iacResult.category == 'Obesidad' ? 'current-category' : ''}">
                            <td><strong>Obesidad</strong></td>
                            <td>> 26%</td>
                            <td>> 39%</td>
                        </tr>
                    </tbody>
                </table>
                
                <div class="timestamp">
                    <p>📅 Cálculo realizado el: <fmt:formatDate value="${iacResult.calculated_at}" pattern="dd/MM/yyyy 'a las' HH:mm:ss"/></p>
                </div>
            </c:if>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/calculator.jsp" class="btn btn-primary">
                    🧮 Calcular Nuevamente
                </a>
                
                <a href="${pageContext.request.contextPath}/history" class="btn btn-success">
                    📊 Ver mi Historial
                </a>
                
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-info">
                    👤 Actualizar Perfil
                </a>
                
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">
                    🏠 Volver al Inicio
                </a>
            </div>
        </div>
    </div>
</body>
</html>