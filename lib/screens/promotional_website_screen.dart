import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class PromotionalWebsiteScreen extends StatefulWidget {
  const PromotionalWebsiteScreen({super.key});

  @override
  State<PromotionalWebsiteScreen> createState() =>
      _PromotionalWebsiteScreenState();
}

class _PromotionalWebsiteScreenState extends State<PromotionalWebsiteScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _featuresController;
  late AnimationController _destinationsController;
  late Timer _timer;

  List<String> images = [
    'mayonvolcano.jpg',
    'batanes.jpg',
    'siargao.jpg',
    'maskarafestival.jpg',
    'sunkencementery.jpg',
    'onboarding3.jpg',
    'onboarding2.jpg',
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _featuresController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _destinationsController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _heroController.forward();
    Future.delayed(
        const Duration(milliseconds: 400), () => _featuresController.forward());
    Future.delayed(const Duration(milliseconds: 800),
        () => _destinationsController.forward());
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        index = (index + 1) % images.length;
      });
    });
  }

  @override
  void dispose() {
    _heroController.dispose();
    _featuresController.dispose();
    _destinationsController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context),
            _buildFeaturesSection(context),
            _buildVideoSection(),
            _buildDestinationsSection(context),
            _buildBottomCTA(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return FadeTransition(
      opacity: _heroController,
      child: Container(
        height: isMobile ? 1300 : 750,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D47A1).withOpacity(0.9),
              const Color(0xFF64B5F6).withOpacity(0.9),
              const Color(0xFFE1F5FE).withOpacity(0.7),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/backgrounds/collage.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 40),
                child: isMobile
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),
                          _buildHeroPhoneMockup(),
                          const SizedBox(height: 50),
                          _buildHeroTextAndButtons(isMobile),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildHeroPhoneMockup(),
                          const SizedBox(width: 80),
                          Expanded(child: _buildHeroTextAndButtons(isMobile)),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroPhoneMockup() {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: 340,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(48),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48),
            child: Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 1.05, end: 1.0)
                            .animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    key: ValueKey<int>(index),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/backgrounds/${images[index]}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroTextAndButtons(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Image.asset('assets/images/icon.png', width: 70, height: 70),
            const SizedBox(width: 20),
            Text(
              'Discover Philippines',
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 32 : 40,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          'Explore 7,641 Islands of Paradise',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 40 : 56,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Plan your unforgettable journey through the Philippines with curated destinations, from pristine beaches to vibrant festivals.',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 18 : 22,
            color: Colors.white.withOpacity(0.95),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Your Adventure Awaits!',
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 16 : 20,
            fontWeight: FontWeight.w600,
            color: Colors.amber[200],
          ),
        ),
        const SizedBox(height: 56),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildStoreButton(store: 'google', onPressed: () {}),
            const SizedBox(width: 24),
            _buildStoreButton(store: 'apple', onPressed: () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildStoreButton(
      {required String store, required VoidCallback onPressed}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = MediaQuery.of(context).size.width < 600;
        final scaleFactor = isMobile ? 0.85 : 1.0;
        final maxWidth =
            constraints.maxWidth > 400 ? 300.0 : constraints.maxWidth * 0.7;
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onPressed,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                  horizontal: 28 * scaleFactor, vertical: 14 * scaleFactor),
              constraints: BoxConstraints(
                  minWidth: 200 * scaleFactor, maxWidth: maxWidth),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0288D1),
                    const Color(0xFF42A5F5).withOpacity(0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(14 * scaleFactor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10 * scaleFactor,
                    offset: Offset(0, 5 * scaleFactor),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    store == 'google'
                        ? FontAwesomeIcons.googlePlay
                        : FontAwesomeIcons.apple,
                    color: Colors.white,
                    size: 36 * scaleFactor,
                  ),
                  SizedBox(width: 14 * scaleFactor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store == 'google' ? 'GET IT ON' : 'Download on the',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14 * scaleFactor,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        store == 'google' ? 'Google Play' : 'App Store',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20 * scaleFactor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return FadeTransition(
      opacity: _featuresController,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: 120, horizontal: isMobile ? 16 : 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFF5F8FF),
              const Color(0xFFE3F2FD).withOpacity(0.9),
            ],
          ),
        ),
        child: Column(
          children: [
            Text(
              'Why Discover Philippines?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D47A1),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Discover features to make your trip unforgettable',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                color: Colors.grey[800],
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 60),
            isMobile
                ? Column(
                    children: [
                      _buildFeatureCard(
                        icon: FontAwesomeIcons.mapLocationDot,
                        title: 'Interactive Maps',
                        description:
                            'Navigate with detailed maps and real-time location.',
                        color: const Color(0xFF0288D1),
                      ),
                      const SizedBox(height: 32),
                      _buildFeatureCard(
                        icon: FontAwesomeIcons.heart,
                        title: 'Save Favorites',
                        description: 'Bookmark destinations for easy planning.',
                        color: const Color(0xFFD81B60),
                      ),
                      const SizedBox(height: 32),
                      _buildFeatureCard(
                        icon: FontAwesomeIcons.magnifyingGlass,
                        title: 'Smart Search',
                        description: 'Find destinations with powerful filters.',
                        color: const Color(0xFF388E3C),
                      ),
                      const SizedBox(height: 32),
                      _buildFeatureCard(
                        icon: FontAwesomeIcons.earthAsia,
                        title: 'Region Explorer',
                        description: 'Explore 17 regions with detailed guides.',
                        color: const Color(0xFFFBC02D),
                      ),
                      const SizedBox(height: 32),
                      _buildFeatureCard(
                        icon: FontAwesomeIcons.calendar,
                        title: 'Festival Calendar',
                        description: 'Plan visits around vibrant festivals.',
                        color: const Color(0xFF8E24AA),
                      ),
                      const SizedBox(height: 32),
                      _buildFeatureCard(
                        icon: FontAwesomeIcons.utensils,
                        title: 'Local Cuisine',
                        description: 'Discover authentic Filipino dining.',
                        color: const Color(0xFFE64A19),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFeatureCard(
                            icon: FontAwesomeIcons.mapLocationDot,
                            title: 'Interactive Maps',
                            description:
                                'Navigate with detailed maps and real-time location.',
                            color: const Color(0xFF0288D1),
                          ),
                          const SizedBox(width: 40),
                          _buildFeatureCard(
                            icon: FontAwesomeIcons.heart,
                            title: 'Save Favorites',
                            description:
                                'Bookmark destinations for easy planning.',
                            color: const Color(0xFFD81B60),
                          ),
                          const SizedBox(width: 40),
                          _buildFeatureCard(
                            icon: FontAwesomeIcons.magnifyingGlass,
                            title: 'Smart Search',
                            description:
                                'Find destinations with powerful filters.',
                            color: const Color(0xFF388E3C),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFeatureCard(
                            icon: FontAwesomeIcons.earthAsia,
                            title: 'Region Explorer',
                            description:
                                'Explore 17 regions with detailed guides.',
                            color: const Color(0xFFFBC02D),
                          ),
                          const SizedBox(width: 40),
                          _buildFeatureCard(
                            icon: FontAwesomeIcons.calendar,
                            title: 'Festival Calendar',
                            description:
                                'Plan visits around vibrant festivals.',
                            color: const Color(0xFF8E24AA),
                          ),
                          const SizedBox(width: 40),
                          _buildFeatureCard(
                            icon: FontAwesomeIcons.utensils,
                            title: 'Local Cuisine',
                            description: 'Discover authentic Filipino dining.',
                            color: const Color(0xFFE64A19),
                          ),
                        ],
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 60),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0D47A1),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: isMobile ? 48 : 96, horizontal: isMobile ? 16 : 40),
      decoration: const BoxDecoration(color: Colors.white),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'See the App in Action',
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D47A1),
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Watch how Discover Philippines simplifies travel planning with stunning destinations.',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Join thousands of travelers today!',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0288D1),
                  ),
                ),
                const SizedBox(height: 32),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage(
                              'assets/images/backgrounds/boracay.jpg'),
                          fit: BoxFit.cover,
                          opacity: 0.8,
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedScale(
                        scale: 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            FontAwesomeIcons.play,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'See the App in Action',
                        style: GoogleFonts.poppins(
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D47A1),
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Watch how Discover Philippines simplifies travel planning with stunning destinations.',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Join thousands of travelers today!',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0288D1),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 80),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 380,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          image: const DecorationImage(
                            image: AssetImage(
                                'assets/images/backgrounds/boracay.jpg'),
                            fit: BoxFit.cover,
                            opacity: 0.8,
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              FontAwesomeIcons.play,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildDestinationsSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1000;
    return FadeTransition(
      opacity: _destinationsController,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: 120, horizontal: isMobile ? 16 : 40),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F8FF),
          image: DecorationImage(
            image: const AssetImage('assets/images/backgrounds/pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: Column(
          children: [
            Text(
              'Top Destinations',
              style: GoogleFonts.poppins(
                fontSize: 44,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D47A1),
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Explore the Philippines’ most stunning locations',
              style: GoogleFonts.poppins(
                fontSize: 22,
                color: Colors.grey[800],
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            ..._buildDestinationRows(isMobile),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDestinationRows(bool isMobile) {
    final destinations = [
      {
        'title': 'Boracay',
        'subtitle': 'White Beach Paradise',
        'description':
            'Famous for its powdery white sand and crystal clear waters',
        'image': 'assets/images/backgrounds/boracay.jpg',
        'region': 'Western Visayas',
      },
      {
        'title': 'Chocolate Hills',
        'subtitle': 'Bohol’s Natural Wonder',
        'description': 'Unique geological formations that turn brown in summer',
        'image': 'assets/images/backgrounds/chocolatehills.jpg',
        'region': 'Central Visayas',
      },
      {
        'title': 'Mayon Volcano',
        'subtitle': 'Perfect Cone Beauty',
        'description': 'World’s most perfectly formed volcano',
        'image': 'assets/images/backgrounds/mayonvolcano.jpg',
        'region': 'Bicol Region',
      },
      {
        'title': 'Vigan Heritage',
        'subtitle': 'UNESCO World Heritage',
        'description': 'Spanish colonial architecture and cobblestone streets',
        'image': 'assets/images/backgrounds/vigan.jpg',
        'region': 'Ilocos Region',
      },
      {
        'title': 'Siargao Island',
        'subtitle': 'Surfing Capital',
        'description': 'Famous for Cloud 9 surf break and pristine beaches',
        'image': 'assets/images/backgrounds/siargao.jpg',
        'region': 'Caraga Region',
      },
      {
        'title': 'Coron Island',
        'subtitle': 'Underwater Paradise',
        'description': 'Crystal clear waters and world-class diving spots',
        'image': 'assets/images/backgrounds/coron.jpg',
        'region': 'MIMAROPA',
      },
      {
        'title': 'Siquijor Island',
        'subtitle': 'Mystical Island',
        'description':
            'Known for its mystical traditions and beautiful waterfalls',
        'image': 'assets/images/backgrounds/siquijor.jpg',
        'region': 'Central Visayas',
      },
      {
        'title': 'Batanes Islands',
        'subtitle': 'Northern Paradise',
        'description':
            'Rolling hills and stone houses with stunning landscapes',
        'image': 'assets/images/backgrounds/batanes.jpg',
        'region': 'Cagayan Valley',
      },
      {
        'title': 'Rice Terraces',
        'subtitle': 'Eighth Wonder',
        'description': 'Ancient terraces carved into the mountainside',
        'image': 'assets/images/backgrounds/riceteracess.jpg',
        'region': 'Cordillera Region',
      },
    ];
    final rows = <Widget>[];
    final cardsPerRow = isMobile ? 1 : 3;
    for (int i = 0; i < destinations.length; i += cardsPerRow) {
      final rowCards = <Widget>[];
      for (int j = i; j < i + cardsPerRow && j < destinations.length; j++) {
        rowCards.add(
          Expanded(
            child: _buildDestinationCard(
              title: destinations[j]['title']!,
              subtitle: destinations[j]['subtitle']!,
              description: destinations[j]['description']!,
              image: destinations[j]['image']!,
              region: destinations[j]['region']!,
            ),
          ),
        );
        if (j < i + cardsPerRow - 1 && j < destinations.length - 1) {
          rowCards.add(
              SizedBox(width: isMobile ? 0 : 40, height: isMobile ? 40 : 0));
        }
      }
      rows.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start, children: rowCards));
      if (i + cardsPerRow < destinations.length) {
        rows.add(const SizedBox(height: 60));
      }
    }
    return rows;
  }

  Widget _buildDestinationCard({
    required String title,
    required String subtitle,
    required String description,
    required String image,
    required String region,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.cover,
                    opacity: 0.95,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        region,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D47A1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCTA() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0D47A1).withOpacity(0.9),
            const Color(0xFF1976D2).withOpacity(0.9),
            const Color(0xFF42A5F5).withOpacity(0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/backgrounds/collage.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start Your Philippine Adventure!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStoreButton(store: 'google', onPressed: () {}),
                      const SizedBox(width: 24),
                      _buildStoreButton(store: 'apple', onPressed: () {}),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      decoration: const BoxDecoration(color: Color(0xFF0D47A1)),
      child: Column(
        children: [
          Text(
            'Discover Philippines - Your Ultimate Travel Companion',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSlide(
            offset: Offset(0, _destinationsController.value * -0.2),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            child: Text(
              'All rights reserved. © ${DateTime.now().year}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
