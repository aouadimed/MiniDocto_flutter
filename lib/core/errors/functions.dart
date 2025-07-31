
import 'package:flutter_user/core/errors/failures.dart';

String mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return "An error occurred in our server ! please try again later";
    case UserCredentialFailure:
      return "Verify your credential !";
    case ConnexionFailure:
      return "Please verify your connexion and try again !";
    case EmailExistsFailure:
      return "This email is already in use. Please use a different email.";
    default:
      return "";
  }
}
