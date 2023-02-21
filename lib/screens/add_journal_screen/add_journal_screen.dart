import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/helpers/weekday.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';

class AddJounalScreen extends StatelessWidget {
  final Journal journal;
  final bool isEditing;
  AddJounalScreen({Key? key, required this.journal, required this.isEditing})
      : super(key: key);

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contentController.text = journal.content;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          WeekDay(journal.createdAt).toString(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              registerJournal(context);
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: _contentController,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
            fontSize: 24,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Descrição...',
          ),
          expands: true,
          minLines: null,
          maxLines: null,
        ),
      ),
    );
  }

  registerJournal(BuildContext context) {
    String content = _contentController.text;
    journal.content = content;
    JournalService service = JournalService();
    if (isEditing) {
      service
          .register(journal)
          .then((value) => {Navigator.pop(context, value)});
    } else {
      service
          .edit(journal.id, journal)
          .then((value) => {Navigator.pop(context, value)});
    }
  }
}
