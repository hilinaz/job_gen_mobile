// This file provides stub implementations for web-specific functionality
// when running on mobile platforms

// Stub classes for html functionality
class Blob {
  Blob(List<dynamic> data) {}
}

class Url {
  static String createObjectUrl(dynamic blob) => '';
  static String createObjectUrlFromBlob(dynamic blob) => '';
  static void revokeObjectUrl(String url) {}
}

class AnchorElement {
  AnchorElement({String? href});
  
  void setAttribute(String name, String value) {}
  void click() {}
  void remove() {}
  
  String href = '';
  dynamic style = _StyleStub();
}

class _StyleStub {
  String display = '';
  String width = '';
  String height = '';
}

class IFrameElement {
  String src = '';
  dynamic style = _StyleStub();
}

class Document {
  dynamic body = _BodyStub();
}

class _BodyStub {
  List<dynamic> children = [];
  
  void add(dynamic element) {}
}

// Stub for document global
final Document document = Document();

// Stub for window global
final _WindowStub window = _WindowStub();

class _WindowStub {
  void open(String url, String target) {}
}

// Stub for platformViewRegistry
class PlatformViewRegistry {
  void registerViewFactory(String viewTypeId, dynamic Function(int viewId) viewFactory) {}
}

final PlatformViewRegistry platformViewRegistry = PlatformViewRegistry();
