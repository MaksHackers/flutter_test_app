import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:postgres/postgres.dart';

class Db {
  Connection? _connection;

  static const String _dbName = 'pmu_course';
  static const String _dbUser = 'postgres';
  static const String _dbPassword = 'postgres';
  static const int _dbPort = 5432;

  static String get _host {
    if (kIsWeb) throw UnsupportedError('PostgreSQL не поддерживается на web.');
    if (Platform.isAndroid) return '10.8.1.17';
    return 'localhost';
  }

  static Future<void> init() async {
    debugPrint('[DB] Подключение к серверу PostgreSQL...');

    final adminConn = await Connection.open(
      Endpoint(
        host: _host,
        port: _dbPort,
        database: 'postgres',
        username: _dbUser,
        password: _dbPassword,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

    try {
      final exists = await adminConn.execute(
        Sql.named('SELECT 1 FROM pg_database WHERE datname = @name'),
        parameters: {'name': _dbName},
      );
      if (exists.isEmpty) {
        debugPrint('[DB] База $_dbName не найдена, создаём...');
        await adminConn.execute('CREATE DATABASE $_dbName');
        debugPrint('[DB] База $_dbName создана.');
      } else {
        debugPrint('[DB] База $_dbName уже существует.');
      }
    } finally {
      await adminConn.close();
    }

    final appConn = await Connection.open(
      Endpoint(
        host: _host,
        port: _dbPort,
        database: _dbName,
        username: _dbUser,
        password: _dbPassword,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );

    try {
      await appConn.execute('''
        CREATE TABLE IF NOT EXISTS likes (
          card_id TEXT PRIMARY KEY,
          created_at TIMESTAMPTZ DEFAULT NOW()
        )
      ''');
      debugPrint('[DB] Таблица likes готова.');
    } finally {
      await appConn.close();
    }
  }

  Future<Connection> _getConnection() async {
    final existing = _connection;
    if (existing != null && existing.isOpen) return existing;

    final conn = await Connection.open(
      Endpoint(
        host: _host,
        port: _dbPort,
        database: _dbName,
        username: _dbUser,
        password: _dbPassword,
      ),
      settings: const ConnectionSettings(sslMode: SslMode.disable),
    );
    _connection = conn;
    return conn;
  }

  Future<List<String>> loadLikes() async {
    final conn = await _getConnection();
    final result = await conn.execute('SELECT card_id FROM likes ORDER BY created_at');
    return result.map((row) => row[0] as String).toList();
  }

  Future<void> addLike(String cardId) async {
    final conn = await _getConnection();
    await conn.execute(
      Sql.named('INSERT INTO likes (card_id) VALUES (@id) ON CONFLICT DO NOTHING'),
      parameters: {'id': cardId},
    );
  }

  Future<void> removeLike(String cardId) async {
    final conn = await _getConnection();
    await conn.execute(
      Sql.named('DELETE FROM likes WHERE card_id = @id'),
      parameters: {'id': cardId},
    );
  }

  Future<void> close() async {
    await _connection?.close();
    _connection = null;
  }
}