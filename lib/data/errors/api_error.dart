import 'package:commercial_app/generated/l10n.dart';

class ApiError implements Exception {
  final String message;
  final int statusCode;

  ApiError(this.message, this.statusCode);

  static ApiError fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return ApiError(
          S.current.badRequestError,
          400,
        );
      case 401:
        return ApiError(
          S.current.unauthorizedError,
          401,
        );
      case 402:
        return ApiError(
          S.current.paymentRequiredError,
          402,
        );
      case 403:
        return ApiError(
          S.current.forbiddenError,
          403,
        );
      case 404:
        return ApiError(
          S.current.notFoundError,
          404,
        );
      case 500:
        return ApiError(
          S.current.internalServerError,
          500,
        );
      case 503:
        return ApiError(
          S.current.serviceUnavailableError,
          503,
        );
      default:
        return ApiError(
          S.current.unknownErrorOccurred,
          statusCode,
        );
    }
  }
}
