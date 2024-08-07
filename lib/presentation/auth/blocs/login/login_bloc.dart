import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_superbootcamp/data/datasources/auth_remote_datasource.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_bloc.freezed.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const _Initial()) {
    on<_Login>((event, emit) async {
      emit(const _Loading());
      final response = await AuthRemoteDatasource.instance.login(
        email: event.email,
        password: event.password,
      );

      response.fold(
        (l) => emit(_Failure(l)),
        (r) => emit(const _Success()),
      );
    });
  }
}
