import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '文本比较',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: TextComparisonPage(),
    );
  }
}

class TextComparisonPage extends StatefulWidget {
  @override
  _TextComparisonPageState createState() => _TextComparisonPageState();
}

class _TextComparisonPageState extends State<TextComparisonPage> {
  final TextEditingController _text1Controller = TextEditingController();
  final TextEditingController _text2Controller = TextEditingController();
  final TextEditingController _customRulesController = TextEditingController();
  Map<String, dynamic> _result = {};
  bool _isLoading = false;
  bool _ignoreWhitespace = false;
  bool _ignorePunctuation = false;
  bool _useCustomRules = false;

  Future<void> _compareTexts() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse('/api/compare'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'text1': _text1Controller.text,
        'text2': _text2Controller.text,
        'ignore_whitespace': _ignoreWhitespace,
        'ignore_punctuation': _ignorePunctuation,
        'use_custom_rules': _useCustomRules,
        'custom_rules': _customRulesController.text,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        _result = json.decode(response.body);
      });
    } else {
      setState(() {
        _result = {'error': '出错了，请稍后再试。'};
      });
    }
  }

  void _showCustomRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('自定义规则'),
          content: TextField(
            controller: _customRulesController,
            maxLines: null,
            decoration: InputDecoration(
              hintText: '输入规则，格式：\n- 字符1:字符2\n* 字符串1:字符串2',
              border: OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文本比较'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  ComparisonOptions(
                    ignoreWhitespace: _ignoreWhitespace,
                    ignorePunctuation: _ignorePunctuation,
                    useCustomRules: _useCustomRules,
                    onIgnoreWhitespaceChanged: (value) {
                      setState(() {
                        _ignoreWhitespace = value;
                      });
                    },
                    onIgnorePunctuationChanged: (value) {
                      setState(() {
                        _ignorePunctuation = value;
                      });
                    },
                    onUseCustomRulesChanged: (value) {
                      setState(() {
                        _useCustomRules = value;
                        if (value) {
                          _showCustomRulesDialog();
                        }
                      });
                    },
                    onEditCustomRules: _showCustomRulesDialog,
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextInputBox(
                            controller: _text1Controller,
                            label: '文本1',
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextInputBox(
                            controller: _text2Controller,
                            label: '文本2',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _compareTexts,
                    child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('比较'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: ResultDisplay(result: _result),
            ),
          ],
        ),
      ),
    );
  }
}

class ComparisonOptions extends StatelessWidget {
  final bool ignoreWhitespace;
  final bool ignorePunctuation;
  final bool useCustomRules;
  final ValueChanged<bool> onIgnoreWhitespaceChanged;
  final ValueChanged<bool> onIgnorePunctuationChanged;
  final ValueChanged<bool> onUseCustomRulesChanged;
  final VoidCallback onEditCustomRules;

  const ComparisonOptions({
    Key? key,
    required this.ignoreWhitespace,
    required this.ignorePunctuation,
    required this.useCustomRules,
    required this.onIgnoreWhitespaceChanged,
    required this.onIgnorePunctuationChanged,
    required this.onUseCustomRulesChanged,
    required this.onEditCustomRules,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('比较选项:', style: TextStyle(fontWeight: FontWeight.bold)),
        SwitchListTile(
          title: Text('忽略空白字符'),
          value: ignoreWhitespace,
          onChanged: onIgnoreWhitespaceChanged,
        ),
        SwitchListTile(
          title: Text('忽略中英文标点差异'),
          value: ignorePunctuation,
          onChanged: onIgnorePunctuationChanged,
        ),
        SwitchListTile(
          title: Text('使用自定义规则'),
          value: useCustomRules,
          onChanged: onUseCustomRulesChanged,
        ),
        if (useCustomRules)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: ElevatedButton(
              onPressed: onEditCustomRules,
              child: Text('编辑自定义规则'),
            ),
          ),
      ],
    );
  }
}


class TextInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const TextInputBox({Key? key, required this.controller, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
        ),
        maxLines: null,
        expands: true,
      ),
    );
  }
}

class ResultDisplay extends StatelessWidget {
  final Map<String, dynamic> result;

  const ResultDisplay({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (result.isEmpty) {
      return Container();
    }

    if (result.containsKey('error')) {
      return Text(result['error'], style: TextStyle(color: Colors.red));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SimilarityDisplay(similarity: result['similarity']),
        SizedBox(height: 16),
        Text(
          result['identical'] ? '两份文本完全相同（忽略空格和制表符）。' : '两份文本存在差异。',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: result['differences']?.length ?? 0,
            itemBuilder: (context, index) {
              final diff = result['differences'][index];
              return DifferenceCard(
                type: diff['type'],
                text1: diff['text1'],
                text2: diff['text2'],
              );
            },
          ),
        ),
      ],
    );
  }
}

class SimilarityDisplay extends StatelessWidget {
  final String similarity;

  const SimilarityDisplay({Key? key, required this.similarity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = double.parse(similarity.replaceAll('%', '')) / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('相似度:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueGrey),
          minHeight: 20,
        ),
        SizedBox(height: 4),
        Text(similarity, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class DifferenceCard extends StatelessWidget {
  final String type;
  final String text1;
  final String text2;

  const DifferenceCard({Key? key, required this.type, required this.text1, required this.text2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('差异类型: $type', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('文本1: $text1'),
            SizedBox(height: 4),
            Text('文本2: $text2'),
          ],
        ),
      ),
    );
  }
}