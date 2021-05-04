// aqui ele vai mostrar os campos para preencher os dados de entrega, depois de ter buscado o cep

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/address.dart';
import 'package:loja_virtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    //craindo o validador com a verificação.
    String emptyValidator(String text) => text.isEmpty ? 'Campo Obrigatório' : null;

    if (address.zipCode != null && cartManager.deliveryPrice == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.street,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua / Avenida',
              hintText: 'Av. Brasil',
            ),
            validator: emptyValidator,
            onSaved: (t) => address.street = t,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Número',
                    hintText: '123',
                  ),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: emptyValidator,
                  onSaved: (t) => address.number = t,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                  ),
                  onSaved: (t) => address.complement = t,
                ),
              ),
            ],
          ),
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.district,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Bairro',
              hintText: 'Centro',
            ),
            validator: emptyValidator,
            onSaved: (t) => address.district = t,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  enabled: false,
                  initialValue: address.city,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Cidade',
                    hintText: 'União da Vitória',
                  ),
                  validator: emptyValidator,
                  onSaved: (t) => address.city = t,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'PR',
                    counterText: '',
                  ),
                  maxLength: 2,
                  validator: (e) {
                    if (e.isEmpty) {
                      return 'Campo Obrigatório';
                    } else if (e.length != 2) {
                      return 'Inválido';
                    }
                    return null;
                  },
                  onSaved: (t) => address.state = t,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          RaisedButton(
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
            textColor: Colors.white,
            onPressed: !cartManager.loading ? () async {
              if (Form.of(context).validate()) {
                Form.of(context).save();
                try {
                  await context.read<CartManager>().setAddress(address);
                } catch (e) {
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
            child: cartManager.loading
              ? const CircularProgressIndicator(
                  valueColor:AlwaysStoppedAnimation(Colors.white),
                )
              : const Text('Calcular Frete'),
          ),
        ],
      );
    } else if (address.zipCode != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child:
            Text('${address.street}, ${address.number}\n${address.district}\n'
                '${address.city} - ${address.state}'),
      );
    } else {
      return Container();
    }
  }
}
