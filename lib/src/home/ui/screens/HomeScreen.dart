
import 'package:customers/src/home/blocs/customer-form/CustomerFormBloc.dart';
import 'package:customers/src/home/blocs/customer-list/CustomerBloc.dart';
import 'package:customers/src/home/ui/screens/FormScreen.dart';
import 'package:customers/src/home/ui/widgets/BottomLoadingIndicator.dart';
import 'package:customers/src/home/ui/widgets/CustomerListWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final String title;


  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  CustomerBloc _customerBloc;
  CustomerFormBloc _customerFormBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =  GlobalKey<RefreshIndicatorState>();
  
  TextEditingController _searchController = new TextEditingController();


 
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // _customerBloc.add(GetCustomerList(query: ""));
  }

  @override
  Widget build(BuildContext context) {
    _customerBloc = BlocProvider.of<CustomerBloc>(context);
    _customerFormBloc  = BlocProvider.of<CustomerFormBloc>(context); 
    return Scaffold(
      appBar: AppBar(
          title: TextField(
            controller: _searchController,
            autocorrect: false,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  _customerBloc.add(GetCustomerList(query: _searchController.text ?? ""));
                },
              ),
              hintText: 'Search...',
            ),
          ),
        ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
           _customerBloc.add(
             GetCustomerList(query: "")
           );
        },
        child: BlocListener<CustomerBloc, CustomerState>(
            listenWhen: (previousState, state) {
                return state is CustomerListSuccess;
            },
            listener: (context, state) {
                if (state is CustomerListFailed) {
                    _scaffoldKey.currentState.showSnackBar(snackBar(state.error));
                }
            },
            child: generateItemsList(),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           Navigator.push(context, 
                MaterialPageRoute<FormScreen>(
                  builder: (context) {
                    return MultiBlocProvider(
                      providers: [
                          BlocProvider<CustomerFormBloc>.value(
                              value: _customerFormBloc..add(
                                GetCustomerFrom()
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
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

    generateItemsList() {
      return SafeArea(
        top: true,
        bottom: false,
        child: new OrientationBuilder(builder: (context, orientation) {
           return BlocBuilder<CustomerBloc, CustomerState>(builder: (context, state) {

                  if (state is CustomerListSuccess) {
                      return state.customers.isNotEmpty ? CustomScrollView(
                          controller: _scrollController,
                          shrinkWrap: true,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                    return CustomerListWidget(customer: state.customerList[index]);
                                },
                                childCount: state.customerList.length,
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: BottomLoadingIndicator(),
                            )
                          ],
                      ) : Center(
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                accentColor: Colors.pink,
                              ),
                              child: Text("No hay registros para mostrar"),
                            ),
                      );
                  }else if (state is CustomerListFailed) {
                      return Center(
                        child: Text('failed to fetch response: ${state.error}'),
                      );
                  }else if (state is CustomerListLoading) {
                    return Center(
                        child: Theme(
                            data: Theme.of(context).copyWith(
                                accentColor: Colors.pink,
                            ),
                            child: CircularProgressIndicator(),
                        ),
                    );
                 } else {
                   return Center(); 
                 }   
             }
           ); 
        })
      );  

  }

  @override
  void dispose() {
    _scrollController.dispose();
    _customerBloc.close();
    _customerFormBloc.close(); 
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _customerBloc.add(LoadMorePage(query: _searchController.text ?? ""));
    }
  }

  SnackBar snackBar(String message) {
      return SnackBar(content: Text(message), duration: (Duration(seconds: 1)));
  } 



}
