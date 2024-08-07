import 'package:commercial_app/data/datasources/local/local_database_export.dart';
import 'package:commercial_app/data/datasources/remote/remarks_remote_datasource.dart';
import 'package:commercial_app/data/repositories/data_repository_export.dart';
import 'package:commercial_app/domain/repositories/domain_reposirories_export.dart';
import 'package:commercial_app/domain/usecases/usecases_export.dart';
import 'package:commercial_app/presentation/cubit/cubit_export.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerLazySingleton(() => ButtonCubit(<String, String>{}, sl(), sl()));
  sl.registerLazySingleton(() => ClearCubit(clearAllDataUsecase: sl()));
  sl.registerLazySingleton(() => ValidationCubit());
  sl.registerLazySingleton(() => DataCubit(
      saveTextUsecase: sl(),
      saveListUsecase: sl(),
      loadListUsecase: sl(),
      saveCheckedRoomsUsecase: sl(),
      loadCheckedRoomsUsecase: sl(),
      saveRommControllerUsecase: sl(),
      loadRommControllerUsecase: sl(),),);
  sl.registerLazySingleton(() => ListCubit(
      removeItemUsecase: sl(),
      restoreItemUsecase: sl(),
      saveDataListUsecase: sl(),
      loadDataListUsecase: sl(),
      removeImageUsecase: sl(),),);

  // Usecases
  sl.registerLazySingleton(() => SaveSelectionUsecase(sl()));
  sl.registerLazySingleton(() => GetSelectionUsecase(sl()));
  sl.registerLazySingleton(() => ClearAllDataUsecase(sl()));
  sl.registerLazySingleton(() => ValidationUsecase());
  sl.registerLazySingleton(() => SaveTextUsecase(repository: sl()));
  sl.registerLazySingleton(() => SaveListUsecase(repository: sl()));
  sl.registerLazySingleton(() => LoadListUsecase(repository: sl()));
  sl.registerLazySingleton(() => SaveCheckedRoomsUsecase(repository: sl()));
  sl.registerLazySingleton(() => LoadCheckedRoomsUsecase(repository: sl()));
  sl.registerLazySingleton(() => SaveRommControllerUsecase(repository: sl()));
  sl.registerLazySingleton(() => LoadRommControllerUsecase(repository: sl()));
  sl.registerLazySingleton(() => RemoveItemUsecase(sl()));
  sl.registerLazySingleton(() => RestoreItemUsecase(sl()));
  sl.registerLazySingleton(() => SaveDataListUsecase(sl()));
  sl.registerLazySingleton(() => LoadDataListUsecase(sl()));
  sl.registerLazySingleton(() => RemoveImageUsecase(sl()));

  // Repositories
  sl.registerLazySingleton<OptionRepository>(() => OptionRepositoryImpl(sl()));
  sl.registerLazySingleton<ClearRepository>(
      () => ClearRepositoryImpl(localDatasource: sl()),);
  sl.registerLazySingleton<DataRepository>(
      () => DataRepositoryImpl(dataLocalDatasource: sl()),);
  sl.registerLazySingleton<ListRepository>(() => ListRepositoryImpl(
      listLocalDatasourse: sl(), remarksRemoteDatasource: sl(),),);

  // Data Sources
  sl.registerLazySingleton<OptionsLocalDatasource>(
      () => OptionsLocalDatasourceImpl(sl()),);
  sl.registerLazySingleton<ClearLocalDatasource>(
      () => ClearLocalDatasourceImpl(databaseServices: sl()),);
  sl.registerLazySingleton<DataLocalDatasource>(
      () => DataLocalDatasourceImpl(sharedPreferences: sl()),);
  sl.registerLazySingleton<ListLocalDatasourse>(
      () => ListLocalDatasourseImpl(databaseServices: sl()),);
  sl.registerLazySingleton<RemarksRemoteDatasource>(
      () => RemarksRemoteDatasourceImpl(),);

  // External
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  final DatabaseServices databaseServices = DatabaseServices.instance;
  sl.registerLazySingleton(() => databaseServices);
}
