class SignInState {
  final bool isLoading;
  final bool isHidePassword;

  SignInState({
    this.isLoading = false,
    this.isHidePassword = false,
  });

  SignInState copyWith({
    bool? isLoading,
    bool? isHidePassword,
  }){
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      isHidePassword: isHidePassword ?? this.isHidePassword
    );
  }
}