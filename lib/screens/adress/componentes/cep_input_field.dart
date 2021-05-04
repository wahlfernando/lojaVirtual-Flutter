import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/common/custon_icon_button.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {

  const CepInputField(this.address);

  final Address address;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final TextEditingController cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    if (widget.address.zipCode == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: '12.345-678',
            ),
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
              //essa linha serve para bloquear ualquer outro tipo de letra ou caracter especial, dai smente da para digitar numeros
              CepInputFormatter()
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if (cep.isEmpty) {
                return 'Campo Obrigatório';
              } else if (cep.length != 10) {
                return 'CEP Inválido';
              } else {
                return null;
              }
            },
          ),
          RaisedButton(
            onPressed: !cartManager.loading ? () async {
                if (Form.of(context).validate()){
                  try{
                    await context.read<CartManager>().getAddress(cepController.text);
                  } catch (e){
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '$e',
                          style: const TextStyle(fontSize: 16),
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
              }
            } : null,
            disabledColor: primaryColor.withAlpha(100),
            color: primaryColor,
            textColor: Colors.white,
            child: cartManager.loading ?
              const CircularProgressIndicator(
                valueColor:AlwaysStoppedAnimation(Colors.white),
              )
              : const Text('Buscar CEP'),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'CEP: ${widget.address.zipCode}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              size: 20,
              onTap: (){
                context.read<CartManager>().removeAddress();
              },
            ),
          ],
        ),
      );
    }
  }
}
