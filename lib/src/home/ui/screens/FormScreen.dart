import 'package:customers/src/home/blocs/customer-form/CustomerFormBloc.dart';
import 'package:customers/src/home/blocs/customer-list/CustomerBloc.dart';
import 'package:customers/src/home/data/models/Customer.dart';
import 'package:customers/src/home/ui/widgets/BottomLoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  CustomerFormBloc _customerFromBloc;
  CustomerBloc _customerBloc; 
  List _typeIdentifier = ["CC", "PA", "CE", "TI", "RC"];
  List<DropdownMenuItem<String>> _dropDownMenuItems;


   @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    super.initState();
  }

  
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String typeIdentifier in _typeIdentifier) {
      items.add(new DropdownMenuItem(
          value: typeIdentifier,
          child: new Text(typeIdentifier)
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {

    _customerFromBloc = BlocProvider.of<CustomerFormBloc>(context); 
    _customerBloc = BlocProvider.of<CustomerBloc>(context); 
  return WillPopScope(
      onWillPop: () async {
        _customerFromBloc.add(GoToBackFrom());
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: BlocBuilder<CustomerFormBloc, CustomerFormState>(
          builder: (context, state) =>
              Text((state.customer?.id == null ? 'Add' : 'Edit') + ' Customer'),
        )),
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: BlocListener<CustomerFormBloc, CustomerFormState>(
                listenWhen: (previousState, state) {
                  return state is CustomerFormSuccess;
                },
                listener: (context, state) {
                    _customerBloc.add(GetCustomerList(query: "")); 
                    //BlocProvider.of<CustomerBloc>(context).add(GetCustomerList(query: "")); 
                    Navigator.pop(context);
                },
                child: BlocBuilder<CustomerFormBloc, CustomerFormState>(
                    builder: (context, state) {
                  if (state is CustomerFormSave) {
                    Customer customer = state.customer?.id == null ? Customer() : state.customer;
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                            
                            DropdownButtonFormField(
                              decoration: InputDecoration(
                                labelText: 'Identifier Type',
                              ),
                              items: _dropDownMenuItems, 
                              value: customer?.identifierType ?? '',
                              onChanged: (value) {
                                customer?.identifierType = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Identifier Type is Required';
                                }
                                return null;
                              }
                           ),
                            
                           TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Identifier',
                              ),
                              initialValue: customer?.firstName ?? '',
                              onChanged: (value) {
                                customer?.firstName = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Identifier is Required';
                                }
                                return null;
                              }
                          ),

                          TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                              ),
                              initialValue: customer?.firstName ?? '',
                              onChanged: (value) {
                                customer?.firstName = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'First Name is Required';
                                }
                                return null;
                              }
                          ),

                          TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                              ),
                              initialValue: customer?.firstName ?? '',
                              onChanged: (value) {
                                customer?.firstName = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Last Name is Required';
                                }
                                return null;
                              }
                          ),

                          TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Number Phone',
                              ),
                              initialValue: customer?.numberPhone ?? '',
                              onChanged: (value) {
                                customer?.numberPhone = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                    return 'Number Phone is Required';
                                }
                                return null;
                              }
                          ),

                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                              ),
                              initialValue: customer?.email ?? '',
                              onChanged: (value) {
                                customer?.email = value;
                              },
                              validator: (value) {
                                if (value.length < 1) {
                                  return 'Email is Required';
                                }
                                return null;
                              }
                          ),

                          TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                labelText: 'Company Name',
                              ),
                              initialValue: customer?.companyName ?? '',
                              onChanged: (value) {
                                customer?.companyName = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Company Name is Required';
                                }
                                return null;
                              }
                          ),

                          RaisedButton(
                            child: Text('Submit'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _customerFromBloc.add(customer?.id == null
                                    ? CreateCustomer(customer: customer)
                                    : UpdateCustomer(customer: customer));
                              }
                            },
                          )
                        ],
                      ),
                    );
                  }
                  if (state is CustomerFormFailed) {
                    return Text(state.error);
                  }
                  return BottomLoadingIndicator();
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

}