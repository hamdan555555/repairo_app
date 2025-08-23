import 'package:breaking_project/business_logic/CreatingOrderCubit/creating_order_cubit.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_states.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/provided_services.dart';
import 'package:breaking_project/data/models/service_model.dart';
import 'package:breaking_project/data/repository/creating_order_repository.dart';
import 'package:breaking_project/data/web_services/creating_order_webservice.dart';
import 'package:breaking_project/presentation/screens/creating_order.dart';
import 'package:breaking_project/presentation/widgets/cart_item_widget.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:breaking_project/presentation/widgets/service_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:line_icons/line_icon.dart';

class ProvidedServicesScreen extends StatefulWidget {
  final List<String> selectedServices;
  final String techId;
  final String techname;
  final Cart cart;

  const ProvidedServicesScreen(
      {super.key,
      required this.selectedServices,
      required this.techId,
      required this.techname,
      required this.cart});

  @override
  State<ProvidedServicesScreen> createState() => _ProvidedServicesScreenState();
}

class _ProvidedServicesScreenState extends State<ProvidedServicesScreen> {
  List<RProvidedServices> services = [];
  List<String> selectedServices = [];

  @override
  void initState() {
    context
        .read<ProvidedServicesCubit>()
        .fetchProvidedServices(widget.techId, widget.selectedServices);
    super.initState();
  }

  void toggleServiceSelection(String serviceId, bool selected) {
    setState(() {
      if (selected) {
        selectedServices.add(serviceId);
        print(selectedServices);
      } else {
        selectedServices.remove(serviceId);
        print(selectedServices);
      }
    });
  }

  void showCartBottomSheet(BuildContext context, Cart cart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // الشرط الرئيسي: إذا كانت السلة فارغة، قم بإخفاء الـ sheet
            if (cart.isEmpty) {
              Navigator.of(context).pop();
              return Container(); // ارجع حاوية فارغة
            }

            return Directionality(
              textDirection: TextDirection.rtl,
              child: DraggableScrollableSheet(
                initialChildSize: 0.2,
                minChildSize: 0.1,
                //maxChildSize: 0.8,
                expand: false,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "المجموع: ${cart.total.toStringAsFixed(2)} ليرة",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Cairo"),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Get.to(SuggestedServicesScreen(
                                //     cart: cart, suggestion_list: servicess));
                                //Get.to(SchedulePage(cart: cart));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 24),
                                  child: Text(
                                    "التالي",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Cairo",
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: cart.items.length,
                            itemBuilder: (context, index) {
                              final item = cart.items[index];
                              return ListTile(
                                title: Text(
                                  item.service.displayName!,
                                  style: TextStyle(fontFamily: "Cairo"),
                                ),
                                subtitle: Text(
                                  "x${item.quantity}",
                                  style: TextStyle(fontFamily: "Cairo"),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        // قم بإنقاص الكمية هنا
                                        cart.decrement(item.service);
                                        // ثم قم بتحديث الـ state
                                        setState(() {});
                                      },
                                    ),
                                    Text("${item.quantity}"),
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        // قم بزيادة الكمية هنا
                                        cart.add(item.service);
                                        // ثم قم بتحديث الـ state
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // appBar: AppBar(
        // title: Text("${widget.techname}'s services ",
        //     style: TextStyle(color: Colors.white)),
        //   backgroundColor: const Color(0xFF6F4EC9),
        //   centerTitle: true,
        // ),
        body: BlocBuilder<ProvidedServicesCubit, ProvidedServicesStates>(
          builder: (context, state) {
            if (state is ProvidedServicesSuccess) {
              services = (state).providedservices;
              selectedServices = widget.selectedServices;
              print(selectedServices);
              return Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, right: 8),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.grey.shade500,
                                child: Icon(
                                  Icons.arrow_back_ios_new_sharp,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text("  خدمات المهني ${widget.techname}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Cairo",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final service = services[index];
                            final isSelected =
                                selectedServices.contains(service.id);
                            //final isSelected = service.selected;
                            print(isSelected);

                            return Container(
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // صورة الخدمة
                                      Container(
                                        width: 70,
                                        height: 70,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            service.image!.replaceFirst(
                                                '127.0.0.1',
                                                AppConstants.baseaddress),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),

                                      // النصوص
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              service.name!,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Cairo"),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              "خدمة جديدة تستطيع تلبية احتياجات المستخدمين اللذين يرغبون بالاستفادة من الخدمات الموجودة على النظام ومن ثم استخدامها",
                                              style: TextStyle(
                                                  fontFamily: "Cairo",
                                                  fontSize: 13,
                                                  color: Colors.grey[700]),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 16),
                                            Row(
                                              children: [
                                                Text(
                                                  "${service.price} ليرة",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Cairo",
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                                Spacer(),
                                                !widget.cart.contains(
                                                        service as RServiceData)
                                                    ? GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            widget.cart.add(service
                                                                as RServiceData);
                                                          });
                                                          showCartBottomSheet(
                                                              context,
                                                              widget.cart);

                                                          // if (cart.items.isNotEmpty) {
                                                          //   _showCart();
                                                          // }
                                                        },
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 4),
                                                          child: Container(
                                                            // width: 50.w,
                                                            // height: 35,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    Colors.teal,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10))),
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        8.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "أضف",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              "Cairo",
                                                                          fontSize:
                                                                              13,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    LineIcon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 16,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 4),
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      widget
                                                                          .cart
                                                                          .decrement(service
                                                                              as RServiceData);
                                                                    });
                                                                    showCartBottomSheet(
                                                                        context,
                                                                        widget
                                                                            .cart);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            width:
                                                                                0.5,
                                                                            color: Colors
                                                                                .grey),
                                                                        borderRadius:
                                                                            BorderRadius.circular(30)),
                                                                    child: Icon(
                                                                      Icons
                                                                          .remove,
                                                                      color: Colors
                                                                          .teal,
                                                                      size: 18,
                                                                    ),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          4),
                                                                  child: Text(
                                                                    "${widget.cart.getQuantity(service as RServiceData)}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontFamily:
                                                                          "Cairo",
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      widget
                                                                          .cart
                                                                          .add(service
                                                                              as RServiceData);
                                                                    });
                                                                    showCartBottomSheet(
                                                                        context,
                                                                        widget
                                                                            .cart);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            width:
                                                                                0.5,
                                                                            color: Colors
                                                                                .grey),
                                                                        borderRadius:
                                                                            BorderRadius.circular(30)),
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      color: Colors
                                                                          .teal,
                                                                      size: 18,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // ElevatedButton(
                                      //   style: ElevatedButton.styleFrom(
                                      //     shape: StadiumBorder(),
                                      //     padding: EdgeInsets.symmetric(
                                      //         horizontal: 16, vertical: 8),
                                      //   ),
                                      //   onPressed: () {
                                      //     setState(() {
                                      //       cart.add(service);
                                      //     });
                                      //     if (cart.items.isNotEmpty) {
                                      //       _showCart();
                                      //     }
                                      //   },
                                      //   child: Text("أضف"),
                                      // ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                              ),
                            );
                            //  ServiceCard(
                            //     service: service,
                            //     isSelected: isSelected!,
                            //     onToggle: toggleServiceSelection);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomElevatedButton(
                          onpressed: () {
                            Get.to(() => BlocProvider(
                                  create: (context) => CreatingOrderCubit(
                                      CreatingOrderRepository(
                                          CreatingOrderWebservice())),
                                  child: CreateRequestScreen(
                                    id: widget.techId,
                                    services: widget.selectedServices,
                                  ),
                                ));
                          },
                          text: "Next",
                          active: selectedServices.isNotEmpty,
                        ),
                      )
                    ]),
              );
            } else if (state is ProvidedServicesLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.teal,
              ));
            } else if (state is ProvidedServicesError) {
              return Center(child: Text("Error Happened"));
            }
            return Center(child: Text("No Data"));

            //  ListView.builder(
            //   padding: const EdgeInsets.all(16),
            //   itemCount: services.length,
            //   itemBuilder: (context, index) {
            //     final service = services[index];
            //     return Center(child: Text("NO Data"))
            //   },
            // );
          },
        ),
      ),
    );
  }
}
