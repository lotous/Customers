import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:customers/src/home/data/models/Customer.dart';
import 'package:customers/src/home/data/repositories/CustomerRepository.dart';
import 'package:meta/meta.dart';

part 'CustomerEvent.dart';
part 'CustomerState.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {

  final CustomerRepository customerRepository;
   
  CustomerBloc({this.customerRepository}) :  super(CustomerListInitial());

  int pageValue = 1;
  bool hasReachedMax = false;


  @override
  Stream<CustomerState> mapEventToState(CustomerEvent event) async* {
      CustomerState currentState = state; 
      yield CustomerListLoading();


      if(event is LoadMorePage){
        if(!hasReachedMax){
            List<Customer> customerData = await customerRepository.getAll(query: event.query, page: pageValue);
            if(currentState?.customers != null){
                customerData.addAll(currentState.customers); 
            } 
            yield CustomerListSuccess(
                customerList: customerData,
                hasReachedMax: hasReachedMax,
            );
            _updatePageValue(pageValue);
            _updateReachedMax(customerData.length <= 0); 
        } else {
            if(currentState?.customers != null){
                yield CustomerListSuccess(
                    customerList: currentState.customers,
                    hasReachedMax: hasReachedMax,
                );
            }
        }
      }
      
      if (event is GetCustomerList) {
        try{
              _updatePageValue(1);
              List<Customer> customerData = await customerRepository.getAll(query: event.query, page: 1);
              _updateReachedMax(customerData.length <= 0); 
              if (customerData.length > 0) {
                  yield CustomerListSuccess(
                      customerList: customerData,
                      hasReachedMax: hasReachedMax,
                  );
              }else{
                   yield CustomerListSuccess(
                      customerList: [],
                      hasReachedMax: hasReachedMax,
                  );
              }
           
        } catch(e) {
            yield CustomerListFailed(e.toString());
        }
     } else if (event is DeleteCustomer) {
        try {
          await customerRepository.deleteById(event.customer.id);
          currentState?.customers?.remove(event.customer);
          yield CustomerListSuccess(
              customerList: currentState?.customers ?? await customerRepository.getAll(query: "", page: 1),
              hasReachedMax: hasReachedMax,
          );
        } catch(e) {
          yield CustomerListFailed(e.toString());
        }
     } else if (event is LoadMorePage) {

     }
  }

  void _updatePageValue(int page) {
    if (page >= 1) pageValue = page + 1;
  }

  void _updateReachedMax(bool reachedMax) { 
    hasReachedMax = reachedMax;
  }
      
}
