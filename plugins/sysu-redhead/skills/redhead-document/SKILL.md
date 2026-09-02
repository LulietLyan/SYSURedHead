---
name: redhead-document
description: "Create or typeset a new Chinese Party and government red-header document draft with SYSURedHead, including notices, requests, joint documents, letters, orders, minutes, and campus reports. Use when the user asks to generate, format, initialize, or compile such a LaTeX document. Do not use merely to summarize, translate, or review an existing document, or to create official seals, signatures, approval records, exchange packages, or archive packages."
---

# SYSURedHead Document

Create a self-contained XeLaTeX project from the bundled SYSURedHead templates, fill its public semantic fields, and optionally compile it. Treat every result as a typesetting draft, never as an officially issued document or proof of compliance.

## Route the request

- Use this workflow for creating, reformatting, or compiling a new red-header document project.
- Do not initialize a project when the user only wants a summary, translation, critique, or factual explanation of an existing document. Handle that request normally without this skill's generation workflow.
- Before accepting document content, read [references/safety.md](references/safety.md). If the content may be restricted, continue only with sanitized placeholders.
- When choosing a document type or editing fields, read [references/fields.md](references/fields.md). Do not guess a layout-changing field when different choices would produce materially different output.

## Create the project

1. Establish the target directory, one of the seven supported types, the intended direction, the semantic fields, the body outline, optional components, and whether a local build is wanted. Ask only about missing choices that change layout or legal meaning; use conspicuous placeholders for ordinary missing prose.
2. Classify the work as a fictional demonstration or a real draft. For a demonstration, choose conspicuously fictional metadata and an explicit fixed example date when the user omits them, then report those assumptions. For a real draft, preserve only user-supplied, authorized public information and never invent an authority, document number, signatory, date, classification, approval, or distribution scope; ask for a required value or leave a conspicuous placeholder.
3. Resolve the directory containing this `SKILL.md` as `skill_dir`, then run the bundled initializer without assuming that the current working directory is the skill directory:

   ```bash
   "$skill_dir/scripts/init-document.sh" --type notice --output /path/to/new-document
   ```

   Replace `notice` with the selected type. The destination must be new or empty; do not bypass the initializer's refusal to overwrite files.
4. Edit only `document.tex` for document-specific content. Use `\RedHeadSetup` and the public components listed in the field reference. Do not modify the bundled class or style modules to encode one document's data, and do not use internal commands containing `@`.
5. Escape user text for LaTeX, preserve explicit line or paragraph structure, and keep `draft-label` visibly non-empty. Use a fixed written date instead of `\today` when reproducible output matters.
6. When compilation is requested, or when it is unspecified and both `make` and XeLaTeX are available, state the default-to-build assumption and run `make` in the generated directory. Do not compile an initialize-only request. Do not install packages, fetch fonts, or use network services. If the toolchain is unavailable, leave the complete source project and report that it was not compiled.

## Check and report

- Treat a nonzero build as a failure. Inspect the log for LaTeX errors, undefined control sequences, missing glyphs, and content overflow; correct document-source problems and rebuild when possible.
- If `pdfinfo` is available, confirm the generated PDF uses A4 pages. Visually inspect layout when a PDF preview tool is available and the task warrants it.
- Report the selected type, output path, build result, PDF path when produced, unresolved placeholders, warnings, and the manual checks from the safety reference.
- Never describe the output as certified, approved, signed, sealed, exchanged, archived, or automatically compliant with GB/T 9704-2012.
