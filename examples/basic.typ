#import "@local/typdd:0.1.0": bdd, high, low

// Example 1: Simple BDD for function f(x1, x2) = x1 ∧ x2
= Basic BDD Example

This is a simple Binary Decision Diagram representing the Boolean function $f(x_1, x_2) = x_1 and x_2$.

#bdd(
  nodes: (
    (id: "x1", label: $x_1$),
    (id: "x2", label: $x_2$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x1", "0", low), // x1 = 0 → 0
    ("x1", "x2", high), // x1 = 1 → x2
    ("x2", "0", low), // x2 = 0 → 0
    ("x2", "1", high), // x2 = 1 → 1
  ),
)

// Example 2: BDD for function f(x1, x2) = x1 ∨ x2
== OR Function

BDD representing $f(x_1, x_2) = x_1 or x_2$.

#bdd(
  nodes: (
    (id: "x1", label: $x_1$),
    (id: "x2", label: $x_2$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x1", "x2", low), // x1 = 0 → x2
    ("x1", "1", high), // x1 = 1 → 1
    ("x2", "0", low), // x2 = 0 → 0
    ("x2", "1", high), // x2 = 1 → 1
  ),
)

// Example 3: BDD for function f(x1, x2, x3) = (x1 ∧ x2) ∨ x3
== Three Variable Function

BDD for $(x_1 and x_2) or x_3$.

#bdd(
  nodes: (
    (id: "x1", label: $x_1$),
    (id: "x2a", label: $x_2$),
    (id: "x2b", label: $x_2$),
    (id: "x3a", label: $x_3$),
    (id: "x3b", label: $x_3$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x1", "x3a", low),
    ("x1", "x2a", high),
    ("x2a", "x3b", low),
    ("x2a", "1", high),
    ("x3a", "0", low),
    ("x3a", "1", high),
    ("x3b", "0", low),
    ("x3b", "1", high),
  ),
)
