import 'dart:async';

import 'package:cryptotrack/core/theme/themeConstants.dart';
import 'package:cryptotrack/presentation/Bloc/events.dart';
import 'package:cryptotrack/presentation/Bloc/states.dart';
import 'package:cryptotrack/presentation/widgets/blobBackground.dart';
import 'package:cryptotrack/presentation/widgets/currencyChange.dart';
import 'package:cryptotrack/presentation/widgets/delegate.dart';
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
  List<String> favoriteCodes = [];
  String selectedCurrency = 'try';
  Timer? timer;
  bool isFavoriteSelected = false;

  bool isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CryptoBloc>().add(
      FetchCryptosEvent(currency: selectedCurrency),
    );

    timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      context.read<CryptoBloc>().add(
        FetchCryptosEvent(currency: selectedCurrency),
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double headerHeight = isSearchVisible ? 190.0 : 140.0;

    return CryptoBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12 , vertical:0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      cardBackgroundContainer(),
                      const SizedBox(height: 20),
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
                          const SizedBox(width: 10),
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
                    ],
                  ),
                ),
              ),
            ),
        
            SliverPersistentHeader(
              pinned: true,
              key: ValueKey(isSearchVisible),
              delegate: HeaderDelegate(
               height: headerHeight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 0),
                  child: Column(
                    children: [
                      // Başlık ve Para Birimi 
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
                                  FetchCryptosEvent(
                                    currency: selectedCurrency,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                        
                      // Çipler ve Arama İkonu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              chipUI('Tümü', !isFavoriteSelected, (p0) {
                                setState(() {
                                  isFavoriteSelected = false;
                                });
                              }),
                              const SizedBox(width: 10),
                              chipUI('Favoriler', isFavoriteSelected, (p0) {
                                setState(() {
                                  isFavoriteSelected = true;
                                });
                              }),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSearchVisible = !isSearchVisible;
                                if (!isSearchVisible) {
                                  _searchController.clear();
                                  context.read<CryptoBloc>().add(
                                    SearchCrypto(search: ''),
                                  );
                                }
                              });
                            },
                            child: Icon(
                              isSearchVisible ? Icons.close : Icons.search,
                              color: ThemeConstants.textSec,
                            ),
                          ),
                        ],
                      ),
                        
                      // Arama Alanı
                      if (isSearchVisible) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 45,
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Arama...',
                              hintStyle: const TextStyle(color: Colors.grey),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 12,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              context.read<CryptoBloc>().add(
                                SearchCrypto(search: value),
                              );
                            },
                          ),
                        ),
                      ],
                     
                    ],
                  ),
                ),
              ),
            ),

            BlocBuilder<CryptoBloc, CryptoState>(
              builder: (context, state) {
                if (state is CryptoLoadingState) {
                  return SliverToBoxAdapter(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade600,
                      child: Column(
                        children: List.generate(
                          10,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12 , vertical:0),
                            child: loadingSkeleton(),
                          ),
                        ),
                      ),
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
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: mainText(
                          isFavoriteSelected
                              ? 'Henüz favori kripto eklemediniz.'
                              : 'Aradığınız kripto bulunamadı.',
                        ),
                      ),
                    );
                  }
        
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final crypto = displayedCryptos[index];
                      final code = crypto.safeCode.toLowerCase();
                      final isFav = state.favorites
                          .map((e) => e.toLowerCase())
                          .contains(code);
        
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 0,
                        ),
                        child: cryptosUI(
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
                        ),
                      );
                    }, childCount: displayedCryptos.length),
                  );
                } else if (state is CryptoErrorState) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: mainText(state.message)),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }
}
