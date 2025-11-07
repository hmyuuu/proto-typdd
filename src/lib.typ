// typdd - A Typst package for drawing Binary Decision Diagrams (BDDs)
// and Algebraic Decision Diagrams (ADDs)

#import "@preview/cetz:0.3.1": canvas, draw

#import "utils.typ": merge, get-or, is-terminal, is-decision, validate-edge-type, find-node
#import "themes.typ"
#import "layout.typ"
#import "dsl.typ"

// Draw a decision node (circle)
#let draw-decision-node(id, label, pos, style) = {
  let (x, y) = pos
  draw.circle((x, y), radius: style.radius, fill: style.fill, stroke: style.stroke, name: id)
  draw.content((x, y), text(size: style.text-size, label))
}

// Draw a terminal node (rectangle)
#let draw-terminal-node(id, value, pos, style) = {
  let (x, y) = pos
  let node-style = if value { style.at("true") } else { style.at("false") }

  let width = node-style.width
  let height = node-style.height

  draw.rect(
    (x - width/2, y - height/2),
    (x + width/2, y + height/2),
    fill: node-style.fill,
    stroke: node-style.stroke,
    name: id
  )

  let label-text = if value { "1" } else { "0" }
  draw.content(
    (x, y),
    text(size: node-style.text-size, fill: node-style.at("text-fill", default: black), label-text)
  )
}

// Draw an edge between two nodes
#let draw-edge(from-id, to-id, edge-type, edge-style) = {
  validate-edge-type(edge-type)

  let style = if edge-type == "low" { edge-style.low } else { edge-style.high }

  // Build stroke arguments
  let stroke-args = if "dash" in style and style.dash != none {
    (stroke: style.stroke, dash: style.dash)
  } else {
    (stroke: style.stroke,)
  }

  draw.line(
    (name: from-id),
    (name: to-id),
    mark: style.at("mark", default: none),
    ..stroke-args
  )
}

// Main BDD drawing function (declarative API)
#let bdd(
  nodes: (),
  edges: (),
  pos: none,
  theme: "academic",
  style: none,
  root-id: none,
  width: auto,
  height: auto,
) = {
  // Get base theme
  let base-style = themes.get(theme)

  // Merge custom style if provided
  if style != none {
    base-style = merge(base-style, style)
  }

  // Calculate positions if not provided
  let positions = pos
  if positions == none {
    positions = layout.layout(nodes, edges, spacing: base-style.spacing, root-id: root-id)
  }

  // Draw the diagram
  canvas(length: 1cm, {
    import draw: *

    // Draw nodes first (so they can be referenced by edges)
    for node in nodes {
      let node-pos = positions.at(node.id)

      if is-terminal(node) {
        draw-terminal-node(node.id, node.terminal, node-pos, base-style.terminal)
      } else {
        let label = get-or(node, "label", node.id)
        draw-decision-node(node.id, label, node-pos, base-style.decision)
      }
    }

    // Draw edges (after nodes so they appear on top)
    for edge in edges {
      let (from-id, to-id, edge-type) = edge
      draw-edge(from-id, to-id, edge-type, base-style.edge)
    }
  })
}

// Builder state for programmatic API
#let builder-state = state("typdd-builder", (
  nodes: (),
  edges: (),
))

// Builder API for programmatic construction
#let builder() = {
  let state = (
    nodes: (),
    edges: (),
  )

  // Return object with chainable methods
  (
    // Add a decision node
    node: (self, id, label) => {
      self.nodes.push((id: id, label: label))
      self
    },

    // Add a terminal node
    terminal: (self, id, value) => {
      self.nodes.push((id: id, terminal: value))
      self
    },

    // Add an edge
    edge: (self, from-id, to-id, edge-type) => {
      self.edges.push((from-id, to-id, edge-type))
      self
    },

    // Render the diagram
    render: (self, ..args) => {
      bdd(nodes: self.nodes, edges: self.edges, ..args)
    },

    // Internal state
    nodes: state.nodes,
    edges: state.edges,
  )
}

// Edge type constants for convenience
#let low = "low"
#let high = "high"

// Re-export theme names
#let theme-academic = "academic"
#let theme-colorful = "colorful"
#let theme-minimal = "minimal"

// ===== DSL API =====

// Create a new diagram using DSL
// Usage: diagram().add("x1 -> x2").label("x1", $x_1$).render()
#let diagram(labels: (:)) = {
  dsl.diagram(labels: labels)
}

// Add edges to a DSL diagram using arrow syntax
// Usage: add(d, "x1 -> x2", "x1 => 1")
#let add(state, ..edge-strs) = {
  dsl.add(state, ..edge-strs)
}

// Convenience function: put edges into a diagram (alias for add)
// Usage: put(d, "x1 -> x2", "x1 => 1")
#let put(state, ..edge-strs) = {
  dsl.put(state, ..edge-strs)
}

// Set a single label for a node
// Usage: label(d, "x1", $x_1$)
#let set-label(state, id, lbl) = {
  dsl.label(state, id, lbl)
}

// Set multiple labels for nodes
// Usage: set-labels(d, x1: $x_1$, x2: $x_2$)
#let set-labels(state, ..lbls) = {
  dsl.labels(state, ..lbls)
}

// Render a DSL diagram
// Usage: render(d, theme: "colorful")
#let render(state, ..args) = {
  let nodes = dsl.build-nodes(state.added-nodes, state.labels)
  bdd(nodes: nodes, edges: state.edges, ..args)
}
