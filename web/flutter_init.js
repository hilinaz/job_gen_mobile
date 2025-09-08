// Flutter web initialization configuration

// This function initializes the Flutter web app with the specified configuration
function initializeFlutterApp() {
  // Wait for the DOM to be fully loaded
  window.addEventListener('DOMContentLoaded', function() {
    // Configuration for Flutter web
    const config = {
      // Force HTML renderer
      renderer: 'html',
      
      // Disable CanvasKit
      canvasKitBaseUrl: null,
      canvasKitVariant: null,
      
      // Enable better text rendering
      useColorEmoji: true,
      
      // Set the application root
      appRoot: '#app',
      
      // Enable debug mode in development
      debug: window.location.hostname === 'localhost' || 
             window.location.hostname === '127.0.0.1',
      
      // Configure service worker
      serviceWorker: {
        serviceWorkerVersion: 'v1',
        serviceWorkerUrl: 'flutter_service_worker.js',
        timeoutMillis: 4000
      },
      
      // Handle errors
      onError: function(error) {
        console.error('Flutter error:', error);
        return true; // Prevent default error handling
      },
      
      // Handle first frame
      onFirstFrame: function() {
        console.log('Flutter first frame rendered');
        // Hide loading indicator if it exists
        const loading = document.getElementById('loading');
        if (loading) {
          loading.style.display = 'none';
        }
      }
    };

    // Initialize Flutter web
    _flutter.loader.loadEntrypoint({
      config: config,
      onEntrypointLoaded: async function(engineInitializer) {
        try {
          const appRunner = await engineInitializer.initializeEngine(config);
          await appRunner.runApp();
        } catch (error) {
          console.error('Failed to start Flutter app:', error);
          
          // Show error message to user
          const appRoot = document.querySelector(config.appRoot) || document.body;
          appRoot.innerHTML = `
            <div style="text-align: center; padding: 2rem; font-family: Arial, sans-serif;">
              <h2>Application Error</h2>
              <p>Failed to load the application. Please try refreshing the page.</p>
              <button onclick="window.location.reload()" 
                      style="padding: 0.5rem 1rem; margin-top: 1rem; cursor: pointer;">
                Refresh Page
              </button>
              <p><small>Error: ${error.message}</small></p>
            </div>
          `;
        }
      }
    });
  });
}

// Start the initialization
initializeFlutterApp();
