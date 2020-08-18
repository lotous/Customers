part of 'CustomerBloc.dart';

@immutable
abstract class CustomerEvent {}

class DeleteCustomer extends CustomerEvent {

  final Customer customer;

  DeleteCustomer(this.customer);

  List<Object> get props => [customer];

}


class GetCustomerList extends CustomerEvent {

  final String query;

  GetCustomerList({this.query});

  List<Object> get props => [query];

}



class LoadMorePage extends CustomerEvent {

 final String query;

  LoadMorePage({this.query});

  List<Object> get props => [query];

}