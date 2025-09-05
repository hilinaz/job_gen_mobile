// This is a basic service worker that caches the Flutter application
// for offline use and improves performance

const CACHE_NAME = 'jobgen-mobile-cache-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/main.dart.js',
  '/flutter.js',
  '/manifest.json',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
  '/icons/Icon-maskable-192.png',
  '/icons/Icon-maskable-512.png',
  '/assets/AssetManifest.json',
  '/assets/FontManifest.json',
  '/assets/NOTICES',
  '/assets/packages/cupertino_icons/assets/CupertinoIcons.ttf',
  '/assets/fonts/MaterialIcons-Regular.otf',
];

// Install event - cache all static assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        return cache.addAll(urlsToCache);
      })
  );
});

// Fetch event - serve from cache, falling back to network
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request)
      .then((response) => response || fetch(event.request))
  );
});

// Activate event - clean up old caches
self.addEventListener('activate', (event) => {
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheWhitelist.indexOf(cacheName) === -1) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});
