import 'dart:io';

import 'package:dio/dio.dart';
import 'package:loja_virtual/models/cepaberto_address.dart';

const token = '58b9137227dfb0fd0952e73292215559';

class CepAbertoServices{

  Future<CepAbertoAddress> getAddressFromCep(String cep) async {

    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endpoint = "https://www.cepaberto.com/api/v3/cep?cep=$cleanCep";

    //Criando um header de requisição, para verificação de cotas de requisição;
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';

    try{
      final resposnse = await dio.get<Map<String, dynamic>>(endpoint);
      if(resposnse.data.isEmpty){
        return Future.error('CEP Inválido');
      }

      final CepAbertoAddress address = CepAbertoAddress.fromMap(resposnse.data);
      return address;
    } catch (e){
      return Future.error('Erro ao bsucar CEP');
    }

  }


}