
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home/blocs/customer-form/CustomerFormBloc.dart';
import 'home/blocs/customer-list/CustomerBloc.dart';
import 'home/data/repositories/CustomerRepository.dart';
import 'home/ui/screens/HomeScreen.dart';

class Aplication extends StatefulWidget {
  
  @override
  _AplicationState createState() => _AplicationState();
}

class _AplicationState extends State<Aplication> {
  CustomerRepository _customerRepository = CustomerRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(providers: [
            BlocProvider<CustomerBloc>(
              create: (context) => CustomerBloc(customerRepository: _customerRepository)..add(
                 GetCustomerList(query: "") 
              ),
            ), 
            BlocProvider<CustomerFormBloc>(
              create: (context) => CustomerFormBloc(customerRepository: _customerRepository),
            ),
         ], 
         child: HomeScreen(title: 'Flutter Demo Home Page')
      ),
    
    );
  }
}

