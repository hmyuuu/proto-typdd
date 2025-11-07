// Layout algorithms for automatic node positioning

#import "utils.typ": find-node

// Compute the level (depth) of each node in the BDD
// Returns a dictionary mapping node IDs to their level (0 = root)
#let compute-levels(nodes, edges, root-id: none) = {
  let levels = (:)

  // Find root node (node with no incoming edges) if not specified
  let root = root-id
  if root == none {
    let targets = edges.map(e => e.at(1))
    for node in nodes {
      if node.id not in targets {
        root = node.id
        break
      }
    }
  }

  if root == none {
    panic("Could not find root node. Please specify root-id explicitly.")
  }

  // BFS to assign levels
  let queue = ((root, 0),)
  let visited = (root,)

  while queue.len() > 0 {
    let (node-id, level) = queue.remove(0)
    levels.insert(node-id, level)

    // Find outgoing edges
    for edge in edges {
      if edge.at(0) == node-id {
        let target = edge.at(1)
        if target not in visited {
          visited.push(target)
          queue.push((target, level + 1))
        } else {
          // Update level to maximum depth if already visited
          let current-level = levels.at(target, default: 0)
          if level + 1 > current-level {
            levels.insert(target, level + 1)
          }
        }
      }
    }
  }

  // Assign remaining nodes (disconnected) to level 0
  for node in nodes {
    if node.id not in levels {
      levels.insert(node.id, 0)
    }
  }

  levels
}

// Group nodes by their level
#let group-by-level(nodes, levels) = {
  let max-level = 0
  for (_, level) in levels {
    if level > max-level {
      max-level = level
    }
  }

  let groups = range(max-level + 1).map(_ => ())

  for node in nodes {
    let level = levels.at(node.id)
    groups.at(level).push(node)
  }

  groups
}

// Calculate horizontal positions for nodes at each level
// Returns a dictionary mapping node IDs to (x, y) coordinates
#let calculate-positions(nodes, edges, spacing, root-id: none) = {
  let levels = compute-levels(nodes, edges, root-id: root-id)
  let groups = group-by-level(nodes, levels)

  let positions = (:)
  let v-spacing = spacing.vertical
  let h-spacing = spacing.horizontal

  for (level, level-nodes) in groups.enumerate() {
    let y = -level * v-spacing
    let count = level-nodes.len()

    for (i, node) in level-nodes.enumerate() {
      // Center nodes horizontally at each level
      let x = (i - (count - 1) / 2.0) * h-spacing
      positions.insert(node.id, (x, y))
    }
  }

  positions
}

// Automatic layout algorithm
// Takes nodes, edges, and spacing parameters
// Returns position dictionary
#let layout(nodes, edges, spacing: (vertical: 2.0, horizontal: 1.5), root-id: none) = {
  calculate-positions(nodes, edges, spacing, root-id: root-id)
}
