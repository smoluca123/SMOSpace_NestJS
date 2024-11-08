import { Prisma } from '@prisma/client';

export const userTypeDataSelect = {
  id: true,
  typeName: true,
} satisfies Prisma.UserTypeSelect;

export const userDataSelect = {
  id: true,
  username: true,
  fullName: true,
  displayName: true,
  email: true,
  age: true,
  phoneNumber: true,
  isActive: true,
  isVerified: true,
  isBanned: true,
  createdAt: true,
  updatedAt: true,
  credits: true,
  userType: {
    select: userTypeDataSelect,
  },
  avatar: true,
} satisfies Prisma.UserSelect;

export type UserDataType = Prisma.UserGetPayload<{
  select: typeof userDataSelect;
}>;

export const userSessionDataSelect = {
  id: true,
  expiresAt: true,
} satisfies Prisma.UserSessionSelect;
