import 'dart:async';

import 'package:cryptotrack/core/theme/themeConstants.dart';
import 'package:cryptotrack/presentation/Bloc/events.dart';
import 'package:cryptotrack/presentation/Bloc/states.dart';
import 'package:cryptotrack/presentation/widgets/blobBackground.dart';
import 'package:cryptotrack/presentation/widgets/currencyChange.dart';
import 'package:cryptotrack/presentation/widgets/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCurrency = 'try';
  Timer? timer;

  List<Map<String, dynamic>> cryptoList = [];
  List<Map<String, dynamic>> cryptoFilteredList = [];

  @override
  void initState() {
    super.initState();
    context.read<CryptoBloc>().add(
      FetchCryptosEvent(currency: selectedCurrency),
    );

    timer = Timer.periodic(Duration(seconds: 30), (timer) {
      context.read<CryptoBloc>().add(
        FetchCryptosEvent(currency: selectedCurrency),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CryptoBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(ThemeConstants.scaffoldPads),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                cardBackgroundContainer(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        child: buttonUI(
                          Colors.white.withAlpha(50),
                          'Para çek',
                          Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    Expanded(
                      child: GestureDetector(
                        child: buttonUI(
                          Colors.orangeAccent,
                          'Para yatır',
                          null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    secText('Kriptolar'),
                    CurrencyDropdown(
                      selectedCurrency: selectedCurrency,
                      onCurrencyChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCurrency = newValue;
                          });
                          context.read<CryptoBloc>().add(
                            FetchCryptosEvent(currency: selectedCurrency),
                          );
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Arama...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        cryptoFilteredList = cryptoList;
                        return;
                      }
                      cryptoFilteredList = cryptoList.where((search) {
                        final name = search['name'].toString();
                        final code = search['code'].toString();

                        if (name.toLowerCase().contains(value.toLowerCase()) ||
                            code.toLowerCase().contains(value.toLowerCase())) {
                          return true;
                        }
                        return false;
                      }).toList();
                    });
                  },
                ),
                SizedBox(height: 10),
                Expanded(
                  child: BlocBuilder<CryptoBloc, CryptoState>(
                    builder: (context, state) {
                      if (state is CryptoLoadingState) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade800,
                          highlightColor: Colors.grey.shade600,
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return loadingSkeleton();
                            },
                          ),
                        );
                      } else if (state is CryptoLoadedState) {
                        cryptoList = state.cryptos.map((crypto) {
                          return {
                            'image': crypto.safeImage,
                            'name': crypto.safeName,
                            'code': crypto.safeCode,
                            'price': crypto.safePrice,
                            'change': crypto.safeChange,
                          };
                        }).toList();
                        if (cryptoFilteredList.isEmpty) {
                          cryptoFilteredList = cryptoList;
                        }
                        return ListView.builder(
                          itemCount: cryptoFilteredList.length,
                          itemBuilder: (context, index) {
                            final crypto = cryptoFilteredList[index];
                            return cryptosUI(
                              crypto['image'],
                              crypto['name'],
                              crypto['code'],
                              crypto['price'],
                              crypto['change'],
                            );
                          },
                        );
                      } else if (state is CryptoErrorState) {
                        return Center(child: mainText(state.message));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
