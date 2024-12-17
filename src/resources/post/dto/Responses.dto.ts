import { ApiProperty } from '@nestjs/swagger';
import { IPaginationResponseType } from 'src/interfaces/interfaces.global';
import { PostDataType } from 'src/libs/prisma-types';
import { ResponseWrapperDto } from 'src/libs/Responses.dto';
import { UserDataResponseDto } from 'src/resources/auth/dto/Responses.dto';

export class PostDataResponseDto implements PostDataType {
  @ApiProperty()
  id: string;
  @ApiProperty()
  content: string;
  @ApiProperty()
  isPrivate: boolean;
  @ApiProperty()
  createdAt: Date;
  @ApiProperty()
  updatedAt: Date;
  @ApiProperty()
  likeCount: number;

  @ApiProperty({
    type: UserDataResponseDto,
  })
  author: UserDataResponseDto;
}

export class GetPostsResponseDto
  extends ResponseWrapperDto
  implements IPaginationResponseType<PostDataType>
{
  @ApiProperty()
  data: {
    totalCount: number;
    totalPage: number;
    currentPage: number;
    pageSize: number;
    hasNextPage: boolean;
    hasPreviousPage: boolean;
    items: PostDataResponseDto[];
  };
}
