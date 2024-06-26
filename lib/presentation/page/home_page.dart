import 'package:d_chart/d_chart.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_record/config/app_asset.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/config/app_format.dart';
import 'package:money_record/config/session.dart';
import 'package:money_record/presentation/controller/c_home.dart';
import 'package:money_record/presentation/controller/c_user.dart';
import 'package:money_record/presentation/page/auth/login_page.dart';
import 'package:money_record/presentation/page/history/add_history_page.dart';
import 'package:money_record/presentation/page/history/detail_history_page.dart';
import 'package:money_record/presentation/page/history/history_page.dart';
import 'package:money_record/presentation/page/history/income_outcome_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final cUser = Get.put(CUser());
  final cHome = Get.put(CHome());

  @override
  void initState() {
    cHome.getAnalysis(cUser.data.idUser!);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: drawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            child: Row(
              children: [
                Image.asset(AppAsset.profile),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hi,',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Obx(() {
                        return Text(
                          cUser.data.name ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        );
                      }),
                    ],
                  ),
                ),
                Builder(builder: (ctx) {
                  return Material(
                    borderRadius: BorderRadius.circular(4),
                    color: AppColor.chartColor,
                    child: InkWell(
                      onTap: () {
                        Scaffold.of(ctx).openEndDrawer();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.menu,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                cHome.getAnalysis(cUser.data.idUser!);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                children: [
                  Text(
                    'Pengeluaran Hari Ini!',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  DView.height(),
                  cardToday(context),
                  DView.height(30),
                  Center(
                    child: Container(
                      height: 5,
                      width: 80,
                      decoration: BoxDecoration(
                          color: AppColor.bgColor,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  DView.height(30),
                  Text(
                    'Pengeluaran Minggu Ini!',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  DView.height(),
                  weekly(),
                  DView.height(30),
                  Text(
                    'Perbandingan Bulan Ini!',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  DView.height(),
                  monthly(context)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Drawer drawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            margin: const EdgeInsets.only(bottom: 0),
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(AppAsset.profile),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() {
                            return Text(
                              cUser.data.name ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            );
                          }),
                          Obx(() {
                            return Text(
                              cUser.data.email ?? '',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w300, fontSize: 16),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
                Material(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      Session.clearUser();
                      Get.off(() => const LoginPage());
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 8,
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Get.to(() => AddHistoryPage())?.then((value) {
                if(value??false) {
                  cHome.getAnalysis(cUser.data.idUser!);
                }
              });
            },
            leading: const Icon(Icons.add),
            horizontalTitleGap: 0,
            title: const Text('Tambah Baru'),
            trailing: const Icon(Icons.navigate_next),
          ),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(
                type: 'Pemasukan',
              ));
            },
            leading: const Icon(Icons.south_west),
            horizontalTitleGap: 0,
            title: const Text('Pemasukan'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              Get.to(() => const IncomeOutcomePage(
                type: 'Pengeluaran',
              ));
            },
            leading: const Icon(Icons.north_east),
            horizontalTitleGap: 0,
            title: const Text('Pengeluaran'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {
              Get.to(() => const HistoryPage());
            },
            leading: const Icon(Icons.history),
            horizontalTitleGap: 0,
            title: const Text('Riwayat'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.add),
            horizontalTitleGap: 0,
            title: const Text('Tambah Baru'),
            trailing: const Icon(Icons.navigate_next),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Row monthly(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: [
              Obx(
                () {
                  return DChartPie(
                    data: [
                      {'domain': 'income', 'measure': cHome.monthIncome},
                      {'domain': 'outcome', 'measure': cHome.monthOutcome},
                      if(cHome.monthIncome == 0 && cHome.monthOutcome == 0)
                        {'domain': 'nol', 'measure': 1},
                    ],
                    fillColor: (pieData, index) {
                      switch (pieData['domain']) {
                        case 'income':
                          return AppColor.primaryColor;
                        case 'outcome':
                          return AppColor.chartColor;
                        default:
                          return AppColor.bgColor.withOpacity(0.5);
                      }
                    },
                    donutWidth: 20,
                    labelColor: Colors.transparent,
                    showLabelLine: false,
                  );
                }
              ),
              Center(
                child: Obx(
                  () {
                    return Text(
                      '${cHome.percentIncome}%',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: AppColor.primaryColor),
                    );
                  }
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.primaryColor,
                ),
                DView.width(8),
                const Text('Pemasukan')
              ],
            ),
            DView.height(8),
            Row(
              children: [
                Container(
                  height: 16,
                  width: 16,
                  color: AppColor.chartColor,
                ),
                DView.width(8),
                const Text('Pengeluaran'),
              ],
            ),
            DView.height(20),
            Obx(() {
              return Text(cHome.monthPercent);
            }),
            DView.height(10),
            const Text('Atau setara:'),
            Obx(() {
              return Text(
                AppFormat.currency(cHome.differentMonth.toString()),
                style: const TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            })
          ],
        )
      ],
    );
  }

  AspectRatio weekly() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Obx(
        () {
          return DChartBar(
            data: [
              {
                'id': 'Bar',
                'data': List.generate(7, (index) {
                  return {'domain': cHome.weekText()[index], 'measure': cHome.week[index]};
                })
              },
            ],
            domainLabelPaddingToAxisLine: 12,
            axisLineTick: 2,
            axisLineColor: AppColor.primaryColor,
            measureLabelPaddingToAxisLine: 16,
            barColor: (barData, index, id) => AppColor.primaryColor,
            showBarValue: true,
          );
        }
      ),
    );
  }

  Material cardToday(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: 4,
      color: AppColor.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Obx(
              () {
                return Text(
                  AppFormat.currency(cHome.today.toString()),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold, color: AppColor.secondaryColor),
                );
              }
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
            child: Obx(
              () {
                return Text(
                  cHome.todayPercent,
                  style: const TextStyle(color: AppColor.bgColor, fontSize: 16),
                );
              }
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => DetailHistoryPage(
                date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                idUser: cUser.data.idUser!,
                type: 'Pengeluaran',
              ));
            },
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 0, 16),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Selengkapnya',
                    style: TextStyle(color: AppColor.primaryColor, fontSize: 16),
                  ),
                  Icon(
                    Icons.navigate_next,
                    color: AppColor.primaryColor,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
