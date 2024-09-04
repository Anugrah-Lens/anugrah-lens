// // To parse this JSON data, do
// //
// //     final customersSpesificModel = customersSpesificModelFromMap(jsonString);

// import 'dart:convert';

// CustomersSpecificModel customersSpesificModelFromMap(String str) => CustomersSpecificModel.fromMap(json.decode(str));

// String customersSpesificModelToMap(CustomersSpecificModel data) => json.encode(data.toMap());

// class CustomersSpecificModel {
//     bool? error;
//     String? message;
//     CustomerSpecific? customer;

//     CustomersSpecificModel({
//         this.error,
//         this.message,
//         this.customer,
//     });

//     factory CustomersSpecificModel.fromMap(Map<String, dynamic> json) => CustomersSpecificModel(
//         error: json["error"],
//         message: json["message"],
//         customer: json["customer"] == null ? null : CustomerSpecific.fromMap(json["customer"]),
//     );

//     Map<String, dynamic> toMap() => {
//         "error": error,
//         "message": message,
//         "customer": customer?.toMap(),
//     };
// }

// class CustomerSpecific {
//     String? id;
//     String? name;
//     String? address;
//     int? phone;
//     List<GlassSpecific>? glasses;

//     CustomerSpecific({
//         this.id,
//         this.name,
//         this.address,
//         this.phone,
//         this.glasses,
//     });

//     factory CustomerSpecific.fromMap(Map<String, dynamic> json) => CustomerSpecific(
//         id: json["id"],
//         name: json["name"],
//         address: json["address"],
//         phone: json["phone"],
//         glasses: json["glasses"] == null ? [] : List<GlassSpecific>.from(json["glasses"]!.map((x) => GlassSpecific.fromMap(x))),
//     );

//     Map<String, dynamic> toMap() => {
//         "id": id,
//         "name": name,
//         "address": address,
//         "phone": phone,
//         "glasses": glasses == null ? [] : List<dynamic>.from(glasses!.map((x) => x.toMap())),
//     };
// }

// class GlassSpecific {
//     String? id;
//     String? frame;
//     String? lensType;
//     String? left;
//     String? right;
//     int? price;
//     int? deposit;
//     String? orderDate;
//     String? deliveryDate;
//     String? paymentStatus;
//     String? paymentMethod;
//     String? customerId;
//     List<InstallmentSpecific>? installments;

//     GlassSpecific({
//         this.id,
//         this.frame,
//         this.lensType,
//         this.left,
//         this.right,
//         this.price,
//         this.deposit,
//         this.orderDate,
//         this.deliveryDate,
//         this.paymentStatus,
//         this.paymentMethod,
//         this.customerId,
//         this.installments,
//     });

//     factory GlassSpecific.fromMap(Map<String, dynamic> json) => GlassSpecific(
//         id: json["id"],
//         frame: json["frame"],
//         lensType: json["lensType"],
//         left: json["left"],
//         right: json["right"],
//         price: json["price"],
//         deposit: json["deposit"],
//         orderDate: json["orderDate"],
//         deliveryDate: json["deliveryDate"],
//         paymentStatus: json["paymentStatus"],
//         paymentMethod: json["paymentMethod"],
//         customerId: json["customerId"],
//         installments: json["installments"] == null ? [] : List<InstallmentSpecific>.from(json["installments"]!.map((x) => InstallmentSpecific.fromMap(x))),
//     );

//     Map<String, dynamic> toMap() => {
//         "id": id,
//         "frame": frame,
//         "lensType": lensType,
//         "left": left,
//         "right": right,
//         "price": price,
//         "deposit": deposit,
//         "orderDate": orderDate,
//         "deliveryDate": deliveryDate,
//         "paymentStatus": paymentStatus,
//         "paymentMethod": paymentMethod,
//         "customerId": customerId,
//         "installments": installments == null ? [] : List<dynamic>.from(installments!.map((x) => x.toMap())),
//     };
// }

// class InstallmentSpecific {
//     String? id;
//     String? paidDate;
//     int? amount;
//     int? total;
//     int? remaining;
//     String? glassId;

//     InstallmentSpecific({
//         this.id,
//         this.paidDate,
//         this.amount,
//         this.total,
//         this.remaining,
//         this.glassId,
//     });

//     factory InstallmentSpecific.fromMap(Map<String, dynamic> json) => InstallmentSpecific(
//         id: json["id"],
//         paidDate: json["paidDate"],
//         amount: json["amount"],
//         total: json["total"],
//         remaining: json["remaining"],
//         glassId: json["glassId"],
//     );

//     Map<String, dynamic> toMap() => {
//         "id": id,
//         "paidDate": paidDate,
//         "amount": amount,
//         "total": total,
//         "remaining": remaining,
//         "glassId": glassId,
//     };
// }
