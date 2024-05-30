import 'package:flutter/material.dart';

class TabControllerProvider extends ChangeNotifier {
  TabController? _tabController;

  // Getter
  TabController get tabController => _tabController!;

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
    notifyListeners();
  }

  void initTabController(int length, TickerProvider tickerProvider) {
    _tabController ??= TabController(length: length, vsync: tickerProvider);
    // notifyListeners();
  }

  void moveBackToForm() {
    _tabController!.animateTo(0);
    notifyListeners();
  }
}
