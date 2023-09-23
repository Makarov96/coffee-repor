import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.controller,
    required this.trigger,
  });
  final AnimationController controller;
  final VoidCallback trigger;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10).copyWith(
        top: 50,
      ),
      height: 80,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Color(0xFF425651),
                  size: 30,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.forward().then(
                    (value) {
                      trigger();
                    },
                  );
                },
                icon: const Icon(
                  Icons.shopping_basket_outlined,
                  color: Color(0xFF425651),
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double finalAngle = 0.0;
  double oldAngle = 0.0;
  double upsetAngle = 0.0;
  bool hasPressed = false;
  late PageController _scontroller;
  late AnimationController _animationController;
  late AnimationController _animationButtonController;
  late AnimationController _animationButton2Controller;
  late Animation<double> buttonAnimation;
  late Animation<double> button2Animation;
  late Animation<double> opacity;
  late AnimationController _animationPosition;
  late TabController _tabController;
  bool _aimatedOpacity = false;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _scontroller = PageController(
      initialPage: 0,
      viewportFraction: 1 / 8,
    );
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      upperBound: 1,
      duration: const Duration(
        seconds: 2,
      ),
    );
    _animationButtonController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );
    _animationButton2Controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );
    buttonAnimation = Tween<double>(
      begin: 1,
      end: 0.8,
    ).animate(
      CurvedAnimation(
        parent: _animationButtonController,
        curve: Curves.easeInCirc,
      ),
    );

    button2Animation = Tween<double>(
      begin: 1,
      end: 0.8,
    ).animate(
      CurvedAnimation(
        parent: _animationButton2Controller,
        curve: Curves.easeInCirc,
      ),
    );
    _animationPosition = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 200,
      ),
    );

    opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationPosition);
    super.initState();
  }

  var currenIndex = 4;
  CoffePackageService coffePackageService = CoffePackageService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF7CB9E),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: -100,
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 280,
              horizontal: 100,
            ),
            width: 200,
            height: 400,
            child: Stack(
              children: [
                PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  controller: _scontroller,
                  itemCount: KindOfCoffee.kindOfCoffees.length,
                  onPageChanged: (index) {
                    currenIndex = index;
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    return Center(
                      child: Text(
                        KindOfCoffee.kindOfCoffees[index].name,
                        style: TextStyle(
                            color: currenIndex == index
                                ? const Color(0xFF425651)
                                : const Color(0xFF425651).withOpacity(0.6),
                            fontWeight: FontWeight.w800,
                            fontSize: 20),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7CB9E),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 10,
                          offset: const Offset(0, 10),
                          blurRadius: 10,
                          color: const Color(0xFFF7CB9E).withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7CB9E),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 10,
                          offset: const Offset(0, -10),
                          blurRadius: 10,
                          color: const Color(0xFFF7CB9E).withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: -450,
          top: 0,
          bottom: 0,
          right: 0,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              Offset centerOfGestureDetector =
                  Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);

              return GestureDetector(
                onPanStart: (details) {
                  final touchPositionFromCenter =
                      details.localPosition - centerOfGestureDetector;
                  upsetAngle = oldAngle - touchPositionFromCenter.direction;
                },
                onPanEnd: (details) {
                  setState(
                    () {
                      oldAngle = finalAngle;
                    },
                  );
                },
                onPanUpdate: (details) {
                  final touchPositionFromCenter =
                      details.localPosition - centerOfGestureDetector;

                  setState(
                    () {
                      finalAngle =
                          (touchPositionFromCenter.direction + upsetAngle)
                              .clamp(0.0, 8.0);
                    },
                  );
                  _scontroller.animateToPage(
                    finalAngle.toInt(),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.decelerate,
                  );
                },
                child: Transform.rotate(
                  alignment: Alignment.center,
                  angle: finalAngle,
                  child: Image.asset(
                    'assets/coffe-image.png',
                    height: 500,
                    width: 500,
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              CustomAppBar(
                controller: _animationController,
                trigger: () {
                  _aimatedOpacity = true;
                  setState(() {});
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF425651),
                isScrollable: true,
                tabs: const [
                  Text(
                    'Seafood',
                    style: TextStyle(
                      color: Color(0xFF425651),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Indian',
                    style: TextStyle(
                      color: Color(0xFF425651),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Italian',
                    style: TextStyle(
                      color: Color(0xFF425651),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'China',
                    style: TextStyle(color: Color(0xFF425651), fontSize: 20),
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const FavoriteButton(),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  _animationButtonController.forward().then((value) {
                    _animationButtonController.reverse();
                  });
                  _animationPosition.forward();
                  coffePackageService.updatePosition(top: -785, left: 400);
                },
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll<Color>(
                    Color(0xFF425651),
                  ),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                child: AnimatedBuilder(
                  animation: _animationButtonController,
                  builder: (BuildContext context, Widget? child) {
                    return SizedBox(
                      width: buttonAnimation.value * 300,
                      height: buttonAnimation.value * 60,
                      child: const Center(
                        child: Text(
                          'ADD TO CARD',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFF7CB9E),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        AnimatedBuilder(
          animation: coffePackageService,
          child: AnimatedBuilder(
            animation: _animationPosition,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: coffePackageService.itemWeight,
                height: coffePackageService.itemHeight,
                decoration: coffePackageService.isNewBuy
                    ? const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      )
                    : BoxDecoration(
                        color:
                            const Color(0xFF425651).withOpacity(opacity.value),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          opacity: opacity.value,
                          fit: BoxFit.scaleDown,
                          image: const AssetImage(
                            'assets/coffe.png',
                          ),
                        ),
                      ),
              );
            },
          ),
          builder: (context, child) {
            return AnimatedPositioned(
              duration: const Duration(milliseconds: 1500),
              top: coffePackageService.getTop,
              bottom: coffePackageService.getBottom,
              left: coffePackageService.getLeft,
              child: child!,
              onEnd: () {
                coffePackageService.updateContainer(
                  height: 12,
                  width: 12,
                );
                setState(() {});
              },
            );
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          top: -20,
          child: AnimatedBuilder(
            animation: _animationController.view,
            child: Container(
              width: double.infinity,
              height: 750,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 15,
                    blurRadius: 10,
                  )
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _aimatedOpacity ? 1.0 : 0.0,
                    child: Container(
                      height: 100,
                      width: 350,
                      padding: const EdgeInsetsDirectional.all(20),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            foregroundImage: NetworkImage(
                              KindOfCoffee.kindOfCoffees[currenIndex].path,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            KindOfCoffee.kindOfCoffees[currenIndex].name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        _animationButton2Controller.forward().then((value) {
                          _animationButton2Controller.reverse();
                        });

                        if (_animationController.status ==
                            AnimationStatus.completed) {
                          _animationController.reverse();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll<Color>(
                          Color(0xFF425651),
                        ),
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      child: AnimatedBuilder(
                        animation: _animationButton2Controller,
                        builder: (BuildContext context, Widget? child) {
                          return SizedBox(
                            width: button2Animation.value * 300,
                            height: button2Animation.value * 60,
                            child: const Center(
                              child: Text(
                                'CHECKOUT',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFFF7CB9E),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            builder: (BuildContext context, Widget? child) {
              final inverse = (_animationController.value - 1);
              return Transform(
                transform: Matrix4.identity()..setRotationX(pi * inverse),
                alignment: FractionalOffset.topCenter,
                child: child!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class CoffePackageService extends ChangeNotifier {
  double itemHeight = 50.0;
  double itemWeight = 50.0;
  bool isNewBuy = false;

  void updateContainer({
    required double height,
    required double width,
  }) {
    itemHeight = height;
    itemWeight = width;
    isNewBuy = true;
    notifyListeners();
  }

  void updatePosition({
    double? right,
    double? left,
    double? top,
    double? bottom,
  }) {
    setRight = right ?? this.right;
    setLeft = left ?? this.left;
    setTop = top ?? this.top;
    setBottom = bottom ?? this.bottom;
    notifyListeners();
  }

  void reset() {
    itemHeight = 50;
    itemWeight = 50;
    isNewBuy = false;

    right = 0;
    left = 0;
    top = 15;
    bottom = 0;
    notifyListeners();
  }

  double right = 0;
  double get getRight => right;

  set setRight(double right) => this.right = right;
  double left = 0;
  double get getLeft => left;
  set setLeft(double left) => this.left = left;

  double top = 15;
  double get getTop => top;
  set setTop(double top) => this.top = top;

  double bottom = 0;
  double get getBottom => bottom;
  set setBottom(double bottom) => this.bottom = bottom;
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF425651),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.favorite,
          color: Color(0xFFF7CB9E),
        ),
      ),
    );
  }
}

class KindOfCoffee {
  final String name;
  final String path;

  KindOfCoffee({
    required this.name,
    required this.path,
  });

  static List<KindOfCoffee> get kindOfCoffees => [
        KindOfCoffee(
          name: 'Coffee',
          path:
              'https://thewoodenskillet.com/wp-content/uploads/2022/08/how-to-use-a-french-press-coffee-maker-1.jpg',
        ),
        KindOfCoffee(
          name: 'Coffee expresso',
          path:
              'https://twochimpscoffee.com/wp-content/uploads/2023/01/perfect-crema-2-1024x870.jpg',
        ),
        KindOfCoffee(
          name: 'Coffee mocha',
          path:
              'https://athome.starbucks.com/sites/default/files/2021-06/1_CAH_CaffeMocha_Hdr_2880x16602.jpg',
        ),
        KindOfCoffee(
          name: 'Coffee Milk 1/4',
          path:
              'https://feelgoodfoodie.net/wp-content/uploads/2018/05/coconut-oil-coffee-9.jpg',
        ),
        KindOfCoffee(
          name: 'Coffee Milk 1/3',
          path:
              'https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2020/06/Cold-Brew-Coffee-3.jpg',
        ),
        KindOfCoffee(
          name: 'Coffee Milk 1/2',
          path:
              'https://urnex.com/media/magefan_blog/2019/10/milk-and-coffee.jpg',
        ),
        KindOfCoffee(
          name: 'Coffee frappuccino',
          path:
              'https://coffeeatthree.com/wp-content/uploads/starbucks-coffee-frappuccino-6.jpg',
        ),
      ];
}
