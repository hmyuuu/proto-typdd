// DSL for concise BDD construction using arrow syntax
// Usage: diagram().add("x1 -> x2", "x1 => 1").label("x1", $x_1$).render()

// Parse an edge string like "x1 -> x2" or "x1 => 1"
// Returns (from, to, edge-type)
#let parse-edge(edge-str) = {
  let s = edge-str.trim()

  // Try to find => (high edge)
  if s.contains("=>") {
    let parts = s.split("=>")
    if parts.len() != 2 {
      panic("Invalid edge syntax: " + edge-str)
    }
    return (parts.at(0).trim(), parts.at(1).trim(), "high")
  }

  // Try to find -> (low edge)
  if s.contains("->") {
    let parts = s.split("->")
    if parts.len() != 2 {
      panic("Invalid edge syntax: " + edge-str)
    }
    return (parts.at(0).trim(), parts.at(1).trim(), "low")
  }

  panic("Edge must contain -> or =>: " + edge-str)
}

// Check if a node ID is a terminal (0 or 1)
#let is-terminal-id(id) = {
  id == "0" or id == "1"
}

// Get terminal value from ID
#let terminal-value(id) = {
  if id == "1" { true } else { false }
}

// Build nodes list from edges and labels
#let build-nodes(added-nodes, labels) = {
  let nodes = ()

  for node-id in added-nodes.keys() {
    if is-terminal-id(node-id) {
      nodes.push((id: node-id, terminal: terminal-value(node-id)))
    } else {
      let label = labels.at(node-id, default: node-id)
      nodes.push((id: node-id, label: label))
    }
  }

  nodes
}

// DSL diagram builder - returns state object
#let diagram(labels: (:)) = {
  (
    edges: (),
    labels: labels,
    added-nodes: (:),
  )
}

// Add edges using arrow syntax: "x1 -> x2", "x2 => 1"
#let add(state, ..edge-strs) = {
  let new-state = state

  for edge-str in edge-strs.pos() {
    let (from, to, edge-type) = parse-edge(edge-str)
    new-state.edges.push((from, to, edge-type))

    // Track which nodes we've seen
    new-state.added-nodes.insert(from, true)
    new-state.added-nodes.insert(to, true)
  }

  new-state
}

// Set label for a node: label("x1", $x_1$)
#let label(state, id, lbl) = {
  let new-state = state
  new-state.labels.insert(id, lbl)
  new-state
}

// Set multiple labels: labels(x1: $x_1$, x2: $x_2$)
#let labels(state, ..lbls) = {
  let new-state = state
  for (key, value) in lbls.named() {
    new-state.labels.insert(key, value)
  }
  new-state
}

// Convenience function: put edges into a diagram
// Usage: put(d, "x1 -> x2", "x1 => 1")
#let put(state, ..edge-strs) = {
  add(state, ..edge-strs)
}
