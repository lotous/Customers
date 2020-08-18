import 'package:customers/src/home/data/dao/CustomerDao.dart';
import 'package:customers/src/home/data/models/Customer.dart';

class CustomerRepository {
  
  final customerDao = CustomerDao();

  Future<List<Customer>> getAll({String query, int page}) => customerDao.getCustomers(query: query, page: page);

  Future insert(Customer customer) => customerDao.createCustomer(customer);

  Future update(Customer customer) => customerDao.updateCustomer(customer);

    Future getById(int id) => customerDao.getCustomer(id: id);

  Future deleteById(int id) => customerDao.deleteCustomer(id);

  Future deleteAll() => customerDao.deleteAllCustomers();

}