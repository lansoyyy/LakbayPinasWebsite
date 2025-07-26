import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lakbay_pinas/utils/colors.dart';
import 'package:lakbay_pinas/widgets/show.snackbar_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  late AnimationController _scrollController;
  late AnimationController _videoController;
  late AnimationController _ctaController;
  late AnimationController _footerController;
  late Timer _timer;

  // Animation values
  late Animation<double> _heroFadeAnimation;
  late Animation<Offset> _heroSlideAnimation;
  late Animation<double> _heroScaleAnimation;
  late Animation<double> _featuresFadeAnimation;
  late Animation<Offset> _featuresSlideAnimation;
  late Animation<double> _destinationsFadeAnimation;
  late Animation<Offset> _destinationsSlideAnimation;
  late Animation<double> _videoFadeAnimation;
  late Animation<double> _videoScaleAnimation;
  late Animation<double> _ctaFadeAnimation;
  late Animation<Offset> _ctaSlideAnimation;

  List<String> images = [
    'mayonvolcano.jpg',
    'food.jpg',
    'batanes.jpg',
    'maskarafestival.jpg',
    'onboarding2.jpg',
    'wangod.jpg',
    'siargao.jpg',
    'culture.jpg',
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _heroController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _featuresController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _destinationsController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _scrollController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _videoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _ctaController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _footerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    // Initialize animations
    _heroFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic),
    );
    _heroSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic));
    _heroScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.elasticOut),
    );

    _featuresFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _featuresController, curve: Curves.easeOutCubic),
    );
    _featuresSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _featuresController, curve: Curves.easeOutCubic));

    _destinationsFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _destinationsController, curve: Curves.easeOutCubic),
    );
    _destinationsSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _destinationsController, curve: Curves.easeOutCubic));

    _videoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _videoController, curve: Curves.easeOutCubic),
    );
    _videoScaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _videoController, curve: Curves.elasticOut),
    );

    _ctaFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctaController, curve: Curves.easeOutCubic),
    );
    _ctaSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _ctaController, curve: Curves.easeOutCubic));

    // Start animations
    _heroController.forward();
    Future.delayed(
        const Duration(milliseconds: 800), () => _featuresController.forward());
    Future.delayed(const Duration(milliseconds: 1200),
        () => _destinationsController.forward());
    Future.delayed(
        const Duration(milliseconds: 1600), () => _videoController.forward());
    Future.delayed(
        const Duration(milliseconds: 2000), () => _ctaController.forward());
    Future.delayed(
        const Duration(milliseconds: 2400), () => _footerController.forward());
    Future.delayed(
        const Duration(milliseconds: 1400), () => _scrollController.forward());

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
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
    _scrollController.dispose();
    _videoController.dispose();
    _ctaController.dispose();
    _footerController.dispose();
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
    return SlideTransition(
      position: _heroSlideAnimation,
      child: FadeTransition(
        opacity: _heroFadeAnimation,
        child: Container(
          height: isMobile ? 1500 : 850,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0D47A1).withOpacity(0.95),
                const Color(0xFF1976D2).withOpacity(0.9),
                const Color(0xFF42A5F5).withOpacity(0.8),
                const Color(0xFF90CAF9).withOpacity(0.7),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Animated background pattern
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _heroController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: 0.08 * _heroController.value,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/backgrounds/collage.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Floating particles effect
              ...List.generate(20, (index) => _buildFloatingParticle(index)),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
                  child: isMobile
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            ScaleTransition(
                              scale: _heroScaleAnimation,
                              child: _buildHeroPhoneMockup(),
                            ),
                            const SizedBox(height: 60),
                            _buildHeroTextAndButtons(isMobile),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ScaleTransition(
                              scale: _heroScaleAnimation,
                              child: _buildHeroPhoneMockup(),
                            ),
                            const SizedBox(width: 100),
                            Expanded(child: _buildHeroTextAndButtons(isMobile)),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    return AnimatedBuilder(
      animation: _heroController,
      builder: (context, child) {
        final progress = _heroController.value;
        final offset = (index % 3 + 1) * progress;
        return Positioned(
          left: (index * 50.0) % MediaQuery.of(context).size.width,
          top: (index * 30.0) % 400 + offset * 20,
          child: Opacity(
            opacity: 0.3 * progress,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeroPhoneMockup() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = MediaQuery.of(context).size.width < 600;
        final scaleFactor = isMobile ? 0.9 : 1.1;
        final phoneWidth = 380 * scaleFactor;
        final phoneHeight = 750 * scaleFactor;

        return AnimatedBuilder(
          animation: _heroController,
          builder: (context, child) {
            return Transform.translate(
                offset: Offset(0, 50 * (1 - _heroController.value)),
                child: AnimatedScale(
                  scale: 0.8 + (0.2 * _heroController.value),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.elasticOut,
                  child: Padding(
                    padding: EdgeInsets.all(24 * scaleFactor),
                    child: Container(
                      width: phoneWidth,
                      height: phoneHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey[300]!.withOpacity(0.95),
                            Colors.grey[900]!.withOpacity(0.98),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40 * scaleFactor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20 * scaleFactor,
                            offset: Offset(0, 10 * scaleFactor),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.15),
                            blurRadius: 8 * scaleFactor,
                            offset: Offset(-4 * scaleFactor, -4 * scaleFactor),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.grey[400]!.withOpacity(0.9),
                          width: 1.5 * scaleFactor,
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Inner screen
                          Positioned(
                            left: 8 * scaleFactor,
                            right: 8 * scaleFactor,
                            top: 8 * scaleFactor,
                            bottom: 8 * scaleFactor,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(36 * scaleFactor),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: Stack(
                                  children: [
                                    // Image carousel with enhanced transitions
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 800),
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: ScaleTransition(
                                            scale: Tween<double>(
                                                    begin: 1.1, end: 1.0)
                                                .animate(CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeOutCubic,
                                            )),
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
                                            opacity: 0.95,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Enhanced side buttons
                          Positioned(
                            left: -2 * scaleFactor,
                            top: phoneHeight * 0.15,
                            child: Container(
                              width: 4 * scaleFactor,
                              height: 60 * scaleFactor,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius:
                                    BorderRadius.circular(2 * scaleFactor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4 * scaleFactor,
                                    offset: Offset(0, 2 * scaleFactor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: -2 * scaleFactor,
                            top: phoneHeight * 0.25,
                            child: Container(
                              width: 4 * scaleFactor,
                              height: 30 * scaleFactor,
                              decoration: BoxDecoration(
                                color: Colors.orange[400],
                                borderRadius:
                                    BorderRadius.circular(2 * scaleFactor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.3),
                                    blurRadius: 4 * scaleFactor,
                                    offset: Offset(0, 2 * scaleFactor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: -2 * scaleFactor,
                            top: phoneHeight * 0.2,
                            child: Container(
                              width: 4 * scaleFactor,
                              height: 80 * scaleFactor,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius:
                                    BorderRadius.circular(2 * scaleFactor),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 4 * scaleFactor,
                                    offset: Offset(0, 2 * scaleFactor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          },
        );
      },
    );
  }

  Widget _buildHeroTextAndButtons(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _heroController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - _heroController.value)),
              child: Opacity(
                opacity: _heroController.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AnimatedScale(
                                    scale: 0.8 + (0.2 * _heroController.value),
                                    duration: const Duration(milliseconds: 800),
                                    child: Image.asset('assets/images/icon.png',
                                        width: 50, height: 50),
                                  ),
                                  const SizedBox(width: 16),
                                  Flexible(
                                    child: Text(
                                      'Discover Philippines',
                                      style: GoogleFonts.poppins(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                            color:
                                                Colors.black.withOpacity(0.4),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                            ],
                          )
                        : Row(
                            children: [
                              AnimatedScale(
                                scale: 0.8 + (0.2 * _heroController.value),
                                duration: const Duration(milliseconds: 800),
                                child: Image.asset('assets/images/icon.png',
                                    width: 80, height: 80),
                              ),
                              const SizedBox(width: 24),
                              Text(
                                'Discover Philippines',
                                style: GoogleFonts.poppins(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
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
                        fontSize: isMobile ? 32 : 64,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.8,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Plan your unforgettable journey through the Philippines with curated destinations, from pristine beaches to vibrant festivals.',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 16 : 24,
                        color: Colors.white.withOpacity(0.95),
                        height: 1.7,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber[200]!.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.amber[200]!.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Your Adventure Awaits!',
                        style: GoogleFonts.poppins(
                          fontSize: isMobile ? 15 : 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.amber[200],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildEnhancedStoreButton(
                                store: 'google',
                                onPressed: () async {
                                  launchUrlString(
                                      'https://play.google.com/store/apps/details?id=com.algovision.discoverph');
                                },
                              ),
                              const SizedBox(height: 20),
                              _buildEnhancedStoreButton(
                                store: 'apple',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        _buildComingSoonDialog(context),
                                  );
                                },
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildEnhancedStoreButton(
                                store: 'google',
                                onPressed: () async {
                                  launchUrlString(
                                      'https://play.google.com/store/apps/details?id=com.algovision.discoverph');
                                },
                              ),
                              const SizedBox(width: 32),
                              _buildEnhancedStoreButton(
                                store: 'apple',
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        _buildComingSoonDialog(context),
                                  );
                                },
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEnhancedStoreButton(
      {required String store, required VoidCallback onPressed}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = MediaQuery.of(context).size.width < 600;
        final scaleFactor = isMobile ? 0.9 : 1.0;
        final maxWidth =
            constraints.maxWidth > 400 ? 320.0 : constraints.maxWidth * 0.8;

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: store == 'google' ? onPressed : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                  horizontal: 32 * scaleFactor, vertical: 18 * scaleFactor),
              constraints: BoxConstraints(
                  minWidth: 220 * scaleFactor, maxWidth: maxWidth),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0288D1),
                    const Color(0xFF42A5F5).withOpacity(0.9),
                    const Color(0xFF90CAF9).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18 * scaleFactor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15 * scaleFactor,
                    offset: Offset(0, 8 * scaleFactor),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.1),
                    blurRadius: 8 * scaleFactor,
                    offset: Offset(-3 * scaleFactor, -3 * scaleFactor),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
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
                    size: 40 * scaleFactor,
                  ),
                  SizedBox(width: 16 * scaleFactor),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store == 'google' ? 'GET IT ON' : 'Soon on',
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12 * scaleFactor,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        store == 'google' ? 'Google Play' : 'App Store',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22 * scaleFactor,
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
    return SlideTransition(
        position: _featuresSlideAnimation,
        child: FadeTransition(
          opacity: _featuresFadeAnimation,
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: 140, horizontal: isMobile ? 20 : 60),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFF8FBFF),
                  const Color(0xFFE8F4FD).withOpacity(0.95),
                  const Color(0xFFF0F8FF).withOpacity(0.9),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _featuresController,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - _featuresController.value)),
                      child: Opacity(
                        opacity: _featuresController.value,
                        child: Column(
                          children: [
                            Text(
                              'Why Discover Philippines?',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0D47A1),
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Discover features to make your trip unforgettable',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 80),
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
                            description:
                                'Bookmark destinations for easy planning.',
                            color: const Color(0xFFD81B60),
                          ),
                          const SizedBox(height: 32),
                          _buildFeatureCard(
                            icon: FontAwesomeIcons.magnifyingGlass,
                            title: 'Smart Search',
                            description:
                                'Find destinations with powerful filters.',
                            color: const Color(0xFF388E3C),
                          ),
                          const SizedBox(height: 32),
                          _buildFeatureCard(
                            icon: FontAwesomeIcons.earthAsia,
                            title: 'Region Explorer',
                            description:
                                'Explore 17 regions with detailed guides.',
                            color: const Color(0xFFFBC02D),
                          ),
                          const SizedBox(height: 32),
                          _buildFeatureCard(
                            icon: FontAwesomeIcons.calendar,
                            title: 'Festival Calendar',
                            description:
                                'Plan visits around vibrant festivals.',
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
                                description:
                                    'Discover authentic Filipino dining.',
                                color: const Color(0xFFE64A19),
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ));
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    final ValueNotifier<bool> isHovered = ValueNotifier(false);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: GestureDetector(
        onTap: () {},
        child: ValueListenableBuilder<bool>(
          valueListenable: isHovered,
          builder: (context, hovered, child) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              width: 340,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(hovered ? 0.3 : 0.15),
                    blurRadius: hovered ? 20 : 12,
                    offset: Offset(0, hovered ? 12 : 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: color.withOpacity(hovered ? 0.3 : 0.1),
                  width: hovered ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.all(hovered ? 20 : 16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(hovered ? 0.15 : 0.1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(hovered ? 0.3 : 0.2),
                          blurRadius: hovered ? 15 : 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: AnimatedScale(
                      scale: hovered ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(icon, color: color, size: hovered ? 70 : 60),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D47A1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.6,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: hovered ? 60 : 40,
                    height: 3,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoSection() {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return FadeTransition(
      opacity: _videoFadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
            parent: _videoController, curve: Curves.easeOutCubic)),
        child: Container(
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
        ),
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
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Container(
      height: isMobile ? 500 : 400,
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
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildEnhancedStoreButton(
                                store: 'google',
                                onPressed: () {
                                  launchUrlString(
                                      'https://play.google.com/store/apps/details?id=com.algovision.discoverph');
                                }),
                            const SizedBox(height: 16),
                            _buildEnhancedStoreButton(
                              store: 'apple',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _buildComingSoonDialog(context),
                                );
                              },
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildEnhancedStoreButton(
                                store: 'google',
                                onPressed: () {
                                  launchUrlString(
                                      'https://play.google.com/store/apps/details?id=com.algovision.discoverph');
                                }),
                            const SizedBox(width: 24),
                            _buildEnhancedStoreButton(
                              store: 'apple',
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) =>
                                      _buildComingSoonDialog(context),
                                );
                              },
                            ),
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

  Widget _buildComingSoonDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0D47A1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: const Icon(
                Icons.apple,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Coming Soon!',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0D47A1),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Discover Philippines is coming soon to the Apple App Store.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
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
          const SizedBox(height: 30),
          // Social Media Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                icon: FontAwesomeIcons.facebook,
                url: 'https://www.facebook.com/discoverphilippines25',
                color: const Color(0xFF1877F2),
              ),
              const SizedBox(width: 20),
              _buildSocialIcon(
                icon: FontAwesomeIcons.instagram,
                url: 'https://www.instagram.com/_discoverphilippines/#',
                color: const Color(0xFFE4405F),
              ),
              const SizedBox(width: 20),
              _buildSocialIcon(
                icon: FontAwesomeIcons.tiktok,
                url: 'https://www.tiktok.com/@_discoverphilippines',
                color: const Color(0xFF000000),
              ),
            ],
          ),
          const SizedBox(height: 30),
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

  Widget _buildSocialIcon({
    required IconData icon,
    required String url,
    required Color color,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          try {
            await launchUrlString(url);
          } catch (e) {
            // Handle error if URL cannot be launched
            print('Could not launch $url');
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
