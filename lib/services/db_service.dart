import 'package:mysql_client/mysql_client.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  MySQLConnection? _connection;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<void> connect() async {
    if (_connection != null) return;

    try {
      _connection = await MySQLConnection.createConnection(
        host: '192.168.1.35',
        port: 3306,
        userName: 'flutter_user',
        password: 'StrongPassword',
        databaseName: 'forgemind_db',
      );

      await _connection!.connect();

      print('Connected to MySQL Database!');
    } catch (e) {
      print('Error connecting to MySQL: $e');
      _connection = null;
    }
  }

  Future<Map<String, int>> getHealthScores() async {
    await connect();

    if (_connection == null) {
      return {
        'production': 82,
        'energy': 75,
        'workforce': 91,
        'inventory': 88,
      };
    }

    try {
      final result = await _connection!.execute(
        'SELECT * FROM health_scores LIMIT 1',
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();

        return {
          'production': int.parse(row['production_score'] ?? '82'),
          'energy': int.parse(row['energy_score'] ?? '75'),
          'workforce': int.parse(row['workforce_score'] ?? '91'),
          'inventory': int.parse(row['inventory_score'] ?? '88'),
        };
      }
    } catch (e) {
      print('Error fetching health scores: $e');
    }

    return {
      'production': 82,
      'energy': 75,
      'workforce': 91,
      'inventory': 88,
    };
  }

  Future<List<Map<String, dynamic>>> getInsights() async {
    await connect();

    if (_connection == null) {
      return [];
    }

    try {
      final result = await _connection!.execute(
        'SELECT * FROM insights ORDER BY created_at DESC LIMIT 10',
      );

      return result.rows.map((row) {
        final data = row.assoc();

        return {
          'title': data['title'] ?? '',
          'description': data['description'] ?? '',
          'type': data['type'] ?? 'info',
        };
      }).toList();
    } catch (e) {
      print('Error fetching insights: $e');
      return [];
    }
  }

  Future<void> logCopilotQuery(
    String query,
    String response,
  ) async {
    await connect();

    if (_connection == null) return;

    try {
      await _connection!.execute(
        '''
        INSERT INTO copilot_logs
        (query_text, response_text, created_at)
        VALUES (:query, :response, NOW())
        ''',
        {
          'query': query,
          'response': response,
        },
      );
    } catch (e) {
      print('Error logging query: $e');
    }
  }

  Future<void> close() async {
    try {
      await _connection?.close();
    } catch (_) {}

    _connection = null;
  }
}