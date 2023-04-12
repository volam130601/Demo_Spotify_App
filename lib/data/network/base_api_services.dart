abstract class BaseApiServices {
  Future<dynamic> getGetApiResponse(Uri url);

  Future<dynamic> getPostApiResponse(Uri url, dynamic data);
}
