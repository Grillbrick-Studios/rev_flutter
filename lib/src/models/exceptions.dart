import 'bible.dart';

class ReadFileError implements Exception {
  final String msg;
  final Exception parent;

  ReadFileError(this.parent) : msg = 'There was an error reading the file!';

  @override
  String toString() {
    return '$msg original error: ${parent.runtimeType}';
  }
}

class WriteFileError implements Exception {
  final String msg;
  final Exception parent;

  WriteFileError(this.parent) : msg = 'There was an error writing the file!';

  @override
  String toString() {
    return '$msg original error: ${parent.runtimeType}';
  }
}

class FetchFileError implements Exception {
  final String msg;
  final Exception parent;

  FetchFileError(this.parent) : msg = 'There was an error fetching the file!';

  @override
  String toString() {
    return '$msg original error: ${parent.runtimeType}';
  }
}

class IdbFactoryError implements Exception {
  final String msg;
  final Exception parent;

  IdbFactoryError(this.parent)
      : msg = 'There was an error loading the '
            'IdbFactory';

  @override
  String toString() {
    return '$msg original error: ${parent.runtimeType}';
  }
}

/// Exceptions to throw when parsing verses or VerseLike data
class BibleLikeException implements Exception {
  final String? msg;
  final BibleLike caller;

  const BibleLikeException(this.caller, [this.msg]);

  @override
  String toString() => msg ?? 'A bad path was sent to $caller';
}

class BadBiblePathException extends BibleLikeException {
  BadBiblePathException(BibleLike caller, [String? msg]) : super(caller, msg);

  @override
  String toString() => msg ?? 'A bad path was sent to $caller';
}

class BookNotFoundException extends BibleLikeException {
  BookNotFoundException(BibleLike caller, [String? msg]) : super(caller, msg);

  @override
  String toString() => msg ?? 'The book sent to $caller was not found';
}

class ChapterNotFoundException extends BibleLikeException {
  ChapterNotFoundException(BibleLike caller, [String? msg])
      : super(caller, msg);

  @override
  String toString() => msg ?? 'The chapter sent to $caller was not found';
}

class VerseNotFoundException extends BibleLikeException {
  VerseNotFoundException(BibleLike caller, [String? msg]) : super(caller, msg);

  @override
  String toString() => msg ?? 'The verse sent to $caller was not found';
}
