#let gambar(path, ..args) = {
  image("gambar/" + path, ..args)
}

#let content-to-string(it) = {
  if it.has("text") {
    it.text
  } else if it.has("children") {
    it.children.map(content-to-string).join(" ")
  } else if it.has("body") {
    content-to-string(it.body)
  } else if it == [] {
    " "
  }
}

#let n(num, decimal: ",", thousands: ".") = {
  let parts = str(num).split(".")
  let decimal_part = if parts.len() == 2 { parts.at(1) }
  let integer_part = parts
    .at(0)
    .rev()
    .clusters()
    .enumerate()
    .map(item => {
      let (index, value) = item
      return (
        value
          + if calc.rem(index, 3) == 0 and index != 0 {
            thousands
          }
      )
    })
    .rev()
    .join("")
  return integer_part + if decimal_part != none { decimal + decimal_part }
}

#let tabel(headers: (), columns: 2, ..rows) = {
  table(
    columns: columns,
    inset: 0.525em,
    table.hline(stroke: 0.5pt + black),
    table.header(..headers),
    table.hline(stroke: 0.5pt + black),
    ..rows,
    table.hline(stroke: 0.5pt + black),
  )
}

#let prose = cite.with(form: "prose")

#let tanggal(date) = {
  let months = (
    January: "Januari",
    February: "Februari",
    March: "Maret",
    April: "April",
    May: "Mei",
    June: "Juni",
    July: "Juli",
    August: "Agustus",
    September: "September",
    October: "Oktober",
    November: "November",
    December: "December",
  )

  let month-pat = regex("(January|February|March|April|May|June|July|August|September|October|November|December)")

  let days = (
    Monday: "Senin",
    Tuesday: "Selasa",
    Wednesday: "Rabu",
    Thursday: "Kamis",
    Friday: "Jumat",
    Saturday: "Sabtu",
    Sunday: "Minggu",
  )

  let day-pat = regex("(Monday|Tuesday|Wednesday|Thursday|Friday|Saturday|Sunday)")

  date.replace(month-pat, month => months.at(month.text)).replace(day-pat, day => days.at(day.text))
}
