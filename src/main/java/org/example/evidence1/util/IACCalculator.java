package org.example.evidence1.util;

/**
 * Clase utilitaria para cálculos relacionados con el Índice de Adiposidad Corporal (IAC)
 */
public class IACCalculator {
    
    // Constantes para las categorías IAC
    public static final String CATEGORIA_BAJO = "Bajo";
    public static final String CATEGORIA_NORMAL = "Normal";
    public static final String CATEGORIA_SOBREPESO = "Sobrepeso";
    public static final String CATEGORIA_OBESIDAD = "Obesidad";
    
    // Rangos de IAC por sexo
    // Para hombres
    private static final double HOMBRE_BAJO_MAX = 8.0;
    private static final double HOMBRE_NORMAL_MAX = 21.0;
    private static final double HOMBRE_SOBREPESO_MAX = 26.0;
    
    // Para mujeres
    private static final double MUJER_BAJO_MAX = 21.0;
    private static final double MUJER_NORMAL_MAX = 33.0;
    private static final double MUJER_SOBREPESO_MAX = 39.0;
    
    /**
     * Calcula el Índice de Adiposidad Corporal (IAC)
     * Fórmula: IAC = (hip_cm / (height_m ^ 1.5)) - 18
     * 
     * @param hip_cm circunferencia de cadera en centímetros
     * @param height_m estatura en metros
     * @return valor del IAC calculado
     * @throws IllegalArgumentException si los parámetros son inválidos
     */
    public static double calcularIAC(double hip_cm, double height_m) {
        // Validaciones
        if (hip_cm <= 0) {
            throw new IllegalArgumentException("La circunferencia de cadera debe ser mayor a 0");
        }
        if (height_m <= 0) {
            throw new IllegalArgumentException("La estatura debe ser mayor a 0");
        }
        if (height_m > 3.0) {
            throw new IllegalArgumentException("La estatura parece demasiado alta (mayor a 3 metros)");
        }
        if (hip_cm > 200) {
            throw new IllegalArgumentException("La circunferencia de cadera parece demasiado alta (mayor a 200 cm)");
        }
        
        // Cálculo del IAC
        double heightPower = Math.pow(height_m, 1.5);
        double iac = (hip_cm / heightPower) - 18.0;
        
        // Redondear a 2 decimales
        return Math.round(iac * 100.0) / 100.0;
    }
    
    /**
     * Determina la categoría del IAC basada en el valor y el sexo
     * 
     * @param iac valor del IAC
     * @param sexo sexo de la persona ('M' para masculino, 'F' para femenino, 'O' para otro)
     * @return categoría del IAC
     */
    public static String categoria(double iac, String sexo) {
        if (sexo == null) {
            sexo = "O"; // Por defecto usar rangos generales
        }
        
        sexo = sexo.toUpperCase();
        
        switch (sexo) {
            case "M": // Masculino
                return categoriaHombre(iac);
            case "F": // Femenino
                return categoriaMujer(iac);
            default: // Otro o no especificado - usar rangos promedio
                return categoriaGeneral(iac);
        }
    }
    
    /**
     * Sobrecarga del método categoria para cuando no se especifica el sexo
     * 
     * @param iac valor del IAC
     * @return categoría del IAC usando rangos generales
     */
    public static String categoria(double iac) {
        return categoria(iac, "O");
    }
    
    /**
     * Determina la categoría IAC para hombres
     * 
     * @param iac valor del IAC
     * @return categoría del IAC para hombres
     */
    private static String categoriaHombre(double iac) {
        if (iac <= HOMBRE_BAJO_MAX) {
            return CATEGORIA_BAJO;
        } else if (iac <= HOMBRE_NORMAL_MAX) {
            return CATEGORIA_NORMAL;
        } else if (iac <= HOMBRE_SOBREPESO_MAX) {
            return CATEGORIA_SOBREPESO;
        } else {
            return CATEGORIA_OBESIDAD;
        }
    }
    
    /**
     * Determina la categoría IAC para mujeres
     * 
     * @param iac valor del IAC
     * @return categoría del IAC para mujeres
     */
    private static String categoriaMujer(double iac) {
        if (iac <= MUJER_BAJO_MAX) {
            return CATEGORIA_BAJO;
        } else if (iac <= MUJER_NORMAL_MAX) {
            return CATEGORIA_NORMAL;
        } else if (iac <= MUJER_SOBREPESO_MAX) {
            return CATEGORIA_SOBREPESO;
        } else {
            return CATEGORIA_OBESIDAD;
        }
    }
    
    /**
     * Determina la categoría IAC usando rangos generales (promedio entre hombres y mujeres)
     * 
     * @param iac valor del IAC
     * @return categoría del IAC usando rangos generales
     */
    private static String categoriaGeneral(double iac) {
        if (iac <= 14.5) { // Promedio entre 8 y 21
            return CATEGORIA_BAJO;
        } else if (iac <= 27.0) { // Promedio entre 21 y 33
            return CATEGORIA_NORMAL;
        } else if (iac <= 32.5) { // Promedio entre 26 y 39
            return CATEGORIA_SOBREPESO;
        } else {
            return CATEGORIA_OBESIDAD;
        }
    }
    
    /**
     * Obtiene información detallada sobre los rangos IAC para un sexo específico
     * 
     * @param sexo sexo de la persona
     * @return String con información de los rangos
     */
    public static String obtenerRangosInfo(String sexo) {
        if (sexo == null) {
            sexo = "O";
        }
        
        sexo = sexo.toUpperCase();
        
        switch (sexo) {
            case "M":
                return String.format("Rangos IAC para Hombres:\n" +
                        "• %s: ≤ %.1f\n" +
                        "• %s: %.1f - %.1f\n" +
                        "• %s: %.1f - %.1f\n" +
                        "• %s: > %.1f",
                        CATEGORIA_BAJO, HOMBRE_BAJO_MAX,
                        CATEGORIA_NORMAL, HOMBRE_BAJO_MAX + 0.1, HOMBRE_NORMAL_MAX,
                        CATEGORIA_SOBREPESO, HOMBRE_NORMAL_MAX + 0.1, HOMBRE_SOBREPESO_MAX,
                        CATEGORIA_OBESIDAD, HOMBRE_SOBREPESO_MAX);
                        
            case "F":
                return String.format("Rangos IAC para Mujeres:\n" +
                        "• %s: ≤ %.1f\n" +
                        "• %s: %.1f - %.1f\n" +
                        "• %s: %.1f - %.1f\n" +
                        "• %s: > %.1f",
                        CATEGORIA_BAJO, MUJER_BAJO_MAX,
                        CATEGORIA_NORMAL, MUJER_BAJO_MAX + 0.1, MUJER_NORMAL_MAX,
                        CATEGORIA_SOBREPESO, MUJER_NORMAL_MAX + 0.1, MUJER_SOBREPESO_MAX,
                        CATEGORIA_OBESIDAD, MUJER_SOBREPESO_MAX);
                        
            default:
                return "Rangos IAC Generales:\n" +
                        "• " + CATEGORIA_BAJO + ": ≤ 14.5\n" +
                        "• " + CATEGORIA_NORMAL + ": 14.6 - 27.0\n" +
                        "• " + CATEGORIA_SOBREPESO + ": 27.1 - 32.5\n" +
                        "• " + CATEGORIA_OBESIDAD + ": > 32.5";
        }
    }
    
    /**
     * Valida si los parámetros de entrada son válidos para el cálculo
     * 
     * @param hip_cm circunferencia de cadera en centímetros
     * @param height_m estatura en metros
     * @return true si los parámetros son válidos, false en caso contrario
     */
    public static boolean validarParametros(double hip_cm, double height_m) {
        return hip_cm > 0 && hip_cm <= 200 && height_m > 0 && height_m <= 3.0;
    }
}