import 'package:my_notes_provider_sqflite/models/note_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteDBHelper {
  static final NoteDBHelper instance = NoteDBHelper._();

  static const String dbName = 'notes.db';
  static const String tableName = 'Notes';
  static const int dbVersion = 2; // Incrementa la versión de la base de datos

  late Database _database;

  NoteDBHelper._();

  Future<Database> get database async {
    _database = await _initDB();
    return _database;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    // Abrir la base de datos
    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _createDB,
      onUpgrade: _onUpgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const stringType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableName (
        id $idType,
        title $stringType,
        content $stringType,
        date $stringType,
        updated_date $stringType
      )
    ''');
  }

  Future<void> _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Agregar la columna updated_date si no existe
      await db.execute('''
        ALTER TABLE $tableName ADD COLUMN updated_date TEXT
      ''');
    }
  }

  Future<int> insertNote(NoteModel note) async {
    final db = await database;
    return await db.insert(tableName, note.toMap());
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) {
      return NoteModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        date: maps[i]['date'],
        updatedDate: maps[i]['updated_date'],
      );
    });
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    return await db.update(
      tableName,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
