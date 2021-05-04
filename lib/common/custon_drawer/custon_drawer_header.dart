import 'package:flutter/material.dart';
import 'package:loja_virtual/models/page_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustonDrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
      height: 180,
      child: Consumer<UserManager>(
        builder: (_,userManager,__) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              //cllocar um Row om o text abaixo para colocar uma imagem ao lado do noma da loja
              const Text(
                'BuyAndSell',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Text(
                'Olá, ${userManager.user?.name ?? ''}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                 ),
              ),
              //Botão feito de GestureDetector
              GestureDetector(
                onTap: (){
                  if(userManager.isLoggedIn){
                    context.read<PageManager>().setPage(0);
                    userManager.singOut();
                  } else{
                    Navigator.of(context).pushNamed('/login');
                  }
                },
                child: Text(userManager.isLoggedIn
                    ? 'Sair'
                    : 'Entre ou Cadastre-se >',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
