#import "fn.typ": *

= Simpulan dan Saran

Berdasarkan hasil penelitian, dapat disimpulkan bahwa pengembangan _language server_ dengan pendekatan
Design Science Research sebagai kerangka kerja berhasil dilaksanakan. Melalui penerapan Design Science Research (DSR)
versi #prose(<peffers_design_2007>), penelitian ini berhasil mengembangkan _language server_ yang mampu mencari
lokasi komponen dan _layout_ dalam _workspace_, melompat ke file yang mendefinisikan komponen dan _layout_
serta tempat penggunaan, menyajikan dokumentasi komponen dan _layout_ langsung di editor, melaporkan kesalahan
saat pengeditan, menyediakan saran _auto-complete_, dan memberi informasi atribut yang disediakan oleh suatu komponen.
Hasil pengujian _white box_ mengonfirmasi bahwa setiap _method_ LSP terimplementasi sesuai spesifikasi.
Daya tanggapnya pun kompetitif dengan _language server_ bahasa serupa.

Hasil penelitian ini menghasilkan beberapa saran yang dapat dijadikan
pertimbangan untuk pengembangan selanjutnya, yaitu:

+ Penggunaan tree-sitter sebagai _parser_ mengakibatkan laporan kesalahan sintaks
  yang dihasilkan kurang informatif, sehingga subyek kesusahan mengerjakan tugas dalam basis kode _dummy_.
  Pengembangan selanjutnya dapat menggunakan _parser_
  PHP kustom yang dimodifikasi untuk menangani HTML dan _directive_ Blade yang dapat
  menghasilkan laporan kesalahan sintaks yang lebih akurat dan informatif.
+ Dikarenakan _blase_ khusus menyediakan bantuan untuk Blade, bantuan untuk
  PHP yang berada dalam _directive_ dan atribut selain pelaporan kesalahan sintaks
  tidak tersedia. Untuk pengembangan selanjutnya, _blase_ dapat dijadikan modul dalam
  language server PHP yang dapat menyediakan bantuan lebih lengkap kepada pengguna.
