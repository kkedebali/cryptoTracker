import 'dart:async';

import 'package:cryptotrack/core/theme/themeConstants.dart';
import 'package:cryptotrack/presentation/Bloc/events.dart';
import 'package:cryptotrack/presentation/Bloc/states.dart';
import 'package:cryptotrack/presentation/widgets/blobBackground.dart';
import 'package:cryptotrack/presentation/widgets/currencyChange.dart';
import 'package:cryptotrack/presentation/widgets/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> favoriteCodes = [];
  String selectedCurrency = 'try';
  Timer? timer;
  bool isFavoriteSelected = false;

  List<Map<String, dynamic>> cryptoList = [];

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
                    context.read<CryptoBloc>().add(SearchCrypto(search: value));
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    ChoiceChip(
                      label: Text('Tümü'),
                      selected: !isFavoriteSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            isFavoriteSelected = false;
                          });
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    ChoiceChip(
                      label: Text('Favoriler'),
                      selected: isFavoriteSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            isFavoriteSelected = true;
                          });
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
                        final displayedCryptos = isFavoriteSelected
                            ? state.cryptos.where((crypto) {
                                final code = crypto.safeCode.toLowerCase();
                                return state.favorites
                                    .map((e) => e.toLowerCase())
                                    .contains(code);
                              }).toList()
                            : state.cryptos;

                        if (displayedCryptos.isEmpty) {
                          return Center(
                            child: mainText(
                              isFavoriteSelected
                                  ? 'Henüz favori kripto eklemediniz.'
                                  : 'Aradığınız kripto bulunamadı.',
                            ),
                          );
                        }
                        if (state.cryptos.isEmpty) {
                          return Center(
                            child: mainText('Aradığınız kripto bulunamadı.'),
                          );
                        }

                        cryptoList = state.cryptos.map((crypto) {
                          return {
                            'image': crypto.safeImage,
                            'name': crypto.safeName,
                            'code': crypto.safeCode,
                            'price': crypto.safePrice,
                            'change': crypto.safeChange,
                          };
                        }).toList();

                        return ListView.builder(
                          itemCount: displayedCryptos.length,
                          itemBuilder: (context, index) {
                            final crypto = displayedCryptos[index];
                            final code = crypto.safeCode.toLowerCase();
                            final isFav = state.favorites
                                .map((e) => e.toLowerCase())
                                .contains(code);

                            return cryptosUI(
                              crypto.safeImage,
                              crypto.safeName,
                              crypto.safeCode,
                              crypto.safePrice,
                              crypto.safeChange,
                              isFav,
                              () {
                                context.read<CryptoBloc>().add(
                                  ToggleFavoritesEvent(
                                    code: crypto.safeCode.toLowerCase(),
                                  ),
                                );
                              },
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
