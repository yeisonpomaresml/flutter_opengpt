import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  bool loading = false;
  var controller = TextEditingController();
  var controllerResponse = TextEditingController();
  var urlImage =
      "https://lh3.googleusercontent.com/jUoaTIlBn5ibfQcND2n5OMD6Z7xoqNj-ShHlFR6QuLffLXD5pS8V2eNg1rGlrsRrnDkoQ28O8UHzqzBQKAGY4l1CS2NQSq2SkRScK6FOjl82jppyohK-";
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextFormField(controller: controller),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        loading = true;
                        setState(() {});
                        var url = Uri.https(
                            'api.openai.com', '/v1/images/generations');

                        final response = await http.post(url,
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              'Authorization':
                                  'Bearer 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',
                            },
                            body: jsonEncode(<String, String>{
                              'prompt': controller.text,
                              "size": "1024x1024"
                            }));

                        if (response.statusCode == 200) {}
                        final body = json.decode(response.body);
                        urlImage = body["data"][0]["url"];
                        loading = false;
                        setState(() {});
                      },
                child: const Text("Image GPT")),
            SizedBox(
              width: 10,
            ),
            loading == false ? Container() : CircularProgressIndicator(),
            SizedBox(
              width: 10,
            ),
            ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        loading = true;
                        setState(() {});
                        var url =
                            Uri.https('api.openai.com', '/v1/completions');

                        final response = await http.post(url,
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                              'Authorization':
                                  'Bearer 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',
                            },
                            body: jsonEncode(<String, String>{
                              'model': "text-davinci-003",
                              'prompt': controller.text
                            }));

                        if (response.statusCode == 200) {}
                        final body = json.decode(response.body);
                        controllerResponse.text = body["choices"][0]["text"];
                        loading = false;
                        setState(() {});
                      },
                child: const Text("Completions GPT"))
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Image(image: NetworkImage(urlImage)),
        SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: controllerResponse,
          minLines: 3,
          maxLines: 3,
        ),
      ],
    );
  }
}
