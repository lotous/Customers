part of 'CustomerBloc.dart';

@immutable
abstract class CustomerState {
  
  final List<Customer> customers;
  final bool reachedMax; 

  const CustomerState({this.customers, this.reachedMax});
}

class CustomerListInitial extends CustomerState {}

class CustomerNotMorePage extends CustomerState {
   final List<Customer> customerList;
  final bool hasReachedMax;

  const CustomerNotMorePage({this.customerList, this.hasReachedMax}) : super(customers: customerList, reachedMax: hasReachedMax);

  List<Object> get props => [customerList, hasReachedMax];

  @override
  String toString() =>
      'CustomerNotMorePage { customerData: ${customerList.length}, hasReachedMax: $hasReachedMax }';

}

class CustomerListLoading extends CustomerState {}

class CustomerListSuccess extends CustomerState {

  final List<Customer> customerList;
  final bool hasReachedMax;

  const CustomerListSuccess({this.customerList, this.hasReachedMax}) : super(customers: customerList, reachedMax: hasReachedMax);

  List<Object> get props => [customerList, hasReachedMax];

  @override
  String toString() =>
      'CustomerListSuccess { customerData: ${customerList.length}, hasReachedMax: $hasReachedMax }';
}


class CustomerListFailed extends CustomerState {

 
  final String error;

  CustomerListFailed(this.error);

  @override
  String toString() {
    return error;
  }

}