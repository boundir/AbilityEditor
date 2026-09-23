import { useCallback, useEffect, useMemo, useState } from 'react'

import { emit } from './emit'
import { buildIndices, loadSchema, type Indices } from './schema'
import { emptyDoc, newNode, setAtPath, type Doc, type Path, type Value } from './state'
import { validate, type Issue } from './validate'

import { ImportPanel } from './components/ImportPanel'
import { NodeEditor } from './components/NodeEditor'

type LoadState =
  | { status: 'loading' }
  | { status: 'error'; message: string }
  | { status: 'ready'; indices: Indices; stale: boolean }

export function App() {
  const [load, setLoad] = useState<LoadState>({ status: 'loading' })
  const [doc, setDoc] = useState<Doc | null>(null)
  const [selected, setSelected] = useState(0)
  const [filter, setFilter] = useState('')
  const [copied, setCopied] = useState(false)
  const [importing, setImporting] = useState(false)

  useEffect(() => {
    let cancelled = false
    loadSchema()
      .then(({ schema, fromCache }) => {
        if (cancelled) return
        setLoad({ status: 'ready', indices: buildIndices(schema), stale: fromCache })
        setDoc(emptyDoc(schema.sourceHash))
      })
      .catch((error: unknown) => {
        if (cancelled) return
        setLoad({ status: 'error', message: error instanceof Error ? error.message : String(error) })
      })
    return () => {
      cancelled = true
    }
  }, [])

  const update = useCallback((path: Path, value: Value | undefined) => {
    setDoc((current) => (current ? setAtPath(current, path, value) : current))
  }, [])

  const indices = load.status === 'ready' ? load.indices : null

  const output = useMemo(
    () => (doc && indices ? emit(doc, indices) : ''),
    [doc, indices],
  )
  const issues = useMemo(
    () => (doc && indices ? validate(doc, indices) : []),
    [doc, indices],
  )

  if (load.status === 'loading') return <main className="state">Loading schema…</main>

  if (load.status === 'error') {
    return (
      <main className="state state--error">
        <h1>Could not load the schema</h1>
        <p>{load.message}</p>
        <p>
          This tool is driven by <code>schema.json</code>, published alongside the documentation.
          If you are running locally, generate it first with{' '}
          <code>.scripts/generate-docs.ps1</code>.
        </p>
      </main>
    )
  }

  if (!doc || !indices) return null

  const entry = doc.entries[selected]
  const errors = issues.filter((i) => i.severity === 'error')
  const warnings = issues.filter((i) => i.severity === 'warning')

  const copy = async () => {
    try {
      await navigator.clipboard.writeText(output)
      setCopied(true)
      setTimeout(() => setCopied(false), 1500)
    } catch {
      setCopied(false)
    }
  }

  return (
    <div className="layout">
      <header className="topbar">
        <h1>Ability Editor · config builder</h1>
        <input
          className="search"
          type="search"
          placeholder="Filter fields…"
          value={filter}
          onChange={(event) => setFilter(event.target.value)}
        />
        <button type="button" onClick={() => setImporting(true)}>
          Check existing config
        </button>
        <a href="../" className="topbar__link">
          Documentation
        </a>
      </header>

      {load.stale && (
        <p className="banner banner--warn">
          Showing a cached schema — the live one could not be fetched, so this may be out of date.
        </p>
      )}

      <aside className="entries">
        <div className="entries__head">
          <h2>Entries</h2>
          <button
            type="button"
            onClick={() => {
              setDoc({ ...doc, entries: [...doc.entries, newNode({ Ability: '' })] })
              setSelected(doc.entries.length)
            }}
          >
            + Add
          </button>
        </div>
        <ul>
          {doc.entries.map((item, index) => {
            const ability = typeof item['Ability'] === 'string' ? item['Ability'] : ''
            const entryIssues = issues.filter((i) => i.path[0] === index)
            const hasError = entryIssues.some((i) => i.severity === 'error')
            return (
              <li key={item._id}>
                <button
                  type="button"
                  className={index === selected ? 'is-selected' : ''}
                  onClick={() => setSelected(index)}
                >
                  <span>{ability || <em>unnamed</em>}</span>
                  {entryIssues.length > 0 && (
                    <span className={`pill ${hasError ? 'pill--error' : 'pill--warn'}`}>
                      {entryIssues.length}
                    </span>
                  )}
                </button>
                {doc.entries.length > 1 && (
                  <button
                    type="button"
                    className="entries__remove"
                    aria-label={`Remove entry ${index + 1}`}
                    onClick={() => {
                      setDoc({ ...doc, entries: doc.entries.filter((_, i) => i !== index) })
                      setSelected((s) => Math.max(0, Math.min(s, doc.entries.length - 2)))
                    }}
                  >
                    ×
                  </button>
                )}
              </li>
            )
          })}
        </ul>
      </aside>

      <main className="editor">
        {importing && (
          <ImportPanel
            indices={indices}
            onClose={() => setImporting(false)}
            onLoad={(loaded) => {
              setDoc(loaded)
              setSelected(0)
            }}
          />
        )}
        {entry ? (
          <NodeEditor
            node={entry}
            structName="AbilityEdit"
            path={[selected]}
            indices={indices}
            onChange={update}
            filter={filter}
          />
        ) : (
          <p className="empty">No entry selected.</p>
        )}
      </main>

      <section className="output">
        <div className="output__head">
          <h2>XComAbilityEditor.ini</h2>
          <button type="button" onClick={copy}>
            {copied ? 'Copied' : 'Copy'}
          </button>
        </div>
        <pre>{output}</pre>

        <IssueList errors={errors} warnings={warnings} onSelect={(path) => {
          const index = path[0]
          if (typeof index === 'number') setSelected(index)
        }} />
      </section>
    </div>
  )
}

function IssueList({
  errors,
  warnings,
  onSelect,
}: {
  errors: Issue[]
  warnings: Issue[]
  onSelect: (path: Path) => void
}) {
  if (errors.length === 0 && warnings.length === 0) {
    return <p className="issues issues--ok">No problems found.</p>
  }

  return (
    <div className="issues">
      {[...errors, ...warnings].map((issue, index) => (
        <button
          type="button"
          key={`${issue.title}-${index}`}
          className={`issue issue--${issue.severity}`}
          onClick={() => onSelect(issue.path)}
        >
          <strong>{issue.title}</strong>
          <span>{issue.detail}</span>
        </button>
      ))}
    </div>
  )
}
