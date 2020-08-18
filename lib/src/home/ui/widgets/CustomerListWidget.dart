import 'package:customers/src/home/blocs/customer-form/CustomerFormBloc.dart';
import 'package:customers/src/home/blocs/customer-list/CustomerBloc.dart';
import 'package:customers/src/home/data/models/Customer.dart';
import 'package:customers/src/home/ui/screens/FormScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerListWidget extends StatefulWidget {
  CustomerListWidget({Key key, @required this.customer})
      : assert(customer != null),
        super(key: key);

  final Customer customer;

  @override
  _CustomerListWidgetState createState() => _CustomerListWidgetState();
}

class _CustomerListWidgetState extends State<CustomerListWidget> {
  CustomerBloc _customerBloc;
  CustomerFormBloc _customerFormBloc;
  @override
  Widget build(BuildContext context) {
    _customerBloc = BlocProvider.of<CustomerBloc>(context);
    _customerFormBloc = BlocProvider.of<CustomerFormBloc>(context); 
      return Dismissible(
            key: Key(widget.customer.identifier),
            child: InkWell(
                onTap: () {
                  print("${widget.customer.id} clicked");
                },
                child: ListTile(title: Text('${widget.customer.firstName} ${widget.customer.lastName}'))),
            background: slideRightBackground(),
            secondaryBackground: slideLeftBackground(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                final bool res = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text(
                            "do you want to delete this client (${widget.customer.firstName})?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "Cancel",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              _customerBloc.add(
                                DeleteCustomer(widget.customer)
                              );
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
                return res;
              } else {
                  Navigator.of(context).push(
                      MaterialPageRoute<FormScreen>(
                        builder: (context) {
                          return MultiBlocProvider(
                            providers: [
                                BlocProvider<CustomerFormBloc>.value(
                                    value: _customerFormBloc..add(
                                        GetCustomerFrom(customer: widget.customer)
                                    )
                                ),
                                BlocProvider<CustomerBloc>.value(
                                  value: _customerBloc
                                ),
                            ],
                            child: FormScreen(),
                          );
                        },
                      ) 
                ); 
                return false; 
              }
            },
          );
  }

  Widget slideRightBackground() {
      return Container(
        color: Colors.green,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              Text(
                " Edit",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          alignment: Alignment.centerLeft,
        ),
      );
    }

    Widget slideLeftBackground() {
      return Container(
        color: Colors.red,
        child: Align(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              Text(
                " Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(
                width: 20,
              ),
            ],
          ),
          alignment: Alignment.centerRight,
        ),
      );
    }

  @override
  void dispose() {
    _customerBloc.close();
    _customerFormBloc.close(); 
    super.dispose();
  }
}