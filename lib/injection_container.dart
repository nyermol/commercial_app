import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/data/datasources/remote/remarks_remote_datasource.dart';
import 'package:commercial_app/data/repositories/data_repository_export.dart';
import 'package:commercial_app/domain/repositories/domain_repositories_export.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerLazySingleton<ButtonCubit>(
    () => ButtonCubit(<String, String>{}, sl(), sl()),
  );
  sl.registerLazySingleton<ClearCubit>(
    () => ClearCubit(clearAllDataUsecase: sl()),
  );
  sl.registerLazySingleton<ValidationCubit>(() => ValidationCubit());
  sl.registerLazySingleton<DataCubit>(
    () => DataCubit(
      saveTextUsecase: sl(),
    ),
  );
  sl.registerLazySingleton<RoomCubit>(
    () => RoomCubit(
      saveListUsecase: sl(),
      loadListUsecase: sl(),
      saveCheckedRoomsUsecase: sl(),
      loadCheckedRoomsUsecase: sl(),
      saveRoomControllerUsecase: sl(),
      loadRoomControllerUsecase: sl(),
    ),
  );
  sl.registerLazySingleton<ListCubit>(
    () => ListCubit(
      removeItemUsecase: sl(),
      restoreItemUsecase: sl(),
      saveDataListUsecase: sl(),
      loadDataListUsecase: sl(),
      removeImageUsecase: sl(),
    ),
  );
  sl.registerLazySingleton<InternetCubit>(
    () => InternetCubit(connectivity: sl()),
  );

  // Usecases
  sl.registerLazySingleton<SaveSelectionUsecase>(
    () => SaveSelectionUsecase(sl()),
  );
  sl.registerLazySingleton<GetSelectionUsecase>(
    () => GetSelectionUsecase(sl()),
  );
  sl.registerLazySingleton<ClearAllDataUsecase>(
    () => ClearAllDataUsecase(sl()),
  );
  sl.registerLazySingleton<ValidationUsecase>(() => ValidationUsecase());
  sl.registerLazySingleton<SaveTextUsecase>(
    () => SaveTextUsecase(repository: sl()),
  );
  sl.registerLazySingleton<SaveListUsecase>(
    () => SaveListUsecase(repository: sl()),
  );
  sl.registerLazySingleton<LoadListUsecase>(
    () => LoadListUsecase(repository: sl()),
  );
  sl.registerLazySingleton<SaveCheckedRoomsUsecase>(
    () => SaveCheckedRoomsUsecase(repository: sl()),
  );
  sl.registerLazySingleton<LoadCheckedRoomsUsecase>(
    () => LoadCheckedRoomsUsecase(repository: sl()),
  );
  sl.registerLazySingleton<SaveRoomControllerUsecase>(
    () => SaveRoomControllerUsecase(repository: sl()),
  );
  sl.registerLazySingleton<LoadRoomControllerUsecase>(
    () => LoadRoomControllerUsecase(repository: sl()),
  );
  sl.registerLazySingleton<RemoveItemUsecase>(() => RemoveItemUsecase(sl()));
  sl.registerLazySingleton<RestoreItemUsecase>(() => RestoreItemUsecase(sl()));
  sl.registerLazySingleton<SaveDataListUsecase>(
    () => SaveDataListUsecase(sl()),
  );
  sl.registerLazySingleton<LoadDataListUsecase>(
    () => LoadDataListUsecase(sl()),
  );
  sl.registerLazySingleton<RemoveImageUsecase>(() => RemoveImageUsecase(sl()));

  // Repositories
  sl.registerLazySingleton<OptionRepository>(() => OptionRepositoryImpl(sl()));
  sl.registerLazySingleton<ClearRepository>(
    () => ClearRepositoryImpl(localDatasource: sl()),
  );
  sl.registerLazySingleton<DataRepository>(
    () => DataRepositoryImpl(dataLocalDatasource: sl()),
  );
  sl.registerLazySingleton<ListRepository>(
    () => ListRepositoryImpl(
      listLocalDatasourse: sl(),
      remarksRemoteDatasource: sl(),
    ),
  );
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(roomLocalDatasource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<OptionsLocalDatasource>(
    () => OptionsLocalDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<ClearLocalDatasource>(
    () => ClearLocalDatasourceImpl(databaseServices: sl()),
  );
  sl.registerLazySingleton<DataLocalDatasource>(
    () => DataLocalDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<RoomLocalDatasource>(
    () => RoomLocalDatasourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ListLocalDatasourse>(
    () => ListLocalDatasourseImpl(databaseServices: sl()),
  );
  sl.registerLazySingleton<RemarksRemoteDatasource>(
    () => RemarksRemoteDatasourceImpl(),
  );

  // External
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  final DatabaseServices databaseServices = DatabaseServices.instance;
  sl.registerLazySingleton(() => databaseServices);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());
}
