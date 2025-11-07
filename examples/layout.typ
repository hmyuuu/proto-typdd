#import "../lib.typ": bdd, low, high

= Automatic Layout Examples

The package automatically positions nodes in a hierarchical layout. You can control spacing and root node.

== Default Auto Layout

By default, nodes are arranged automatically:

#bdd(
  nodes: (
    (id: "x1", label: $x_1$),
    (id: "x2", label: $x_2$),
    (id: "x3", label: $x_3$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x1", "x2", low),
    ("x1", "x3", high),
    ("x2", "0", low),
    ("x2", "1", high),
    ("x3", "0", low),
    ("x3", "1", high),
  )
)

== Custom Spacing

You can adjust vertical and horizontal spacing with the style parameter:

=== Compact
#bdd(
  nodes: (
    (id: "a", label: $a$),
    (id: "b", label: $b$),
    (id: "c", label: $c$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("a", "b", low),
    ("a", "c", high),
    ("b", "0", low),
    ("b", "1", high),
    ("c", "0", low),
    ("c", "1", high),
  ),
  style: (
    spacing: (vertical: 1.2, horizontal: 1.0)
  )
)

=== Spacious
#bdd(
  nodes: (
    (id: "a", label: $a$),
    (id: "b", label: $b$),
    (id: "c", label: $c$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("a", "b", low),
    ("a", "c", high),
    ("b", "0", low),
    ("b", "1", high),
    ("c", "0", low),
    ("c", "1", high),
  ),
  style: (
    spacing: (vertical: 2.5, horizontal: 2.0)
  )
)

== Specifying Root Node

For complex graphs, you may want to specify which node is the root:

#bdd(
  nodes: (
    (id: "root", label: $r$),
    (id: "left", label: $l$),
    (id: "right", label: $r$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("root", "left", low),
    ("root", "right", high),
    ("left", "0", low),
    ("left", "1", high),
    ("right", "0", low),
    ("right", "1", high),
  ),
  root-id: "root"
)

== Wide BDD

Auto-layout handles wide trees gracefully:

#bdd(
  nodes: (
    (id: "x", label: $x$),
    (id: "a", label: $a$),
    (id: "b", label: $b$),
    (id: "c", label: $c$),
    (id: "d", label: $d$),
    (id: "0", terminal: false),
    (id: "1", terminal: true),
  ),
  edges: (
    ("x", "a", low),
    ("x", "b", high),
    ("a", "c", low),
    ("a", "d", high),
    ("b", "c", low),
    ("b", "d", high),
    ("c", "0", low),
    ("c", "1", high),
    ("d", "0", low),
    ("d", "1", high),
  ),
  theme: "colorful"
)
