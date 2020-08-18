part of 'CustomerFormBloc.dart';

@immutable
abstract class CustomerFormState {

  final Customer customer;

  final String message;

  CustomerFormState({this.customer, this.message});

}

class CustomerFormInitial extends CustomerFormState {}

class CustomerFormLoading extends CustomerFormState {}

class CustomerFormSave extends CustomerFormState {

  CustomerFormSave({@required Customer customer}) : super(customer: customer);

}

class CustomerFormSuccess extends CustomerFormState {
  
  CustomerFormSuccess({@required String message});

  @override
  String toString() {
    return message;
  }

}

class CustomerFormFailed extends CustomerFormState {

  final String error;

  CustomerFormFailed(this.error);

  @override
  String toString() {
    return error;
  }

}
