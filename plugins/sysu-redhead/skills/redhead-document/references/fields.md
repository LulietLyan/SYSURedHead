# SYSURedHead fields

Read this reference when selecting a template type or editing `document.tex`. The initializer copies the selected type to `document.tex`; document-specific changes belong there.

## Type matrix

| `--type` | Template | `layout` | `direction` | Fields that normally determine the layout |
| --- | --- | --- | --- | --- |
| `notice` | `types/notice.tex` | `normal` | `down` | `authority`, `mark`, `document-number`, `title`, `recipients`, `issuer`, `date` |
| `request` | `types/request.tex` | `normal` | `up` | notice fields plus `signer` |
| `joint` | `types/joint-notice.tex` | `normal` | `down` | `authority`, `coauthorities`, `mark`, `document-number`, `title`, `recipients`, `issuer`, `date` |
| `letter` | `types/letter.tex` | `letter` | `parallel` | `authority`, `mark`, `document-number`, `title`, `recipients`, `issuer`, `date` |
| `order` | `types/order.tex` | `order` | `down` | `authority`, `mark`, `order-number`, `title`, `signer-title`, `signer`, `date` |
| `minutes` | `types/minutes.tex` | `minutes` | `parallel` | `authority`, `meeting-name`, `mark`, `document-number`, `title`, `date` |
| `campus` | `types/campus-report.tex` | `campus` | `parallel` | `authority`, `mark`, `document-number`, `title`, `recipients`, `issuer`, `date` |

The type selects a useful starting point, not a legal classification. When a request does not clearly distinguish `normal`, `letter`, `order`, `minutes`, or `campus`, confirm the intended layout before initializing.

## Setup keys

Put document metadata in the single public setup block:

```tex
\RedHeadSetup{
  layout = normal,
  direction = down,
  authority = {某市示例事务局},
  mark = {某市示例事务局文件},
  document-number = {示例发〔2026〕1号},
  title = {关于示例事项的通知},
  recipients = {各有关单位：},
  issuer = {某市示例事务局},
  date = {2026年9月2日},
  draft-label = {排版草稿，不具公文效力},
  seal = none
}
```

Supported keys and values:

| Key | Value |
| --- | --- |
| `layout` | `normal`, `letter`, `order`, `minutes`, or `campus` |
| `direction` | `down`, `up`, or `parallel` |
| `copy-number` | Copy number text; required by project validation when `classification` is set |
| `classification` | Empty or `none`, `秘密`, `机密`, or `绝密` |
| `classification-period` | Confidentiality period text; use only with `classification` |
| `urgency` | Empty or `none`, `加急`, or `特急` |
| `authority` | Primary issuing authority |
| `coauthorities` | Additional joint authorities separated with semicolons |
| `mark` | Issuing-authority mark or campus-report mark |
| `document-number` | Document number |
| `signer` | Signatory name; required by project validation for `direction = up` |
| `signer-title` | Signatory title used by the order layout |
| `title` | Document title |
| `recipients` | Main recipients, including punctuation intended for display |
| `issuer` | Issuing-authority signature text |
| `date` | Written formation date; prefer a fixed date |
| `note` | Parenthetical note below the closing |
| `copies` | Copy recipients for the imprint |
| `print-office` | Printing office |
| `print-date` | Printing date |
| `order-number` | Order number used by the order layout |
| `meeting-name` | Meeting name or minutes mark |
| `draft-label` | Visible draft status; keep non-empty |
| `seal` | `none` or `placeholder`; never an image or imitation of a seal |

## Public components

Use only these document-level interfaces:

```tex
\RedHeadSetup{...}
\RedHeadMakeHead
\RedHeadMakeClosing
\RedHeadNote{...}
\begin{RedHeadAttachments}
  \item Attachment title
\end{RedHeadAttachments}
\begin{RedHeadAttachment}{1}{Attachment title}
  Attachment body
\end{RedHeadAttachment}
\RedHeadMeetingList{Attendees}{Names}
\RedHeadSealPlaceholder
\RedHeadMakeImprint
\RedHeadValidate
```

Keep body headings in ordinary LaTeX sectioning commands already demonstrated by the selected template. Escape LaTeX-special characters in prose, especially `#`, `$`, `%`, `&`, `_`, `{`, `}`, `~`, `^`, and `\`. Do not insert raw user text into command arguments without checking it.

## Validation decisions

- `direction = up` without `signer` must remain an explicit warning or unresolved field; do not invent a name.
- Any non-empty `classification` without `copy-number` must remain an explicit warning or unresolved field; do not invent a copy number or security marking.
- Unknown enumerated values must be corrected to a supported value, not forced through the class internals.
- `seal = placeholder` produces only the template's visibly non-authoritative position marker. Never replace it with an emblem, scanned seal, signature, or signature image.
- Preserve `draft-label = {排版草稿，不具公文效力}` or another equally clear non-official label in every generated draft.
