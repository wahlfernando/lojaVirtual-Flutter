import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custon_drawer/custon_drawer.dart';
import 'package:loja_virtual/common/custon_icon_button.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/order/order_tile.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:loja_virtual/models/order.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AdminOrdersScreen extends StatefulWidget {
  @override
  _AdminOrdersScreenState createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = const BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    );

    final PanelController panelController = PanelController();
    bool marcarTodos = false;

    return Scaffold(
      drawer: CustonDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos',
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __) {
          final filteredOrders = ordersManager.filteredOrders;

          return SlidingUpPanel(
            controller: panelController,
            body: Column(
              children: [
                if (ordersManager.userFilter != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Pedidos de ${ordersManager.userFilter.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        CustomIconButton(
                          iconData: Icons.close,
                          color: Colors.white,
                          onTap: () {
                            ordersManager.setUserFilter(null);
                          },
                        )
                      ],
                    ),
                  ),
                if (filteredOrders.isEmpty)
                  const Expanded(
                    child: EmptyCard(
                      title: 'Nenhuma venda realizada!',
                      iconData: Icons.border_clear,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredOrders.length,
                      itemBuilder: (_, index) {
                        return OrderTile(
                          filteredOrders.toList()[index],
                          showControls: true,
                        );
                      },
                    ),
                  ),
                const SizedBox(
                  height: 120,
                ),
              ],
            ),
            borderRadius: radius,
            minHeight: 40,
            maxHeight: 440,
            panel: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    if(panelController.isPanelClosed){
                      panelController.open();
                    } else{
                      panelController.close();
                    }
                  },
                  child: Container(
                    width: 290,
                     color: Colors.transparent,
                     height: 40,
                     alignment: Alignment.center,
                     child: Text(
                       'Filtros',
                       style: TextStyle(
                           color: Theme.of(context).primaryColor,
                           fontWeight: FontWeight.w800,
                           fontSize: 16),
                     ),
                   ),
                ),
                Expanded(
                  child: Column(
                    children: Status.values.map((s) {
                      return CheckboxListTile(
                        title: Text(Order.getStatusText(s)),
                        dense: true,
                        activeColor: Theme.of(context).primaryColor,
                        value: ordersManager.statusFilter.contains(s),
                        onChanged: (v){
                          ordersManager.setStatusFilter(
                            status: s,
                            enabled: v
                          );
                        },
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
