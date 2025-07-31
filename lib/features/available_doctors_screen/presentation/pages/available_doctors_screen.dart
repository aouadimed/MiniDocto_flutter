import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_user/core/constants/appcolors.dart';
import 'package:flutter_user/features/available_doctors_screen/data/models/available_doctor_model.dart';
import 'package:flutter_user/features/available_doctors_screen/presentation/bloc/available_doctors_screen_bloc.dart';
import 'package:flutter_user/features/available_doctors_screen/presentation/widgets/available_item.dart';
import 'package:flutter_user/features/available_doctors_screen/presentation/widgets/available_item_shimmer.dart';
import 'package:flutter_user/features/schedule_screen/presentation/bloc/schedule_bloc.dart';
import 'package:flutter_user/features/schedule_screen/presentation/pages/schedule_screen.dart';
import 'package:flutter_user/global/common_widget/app_bar.dart';
import 'package:flutter_user/injection_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AvailableDoctorsScreen extends StatefulWidget {
  const AvailableDoctorsScreen({super.key});

  @override
  State<AvailableDoctorsScreen> createState() => _AvailableDoctorsScreenState();
}

class _AvailableDoctorsScreenState extends State<AvailableDoctorsScreen> {
  late ScrollController _scrollController;
  int _currentPage = 0;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasReachedMax = false;
  List<AvailableDoctorElement> _availableDoctors = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _fetchInitialDoctors();
  }

  void _onScroll() {
    if (_isBottom && !_isLoadingMore && !_hasReachedMax) {
      _loadMoreDoctors();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _fetchInitialDoctors() {
    // Log viewing available doctors
    FirebaseAnalytics.instance.logEvent(
      name: 'view_available_doctors',
      parameters: {
        'action': 'initial_load',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _availableDoctors.clear();
      _hasReachedMax = false;
    });

    context.read<AvailableDoctorsScreenBloc>().add(
      GetAvailableDoctorsEvent(page: _currentPage),
    );
  }

  void _loadMoreDoctors() {
    // Log loading more doctors
    FirebaseAnalytics.instance.logEvent(
      name: 'load_more_doctors',
      parameters: {
        'current_page': _currentPage,
        'total_doctors_loaded': _availableDoctors.length,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
    
    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    context.read<AvailableDoctorsScreenBloc>().add(
      GetAvailableDoctorsEvent(page: _currentPage),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      AvailableDoctorsScreenBloc,
      AvailableDoctorsScreenState
    >(
      listener: (context, state) {
        if (state is AvailableDoctorsScreenFailure) {
          setState(() {
            _isLoading = false;
            _isLoadingMore = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is AvailableDoctorsScreenLoaded) {
          final newDoctors = state.availableDoctor.availableDoctors;

          setState(() {
            _isLoading = false;
            _isLoadingMore = false;

            if (_currentPage == 0) {
              // First page - replace all data
              _availableDoctors = newDoctors;
            } else {
              // Subsequent pages - append data
              _availableDoctors.addAll(newDoctors);
            }

            // Check if we've reached the end
            _hasReachedMax =
                newDoctors.isEmpty ||
                _currentPage >= (state.availableDoctor.totalPages ?? 1) - 1;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: const GeneralAppBar(
          titleText: "Available Doctors",
          logo: AssetImage('assets/images/logo.webp'),
        ),
        body: SafeArea(child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingShimmer();
    }

    if (_availableDoctors.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      color: primaryColor,
      elevation: 0,
      backgroundColor: Colors.white,
      onRefresh: () async {
        _fetchInitialDoctors();
        // Wait a bit for the request to complete
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: _availableDoctors.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _availableDoctors.length) {
            return _buildLoadingMoreIndicator();
          }

          final doctor = _availableDoctors[index];
          return AvailableItemWidget(
            availableItemModelObj: doctor,
            onTapBooknow: () async {
              // Log selecting a doctor for booking
              FirebaseAnalytics.instance.logEvent(
                name: 'select_doctor_for_booking',
                parameters: {
                  'doctor_id': doctor.id ?? 'unknown',
                  'doctor_name': doctor.name ?? 'unknown',
                  'doctor_category': doctor.category ?? 'unknown',
                  'doctor_score': doctor.score ?? 0,
                  'timestamp': DateTime.now().toIso8601String(),
                },
              );
              
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => BlocProvider(
                        create: (context) => sl<ScheduleBloc>(),
                        child: ScheduleScreen(doctorId: doctor.id!),
                      ),
                ),
              );
              
              // Refresh the available doctors list when returning from schedule screen
              if (result == true || result == null) {
                _fetchInitialDoctors();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer(
          duration: const Duration(seconds: 3),
          interval: const Duration(seconds: 5),
          color: Colors.white,
          colorOpacity: 0.3,
          enabled: true,
          direction: const ShimmerDirection.fromLTRB(),
          child: const AvailableItemShimmer(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No available doctors found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please check back later',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchInitialDoctors,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Center(
      child:
          _hasReachedMax
              ? Text(
                'No more doctors to load',
                style: TextStyle(color: Colors.grey[600]),
              )
              : AvailableItemShimmer(),
    );
  }
}
