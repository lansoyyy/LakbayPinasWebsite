import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../services/geolocation_service.dart';

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

  // NEW: Additional controllers for enhanced animations
  late AnimationController _pulseController;
  late AnimationController _floatingController;
  late AnimationController _shimmerController;

  late Timer _timer;
  final ScrollController _pageScrollController = ScrollController();
  double _scrollOffset = 0.0;

  // Animation values
  late Animation<double> _heroFadeAnimation;
  late Animation<Offset> _heroSlideAnimation;
  late Animation<double> _heroScaleAnimation;
  late Animation<double> _featuresFadeAnimation;
  late Animation<Offset> _featuresSlideAnimation;
  late Animation<double> _videoFadeAnimation;

  // NEW: Enhanced animations
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _shimmerAnimation;

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

  // NEW: Country detection variables
  Map<String, dynamic>? userLocationData;
  bool isLoadingLocation = true;
  String welcomeMessage = 'Welcome to Discover Philippines!';

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

    // NEW: Enhanced animation controllers
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _floatingController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _shimmerController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

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

    _videoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _videoController, curve: Curves.easeOutCubic),
    );

    // NEW: Enhanced animations
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Start animations
    _heroController.forward();
    _pulseController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
    _shimmerController.repeat();

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

    // Optimized scroll listener with throttling for better performance
    _pageScrollController.addListener(() {
      final newOffset = _pageScrollController.offset;
      // Throttle scroll updates to reduce setState calls
      if ((newOffset - _scrollOffset).abs() > 10) {
        setState(() {
          _scrollOffset = newOffset;
        });
      }
    });

    // Slower carousel for better performance
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      setState(() {
        index = (index + 1) % images.length;
      });
    });

    // NEW: Get user's country on app start
    _detectUserCountry();
  }

  // NEW: Method to detect user's country
  Future<void> _detectUserCountry() async {
    try {
      Map<String, dynamic>? locationData;

      locationData = await GeolocationService.getUserCountry();

      if (mounted) {
        setState(() {
          userLocationData = locationData;
          isLoadingLocation = false;

          if (locationData != null) {
            welcomeMessage = GeolocationService.getWelcomeMessage(locationData);
          } else {
            welcomeMessage = 'Welcome to Discover Philippines!';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingLocation = false;
          welcomeMessage = 'Welcome to Discover Philippines!';
        });
      }
    }
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
    _pulseController.dispose();
    _floatingController.dispose();
    _shimmerController.dispose();
    _pageScrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _pageScrollController,
            child: Column(
              children: [
                _buildHeroSection(context),
                _buildStatsSection(context),
                _buildFeaturesSection(context),
                _buildVideoSection(),
                _buildDestinationsSection(context),
                _buildTestimonialsSection(context),
                _buildBottomCTA(),
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
      // NEW: Floating action button for scroll to top
      floatingActionButton: _scrollOffset > 500
          ? AnimatedOpacity(
              opacity: _scrollOffset > 500 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0D47A1),
                      const Color(0xFF42A5F5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D47A1).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    _pageScrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                    );
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(Icons.keyboard_arrow_up,
                      color: Colors.white, size: 30),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return SlideTransition(
      position: _heroSlideAnimation,
      child: FadeTransition(
        opacity: _heroFadeAnimation,
        child: Container(
          height: isMobile ? 1750 : 850,
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
              // NEW: Enhanced parallax background
              Positioned.fill(
                child: Transform.translate(
                  offset: Offset(0, _scrollOffset * 0.5),
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
              ),

              // Reduced particles for better performance (8 instead of 25)
              ...List.generate(8, (index) => _buildFloatingParticle(index)),

              // NEW: Geometric decorative elements
              _buildGeometricDecorations(),

              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
                  child: isMobile
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            // NEW: Add floating animation to phone mockup
                            AnimatedBuilder(
                              animation: _floatingAnimation,
                              child: ScaleTransition(
                                scale: _heroScaleAnimation,
                                child: _buildHeroPhoneMockup(),
                              ),
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatingAnimation.value),
                                  child: child,
                                );
                              },
                            ),
                            const SizedBox(height: 60),
                            _buildHeroTextAndButtons(isMobile),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // NEW: Add floating animation to phone mockup
                            AnimatedBuilder(
                              animation: _floatingAnimation,
                              child: ScaleTransition(
                                scale: _heroScaleAnimation,
                                child: _buildHeroPhoneMockup(),
                              ),
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _floatingAnimation.value),
                                  child: child,
                                );
                              },
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

  // NEW: Enhanced floating particles with varied sizes and speeds
  Widget _buildFloatingParticle(int index) {
    final size = (index % 4 + 1) * 1.5;
    final speed = (index % 3 + 1) * 0.3;

    return AnimatedBuilder(
      animation: _heroController,
      builder: (context, child) {
        final progress = _heroController.value;
        final offset = (index % 3 + 1) * progress * speed;
        return Positioned(
          left: (index * 60.0) % MediaQuery.of(context).size.width,
          top: (index * 40.0) % 500 + offset * 25,
          child: Opacity(
            opacity: (0.15 + (index % 4) * 0.05) * progress,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: index % 3 == 0
                    ? Colors.white
                    : index % 3 == 1
                        ? Colors.amber[200]
                        : Colors.blue[200],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // NEW: Geometric decorative elements
  Widget _buildGeometricDecorations() {
    return Stack(
      children: [
        // Pulsing circle
        Positioned(
          top: 120,
          right: 80,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Floating square
        Positioned(
          bottom: 200,
          left: 100,
          child: AnimatedBuilder(
            animation: _floatingController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_floatingAnimation.value * 0.5,
                    _floatingAnimation.value * 0.3),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Triangle decoration
        Positioned(
          top: 300,
          left: 50,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _pulseController.value * 2 * math.pi,
                child: CustomPaint(
                  size: const Size(30, 30),
                  painter: TrianglePainter(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
                          // NEW: Enhanced glow effect
                          BoxShadow(
                            color: const Color(0xFF42A5F5).withOpacity(0.2),
                            blurRadius: 30 * scaleFactor,
                            offset: Offset(0, 0),
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
                                    // Optimized image carousel with simple transition
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      transitionBuilder: (child, animation) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      child: Stack(
                                        key: ValueKey<int>(index),
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/backgrounds/${images[index]}'),
                                                fit: BoxFit.cover,
                                                opacity: 0.95,
                                              ),
                                            ),
                                          ),
                                          // NEW: Subtle overlay gradient
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Colors.transparent,
                                                  Colors.black.withOpacity(0.2),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // NEW: Image indicators
                                    Positioned(
                                      bottom: 20,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                          images.length,
                                          (dotIndex) => AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 3),
                                            width: dotIndex == index ? 20 : 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: dotIndex == index
                                                  ? Colors.white
                                                  : Colors.white
                                                      .withOpacity(0.4),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              boxShadow: dotIndex == index
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.white
                                                            .withOpacity(0.5),
                                                        blurRadius: 8,
                                                        offset:
                                                            const Offset(0, 0),
                                                      ),
                                                    ]
                                                  : null,
                                            ),
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
                                  // NEW: Enhanced glow for special button
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.4),
                                    blurRadius: 8 * scaleFactor,
                                    offset: Offset(0, 0),
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
                child: Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isMobile
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    // NEW: Enhanced app icon with pulse animation
                                    AnimatedBuilder(
                                      animation: _pulseController,
                                      builder: (context, child) {
                                        return Transform.scale(
                                          scale: _pulseAnimation.value,
                                          child: Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.white
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 0),
                                                ),
                                              ],
                                            ),
                                            child: Image.asset(
                                                'assets/images/icon.png',
                                                width: 50,
                                                height: 50),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                    Flexible(
                                      child: ShaderMask(
                                        shaderCallback: (bounds) =>
                                            const LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Color(0xFFE3F2FD)
                                          ],
                                        ).createShader(bounds),
                                        child: Text(
                                          'Discover Philippines',
                                          style: GoogleFonts.poppins(
                                            fontSize: 26,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black
                                                    .withOpacity(0.4),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                              ],
                            )
                          : Row(
                              children: [
                                // NEW: Enhanced app icon with pulse animation
                                AnimatedBuilder(
                                  animation: _pulseController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            width: 2,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.1),
                                              blurRadius: 15,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                        ),
                                        child: Image.asset(
                                            'assets/images/icon.png',
                                            width: 80,
                                            height: 80),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 24),
                                ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [Colors.white, Color(0xFFE3F2FD)],
                                  ).createShader(bounds),
                                  child: Text(
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
                                ),
                              ],
                            ),
                      const SizedBox(height: 40),

                      // NEW: Dynamic welcome message with country detection
                      if (isLoadingLocation)
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Detecting your location...',
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 14 : 18,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFFFFE0B2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            welcomeMessage,
                            style: GoogleFonts.poppins(
                              fontSize: isMobile ? 18 : 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      const SizedBox(height: 20),

                      // NEW: Enhanced main title with gradient text
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFFFF3E0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          'Explore 7,641 Islands of Paradise',
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 28 : 64,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: isMobile ? 1.2 : 1.8,
                            height: isMobile ? 1.2 : 1.1,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          maxLines: isMobile ? 3 : 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign:
                              isMobile ? TextAlign.center : TextAlign.start,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // NEW: Enhanced description with glassmorphism container
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Text(
                          userLocationData != null
                              ? 'Plan your unforgettable journey from ${userLocationData!['country']} to the Philippines with curated destinations, from pristine beaches to vibrant festivals.'
                              : 'Plan your unforgettable journey through the Philippines with curated destinations, from pristine beaches to vibrant festivals.',
                          style: TextStyle(
                              fontSize: isMobile ? 14 : 24,
                              color: Colors.white.withOpacity(0.95),
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Medium'),
                          maxLines: isMobile ? 4 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // NEW: Enhanced call-to-action badge with shimmer effect
                      AnimatedBuilder(
                        animation: _shimmerController,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber[200]!.withOpacity(0.3),
                                  Colors.orange[200]!.withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: Colors.amber[200]!.withOpacity(0.6),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.amber[200]!.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber[200],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Your Adventure Awaits!',
                                      style: GoogleFonts.poppins(
                                        fontSize: isMobile ? 15 : 22,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.amber[200],
                                      ),
                                    ),
                                  ],
                                ),
                                // NEW: Shimmer effect
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment(
                                              -1.0 + _shimmerAnimation.value,
                                              0.0),
                                          end: Alignment(
                                              1.0 + _shimmerAnimation.value,
                                              0.0),
                                          colors: [
                                            Colors.transparent,
                                            Colors.white.withOpacity(0.2),
                                            Colors.transparent,
                                          ],
                                          stops: const [0.0, 0.5, 1.0],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // NEW: Country indicator (only show if location is detected)
                      if (userLocationData != null && !isLoadingLocation)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Visiting from ${userLocationData!['country']}',
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 12 : 14,
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                ),
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
                                  onPressed: () async {
                                    if (userLocationData!['country'] ==
                                            'Philippines' ||
                                        userLocationData!['country'] == 'PH') {
                                      launchUrlString(
                                          'https://play.google.com/store/apps/details?id=com.algovision.discoverph');
                                    } else {
                                      launchUrlString(
                                          'https://play.google.com/store/apps/details?id=com.algovision.phdiscover');
                                    }
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
                                    if (userLocationData!['country'] ==
                                            'Philippines' ||
                                        userLocationData!['country'] == 'PH') {
                                      launchUrlString(
                                          'https://play.google.com/store/apps/details?id=com.algovision.discoverph');
                                    } else {
                                      launchUrlString(
                                          'https://play.google.com/store/apps/details?id=com.algovision.phdiscover');
                                    }
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
                  colors: store == 'google'
                      ? [
                          const Color(0xFF0288D1),
                          const Color(0xFF42A5F5).withOpacity(0.9),
                          const Color(0xFF90CAF9).withOpacity(0.8),
                        ]
                      : [
                          Colors.grey[600]!,
                          Colors.grey[700]!,
                          Colors.grey[800]!,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18 * scaleFactor),
                boxShadow: [
                  BoxShadow(
                    color: store == 'google'
                        ? const Color(0xFF0288D1).withOpacity(0.4)
                        : Colors.black.withOpacity(0.25),
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
                  // NEW: Enhanced icon container
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      store == 'google'
                          ? FontAwesomeIcons.googlePlay
                          : FontAwesomeIcons.apple,
                      color: Colors.white,
                      size: 32 * scaleFactor,
                    ),
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

  Widget _buildStatsSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 100, horizontal: isMobile ? 20 : 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0D47A1).withOpacity(0.95),
            const Color(0xFF1976D2).withOpacity(0.9),
            const Color(0xFF42A5F5).withOpacity(0.85),
          ],
        ),
      ),
      child: Column(
        children: [
          // Promotional heading
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFFFFF3E0)],
            ).createShader(bounds),
            child: Text(
              'Join Millions of Happy Travelers!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: isMobile ? 32 : 44,
                fontWeight: FontWeight.w800,
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
          ),
          const SizedBox(height: 20),
          Text(
            'Discover Philippines is the #1 travel app for exploring the beauty of the Philippines',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 16 : 20,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  children: [
                    // _buildStatCard(
                    //   icon: FontAwesomeIcons.download,
                    //   number: '500K+',
                    //   label: 'App Downloads',
                    //   color: Colors.amber[300]!,
                    // ),
                    // const SizedBox(height: 40),
                    _buildStatCard(
                      icon: FontAwesomeIcons.mapLocationDot,
                      number: '7,641',
                      label: 'Islands to Explore',
                      color: Colors.green[300]!,
                    ),
                    const SizedBox(height: 40),
                    _buildStatCard(
                      icon: FontAwesomeIcons.users,
                      number: '2M+',
                      label: 'Happy Travelers',
                      color: Colors.orange[300]!,
                    ),
                    const SizedBox(height: 40),
                    _buildStatCard(
                      icon: FontAwesomeIcons.star,
                      number: '5.0★',
                      label: 'App Store Rating',
                      color: Colors.pink[300]!,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Expanded(
                    //   child: _buildStatCard(
                    //     icon: FontAwesomeIcons.download,
                    //     number: '500K+',
                    //     label: 'App Downloads',
                    //     color: Colors.amber[300]!,
                    //   ),
                    // ),
                    Expanded(
                      child: _buildStatCard(
                        icon: FontAwesomeIcons.mapLocationDot,
                        number: '7,641',
                        label: 'Islands to Explore',
                        color: Colors.green[300]!,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        icon: FontAwesomeIcons.users,
                        number: '2M+',
                        label: 'Happy Travelers',
                        color: Colors.orange[300]!,
                      ),
                    ),
                    Expanded(
                      child: _buildStatCard(
                        icon: FontAwesomeIcons.star,
                        number: '5.0★',
                        label: 'App Store Rating',
                        color: Colors.pink[300]!,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String number,
    required String label,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _featuresController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - _featuresController.value)),
          child: Opacity(
            opacity: _featuresController.value,
            child: Container(
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    number,
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
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
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                    ),
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
                            // NEW: Enhanced section title with gradient
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                              ).createShader(bounds),
                              child: Text(
                                'Why Discover Philippines?',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
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
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: 340,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(hovered ? 0.2 : 0.15),
                    blurRadius: hovered ? 20 : 15,
                    offset: Offset(0, hovered ? 12 : 8),
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
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(hovered ? 20 : 18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withOpacity(hovered ? 0.2 : 0.1),
                          color.withOpacity(hovered ? 0.15 : 0.08),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(hovered ? 0.3 : 0.2),
                          blurRadius: hovered ? 15 : 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: color, size: hovered ? 70 : 65),
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
                    width: hovered ? 80 : 50,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.6)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: hovered
                          ? [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                              ),
                            ]
                          : null,
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
                    // NEW: Enhanced section title
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                      ).createShader(bounds),
                      child: Text(
                        'See the App in Action',
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF0288D1).withOpacity(0.1),
                            const Color(0xFF42A5F5).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF0288D1).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Join thousands of travelers today!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0288D1),
                        ),
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
                              // NEW: Enhanced shadow
                              BoxShadow(
                                color: const Color(0xFF0288D1).withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 0),
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
                          child: AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black.withOpacity(0.6),
                                        Colors.black.withOpacity(0.4),
                                      ],
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    FontAwesomeIcons.play,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
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
                          // NEW: Enhanced section title
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                            ).createShader(bounds),
                            child: Text(
                              'See the App in Action',
                              style: GoogleFonts.poppins(
                                fontSize: 44,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF0288D1).withOpacity(0.1),
                                  const Color(0xFF42A5F5).withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: const Color(0xFF0288D1).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'Join thousands of travelers today!',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0288D1),
                              ),
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
                                // NEW: Enhanced shadow
                                BoxShadow(
                                  color:
                                      const Color(0xFF0288D1).withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 0),
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
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.black.withOpacity(0.6),
                                          Colors.black.withOpacity(0.4),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      FontAwesomeIcons.play,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                                );
                              },
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
      opacity: _featuresController,
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
            // NEW: Enhanced section title
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
              ).createShader(bounds),
              child: Text(
                'Top Destinations',
                style: GoogleFonts.poppins(
                  fontSize: 44,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
            ),
            const SizedBox(height: 20),
            Text(
              "Explore the Philippines' most stunning locations",
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
        'subtitle': "Bohol's Natural Wonder",
        'description': 'Unique geological formations that turn brown in summer',
        'image': 'assets/images/backgrounds/chocolatehills.jpg',
        'region': 'Central Visayas',
      },
      {
        'title': 'Mayon Volcano',
        'subtitle': 'Perfect Cone Beauty',
        'description': "World's most perfectly formed volcano",
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
    final ValueNotifier<bool> isHovered = ValueNotifier(false);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: isHovered,
        builder: (context, hovered, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            transform: Matrix4.identity()..scale(hovered ? 1.01 : 1.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(hovered ? 0.15 : 0.1),
                  blurRadius: hovered ? 15 : 12,
                  offset: Offset(0, hovered ? 8 : 6),
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
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF0D47A1).withOpacity(0.15),
                              const Color(0xFF42A5F5).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF0D47A1).withOpacity(0.2),
                            width: 1,
                          ),
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
          );
        },
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 120, horizontal: isMobile ? 20 : 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF8FBFF),
            const Color(0xFFE8F4FD).withOpacity(0.95),
          ],
        ),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
            ).createShader(bounds),
            child: Text(
              'What Travelers Say',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Real experiences from real travelers using Discover Philippines',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 60),
          isMobile
              ? Column(
                  children: [
                    _buildTestimonialCard(
                      name: 'Maria Santos',
                      location: 'Manila',
                      rating: 5,
                      review:
                          'This app made planning our Palawan trip so easy! The interactive maps and destination guides were incredibly helpful.',
                      avatar: '👩‍💼',
                    ),
                    const SizedBox(height: 30),
                    _buildTestimonialCard(
                      name: 'John Rodriguez',
                      location: 'Cebu',
                      rating: 5,
                      review:
                          'I discovered hidden gems in Bohol thanks to this app. The festival calendar feature helped me time my visit perfectly!',
                      avatar: '👨',
                    ),
                    const SizedBox(height: 30),
                    _buildTestimonialCard(
                      name: 'Sarah Kim',
                      location: 'South Korea',
                      rating: 5,
                      review:
                          'As a foreign traveler, this app was a lifesaver! The local cuisine recommendations were spot on.',
                      avatar: '👩‍🎨',
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildTestimonialCard(
                        name: 'Maria Santos',
                        location: 'Manila',
                        rating: 5,
                        review:
                            'This app made planning our Palawan trip so easy! The interactive maps and destination guides were incredibly helpful.',
                        avatar: '👩‍💼',
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildTestimonialCard(
                        name: 'John Rodriguez',
                        location: 'Cebu',
                        rating: 5,
                        review:
                            'I discovered hidden gems in Bohol thanks to this app. The festival calendar feature helped me time my visit perfectly!',
                        avatar: '👨',
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildTestimonialCard(
                        name: 'Sarah Kim',
                        location: 'South Korea',
                        rating: 5,
                        review:
                            'As a foreign traveler, this app was a lifesaver! The local cuisine recommendations were spot on.',
                        avatar: '👩‍🎨',
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 60),
          // Call-to-action within testimonials
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0288D1).withOpacity(0.1),
                  const Color(0xFF42A5F5).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: const Color(0xFF0288D1).withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Text(
                  '🌟 Join 2,000,000+ Happy Travelers',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0288D1),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Download now and start your Philippine adventure today!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard({
    required String name,
    required String location,
    required int rating,
    required String review,
    required String avatar,
  }) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF0288D1).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF42A5F5).withOpacity(0.2),
                      const Color(0xFF0288D1).withOpacity(0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    avatar,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D47A1),
                      ),
                    ),
                    Text(
                      location,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: Colors.amber[600],
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '"$review"',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
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
          // NEW: Enhanced parallax background
          Positioned.fill(
            child: Transform.translate(
              offset: Offset(0, _scrollOffset * 0.3),
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
          ),

          // NEW: Floating geometric shapes
          ...List.generate(8, (index) => _buildCTAFloatingShape(index)),

          Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // NEW: Enhanced CTA title with shimmer effect
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment(-1.0 + _shimmerAnimation.value, 0.0),
                          end: Alignment(1.0 + _shimmerAnimation.value, 0.0),
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.8),
                            Colors.white,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ).createShader(bounds),
                        child: Text(
                          '🚀 Start Your Dream Adventure NOW!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: isMobile ? 32 : 48,
                            fontWeight: FontWeight.w900,
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
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildEnhancedStoreButton(
                                store: 'google',
                                onPressed: () {
                                  if (userLocationData!['country'] ==
                                          'Philippines' ||
                                      userLocationData!['country'] == 'PH') {
                                    launchUrlString(
                                        'https://play.google.com/store/apps/details?id=com.algovision.discoverph');
                                  } else {
                                    launchUrlString(
                                        'https://play.google.com/store/apps/details?id=com.algovision.phdiscover');
                                  }
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
                                  if (userLocationData!['country'] ==
                                          'Philippines' ||
                                      userLocationData!['country'] == 'PH') {
                                    launchUrlString(
                                        'https://play.google.com/store/apps/details?id=com.algovision.discoverph');
                                  } else {
                                    launchUrlString(
                                        'https://play.google.com/store/apps/details?id=com.algovision.phdiscover');
                                  }
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

  // NEW: Floating shapes for CTA section
  Widget _buildCTAFloatingShape(int index) {
    final size = (index % 3 + 1) * 15.0;
    final speed = (index % 2 + 1) * 0.4;

    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Positioned(
          left: (index * 80.0) % MediaQuery.of(context).size.width,
          top: (index * 60.0) % 300 + _floatingAnimation.value * speed,
          child: Opacity(
            opacity: 0.1,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: index % 2 == 0 ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: index % 2 == 0 ? null : BorderRadius.circular(8),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildComingSoonDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              const Color(0xFFF8FBFF),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0D47A1),
                      Color(0xFF42A5F5),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 20,
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
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF0D47A1),
                    Color(0xFF42A5F5),
                  ],
                ).createShader(bounds),
                child: Text(
                  'Coming Soon!',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Discover Philippines is coming soon to the Apple App Store. Stay tuned for updates!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0D47A1),
                      Color(0xFF42A5F5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D47A1).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF0D47A1),
            const Color(0xFF1565C0),
          ],
        ),
      ),
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
          // Enhanced Social Media Icons
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
            offset: Offset(0, _featuresController.value * -0.2),
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
    final ValueNotifier<bool> isHovered = ValueNotifier(false);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => isHovered.value = true,
      onExit: (_) => isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: isHovered,
        builder: (context, hovered, child) {
          return GestureDetector(
            onTap: () async {
              try {
                await launchUrlString(url);
              } catch (e) {
                print('Could not launch $url');
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: hovered
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(hovered ? 0.4 : 0.2),
                  width: 1,
                ),
                boxShadow: hovered
                    ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ]
                    : null,
              ),
              child: AnimatedScale(
                scale: hovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// NEW: Custom painter for triangle decoration
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
