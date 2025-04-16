import 'package:avatar_glow/avatar_glow.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meal/core/theme/app_colors.dart';
import 'package:meal/core/utils/logger.dart';
import 'package:meal/core/utils/share_util.dart';
import 'package:meal/core/utils/url_launcher_util.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_bloc.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_event.dart';
import 'package:meal/features/meals/presentation/bloc/detail/meal_detail_state.dart';
import 'package:meal/shared/widgets/empty_widget.dart';
import 'package:meal/shared/widgets/error_widget.dart';
import 'package:meal/shared/widgets/extended_image_widget.dart';
import 'package:meal/shared/widgets/loading_widget.dart';

class MealDetailPage extends StatefulWidget {
  const MealDetailPage({super.key});

  @override
  State<MealDetailPage> createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _scrollProgress = 0.0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final progress = _scrollController.offset / 300;
    setState(() {
      _scrollProgress = progress.clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      return Scaffold(body: errorWidget(message: 'Error: Invalid arguments'));
    }

    final String mealId = args['id'] as String;
    final String? imageUrl = args['image'] as String?;
    final String? tag = args['tag'] ?? 'meal';

    Logger().i('tag meal: $tag');

    return Scaffold(
      body: BlocListener<MealDetailBloc, MealDetailState>(
        listener: (context, state) {
          if (state is MealDetailLoaded) {
            _animationController.forward();
          }

          if (state is MealDetailToggleLike) {
            CherryToast.success(
              title: Text(state.message),
              toastPosition: Position.bottom,
              animationCurve: Curves.easeInOut,
              animationType: AnimationType.fromBottom,
              animationDuration: const Duration(milliseconds: 200),
            ).show(context);
          }
        },
        child: BlocBuilder<MealDetailBloc, MealDetailState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Color.lerp(Colors.transparent, Colors.red, _scrollProgress),
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color.lerp(Colors.black38, Colors.transparent, _scrollProgress),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: BackButton(color: Colors.white),
                  ),
                  actions: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.lerp(Colors.black38, Colors.transparent, _scrollProgress),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: Icon(
                          state is MealDetailLoaded && state.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.white,
                        ),
                        onPressed: () => context.read<MealDetailBloc>().add(ToggleLike()),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color.lerp(Colors.black38, Colors.transparent, _scrollProgress),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () async {
                          if (state is MealDetailLoaded) {
                            try {
                              await ShareUtil.shareMeal(
                                title: state.meal.strMeal ?? '',
                                youtubeUrl: state.meal.strYoutube,
                              );
                            } catch (e) {
                              Logger().e('Error sharing meal: $e', tag: 'MealDetailPage');
                            }
                          }
                        },
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Hero(
                      tag: '$tag-image-$mealId',
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        child: extendedImage(imagePath: imageUrl ?? '', height: 300, width: double.infinity),
                      ),
                    ),
                    title: Text(
                      state is MealDetailLoaded ? state.meal.strMeal ?? '' : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(offset: Offset(0, 1), blurRadius: 3.0, color: Color.fromRGBO(0, 0, 0, 0.75))],
                      ),
                    ),
                  ),
                ),
                if (state is MealDetailLoading)
                  SliverFillRemaining(child: loadingWidget(message: 'Loading meal detail...'))
                else if (state is MealDetailError)
                  SliverFillRemaining(child: errorWidget(message: state.message))
                else if (state is MealDetailLoaded)
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, color: Color(0xff88879C)),
                                  Text(
                                    '${state.meal.intMinutes} min',
                                    style: const TextStyle(fontSize: 16, color: Color(0xff88879C)),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.remove_red_eye, color: Color(0xff88879C)),
                                  Text(
                                    '${state.meal.intViews} views',
                                    style: const TextStyle(fontSize: 16, color: Color(0xff88879C)),
                                  ),
                                  const SizedBox(width: 16),
                                  const Icon(Icons.restaurant, color: Color(0xff88879C)),
                                  Text(
                                    '${state.meal.intCalories} cal',
                                    style: const TextStyle(fontSize: 16, color: Color(0xff88879C)),
                                  ),
                                  const Spacer(),
                                  Visibility(
                                    visible: state.meal.strYoutube != null && state.meal.strYoutube!.isNotEmpty,
                                    child: AvatarGlow(
                                      glowColor: AppColors.primary,
                                      glowCount: 2,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.primary,
                                        ),
                                        child: IconButton(
                                          onPressed: () async {
                                            try {
                                              await UrlLauncherUtil.launchYoutube(state.meal.strYoutube ?? '');
                                            } catch (e) {
                                              Logger().e('Error launching YouTube: $e', tag: 'MealDetailPage');
                                            }
                                          },
                                          icon: Icon(Icons.play_arrow_rounded, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 26),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffF7FBFD),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => context.read<MealDetailBloc>().add(SelectIngredientsTab()),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                            color: state.isIngredientsSelected
                                                ? const Color(0xff222831)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: AnimatedDefaultTextStyle(
                                            duration: const Duration(milliseconds: 300),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  state.isIngredientsSelected ? Colors.white : const Color(0xff88879C),
                                            ),
                                            child: const Text('Ingredients', textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () => context.read<MealDetailBloc>().add(SelectInstructionsTab()),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                            color: !state.isIngredientsSelected
                                                ? const Color(0xff222831)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          padding: const EdgeInsets.all(16),
                                          child: AnimatedDefaultTextStyle(
                                            duration: const Duration(milliseconds: 300),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  !state.isIngredientsSelected ? Colors.white : const Color(0xff88879C),
                                            ),
                                            child: const Text('Instructions', textAlign: TextAlign.center),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child, Animation<double> animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.0, 0.1),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: state.isIngredientsSelected
                                    ? Column(
                                        key: const ValueKey('ingredients'),
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Ingredients',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 16),
                                          ...state.meal.ingredients.map(
                                            (ingredient) => Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: const BoxDecoration(
                                                      color: AppColors.primary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      ingredient,
                                                      style: const TextStyle(fontSize: 16, color: Color(0xff222831)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        key: const ValueKey('instructions'),
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Instructions',
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffF7FBFD),
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              state.meal.strInstructions ?? '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                height: 1.5,
                                                color: Color(0xff222831),
                                              ),
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverFillRemaining(child: emptyWidget(message: 'No meal detail found')),
              ],
            );
          },
        ),
      ),
    );
  }
}
