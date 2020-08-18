import 'package:customers/src/home/data/models/Customer.dart';
import 'package:customers/src/home/data/providers/DataBaseProvider.dart';

class CustomerDao {

  final databaseProvider = DatabaseProvider.db;

  Future<int> createCustomer(Customer customer) async {
    final db = await databaseProvider.instance;
    var result = db.insert(databaseProvider.customersTable, customer.toJson());
    return result;
  }

  Future<List<Customer>> getCustomers({List<String> columns, String query, int page}) async {
    final db = await databaseProvider.instance;

    List<Map<String, dynamic>> result;
    if (query != null) {
        result = await db.query(databaseProvider.customersTable,
            columns: columns,
            where: 'firstName LIKE ? OR lastName LIKE ? OR identifier LIKE ? OR email LIKE ? OR companyName LIKE ?',
            limit: 20,
            offset: (20 * page) - 20,
            whereArgs: ["%$query%","%$query%","%$query%","%$query%","%$query%"]);
    } else {
      result = await db.query(databaseProvider.customersTable, columns: columns);
    }
    
    List<Customer> customers = result.isNotEmpty ? 
                               result.map((item) => Customer.fromToJson(item)).toList() : [];
    return customers;
  }

   Future<Customer> getCustomer({List<String> columns, int id}) async {
    final db = await databaseProvider.instance;

    var result = await db.query(
      databaseProvider.customersTable, 
      columns: columns, 
      where: 'id = ?', 
      whereArgs: [id]
    );

    List<Customer> customers = result.isNotEmpty ? result.map((customer) => Customer.fromToJson(customer)).toList() : [];
    Customer customer = customers.isNotEmpty ? customers[0] : Customer();

    return customer;
  }

  Future<bool> updateCustomer(Customer customer) async {
    final db = await databaseProvider.instance;
    var result = await db.update(
        databaseProvider.customersTable, customer.toJson(),
        where: "id = ?", whereArgs: [customer.id]
    );
    return result == 1;
  }

  Future<bool> deleteCustomer(int id) async {
    final db = await databaseProvider.instance;
    var result = await db.delete(
        databaseProvider.customersTable, 
        where: 'id = ?', 
        whereArgs: [id]
    );
    return result == 1;
  }

  Future<bool> deleteAllCustomers() async {
    final db = await databaseProvider.instance;
    var result = await db.delete(
      databaseProvider.customersTable,
    );
    return result == 1;
  }


}