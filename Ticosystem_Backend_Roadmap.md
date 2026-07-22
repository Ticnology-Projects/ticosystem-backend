# Roadmap de Desarrollo Backend - Ticosystem (NestJS + Prisma)

Este documento detalla el plan de desarrollo para el backend de **Ticosystem**, un sistema multitenant de gestión de facturas y servicios de TI. La arquitectura está diseñada ("API-First") para soportar de manera robusta y segura tanto clientes web (Vite + React) como aplicaciones móviles offline-first (Flutter).

---

## Fase 1: Configuración Core y Capa de Datos (Multitenancy)
**Objetivo:** Establecer los cimientos del servidor, asegurando que la arquitectura multitenant sea inviolable a nivel de base de datos y que los errores se manejen de forma estandarizada.

* **Setup Inicial:** Inicialización de NestJS y configuración de Prisma Client con la base de datos PostgreSQL.
* **Prisma Extensions (Multitenancy):** Implementación de un middleware o `Prisma Client Extension` global. Esto interceptará todas las consultas a la base de datos para inyectar automáticamente la cláusula `WHERE organization_id = ?`, evitando fugas de datos entre inquilinos.
* **Manejo de Excepciones:** Creación de un `GlobalExceptionFilter` para estandarizar las respuestas de error (JSON consistente con status HTTP).
* **Seed de Base de Datos:** Script inicial para inyectar al usuario Super-Admin, la organización base y los permisos iniciales.

---

## Fase 2: Autenticación Híbrida y Gestión de Sesiones (Auth Module)
**Objetivo:** Crear la puerta de entrada segura al sistema soportando distintos tipos de clientes y manteniendo un control estricto de las sesiones.

* **Estrategia Híbrida JWT:** Configuración de `Passport` y `JwtModule` para aceptar credenciales de dos formas:
    * **Vía Cookies `HttpOnly`:** Para la aplicación web (React).
    * **Vía Header `Authorization: Bearer`:** Para la aplicación móvil (Flutter).
* **Módulo de Sesiones (`user_session`):** Implementación del inicio de sesión que almacene la IP, el `user_agent`, la fecha de expiración y el hash del `refresh_token`. Esta tabla consolida la lista negra; si un token no existe o tiene `is_revoked = true`, el acceso es denegado.
* **Rotación y Revocación:** Endpoints para refrescar el `access_token` y para cerrar sesión (revocando el token remotamente).

---

## Fase 3: Autorización, Guards y RBAC
**Objetivo:** Construir los "muros" de seguridad para los endpoints basados en el rol del empleado en su respectiva organización.

* **`JwtAuthGuard`:** Valida la legitimidad y vigencia del `access_token` del usuario.
* **`TenantGuard`:** Extrae el `organization_id` del token validado y lo inyecta en el contexto de Prisma para aislar el alcance de las consultas.
* **`PermissionGuard` (RBAC):** Creación de un decorador personalizado (ej. `@RequirePermissions('create:invoice')`). Este guard leerá el `position_id` del usuario, consultará la tabla `position_permission` y determinará si deja pasar la petición (Status 200) o lanza un `403 Forbidden`.

---

## Fase 4: Módulos Administrativos Base
**Objetivo:** Desarrollo de los CRUDs fundamentales para la configuración y administración del sistema.

* **Organizaciones y Perfiles:** Endpoints para gestionar la tabla maestra `organization` y sus perfiles derivados (`client_profile` y `vendor_profile`), manejando identificadores fiscales (RUC o Tax ID internacional).
* **Posiciones y Permisos:** Gestión de roles y la asignación de permisos dinámicos a través de la tabla `position_permission`.
* **Usuarios:** Creación, edición, reseteo de contraseñas y asignación de usuarios a una posición y organización específica.

---

## Fase 5: Módulos de Negocio y Servicios (Soporte Offline-First)
**Objetivo:** El núcleo operativo de TI. Este módulo está adaptado para soportar a los técnicos en campo sin conexión a internet mediante la app móvil.

* **Catálogos:** CRUD de `product`, `service_category` y `service_activity`.
* **Servicios Recurrentes:** Endpoints para suscripciones como `domain_service`, `hosting`, `ms365_service`, `office_service`, etc.
* **Órdenes de Servicio (`service_order`):** * **Sincronización de Tiempos:** Los endpoints (`PATCH`) recibirán el `client_timestamp` enviado desde Flutter para registrar las fechas reales de inicio/fin (`startTime`, `endTime`), evitando usar la fecha del servidor cuando el internet se recupere.
    * **Resolución de Conflictos:** Uso de un versionado o hash para evitar que un técnico sobreescriba cambios realizados por un admin en la web mientras estaba offline.
* **Evidencias S3 y URLs Pre-firmadas:** Creación de un endpoint dedicado que genere "Presigned URLs" de AWS S3. La app en Flutter solicitará estas URLs, subirá directamente los binarios de fotos (`service_order_photo`) a S3, y enviará solo los enlaces (URLs) al backend, optimizando el ancho de banda.

---

## Fase 6: Facturación, Pagos y Trazabilidad Histórica
**Objetivo:** Flujo financiero y contable de la empresa, gestionando facturas y relaciones complejas de pago.

* **Facturación (`invoice`):** Endpoints para facturas de compra y venta (`purchase_invoice`, `sale_invoice`), preparadas para tipos de comprobante SUNAT y facturas internacionales (divisas y país).
* **Módulo de Pagos (`payment` & `invoice_payment`):** Endpoints para registrar egresos/ingresos, permitiendo un pago a múltiples facturas o pagos parciales a una sola factura, guardando el enlace al comprobante (`voucher_url` en S3).
* **Trazabilidad y Cierre Contable:** Implementación de lógica interna (eventos/servicios) que, al consolidar renovaciones o pagos de servicios, registre de manera automática las asociaciones en la tabla `service_invoice_history` para auditorías financieras.
