import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      home: NoteListScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
         backgroundColor: Color.fromARGB(255, 136, 136, 136),
         ),
         scaffoldBackgroundColor: const Color.fromARGB(255, 255, 171, 171),
         elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 167, 0, 0), 
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          )
         )
      ),
      darkTheme: ThemeData.dark().copyWith(
         appBarTheme: const AppBarTheme(
         backgroundColor: Color.fromARGB(255, 0, 111, 119),
         ),
         scaffoldBackgroundColor: const Color.fromARGB(255, 41, 21, 87),
         elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 92, 122, 255),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          )
         )  
      ),
      themeMode: ThemeMode.system,
    );
  }
}

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Map<String, String>> notes = [];
  List<Map<String, String>> filteredNotes = [];
  TextEditingController searchController = TextEditingController();
  bool sortAscending = true;

  @override
  void initState() {
    super.initState();
    filteredNotes = notes;
    searchController.addListener(_filterNotes);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterNotes() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredNotes = notes.where((note) {
        String title = note['title']?.toLowerCase() ?? '';
        return title.contains(query);
      }).toList();
      _sortNotes();
    });
  }

  void _sortNotes() {
    filteredNotes.sort((a, b) {
      DateFormat format = DateFormat('dd.MM.yyyy');
      DateTime? dateA = format.tryParse(a['releaseDate'] ?? '');
      DateTime? dateB = format.tryParse(b['releaseDate'] ?? '');
      
      if (dateA == null || dateB == null) return 0;
      
      return sortAscending 
          ? dateA.compareTo(dateB)
          : dateB.compareTo(dateA);
    });
  }

  void _toggleSort() {
    setState(() {
      sortAscending = !sortAscending;
      _sortNotes();
    });
  }

  void addNote(Map<String, String> note) {
    setState(() {
      notes.add(note);
      filteredNotes = notes;
      _sortNotes();
    });
  }

  void removeNote(int index) {
    setState(() {
      notes.removeAt(index);
      filteredNotes = notes;
      _sortNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список заметки'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Поиск заметок',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _toggleSort,
                  child: Text('Сортировка ${sortAscending ? 'по возрастанию' : 'по убыванию'}'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text('${note['title']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${note['content']}'),
                        Text('Дата создания: ${note['createdDate']}'),
                        Text('Дата реализации: ${note['releaseDate']}'),
                        Text('Дополнительно: ${note['extra']}'),
                      ],
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${note['title']}')));
                    },
                    onLongPress: () {
                      int originalIndex = notes.indexWhere((n) => n['title'] == note['title']);
                      if (originalIndex != -1) {
                        removeNote(originalIndex);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Заказ удалён(')));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(context,
                    MaterialPageRoute(builder: (conext) => CreateNoteScreen()));
                if (result != null) {
                  addNote(result);
                }
              },
              child: const Text('Создать заметку')),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class  CreateNoteScreen extends StatefulWidget {
@override
  _CreateNoteScreenState createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController createdDateController = TextEditingController();
  final TextEditingController releaseDateController = TextEditingController();
  final TextEditingController extraController = TextEditingController();
  DateTime? selectedDate;

  Future<void> _selectData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
          releaseDateController.text = DateFormat('dd.MM.yyyy').format(picked);
          createdDateController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
        });
      }
  }
  
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать заказ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Заголовок',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Поле обязательно';
                    }
                      return null;
                  },
                ),
                TextFormField(
                  controller: contentController,
                  decoration: const InputDecoration(
                    labelText: 'Текст',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Поле обязательно';
                    }
                      return null;
                  },
                ),
                TextFormField(
                  controller: releaseDateController,
                  decoration: InputDecoration(
                    labelText: 'Дата реализции',
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectData(context);
                      },
                      icon: Icon(Icons.edit_calendar))
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty){
                      return 'Поле обязательно';
                    }
                      return null;
                  },
                  onTap: () {
                    _selectData(context);
                  },
                  readOnly: true,
                ),
                TextFormField(
                  controller: extraController,
                  decoration: const InputDecoration(
                    labelText: 'Дополнительно',
                  ),
                ),
                SizedBox(
                  height: 20, 
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final newNote = {
                        'title': titleController.text,
                        'content': contentController.text,
                        'createdDate': createdDateController.text,
                        'releaseDate': releaseDateController.text,
                        'extra': extraController.text,  
                      };
                      Navigator.pop(context, newNote);
                    }
                  }, 
                  child: const Text('Добавить заметку')
                ),
              ],
            ),
        ),
      ),
    );
  }
}