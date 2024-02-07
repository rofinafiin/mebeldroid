//DIGUNAKAN UNTUK GET ALL DATA
class Datum {
  final int nomorFaktur;
  final String kodeBarang;
  final String namaBarang;
  final int satuan;
  final int hargaSatuan;
  final int subtotal;

  Datum({
    required this.nomorFaktur,
    required this.kodeBarang,
    required this.namaBarang,
    required this.satuan,
    required this.hargaSatuan,
    required this.subtotal,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        nomorFaktur: json["nomor-faktur"],
        kodeBarang: json["kode-barang"],
        namaBarang: json["nama-barang"],
        satuan: json["satuan"],
        hargaSatuan: json["harga-satuan"],
        subtotal: json["subtotal"],
      );

  Map<String, dynamic> toJson() => {
        "nomor-faktur": nomorFaktur,
        "kode-barang": kodeBarang,
        "nama-barang": namaBarang,
        "satuan": satuan,
        "harga-satuan": hargaSatuan,
        "subtotal": subtotal,
      };
}

//DIGUNAKAN UNTUK FORM INPUT
class RequestDelete {
  final int nomorFaktur;

  RequestDelete({
    required this.nomorFaktur,
  });

  factory RequestDelete.fromJson(Map<String, dynamic> json) => RequestDelete(
        nomorFaktur: json["nomor-faktur"],
      );

  Map<String, dynamic> toJson() => {
        "nomor-faktur": nomorFaktur,
      };
}

//DIGUNAKAN UNTUK RESPONSE
class ResponsePost {
  final int code;
  final bool success;
  final String status;
  final String data;

  ResponsePost({
    required this.code,
    required this.success,
    required this.status,
    required this.data,
  });

  factory ResponsePost.fromJson(Map<String, dynamic> json) => ResponsePost(
        code: json["code"],
        success: json["success"],
        status: json["status"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "status": status,
        "data": data,
      };
}

class ResponseDelete {
  final int code;
  final bool success;
  final String status;
  final String data;

  ResponseDelete({
    required this.code,
    required this.success,
    required this.status,
    required this.data,
  });

  factory ResponseDelete.fromJson(Map<String, dynamic> json) => ResponseDelete(
        code: json["code"],
        success: json["success"],
        status: json["status"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "success": success,
        "status": status,
        "data": data,
      };
}
