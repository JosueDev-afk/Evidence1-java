# Configuración de MySQL con Docker para Calculadora IAC

Este documento explica cómo configurar la base de datos MySQL usando Docker para la aplicación de Calculadora IAC.

## Requisitos Previos

- Docker instalado en tu sistema
- Puerto 3306 disponible (o cambiar el puerto en los comandos)

## Configuración Rápida

### 1. Crear y ejecutar el contenedor MySQL

```bash
docker run --name mysql-iac \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=iac_app \
  -e MYSQL_USER=iac_user \
  -e MYSQL_PASSWORD=pass123 \
  -p 3306:3306 \
  -d mysql:8.0
```

### 2. Verificar que el contenedor está ejecutándose

```bash
docker ps
```

Deberías ver el contenedor `mysql-iac` en la lista.

### 3. Conectar a MySQL y ejecutar scripts

#### Opción A: Usando cliente MySQL (si está instalado)

```bash
# Conectar como root
mysql -h localhost -P 3306 -u root -proot123

# O conectar como usuario de la aplicación
mysql -h localhost -P 3306 -u iac_user -ppass123 iac_app
```

#### Opción B: Usando Docker exec

```bash
# Conectar al contenedor
docker exec -it mysql-iac mysql -u root -proot123

# O directamente a la base de datos de la aplicación
docker exec -it mysql-iac mysql -u iac_user -ppass123 iac_app
```

### 4. Ejecutar los scripts SQL

Una vez conectado a MySQL, ejecuta los scripts en este orden:

```sql
-- 1. Crear el esquema (si no usas los archivos, copia el contenido)
source /path/to/schema.sql;

-- 2. Insertar datos de prueba
source /path/to/data.sql;
```

#### Alternativa: Copiar archivos al contenedor

```bash
# Copiar archivos SQL al contenedor
docker cp src/main/resources/database/schema.sql mysql-iac:/tmp/schema.sql
docker cp src/main/resources/database/data.sql mysql-iac:/tmp/data.sql

# Ejecutar los scripts
docker exec -i mysql-iac mysql -u root -proot123 < /tmp/schema.sql
docker exec -i mysql-iac mysql -u root -proot123 < /tmp/data.sql
```

## Configuración de la Aplicación

La aplicación está configurada para conectarse con estos parámetros:

- **Host**: localhost
- **Puerto**: 3306
- **Base de datos**: iac_app
- **Usuario**: iac_user
- **Contraseña**: pass123

Estos valores están configurados en el archivo `web.xml`.

## Comandos Útiles

### Gestión del contenedor

```bash
# Detener el contenedor
docker stop mysql-iac

# Iniciar el contenedor
docker start mysql-iac

# Reiniciar el contenedor
docker restart mysql-iac

# Ver logs del contenedor
docker logs mysql-iac

# Eliminar el contenedor (¡CUIDADO! Se perderán los datos)
docker rm -f mysql-iac
```

### Backup y Restore

```bash
# Crear backup
docker exec mysql-iac mysqldump -u root -proot123 iac_app > backup_iac_app.sql

# Restaurar backup
docker exec -i mysql-iac mysql -u root -proot123 iac_app < backup_iac_app.sql
```

### Acceso directo a la base de datos

```bash
# Conectar directamente a la base de datos de la aplicación
docker exec -it mysql-iac mysql -u iac_user -ppass123 iac_app
```

## Verificación de la Instalación

Una vez configurado, puedes verificar que todo funciona correctamente:

```sql
-- Verificar tablas creadas
SHOW TABLES;

-- Verificar usuarios de prueba
SELECT COUNT(*) as total_usuarios FROM users;

-- Verificar resultados IAC de prueba
SELECT COUNT(*) as total_resultados FROM iac_results;

-- Ver algunos datos de ejemplo
SELECT u.nombre, r.iac_value, r.category 
FROM users u 
JOIN iac_results r ON u.id = r.user_id 
LIMIT 5;
```

## Solución de Problemas

### Puerto 3306 ocupado

Si el puerto 3306 está ocupado, puedes usar otro puerto:

```bash
docker run --name mysql-iac \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=iac_app \
  -e MYSQL_USER=iac_user \
  -e MYSQL_PASSWORD=pass123 \
  -p 3307:3306 \
  -d mysql:8.0
```

Recuerda actualizar la configuración en `web.xml` para usar el puerto 3307.

### Problemas de conexión

1. Verifica que el contenedor esté ejecutándose: `docker ps`
2. Verifica los logs: `docker logs mysql-iac`
3. Asegúrate de que no hay firewall bloqueando el puerto
4. Verifica las credenciales en la aplicación

### Reiniciar desde cero

```bash
# Eliminar contenedor existente
docker rm -f mysql-iac

# Crear nuevo contenedor
docker run --name mysql-iac \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=iac_app \
  -e MYSQL_USER=iac_user \
  -e MYSQL_PASSWORD=pass123 \
  -p 3306:3306 \
  -d mysql:8.0

# Esperar unos segundos y ejecutar scripts
sleep 10
docker exec -i mysql-iac mysql -u root -proot123 < src/main/resources/database/schema.sql
docker exec -i mysql-iac mysql -u root -proot123 < src/main/resources/database/data.sql
```

## Notas Importantes

- Los datos se almacenan dentro del contenedor. Si eliminas el contenedor, perderás los datos.
- Para persistencia de datos en producción, considera usar volúmenes de Docker.
- Las credenciales mostradas son para desarrollo. Usa credenciales seguras en producción.
- El usuario `iac_user` tiene permisos completos sobre la base de datos `iac_app`.

## Configuración con Volumen Persistente (Recomendado)

Para evitar pérdida de datos:

```bash
# Crear volumen
docker volume create mysql-iac-data

# Ejecutar contenedor con volumen
docker run --name mysql-iac \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -e MYSQL_DATABASE=iac_app \
  -e MYSQL_USER=iac_user \
  -e MYSQL_PASSWORD=pass123 \
  -p 3306:3306 \
  -v mysql-iac-data:/var/lib/mysql \
  -d mysql:8.0
```