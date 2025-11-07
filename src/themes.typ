// Theme definitions for typdd package

// Academic theme: clean, professional, black and white with minimal color
#let academic = (
  decision: (
    fill: white,
    stroke: black + 1.5pt,
    radius: 0.4,
    text-size: 11pt,
  ),
  terminal: (
    "false": (
      fill: white,
      stroke: black + 1.5pt,
      width: 0.6,
      height: 0.4,
      text-size: 11pt,
    ),
    "true": (
      fill: black,
      stroke: black + 1.5pt,
      width: 0.6,
      height: 0.4,
      text-size: 11pt,
      text-fill: white,
    ),
  ),
  edge: (
    low: (
      dash: "dotted",
      mark: none,
    ),
    high: (
      dash: none,
      mark: (end: "stealth"),
    ),
  ),
  label: (
    size: 9pt,
    fill: gray,
  ),
  spacing: (
    vertical: 2.0,
    horizontal: 1.5,
  ),
)

// Colorful theme: vibrant colors for better visual distinction
#let colorful = (
  decision: (
    fill: rgb("#E3F2FD"),
    stroke: rgb("#1976D2") + 2pt,
    radius: 0.4,
    text-size: 11pt,
  ),
  terminal: (
    "false": (
      fill: rgb("#FFEBEE"),
      stroke: rgb("#C62828") + 2pt,
      width: 0.6,
      height: 0.4,
      text-size: 11pt,
    ),
    "true": (
      fill: rgb("#4CAF50"),
      stroke: rgb("#2E7D32") + 2pt,
      width: 0.6,
      height: 0.4,
      text-size: 11pt,
      text-fill: white,
    ),
  ),
  edge: (
    low: (
      dash: "dotted",
      mark: none,
    ),
    high: (
      dash: none,
      mark: (end: "stealth"),
    ),
  ),
  label: (
    size: 9pt,
    fill: rgb("#666666"),
  ),
  spacing: (
    vertical: 2.0,
    horizontal: 1.5,
  ),
)

// Minimal theme: clean and simple with subtle styling
#let minimal = (
  decision: (
    fill: rgb("#FAFAFA"),
    stroke: rgb("#424242") + 1pt,
    radius: 0.35,
    text-size: 10pt,
  ),
  terminal: (
    "false": (
      fill: white,
      stroke: rgb("#757575") + 1pt,
      width: 0.5,
      height: 0.35,
      text-size: 10pt,
    ),
    "true": (
      fill: rgb("#616161"),
      stroke: rgb("#424242") + 1pt,
      width: 0.5,
      height: 0.35,
      text-size: 10pt,
      text-fill: white,
    ),
  ),
  edge: (
    low: (
      dash: "dotted",
      mark: none,
    ),
    high: (
      dash: none,
      mark: (end: "stealth"),
    ),
  ),
  label: (
    size: 8pt,
    fill: rgb("#BDBDBD"),
  ),
  spacing: (
    vertical: 1.8,
    horizontal: 1.3,
  ),
)

// Get theme by name
#let get(name) = {
  if name == "academic" {
    academic
  } else if name == "colorful" {
    colorful
  } else if name == "minimal" {
    minimal
  } else {
    panic(
      "Unknown theme: "
        + repr(name)
        + ". Available themes: academic, colorful, minimal",
    )
  }
}
