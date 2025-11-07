#import "@local/typdd:0.1.0": bdd, high, low

= Test: Edge Overlap Prevention

This diagram tests if curved edges properly prevent overlaps.

== Case 1: Complex Routing
This tests edges that might cross:

#bdd(
  nodes: (
    (id: "x1", label: $x_1$),
    (id: "x2a", label: $x_2$),
    (id: "x2b", label: $x_2$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x1", "x2a", low),
    ("x1", "x2b", high),
    ("x2a", "0", low),
    ("x2a", "1", high),
    ("x2b", "0", low),
    ("x2b", "1", high),
  ),
)

== Case 2: Same-Level Nodes
Multiple edges at same level:

#bdd(
  nodes: (
    (id: "root", label: $r$),
    (id: "a", label: $a$),
    (id: "b", label: $b$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("root", "a", low),
    ("root", "b", high),
    ("a", "0", low),
    ("a", "1", high),
    ("b", "0", low),
    ("b", "1", high),
  ),
)
