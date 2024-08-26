import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vendor/views/pages/vendor_chat_support/vendor_chat_support.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/ticket_list_model.dart';
import '../../../requests/order.request.dart';
import '../../../utils/ui_spacer.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late Future<List<Ticket>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = OrderRequest().getTickets();
  }

  Future<void> _refreshTickets() async {
    setState(() {
      _ticketsFuture = OrderRequest().getTickets();
    });
    // Wait for the future to complete before finishing the refresh
    await _ticketsFuture;
  }

  String timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);

    if (duration.inMinutes < 1) return 'just now';
    if (duration.inMinutes < 60) return '${duration.inMinutes} mins ago';
    if (duration.inHours < 24) return '${duration.inHours} hours ago';
    if (duration.inDays < 7) return '${duration.inDays} days ago';

    // Customize further if needed
    return 'on ${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: AppColor.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTickets,
        child: FutureBuilder<List<Ticket>>(
          future: _ticketsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              final errorMessage = snapshot.error.toString().contains('Null')
                  ? 'Received unexpected null value'
                  : 'Error: ${snapshot.error}';
              return Center(child: Text(errorMessage));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No tickets available.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final ticket = snapshot.data![index];
                  print('Updated at: ${ticket.updatedAt}');
                  // Format the delivered time
                  String deliveredTime = ticket.updatedAt != null
                      ? timeAgo(ticket.updatedAt!)
                      : 'No delivery time available';

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: VStack([
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 3, color: AppColor.appMainColor)),
                        child: VStack(
                          [
                            //title
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(ticket.user.name,
                                      style: AppTextStyle
                                          .comicNeue25BoldTextStyle(
                                          color: AppColor.appMainColor)),
                                ),
                                UiSpacer.hSpace(10),
                                Expanded(
                                  child: Text(ticket.title,
                                      style: AppTextStyle
                                          .comicNeue20BoldTextStyle(
                                          color: AppColor.appMainColor)),
                                ),
                                UiSpacer.hSpace(5),
                                Expanded(
                                  child: Text(
                                    'Delivered $deliveredTime',
                                    maxLines: 3,
                                    style: AppTextStyle
                                        .comicNeue20BoldTextStyle(
                                        color: AppColor.appMainColor),
                                  ),
                                ),
                              ],
                            ).py4(),

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: ticket.items.map((item) {
                                      return Text(
                                        '${item.quantity}x ${item.product.name}',
                                        style: AppTextStyle
                                            .comicNeue20BoldTextStyle(
                                            color: AppColor.appMainColor),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(width: 5),
                                Column(
                                  children: [
                                    Text('Total',
                                        style: AppTextStyle
                                            .comicNeue25BoldTextStyle(
                                            color: AppColor.appMainColor)),
                                    Text('\$${ticket.total}',
                                        style: AppTextStyle
                                            .comicNeue25BoldTextStyle(
                                            color: AppColor.appMainColor)),
                                  ],
                                ),
                                SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    openDialog(
                                        ticket.id,
                                        ticket.messages,
                                        ticket.isClosed,
                                        index,
                                      ticket.user.name,
                                      ticket.orderNumber,
                                      ticket.total,

                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                            width: 3,
                                            color: AppColor.appMainColor)),
                                    child: Text('Resolve\nNow',
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle
                                            .comicNeue20BoldTextStyle(
                                            color: AppColor
                                                .appMainColor))
                                        .px20()
                                        .py4(),
                                  ),
                                ),
                              ],
                            ).py4(),
                            Text('(Click to expand)',
                                style: AppTextStyle.comicNeue14BoldTextStyle(
                                    color: AppColor.appMainColor)),

                            //time

                            //body
                          ],
                        ).py12(),
                      ),
                    ]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  void openDialog(int? ticketId,List<Message>? messages,bool? isChatClosed, int? index,String? name,String orderNumber,double? total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$name\n$orderNumber',
                        style: AppTextStyle.comicNeue35BoldTextStyle(
                            color: AppColor.appMainColor))
                        .p8(),
                    Text('\$$total',
                        style: AppTextStyle.comicNeue25BoldTextStyle(
                            color: AppColor.appMainColor))
                        .p8(),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      child: Text('Refund',
                          style: AppTextStyle.comicNeue25BoldTextStyle(
                              color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() => Navigator.pop(context)),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 3, color: AppColor.appMainColor)),
                        child: Text('Credit\n(recommended)',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.comicNeue25BoldTextStyle(
                                color: AppColor.appMainColor))
                            .p4(),
                      ).onInkTap(() => Navigator.pop(context)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VendorChatSupport(
            ticketId: ticketId,
            messages: messages,
            isChatClosed: isChatClosed,
            index: index,
          ),
        ),
      );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 3, color: AppColor.appMainColor)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        child: Text('Chat',
                            style: AppTextStyle.comicNeue25BoldTextStyle(
                                color: AppColor.appMainColor))
                            .p4(),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 3, color: AppColor.appMainColor)),
                        child: Text('Redeliver\n(Not Recommended)',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.comicNeue25BoldTextStyle(
                                color: AppColor.appMainColor))
                            .p4(),
                      ).onInkTap(() => Navigator.pop(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


// Container(
//   decoration: BoxDecoration(
//       border: Border.all(color: AppColor.primaryColor, width: 3.0),
//       borderRadius: BorderRadius.circular(15.0)),
//   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//   child: ListTile(
//     title: Text(
//       ticket.title,
//       style: TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//         color: AppColor.primaryColor,
//       ),
//     ),
//     subtitle: Text(
//       'Order Number: ${ticket.orderNumber}',
//       style: TextStyle(
//         fontSize: 15,
//         fontWeight: FontWeight.bold,
//         color: AppColor.primaryColor,
//       ),
//     ),
//     onTap: () {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => VendorChatSupport(
//             ticketId: ticket.id,
//             messages: ticket.messages,
//             isChatClosed: ticket.isClosed,
//             index: index,
//           ),
//         ),
//       );
//     },
//   ),
// ),