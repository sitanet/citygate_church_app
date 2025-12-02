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
  List<Object?> get props => [];
}

class HomeDataRequested extends HomeEvent {}

class RefreshRequested extends HomeEvent {}

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
  List<Object?> get props => [recentContent, upcomingEvents];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetRecentContent getRecentContent;
  final GetUpcomingEvents getUpcomingEvents;

  HomeBloc({
    required this.getRecentContent,
    required this.getUpcomingEvents,
  }) : super(HomeInitial()) {
    on<HomeDataRequested>(_onHomeDataRequested);
    on<RefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onHomeDataRequested(
    HomeDataRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    await _loadHomeData(emit);
  }

  Future<void> _onRefreshRequested(
    RefreshRequested event,
    Emitter<HomeState> emit,
  ) async {
    await _loadHomeData(emit);
  }

  Future<void> _loadHomeData(Emitter<HomeState> emit) async {
    try {
      final recentContent = await getRecentContent(NoParams());
      final upcomingEvents = await getUpcomingEvents(NoParams());
      
      emit(HomeLoaded(
        recentContent: recentContent,
        upcomingEvents: upcomingEvents,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}