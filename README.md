# Flow Studio IDE

A complete, browser-based visual programming environment for the Flow language with live parser, AST visualization, and multi-target compiler backends.

## Quick Start

### 1. Start the Dev Server

**Windows:**
```bash
npm run dev
```

Or double-click: `start-dev.bat`

The server will start on **http://localhost:3000/**

### 2. Open the IDE

1. Navigate to http://localhost:3000/ in your browser
2. Click "Open Editor" button
3. Start writing Flow code!

## Features

### Code Editor
- **Live Parsing**: Code is parsed as you type
- **Error Display**: Line-numbered error messages
- **Syntax Highlighting**: Dark theme with readable code display
- **Line Numbers**: Easy code navigation

### Visual Explorer
- **AST Tree**: Shows the parsed program structure
- **Click Selection**: Click any element to select and view properties
- **Hierarchy View**: See how your code is organized

### Properties Panel
- **Element Info**: View selected element's type and properties
- **Live Updates**: Properties update as you type

### Preview Pane
- **Live HTML Preview**: See compiled output in real-time
- **Error Feedback**: Shows compile errors if any
- **Interactive**: Test buttons and other interactive elements

## Example Flow Code

```flow
page Home

section Hero [
  text [ text = "Welcome to Flow Studio" ]
  button [ text = "Click Me" ]
]
```

This simple code:
- Creates a page called "Home"
- Adds a section named "Hero"
- Displays a text element and a button
- Automatically renders as HTML in the preview pane

## Compiling to Different Targets

The IDE automatically compiles your Flow code to multiple targets:

### HTML
Generates a complete HTML document with embedded CSS and JavaScript.

### React
Generates a functional React component with hooks for state management.

### Flutter
Generates Dart code using Flutter widgets for mobile apps.

Use the "Build" button in the top bar to view generated code.

## Project Structure

```
app/
├── src/
│   ├── pages/
│   │   ├── Home.jsx          # Landing page
│   │   └── Editor.jsx        # Main IDE
│   ├── components/
│   │   └── editor/
│   │       ├── CodeEditor.jsx      # Code input
│   │       ├── Explorer.jsx        # AST viewer
│   │       ├── PreviewPane.jsx     # HTML preview
│   │       ├── PropertiesPanel.jsx # Properties
│   │       └── TopBar.jsx          # Toolbar
│   └── lib/
│       └── flow/
│           ├── parser.js           # Flow parser
│           ├── lexer.js            # Flow lexer
│           └── backends/
│               ├── html.js         # HTML compiler
│               ├── react.js        # React compiler
│               └── flutter.js      # Flutter compiler
└── vite.config.js            # Vite configuration
```

## Commands

```bash
# Start development server
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run tests
npm test

# Run tests in watch mode
npm test:watch
```

## Flow Language Syntax

### Pages and Sections
```flow
page Home

section Header [
  text [ text = "My App" ]
]

section Content [
  button [ text = "Click Me" ]
]
```

### Text Elements
```flow
text [ text = "Hello World" ]
```

### Buttons
```flow
button [ text = "Submit" ]
```

### Input Fields
```flow
input [ ]
```

### Rows and Columns
```flow
row [
  text [ text = "Left" ]
  text [ text = "Right" ]
]

column [
  text [ text = "Top" ]
  text [ text = "Bottom" ]
]
```

## Keyboard Shortcuts

- **Tab**: Indent code
- **Enter**: New line
- **Ctrl+Z**: Undo (browser native)
- **Ctrl+Y**: Redo (browser native)

## Troubleshooting

### Dev server won't start
- Ensure port 3000 is not in use
- Try killing any existing node processes
- Delete `node_modules` and run `npm install --legacy-peer-deps`

### Editor not loading
- Check browser console (F12) for errors
- Try refreshing the page
- Clear browser cache

### Preview not showing
- Check for errors in the error panel
- Verify Flow code syntax is correct
- Check browser console for JavaScript errors

### Import errors in IDE
- This usually happens after file changes
- The dev server auto-reloads; wait a moment
- Refresh the browser if needed

## Learn More

- **Flow Language Spec**: See `Flow-Spec.md` for complete language documentation
- **Build Summary**: See `BUILD_SUMMARY.md` for implementation details
- **Tests**: Run `npm test` to verify the compiler pipeline

## Architecture

The IDE follows a modular architecture:

1. **Parser** → Converts Flow code to AST
2. **Backends** → Compile AST to HTML/React/Flutter
3. **Editor UI** → Displays code, AST, and preview
4. **React Router** → Routes between Home and Editor pages

The dev server uses Vite for instant hot module reloading, so changes are reflected in real-time.

## Next Steps

1. **Edit Flow code** in the editor
2. **Watch the preview** update in real-time
3. **Click the Build button** to see generated code
4. **Export** your code to HTML, React, or Flutter

Enjoy building with Flow! 🚀
