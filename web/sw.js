// Service worker for caching app resources
const CACHE_NAME = 'lakbay-pinas-v1';
const urlsToCache = [
  '/',
  'main.dart.js',
  'styles.css',
  'icons/Icon-192.png',
  'icons/Icon-512.png'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
  );
});

self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => response || fetch(event.request))
  );
});
