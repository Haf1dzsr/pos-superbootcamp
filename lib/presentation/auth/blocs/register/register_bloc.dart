import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pos_superbootcamp/data/datasources/auth_remote_datasource.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_bloc.freezed.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const _Initial()) {
    on<_Register>((event, emit) async {
      emit(const _Loading());
      final response = await AuthRemoteDatasource.instance.register(
        name: event.name,
        phoneNumber: event.phoneNumber,
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
