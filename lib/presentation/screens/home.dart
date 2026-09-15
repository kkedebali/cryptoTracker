import 'dart:async';

import 'package:cryptotrack/core/theme/themeConstants.dart';
import 'package:cryptotrack/presentation/Bloc/events.dart';
import 'package:cryptotrack/presentation/Bloc/states.dart';
import 'package:cryptotrack/presentation/widgets/blobBackground.dart';
import 'package:cryptotrack/presentation/widgets/currencyChange.dart';
import 'package:cryptotrack/presentation/widgets/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCurrency = 'try';
  Timer? timer;

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
                Expanded(
                  child: BlocBuilder<CryptoBloc, CryptoState>(
                    builder: (context, state) {
                      if (state is CryptoLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is CryptoLoadedState) {
                        return ListView.builder(
                          itemCount: state.cryptos.length,
                          itemBuilder: (context, index) {
                            final crypto = state.cryptos[index];
                            return cryptosUI(
                              crypto.safeImage,
                              crypto.safeName,
                              crypto.safeCode,
                              crypto.safePrice,
                              crypto.safeChange,
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
