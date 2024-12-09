import { ApiProperty } from '@nestjs/swagger';
import { IResponseType } from 'src/interfaces/interfaces.global';
import { UserDataType } from 'src/libs/prisma-types';
import { ResponseWrapperDto } from 'src/libs/Responses.dto';
import { UserDataResponseDto } from 'src/resources/auth/dto/Responses.dto';

export class UserCreditsResponseDto {
  @ApiProperty()
  id: string;
  @ApiProperty()
  username: string;
  @ApiProperty()
  credits: number;
}

export class UserInfomationResponseDto
  extends ResponseWrapperDto
  implements IResponseType<UserDataType>
{
  @ApiProperty({
    type: UserDataResponseDto,
  })
  data: UserDataResponseDto;
}

export class BanUserResponseDto
  extends ResponseWrapperDto
  implements IResponseType<null>
{
  @ApiProperty({
    default: null,
  })
  data: null;
}

export class SendVerificationEmailResponseDto
  extends ResponseWrapperDto
  implements IResponseType<null>
{
  @ApiProperty({
    default: null,
  })
  data: null;
}

export class UpdateAddCreditsUserResponseDto
  extends ResponseWrapperDto
  implements
    IResponseType<{
      id: string;
      username: string;
      credits: number;
    }>
{
  @ApiProperty({
    type: UserCreditsResponseDto,
  })
  data: {
    id: string;
    username: string;
    credits: number;
  };
}
