import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/GetMCXModel.dart';
import '../Utils/AppBar.dart';

class StockDetailScreen extends ConsumerStatefulWidget {
  Datum stockData;

  StockDetailScreen({super.key, required this.stockData});

  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends ConsumerState<StockDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(ref: ref,showBackButton: true,),
    );
  }
}
