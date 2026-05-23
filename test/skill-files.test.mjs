import { test } from 'node:test';
import assert from 'node:assert/strict';
import { readFile, stat } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const skillDir = path.join(root, 'skills', 'ikenga-artifact-builder');

test('skill directory exists', async () => {
  const s = await stat(skillDir);
  assert.ok(s.isDirectory());
});

test('SKILL.md has valid frontmatter', async () => {
  const md = await readFile(path.join(skillDir, 'SKILL.md'), 'utf8');
  assert.match(md, /^---\s*\nname: ikenga-artifact-builder\b/, 'frontmatter must start with name');
  assert.match(md, /\nlicense: Apache-2\.0\b/, 'frontmatter must declare Apache-2.0 license');
  assert.match(md, /\n---\s*\n/, 'frontmatter must close');
});

test('three reference artifacts present and non-empty', async () => {
  for (const name of ['hello-world.html', 'cfo-daily.html', 'ceo-overview.html']) {
    const p = path.join(skillDir, 'references', name);
    const buf = await readFile(p);
    assert.ok(buf.length > 1000, `${name} should be substantive (>1KB)`);
    assert.match(buf.toString('utf8'), /<script type="application\/json" id="ikenga-manifest">/, `${name} must have manifest tag`);
    assert.match(buf.toString('utf8'), /<script type="application\/json" id="ikenga-mock-data">/, `${name} must have mock-data tag`);
  }
});

// Per ADR-009 every pkg/artifact ships Apache-2.0; the BUSL tier was retired.
// The agent copies the manifest template + examples verbatim, so a stale
// BUSL-1.1 here propagates into every generated artifact. Guard against it.
test('manifest template + examples declare Apache-2.0, never BUSL', async () => {
  const files = [
    path.join(skillDir, 'SKILL.md'),
    ...['hello-world.html', 'cfo-daily.html', 'ceo-overview.html'].map((n) =>
      path.join(skillDir, 'references', n),
    ),
  ];
  for (const p of files) {
    const txt = await readFile(p, 'utf8');
    assert.doesNotMatch(txt, /"license":\s*"BUSL-1\.1"/, `${path.basename(p)} must not embed a BUSL-1.1 manifest license`);
    assert.match(txt, /"license":\s*"Apache-2\.0"/, `${path.basename(p)} must embed an Apache-2.0 manifest license`);
  }
});
