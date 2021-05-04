import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custon_drawer/custon_drawer_header.dart';
import 'package:loja_virtual/common/custon_drawer/drawer_list.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustonDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.blue[100], Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          ListView(
            children: [
              CustonDrawerHeader(),
              const Divider(),
              const DrawerTitle(
                iconData: Icons.home,
                title: 'Início',
                page: 0,
              ),
              const DrawerTitle(
                iconData: Icons.list,
                title: 'Produtos',
                page: 1,
              ),
              const DrawerTitle(
                iconData: Icons.playlist_add_check,
                title: 'Meus Pedidos',
                page: 2,
              ),
              const DrawerTitle(
                iconData: Icons.location_on,
                title: 'Lojas',
                page: 3,
              ),
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled) {
                    return Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                         const Divider(),
                         const DrawerTitle(
                          iconData: Icons.settings,
                          title: 'Usuários',
                          page: 4,
                        ),
                         const DrawerTitle(
                          iconData: Icons.settings,
                          title: 'Pedidos',
                          page: 5,
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
