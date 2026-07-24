#import "fn.typ": *

= Pendahuluan
Menggunakan bahasa perangkat lunak secara efektif, yang umum maupun yang domain khusus,
memerlukan bantuan yang efektif pula untuk menulis dan memahami bahasa tersebut @barros_editing_2022.
Bantuan tersebut secara konvensional ditawarkan oleh aplikasi _Integrated Development
Environment_ (IDE) yang dapat memahami struktur program dan proyek
yang dikembangkan dalam suatu bahasa secara mendalam dan menyeluruh @bork_language_2023.

Blade adalah bahasa domain khusus _templating_ untuk Laravel @otwell_laravelframework_2025,
_framework_ untuk bahasa pemrograman PHP.
Meskipun bantuan pengembangan untuk Blade seringkali dapat diberikan
oleh Laravel sendiri, terkadang ada kesalahan pengeditan yang tidak dapat dilaporkan secara akurat
oleh Laravel secara bawaan. Bila ada kesalahan sintaks, karena Blade tidak
memahami PHP, Blade langsung meng-_compile view_ dan berharap pengecualian yang dilempar
oleh _interpreter_ PHP dapat dilacak ke berkas Blade awal. Pelaporan kesalahan yang
tidak akurat seperti ini memberikan _DevX_ yang tidak memadai @leander_developer_2025.

Selain itu, ketika menggunakan _component_ Blade, untuk mengetahui antarmuka pemrograman
dari _component_ yang ingin dipakai, pengembang harus beralih dari pekerjaan mereka untuk
membuka dan membaca dokumentasi.
Hal tersebut dapat menyebabkan terjadinya _context switch_ @meyer_software_2014.
_Context switch_ seperti itu menghambat kerja pengembang @cruz_work_2017. Ketidakjelasan
antarmuka pemrograman dan dokumentasi juga berdampak negatif terhadap produktifitas
pengembang @leander_developer_2025 @li_what_2020.

Pengakomodasian _DevX_ diserahkan kepada peralatan bantuan pengeditan pihak ketiga
yang kebanyakan hanya tersedia di aplikasi antarmuka grafis berbayar dan sumber tertutup
yang membatasi akses untuk beberapa kalangan. Karena itu pula, bantuan pengeditan seperti
ini seringkali tidak bisa digunakan di lingkungan yang hanya menyediakan antarmuka tekstual
di dalam terminal, antarmuka yang sampai saat ini masih sering dipakai oleh pengembang @gandhi_lightening_2020.

Untuk mengatasi masalah tersebut, _language server_ untuk Blade bertajuk `blase` dikembangkan.
Penelitian ini berfokus merancang dan mengembangkan _language server_ untuk
bahasa Blade yang didefinisikan di dokumentasi Laravel versi 12.x. Setelah itu, _language server_
diintegrasikan dengan Neovim dan Visual Studio Code, diukur dampaknya terhadap _developer experience_
dan dirilis secara _open source_ melalui GitHub.
Harapannya hasil dari penelitian ini dapat membantu pengembang web Laravel ketika menggunakan Blade,
berkontribusi terhadap literatur penelitian _developer tooling_,
dan berdampak positif terhadap ekosistem bantuan pengeditan kode _open source_.
