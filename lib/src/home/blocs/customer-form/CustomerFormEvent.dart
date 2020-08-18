part of 'CustomerFormBloc.dart';

@immutable
abstract class CustomerFormEvent {
    final Customer customer;

  CustomerFormEvent({this.customer});
}

class GoToBackFrom extends CustomerFormEvent {}

class GetCustomerFrom extends CustomerFormEvent {
  GetCustomerFrom({Customer customer}) : super(customer: customer);
}

class CreateCustomer extends CustomerFormEvent {
  CreateCustomer({@required Customer customer}) : super(customer: customer);
}

class UpdateCustomer extends CustomerFormEvent {
  UpdateCustomer({@required Customer customer}) : super(customer: customer);
}