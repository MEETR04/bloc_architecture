sealed class AppResult<T> {
  const AppResult();
}

final class Success<T> extends AppResult<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends AppResult<T> {
  const Failure(this.message);
  final String message;
}
