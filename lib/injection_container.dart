import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/data/datasources/remote/remarks_remote_datasource.dart';
import 'package:commercial_app/data/repositories/data_repository_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:commercial_app/domain/cubit/cubit_export.dart';
import 'package:commercial_app/services/service_export.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerLazySingleton<ButtonCubit>(
    () => ButtonCubit(
      sl(),
      sl(),
    ),
  );
  sl.registerLazySingleton<ClearCubit>(
    () => ClearCubit(
      clearAllDataUsecase: sl(),
    ),
  );
  sl.registerLazySingleton<ValidationCubit>(
    () => ValidationCubit(),
  );
  sl.registerLazySingleton<DataCubit>(
    () => DataCubit(
      saveTextUsecase: sl(),
    ),
  );
  sl.registerLazySingleton<RoomCubit>(
    () => RoomCubit(
      saveRoomsUsecase: sl(),
      loadRoomsUsecase: sl(),
    ),
  );
  sl.registerLazySingleton<RemarksCubit>(
    () => RemarksCubit(
      saveDataListUsecase: sl(),
      loadDataListUsecase: sl(),
      removeImageUsecase: sl(),
      deleteRemarkUsecase: sl(),
    ),
  );
  sl.registerLazySingleton<InternetCubit>(
    () => InternetCubit(connectivity: sl()),
  );

  // Use Cases
  sl.registerLazySingleton<SaveSelectionUsecase>(
    () => SaveSelectionUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<GetSelectionUsecase>(
    () => GetSelectionUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<ClearAllDataUsecase>(
    () => ClearAllDataUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<ValidationUsecase>(
    () => ValidationUsecase(),
  );
  sl.registerLazySingleton<SaveTextUsecase>(
    () => SaveTextUsecase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton<SaveRoomsUsecase>(
    () => SaveRoomsUsecase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton<LoadRoomsUsecase>(
    () => LoadRoomsUsecase(
      repository: sl(),
    ),
  );
  sl.registerLazySingleton<SaveDataListUsecase>(
    () => SaveDataListUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<LoadDataListUsecase>(
    () => LoadDataListUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<RemoveImageUsecase>(
    () => RemoveImageUsecase(
      sl(),
    ),
  );
  sl.registerLazySingleton<CheckFirstLaunchUsecase>(
    () => CheckFirstLaunchUsecase(
      clearCubit: sl(),
    ),
  );
  sl.registerLazySingleton<DeleteRemarkUsecase>(
    () => DeleteRemarkUsecase(
      sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<OptionRepository>(
    () => OptionRepositoryImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<ClearRepository>(
    () => ClearRepositoryImpl(
      localDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<DataRepository>(
    () => DataRepositoryImpl(
      dataLocalDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<RemarksRepository>(
    () => RemarksRepositoryImpl(
      remarksLocalDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(
      roomLocalDatasource: sl(),
    ),
  );

  // Datasources
  sl.registerLazySingleton<OptionsLocalDatasource>(
    () => OptionsLocalDatasourceImpl(
      sl(),
    ),
  );
  sl.registerLazySingleton<ClearLocalDatasource>(
    () => ClearLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<DataLocalDatasource>(
    () => DataLocalDatasourceImpl(
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<RoomLocalDatasource>(
    () => RoomLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<RemarksLocalDatasource>(
    () => RemarksLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<RemarksRemoteDatasource>(
    () => RemarksRemoteDatasourceImpl(),
  );

  // External
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<Connectivity>(
    () => Connectivity(),
  );
  sl.registerLazySingleton<ImagePickerService>(
    () => getImagePickerService(),
  );
  sl.registerLazySingleton<DatePickerService>(
    () => getDatePickerService(),
  );
  sl.registerLazySingleton<DocumentService>(
    () => getDocumentService(),
  );
}
