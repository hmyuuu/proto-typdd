# typdd

A Typst package for drawing Binary Decision Diagrams (BDDs) and Algebraic Decision Diagrams (ADDs) using [CeTZ](https://github.com/cetz-package/cetz).

## Features

- **Three API Styles**: Declarative, Programmatic, and DSL (arrow syntax)
- **Automatic Layout**: Hierarchical positioning with customizable spacing
- **Multiple Themes**: Academic, Colorful, and Minimal built-in themes
- **Highly Customizable**: Override colors, sizes, shapes, and more
- **Clean Output**: Professional diagrams suitable for papers and presentations

## Quick Start

### DSL API (Recommended for Simplicity)

The fastest way to create a BDD using arrow syntax:

```typst
#import "@local/typdd:0.1.0": diagram, put, render, set-labels

#let d = diagram(labels: (x1: $x_1$, x2: $x_2$))
#let d = put(d, "x1 -> 0", "x1 => x2", "x2 -> 0", "x2 => 1")
#render(d)
```

Where:

- `->` means low edge (variable = 0, dotted line)
- `=>` means high edge (variable = 1, solid arrow)

### Declarative API

Define BDDs using data structures:

```typst
#import "@local/typdd:0.1.0": bdd, low, high

#bdd(
  nodes: (
    (id: "x1", label: $x_1$),
    (id: "x2", label: $x_2$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x1", "0", low),
    ("x1", "x2", high),
    ("x2", "0", low),
    ("x2", "1", high),
  )
)
```

This creates a BDD representing the Boolean function `f(x₁, x₂) = x₁ ∧ x₂`.

## API Reference

### Declarative API

The declarative API uses the `bdd()` function with data structures:

```typst
#bdd(
  nodes: array,      // Array of node definitions
  edges: array,      // Array of edge definitions
  pos: dictionary,   // Optional: manual node positions
  theme: string,     // Optional: theme name (default: "academic")
  style: dictionary, // Optional: style overrides
  root-id: string,   // Optional: specify root node for layout
)
```

#### Node Definition

**Decision Node:**

```typst
(id: "node-id", label: $x$)
```

**Terminal Node:**

```typst
(id: "node-id", terminal: true)   // For "1" terminal
(id: "node-id", terminal: false)  // For "0" terminal
```

#### Edge Definition

```typst
("from-id", "to-id", edge-type)
```

Where `edge-type` is either `low` (dotted line) or `high` (solid arrow).

### Programmatic API

Build BDDs step-by-step using the builder pattern:

```typst
#import "@local/typdd:0.1.0": builder, low, high

#builder()
  .node("x1", $x_1$)
  .node("x2", $x_2$)
  .terminal("0", false)
  .terminal("1", true)
  .edge("x1", "0", low)
  .edge("x1", "x2", high)
  .edge("x2", "0", low)
  .edge("x2", "1", high)
  .render()
```

#### Builder Methods

- `.node(id, label)` - Add a decision node
- `.terminal(id, value)` - Add a terminal node (value: true or false)
- `.edge(from, to, type)` - Add an edge (type: low or high)
- `.render(..args)` - Render the diagram (accepts same args as `bdd()`)

### DSL API (Arrow Syntax)

The DSL provides the most concise syntax using arrow operators:

- `->` for **low edges** (dotted line, variable = 0)
- `=>` for **high edges** (solid arrow, variable = 1)

```typst
#import "@local/typdd:0.1.0": diagram, put, render, set-labels

#let d = diagram(labels: (x1: $x_1$, x2: $x_2$))
#let d = put(d,
  "x1 -> 0", "x1 => x2",
  "x2 -> 0", "x2 => 1"
)
#render(d)
```

This is the **shortest** way to create BDDs - about 50% less code than the declarative API!

#### DSL Functions

- `diagram(labels: dict)` - Create a new diagram (optionally with predefined labels)
- `put(state, ..edges)` - Add edges using arrow syntax strings
- `add(state, ..edges)` - Alias for `put()`
- `set-label(state, id, label)` - Set a single node label
- `set-labels(state, ..labels)` - Set multiple node labels
- `render(state, ..args)` - Render the diagram (accepts same args as `bdd()`)

#### DSL Edge Syntax

Edges are defined as strings with arrows:

```typst
"x1 -> x2"    // Low edge from x1 to x2
"x1 => 1"     // High edge from x1 to terminal 1
"x2 -> 0"     // Low edge from x2 to terminal 0
```

You can add multiple edges in one call:

```typst
#let d = put(d, "x1 -> x2", "x1 => 1", "x2 -> 0", "x2 => 1")
```

Terminals (0 and 1) are automatically recognized and created.

## Themes

Three built-in themes are available:

### Academic (default)

Professional black and white theme, ideal for papers and formal documents.

```typst
#bdd(..., theme: "academic")
```

### Colorful

Vibrant colors with blue decision nodes and red/green terminals.

```typst
#bdd(..., theme: "colorful")
```

### Minimal

Clean and subtle gray tones for a modern aesthetic.

```typst
#bdd(..., theme: "minimal")
```

## Customization

### Custom Styles

Override specific style properties while using a theme:

```typst
#bdd(
  nodes: (...),
  edges: (...),
  theme: "academic",
  style: (
    decision: (
      fill: blue.lighten(80%),
      stroke: blue + 2pt,
      radius: 0.5,
      text-size: 12pt,
    ),
    terminal: (
      true: (
        fill: green,
        text-fill: white,
      ),
    ),
    edge: (
      high: (
        stroke: blue + 1.5pt,
      ),
    ),
    spacing: (
      vertical: 2.5,
      horizontal: 2.0,
    )
  )
)
```

### Style Properties

**Decision Nodes:**

- `fill`: Background color
- `stroke`: Border style
- `radius`: Circle radius
- `text-size`: Label text size

**Terminal Nodes:**

- `true` / `false`: Separate styles for each terminal type
  - `fill`: Background color
  - `stroke`: Border style
  - `width`: Rectangle width
  - `height`: Rectangle height
  - `text-size`: Label text size
  - `text-fill`: Text color

**Edges:**

- `low` / `high`: Separate styles for each edge type
  - `stroke`: Line style and color
  - `dash`: Line dash pattern (e.g., "dotted", "dashed")
  - `mark`: Arrow marker configuration

**Spacing:**

- `vertical`: Vertical distance between levels
- `horizontal`: Horizontal distance between nodes

### Manual Positioning

Specify exact coordinates for nodes:

```typst
#bdd(
  nodes: (...),
  edges: (...),
  pos: (
    x1: (0, 0),
    x2: (-1.5, -2),
    x3: (1.5, -2),
    "0": (0, -4),
    "1": (0, -5),
  )
)
```

## Examples

The `examples/` directory contains comprehensive examples:

- **basic.typ**: Simple BDD examples for common Boolean functions
- **declarative.typ**: Declarative API usage with themes
- **builder.typ**: Programmatic API demonstrations
- **dsl.typ**: DSL API with arrow syntax - the most concise approach
- **layout.typ**: Automatic layout with custom spacing
- **styling.typ**: Custom styling examples
- **themes.typ**: Theme comparison showcase

## BDD Conventions

The package follows standard BDD conventions:

- **Low edges** (variable = 0): Dotted lines
- **High edges** (variable = 1): Solid lines with arrows
- **Terminal nodes**: Rectangles labeled "0" (false) or "1" (true)
- **Decision nodes**: Circles with variable labels
- **Layout**: Top-to-bottom hierarchical structure
