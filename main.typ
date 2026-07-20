#import "var.typ"
#import "fn.typ"

#set document(
  title: var.judul,
  author: var.penulis,
)
#set page(
  paper: "a4",
)
#set text(
  font: "Times New Roman",
  size: 12pt,
  lang: "id",
  spacing: 0.15em,
)
#show raw: set text(font: "Courier New")
#set par(
  justify: true,
  first-line-indent: (
    amount: 1cm,
    all: true,
  ),
  spacing: 0.5em,
  leading: 0.5em,
)

#show figure: set par(spacing: 1.5em)
#set figure.caption(separator: h(0.125em))
#set heading(numbering: "1.1.1")
#show heading: it => {
  set par(
    justify: false,
    first-line-indent: (
      amount: 0cm,
      all: true,
    ),
  )
  set text(12pt)
  let text-weight = if it.level >= 2 { "regular" } else { "bold" }
  if it.level >= 2 {
    text(
      weight: text-weight,
      numbering("1.1", ..counter(heading).get()),
    )

    box(width: 1em)
  }
  let body = if it.level == 1 { upper(it.body) } else { it.body }
  text(weight: text-weight, body)
  v(0.5em)
}
#set enum(
  numbering: "a.",
  indent: 0em,
  body-indent: 1.5em,
)

#set list(
  indent: 0em,
  body-indent: 2em,
)

#show figure.where(kind: table): it => {
  set figure(gap: 3pt)
  set par(justify: true, first-line-indent: 0em, spacing: 3pt)
  show par: set align(left)
  set table(
    stroke: (x: none, y: none),
  )
  show table.cell: it => {
    set text(size: 11pt)
    if it.y > 0 {
      align(left, it)
    } else {
      align(center, strong(it))
    }
  }
  set figure.caption(position: top)
  it
}

// Bagian Utama
#for section in ("kop", "pendahuluan", "metode", "hasil-pembahasan", "simpulan-saran") {
  counter(heading).update(0)
  include section + ".typ"
}

#show bibliography: it => {
  set block(width: 100%)
  show heading: it => [
    #set text(14pt)
    #align(center, upper(it.body))
    #v(1.5em)
  ]
  it
}

// Bagian Akhir
#bibliography("ref.bib", style: "ipb.csl")
