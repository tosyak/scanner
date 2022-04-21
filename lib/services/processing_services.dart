import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:date_format/date_format.dart';

var linkID = "";
var postRequestStatus = true;
var processingQuantity;
var processingName = "";

formatJsonData() async {
  var processingDeleteList = [
    // "meta",
    // "id",
    // "accountId",
    // "owner",
    // "shared",
    // "group",
    // "updated",
    // "name",
    // "externalCode",
    "moment",
    // "applicable",
    "created",
    // "printed",
    // "published",
    // "files",
    // "products",
    // "materials",
    "deleted"
  ];

  var productsDeleteList = ["context", "deleted"];
  var materialsDeletedList = ["meta", "id", "deleted"];

  var processing = await fetchProcessing() as Map<String, dynamic>;
  var materials = await fetchProcessingMaterials() as Map<String, dynamic>;
  var products = await fetchProcessingProducts() as Map<String, dynamic>;

  processingDeleteList.forEach((element) {
    processing.remove(element);
  });
  productsDeleteList.forEach((element) {
    materials.remove(element);
  });
  productsDeleteList.forEach((element) {
    products.remove(element);
  });

  for (var i = 0; i < materials["rows"].length; ++i) {
    materialsDeletedList.forEach((element) {
      materials['rows'][i].remove(element);
    });
  }

  for (var i = 0; i < products["rows"].length; ++i) {
    materialsDeletedList.forEach((element) {
      products['rows'][i].remove(element);
    });
  }

  for (var i = 0; i < materials['rows'].length; ++i) {
    materials['rows'][i]['quantity'] =
        (materials['rows'][i]['quantity'] / processing['quantity']) *
            processingQuantity;
  }

  for (var i = 0; i < products['rows'].length; ++i) {
    products['rows'][i]['quantity'] =
        (products['rows'][i]['quantity'] / processing['quantity']) *
            processingQuantity;
  }

  processing['products'] = products;
  processing['materials'] = materials;
  processing['quantity'] = processingQuantity;
  processing['name'] = processing['name'] +
      ' ' +
      formatDate(DateTime.now(),
          [dd, '.', mm, '.', yyyy, ' ', HH, ':', nn, ':', ss]).toString();
  print(processing);

  return processing;
}

Future<Map<String, dynamic>> fetchProcessing() async {
  var link =
      'https://online.moysklad.ru/api/remap/1.2/entity/processing/$linkID';
  final response = await http.get(Uri.parse(link), headers: {
    'authorization': 'Bearer f7756f7da07100fa2ee2de6d5c0368e820fe2502',
    'Content-Type': 'application/json',
    "Access-Control_Allow_Origin": "*",
  });
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    print(response.statusCode);
    processingName = json["name"];
    return json;
  } else {
    print(response.statusCode);
    print(link);

    throw Exception('Failed to load processing');
  }
}

Future<Map<String, dynamic>> fetchProcessingMaterials() async {
  var processing = await fetchProcessing() as Map<String, dynamic>;
  var url = processing['materials']['meta']['href'];

  final response = await http.get(Uri.parse('$url'), headers: {
    'authorization': 'Bearer f7756f7da07100fa2ee2de6d5c0368e820fe2502',
  });
  if (response.statusCode == 200) {
    var materials = jsonDecode(response.body);

    return materials;
  } else {
    print(response.statusCode);
    throw Exception('Failed to load processing');
  }
}

Future<Map<String, dynamic>> fetchProcessingProducts() async {
  var processing = await fetchProcessing() as Map<String, dynamic>;
  var url = processing['products']['meta']['href'];
  final response = await http.get(Uri.parse('$url'), headers: {
    'authorization': 'Bearer f7756f7da07100fa2ee2de6d5c0368e820fe2502',
  });
  if (response.statusCode == 200) {
    var products = jsonDecode(response.body);
    return products;
  } else {
    print(response.statusCode);
    throw Exception('Failed to load processing');
  }
}

Future<http.Response> postRequest() async {
  var data = await formatJsonData() as Map<String, dynamic>;
  var body = json.encode(data);
  var response = await http.post(
      Uri.parse('https://online.moysklad.ru/api/remap/1.2/entity/processing'),
      headers: {
        'authorization': 'Bearer f7756f7da07100fa2ee2de6d5c0368e820fe2502',
        'Content-Type': 'application/json',
      },
      body: body);

  if (response.statusCode == 200) {
    postRequestStatus = true;
    print("${response.statusCode}");
    print("${response.body}");
    return response;
  } else {
    print("${response.statusCode}");
    throw Exception('Failed to create processing.');
  }
}
