<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historial IAC - Seguimiento de Resultados</title>
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
            max-width: 1200px;
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
        
        .controls {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .controls h2 {
            color: #667eea;
            margin-bottom: 20px;
            font-size: 1.5rem;
        }
        
        .filter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            align-items: end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            margin-bottom: 5px;
            font-weight: 600;
            color: #333;
        }
        
        .form-group input,
        .form-group select {
            padding: 10px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-danger {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: white;
        }
        
        .btn-secondary {
            background: linear-gradient(45deg, #6c757d, #545b62);
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.2);
        }
        
        .btn-sm {
            padding: 5px 10px;
            font-size: 0.9rem;
        }
        
        .history-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 20px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            border-left: 4px solid #667eea;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .history-table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .history-table th,
        .history-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        
        .history-table th {
            background: #667eea;
            color: white;
            font-weight: 600;
            position: sticky;
            top: 0;
        }
        
        .history-table tr:hover {
            background: #f8f9fa;
        }
        
        .category-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .badge-bajo {
            background: #d4edda;
            color: #155724;
        }
        
        .badge-normal {
            background: #d1ecf1;
            color: #0c5460;
        }
        
        .badge-sobrepeso {
            background: #fff3cd;
            color: #856404;
        }
        
        .badge-obesidad {
            background: #f8d7da;
            color: #721c24;
        }
        
        .iac-value {
            font-weight: bold;
            font-size: 1.1rem;
        }
        
        .iac-bajo { color: #28a745; }
        .iac-normal { color: #17a2b8; }
        .iac-sobrepeso { color: #ffc107; }
        .iac-obesidad { color: #dc3545; }
        
        .no-results {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }
        
        .no-results i {
            font-size: 3rem;
            margin-bottom: 20px;
            display: block;
        }
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
        }
        
        .alert-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .navigation {
            text-align: center;
            margin-top: 20px;
        }
        
        .navigation a {
            color: white;
            text-decoration: none;
            margin: 0 15px;
            font-weight: 500;
            opacity: 0.9;
            transition: opacity 0.3s ease;
        }
        
        .navigation a:hover {
            opacity: 1;
            text-decoration: underline;
        }
        
        .chart-container {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: center;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }
            
            .history-container {
                padding: 20px;
            }
            
            .filter-form {
                grid-template-columns: 1fr;
            }
            
            .history-table {
                font-size: 0.9rem;
            }
            
            .history-table th,
            .history-table td {
                padding: 10px;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        
        .table-responsive {
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Historial de Cálculos IAC</h1>
            <p>Seguimiento de tu progreso y resultados anteriores</p>
        </div>
        
        <div class="controls">
            <h2>🔍 Filtros de Búsqueda</h2>
            <form action="${pageContext.request.contextPath}/history" method="get" class="filter-form">
                <div class="form-group">
                    <label for="userName">Buscar por Usuario:</label>
                    <input type="text" id="userName" name="userName" 
                           value="${param.userName}" placeholder="Nombre del usuario">
                </div>
                
                <div class="form-group">
                    <label for="view">Vista:</label>
                    <select id="view" name="view">
                        <option value="all" ${param.view == 'all' ? 'selected' : ''}>Todos los usuarios</option>
                        <option value="user" ${param.view == 'user' ? 'selected' : ''}>Por usuario específico</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">🔍 Buscar</button>
                </div>
                
                <div class="form-group">
                    <a href="history" class="btn btn-secondary">🔄 Limpiar</a>
                </div>
            </form>
        </div>
        
        <div class="history-container">
            <c:if test="${not empty message}">
                <div class="alert alert-success">
                    ${message}
                </div>
            </c:if>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty results}">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">${results.size()}</div>
                        <div class="stat-label">Total de Cálculos</div>
                    </div>
                    
                    <c:set var="avgIAC" value="0"/>
                    <c:set var="count" value="0"/>
                    <c:forEach var="result" items="${results}">
                        <c:set var="avgIAC" value="${avgIAC + result.iac_value}"/>
                        <c:set var="count" value="${count + 1}"/>
                    </c:forEach>
                    
                    <div class="stat-card">
                        <div class="stat-number">
                            <fmt:formatNumber value="${avgIAC / count}" pattern="#0.00"/>%
                        </div>
                        <div class="stat-label">IAC Promedio</div>
                    </div>
                    
                    <c:set var="normalCount" value="0"/>
                    <c:forEach var="result" items="${results}">
                        <c:if test="${result.category == 'Normal'}">
                            <c:set var="normalCount" value="${normalCount + 1}"/>
                        </c:if>
                    </c:forEach>
                    
                    <div class="stat-card">
                        <div class="stat-number">${normalCount}</div>
                        <div class="stat-label">Resultados Normales</div>
                    </div>
                    
                    <div class="stat-card">
                        <div class="stat-number">
                            <c:choose>
                                <c:when test="${not empty results}">
                                    <fmt:formatDate value="${results[0].calculated_at}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="stat-label">Último Cálculo</div>
                    </div>
                </div>
                
                <h2>📊 Historial Detallado</h2>
                
                <div class="table-responsive">
                    <table class="history-table">
                        <thead>
                            <tr>
                                <th>Usuario</th>
                                <th>Fecha</th>
                                <th>Estatura (m)</th>
                                <th>Cadera (cm)</th>
                                <th>IAC</th>
                                <th>Categoría</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="result" items="${results}">
                                <tr>
                                    <td>
                                        <strong>${result.user.nombre}</strong><br>
                                        <small>${result.user.edad} años, 
                                            <c:choose>
                                                <c:when test="${result.user.sexo == 'M'}">Masculino</c:when>
                                                <c:when test="${result.user.sexo == 'F'}">Femenino</c:when>
                                                <c:otherwise>Otro</c:otherwise>
                                            </c:choose>
                                        </small>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${result.calculated_at}" pattern="dd/MM/yyyy"/><br>
                                        <small><fmt:formatDate value="${result.calculated_at}" pattern="HH:mm:ss"/></small>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${result.height_m}" pattern="#0.00"/>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${result.hip_cm}" pattern="#0.0"/>
                                    </td>
                                    <td>
                                        <span class="iac-value iac-${result.category.toLowerCase()}">
                                            <fmt:formatNumber value="${result.iac_value}" pattern="#0.00"/>%
                                        </span>
                                    </td>
                                    <td>
                                        <span class="category-badge badge-${result.category.toLowerCase()}">
                                            ${result.category}
                                        </span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/history" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="resultId" value="${result.id}">
                                            <button type="submit" class="btn btn-danger btn-sm" 
                                                    onclick="return confirm('¿Estás seguro de que quieres eliminar este resultado?')">
                                                🗑️ Eliminar
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
            
            <c:if test="${empty results}">
                <div class="no-results">
                    <i>📊</i>
                    <h3>No se encontraron resultados</h3>
                    <p>No hay cálculos de IAC registrados con los criterios especificados.</p>
                    <p>¡Realiza tu primer cálculo para comenzar a ver tu historial!</p>
                    <br>
                    <a href="${pageContext.request.contextPath}/calculator.jsp" class="btn btn-primary">🧮 Calcular IAC</a>
                </div>
            </c:if>
            
            <c:if test="${not empty results}">
                <div class="chart-container">
                    <h3>📈 Evolución del IAC</h3>
                    <p><em>Gráfico de tendencias próximamente disponible</em></p>
                    <small>Esta funcionalidad mostrará la evolución de tus resultados IAC a lo largo del tiempo</small>
                </div>
            </c:if>
        </div>
        
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/index.jsp">← Volver al Inicio</a>
            <a href="${pageContext.request.contextPath}/calculator.jsp">Calcular IAC</a>
            <a href="${pageContext.request.contextPath}/register.jsp">Registrarse</a>
        </div>
    </div>
    
    <script>
        // Confirmación para eliminar resultados
        document.querySelectorAll('form[action="${pageContext.request.contextPath}/history"] button[type="submit"]').forEach(button => {
            if (button.textContent.includes('Eliminar')) {
                button.addEventListener('click', function(e) {
                    if (!confirm('¿Estás seguro de que quieres eliminar este resultado? Esta acción no se puede deshacer.')) {
                        e.preventDefault();
                    }
                });
            }
        });
        
        // Auto-submit del formulario cuando cambia la vista
        document.getElementById('view').addEventListener('change', function() {
            if (this.value === 'all') {
                document.getElementById('userName').value = '';
            }
        });
    </script>
</body>
</html>