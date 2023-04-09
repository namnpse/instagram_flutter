import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/common.dart';
import '../widgets/lazy_indexed_stack.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    //Animating Page
    // _pageController.jumpToPage(page);
    onPageChanged(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: PageView(
      //   controller: _pageController,
      //   onPageChanged: onPageChanged,
      //   children: homeScreenItems,
      // ),
      body: _tabViews(),
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          'assets/ic_instagram.svg',
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.messenger_outline,
              color: primaryColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(
                Icons.home,
                color: (_page == 0) ? primaryColor : secondaryColor,
              ),
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.search,
                  color: (_page == 1) ? primaryColor : secondaryColor,
                ),
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Icon(
                  Icons.add_circle,
                  color: (_page == 2) ? primaryColor : secondaryColor,
                ),
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(
                Icons.favorite,
                color: (_page == 3) ? primaryColor : secondaryColor,
              ),
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Icon(
                Icons.person,
                color: (_page == 4) ? primaryColor : secondaryColor,
              ),
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
      // bottomNavigationBar: Container(
      //   height: 50,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       Expanded(
      //         child: Container(
      //           alignment: Alignment.center,
      //           child: Icon(
      //             Icons.person,
      //             color: (_page == 1) ? primaryColor : secondaryColor,
      //           ),
      //         ),
      //       ),
      //       Expanded(
      //         child: Container(
      //           alignment: Alignment.center,
      //           child: Icon(
      //             Icons.person,
      //             color: (_page == 2) ? primaryColor : secondaryColor,
      //           ),
      //         ),
      //       ),
      //       Expanded(
      //         child: Container(
      //           alignment: Alignment.center,
      //           child: Icon(
      //             Icons.person,
      //             color: (_page == 3) ? primaryColor : secondaryColor,
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
    );
  }

  Widget _tabViews() {
    List<Widget> tabs = homeScreenItems;
    // tabs.add(HomePage());
    // tabs.add(LeadListRoute.route);
    // tabs.add(BlocProvider<ListLeadBloc>(
    //   create: (_) => ListLeadBloc(
    //     getListOpportunityUseCase:
    //     GetIt.instance.get<GetListOpportunityUseCase>(),
    //     getFiltersUseCase: GetIt.instance.get<GetFiltersUseCase>(),
    //   ),
    //   child: CustomerListPage(),
    // ));
    // tabs.add(MenuPage());
    return LazyIndexedStack(
      index: _page,
      children: homeScreenItems,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
