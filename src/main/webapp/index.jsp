<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculadora IAC - Índice de Adiposidad Corporal</title>
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
            margin-bottom: 40px;
        }
        
        .header h1 {
            font-size: 3rem;
            margin-bottom: 10px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        
        .header p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        .main-content {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            margin-bottom: 30px;
        }
        
        .info-section {
            margin-bottom: 40px;
        }
        
        .info-section h2 {
            color: #667eea;
            margin-bottom: 20px;
            font-size: 2rem;
        }
        
        .info-section p {
            margin-bottom: 15px;
            font-size: 1.1rem;
            text-align: justify;
        }
        
        .formula {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 20px;
            margin: 20px 0;
            border-radius: 5px;
        }
        
        .formula h3 {
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .formula-text {
            font-family: 'Courier New', monospace;
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
            background: white;
            padding: 10px;
            border-radius: 5px;
            text-align: center;
        }
        
        .categories {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin: 30px 0;
        }
        
        .category-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            border: 2px solid transparent;
            transition: all 0.3s ease;
        }
        
        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .category-card.bajo { border-color: #28a745; }
        .category-card.normal { border-color: #17a2b8; }
        .category-card.sobrepeso { border-color: #ffc107; }
        .category-card.obesidad { border-color: #dc3545; }
        
        .category-card h4 {
            margin-bottom: 10px;
            font-size: 1.3rem;
        }
        
        .bajo h4 { color: #28a745; }
        .normal h4 { color: #17a2b8; }
        .sobrepeso h4 { color: #e67e22; }
        .obesidad h4 { color: #dc3545; }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 40px;
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
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-secondary {
            background: linear-gradient(45deg, #f093fb, #f5576c);
            color: white;
        }
        
        .btn-success {
            background: linear-gradient(45deg, #4facfe, #00f2fe);
            color: white;
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .footer {
            text-align: center;
            color: white;
            margin-top: 40px;
            opacity: 0.8;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }
            
            .main-content {
                padding: 20px;
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
            <h1>Calculadora IAC</h1>
            <p>Índice de Adiposidad Corporal - Evaluación Precisa de Grasa Corporal</p>
        </div>
        
        <div class="main-content">
            <div class="info-section">
                <h2>¿Qué es el Índice de Adiposidad Corporal (IAC)?</h2>
                <p>
                    El Índice de Adiposidad Corporal (IAC) es una medida alternativa al IMC que estima el porcentaje 
                    de grasa corporal utilizando únicamente la circunferencia de la cadera y la estatura. 
                    Fue desarrollado como una herramienta más precisa para evaluar la adiposidad, especialmente 
                    en diferentes grupos étnicos.
                </p>
                <p>
                    A diferencia del IMC, el IAC no requiere el peso corporal, lo que lo hace más accesible y 
                    potencialmente más preciso para estimar la grasa corporal en ciertas poblaciones.
                </p>
            </div>
            
            <div class="formula">
                <h3>Fórmula del IAC</h3>
                <div class="formula-text">
                    IAC = (Circunferencia de Cadera en cm / Estatura en m<sup>1.5</sup>) - 18
                </div>
            </div>
            
            <div class="info-section">
                <h2>Categorías del IAC</h2>
                <p>Los rangos del IAC varían según el sexo:</p>
                
                <div class="categories">
                    <div class="category-card bajo">
                        <h4>Bajo</h4>
                        <p><strong>Hombres:</strong> ≤ 8%</p>
                        <p><strong>Mujeres:</strong> ≤ 21%</p>
                    </div>
                    
                    <div class="category-card normal">
                        <h4>Normal</h4>
                        <p><strong>Hombres:</strong> 8.1% - 21%</p>
                        <p><strong>Mujeres:</strong> 21.1% - 33%</p>
                    </div>
                    
                    <div class="category-card sobrepeso">
                        <h4>Sobrepeso</h4>
                        <p><strong>Hombres:</strong> 21.1% - 26%</p>
                        <p><strong>Mujeres:</strong> 33.1% - 39%</p>
                    </div>
                    
                    <div class="category-card obesidad">
                        <h4>Obesidad</h4>
                        <p><strong>Hombres:</strong> > 26%</p>
                        <p><strong>Mujeres:</strong> > 39%</p>
                    </div>
                </div>
            </div>
            
            <div class="info-section">
                <h2>Ventajas del IAC</h2>
                <p>• <strong>No requiere peso:</strong> Solo necesita estatura y circunferencia de cadera</p>
                <p>• <strong>Más preciso:</strong> Mejor correlación con la grasa corporal que el IMC</p>
                <p>• <strong>Menos sesgado:</strong> Funciona mejor en diferentes grupos étnicos</p>
                <p>• <strong>Fácil de medir:</strong> Las medidas son simples de obtener</p>
            </div>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/calculator.jsp" class="btn btn-primary">
                    🧮 Calcular mi IAC
                </a>
                
                <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary">
                    👤 Registrarse
                </a>
                
                <a href="${pageContext.request.contextPath}/history" class="btn btn-success">
                    📊 Ver Historial
                </a>
            </div>
        </div>
        
        <div class="footer">
            <p>&copy; 2024 Calculadora IAC - Herramienta de Evaluación de Adiposidad Corporal</p>
        </div>
    </div>
</body>
</html>