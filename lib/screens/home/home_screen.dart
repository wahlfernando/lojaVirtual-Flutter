import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custon_drawer/custon_drawer.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:loja_virtual/screens/home/components/add_section_widget.dart';
import 'package:loja_virtual/screens/home/components/section_list.dart';
import 'package:loja_virtual/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustonDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 102, 178, 255),
                Color.fromARGB(255, 204, 229, 255),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          CustomScrollView( // inicio da customização do menu dos 3 pontinhos
            //se usar um SliverToBoxAdapter ele tranforma qualquer widget em um sliver
            slivers: [
              //somente pode passar widgtes do tipo sliver
              SliverAppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                snap: true,
                floating: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: const FlexibleSpaceBar(
                  //espaço que ocupa a appBar
                  title: Text('BuyAndSell', style: TextStyle(color: Colors.white)),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),
                  Consumer2<UserManager, HomeManager>(
                    builder: (_, userManager, homeManager,  __){
                      if(userManager.adminEnabled && !homeManager.loading){
                        if(homeManager.editing){
                          return PopupMenuButton(
                            onSelected: (e){
                              if(e == 'Salvar'){
                                homeManager.saveEditing();
                              } else {
                                homeManager.discartEditing();
                              }
                            },
                              itemBuilder: (_){
                                return ['Salvar', 'Descartar'].map((e) {
                                  return PopupMenuItem(
                                    value: e,
                                      child: Text(e),
                                  );
                                }).toList();
                              },
                          );
                        } else{
                          return IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: homeManager.enterEditing,
                          );
                        }
                      } else {
                       return Container();
                      }
                    },
                  ),
                ],
              ),  // FIM da customização do menu dos 3 pontinhos
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {
                  if(homeManager.loading){  //estamso dentro de um sliver, tem que passar slivers para colocar um widget comum
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                        backgroundColor: Colors.transparent,
                      ),
                    );
                  }
                  final List<Widget> children =
                      homeManager.sections.map<Widget>((section) {
                        switch(section.type){
                          case 'List':
                            return SectionList(section);
                          case 'Staggered':
                            return SectionStaggered(section);
                          default:
                            return Container();
                        }
                      }).toList();
                  if(homeManager.editing){
                    children.add(AddSectionWidget(homeManager,));
                  }
                  return SliverList(
                    delegate: SliverChildListDelegate(children),
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
