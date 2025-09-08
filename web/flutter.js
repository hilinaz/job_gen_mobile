// This is a simplified version of flutter.js that forces HTML renderer
// and handles errors more gracefully

// Configuration for the Flutter web app
window.flutterConfiguration = {
  // Force HTML renderer to avoid CanvasKit loading issues
  renderer: 'html',
  // Enable debug mode for better error messages
  debug: true,
};

// Error handling for Flutter web
window.addEventListener('error', function(event) {
  console.error('Flutter web error:', event.error || event.message, event);
  
  // If the error is related to CanvasKit, try to fallback to HTML renderer
  if ((event.message || '').includes('canvaskit.js')) {
    console.warn('CanvasKit load failed, forcing HTML renderer');
    window.flutterConfiguration.renderer = 'html';
    
    // Reload the page to apply the new renderer
    if (!window.location.search.includes('force-html')) {
      window.location.search = '?force-html=true';
    }
  }
});

// Listen for Flutter's initialization errors
window.addEventListener('flutterError', function(event) {
  console.error('Flutter error:', event.detail);
  
  // Show a user-friendly error message
  const errorContainer = document.createElement('div');
  errorContainer.style.cssText = `
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    background: #ffebee;
    color: #b71c1c;
    padding: 16px;
    font-family: Arial, sans-serif;
    z-index: 999999;
    text-align: center;
  `;
  
  errorContainer.innerHTML = `
    <h3>Application Error</h3>
    <p>${event.detail || 'An unexpected error occurred'}</p>
    <button onclick="window.location.reload()" style="
      background: #1976d2;
      color: white;
      border: none;
      padding: 8px 16px;
      border-radius: 4px;
      cursor: pointer;
      margin-top: 8px;
    ">
      Reload Application
    </button>
  `;
  
  document.body.prepend(errorContainer);
});
