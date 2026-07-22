#import "fn.typ": *

#set enum(
  numbering: "1)",
)

= Lokasi dan Waktu
Penelitian ini dilaksanakan di Sekolah Vokasi IPB _University_ dan
berlangsung dari Oktober 2025 hingga Juli 2026.

#pagebreak()

= Metode
Penelitian ini menggunakan pendekatan Design Science Research (DSR) versi #prose(<peffers_design_2007>).
DSR adalah paradigma penelitian yang menjawab permasalahan yang relevan
bagi manusia melalui penciptaan artefak inovatif, sehingga memberikan
kontribusi pengetahuan baru melalui bukti ilmiah @vom_brocke_introduction_2020.
Fokus DSR adalah meneliti artefak, yaitu segala sesuatu yang dibuat manusia dengan tujuan menyelesaikan masalah
@johannesson_introduction_2021.
@dsr-model menunjukkan metodologi DSR yang terdiri dari enam aktivitas utama:
_Problem identification and motivation_,
_Objectives for a solution_, _Design and development_,
_Demonstration_, _Evaluation_, dan _Communication_.
DSR fleksibel karena dapat dimulai dari empat aktivitas pertama mana saja.
Aktivitas yang dijadikan permulaan disebut _entry point_.
_Entry point_ yang digunakan dalam penelitian ini adalah _Problem-Based Initiation_,
yang dimulai dari aktivitas pertama.

#figure(
  image("./gambar/Peffers1.png", width: auto, height: 12em),
  caption: [Tahapan _Design Science Research Methodology_ @peffers_design_2007],
) <dsr-model>

_Language server_ dievaluasi berdasarkan tiga aspek: kesesuaian pengujian, kecepatan waktu respon, dan dampaknya
terhadap pengalaman pengembang web ketika membuat _view_ Blade. Kesesuaian pengujian diukur dari persentase kode yang
dijalankan saat pengujian berlangsung. Kecepatan waktu respon diukur dari seberapa lama _language client_ mendapat tanggapan
dari _language server_. Dampak terhadap pengalaman pengembang diukur menggunakan serangkaian kuesioner dan observasi langsung
pengembang web ketika membuat _view_.
