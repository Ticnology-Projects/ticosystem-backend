/*
  Warnings:

  - Added the required column `userId` to the `office_service` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `warranty_service` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "office_service" ADD COLUMN     "userId" UUID NOT NULL;

-- AlterTable
ALTER TABLE "warranty_service" ADD COLUMN     "userId" UUID NOT NULL;

-- AddForeignKey
ALTER TABLE "office_service" ADD CONSTRAINT "office_service_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "warranty_service" ADD CONSTRAINT "warranty_service_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
