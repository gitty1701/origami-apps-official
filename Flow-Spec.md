# Flow Language Specification
**Official Specification — Version 1.0**
*The complete reference for the Flow programming language, compiler, runtime, standard library, IDE, and tooling.*

---

## Table of Contents

1. [Vision & Philosophy](#1-vision--philosophy)
2. [Language Overview & File Types](#2-language-overview--file-types)
3. [Lexer Specification](#3-lexer-specification)
4. [Grammar & Syntax (EBNF)](#4-grammar--syntax-ebnf)
5. [Variables & Values](#5-variables--values)
6. [Objects & Blocks](#6-objects--blocks)
7. [Pages & Sections](#7-pages--sections)
8. [UI Elements](#8-ui-elements)
9. [Styling with `looks`](#9-styling-with-looks)
10. [Events & Actions](#10-events--actions)
11. [Conditions](#11-conditions)
12. [Loops & Repetition](#12-loops--repetition)
13. [Functions (`when`)](#13-functions-when)
14. [Collections](#14-collections)
15. [Type System](#15-type-system)
16. [AST Schema](#16-ast-schema)
17. [Compiler Pipeline](#17-compiler-pipeline)
18. [HTML / CSS / JS Backend](#18-html--css--js-backend)
19. [React Backend](#19-react-backend)
20. [Flutter Backend](#20-flutter-backend)
21. [Android Compose Backend](#21-android-compose-backend)
22. [Game Runtime](#22-game-runtime)
23. [Standard Library](#23-standard-library)
24. [Package Manager (`fpm`)](#24-package-manager-fpm)
25. [Language Server Protocol](#25-language-server-protocol)
26. [Error Diagnostics](#26-error-diagnostics)
27. [Flow Studio IDE](#27-flow-studio-ide)
28. [CLI Reference](#28-cli-reference)
29. [Testing](#29-testing)
30. [Roadmap](#30-roadmap)

---

## 1. Vision & Philosophy

### 1.1 What is Flow?

Flow is a **beginner-friendly, multi-target programming language** that compiles to real production code. It allows anyone — a ten-year-old, a student, a hobbyist, or a professional — to build:

- **Websites and web apps** (compiles to HTML + CSS + JS or React)
- **Mobile apps** (compiles to Flutter or Android Compose)
- **Desktop apps** (future target)
- **2D and 3D games** (built-in game runtime)

Flow achieves this with **one language, one editor, one mental model**.

### 1.2 Design Philosophy

| Principle | Meaning |
|-----------|---------|
| **Readable as English** | Code should read like a sentence, not a symbol puzzle |
| **One language everywhere** | Same syntax for web, mobile, and games |
| **Visual-editor first** | Every construct maps cleanly to a visual panel |
| **Progressive complexity** | Simple things stay simple; advanced things remain possible |
| **No unnecessary symbols** | Avoid `{}`, `;`, `()` unless they genuinely add clarity |
| **Consistency above all** | Same pattern for similar ideas across the entire language |

### 1.3 What Flow Is NOT

- Flow is **not** HTML or a template language
- Flow is **not** a visual/block-based language like Scratch
- Flow is **not** a wrapper around JavaScript
- Flow is **not** a domain-specific language
- Flow **has** its own grammar, compiler, runtime, and standard library

### 1.4 Inspirations

Flow draws inspiration from:

| Source | What Flow borrows |
|--------|-------------------|
| Scratch | Approachable syntax, event model |
| Roblox Studio | Explorer + Properties IDE model, entity system |
| Figma | Visual design-first thinking |
| Kotlin | Clean, consistent syntax |
| Swift | Readable type system |
| Python | Natural-language feel |
| Natural English | `if score = 100 or score > 100 then win` |

---

## 2. Language Overview & File Types

### 2.1 File Extensions

| Extension | Purpose |
|-----------|---------|
| `.flow` | Main source file (pages, components, game scenes, logic) |
| `.looks` | Style/theme file |
| `.fmod` | Package manifest |

### 2.2 Top-Level Constructs

Every `.flow` file contains one or more of:

```
page        — A routable screen (web page or mobile screen)
section     — A visual block inside a page
component   — A reusable UI element
game        — A game scene
entity      — A game object (inside a game)
service     — Backend logic / API calls
when        — A named event handler / function
```

### 2.3 Hello World (Web)

```flow
page Home

section Hero [
    text.LargeHeading [
        text = Welcome to Flow
    ]

    button [
        id   = startBtn
        text = Get Started
    ]
]

when startBtn is clicked
    open About
```

### 2.4 Hello World (Game)

```flow
game Pong

entity Ball [
    x      = 400
    y      = 300
    speedX = 5
    speedY = 5
]

when Ball updates
    change Ball.x by Ball.speedX
    change Ball.y by Ball.speedY

    if Ball.x > 800 or Ball.x < 0 then
        change Ball.speedX by Ball.speedX * -2

    if Ball.y > 600 or Ball.y < 0 then
        change Ball.speedY by Ball.speedY * -2
```

---

## 3. Lexer Specification

### 3.1 Overview

The Flow lexer converts raw source text into a flat stream of tokens. Whitespace and indentation are **not significant** for block structure (blocks use `[` and `]`). Newlines are **not significant** except to terminate certain single-line constructs (event handlers, conditions without blocks).

### 3.2 Token Types

| Token | Pattern | Example |
|-------|---------|---------|
| `KEYWORD` | (see list below) | `page`, `when`, `if` |
| `IDENTIFIER` | `[a-zA-Z_][a-zA-Z0-9_.]*` | `score`, `player.health` |
| `NUMBER` | `[0-9]+(\.[0-9]+)?` | `42`, `3.14` |
| `STRING` | `"[^"]*"` or bare word in value position | `"Hello"`, `Hello` |
| `COLOR` | `#[0-9a-fA-F]{3,6}` | `#0f172a` |
| `BOOL` | `true` or `false` | `true` |
| `LBRACKET` | `[` | `[` |
| `RBRACKET` | `]` | `]` |
| `EQUALS` | `=` | `=` |
| `OPERATOR` | `+ - * / > < >= <=` | `>` |
| `COMMENT_LINE` | `// ... \n` | `// note` |
| `COMMENT_BLOCK` | `/* ... */` | `/* block */` |
| `NEWLINE` | `\n` | (structural in single-line forms) |

### 3.3 Keyword List

```
page section component game entity service
when is clicked pressed hovered updated
if then else
and or not
repeat times forever while
change by open run print set
looks text button image input video
row column grid stack scroll
true false null
import from as
```

### 3.4 Bare-Word Strings

In **value position** (right-hand side of `=`), a word that is not a keyword or number is treated as a bare string literal:

```flow
text = Hello          // bare string: "Hello"
text = Get Started    // bare string: "Get Started"
name = Alex           // bare string: "Alex"
```

This makes writing UI copy feel natural without quotation marks.

### 3.5 Comments

```flow
// Single line comment

/*
   Multi-line
   comment
*/
```

---

## 4. Grammar & Syntax (EBNF)

```ebnf
program         ::= top_level*

top_level       ::= page_decl
                  | section_decl
                  | component_decl
                  | game_decl
                  | entity_decl
                  | when_decl
                  | import_stmt

page_decl       ::= 'page' IDENT

section_decl    ::= 'section' IDENT block

component_decl  ::= 'component' IDENT block

game_decl       ::= 'game' IDENT

entity_decl     ::= 'entity' IDENT block

block           ::= '[' block_item* ']'

block_item      ::= prop_assign
                  | element
                  | variable_decl
                  | when_inline
                  | if_stmt
                  | loop_stmt
                  | action_stmt

prop_assign     ::= IDENT '=' value

value           ::= NUMBER | COLOR | BOOL | 'null'
                  | STRING | BARE_STRING | IDENT
                  | tuple | list_lit

tuple           ::= '(' value (',' value)+ ')'
list_lit        ::= '[' (value (',' value)*)? ']'

element         ::= element_tag block?
element_tag     ::= IDENT ('.' IDENT)?

variable_decl   ::= IDENT '=' value

when_decl       ::= 'when' event_spec NEWLINE action_block

when_inline     ::= 'when' event_spec NEWLINE action_block

event_spec      ::= IDENT 'is' event_type
                  | IDENT 'updates'
                  | IDENT 'loads'
                  | IDENT 'collides' 'with' IDENT
                  | 'key' IDENT 'is' 'pressed'

event_type      ::= 'clicked' | 'hovered' | 'pressed' | 'changed'

action_block    ::= action_stmt+ (indented or in block)

action_stmt     ::= change_stmt
                  | open_stmt
                  | run_stmt
                  | print_stmt
                  | set_stmt
                  | if_stmt
                  | loop_stmt
                  | IDENT '=' value

change_stmt     ::= 'change' IDENT 'by' expr
open_stmt       ::= 'open' IDENT
run_stmt        ::= 'run' IDENT
print_stmt      ::= 'print' value+
set_stmt        ::= 'set' IDENT 'to' value

if_stmt         ::= 'if' condition 'then' NEWLINE action_block
                    ('else' NEWLINE action_block)?

condition       ::= expr (('and' | 'or') expr)*
                  | 'not' condition

expr            ::= value
                  | IDENT
                  | expr OPERATOR expr
                  | expr 'or' 'more'    // sugar for >= 

loop_stmt       ::= 'repeat' NUMBER 'times' NEWLINE action_block
                  | 'repeat' 'forever' NEWLINE action_block
                  | 'while' condition NEWLINE action_block

import_stmt     ::= 'import' IDENT (',' IDENT)* 'from' STRING
```

---

## 5. Variables & Values

### 5.1 Declaration

Flow does not use `let`, `var`, or `const`. A variable is created by assigning to a name:

```flow
score = 0
name  = Alex
isPaused = false
```

Variables declared at the top level of a page or game are **page-scoped**.
Variables declared inside an entity or component block are **local** to that object.

### 5.2 Mutability

All variables are **mutable by default**. There is no `const` keyword in the surface language (the compiler may optimize read-only bindings internally).

### 5.3 Types (Inferred)

Flow uses **structural type inference**. The programmer never writes a type annotation unless they want to. The compiler infers types from assignment:

| Value | Inferred Type |
|-------|--------------|
| `0`, `3.14` | Number |
| `Hello`, `"World"` | Text |
| `true`, `false` | Bool |
| `#ff0000` | Color |
| `[1, 2, 3]` | List of Number |
| `null` | Null |

### 5.4 `change by` Mutation

```flow
change score by 1       // score = score + 1
change health by -10    // health = health - 10
change speed by speed   // speed = speed * 2 (doubles)
```

### 5.5 `set to` Assignment

```flow
set score to 0
set name to Player1
```

Both `name = value` and `set name to value` are valid. The `set...to` form reads more naturally in action blocks.

---

## 6. Objects & Blocks

### 6.1 Object Syntax

An **object** in Flow is a named collection of properties and/or nested elements, delimited by `[` and `]`:

```flow
player [
    score  = 0
    health = 100
    name   = Hero
]
```

### 6.2 Nesting

Objects can be nested to any depth:

```flow
page Home

section Hero [
    row [
        text.LargeHeading [ text = Hello ]
        button [ text = Start  id = startBtn ]
    ]
]
```

### 6.3 Dot Modifier

A dot modifier selects a **style preset** from the theme:

```flow
text.LargeHeading [ text = Welcome ]
text.Subtitle     [ text = Build anything ]
button.Danger     [ text = Delete ]
row.Centered      [ ... ]
```

The modifier is syntactic sugar — `text.LargeHeading` compiles to a `text` element with the `LargeHeading` style class applied from the active theme.

---

## 7. Pages & Sections

### 7.1 Pages

A `page` declaration defines a routable screen:

```flow
page Home
page Login
page Dashboard
page GameOver
```

Pages are top-level; they do not have a block. Their content is defined by the `section` declarations that follow them (or are in the same file named after the page).

### 7.2 Sections

A `section` is a named visual region inside a page:

```flow
page Home

section Hero [
    text.LargeHeading [ text = Welcome ]
]

section Footer [
    text [ text = © 2025 Flow ]
]
```

Sections compile to `<section>` tags in HTML, or equivalent layout containers in Flutter/Compose.

### 7.3 Navigation

```flow
open Home         // navigate to the Home page
open Login        // navigate to Login
open GameOver     // navigate to a game-over screen
```

The compiler generates the appropriate router call for each target.

---

## 8. UI Elements

### 8.1 Text

```flow
text [ text = Hello World ]

text.LargeHeading [ text = Welcome ]
text.Subtitle     [ text = Build anything ]
text.Caption      [ text = © 2025 ]
text.Code         [ text = print Hello ]
```

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `text` | Text | Content to display |
| `color` | Color | Text color |
| `size` | Number | Font size in px |
| `bold` | Bool | Bold weight |
| `italic` | Bool | Italic style |
| `align` | Text | `left`, `center`, `right` |

### 8.2 Button

```flow
button [
    id   = startBtn
    type = start
    text = Get Started
]
```

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `id` | Text | Unique identifier for event binding |
| `text` | Text | Button label |
| `type` | Text | Semantic type hint (`start`, `submit`, `danger`, `ghost`) |
| `disabled` | Bool | Whether button is disabled |
| `icon` | Text | Icon name from icon set |

### 8.3 Input

```flow
input [
    id          = emailField
    placeholder = Enter your email
    type        = email
    bind        = userEmail
]
```

**Properties:**

| Property | Type | Description |
|----------|------|-------------|
| `id` | Text | Identifier |
| `placeholder` | Text | Placeholder text |
| `type` | Text | `text`, `email`, `password`, `number` |
| `bind` | Identifier | Variable to two-way bind |

### 8.4 Image

```flow
image [
    src    = logo.png
    width  = 200
    height = 100
    alt    = Flow Logo
]
```

### 8.5 Video

```flow
video [
    src      = intro.mp4
    autoplay = true
    loop     = true
    muted    = true
]
```

### 8.6 Layout Elements

```flow
row    [ ... ]          // horizontal flex container
column [ ... ]          // vertical flex container
grid   [ cols = 3  ... ] // CSS grid
stack  [ ... ]          // absolute overlay (z-stacked)
scroll [ ... ]          // scrollable container
```

**Common layout properties:**

| Property | Type | Description |
|----------|------|-------------|
| `gap` | Number | Space between children |
| `padding` | Number | Inner spacing |
| `align` | Text | `start`, `center`, `end`, `stretch` |
| `justify` | Text | `start`, `center`, `end`, `between` |
| `width` | Number or Text | Width in px or `fill`, `wrap` |
| `height` | Number or Text | Height |

### 8.7 Navigation Elements

```flow
link   [ to = About  text = About Us ]
tabs   [ items = tabList ]
drawer [ trigger = menuBtn  ... ]
```

---

## 9. Styling with `looks`

### 9.1 Inline Styles

Any element can receive style properties directly:

```flow
text [
    text       = Hello
    color      = #4F46E5
    size       = 32
    bold       = true
]
```

### 9.2 The `looks` Block

A `looks` block defines styles attached to the nearest element or page:

```flow
section Hero [
    looks [
        background.color = #0f172a
        padding          = 64
    ]

    text.LargeHeading [
        text = Welcome
        looks [
            color = #ffffff
        ]
    ]
]
```

### 9.3 `.looks` Theme Files

Global themes live in `.looks` files:

```flow
// theme.looks

theme Light [
    primary   = #4F46E5
    secondary = #7C3AED
    danger    = #EF4444
    bg        = #FFFFFF
    surface   = #F9FAFB
    text      = #111827
    radius    = 8
    font      = Inter
    shadow    = 0 2px 8px rgba(0,0,0,0.1)
]

theme Dark [
    primary   = #818CF8
    secondary = #A78BFA
    danger    = #F87171
    bg        = #0F172A
    surface   = #1E293B
    text      = #F1F5F9
    radius    = 8
    font      = Inter
]
```

### 9.4 Style Presets

Style presets in `.looks` files define named element variants:

```flow
style LargeHeading [
    size   = 48
    bold   = true
    color  = primary
    margin = 0 0 16 0
]

style Subtitle [
    size   = 20
    color  = text
    opacity = 0.7
]

style Danger [
    background.color = danger
    color            = #fff
    radius           = radius
]
```

### 9.5 Animations

```flow
button [
    text = Hover Me
    looks [
        transition = all 0.2s ease

        hover [
            background.color = primary
            scale            = 1.05
        ]
    ]
]
```

---

## 10. Events & Actions

### 10.1 Event Syntax

Flow uses `when` to respond to events:

```flow
when startBtn is clicked
    open Home

when emailField is changed
    set emailError to null

when key Escape is pressed
    run closeModal

when player updates
    change player.x by player.speedX
```

### 10.2 Event Types

| Event | Description |
|-------|-------------|
| `is clicked` | Mouse/tap click |
| `is hovered` | Mouse hover start |
| `is pressed` | Mousedown / touchstart |
| `is changed` | Input value changed |
| `updates` | Game entity per-frame update |
| `loads` | Page or component mounted |
| `collides with X` | Game collision event |
| `key K is pressed` | Keyboard key event |

### 10.3 Actions

| Action | Syntax | Description |
|--------|--------|-------------|
| Navigate | `open PageName` | Go to a page |
| Change var | `change X by N` | Increment/decrement |
| Set var | `set X to V` | Assign value |
| Assign | `X = V` | Assign value (shorthand) |
| Run handler | `run handlerName` | Call another `when` |
| Print | `print Hello` | Log to console |
| Show element | `show elementId` | Make element visible |
| Hide element | `hide elementId` | Make element invisible |
| Play sound | `play soundName` | Play audio asset |
| Stop sound | `stop soundName` | Stop audio |
| Spawn entity | `spawn EntityName` | Create game entity |
| Destroy entity | `destroy self` | Remove entity |

### 10.4 Multi-Action Handlers

```flow
when startBtn is clicked
    set isPaused to false
    set score to 0
    open Game
    play startSound
```

### 10.5 Inline Event Handlers (inside blocks)

```flow
button [
    text = Click Me
    when self is clicked
        change score by 1
        print Score is now
        print score
]
```

`self` refers to the current element.

---

## 11. Conditions

### 11.1 Basic `if...then`

```flow
if score = 100 then
    run winGame
```

### 11.2 `if...then...else`

```flow
if health > 0 then
    run continueGame
else
    run gameOver
```

### 11.3 Natural Language Comparisons

Flow intentionally avoids `>=` and `<=` in favor of readable alternatives:

| Flow Syntax | Meaning |
|-------------|---------|
| `score = 100` | Equal to |
| `score > 100` | Greater than |
| `score < 100` | Less than |
| `score = 100 or score > 100` | Greater than or equal (preferred) |
| `score = 100 or score < 100` | Less than or equal (preferred) |
| `not score = 0` | Not equal |

The compiler does support `>=` and `<=` as valid operators, but the style guide discourages them for beginner code.

### 11.4 Compound Conditions

```flow
if score > 50 and health > 0 then
    show winBanner

if name = Alex or name = Sam then
    show VIPBadge

if not isPaused then
    run updateGame
```

### 11.5 Nested Conditions

```flow
if score > 100 then
    if health = 100 then
        run perfectWin
    else
        run normalWin
else
    run continueGame
```

---

## 12. Loops & Repetition

### 12.1 `repeat N times`

```flow
repeat 10 times
    change score by 1
```

### 12.2 `repeat forever`

```flow
repeat forever
    run updateParticles
```

Used primarily in game loops. In web contexts, `repeat forever` compiles to `requestAnimationFrame`.

### 12.3 `while` Loop

```flow
while score < 100
    change score by 1
    run updateScoreDisplay
```

### 12.4 `for each` Loop

```flow
for each item in cart
    show CartItem with item

for each player in players
    change player.score by 10
```

---

## 13. Functions (`when`)

Flow does not use traditional function syntax. Named logic blocks are declared with `when`:

### 13.1 Named Handlers

```flow
when gameOver runs
    set score to 0
    set health to 100
    open GameOver
```

These are called with:

```flow
run gameOver
```

### 13.2 Handlers with Parameters (Advanced)

```flow
when showMessage runs with text message
    set messageBox.text to message
    show messageBox
```

Called with:

```flow
run showMessage with text Game Over
```

### 13.3 Return Values

```flow
when double runs with number x
    return x * 2
```

Used in expressions:

```flow
set result to double with number score
```

---

## 14. Collections

### 14.1 Lists

```flow
colors = [red, green, blue]
scores = [10, 20, 30, 40]
names  = [Alice, Bob, Charlie]
```

### 14.2 Accessing Items

```flow
first = colors at 0
last  = colors at 2
```

### 14.3 List Operations

```flow
add purple to colors
remove red from colors
set colors to empty list

for each color in colors
    print color
```

### 14.4 Maps (Key-Value)

```flow
playerData = {
    name   = Alex
    score  = 0
    health = 100
}

set playerData.name to Jordan
print playerData.score
```

---

## 15. Type System

### 15.1 Types

| Type | Description | Examples |
|------|-------------|---------|
| `Number` | 64-bit float | `0`, `3.14`, `-1` |
| `Text` | UTF-8 string | `Hello`, `"World"` |
| `Bool` | Boolean | `true`, `false` |
| `Color` | Hex or named color | `#ff0000`, `red` |
| `Null` | No value | `null` |
| `List<T>` | Ordered collection | `[1, 2, 3]` |
| `Map<T>` | Key-value store | `{ x = 1 }` |

### 15.2 Type Inference

The compiler infers all types. No annotations are ever required. Type errors are reported as friendly messages.

### 15.3 Type Coercions

Flow automatically coerces `Number` to `Text` in string contexts:

```flow
print Your score is
print score         // score is a Number, printed as text
```

Explicit conversion:

```flow
set label to score as text
set num   to input.value as number
```

### 15.4 Null Safety

Flow variables can hold `null`. The compiler warns when a potentially-null variable is used without a guard:

```flow
if playerName = null then
    set playerName to Guest

print playerName    // safe
```

---

## 16. AST Schema

The AST is the internal tree structure the parser produces. All compiler backends consume the AST.

```json
{
  "PageDecl":      { "name": "string" },
  "SectionDecl":   { "name": "string", "body": ["Node"] },
  "ComponentDecl": { "name": "string", "body": ["Node"] },
  "GameDecl":      { "name": "string" },
  "EntityDecl":    { "name": "string", "body": ["Node"] },
  "Element":       { "tag": "string", "modifier": "string?", "props": "Map<string,Expr>", "body": ["Node"] },
  "PropAssign":    { "key": "string", "value": "Expr" },
  "LooksBlock":    { "props": "Map<string,Expr>", "hover": "LooksBlock?", "focus": "LooksBlock?" },
  "WhenDecl": {
    "event": "EventSpec",
    "body": ["ActionNode"]
  },
  "EventSpec": {
    "subject": "string",
    "type": "clicked|hovered|pressed|changed|updates|loads|collision|key"
  },
  "IfStmt":    { "cond": "Condition", "then": ["ActionNode"], "else": ["ActionNode"] },
  "RepeatStmt":{ "count": "Expr|'forever'", "body": ["ActionNode"] },
  "WhileStmt": { "cond": "Condition", "body": ["ActionNode"] },
  "ForEachStmt":{ "var": "string", "iterable": "Expr", "body": ["ActionNode"] },
  "ChangeStmt":{ "target": "string", "by": "Expr" },
  "SetStmt":   { "target": "string", "to": "Expr" },
  "OpenStmt":  { "page": "string" },
  "RunStmt":   { "handler": "string", "args": "Map<string,Expr>" },
  "PrintStmt": { "values": ["Expr"] },
  "ShowStmt":  { "target": "string" },
  "HideStmt":  { "target": "string" },
  "ReturnStmt":{ "value": "Expr?" },
  "Assign":    { "target": "string", "value": "Expr" },
  "BinaryExpr":{ "op": "string", "left": "Expr", "right": "Expr" },
  "Identifier":{ "name": "string" },
  "Literal":   { "kind": "number|text|bool|color|null", "value": "any" },
  "ListLit":   { "items": ["Expr"] },
  "MapLit":    { "pairs": "Map<string,Expr>" }
}
```

---

## 17. Compiler Pipeline

```
Source (.flow)
      │
      ▼
  [Lexer]  →  Token stream
      │
      ▼
  [Parser]  →  AST
      │
      ▼
  [Semantic Analyzer]
      ├── Name resolution
      ├── Type inference + checking
      ├── Scope analysis
      ├── Event graph resolution
      └── Error collection
      │
      ▼
  [IR — Intermediate Representation]
      │
      ├──▶ [HTML/CSS/JS Backend]     →  Static site
      ├──▶ [React Backend]           →  React + Tailwind
      ├──▶ [Flutter Backend]         →  Dart
      ├──▶ [Android Compose Backend] →  Kotlin
      └──▶ [Game Backend]            →  Canvas / WebGL
```

### 17.1 Semantic Analysis Rules

- Variables must be assigned before use
- `when` handler names must be unique per file
- `change X by N` requires X to be a Number
- `bind` on input requires a declared variable
- Circular `run` chains are detected and warned
- `self` is only valid inside element `when` blocks
- `open PageName` verifies that `page PageName` exists in the project

### 17.2 Intermediate Representation (IR)

```
IRProgram
  IRPage[]
    IRSection[]
      IRElement[]
        tag, modifier, props, children, styles
  IRHandler[]
    event, actions[]
  IREntity[]
    props, handlers[]
  IRAction
    ChangeAction | SetAction | OpenAction | RunAction
    PrintAction | IfAction | LoopAction | ReturnAction
```

---

## 18. HTML / CSS / JS Backend

### 18.1 Page Compilation

Each `page` becomes an HTML file (or route in SPA mode):

```
page Home  →  index.html
page About →  about.html
page Login →  login.html
```

### 18.2 Element Mapping

| Flow | HTML |
|------|------|
| `section X [ ]` | `<section id="X">...</section>` |
| `row [ ]` | `<div class="flow-row">...</div>` |
| `column [ ]` | `<div class="flow-col">...</div>` |
| `grid [ cols=3 ]` | `<div class="flow-grid flow-grid-3">` |
| `text [ text=X ]` | `<p>X</p>` |
| `text.LargeHeading` | `<h1 class="flow-LargeHeading">` |
| `button [ text=X ]` | `<button>X</button>` |
| `image [ src=X ]` | `<img src="X">` |
| `input [ bind=v ]` | `<input oninput="__flow.set('v',this.value)">` |
| `link [ to=P ]` | `<a href="/P">` |

### 18.3 Style Compilation

`looks` blocks compile to inline CSS custom properties and classes:

```css
:root {
    --flow-primary: #4F46E5;
    --flow-bg: #FFFFFF;
    --flow-radius: 8px;
    --flow-font: Inter;
}

.flow-LargeHeading {
    font-size: 48px;
    font-weight: 700;
    color: var(--flow-primary);
}
```

### 18.4 Reactive State (JS Runtime)

Flow compiles reactive variables to a minimal signal system:

```javascript
// Compiled output (simplified)
const __flow = {
    state: { score: 0, health: 100 },
    set(key, value) {
        this.state[key] = value;
        this.update(key);
    },
    update(key) {
        document.querySelectorAll(`[data-bind="${key}"]`)
            .forEach(el => el.textContent = this.state[key]);
    }
};
```

### 18.5 Event Compilation

```flow
when startBtn is clicked
    open Home
```

Compiles to:

```javascript
document.getElementById('startBtn').addEventListener('click', () => {
    window.location.href = '/home';
});
```

---

## 19. React Backend

### 19.1 Page → Component

Each `page` compiles to a React functional component:

```jsx
// Home.jsx
export default function Home() {
    const [score, setScore] = React.useState(0);

    return (
        <section id="Hero">
            <h1 className="flow-LargeHeading">Welcome</h1>
            <button onClick={() => navigate('/about')}>Get Started</button>
        </section>
    );
}
```

### 19.2 Routing

Pages compile with React Router:

```jsx
<Routes>
    <Route path="/" element={<Home />} />
    <Route path="/about" element={<About />} />
    <Route path="/login" element={<Login />} />
</Routes>
```

### 19.3 State

Reactive Flow variables become `useState` hooks.

---

## 20. Flutter Backend

### 20.1 Page → StatefulWidget

```dart
class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
    int score = 0;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Column(children: [
                Text('Welcome', style: TextStyle(fontSize: 48)),
                ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/about'),
                    child: Text('Get Started'),
                ),
            ]),
        );
    }
}
```

### 20.2 Element Mapping

| Flow | Flutter |
|------|---------|
| `row` | `Row(children:[])` |
| `column` | `Column(children:[])` |
| `text` | `Text(...)` |
| `button` | `ElevatedButton(...)` |
| `image` | `Image.asset(...)` |
| `input` | `TextField(...)` |
| `scroll` | `SingleChildScrollView(...)` |
| Navigation | `Navigator.pushNamed(...)` |

---

## 21. Android Compose Backend

### 21.1 Page → Composable

```kotlin
@Composable
fun Home(navController: NavController) {
    var score by remember { mutableStateOf(0) }

    Column {
        Text("Welcome", fontSize = 48.sp, fontWeight = FontWeight.Bold)
        Button(onClick = { navController.navigate("about") }) {
            Text("Get Started")
        }
    }
}
```

### 21.2 Element Mapping

| Flow | Compose |
|------|---------|
| `row` | `Row {}` |
| `column` | `Column {}` |
| `text` | `Text(...)` |
| `button` | `Button { Text(...) }` |
| `image` | `Image(painter = ...)` |
| `input` | `TextField(...)` |

---

## 22. Game Runtime

### 22.1 Game Scene

```flow
game Pong

entity Ball [
    x = 400  y = 300
    speedX = 5  speedY = 5
    sprite = ball.png
]

entity Paddle [
    x = 20  y = 250
    width = 10  height = 80
    speed = 6
]
```

### 22.2 Entity Component System (ECS)

Every `entity` compiles to an ECS entry with:
- **Transform**: x, y, width, height, rotation
- **Sprite**: image asset
- **Collider**: bounding box (auto-generated from width/height)
- **Physics**: velocity, gravity (opt-in)
- **Scripts**: the compiled `when` handlers

### 22.3 Game Loop

```
Per frame (60fps target):
    1. processInput()
    2. for each entity: fireUpdateHandlers(entity)
    3. detectCollisions()
    4. fireCollisionHandlers()
    5. renderAll()
```

### 22.4 Game Events

```flow
when Ball updates
    change Ball.x by Ball.speedX
    change Ball.y by Ball.speedY

when Ball collides with Wall
    change Ball.speedX by Ball.speedX * -2

when key ArrowUp is pressed
    change Paddle.y by -6

when key ArrowDown is pressed
    change Paddle.y by 6
```

### 22.5 Built-in Game Components

| Component | Description |
|-----------|-------------|
| `sprite` | Image rendered at entity position |
| `collider` | AABB collision detection |
| `rigidbody` | Velocity + gravity physics |
| `animator` | Sprite sheet frame animation |
| `sound` | Audio clip playback |
| `camera` | Follows a target entity |
| `tilemap` | Tile-based level rendering |
| `particle` | Particle emitter |

### 22.6 Scene Management

```flow
open GameOver       // end current game scene, go to page
spawn Bullet        // create new entity instance
destroy self        // remove this entity
```

### 22.7 Game Compile Target

The game runtime compiles to:
- **Canvas 2D** (default, maximum compatibility)
- **WebGL** (opt-in, for 3D or performance-heavy games)

---

## 23. Standard Library

### 23.1 Text Operations

```flow
length of name              // number of characters
name in uppercase           // "ALEX"
name in lowercase           // "alex"
trim name                   // remove leading/trailing spaces
name contains Hello         // true/false
split name by space         // list of words
replace Hello with Hi in text
first 5 characters of name
```

### 23.2 Number Operations

```flow
round score                 // nearest integer
floor score
ceiling score
absolute health
clamp speed between 0 and 10
random number               // 0 to 1
random number between 1 and 6
square root of area
power of 2 to 8             // 256
```

### 23.3 List Operations

```flow
add item to myList
remove item from myList
first item in myList
last item in myList
length of myList
myList contains item
sort myList
shuffle myList
reverse myList
filter myList where item > 10
map myList multiply each by 2
```

### 23.4 Time

```flow
wait 2 seconds then
    run doSomething

set now to current time
set today to current date
```

### 23.5 Network

```flow
fetch https://api.example.com/data as response
set data to response as JSON
```

### 23.6 Storage

```flow
save score to local storage
set saved to load score from local storage
clear local storage
```

### 23.7 Math Constants

```flow
Math.PI     // 3.14159...
Math.E      // 2.71828...
```

---

## 24. Package Manager (`fpm`)

### 24.1 Project Manifest (`flow.fmod`)

```flow
package [
    name    = my-app
    version = 1.0.0
    author  = Your Name
    target  = [web, mobile, game]

    dependencies [
        flow-charts = ^2.1.0
        flow-auth   = ^1.0.0
    ]
]
```

### 24.2 CLI Commands

```bash
flow new my-app              # scaffold new project
flow add flow-charts         # install a package
flow remove flow-charts      # uninstall a package
flow build                   # compile to all targets
flow build --web             # compile to HTML/JS only
flow build --mobile          # compile to Flutter
flow build --android         # compile to Compose
flow run                     # dev server + live reload
flow test                    # run test suite
flow publish                 # publish to Flow registry
flow upgrade                 # update all dependencies
```

### 24.3 Project Structure

```
my-app/
├── flow.fmod               # package manifest
├── src/
│   ├── pages/
│   │   ├── Home.flow
│   │   ├── About.flow
│   │   └── Login.flow
│   ├── components/
│   │   ├── Card.flow
│   │   └── Nav.flow
│   ├── game/
│   │   └── Pong.flow
│   ├── styles/
│   │   └── theme.looks
│   └── services/
│       └── api.flow
├── assets/
│   ├── images/
│   ├── sounds/
│   └── fonts/
└── out/
    ├── web/
    ├── android/
    └── ios/
```

---

## 25. Language Server Protocol

The Flow Language Server implements LSP for editor tooling.

### 25.1 Capabilities

| Feature | Description |
|---------|-------------|
| Diagnostics | Real-time error/warning highlights |
| Completion | Keywords, element names, props, variable names |
| Hover | Type info, doc comment, element description |
| Go to Definition | Jump to `page`, `when`, or component declaration |
| Find References | All uses of a variable or handler |
| Rename | Safe rename across all files |
| Format Document | Auto-format on save |
| Code Actions | Quick-fix suggestions |
| Semantic Tokens | Rich syntax highlighting |

### 25.2 Architecture

```
Editor (Flow Studio / VS Code)
         │   LSP JSON-RPC (stdio or TCP)
         ▼
FlowLanguageServer
    ├── DocumentManager     (file watching, incremental sync)
    ├── Lexer               (per-document token cache)
    ├── Parser              (incremental parse on change)
    ├── SymbolTable         (project-wide symbol index)
    ├── TypeChecker         (fast incremental checking)
    ├── CompletionEngine    (context-aware suggestions)
    └── DiagnosticsPublisher
```

---

## 26. Error Diagnostics

### 26.1 Error Format

```
Error [F001] at Home.flow : line 12
  Unknown element 'buton'

    12 |  buton [ text = Click Me ]
             ^^^^^

  Did you mean: button ?
```

### 26.2 Error Code Reference

| Code | Name | Description |
|------|------|-------------|
| F001 | UnknownElement | Unrecognized element name |
| F002 | UndefinedVariable | Variable used before assignment |
| F003 | TypeMismatch | Wrong type for operation |
| F004 | MissingProperty | Required prop not given |
| F005 | UnknownPage | `open` targets a page that does not exist |
| F006 | UnknownHandler | `run` targets a handler that does not exist |
| F007 | CircularRun | Circular `run` chain detected |
| F008 | InvalidEvent | Event handler used in wrong context |
| F009 | DuplicateName | Two things share the same name |
| F010 | CircularImport | Import cycle detected |
| W001 | UnusedVariable | Variable assigned but never read |
| W002 | UnreachableAction | Action after a guaranteed `open` or `return` |
| W003 | ShadowedName | Name shadows an outer scope binding |
| W004 | NullableUsed | Possibly-null variable used without guard |

### 26.3 Levels

| Level | Glyph | Meaning |
|-------|-------|---------|
| Error | ✕ | Prevents compilation |
| Warning | ⚠ | Compiles with notice |
| Info | ℹ | Style / best-practice hint |

---

## 27. Flow Studio IDE

### 27.1 Layout

```
┌───────────────────────────────────────────────────────────────────────────────────┐
│ Flow Studio     Home.flow            ▶ Run   ⬤ Preview   ⚙ Build   ☁ Sync     │
├──────────────┬───────────────────────────────────────┬────────────────────────────┤
│ Explorer     │          Monaco Editor                │  Properties                │
│──────────── │                                       │ ────────────────────────── │
│ 📄 Home      │  page Home                            │ Selected: button           │
│ ├─ 🎨 theme  │                                       │                            │
│ ├─ 📦 Hero   │  section Hero [                        │ id      startBtn           │
│ │  ├─ 📝 H1  │      text.LargeHeading [               │ text    Get Started        │
│ │  └─ 🔘 Btn │          text = Welcome               │ type    start              │
│ ├─ 📦 Cards  │      ]                                │                            │
│ └─ ⚡ Events │      button [                         │ Appearance                 │
│              │          id   = startBtn              │ color   ─────              │
│ 📄 About     │          text = Get Started           │ bg      ██ #4F46E5         │
│ 📄 Login     │          type = start                 │ radius  8                  │
│ 🎮 Pong      │      ]                                │                            │
│              │  ]                                    │ Events                     │
│              │                                       │ onClick open About         │
│              │  when startBtn is clicked             │                            │
│              │      open About                       │ Live Preview               │
│              │                                       │ ┌─────────────────────┐   │
│              │                                       │ │    [Get Started]    │   │
│              │                                       │ └─────────────────────┘   │
├──────────────┼───────────────────────────────────────┤                            │
│ Toolbox      │  Console / Terminal                   │                            │
│ ──────────  │ > flow run                             │                            │
│ 📝 Text      │ Compiled in 84ms ✓                    │                            │
│ 🔘 Button    │ Live at localhost:3000                │                            │
│ 📦 Row       │                                       │                            │
│ 🖼 Image     │                                       │                            │
└──────────────┴───────────────────────────────────────┴────────────────────────────┘
```

### 27.2 Explorer Panel

- Tree view of all pages, components, game scenes, and assets
- File-type icons: 📄 page, 📦 component/section, 🎮 game, 🎨 looks, ⚡ events
- Right-click: New, Rename, Delete, Duplicate, Move
- Drag to reorder; drag file into another to nest imports
- Clicking a node jumps to the declaration in the editor

### 27.3 Monaco Editor

- Full VS Code–grade code editing
- Flow syntax highlighting via TextMate grammar
- IntelliSense driven by the Language Server
- Minimap, breadcrumbs, multi-cursor, column select
- Format on save (Flow formatter)
- Integrated terminal (bottom pane)
- Diff view for package upgrades

### 27.4 Properties Panel

- Context-sensitive: shows selected element's properties
- Fields are editable inline and sync to code in real time
- Sections: Identity, Layout, Appearance, Events, Animation
- Color picker for Color-typed properties
- Live preview thumbnail of the selected element

### 27.5 Toolbox

- Drag-and-drop UI elements into the editor or canvas
- Double-click to insert at cursor
- Sections: Layout, Content, Input, Navigation, Game

### 27.6 Live Preview

- Hot-reload: changes appear within 200ms
- Device frame toggle: Desktop, Tablet, Mobile
- Game preview with Play/Pause/Reset controls
- Inspect mode: hover element to see its Flow source

### 27.7 Additional Panels

| Panel | Description |
|-------|-------------|
| Console | Runtime logs from `print` statements |
| Terminal | Embedded shell for `flow` CLI commands |
| AI Assistant | Inline AI that writes Flow code on request |
| AST Viewer | Live visual tree of the parsed AST |
| Package Manager | Browse, install, and update packages with GUI |
| Theme Manager | Visual editor for `.looks` theme files |
| Asset Manager | Import, preview, and organize images/sounds/fonts |
| Error List | All current errors and warnings, click to jump |

### 27.8 Visual Design

- **Default theme**: Dark mode, indigo accent (`#4F46E5`)
- **Typography**: Inter (UI), Fira Code (editor)
- **Panels**: Glassmorphism with subtle blur on panel headers
- **Animations**: Framer Motion for panel transitions and open/close
- **Dockable**: All panels can be detached, resized, or hidden
- **Tabs**: Multiple files open simultaneously

---

## 28. CLI Reference

```
flow new <name>          Create a new Flow project
flow run                 Start dev server (localhost:3000, hot reload)
flow build               Compile to all configured targets
flow build --web         Web only (HTML/JS)
flow build --react       React only
flow build --mobile      Flutter
flow build --android     Android Compose
flow build --game        Game (Canvas/WebGL)
flow add <package>       Install a package
flow remove <package>    Uninstall a package
flow upgrade             Upgrade all dependencies
flow test                Run all test files
flow test <file>         Run one test file
flow format              Auto-format all .flow and .looks files
flow publish             Publish to Flow package registry
flow doctor              Diagnose project health
flow version             Print Flow version
```

---

## 29. Testing

### 29.1 Test Syntax

Test files use `.flow` extension with `test` top-level blocks:

```flow
test Score System [
    setup [
        score = 0
    ]

    should increase score by 1 [
        change score by 1
        expect score to be 1
    ]

    should not go below zero [
        change score by -999
        expect score to be 0 or score > 0 then pass
    ]
]
```

### 29.2 Assertions

```flow
expect X to be Y
expect X to equal Y
expect X to be greater than Y
expect X to be less than Y
expect X to contain Y
expect myList to have length 3
expect element btn to be visible
expect page to be Home
```

---

## 30. Roadmap

### Phase 1 — Foundation (Months 1–3)
- [ ] Lexer + Parser for `.flow` syntax
- [ ] AST + semantic analysis
- [ ] HTML/CSS/JS backend
- [ ] Basic `flow run` dev server with hot reload
- [ ] Flow Studio v0.1 (Monaco + Explorer)

### Phase 2 — Full Web (Months 4–6)
- [ ] Complete UI element library
- [ ] `.looks` theme system + compiler
- [ ] Reactive state (signal-based)
- [ ] Router (multi-page navigation)
- [ ] Language Server (diagnostics + completion)
- [ ] Package manager (`fpm`) + `flow.fmod`

### Phase 3 — Mobile (Months 7–9)
- [ ] Flutter backend
- [ ] Android Compose backend
- [ ] Mobile live preview in Flow Studio
- [ ] `flow build --mobile` and `--android`

### Phase 4 — Game Engine (Months 10–12)
- [ ] ECS runtime
- [ ] Canvas 2D game backend
- [ ] Physics + AABB collision
- [ ] Sprite animation system
- [ ] Web Audio API wrapper
- [ ] WebGL 3D backend (stretch)

### Phase 5 — Polish & Ecosystem (Months 13–18)
- [ ] Flow package registry (web)
- [ ] AI Assistant in Flow Studio
- [ ] VS Code extension
- [ ] Plugin API for Flow Studio
- [ ] Desktop app target (Electron / Tauri)
- [ ] Flow documentation site
- [ ] Comprehensive test suite for compiler

---

*Flow Language Specification v1.0 — Official reference document.*
*This specification is the source of truth for all compiler, runtime, and tooling implementations.*
