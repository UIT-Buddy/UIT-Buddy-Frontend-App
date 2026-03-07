abstract interface class OnboardingDatasource {
  Future<void> completeOnboarding();
  Future<bool> isOnboardingCompleted();
}
