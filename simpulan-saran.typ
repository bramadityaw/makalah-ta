#import "fn.typ": *

= Simpulan dan Saran

Berdasarkan hasil penelitian, dapat disimpulkan bahwa pengembangan _language server_ dengan pendekatan
Design Science Research versi #prose(<peffers_design_2007>) sebagai kerangka kerja berhasil dilaksanakan.
Setiap _method_ LSP terimplementasi sesuai spesifikasi
dan memiliki daya tanggap yang kompetitif dengan _language server_ bahasa serupa.
Hasil dari kuesioner dan observasi langsung pun menunjukkan _developer experience_ yang lebih baik
dibandingkan dengan keadaan sebelum memakai `blase`.

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
