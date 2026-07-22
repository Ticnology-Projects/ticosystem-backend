import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '@prisma/client';
import * as argon2 from 'argon2';
import * as dotenv from 'dotenv';

dotenv.config();

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('🌱 Iniciando el script de Seed con arquitectura de doble capa...');

  // ==========================================
  // 1. EMPRESA MATRIZ (TICOSYSTEM)
  // ==========================================
  let category = await prisma.organizationCategory.findFirst({ where: { name: 'Gestor de Servicios TI' } });
  if (!category) {
    category = await prisma.organizationCategory.create({
      data: { name: 'Gestor de Servicios TI', description: 'Dueños de la plataforma SaaS' },
    });
  }

  let ticosystemOrg = await prisma.organization.findFirst({ where: { legalName: 'Ticosystem S.A.' } });
  if (!ticosystemOrg) {
    ticosystemOrg = await prisma.organization.create({
      data: {
        legalName: 'Ticosystem S.A.',
        countryCode: '+51',
        mainContact: 'Administración Global',
        mainEmail: 'admin@ticosystem.com',
        mainPhone: '932522414',
        address: 'Lima, Peru',
        addressMapsLink: 'https://www.google.com/maps/place/Av.+Carlos+Izaguirre+%26+Av.+Canta+Callao,+San+Mart%C3%ADn+de+Porres+15112/@-11.9864733,-77.1041936,20.5z/data=!4m5!3m4!1s0x9105cdd7829c6429:0x31751bd09816e598!8m2!3d-11.9889031!4d-77.1053234?shorturl=1',
        notes: 'Empresa Matriz Administradora',
        isActive: true,
        organizationCategoryId: category.id,
      },
    });
  }

  // ==========================================
  // 2. CREACIÓN DE PERMISOS
  // ==========================================
  const permissionsData = [
    { name: '*', description: 'Acceso absoluto a todo el sistema (App Level)' },
    { name: 'manage:tenants', description: 'Puede crear y gestionar otras empresas (App Level)' },
    { name: 'manage:billing', description: 'Gestiona la facturación global del SaaS (App Level)' },
    { name: 'manage:users', description: 'Gestiona los usuarios de su propia organización (Org Level)' },
    { name: 'view:reports', description: 'Puede ver reportes de su organización (Org Level)' },
  ];

  for (const p of permissionsData) {
    const exists = await prisma.permission.findFirst({ where: { name: p.name } });
    if (!exists) await prisma.permission.create({ data: p });
  }

  const pAll = await prisma.permission.findFirst({ where: { name: '*' } });
  const pTenants = await prisma.permission.findFirst({ where: { name: 'manage:tenants' } });
  const pBilling = await prisma.permission.findFirst({ where: { name: 'manage:billing' } });
  const pUsers = await prisma.permission.findFirst({ where: { name: 'manage:users' } });
  const pReports = await prisma.permission.findFirst({ where: { name: 'view:reports' } });

  // ==========================================
  // 3. ROLES (Nivel Aplicación)
  // ==========================================
  let superAdminRole = await prisma.role.findFirst({ where: { name: 'Super Administrador' } });
  if (!superAdminRole) {
    superAdminRole = await prisma.role.create({
      data: {
        name: 'Super Administrador',
        description: 'Control total de la plataforma',
        rolePermissions: {
          create: [{ permissionId: pAll!.id }], // Le asignamos el permiso '*'
        },
      },
    });
  }

  let superUserRole = await prisma.role.findFirst({ where: { name: 'Super Usuario' } });
  if (!superUserRole) {
    superUserRole = await prisma.role.create({
      data: {
        name: 'Super Usuario',
        description: 'Administración operativa de la plataforma',
        rolePermissions: {
          create: [{ permissionId: pTenants!.id }, { permissionId: pBilling!.id }],
        },
      },
    });
  }

  // ==========================================
  // 4. POSICIONES (Nivel Organización Ticosystem)
  // ==========================================
  let ceoPosition = await prisma.position.findFirst({ where: { name: 'Director General (CEO)' } });
  if (!ceoPosition) {
    ceoPosition = await prisma.position.create({
      data: {
        name: 'Director General (CEO)',
        description: 'Máxima autoridad interna en Ticosystem',
        organizationId: ticosystemOrg.id,
        positionPermissions: {
          create: [{ permissionId: pUsers!.id }, { permissionId: pReports!.id }],
        },
      },
    });
  }

  let opsManagerPosition = await prisma.position.findFirst({ where: { name: 'Gerente de Operaciones' } });
  if (!opsManagerPosition) {
    opsManagerPosition = await prisma.position.create({
      data: {
        name: 'Gerente de Operaciones',
        description: 'Control de procesos internos en Ticosystem',
        organizationId: ticosystemOrg.id,
        positionPermissions: {
          create: [{ permissionId: pReports!.id }],
        },
      },
    });
  }

  // ==========================================
  // 5. USUARIOS Y RELACIÓN FINAL
  // ==========================================
  const adminPassword = process.env.SUPERADMIN_PASSWORD || 'Admin123!';
  const passwordHash = await argon2.hash(adminPassword); // Argon2 en acción

  // --- Usuario 1: Super Administrador ---
  let adminUser = await prisma.user.findUnique({ where: { mail: 'admin@ticosystem.com' } });
  if (!adminUser) {
    adminUser = await prisma.user.create({
      data: {
        firstName: 'Super',
        firstSurname: 'Admin',
        secondSurname: 'Ticosystem',
        mail: 'admin@ticosystem.com',
        phone: 88888888,
        password: passwordHash,
        isActive: true,
        positionId: ceoPosition.id,       // Posición interna
        organizationId: ticosystemOrg.id, // Pertenece a la matriz
        // Relación con el Role de aplicación
        userRoles: {
          create: [{ roleId: superAdminRole.id }],
        },
      },
    });
    console.log(`✅ Super Admin creado: admin@ticosystem.com / Admin123!`);
  }

  // --- Usuario 2: Super Usuario ---
  let superUser = await prisma.user.findUnique({ where: { mail: 'operaciones@ticosystem.com' } });
  if (!superUser) {
    superUser = await prisma.user.create({
      data: {
        firstName: 'Super',
        firstSurname: 'Usuario',
        secondSurname: 'Operaciones',
        mail: 'operaciones@ticosystem.com',
        phone: 88888889,
        password: passwordHash,
        isActive: true,
        positionId: opsManagerPosition.id, // Posición interna
        organizationId: ticosystemOrg.id,  // Pertenece a la matriz
        userRoles: {
          create: [{ roleId: superUserRole.id }],
        },
      },
    });
    console.log(`✅ Super Usuario creado: operaciones@ticosystem.com / Admin123!`);
  }

  console.log('🚀 Seed completado exitosamente.');
}

main()
  .catch((e) => {
    console.error('Error durante el seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });