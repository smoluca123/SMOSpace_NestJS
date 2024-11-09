import { applyDecorators, UseGuards, UseInterceptors } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiBody,
  ApiConsumes,
  ApiHeader,
  ApiOperation,
  ApiParam,
} from '@nestjs/swagger';
import { Roles } from 'src/decorators/roles.decorator';
import { JwtTokenVerifyGuard } from 'src/guards/jwt-token-verify.guard';
import { RolesLevel } from 'src/interfaces/interfaces.global';
import { UserAvatarUpdateDto } from 'src/resources/user/dto/user.dto';

export const getInfomationDecorator = () =>
  applyDecorators(
    UseGuards(JwtTokenVerifyGuard),
    ApiOperation({
      summary: 'Get user infomation API',
      description: 'Get user infomation by accessToken API',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
  );

export const getUserInfomationDecorator = () =>
  applyDecorators(
    Roles([RolesLevel.MANAGER]),
    ApiOperation({
      summary: 'Get user infomation API',
      description: 'Get user infomation by id API',
    }),
    ApiParam({
      name: 'userId',
      description: 'Param userId accepts sending to username',
    }),
  );

export const banUserDecorator = () =>
  applyDecorators(Roles([RolesLevel.ADMIN]));

export const updateInfomationDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update infomation API',
      description: 'Update infomation by accessToken API',
    }),
    ApiHeader({
      name: 'accessToken',
      required: true,
    }),
    UseGuards(JwtTokenVerifyGuard),
  );

export const updateUserInfomationDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'Update user infomation API',
      description: 'Update user infomation by id API',
    }),
  );

export const updateUserAvatarDecorator = () =>
  applyDecorators(
    ApiOperation({
      summary: 'User Update Avatar API',
      description: 'Update user avatar',
    }),
    ApiConsumes('multipart/form-data'),
    ApiParam({ name: 'userId', description: 'User ID' }),
    ApiBody({ type: UserAvatarUpdateDto }),
    UseInterceptors(
      FileInterceptor('file', {
        // storage: multer.memoryStorage(),
        limits: {
          fileSize: 1024 * 1024 * 50, //50MB
        },
        fileFilter(req, file, cb) {
          // /^.*\.(jpg|jpeg|png|gif|bmp|webp)$/i
          if (!file.mimetype.match('image/*')) {
            console.log('Cancel upload, file not support');
            // Block image upload in public/img folder
            cb(null, false);
          } else {
            cb(null, true);
          }
        },
      }),
    ),
  );
