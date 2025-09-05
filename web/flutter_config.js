// Flutter web configuration
// This file configures the Flutter web renderer and other settings

// Force HTML renderer and disable CanvasKit
window.flutterConfiguration = window.flutterConfiguration || {};
window.flutterConfiguration.renderer = 'html';
window.flutterConfiguration.canvasKitBaseUrl = null;
window.flutterConfiguration.canvasKitVariant = null;
window.flutterConfiguration.useColorEmoji = true;

// Override the default renderer if not already set
if (window.flutterWebRenderer === undefined) {
  window.flutterWebRenderer = 'html';
}

// Intercept Flutter loader to ensure HTML renderer is used
if (window._flutter && window._flutter.loader) {
  const originalLoadEntrypoint = window._flutter.loader.loadEntrypoint;
  
  window._flutter.loader.loadEntrypoint = function(options) {
    // Force HTML renderer in the config
    if (options && options.config) {
      options.config.renderer = 'html';
      options.config.canvasKitBaseUrl = null;
      options.config.canvasKitVariant = null;
    }
    
    return originalLoadEntrypoint.call(this, options);
  };
}

// Handle Flutter web errors
window.addEventListener('flutter-error', function(event) {
  console.error('Flutter error:', event.detail);
  
  // Show error message to user
  const appRoot = document.querySelector('#app') || document.body;
  if (appRoot) {
    appRoot.innerHTML = `
      <div style="text-align: center; padding: 2rem; font-family: Arial, sans-serif;">
        <h2>Application Error</h2>
        <p>An error occurred while loading the application. Please try refreshing the page.</p>
        <button onclick="window.location.reload()" 
                style="padding: 0.5rem 1rem; margin-top: 1rem; cursor: pointer;">
          Refresh Page
        </button>
        <p><small>${event.detail || 'Unknown error'}</small></p>
      </div>
    `;
  }
});

// Hide loading indicator when Flutter is ready
window.addEventListener('flutter-first-frame', function() {
  const loading = document.getElementById('loading');
  if (loading) {
    loading.style.display = 'none';
  }
});
