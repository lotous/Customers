import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:customers/src/home/data/models/Customer.dart';
import 'package:customers/src/home/data/repositories/CustomerRepository.dart';
import 'package:meta/meta.dart';

part 'CustomerFormEvent.dart';
part 'CustomerFormState.dart';

class CustomerFormBloc extends Bloc<CustomerFormEvent, CustomerFormState> {

  final CustomerRepository customerRepository;
   
  CustomerFormBloc({this.customerRepository}) :  super(CustomerFormInitial());

  @override
  Stream<CustomerFormState> mapEventToState(
    CustomerFormEvent event,
  ) async* {
    
        yield CustomerFormLoading();
        if (event is GetCustomerFrom) {
          try {
            yield CustomerFormSave(customer: event?.customer?.id == null ? Customer() : await customerRepository.getById(event.customer?.id));
          } catch(e) {
            yield CustomerFormFailed(e.toString());
          }
        } else if (event is GoToBackFrom) {
          yield CustomerFormInitial();
        } else if (event is CreateCustomer) {
          try {
            await customerRepository.insert(event.customer);
            yield CustomerFormSuccess(message: event.customer.firstName + ' created');
          } catch(e) {
            yield CustomerFormFailed(e.toString());
          }
        } else if (event is UpdateCustomer) {
          try {
            await customerRepository.update(event.customer);
            yield CustomerFormSuccess(message: event.customer.firstName + ' updated');        
          } catch(e) {
            yield CustomerFormFailed(e.toString());
          }
        }


  }
}
