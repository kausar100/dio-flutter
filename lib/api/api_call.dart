import 'package:dio/dio.dart';
import 'package:dio_with_pythonanywhere/model/book.dart';

class DioClient {
  static final _baseUrl = "http://kausar100.pythonanywhere.com";
  final _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    // connectTimeout: const Duration(seconds: 5),
    // receiveTimeout: const Duration(seconds: 3),
  ));

  Future<Data?> getBook({required String id}) async {
    Data? book;

    try {
      // Perform GET request to the endpoint "/book/<id>"
      Response bookData = await _dio.get(_baseUrl + '/book/$id');

      print('book Info: ${bookData.data}');

      book = Data.fromJson(bookData.data);
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        // print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }

    return book;
  }

  Future<Book?> getBooks() async {
    Book? book;

    try {
      // Perform GET request to the endpoint "/book/<id>"
      Response bookData = await _dio.get(_baseUrl + '/books');

      book = Book.fromJson(bookData.data);
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        // print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }

    return book;
  }

  Future<String> createBook({required Data book}) async {
    String message = "";
    try {
      Response response = await _dio.post(
        _baseUrl + '/book',
        data: book.toJson(),
      );

      message = response.data['message'];

      print('book created: ${response.data}');
    } catch (e) {
      print('Error creating book: $e');
      message = e.toString();
    }

    return message;
  }

  Future<String> updateBook({required Data book}) async {
    String message = "";
    try {
      Response response = await _dio.put(
        _baseUrl + '/book',
        data: book.toJson(),
      );

      message = response.data['message'];

      print('book update message: ${response.data}');
    } catch (e) {
      print('Error updating book: $e');
      message = e.toString();
    }

    return message;
  }

  Future<String> deleteBook({required String title}) async {
    String message = "";
    try {
      Response response = await _dio
          .delete(_baseUrl + '/book', queryParameters: {'title': title});

      message = response.data['message'];

      print('book delete message: ${response.data}');
    } catch (e) {
      print('Error deleting book: $e');
      message = e.toString();
    }

    return message;
  }
}
