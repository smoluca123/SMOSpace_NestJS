// import { ApiProperty } from '@nestjs/swagger';
// import { UserType } from '@prisma/client';
// import { Decimal } from '@prisma/client/runtime/library';
// import { Type } from 'class-transformer';
// import { IResponseType } from 'src/interfaces/interfaces.global';
// import { UserDataType, UserSessionDataType } from 'src/libs/prisma-types';
// import { ResponseWrapperDto } from 'src/libs/Responses.dto';

// export class UserTypeResponseDto implements UserType {
//   @ApiProperty()
//   id: string;

//   @ApiProperty()
//   typeName: string;
// }

// export class UserDataResponseDto implements UserDataType {
//   @ApiProperty()
//   id: string;

//   @ApiProperty()
//   username: string;

//   @ApiProperty()
//   fullName: string;

//   @ApiProperty()
//   displayName: string;

//   @ApiProperty()
//   email: string;

//   @ApiProperty()
//   age: number;

//   @ApiProperty()
//   phoneNumber: string;

//   @ApiProperty()
//   isActive: boolean;

//   @ApiProperty()
//   isVerified: boolean;

//   @ApiProperty()
//   isBanned: boolean;

//   @ApiProperty()
//   credits: Decimal;

//   @ApiProperty()
//   avatar: string;

//   @ApiProperty()
//   @Type(() => UserTypeResponseDto)
//   userType: UserTypeResponseDto;

//   @ApiProperty()
//   createdAt: Date;

//   @ApiProperty()
//   updatedAt: Date;
// }

// export class UserDataWithAccessTokenResponseDto extends UserDataResponseDto {
//   @ApiProperty()
//   accessToken: string;
// }

// export class AuthUserSessionResponseDto implements UserSessionDataType {
//   @ApiProperty()
//   id: string;

//   @ApiProperty()
//   token: string;

//   @ApiProperty()
//   expiresAt: Date;

//   @ApiProperty({ type: UserDataWithAccessTokenResponseDto })
//   user: UserDataWithAccessTokenResponseDto;
// }

// export class AuthUserLoginResponseDto
//   extends ResponseWrapperDto
//   implements IResponseType
// {
//   @ApiProperty()
//   message: string;

//   @ApiProperty({ type: UserDataWithAccessTokenResponseDto })
//   @Type(() => UserDataWithAccessTokenResponseDto)
//   data: UserDataWithAccessTokenResponseDto;

//   @ApiProperty()
//   statusCode: number;

//   @ApiProperty()
//   date: Date;
// }

// export class AuthUserRegisterResponseDto
//   extends ResponseWrapperDto
//   implements IResponseType
// {
//   @ApiProperty({ type: UserDataWithAccessTokenResponseDto })
//   @Type(() => UserDataWithAccessTokenResponseDto)
//   data: UserDataWithAccessTokenResponseDto;
// }

// export class AuthRenewSessionResponseDto
//   extends ResponseWrapperDto
//   implements IResponseType
// {
//   @ApiProperty({ type: AuthUserSessionResponseDto })
//   data: AuthUserSessionResponseDto;
// }

// export class AuthUserLogoutResponseDto
//   extends ResponseWrapperDto
//   implements IResponseType
// {
//   @ApiProperty({ default: null })
//   data: null;
// }

// export class AuthValidateSessionResponseDto
//   extends ResponseWrapperDto
//   implements IResponseType
// {
//   @ApiProperty({ type: AuthUserSessionResponseDto })
//   data: AuthUserSessionResponseDto;
// }
