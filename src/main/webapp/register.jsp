<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Usuario - Calculadora IAC</title>
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
            max-width: 600px;
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
        
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 20px;
        }
        
        .form-tabs {
            display: flex;
            margin-bottom: 30px;
            border-bottom: 2px solid #e9ecef;
        }
        
        .tab-button {
            flex: 1;
            padding: 15px;
            background: none;
            border: none;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            color: #6c757d;
        }
        
        .tab-button.active {
            color: #667eea;
            border-bottom: 3px solid #667eea;
        }
        
        .tab-button:hover {
            color: #667eea;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 1.1rem;
        }
        
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f8f9fa;
        }
        
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .required {
            color: #dc3545;
        }
        
        .help-text {
            font-size: 0.9rem;
            color: #6c757d;
            margin-top: 5px;
            font-style: italic;
        }
        
        .btn {
            display: inline-block;
            padding: 15px 30px;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
            text-align: center;
            transition: all 0.3s ease;
            font-size: 1.1rem;
            border: none;
            cursor: pointer;
            width: 100%;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-success {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
        }
        
        .btn-secondary {
            background: linear-gradient(45deg, #6c757d, #495057);
            color: white;
            margin-top: 15px;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
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
        
        .alert-info {
            background-color: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
        }
        
        .user-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
            border-left: 4px solid #667eea;
        }
        
        .user-info h3 {
            color: #667eea;
            margin-bottom: 15px;
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
        
        .features-list {
            background: #e3f2fd;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
        }
        
        .features-list h4 {
            color: #1976d2;
            margin-bottom: 15px;
        }
        
        .features-list ul {
            list-style: none;
            padding: 0;
        }
        
        .features-list li {
            padding: 5px 0;
            color: #333;
        }
        
        .features-list li:before {
            content: "✓ ";
            color: #28a745;
            font-weight: bold;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .header h1 {
                font-size: 2rem;
            }
            
            .form-container {
                padding: 25px;
            }
            
            .user-details {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Gestión de Usuario</h1>
            <p>Registra o actualiza tu información personal</p>
        </div>
        
        <div class="form-container">
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
            
            <div class="form-tabs">
                <button class="tab-button active" onclick="showTab('register')">
                    👤 Nuevo Usuario
                </button>
                <button class="tab-button" onclick="showTab('update')">
                    ✏️ Actualizar Datos
                </button>
                <button class="tab-button" onclick="showTab('search')">
                    🔍 Buscar Usuario
                </button>
            </div>
            
            <!-- Tab: Registro de Nuevo Usuario -->
            <div id="register" class="tab-content active">
                <h2>📝 Registro de Nuevo Usuario</h2>
                
                <div class="features-list">
                    <h4>Beneficios de registrarte:</h4>
                    <ul>
                        <li>Guarda tu historial de cálculos IAC</li>
                        <li>Seguimiento de tu progreso a lo largo del tiempo</li>
                        <li>Acceso rápido a tus datos personales</li>
                        <li>Comparación de resultados anteriores</li>
                    </ul>
                </div>
                
                <form action="${pageContext.request.contextPath}/user" method="post">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="form-group">
                        <label for="nombre">Nombre Completo <span class="required">*</span></label>
                        <input type="text" id="nombre" name="nombre" required 
                               value="${param.nombre}" placeholder="Ingresa tu nombre completo">
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="edad">Edad <span class="required">*</span></label>
                            <input type="number" id="edad" name="edad" required min="1" max="120" 
                                   value="${param.edad}" placeholder="Años">
                        </div>
                        
                        <div class="form-group">
                            <label for="sexo">Sexo <span class="required">*</span></label>
                            <select id="sexo" name="sexo" required>
                                <option value="">Selecciona tu sexo</option>
                                <option value="M" ${param.sexo == 'M' ? 'selected' : ''}>Masculino</option>
                                <option value="F" ${param.sexo == 'F' ? 'selected' : ''}>Femenino</option>
                                <option value="O" ${param.sexo == 'O' ? 'selected' : ''}>Otro</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="estatura_m">Estatura (metros) <span class="required">*</span></label>
                            <input type="number" id="estatura_m" name="estatura_m" required 
                                   step="0.01" min="0.5" max="3.0" 
                                   value="${param.estatura_m}" placeholder="1.75">
                            <div class="help-text">Ejemplo: 1.75 para 1 metro 75 centímetros</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="peso_kg">Peso (kg) - Opcional</label>
                            <input type="number" id="peso_kg" name="peso_kg" 
                                   step="0.1" min="20" max="300" 
                                   value="${param.peso_kg}" placeholder="70.5">
                            <div class="help-text">Tu peso actual en kilogramos</div>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">
                        👤 Registrar Usuario
                    </button>
                </form>
            </div>
            
            <!-- Tab: Actualizar Usuario -->
            <div id="update" class="tab-content">
                <h2>✏️ Actualizar Información de Usuario</h2>
                
                <div class="alert alert-info">
                    <strong>Nota:</strong> Busca primero tu usuario para poder actualizar tus datos.
                </div>
                
                <c:if test="${not empty user}">
                    <div class="user-info">
                        <h3>Usuario Encontrado</h3>
                        <div class="user-details">
                            <div class="user-detail">
                                <span>ID:</span>
                                <strong>${user.id}</strong>
                            </div>
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
                                <strong>${user.estatura_m} m</strong>
                            </div>
                            <c:if test="${not empty user.peso_kg and user.peso_kg > 0}">
                                <div class="user-detail">
                                    <span>Peso:</span>
                                    <strong>${user.peso_kg} kg</strong>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <form action="${pageContext.request.contextPath}/user" method="post">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${user.id}">
                        
                        <div class="form-group">
                            <label for="update_nombre">Nombre Completo <span class="required">*</span></label>
                            <input type="text" id="update_nombre" name="nombre" required 
                                   value="${user.nombre}" placeholder="Ingresa tu nombre completo">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="update_edad">Edad <span class="required">*</span></label>
                                <input type="number" id="update_edad" name="edad" required min="1" max="120" 
                                       value="${user.edad}" placeholder="Años">
                            </div>
                            
                            <div class="form-group">
                                <label for="update_sexo">Sexo <span class="required">*</span></label>
                                <select id="update_sexo" name="sexo" required>
                                    <option value="">Selecciona tu sexo</option>
                                    <option value="M" ${user.sexo == 'M' ? 'selected' : ''}>Masculino</option>
                                    <option value="F" ${user.sexo == 'F' ? 'selected' : ''}>Femenino</option>
                                    <option value="O" ${user.sexo == 'O' ? 'selected' : ''}>Otro</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="update_estatura_m">Estatura (metros) <span class="required">*</span></label>
                                <input type="number" id="update_estatura_m" name="estatura_m" required 
                                       step="0.01" min="0.5" max="3.0" 
                                       value="${user.estatura_m}" placeholder="1.75">
                            </div>
                            
                            <div class="form-group">
                                <label for="update_peso_kg">Peso (kg) - Opcional</label>
                                <input type="number" id="update_peso_kg" name="peso_kg" 
                                       step="0.1" min="20" max="300" 
                                       value="${user.peso_kg}" placeholder="70.5">
                            </div>
                        </div>
                        
                        <button type="submit" class="btn btn-success">
                            ✏️ Actualizar Usuario
                        </button>
                    </form>
                </c:if>
                
                <c:if test="${empty user}">
                    <p>Primero busca un usuario en la pestaña "Buscar Usuario" para poder actualizar sus datos.</p>
                </c:if>
            </div>
            
            <!-- Tab: Buscar Usuario -->
            <div id="search" class="tab-content">
                <h2>🔍 Buscar Usuario</h2>
                
                <form action="${pageContext.request.contextPath}/user" method="get">
                    <input type="hidden" name="action" value="search">
                    
                    <div class="form-group">
                        <label for="search_nombre">Buscar por Nombre</label>
                        <input type="text" id="search_nombre" name="nombre" 
                               value="${param.nombre}" placeholder="Ingresa el nombre a buscar">
                        <div class="help-text">Busca usuarios por su nombre completo o parcial</div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">
                        🔍 Buscar Usuario
                    </button>
                </form>
                
                <c:if not empty="${users}">
                    <h3>Usuarios Encontrados:</h3>
                    <c:forEach var="foundUser" items="${users}">
                        <div class="user-info">
                            <div class="user-details">
                                <div class="user-detail">
                                    <span>Nombre:</span>
                                    <strong>${foundUser.nombre}</strong>
                                </div>
                                <div class="user-detail">
                                    <span>Edad:</span>
                                    <strong>${foundUser.edad} años</strong>
                                </div>
                                <div class="user-detail">
                                    <span>Sexo:</span>
                                    <strong>
                                        <c:choose>
                                            <c:when test="${foundUser.sexo == 'M'}">Masculino</c:when>
                                            <c:when test="${foundUser.sexo == 'F'}">Femenino</c:when>
                                            <c:otherwise>Otro</c:otherwise>
                                        </c:choose>
                                    </strong>
                                </div>
                            </div>
                            <form action="${pageContext.request.contextPath}/user" method="get" style="margin-top: 15px;">
                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="id" value="${foundUser.id}">
                                <button type="submit" class="btn btn-secondary">
                                    ✏️ Editar este Usuario
                                </button>
                            </form>
                        </div>
                    </c:forEach>
                </c:if>
            </div>
        </div>
        
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/index.jsp">← Volver al Inicio</a>
            <a href="${pageContext.request.contextPath}/calculator.jsp">Calcular IAC</a>
            <a href="${pageContext.request.contextPath}/history">Ver Historial</a>
        </div>
    </div>
    
    <script>
        function showTab(tabName) {
            // Ocultar todos los contenidos de tabs
            document.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            
            // Remover clase active de todos los botones
            document.querySelectorAll('.tab-button').forEach(button => {
                button.classList.remove('active');
            });
            
            // Mostrar el tab seleccionado
            document.getElementById(tabName).classList.add('active');
            
            // Activar el botón correspondiente
            event.target.classList.add('active');
        }
        
        // Validación de formularios
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function(e) {
                const estatura = form.querySelector('input[name="estatura_m"]');
                if (estatura && estatura.value) {
                    const estaturaValue = parseFloat(estatura.value);
                    if (estaturaValue < 0.5 || estaturaValue > 3.0) {
                        alert('La estatura debe estar entre 0.5 y 3.0 metros');
                        e.preventDefault();
                        return;
                    }
                }
                
                const peso = form.querySelector('input[name="peso_kg"]');
                if (peso && peso.value) {
                    const pesoValue = parseFloat(peso.value);
                    if (pesoValue < 20 || pesoValue > 300) {
                        alert('El peso debe estar entre 20 y 300 kg');
                        e.preventDefault();
                        return;
                    }
                }
            });
        });
        
        // Auto-formateo de decimales
        document.querySelectorAll('input[name="estatura_m"]').forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value) {
                    this.value = parseFloat(this.value).toFixed(2);
                }
            });
        });
        
        document.querySelectorAll('input[name="peso_kg"]').forEach(input => {
            input.addEventListener('blur', function() {
                if (this.value) {
                    this.value = parseFloat(this.value).toFixed(1);
                }
            });
        });
    </script>
</body>
</html>