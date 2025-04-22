class ApiResponse {
  int get totalDataCount => body["meta"]["total"];
  int get totalPageCount => body["pagination"]["total_pages"];
  List get data => body["data"] ?? [];
  // Just a way of saying there was no error with the request and response return
  bool get allGood => errors.isEmpty;
  bool hasError() => errors.isNotEmpty;
  bool hasData() => data.isNotEmpty;
  int code;
  String message;
  dynamic body;
  List errors;

  ApiResponse({
    required this.code,
    required this.message,
    required this.body,
    required this.errors,
  });

  factory ApiResponse.fromResponse(dynamic response) {
    int code = response.statusCode;
    dynamic body = response.data; // The response body could be a Map or other type
    List errors = [];
    String message = "";

    switch (code) {
      case 200:
        try {
          if (body is Map) {
            if (body.containsKey("message")) {
              message = body["message"]?.toString() ?? "";
            }
          } else if (body is String) {
            message = body;
          } else {
            message = body["message"]?.toString() ?? "";
          }
        } catch (error) {
          print("Message reading error ==> $error");
        }
        break;
      default:
        message = body is Map && body.containsKey("message")
            ? body["message"]?.toString() ?? "Unknown error"
            : "Whoops! Something went wrong, please contact support.";
        errors.add(message);
        break;
    }

    return ApiResponse(
      code: code,
      message: message,
      body: body,
      errors: errors,
    );
  }

}
