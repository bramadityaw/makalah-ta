#import "var.typ"

= #align(center, var.judul)

#set par(spacing: 1.25em)
#line(length: 100%, stroke: 2pt)
#grid(
  columns: (8.4em, 0.75em, 2fr),
  row-gutter: 0.5em,
  [Nama], [:], var.penulis,
  [NIM], [:], var.nim,
  [Hari/Tanggal], [:], var.tanggal-seminar,
  [Dosen Pembimbing], [:], var.pembimbing,
  [Dosen Moderator], [:], var.penguji,
)
#line(length: 100%, stroke: 2pt)

#{
  set text(weight: "bold")
  grid(
    columns: (2.5fr, 1.5fr),
    row-gutter: 0.5em,
    [Menyetujui], none,
    var.pembimbing + [:], align(bottom, line(length: 100%)),
  )
}
