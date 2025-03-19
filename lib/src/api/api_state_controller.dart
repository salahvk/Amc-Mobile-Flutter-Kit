import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef APIError = void Function(Object error, StackTrace? stackTrace);

abstract class APIStateController<TModel>
    extends StateNotifier<AsyncValue<TModel>> {
  APIStateController() : super(const AsyncLoading()) {
    if (shouldCallAtInit) {
      callAPI();
    }
  }

  dynamic onAPIData(TModel onData) => null;
  APIError? onAPIError;

  Future<TModel> apiFuture();
  bool get shouldCallAtInit => false;

  Future callAPI() async {
    state = const AsyncLoading();
    try {
      final TModel futureValue = await apiFuture();

      await onAPIData(futureValue);
      state = AsyncData(futureValue);
    } catch (e, st) {
      state = AsyncError(e, st);
      if (onAPIError != null) {
        onAPIError!.call(e, st);
      } else {
        // ErrorSheet.openGeneralErrorSheet(
        //   onRetry: apiFuture,
        //   isDismissible: RouteHelper.canPop(),
        // );
      }
      //Globals.reportError?.call(e, st);
    }
  }
}
