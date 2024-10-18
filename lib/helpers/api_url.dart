class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id'; // ip responsi
  static const String baseUrlBuku = baseUrl + '/api/buku';

  // URL untuk registrasi dan login
  static const String registrasi = baseUrl + '/api/registrasi';
  static const String login = baseUrl + '/api/login';

  // URL untuk daftar buku (status buku)
  static const String listBuku = baseUrlBuku + '/status'; // Endpoint status buku
  static const String create = baseUrlBuku + '/status'; // Endpoint untuk membuat status baru

  // Mengambil, mengupdate, dan menghapus status buku berdasarkan ID buku
  static String update(int id) {
    return baseUrlBuku + '/status/' + id.toString() + '/update'; // Update status buku
  }

  static String show(int id) {
    return baseUrlBuku + '/status/' + id.toString(); // Menampilkan status buku
  }

  static String delete(int id) {
    return baseUrlBuku + '/status/' + id.toString() + '/delete'; // Menghapus status buku
  }
}
