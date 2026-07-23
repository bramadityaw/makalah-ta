#import "fn.typ": *

= Hasil dan Pembahasan

== _Problem identification and motivation_
Aktivitas _Problem identification and motivation_ mencakup analisis terhadap
keadaan saat ini dari ekosistem peralatan bantuan Laravel dan Blade.
Hasil analisis menyimpulkan bahwa bantuan pengeditan untuk Blade masih
belum memadai. Sebagian besar _editor_ menyediakan bantuan hanya sebatas pewarnaan sintaks
dan bantuan yang lengkap tidak dapat terjangkau dengan mudah atau
belum mendukung Blade. Masalah utama dapat diidentifikasi sebagai kurangnya alat bantu
untuk Blade yang memenuhi kriteria DevX yang baik dengan akses yang inklusif.

== _Objectives for a solution_
Dari aktivitas sebelumnya, tujuan dari solusi yang dikembangkan dapat dirumuskan sebagai berikut:
+ Membantu pengembang web mengedit _template_ Blade dengan lebih efisien
+ Membantu pengembang web mempelajari basis kode baru yang berisikan _template_ Blade
+ Dapat langsung digunakan oleh pengembang web dengan sesedikit mungkin tahapan

== _Design and development_
Aktivitas ini menjelaskan perancangan dan pengembangan _language server_ yang mampu memenuhi tujuan yang dirumuskan di
aktivitas sebelumnya. Pertama, akan dijelaskan arsitektur terperinci dari _language server_ yang telah dikembangkan.
Kedua, akan dijelaskan tahapan-tahapan pengembangan yang dilakukan untuk fitur-fitur yang membentuk perangkat lunak akhir.

=== Arsitektur Terperinci
Bagian ini memaparkan arsitektur terperinci dari _language server_ yang telah dikembangkan.
@arsi-rinci mengilustrasikan arsitektur tersebut. Secara garis besar, `blase` terdiri dari dua subsistem
yang memiliki batasan jelas: _Server State_ dan _Analysis_. Tiap subsistem berkomunikasi dengan _language client_
melalui fungsi penangan yang menanggapi notifikasi dan _request_ LSP serta memproses tipe data LSP menjadi
tipe data internal subsistem dan sebaliknya.

#figure(
  gambar("arsi-rinci.drawio.pdf", width: auto, height: 16em),
  caption: [Arsitektur terperinci `blase`],
) <arsi-rinci>

Arsitektur tersebut didasarkan pada arsitektur `rust_analyzer` #footnote[http://github.com/rust-lang/rust_analyzer].
`rust_analyzer` dijadikan acuan karena `rust_analyzer` adalah _language server_ yang dikembangkan menggunakan
bahasa Rust secara _open source_, sehingga dapat dipelajari dan diamati langsung.
Selain itu, arsitektur yang berdasarkan fungsi penangan ini memungkinkan
implementasi _Server Infrastructure_ dapat diganti bila dinilai kurang sesuai.

_Server State_ bertanggung jawab untuk memastikan keadaan basis kode dalam memori program sinkron dengan
keadaan di editor kode. Subsistem ini tidak berinteraksi dengan sistem berkas untuk mendapat data kode sumber.
Hal tersebut dikarenakan _language server_ harus dapat memberikan bantuan sesuai dengan keadaan di editor kode,
meskipun berkas yang diminta bantuannya belum tersimpan dalam sistem berkas.

_Analysis_ bertanggung jawab untuk menanggapi kueri terhadap keadaan basis kode yang diurus oleh _Server State_.
Setiap kali _language client_ mengirimkan _request_ LSP yang didukung oleh _language server_, _Analysis_ akan
mengambil cuplikan (_snapshot_) dari keadaan basis kode saat _request_ dikirimkan dan menganalisa keadaan tersebut
untuk menyediakan bantuan bahasa ke editor kode. Cuplikan tersebut tidak bisa diubah (_immutable_) dan hanya bisa dibaca.

=== Pengembangan Awal
Untuk memastikan _language server_ yang dikembangkan dapat dievaluasi secara berkelanjutan, pengembangan _language server_
dilakukan dengan mengadopsi alur kerja iteratif dan inkremental. Pengembangan dimulai dengan membuat suatu
_Minimum Viable Product_ (MVP) di iterasi pertama. MVP ini mengimplementasi beberapa fitur _language server_ secara dangkal,
sehingga bila setelah evaluasi ternyata perlu untuk menulis ulang beberapa modul, hal tersebut dapat dilakukan tanpa
masalah yang berarti.

Tahapan ini menghasilkan _language server_ yang mampu menyinkronkan keadaan basis kode dalam editor
dengan yang ada dalam _language server_ secara inkremental dan dapat melaporkan kesalahan sintaks dalam editor.
@diagnosa-sintaks menunjukkan bagaimana kesalahan sintaks dilaporkan dalam Neovim. Kesalahan sintaks diambil dari
tree-sitter yang menghasilkan _node_ `ERROR` dan `MISSING` ketika menjumpai _token_ yang tidak sesuai dengan _grammar_
_custom_ yang telah terdefinisi.

#figure(
  gambar("diagnosa-sintaks.png", height: 5em, width: auto),
  caption: [Pelaporan kesalahan sintaks di Neovim],
) <diagnosa-sintaks>

Setelah language server dapat digunakan dalam Neovim, ekstensi VS Code pun dikembangkan.
Untuk menggunakan ekstensi ini, pengguna perlu mengunduh berkas _executable_ ke dalam folder
yang terdaftar di variabel lingkungan PATH dan memasang ekstensi secara terpisah.
@diagnosa-sintaks-code menunjukkan bagaimana kesalahan sintaks dilaporkan dalam VS Code.
Ekstensi tersebut kemudian dikemas dan didistribusikan langsung dari _repository_ `blase`
sebagai artefak yang dihasilkan oleh proses _continuous integration_.

#figure(
  gambar("diagnosa-sintaks-code.png", height: 8em, width: auto),
  caption: [Pelaporan kesalahan sintaks di VS Code],
) <diagnosa-sintaks-code>

=== Fitur Inti
#import "@preview/subpar:0.2.2"
#let subfigure = subpar.grid.with(
  supplement: context if text.lang == "id" [Gambar] else { auto },
  align: center + horizon,
)
+ _Go to Definition_

  #subfigure(
    figure(
      gambar("goto-def-req.png"),
      caption: [Meminta letak definisi suatu _component_],
    ),
    <goto-def-a>,

    figure(
      gambar("goto-def-res.png"),
      caption: [_Editor_ membuka berkas yang mendefinisikan _component_],
    ),
    <goto-def-b>,

    caption: [_Go to Definition_],
    columns: (1fr, 1fr),
    label: <goto-def>,
  )

  Fitur ini memungkinkan pengguna untuk menavigasi ke berkas yang mendefinisikan suatu _component_ atau _layout_.
  @goto-def menunjukkan tampilannya di VS Code. @goto-def-a adalah tampilan saat nama _tag_ dari _component_
  diklik-kanan, menunjukkan menu konteks yang menyediakan perintah _Go to Definition_. @goto-def-b adalah
  tampilan dari dokumen yang mendefinisikan _component_ setelah _editor_ membukanya.

+ _Signature Help_

  #figure(gambar("sig-help.png", height: 6em, width: auto), caption: [_Signature Help_]) <sig-help>

  Fitur ini membantu pengguna untuk mengetahui atribut yang diperlukan oleh suatu _component_.
  Suatu _component_ dapat dianggap sebagai fungsi, dengan atribut dalam _tag_ pembuka sebagai argumen bernama.
  Karena argumennya memiliki nama, penting untuk memberikan bantuan yang sesuai dengan nama argumen.
  @sig-help menampilkan atribut _component_ beserta nilai bawaan di antara tanda kutip yang tersorot
  sesuai dengan atribut yang sedang diedit.

+ _Hover_

  Fitur ini memungkinkan pengguna untuk mendapat informasi singkat mengenai suatu _component_ atau _layout_ dengan
  mengambangkan kursor (VS Code) atau mengetik _shortcut_ bantuan (Neovim) diatas nama tag _component_ atau _layout_ tersebut.
  Fitur ini melaporkan lokasi _component_ atau _layout_ dalam basis kode dan dokumentasi _markdown_ yang berada di komentar
  teratas dokumen. @hover menunjukkan bagaimana VS Code menampilkan dokumentasi _markdown_ dari _component_.
  Terlihat bahwa format _markdown_ ditampilkan dengan benar, lengkap dengan pewarnaan sintaks untuk potongan kode.

  #figure(gambar("hover.png", height: 8em, width: auto), caption: [_Hover_]) <hover>

+ _Diagnostic_

  #figure(
    gambar("diagnosa-semantik.png", height: 8em, width: auto),
    caption: [_Component_ tak terdefinisi digarisbawahi merah],
  ) <diagnosa-semantik>

  Selain diagnosa sintaks, _language server_ juga memberikan diagnosa semantik.
  Bila pengguna memakai _component_ dan _layout_ yang tidak terdefinisi dalam template mereka,
  maka _language server_ akan memberitahu melalui _editor_ dengan menggarisbawahi _tag_
  komponen tersebut, yang ditunjukkan di @diagnosa-semantik.
  Setiap _editor_ mendeteksi adanya perubahan isi dokumen, _language server_ akan menjalankan
  kueri tree-sitter untuk elemen yang berawalan x-.

+ _Autocompletion_

  #figure(
    grid(
      column-gutter: 0.5em,
      align: horizon,
      columns: (0.75fr, 0.75fr),
      gambar("cmp-component.png"), gambar("cmp-layout.png"),
    ),

    caption: [_Autocomplete_ untuk _component_ dan _layout_],
  )<cmp-component-layout>

  Fitur ini membantu pengguna saat mengetik penggunaan suatu _directive_, _component_ atau _layout_.
  _Editor_ akan secara berkala mengirim _request_ `textDocument/completion` ke _language server_.
  Setelah itu, daftar saran _autocompletion_ akan tersedia sesuai konteks keberadaan kursor.
  @cmp-component-layout menunjukkan daftar saran _autocomplete_ untuk _component_ dan _layout_.
  Saran dikumpulkan dengan menganalisa _component_ dan _layout_ yang ada di basis kode. Setelah itu,
  akan dicari _component_ atau _layout_ yang bernama mirip dengan teks yang pengguna telah tulis.

  #subfigure(
    figure(
      gambar("cmp-directive-cropped.png"),
      caption: [Daftar saran _autocompletion_ untuk _directive_],
    ),
    <cmp-directive-a>,

    figure(
      gambar("cmp-directive-after.png"),
      caption: [_Snippet_ untuk _directive_ `@if`],
    ),
    <cmp-directive-b>,

    columns: (1.5fr, 1fr),
    caption: [_Autocomplete_ untuk _directive_],
    label: <cmp-directive>,
  )

  Beberapa saran hanya akan muncul setelah mengetik karakter tertentu.
  _Autocompletion_ untuk _directive_ hanya akan muncul setelah pengguna mengetik @, yang ditunjukkan
  oleh @cmp-directive. @cmp-directive-a adalah daftar saran untuk _directive_ yang berawalan i.
  Selain itu, dengan memanfaatkan fitur _snippet_ dari LSP, _language server_ bisa mengirimkan potongan kode penuh
  sesuai dengan saran yang dipilih, sehingga dapat mempercepat pengetikan _template_.
  @cmp-directive-b menampilkan _template_ setelah pengguna menerima saran _autocomplete_.

  #subfigure(
    figure(
      gambar("cmp-directive-ctx.png"),
      caption: [Daftar saran untuk tubuh _directive_ perulangan],
    ),
    <cmp-ctx-directive>,

    figure(
      gambar("cmp-ctx-attr.png"),
      caption: [Daftar saran atribut _directive_ untuk _tag_ HTML tertentu],
    ),
    <cmp-ctx-attr>,

    columns: (1.5fr, 1fr),
    caption: [Saran _autocomplete_ yang tergantung dengan konteks],
    label: <cmp-ctx>,
  )

  Beberapa saran pun hanya muncul saat kursor berada di _node_ pohon sintaks tertentu, seperti di @cmp-ctx.
  // Directives that correspond to control flow keywords for loops such as @break or @continue is
  // only available inside of a loop directive's body such as @while and @for* directives, shown in .
  _Directive_ yang berhubungan dengan kata kunci untuk alir kendali perulangan seperti `@break` atau `@continue`
  hanya tersedia dalam tubuh _directive_ perulangan seperti `@while` dan `@for`, yang ditunjukkan di @cmp-ctx-directive.
  _Directive_ yang berfungsi sebagai atribut _boolean_ pada _tag_ HTML tertentu seperti `@required` atau `readonly`
  hanya tersedia pada elemen ```html <input/>``` atau ```html <option/>```, seperti yang ditunjukkan di @cmp-ctx-attr.

+ _Find References_

  #subpar.grid(
    figure(
      gambar("goto-ref-req.png"),
      caption: [Meminta letak pemakaian suatu _component_],
    ),
    <goto-ref-a>,

    figure(
      gambar("goto-ref-res.png"),
      caption: [_Editor_ memberikan daftar letak pemakaian _component_],
    ),
    <goto-ref-b>,

    caption: [_Go to References_],
    columns: (1fr, 1fr),
    label: <goto-ref>,
    supplement: context if text.lang == "id" [Gambar] else { auto },
  )

  Fitur ini memungkinkan pengguna untuk mencari di mana saja suatu _component_ atau _layout_ dipakai dalam basis kode.
  Fitur ini diimplementasi dengan memanfaatkan kemampuan kueri tree-sitter yang dapat mencari _tag_ dengan pola nama
  tertentu.
  @goto-ref menunjukkan tampilannya di VS Code. @goto-ref-a adalah tampilan saat nama _tag_ dari _component_
  diklik-kanan, menunjukkan menu konteks yang menyediakan perintah _Go to References_. @goto-ref-b adalah
  tampilan dari _editor_ yang menunjukkan daftar letak pemakaian _component_ di seluruh basis kode.

+ _Workspace Symbols_

  #subfigure(
    figure(gambar("goto-symbol.png"), caption: [_Workspace Symbols_ melalui _Command Palette_]),
    <goto-symbol>,
    figure(gambar("goto-symbol-res.png"), caption: [Daftar simbol dengan _substring_ 'app']),
    <goto-symbol-res>,
    columns: (1.25fr, 1fr),
    label: <workspace-symbols>,
    caption: [_Workspace Symbols_],
  )

  Fitur ini memungkinkan pengguna untuk mencari _view_, _component_ atau _layout_ yang tersedia di basis kode.
  @workspace-symbols menunjukkan bagaimana fitur ini tersedia di VS Code.
  Di _editor_ tersebut, fitur ini tersedia melalui perintah '_Go to Symbol in Workspace_' dengan _shortcut_ Ctrl+T.
  @goto-symbol menunjukkan bagaimana perintah tersebut diakses melalui _Command Palette_.
  @goto-symbol-res adalah daftar simbol yang memiliki _substring_ 'app' dalam namanya.

== _Demonstration_
_Language server_ didemonstrasikan kepada pengembang web dengan latar belakang pengalaman yang cukup beragam
melalui konferensi video _one-on-one_. Subyek konferensi video diminta untuk
memasang `blase` ke mesin mereka dan mencobanya dalam editor masing-masing untuk membantu mereka melaksanakan
_task_ dalam sebuah proyek Laravel _dummy_. Setelah sesi demonstrasi selesai, subyek diminta untuk mengisi form
evaluasi pengalaman pengembang yang menjadi poin data aktivitas berikutnya.

== _Evaluation_

=== _White Box Testing_

#figure(gambar("coverage.png", height: 8em, width: auto), caption: [_Code coverage_ untuk modul fitur inti]) <coverage>

@coverage menunjukkan persentase kode program yang dijalankan saat pengujian untuk setiap modul fitur inti.
Sebagian besar mencapai sembilan puluh persen, dengan hampir setengahnya terjalankan penuh sampai seratus persen.
Hal ini berarti setiap skenario pengujian berhasil menguji sebagian besar kemungkinan perilaku dari
setiap fitur inti _language server_.

=== Waktu Respon
#figure(
  [
    #table(
      inset: 0.525em,
      columns: 2,
      table.hline(stroke: 0.5pt + black),
      table.header([Parameter], [Spesifikasi]),
      table.hline(stroke: 0.5pt + black),
      [Sistem Operasi], [Windows 10],
      [Arsitektur], [x86_64],
      [Prosesor], [AMD A4-9125 RADEON R3, 4 COMPUTE CORES 2C+2G 2.30 GHz],
      [RAM], [4,00 GB],
      [Penyimpanan], [119 GB],
      [_Graphics Card_], [AMD Radeon(TM) R3 Graphics (73 MB)],
      table.hline(stroke: 0.5pt + black),
    )
  ],
  caption: [Spesifikasi Mesin Pengukuran],
) <spesifikasi-mesin>

#{
  let headers = (
    ([_Method_],) + ([Intelephense], [_blase_]).map(v => v + [ (_ms_)])
  )

  let medians = (
    "Goto Definition": (5.1, 7.74),
    "Completion": (29.09, 121.27),
    "Goto References": (37.22, 190.75),
    "Workspace Symbols": (62.44, 48.64),
    "Signature Help": (19.145, 7.99),
    "Hover": (56.79, 2.05),
  )
    .pairs()
    .map(median => {
      let (method, values) = median
      (emph(method), ..values.map(n))
    })
    .flatten()

  [#figure(
    [
      #tabel(
        headers: headers,
        columns: headers.len(),
        ..medians,
      )
    ],
    caption: [Perbandingan waktu respon _language server_ serupa],
  ) <banding-respon>]
}

@banding-respon menunjukkan hasil perbandingan median waktu respon language server yang serupa dengan `blase` untuk
dua puluh _request_ per method LSP. Perbandingan dilakukan dengan spesifikasi sesuai yang ditunjukkan
oleh @spesifikasi-mesin, dengan pengaturan kompilasi _release_.
Semua pengukuran dalam milidetik (_ms_).

Mengikuti pedoman #prose(<seow_designing_2008>), mayoritas _request_ oleh _language client_ ditanggapi `blase`
lebih cepat dari _instantaneous_. Tak hanya itu, `blase` pun mampu mengalahkan waktu respon
dari tiga _method_ yang didukung oleh Intelephense, _language server_ yang merupakan alat bantu berbayar
yang dipakai oleh pengembang web profesional. Dari hasil analisis tersebut, dapat disimpulkan bahwa `blase` mampu
bersaing dengan alat bantu berbayar dalam hal daya tanggap.

=== Kuesioner dan Observasi Pengguna

#figure(
  gambar("demografi.png", height: 6em, width: auto),
  caption: [Demografi responden berdasarkan tahun pengalaman],
) <demografi>

@demografi menunjukkan persentase responden berdasarkan berapa lama mereka telah menggunakan Laravel untuk pengembangan web.
Dari situ, dapat diketahui sebagian besar responden memiliki satu sampai tiga tahun pengalaman pengembangan web menggunakan Laravel.
Dapat diketahui pula bahwa ada lebih banyak responden dengan pengalaman lebih dari sepuluh tahun dibanding
yang memiliki tujuh hingga sepuluh.

Di salah satu sesi observasi awal, ditemukan bahwa proses instalasi VS Code yang memisahkan antara
pemasangan ekstensi dengan berkas _executable_ menimbulkan kebingungan yang menghambat penyelesaian tugas.
Responden sibuk mencari lokasi unduh berkas _executable_ dan mengonfigurasi direktori mana yang akan ditambahkan
ke variabel PATH.
Oleh karena itu, ekstensi VS Code diubah agar memakai berkas _executable_ _language server_ yang ditaruh dalam
ekstensi secara langsung. Hal tersebut mempersingkat proses pemasangan ekstensi dan memastikan sesi observasi
berikutnya dapat dengan segera beralih ke penyelesaian tugas.

#figure(
  caption: [Penilaian responden terhadap fitur _language server_],
  {
    import "./fn.typ": split_float
    let headers = ([Fitur], [Rata-Rata Penilaian])
    let rows = (
      "Go to Definition": 4.5,
      "Find References": 4,
      "Hover": 4,
      "Autocomplete": 4,
      "Signature Help": 3,
      "Syntax Highlighting": 3.5,
      "Syntax Errors": 3,
    )
      .pairs()
      .map(pair => {
        let (ft, score) = pair
        let (i, d) = split_float(score)
        let i = int(i)
        let star = "★"
        let half-star = "\u{2BE8}"
        let stars = (star,) * i
        if d != none {
          stars.push(half-star)
        }
        (
          emph(ft),
          grid(
            column-gutter: 1.5em,
            columns: (2.5em, auto),
            stars.join(), [(#score / 5)],
          ),
        )
      })
      .flatten()

    tabel(
      columns: headers.len(),
      headers: headers,
      ..rows,
    )
  },
) <penilaian-fitur>

Setelah observasi, responden diminta untuk mengukur pengalaman mereka dan menilai fitur yang digunakan dengan sistem bintang.
@penilaian-fitur menunjukkan rata-rata bintang yang diberikan responden.
Semua responden merasa proses instalasi `blase` sangat mudah dan pada saat pengerjaan task, tidak ada kesulitan yang
dipersulit oleh `blase`. Rata-rata responden merasa pembuatan _view_ dengan bantuan `blase` lebih baik dibanding tanpa bantuan dan
merasa mungkin untuk menggunakan `blase` untuk membantu pengembangan web sehari-hari.

== _Communication_
Hasil penelitian telah disampaikan kepada audiens ilmiah melalui makalah seminar ini.
Untuk audiens praktis, _language server_ yang telah dikembangkan dapat diakses secara terbuka melalui Github di
https://github.com/bramadityaw/blase.
