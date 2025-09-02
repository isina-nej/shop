const CACHE_NAME = 'sina-shop-cache-v1';
const CACHE_EXPIRY = 24 * 60 * 60 * 1000; // 24 hours in milliseconds

// Install event: Cache static assets
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll([
        '/',
        '/index.html',
        '/main.dart.js',
        '/flutter_service_worker.js',
        '/manifest.json',
        '/favicon.png',
        '/icons/Icon-192.png',
        '/icons/Icon-512.png',
        // Add other static assets as needed
      ]);
    })
  );
});

// Fetch event: Use different strategies based on request type
self.addEventListener('fetch', event => {
  if (isApiRequest(event.request.url)) {
    // For API requests, use Network First strategy
    event.respondWith(networkFirstStrategy(event.request));
  } else {
    // For pages and static assets, use Cache First strategy
    event.respondWith(cacheFirstStrategy(event.request));
  }
});

// Cache First strategy for pages and static assets
function cacheFirstStrategy(request) {
  return caches.match(request).then(response => {
    if (response) {
      return response;
    }
    return fetchAndCache(request);
  });
}

// Network First strategy for API requests
function networkFirstStrategy(request) {
  return fetch(request).then(response => {
    if (!response || response.status !== 200 || response.type !== 'basic') {
      // If network fails, try cache
      return caches.match(request).then(cachedResponse => {
        return cachedResponse || response;
      });
    }
    // Network success, cache and return
    const responseClone = response.clone();
    caches.open(CACHE_NAME).then(cache => {
      cache.put(request, responseClone);
    });
    return response;
  }).catch(() => {
    // Network failed, serve from cache
    return caches.match(request);
  });
}

// Helper function to determine if request is for API
function isApiRequest(url) {
  return url.includes('/api/') || url.includes('api.');
}

// Helper function to fetch and cache
function fetchAndCache(request) {
  return fetch(request).then(response => {
    if (!response || response.status !== 200 || response.type !== 'basic') {
      return response;
    }
    const responseClone = response.clone();
    caches.open(CACHE_NAME).then(cache => {
      cache.put(request, responseClone);
    });
    return response;
  });
}

// Activate event: Clean up old caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});
