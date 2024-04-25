import 'package:flutter/material.dart';
import 'package:mlt_menu_admin/core/utils/utils.dart';

import '../../../order/view/screen/order_on_table.dart';
import '../../../table/data/model/table_model.dart';

class ItemTable extends StatelessWidget {
  const ItemTable({super.key, required this.table});
  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // context.push(RouteName.orderOnTable, extra: table)
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                  content: SizedBox(
                      width: 600, child: OrderOnTable(tableModel: table))));
        },
        child: Card(
            elevation: 10,
            // color: table.isUse ? Colors.green.shade900.withOpacity(0.3) : null,
            child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(children: [
                  Expanded(
                      flex: 4,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            text: 'Bàn: ',
                                            style: context.textStyleSmall!
                                                .copyWith(
                                                    color: Colors.white
                                                        .withOpacity(0.3)),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: table.name,
                                                  style: context
                                                      .titleStyleMedium!
                                                      .copyWith(
                                                          color: context
                                                              .colorScheme
                                                              .secondary,
                                                          fontWeight:
                                                              FontWeight.bold))
                                            ])))),
                            Expanded(
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            text: 'Số ghế: ',
                                            style: context.textStyleSmall!
                                                .copyWith(
                                                    color: Colors.white
                                                        .withOpacity(0.3)),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: table.seats.toString(),
                                                  style: context
                                                      .textStyleMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold))
                                            ])))),
                            Expanded(
                                child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: RichText(
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                            text: 'trạng thái: ',
                                            style: context.textStyleSmall!
                                                .copyWith(
                                                    color: Colors.white
                                                        .withOpacity(0.3)),
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: Ultils.tableStatus(
                                                      table.isUse),
                                                  style: context.textStyleSmall!
                                                      .copyWith(
                                                          color: table.isUse
                                                              ? Colors.green
                                                              : context
                                                                  .colorScheme
                                                                  .errorContainer,
                                                          fontWeight:
                                                              FontWeight.bold))
                                            ]))))
                          ])),
                  Expanded(
                      child: Center(
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: table.isUse
                                          ? Colors.green
                                          : Colors.red),
                                  shape: BoxShape.circle),
                              child: Container(
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: table.isUse
                                          ? Colors.green
                                          : Colors.red)))))
                ]))));
  }
}
