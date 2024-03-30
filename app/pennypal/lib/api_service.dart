import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<Map<String, dynamic>> sendMessage(String message) async {
    var url = Uri.parse('http://10.0.2.2:8000/incoming-message');
    var headers = {"Content-Type": "application/json"};
    var body = json.encode({"message": message});

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print(response.body);
        print("inside api_service.dart");
        print("inside api_service.dart");
        print("inside api_service.dart");
        print("\n");
        print("\n");
        print("\n");
        print("\n");
        return json.decode(response.body);
      } else {
        return {"content": "Please try again later.", "graph-needed": false, "user_id": 0};
      }
    } catch (e) {
      print('Error sending message: $e');
        return {"content": "Please try again later.", "graph-needed": false, "user_id": 0};
    }
  }

  static Future<void> getGraphData(int userId) async {
    var url = Uri.parse('http://10.0.2.2:8000/get-graph/$userId');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // Parse response JSON
        var data = json.decode(response.body);
        // Handle graph data
        print('Graph data received: $data');
      } else {
        print('Failed to get graph data');
      }
    } catch (e) {
      print('Error getting graph data: $e');
    }
  }
}
