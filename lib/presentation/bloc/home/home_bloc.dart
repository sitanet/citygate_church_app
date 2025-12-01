import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/content.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/usecases/content/get_recent_content.dart';
import '../../../domain/usecases/content/get_upcoming_events.dart';
import '../../../core/usecase/usecase.dart';

// Events
abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeData extends HomeEvent {}

class RefreshHomeData extends HomeEvent {}

// States
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Content> recentContent;
  final List<Event> upcomingEvents;

  const HomeLoaded({
    required this.recentContent,
    required this.upcomingEvents,
  });

  @override
  List<Object> get props => [recentContent, upcomingEvents];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetRecentContent getRecentContent;
  final GetUpcomingEvents getUpcomingEvents;

  HomeBloc({
    required this.getRecentContent,
    required this.getUpcomingEvents,
  }) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    await _loadData(emit);
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<HomeState> emit) async {
    final recentContentResult = await getRecentContent(NoParams());
    final upcomingEventsResult = await getUpcomingEvents(NoParams());

    if (recentContentResult.isLeft() || upcomingEventsResult.isLeft()) {
      emit(const HomeError(message: 'Failed to load home data'));
      return;
    }

    final recentContent = recentContentResult.getOrElse(() => []);
    final upcomingEvents = upcomingEventsResult.getOrElse(() => []);

    emit(HomeLoaded(
      recentContent: recentContent,
      upcomingEvents: upcomingEvents,
    ));
  }
}