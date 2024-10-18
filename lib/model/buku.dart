class Buku {
  int? id;
  String? availability;
  String? borrower_name;
  int? due_days;

  Buku({
    this.id,
    this.availability,
    this.borrower_name,
    this.due_days,
  });

  // Factory method untuk membuat objek Buku dari JSON
  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'],
      availability: json['availability'],
      borrower_name: json['borrower_name'],
      due_days: json['due_days'],
    );
  }

  // Metode untuk mengubah objek Buku ke dalam format JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'availability': availability,
      'borrower_name': borrower_name,
      'due_days': due_days,
    };
  }
}
