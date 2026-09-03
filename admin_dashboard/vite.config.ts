import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'
import { VitePWA } from 'vite-plugin-pwa'

// https://vite.dev/config/
export default defineConfig({
  server: {
    proxy: {
      // In dev, il backend gira su :8080: evita CORS e mima il deploy di
      // produzione (stesso reverse proxy davanti a dashboard + API).
      '/api': 'http://localhost:8080',
    },
  },
  plugins: [
    react(),
    VitePWA({
      registerType: 'autoUpdate',
      manifest: {
        name: 'Cosplay Inventory Admin',
        short_name: 'CI Admin',
        description: 'Dashboard di amministrazione Cosplay Inventory',
        start_url: '/',
        scope: '/',
        display: 'standalone',
        orientation: 'any',
        background_color: '#1a0f2e',
        theme_color: '#1a0f2e',
        icons: [
          { src: '/pwa/icon-192.png', sizes: '192x192', type: 'image/png', purpose: 'any' },
          { src: '/pwa/icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'any' },
          { src: '/pwa/maskable-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
        ],
      },
      workbox: {
        // Precache SOLO l'app shell (build output di Vite). Le chiamate a /api/**
        // non sono nel glob e restano fuori dal service worker: niente dati
        // amministrativi/autenticati messi in cache offline (stesso principio
        // del service worker admin di Unwaste).
        globPatterns: ['**/*.{js,css,html,svg,png,ico}'],
        navigateFallbackDenylist: [/^\/api/],
      },
    }),
  ],
})
