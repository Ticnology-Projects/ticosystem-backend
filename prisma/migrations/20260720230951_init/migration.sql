-- CreateTable
CREATE TABLE "activity_service_order" (
    "id" UUID NOT NULL,
    "serviceOrderId" UUID NOT NULL,
    "serviceActivityId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "activity_service_order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "antivirus_service" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "url" TEXT,
    "clientProfileId" UUID NOT NULL,
    "purchasePrice" DECIMAL(19,4),
    "sellingPrice" DECIMAL(19,4),
    "period" INTEGER NOT NULL,
    "expirationDate" DATE NOT NULL,
    "userId" UUID NOT NULL,
    "observations" TEXT,
    "emailId" UUID,
    "status" TEXT NOT NULL,
    "reason" TEXT,
    "paymentType" TEXT,
    "purchaseInvoiceInvoiceId" UUID,
    "purchaseInvoiceVendorProfileId" UUID,
    "saleInvoiceInvoiceId" UUID,
    "saleInvoiceClientProfileId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "antivirus_service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "antivirus_vendor" (
    "id" UUID NOT NULL,
    "vendorProfileId" UUID NOT NULL,
    "antivirusServiceId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "antivirus_vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "client_profile" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "client_profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "copy_email" (
    "id" UUID NOT NULL,
    "copyEmail" TEXT NOT NULL,
    "emailId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "copy_email_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "domain" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "expirationDate" DATE NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "domain_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "domain_service" (
    "id" UUID NOT NULL,
    "clientProfileId" UUID NOT NULL,
    "billTo" TEXT,
    "domainId" UUID,
    "hostingId" UUID,
    "purchasePrice" DECIMAL(19,4),
    "expirationDateHosting" DATE,
    "period" INTEGER NOT NULL,
    "sellingPrice" DECIMAL(19,4),
    "userId" UUID NOT NULL,
    "state" TEXT NOT NULL,
    "observations" TEXT,
    "emailId" UUID,
    "phone" INTEGER,
    "status" TEXT NOT NULL,
    "reason" TEXT,
    "paymentType" TEXT,
    "purchaseInvoiceInvoiceId" UUID,
    "purchaseInvoiceVendorProfileId" UUID,
    "saleInvoiceInvoiceId" UUID,
    "saleInvoiceClientProfileId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "domain_service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "domain_vendor" (
    "id" UUID NOT NULL,
    "vendorProfileId" UUID NOT NULL,
    "domainServiceId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "domain_vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "email" (
    "id" UUID NOT NULL,
    "mail" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "email_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "email_catalog" (
    "id" UUID NOT NULL,
    "mail" TEXT NOT NULL,
    "userId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "email_catalog_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hosting" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "hosting_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hosting_vendor" (
    "id" UUID NOT NULL,
    "vendorProfileId" UUID NOT NULL,
    "domainServiceId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "hosting_vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice" (
    "id" UUID NOT NULL,
    "invoiceNumber" TEXT NOT NULL,
    "issueDate" DATE NOT NULL,
    "subtotal" DECIMAL(19,4) NOT NULL,
    "tax" DECIMAL(19,4) NOT NULL,
    "total" DECIMAL(19,4) NOT NULL,
    "type" TEXT NOT NULL,
    "deduction" DECIMAL(19,4) NOT NULL,
    "dueDate" DATE NOT NULL,
    "currency" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invoice_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice_payment" (
    "id" UUID NOT NULL,
    "paymentId" UUID NOT NULL,
    "invoiceId" UUID NOT NULL,
    "amountApplied" DECIMAL(19,4) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invoice_payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice_service_order" (
    "id" UUID NOT NULL,
    "invoiceId" UUID NOT NULL,
    "serviceOrderId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invoice_service_order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "item" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "brand" TEXT NOT NULL,
    "productCatalogId" UUID NOT NULL,
    "serialNumber" TEXT NOT NULL,
    "itemId" UUID,
    "description" TEXT NOT NULL,
    "sellingPrice" DECIMAL(19,4) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ms365_service" (
    "id" UUID NOT NULL,
    "url" TEXT,
    "clientProfileId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "purchasePrice" DECIMAL(19,4),
    "sellingPrice" DECIMAL(19,4),
    "period" INTEGER NOT NULL,
    "expirationDate" DATE NOT NULL,
    "userId" UUID NOT NULL,
    "emailId" UUID,
    "status" TEXT NOT NULL,
    "reason" TEXT,
    "paymentType" TEXT,
    "purchaseInvoiceInvoiceId" UUID,
    "purchaseInvoiceVendorProfileId" UUID,
    "saleInvoiceInvoiceId" UUID,
    "saleInvoiceClientProfileId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ms365_service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ms365_vendor" (
    "id" UUID NOT NULL,
    "vendorProfileId" UUID NOT NULL,
    "ms365ServiceId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ms365_vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "office_service" (
    "id" UUID NOT NULL,
    "url" TEXT,
    "clientProfileId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "purchasePrice" DECIMAL(19,4),
    "sellingPrice" DECIMAL(19,4),
    "period" INTEGER NOT NULL,
    "expirationDate" DATE NOT NULL,
    "emailId" UUID,
    "status" TEXT NOT NULL,
    "reason" TEXT,
    "paymentType" TEXT,
    "purchaseInvoiceInvoiceId" UUID,
    "purchaseInvoiceVendorProfileId" UUID,
    "saleInvoiceInvoiceId" UUID,
    "saleInvoiceClientProfileId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "office_service_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "office_vendor" (
    "id" UUID NOT NULL,
    "vendorProfileId" UUID NOT NULL,
    "officeServiceId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "office_vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization" (
    "id" UUID NOT NULL,
    "legalName" TEXT NOT NULL,
    "taxId" TEXT,
    "countryCode" TEXT NOT NULL,
    "mainContact" TEXT NOT NULL,
    "mainEmail" TEXT NOT NULL,
    "mainPhone" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "addressMapsLink" TEXT NOT NULL,
    "notes" TEXT NOT NULL,
    "website" TEXT,
    "organizationCategoryId" UUID NOT NULL,
    "isActive" BOOLEAN NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "organization_category" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "organization_category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment" (
    "id" UUID NOT NULL,
    "amount" DECIMAL(19,4) NOT NULL,
    "paymentDate" DATE NOT NULL,
    "currency" TEXT NOT NULL,
    "paymentMethod" TEXT NOT NULL,
    "voucherUrl" TEXT NOT NULL,
    "notes" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permission" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "permission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "position" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "organizationId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "position_permission" (
    "id" UUID NOT NULL,
    "permissionId" UUID NOT NULL,
    "positionId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "position_permission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "productVendorId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_vendor" (
    "id" UUID NOT NULL,
    "vendorProfileId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "product_vendor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "profit_month" (
    "id" UUID NOT NULL,
    "profit" DECIMAL(19,4) NOT NULL,
    "month" INTEGER NOT NULL,
    "year" INTEGER NOT NULL,
    "userId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "profit_month_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "purchase_invoice" (
    "invoiceId" UUID NOT NULL,
    "vendorProfileId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "purchase_invoice_pkey" PRIMARY KEY ("invoiceId","vendorProfileId")
);

-- CreateTable
CREATE TABLE "role" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "role_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_permission" (
    "roleId" UUID NOT NULL,
    "permissionId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "role_permission_pkey" PRIMARY KEY ("roleId","permissionId")
);

-- CreateTable
CREATE TABLE "sale_invoice" (
    "invoiceId" UUID NOT NULL,
    "clientProfileId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sale_invoice_pkey" PRIMARY KEY ("invoiceId","clientProfileId")
);

-- CreateTable
CREATE TABLE "service_activity" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "userId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_activity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_category" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "activityServiceId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_category_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_invoice_history" (
    "id" UUID NOT NULL,
    "serviceType" TEXT NOT NULL,
    "serviceId" UUID NOT NULL,
    "purchaseInvoiceInvoiceId" UUID NOT NULL,
    "purchaseInvoiceVendorProfileId" UUID NOT NULL,
    "saleInvoiceInvoiceId" UUID NOT NULL,
    "saleInvoiceClientProfileId" UUID NOT NULL,
    "recordedAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_invoice_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_order" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "clientProfileId" UUID NOT NULL,
    "initialTasks" TEXT,
    "finalObservations" TEXT,
    "scheduledDate" DATE,
    "startAddress" TEXT,
    "startTime" TIMESTAMP(3),
    "endTime" TIMESTAMP(3),
    "endAddress" TEXT,
    "signatureBase64" TEXT,
    "servicePrice" DECIMAL(19,4) NOT NULL,
    "mainContact" TEXT NOT NULL,
    "mainPhone" TEXT NOT NULL,
    "mainEmail" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "reason" TEXT,
    "paymentType" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "service_order_photo" (
    "id" UUID NOT NULL,
    "type" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "serviceOrderId" UUID NOT NULL,
    "extension" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "service_order_photo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" UUID NOT NULL,
    "firstName" TEXT NOT NULL,
    "middleName" TEXT,
    "firstSurname" TEXT NOT NULL,
    "secondSurname" TEXT NOT NULL,
    "mail" TEXT NOT NULL,
    "phone" INTEGER NOT NULL,
    "password" TEXT NOT NULL,
    "positionId" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "isActive" BOOLEAN NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_role" (
    "userId" UUID NOT NULL,
    "roleId" UUID NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_role_pkey" PRIMARY KEY ("userId","roleId")
);

-- CreateTable
CREATE TABLE "user_sessions" (
    "id" UUID NOT NULL,
    "userId" UUID NOT NULL,
    "refreshToken" TEXT NOT NULL,
    "ipAddress" TEXT NOT NULL,
    "userAgent" TEXT NOT NULL,
    "isRevoked" BOOLEAN NOT NULL DEFAULT false,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "vendor_profile" (
    "id" UUID NOT NULL,
    "organizationId" UUID NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vendor_profile_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "warranty" (
    "id" UUID NOT NULL,
    "monthsWarranty" INTEGER NOT NULL,
    "startDate" DATE NOT NULL,
    "endDate" DATE NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "warranty_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "warranty_service" (
    "id" UUID NOT NULL,
    "clientProfileId" UUID NOT NULL,
    "productId" UUID NOT NULL,
    "warrantyId" UUID NOT NULL,
    "emailId" UUID NOT NULL,
    "status" TEXT NOT NULL,
    "reason" TEXT,
    "paymentType" TEXT,
    "sellingPrice" DECIMAL(19,4),
    "purchasePrice" DECIMAL(19,4),
    "saleInvoiceInvoiceId" UUID,
    "saleInvoiceClientProfileId" UUID,
    "purchaseInvoiceInvoiceId" UUID,
    "purchaseInvoiceVendorProfileId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "warranty_service_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_mail_key" ON "user"("mail");

-- CreateIndex
CREATE UNIQUE INDEX "user_sessions_refreshToken_key" ON "user_sessions"("refreshToken");

-- AddForeignKey
ALTER TABLE "activity_service_order" ADD CONSTRAINT "activity_service_order_serviceOrderId_fkey" FOREIGN KEY ("serviceOrderId") REFERENCES "service_order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "activity_service_order" ADD CONSTRAINT "activity_service_order_serviceActivityId_fkey" FOREIGN KEY ("serviceActivityId") REFERENCES "service_activity"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "antivirus_service" ADD CONSTRAINT "antivirus_service_clientProfileId_fkey" FOREIGN KEY ("clientProfileId") REFERENCES "client_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "antivirus_service" ADD CONSTRAINT "antivirus_service_emailId_fkey" FOREIGN KEY ("emailId") REFERENCES "email"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "antivirus_service" ADD CONSTRAINT "antivirus_service_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "antivirus_service" ADD CONSTRAINT "antivirus_service_purchaseInvoiceInvoiceId_purchaseInvoice_fkey" FOREIGN KEY ("purchaseInvoiceInvoiceId", "purchaseInvoiceVendorProfileId") REFERENCES "purchase_invoice"("invoiceId", "vendorProfileId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "antivirus_service" ADD CONSTRAINT "antivirus_service_saleInvoiceInvoiceId_saleInvoiceClientPr_fkey" FOREIGN KEY ("saleInvoiceInvoiceId", "saleInvoiceClientProfileId") REFERENCES "sale_invoice"("invoiceId", "clientProfileId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "antivirus_vendor" ADD CONSTRAINT "antivirus_vendor_vendorProfileId_fkey" FOREIGN KEY ("vendorProfileId") REFERENCES "vendor_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "antivirus_vendor" ADD CONSTRAINT "antivirus_vendor_antivirusServiceId_fkey" FOREIGN KEY ("antivirusServiceId") REFERENCES "antivirus_service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "client_profile" ADD CONSTRAINT "client_profile_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "copy_email" ADD CONSTRAINT "copy_email_emailId_fkey" FOREIGN KEY ("emailId") REFERENCES "email"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "domain_service" ADD CONSTRAINT "domain_service_clientProfileId_fkey" FOREIGN KEY ("clientProfileId") REFERENCES "client_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "domain_service" ADD CONSTRAINT "domain_service_domainId_fkey" FOREIGN KEY ("domainId") REFERENCES "domain"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "domain_service" ADD CONSTRAINT "domain_service_hostingId_fkey" FOREIGN KEY ("hostingId") REFERENCES "hosting"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "domain_service" ADD CONSTRAINT "domain_service_emailId_fkey" FOREIGN KEY ("emailId") REFERENCES "email"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "domain_service" ADD CONSTRAINT "domain_service_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "domain_service" ADD CONSTRAINT "domain_service_purchaseInvoiceInvoiceId_purchaseInvoiceVen_fkey" FOREIGN KEY ("purchaseInvoiceInvoiceId", "purchaseInvoiceVendorProfileId") REFERENCES "purchase_invoice"("invoiceId", "vendorProfileId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "domain_service" ADD CONSTRAINT "domain_service_saleInvoiceInvoiceId_saleInvoiceClientProfi_fkey" FOREIGN KEY ("saleInvoiceInvoiceId", "saleInvoiceClientProfileId") REFERENCES "sale_invoice"("invoiceId", "clientProfileId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "domain_vendor" ADD CONSTRAINT "domain_vendor_vendorProfileId_fkey" FOREIGN KEY ("vendorProfileId") REFERENCES "vendor_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "domain_vendor" ADD CONSTRAINT "domain_vendor_domainServiceId_fkey" FOREIGN KEY ("domainServiceId") REFERENCES "domain_service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "email_catalog" ADD CONSTRAINT "email_catalog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hosting_vendor" ADD CONSTRAINT "hosting_vendor_vendorProfileId_fkey" FOREIGN KEY ("vendorProfileId") REFERENCES "vendor_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hosting_vendor" ADD CONSTRAINT "hosting_vendor_domainServiceId_fkey" FOREIGN KEY ("domainServiceId") REFERENCES "domain_service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_payment" ADD CONSTRAINT "invoice_payment_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "payment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_payment" ADD CONSTRAINT "invoice_payment_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoice"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_service_order" ADD CONSTRAINT "invoice_service_order_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoice"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_service_order" ADD CONSTRAINT "invoice_service_order_serviceOrderId_fkey" FOREIGN KEY ("serviceOrderId") REFERENCES "service_order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item" ADD CONSTRAINT "item_productCatalogId_fkey" FOREIGN KEY ("productCatalogId") REFERENCES "product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "item" ADD CONSTRAINT "item_itemId_fkey" FOREIGN KEY ("itemId") REFERENCES "item"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ms365_service" ADD CONSTRAINT "ms365_service_clientProfileId_fkey" FOREIGN KEY ("clientProfileId") REFERENCES "client_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ms365_service" ADD CONSTRAINT "ms365_service_emailId_fkey" FOREIGN KEY ("emailId") REFERENCES "email"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ms365_service" ADD CONSTRAINT "ms365_service_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ms365_service" ADD CONSTRAINT "ms365_service_purchaseInvoiceInvoiceId_purchaseInvoiceVend_fkey" FOREIGN KEY ("purchaseInvoiceInvoiceId", "purchaseInvoiceVendorProfileId") REFERENCES "purchase_invoice"("invoiceId", "vendorProfileId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ms365_service" ADD CONSTRAINT "ms365_service_saleInvoiceInvoiceId_saleInvoiceClientProfil_fkey" FOREIGN KEY ("saleInvoiceInvoiceId", "saleInvoiceClientProfileId") REFERENCES "sale_invoice"("invoiceId", "clientProfileId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ms365_vendor" ADD CONSTRAINT "ms365_vendor_vendorProfileId_fkey" FOREIGN KEY ("vendorProfileId") REFERENCES "vendor_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ms365_vendor" ADD CONSTRAINT "ms365_vendor_ms365ServiceId_fkey" FOREIGN KEY ("ms365ServiceId") REFERENCES "ms365_service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "office_service" ADD CONSTRAINT "office_service_clientProfileId_fkey" FOREIGN KEY ("clientProfileId") REFERENCES "client_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "office_service" ADD CONSTRAINT "office_service_emailId_fkey" FOREIGN KEY ("emailId") REFERENCES "email"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "office_service" ADD CONSTRAINT "office_service_purchaseInvoiceInvoiceId_purchaseInvoiceVen_fkey" FOREIGN KEY ("purchaseInvoiceInvoiceId", "purchaseInvoiceVendorProfileId") REFERENCES "purchase_invoice"("invoiceId", "vendorProfileId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "office_service" ADD CONSTRAINT "office_service_saleInvoiceInvoiceId_saleInvoiceClientProfi_fkey" FOREIGN KEY ("saleInvoiceInvoiceId", "saleInvoiceClientProfileId") REFERENCES "sale_invoice"("invoiceId", "clientProfileId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "office_vendor" ADD CONSTRAINT "office_vendor_vendorProfileId_fkey" FOREIGN KEY ("vendorProfileId") REFERENCES "vendor_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "office_vendor" ADD CONSTRAINT "office_vendor_officeServiceId_fkey" FOREIGN KEY ("officeServiceId") REFERENCES "office_service"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "organization" ADD CONSTRAINT "organization_organizationCategoryId_fkey" FOREIGN KEY ("organizationCategoryId") REFERENCES "organization_category"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "position" ADD CONSTRAINT "position_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "position_permission" ADD CONSTRAINT "position_permission_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permission"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "position_permission" ADD CONSTRAINT "position_permission_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product" ADD CONSTRAINT "product_productVendorId_fkey" FOREIGN KEY ("productVendorId") REFERENCES "product_vendor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_vendor" ADD CONSTRAINT "product_vendor_vendorProfileId_fkey" FOREIGN KEY ("vendorProfileId") REFERENCES "vendor_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "profit_month" ADD CONSTRAINT "profit_month_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_invoice" ADD CONSTRAINT "purchase_invoice_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoice"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "purchase_invoice" ADD CONSTRAINT "purchase_invoice_vendorProfileId_fkey" FOREIGN KEY ("vendorProfileId") REFERENCES "vendor_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permission" ADD CONSTRAINT "role_permission_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "role_permission" ADD CONSTRAINT "role_permission_permissionId_fkey" FOREIGN KEY ("permissionId") REFERENCES "permission"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sale_invoice" ADD CONSTRAINT "sale_invoice_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoice"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sale_invoice" ADD CONSTRAINT "sale_invoice_clientProfileId_fkey" FOREIGN KEY ("clientProfileId") REFERENCES "client_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_activity" ADD CONSTRAINT "service_activity_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_category" ADD CONSTRAINT "service_category_activityServiceId_fkey" FOREIGN KEY ("activityServiceId") REFERENCES "service_activity"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_invoice_history" ADD CONSTRAINT "service_invoice_history_purchaseInvoiceInvoiceId_purchaseI_fkey" FOREIGN KEY ("purchaseInvoiceInvoiceId", "purchaseInvoiceVendorProfileId") REFERENCES "purchase_invoice"("invoiceId", "vendorProfileId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_invoice_history" ADD CONSTRAINT "service_invoice_history_saleInvoiceInvoiceId_saleInvoiceCl_fkey" FOREIGN KEY ("saleInvoiceInvoiceId", "saleInvoiceClientProfileId") REFERENCES "sale_invoice"("invoiceId", "clientProfileId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_order" ADD CONSTRAINT "service_order_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_order" ADD CONSTRAINT "service_order_clientProfileId_fkey" FOREIGN KEY ("clientProfileId") REFERENCES "client_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "service_order_photo" ADD CONSTRAINT "service_order_photo_serviceOrderId_fkey" FOREIGN KEY ("serviceOrderId") REFERENCES "service_order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_positionId_fkey" FOREIGN KEY ("positionId") REFERENCES "position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_role" ADD CONSTRAINT "user_role_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "role"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_sessions" ADD CONSTRAINT "user_sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "vendor_profile" ADD CONSTRAINT "vendor_profile_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "organization"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warranty_service" ADD CONSTRAINT "warranty_service_clientProfileId_fkey" FOREIGN KEY ("clientProfileId") REFERENCES "client_profile"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warranty_service" ADD CONSTRAINT "warranty_service_productId_fkey" FOREIGN KEY ("productId") REFERENCES "product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warranty_service" ADD CONSTRAINT "warranty_service_warrantyId_fkey" FOREIGN KEY ("warrantyId") REFERENCES "warranty"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warranty_service" ADD CONSTRAINT "warranty_service_emailId_fkey" FOREIGN KEY ("emailId") REFERENCES "email"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warranty_service" ADD CONSTRAINT "warranty_service_saleInvoiceInvoiceId_saleInvoiceClientPro_fkey" FOREIGN KEY ("saleInvoiceInvoiceId", "saleInvoiceClientProfileId") REFERENCES "sale_invoice"("invoiceId", "clientProfileId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warranty_service" ADD CONSTRAINT "warranty_service_purchaseInvoiceInvoiceId_purchaseInvoiceV_fkey" FOREIGN KEY ("purchaseInvoiceInvoiceId", "purchaseInvoiceVendorProfileId") REFERENCES "purchase_invoice"("invoiceId", "vendorProfileId") ON DELETE SET NULL ON UPDATE CASCADE;
