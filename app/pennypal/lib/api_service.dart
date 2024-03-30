import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<Map<String, dynamic>> sendMessage(int user_id, String message) async {
    var url = Uri.parse('http://10.0.2.2:8000/incoming-message');
    var headers = {"Content-Type": "application/json"};
    var body = json.encode({"user_id": user_id, "content": message});

    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print(response.body);
        print("inside api_service.dart");
        Map<String, dynamic> data = json.decode(response.body);
        print(data);
        // Map<String, dynamic> mapped_data = Map.fromIterable(json.decode(response.body), key: (e) => e, value: (e) => data[e]);
        // return mapped_data;
        return data;
      } else {
        return {"content": "Please try again later.", "graph-needed": false, "user_id": 0};
      }
    } catch (e) {
      print('Error sending message: $e');
        return {"content": "Please try again later.", "graph-needed": false, "user_id": 0};
    }
  }

  static Future<List<int>> getGraphData(int userId) async {
    var url = Uri.parse('http://10.0.2.2:8000/get-graph/$userId');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // Parse response JSON
        List<int> imageData = response.bodyBytes;
        // Handle graph data
        print('Graph data received');
        return imageData;
      } else {
        print('Failed to get graph data');
        return [];
      }
    } catch (e) {
      print('Error getting graph data: $e');
      return [];
    }
  }
}
