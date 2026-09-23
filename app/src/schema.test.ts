import { readFileSync } from 'node:fs'
import { resolve } from 'node:path'

import { describe, expect, it } from 'vitest'

import { schemaUrlFrom } from './schema'

describe('schemaUrlFrom', () => {
  it('resolves one level above the app, in production', () => {
    expect(schemaUrlFrom('https://boundir.github.io/AbilityEditor/app/')).toBe(
      'https://boundir.github.io/AbilityEditor/schema.json',
    )
  })

  it('resolves the same way against the dev server', () => {
    expect(schemaUrlFrom('http://localhost:5173/AbilityEditor/app/')).toBe(
      'http://localhost:5173/AbilityEditor/schema.json',
    )
  })

  it('matches the path vite.config.ts serves in dev', () => {
    const config = readFileSync(resolve(import.meta.dirname, '..', 'vite.config.ts'), 'utf-8')
    const base = /const BASE = '([^']+)'/.exec(config)?.[1]
    expect(base).toBeDefined()

    const appUrl = `http://localhost${base}`
    expect(new URL(schemaUrlFrom(appUrl)).pathname).toBe(
      new URL('../schema.json', appUrl).pathname,
    )
    expect(new URL(schemaUrlFrom(appUrl)).pathname).toBe('/AbilityEditor/schema.json')
  })
})
