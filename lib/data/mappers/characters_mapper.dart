import 'package:pmu_course/data/dtos/characters_dto.dart';
import 'package:pmu_course/domain/models/cardEmployee.dart';
import 'package:pmu_course/domain/models/home.dart';

extension CharacterDataDtoToModel on CharacterDataDto {
  CardEmployeeData toDomain() => CardEmployeeData(
    text: attributes?.name ?? 'UNKNOWN',
    imageUrl: attributes?.image,
    descriptionText: '${attributes?.position} \n Зарплата: ${attributes?.salary}',
  );
}

extension CharactersDataDtoToModel on CharactersDto {
  HomeData toDomain() =>
      HomeData(data: data?.map((e) => e.toDomain()).toList(), nextPage: meta?.pagination?.next);
}
