import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'

import react from '@vitejs/plugin-react'
import { defineConfig, type Plugin } from 'vite'

const BASE = '/AbilityEditor/app/'

function serveSchemaInDev(): Plugin {
  const schemaPath = resolve(import.meta.dirname, '..', 'docs', 'schema.json')

  const servedPaths = new Set([
    new URL('../schema.json', `http://localhost${BASE}`).pathname,
    '/schema.json',
  ])

  return {
    name: 'ae-serve-schema-dev',
    apply: 'serve',
    configureServer(server) {
      server.middlewares.use((req, res, next) => {
        if (!req.url || !servedPaths.has(new URL(req.url, 'http://localhost').pathname)) {
          return next()
        }
        try {
          res.setHeader('Content-Type', 'application/json')
          res.setHeader('Cache-Control', 'no-store')
          res.end(readFileSync(schemaPath))
        } catch (error) {
          res.statusCode = 404
          res.end(
            JSON.stringify({
              error: `Could not read ${schemaPath}. Run .scripts/generate-docs.ps1 first.`,
              detail: String(error),
            }),
          )
        }
      })
    },
  }
}

export default defineConfig({
  base: BASE,
  plugins: [react(), serveSchemaInDev()],
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    sourcemap: true,
  },
  server: {
    watch: { usePolling: true, interval: 300 },
  },
})
