import 'package:contact_dio/model/transaksi_model.dart';
import 'package:contact_dio/model/login_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl = 'http://10.200.4.7:3000';

  Future<Iterable<Datum>?> getAllTransaksi() async {
    try {
      var response = await dio.get('$_baseUrl/mst/data');
      if (response.statusCode == 200) {
        final contactList = (response.data['data'] as List)
            .map((contact) => Datum.fromJson(contact))
            .toList();

        return contactList;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint(
            'Client error - the request contains bad syntax or cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Datum?> getSingleTransaksi(int id) async {
    try {
      var response = await dio.get('$_baseUrl/mst/byid/$id');
      debugPrint(id.toString());
      if (response.statusCode == 200) {
        final data = response.data['data'];
        debugPrint(data.toString());
        return Datum.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponsePost?> postTransaksi(Datum ct) async {
    try {
      debugPrint(ct.toString());
      final response = await dio.post(
        '$_baseUrl/mst/insert',
        data: ct.toJson(),
      );
      if (response.statusCode == 200) {
        return ResponsePost.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<ResponsePost?> UpdateTransaksi(String id, Datum ct) async {
    try {
      final response = await Dio().put(
        '$_baseUrl/mst/update',
        data: ct.toJson(),
      );
      if (response.statusCode == 200) {
        return ResponsePost.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteTransaksi(String id) async {
    try {
      final response = await Dio().delete('$_baseUrl/mst/delete/$id');
      if (response.statusCode == 200) {
        return ResponseDelete.fromJson(response.data);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await dio.post(
        '$_baseUrl/login',
        data: login.toJson(),
      );
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return LoginResponse.fromJson(e.response!.data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
