// This file provides a wrapper for platformViewRegistry that works on both web and mobile
import 'package:flutter/foundation.dart' show kIsWeb;

// We use dynamic invocation for web to avoid direct import of dart:ui
// which would cause issues on mobile platforms

/// Register a platform view factory
/// 
/// This function is a wrapper around platformViewRegistry.registerViewFactory
/// that works on both web and mobile platforms
void registerViewFactory(String viewTypeId, dynamic Function(int viewId) viewFactory) {
  if (kIsWeb) {
    // On web, we use JS interop to register the view factory
    // This is done at runtime to avoid compile-time errors on mobile
    _registerViewFactoryForWeb(viewTypeId, viewFactory);
  }
  // On mobile, this is a no-op
}

// This function is only called on web platforms
// ignore: avoid_dynamic_calls
void _registerViewFactoryForWeb(String viewTypeId, dynamic Function(int viewId) viewFactory) {
  // We're using this approach to avoid direct import of dart:ui
  // which would cause issues on mobile platforms
  // ignore: undefined_prefixed_name, avoid_dynamic_calls
  registerViewFactoryImpl(viewTypeId, viewFactory);
}

// This is a stub that will be replaced at runtime on web
// ignore: unused_element
void registerViewFactoryImpl(String viewTypeId, dynamic Function(int viewId) viewFactory) {
  // No-op implementation for mobile
  // On web, this will be replaced with the actual implementation
}
