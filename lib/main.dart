import 'package:dio_with_pythonanywhere/api/api_call.dart';
import 'package:dio_with_pythonanywhere/model/book.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dio Networking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const GetBooks(),
    );
  }
}

class GetSingleBook extends StatefulWidget {
  const GetSingleBook({super.key});

  @override
  State<GetSingleBook> createState() => _GetSingleBookState();
}

class _GetSingleBookState extends State<GetSingleBook> {
  final _client = DioClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Info'),
      ),
      body: Center(
        child: FutureBuilder<Data?>(
          future: _client.getBook(id: '1'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Data? bookInfo = snapshot.data;
              if (bookInfo != null) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(bookInfo.id.toString()),
                    ),
                    title: Text(
                      bookInfo.title.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(bookInfo.releaseDate.toString()),
                    trailing: Text(bookInfo.pages.toString()),
                  ),
                );
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class CreateBook extends StatefulWidget {
  const CreateBook({super.key});

  @override
  State<CreateBook> createState() => _CreateBookState();
}

class _CreateBookState extends State<CreateBook> {
  final _client = DioClient();

  final id = TextEditingController();
  final pages = TextEditingController();
  final releaseDate = TextEditingController();
  final title = TextEditingController();

  String? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create Book'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: "Enter id"),
                textInputAction: TextInputAction.next,
                controller: id,
                onChanged: (value) {
                  id.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length));
                },
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextField(
                textInputAction: TextInputAction.next,
                decoration:
                    const InputDecoration(hintText: "Enter number of pages"),
                controller: pages,
                onChanged: (value) {
                  pages.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length));
                },
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextField(
                textInputAction: TextInputAction.next,
                decoration:
                    const InputDecoration(hintText: "Enter release date"),
                controller: releaseDate,
                onChanged: (value) {
                  releaseDate.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length));
                },
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextField(
                textInputAction: TextInputAction.done,
                decoration:
                    const InputDecoration(hintText: "Enter title of the book"),
                controller: title,
                onChanged: (value) {
                  title.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length));
                },
                keyboardType: TextInputType.text,
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    bool isValid = _checkValidity();
                    if (isValid) {
                      Data book = Data(
                          id: int.parse(id.text),
                          pages: int.parse(pages.text),
                          releaseDate: releaseDate.text,
                          title: title.text);

                      result = await _client.createBook(book: book);
                      showMessage(result!);
                    } else {
                      result = "Please fill up all the fields!";
                      showMessage(result!);
                    }
                  },
                  child: const Text("Create Book"))
            ],
          ),
        ),
      ),
    );
  }

  bool _checkValidity() {
    return id.text.isNotEmpty &&
        pages.text.isNotEmpty &&
        releaseDate.text.isNotEmpty &&
        title.text.isNotEmpty;
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class GetBooks extends StatefulWidget {
  const GetBooks({super.key});

  @override
  State<GetBooks> createState() => _GetBooksState();
}

class _GetBooksState extends State<GetBooks> {
  final _client = DioClient();

  Future<Book?> getBookList() async {
    return await _client.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: Center(
        child: FutureBuilder<Book?>(
          future: getBookList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Book? bookInfo = snapshot.data;
              if (bookInfo != null) {
                return ListView.builder(
                  itemCount: bookInfo.books?.length,
                  itemBuilder: (context, index) {
                    Data? book = bookInfo.books?.elementAt(index);
                    return book == null
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateBook(book: book),
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(8)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    child: Text(book.id.toString()),
                                  ),
                                  title: Text(
                                    book.title.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(book.releaseDate.toString()),
                                  trailing: Column(
                                    children: [
                                      Text(book.pages.toString()),
                                      const Spacer(),
                                      InkWell(
                                          onTap: () async {
                                            String message =
                                                await _client.deleteBook(
                                                    title:
                                                        book.title.toString());

                                            showMessage(message);
                                            setState(() {
                                              
                                            });

                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                );
              }
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class UpdateBook extends StatefulWidget {
  UpdateBook({super.key, required this.book});

  Data book;

  @override
  State<UpdateBook> createState() => _UpdateBookState();
}

class _UpdateBookState extends State<UpdateBook> {
  final _client = DioClient();

  final id = TextEditingController();
  final pages = TextEditingController();
  final releaseDate = TextEditingController();
  final title = TextEditingController();

  @override
  void initState() {
    id.value = TextEditingValue(
        text: widget.book.id.toString(),
        selection:
            TextSelection.collapsed(offset: widget.book.id.toString().length));

    pages.value = TextEditingValue(
        text: widget.book.pages.toString(),
        selection: TextSelection.collapsed(
            offset: widget.book.pages.toString().length));

    releaseDate.value = TextEditingValue(
        text: widget.book.releaseDate.toString(),
        selection: TextSelection.collapsed(
            offset: widget.book.releaseDate.toString().length));

    title.value = TextEditingValue(
        text: widget.book.title.toString(),
        selection: TextSelection.collapsed(
            offset: widget.book.title.toString().length));
    super.initState();
  }

  String? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Update Book'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(hintText: "Enter id"),
                textInputAction: TextInputAction.next,
                controller: id,
                onChanged: (value) {
                  id.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length));
                },
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextField(
                readOnly: true,
                enabled: false,
                textInputAction: TextInputAction.next,
                decoration:
                    const InputDecoration(hintText: "Enter number of pages"),
                controller: pages,
                onChanged: (value) {
                  pages.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length));
                },
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextField(
                textInputAction: TextInputAction.next,
                decoration:
                    const InputDecoration(hintText: "Enter release date"),
                controller: releaseDate,
                onChanged: (value) {
                  releaseDate.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length));
                },
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  FocusScope.of(context).nextFocus();
                },
              ),
              TextField(
                readOnly: true,
                enabled: false,
                textInputAction: TextInputAction.done,
                decoration:
                    const InputDecoration(hintText: "Enter title of the book"),
                controller: title,
                onChanged: (value) {
                  title.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length));
                },
                keyboardType: TextInputType.text,
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              ElevatedButton(
                  onPressed: () async {
                    bool isValid = _checkValidity();
                    if (isValid) {
                      Data book = Data(
                          id: widget.book.id,
                          pages: widget.book.pages,
                          releaseDate: releaseDate.text,
                          title: widget.book.title);

                      result = await _client.updateBook(book: book);
                      showMessage(result!);
                    } else {
                      result = "Please checkout the release date fields!";
                      showMessage(result!);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GetBooks(),
                        ),(route) => false);
                  },
                  child: const Text("Update Book"))
            ],
          ),
        ),
      ),
    );
  }

  bool _checkValidity() {
    return releaseDate.text.isNotEmpty;
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
