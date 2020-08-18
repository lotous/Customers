
class Customer {

  int id;
  String identifierType;
  String identifier;
  String firstName;
  String lastName;
  String numberPhone;
  String email;
  String companyName;
  

  Customer({
    this.id, 
    this.identifierType = "CC", 
    this.identifier = "", 
    this.firstName = "", 
    this.lastName = "", 
    this.numberPhone = "", 
    this.email = "", 
    this.companyName = "" 
  });


  factory Customer.fromToJson(var data) => Customer(
      id: data['id'],
      identifierType: data['identifierType'],    
      identifier: data['identifier'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      numberPhone: data['numberPhone'],
      email: data['email'],
      companyName: data['companyName'],
  );  
      
  Map<String, dynamic> toJson() => {
      "id": this.id,  
      "identifierType": this.identifierType,    
      "identifier": this.identifier,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "numberPhone": this.numberPhone,
      "email": this.email,
      "companyName": this.companyName
  };

}