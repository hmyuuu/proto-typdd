// typdd - A Typst package for drawing Binary Decision Diagrams (BDDs)
// and Algebraic Decision Diagrams (ADDs)

#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#import "utils.typ": merge, get-or, is-terminal, is-decision, validate-edge-type, find-node
#import "themes.typ"
#import "layout.typ"
#import "dsl.typ"

// Helper: Check if a point is near a line segment
#let point-near-line(point, line-start, line-end, threshold: 0.5) = {
  let (px, py) = point
  let (x1, y1) = line-start
  let (x2, y2) = line-end

  // Vector from start to end
  let dx = x2 - x1
  let dy = y2 - y1
  let len-sq = dx * dx + dy * dy

  if len-sq == 0 {
    // Start and end are the same point
    return calc.sqrt((px - x1) * (px - x1) + (py - y1) * (py - y1)) < threshold
  }

  // Project point onto line segment (clamp t to [0, 1])
  let t = calc.max(0, calc.min(1, ((px - x1) * dx + (py - y1) * dy) / len-sq))

  // Find closest point on line segment
  let closest-x = x1 + t * dx
  let closest-y = y1 + t * dy

  // Calculate distance
  let dist = calc.sqrt((px - closest-x) * (px - closest-x) + (py - closest-y) * (py - closest-y))

  dist < threshold
}

// Helper: Calculate bend angle for edges to prevent overlaps
#let calculate-bend-angle(from-id, to-id, edge-type, all-edges, positions, nodes) = {
  let from-pos = positions.at(from-id)
  let to-pos = positions.at(to-id)
  let (fx, fy) = from-pos
  let (tx, ty) = to-pos

  // Check if there's a reverse edge (creates bidirectional connection)
  let has-reverse = all-edges.any(e => e.at(0) == to-id and e.at(1) == from-id)

  // Base bend for bidirectional edges
  let base-bend = if has-reverse {
    if edge-type == "high" { 25deg } else { -25deg }
  } else {
    0deg
  }

  // Check for intermediate nodes that might be in the path
  let needs-extra-bend = false
  for node in nodes {
    // Skip source and target nodes
    if node.id == from-id or node.id == to-id {
      continue
    }

    let node-pos = positions.at(node.id)

    // Check if this node is near the edge path
    if point-near-line(node-pos, from-pos, to-pos, threshold: 0.6) {
      needs-extra-bend = true
      break
    }
  }

  // Apply additional bend if needed to avoid intermediate nodes
  if needs-extra-bend {
    // Determine bend direction based on edge direction and type
    let horizontal-dir = if tx > fx { 1 } else { -1 }
    let additional-bend = if edge-type == "high" {
      horizontal-dir * 20deg
    } else {
      -horizontal-dir * 20deg
    }
    base-bend + additional-bend
  } else {
    base-bend
  }
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

  // Draw the diagram using Fletcher's API directly
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: (base-style.spacing.horizontal * 1cm, base-style.spacing.vertical * 1cm),
    {
      // Draw nodes using Fletcher's node() function directly
      for n in nodes {
        let node-pos = positions.at(n.id)
        let (x, y) = node-pos

        if is-terminal(n) {
          // Terminal node (rectangle)
          let is-true = n.terminal
          let node-style = if is-true {
            base-style.terminal.at("true")
          } else {
            base-style.terminal.at("false")
          }
          let label-text = if is-true { "1" } else { "0" }
          let text-fill = node-style.at("text-fill", default: black)

          node(
            (x, y),
            text(size: node-style.text-size, fill: text-fill, label-text),
            shape: rect,
            width: node-style.width,
            height: node-style.height,
            fill: node-style.fill,
            stroke: node-style.stroke,
            name: label(n.id)
          )
        } else {
          // Decision node (circle)
          let node-label = get-or(n, "label", n.id)
          node(
            (x, y),
            text(size: base-style.decision.text-size, node-label),
            shape: fletcher.shapes.circle,
            radius: base-style.decision.radius,
            fill: base-style.decision.fill,
            stroke: base-style.decision.stroke,
            name: label(n.id)
          )
        }
      }

      // Draw edges using Fletcher's edge() function directly
      for edge-data in edges {
        let (from-id, to-id, edge-type) = edge-data
        validate-edge-type(edge-type)

        // Calculate bend angle to prevent overlaps
        let bend = calculate-bend-angle(from-id, to-id, edge-type, edges, positions, nodes)

        // Follow Fletcher's exact pattern:
        // High edge: edge(<from>, <to>, "->")
        // Low edge: edge(<from>, <to>, "-", stroke: (dash: "dotted"))
        if edge-type == "high" {
          edge(label(from-id), label(to-id), "->", bend: bend)
        } else {
          edge(label(from-id), label(to-id), "-", stroke: (dash: "dotted"), bend: bend)
        }
      }
    }
  )
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
