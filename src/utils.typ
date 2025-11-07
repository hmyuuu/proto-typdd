// Utility functions for typdd package

// Deep merge two dictionaries, recursively merging nested dictionaries
// Values from b override those in a
#let merge(a, b) = {
  let result = a
  for (key, value) in b {
    if key in result and type(result.at(key)) == dictionary and type(value) == dictionary {
      // Recursively merge nested dictionaries
      result.insert(key, merge(result.at(key), value))
    } else {
      // Override with new value
      result.insert(key, value)
    }
  }
  result
}

// Get a value from a dictionary with a default fallback
#let get-or(dict, key, default) = {
  if key in dict {
    dict.at(key)
  } else {
    default
  }
}

// Check if a value is a terminal node
#let is-terminal(node) = {
  "terminal" in node
}

// Check if a value is a decision node
#let is-decision(node) = {
  not is-terminal(node)
}

// Validate edge type
#let validate-edge-type(edge-type) = {
  if edge-type != "low" and edge-type != "high" {
    panic("Edge type must be 'low' or 'high', got: " + repr(edge-type))
  }
}

// Find node by id in nodes array
#let find-node(nodes, id) = {
  for node in nodes {
    if node.id == id {
      return node
    }
  }
  panic("Node not found: " + repr(id))
}
