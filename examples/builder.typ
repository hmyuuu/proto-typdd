#import "../lib.typ": builder, low, high

= Programmatic Builder API

The builder API provides a fluent, chainable interface for constructing BDDs step by step.

== Basic Usage

Here's a simple BDD built using the programmatic API:

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

== Building Step by Step

You can store the builder in a variable and add components incrementally:

#let diagram = builder()

// Add decision nodes
#let diagram = diagram.node("a", $a$)
#let diagram = diagram.node("b", $b$)
#let diagram = diagram.node("c", $c$)

// Add terminal nodes
#let diagram = diagram.terminal("0", false)
#let diagram = diagram.terminal("1", true)

// Add edges
#let diagram = diagram.edge("a", "b", low)
#let diagram = diagram.edge("a", "c", high)
#let diagram = diagram.edge("b", "0", low)
#let diagram = diagram.edge("b", "1", high)
#let diagram = diagram.edge("c", "0", low)
#let diagram = diagram.edge("c", "1", high)

// Render with custom theme
#diagram.render(theme: "colorful")

== Complex Example

Building a more complex BDD with multiple levels:

#builder()
  // Level 0 (root)
  .node("x1", $x_1$)
  // Level 1
  .node("x2a", $x_2$)
  .node("x2b", $x_2$)
  // Level 2
  .node("x3a", $x_3$)
  .node("x3b", $x_3$)
  .node("x3c", $x_3$)
  .node("x3d", $x_3$)
  // Terminals
  .terminal("0", false)
  .terminal("1", true)
  // Edges from x1
  .edge("x1", "x2a", low)
  .edge("x1", "x2b", high)
  // Edges from x2a
  .edge("x2a", "x3a", low)
  .edge("x2a", "x3b", high)
  // Edges from x2b
  .edge("x2b", "x3c", low)
  .edge("x2b", "x3d", high)
  // Edges to terminals
  .edge("x3a", "0", low)
  .edge("x3a", "1", high)
  .edge("x3b", "0", low)
  .edge("x3b", "1", high)
  .edge("x3c", "0", low)
  .edge("x3c", "1", high)
  .edge("x3d", "0", low)
  .edge("x3d", "1", high)
  .render(theme: "minimal")
