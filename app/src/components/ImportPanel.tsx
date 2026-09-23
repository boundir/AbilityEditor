import { useState } from 'react'

import { parseConfig, type ParseProblem } from '../parse'
import type { Indices } from '../schema'
import type { Doc } from '../state'

/**
 * Paste an existing config to load it into the editor and have it checked.
 */

interface Props {
  indices: Indices
  onLoad: (doc: Doc) => void
  onClose: () => void
}

export function ImportPanel({ indices, onLoad, onClose }: Props) {
  const [text, setText] = useState('')
  const [problems, setProblems] = useState<ParseProblem[] | null>(null)
  const [count, setCount] = useState(0)
  const [pending, setPending] = useState<Doc | null>(null)

  const check = () => {
    const result = parseConfig(text, indices)
    setProblems(result.problems)
    setCount(result.entryCount)
    setPending(result.doc)
  }

  const errors = problems?.filter((p) => p.severity === 'error') ?? []
  const warnings = problems?.filter((p) => p.severity === 'warning') ?? []

  return (
    <div className="import">
      <div className="import__head">
        <h2>Check an existing config</h2>
        <button type="button" onClick={onClose}>
          Close
        </button>
      </div>

      <p className="import__intro">
        Paste `+AbilityEdits` entries below. Anything the mod would silently ignore is listed
        here, and loading replaces what is currently in the editor.
      </p>

      <textarea
        value={text}
        onChange={(event) => {
          setText(event.target.value)
          setProblems(null)
          setPending(null)
        }}
        spellCheck={false}
        rows={10}
        placeholder={'[AbilityEditor.X2DLCInfo_AbilityEditor]\n\n+AbilityEdits=( \\\\\n    Ability=SwordSlice \\\\\n)'}
      />

      <div className="import__actions">
        <button type="button" onClick={check} disabled={text.trim() === ''}>
          Check
        </button>
        <button
          type="button"
          onClick={() => {
            if (pending) {
              onLoad(pending)
              onClose()
            }
          }}
          disabled={!pending}
        >
          Load {count > 0 ? `${count} ${count === 1 ? 'entry' : 'entries'}` : ''}
        </button>
      </div>

      {problems && (
        <div className="import__results">
          {errors.length === 0 && warnings.length === 0 ? (
            <p className="issues--ok">
              Read {count} {count === 1 ? 'entry' : 'entries'}, nothing to report.
            </p>
          ) : (
            <>
              <p className="import__summary">
                {errors.length > 0 && <strong>{errors.length} problems</strong>}
                {errors.length > 0 && warnings.length > 0 && ', '}
                {warnings.length > 0 && <span>{warnings.length} worth a look</span>}
              </p>
              <div className="issues">
                {[...errors, ...warnings].map((problem, index) => (
                  <div key={index} className={`issue issue--${problem.severity}`}>
                    <strong>
                      {problem.line > 0 && <span className="issue__line">line {problem.line}</span>}
                      {problem.title}
                    </strong>
                    <span>{problem.detail}</span>
                  </div>
                ))}
              </div>
            </>
          )}
        </div>
      )}
    </div>
  )
}
