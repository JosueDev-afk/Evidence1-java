<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculadora IAC - Calcular Índice</title>
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
            max-width: 800px;
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
        
        .btn-secondary {
            background: linear-gradient(45deg, #6c757d, #495057);
            color: white;
            margin-top: 15px;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
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
        
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-weight: 500;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .formula-reminder {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-bottom: 25px;
            border-radius: 5px;
        }
        
        .formula-reminder h3 {
            color: #1976d2;
            margin-bottom: 8px;
            font-size: 1.2rem;
        }
        
        .formula-reminder p {
            margin: 0;
            color: #333;
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
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Calculadora IAC</h1>
            <p>Ingresa tus datos para calcular tu Índice de Adiposidad Corporal</p>
        </div>
        
        <div class="form-container">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    ${error}
                </div>
            </c:if>
            
            <div class="formula-reminder">
                <h3>Recordatorio de la Fórmula</h3>
                <p><strong>IAC = (Circunferencia de Cadera en cm / Estatura en m<sup>1.5</sup>) - 18</strong></p>
            </div>
            
            <form action="${pageContext.request.contextPath}/calculate" method="post">
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
                        <label for="hip_cm">Circunferencia de Cadera (cm) <span class="required">*</span></label>
                        <input type="number" id="hip_cm" name="hip_cm" required 
                               step="0.1" min="50" max="200" 
                               value="${param.hip_cm}" placeholder="95.5">
                        <div class="help-text">Mide en la parte más ancha de las caderas</div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="peso_kg">Peso (kg) - Opcional</label>
                    <input type="number" id="peso_kg" name="peso_kg" 
                           step="0.1" min="20" max="300" 
                           value="${param.peso_kg}" placeholder="70.5">
                    <div class="help-text">El peso es opcional para el cálculo del IAC, pero se guardará en tu perfil</div>
                </div>
                
                <button type="submit" class="btn btn-primary">
                    🧮 Calcular mi IAC
                </button>
                
                <button type="reset" class="btn btn-secondary">
                    🔄 Limpiar Formulario
                </button>
            </form>
        </div>
        
        <div class="navigation">
            <a href="${pageContext.request.contextPath}/index.jsp">← Volver al Inicio</a>
            <a href="${pageContext.request.contextPath}/user">Registrarse</a>
            <a href="${pageContext.request.contextPath}/history">Ver Historial</a>
        </div>
    </div>
    
    <script>
        // Validación adicional del formulario
        document.querySelector('form').addEventListener('submit', function(e) {
            const estatura = parseFloat(document.getElementById('estatura_m').value);
            const cadera = parseFloat(document.getElementById('hip_cm').value);
            
            if (estatura && (estatura < 0.5 || estatura > 3.0)) {
                alert('La estatura debe estar entre 0.5 y 3.0 metros');
                e.preventDefault();
                return;
            }
            
            if (cadera && (cadera < 50 || cadera > 200)) {
                alert('La circunferencia de cadera debe estar entre 50 y 200 cm');
                e.preventDefault();
                return;
            }
        });
        
        // Auto-formateo de decimales
        document.getElementById('estatura_m').addEventListener('blur', function() {
            if (this.value) {
                this.value = parseFloat(this.value).toFixed(2);
            }
        });
        
        document.getElementById('hip_cm').addEventListener('blur', function() {
            if (this.value) {
                this.value = parseFloat(this.value).toFixed(1);
            }
        });
        
        document.getElementById('peso_kg').addEventListener('blur', function() {
            if (this.value) {
                this.value = parseFloat(this.value).toFixed(1);
            }
        });
    </script>
</body>
</html>