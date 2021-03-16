// imports
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

var lastMap;
onNewRanked() {
  // start interval
  var timer = new Timer.periodic(const Duration(seconds: 30), (timer) {
    onTimeOut();
  });
}
// get latest beatmap scraper
onTimeOut() async {
  // read config.json as text
  var raw_config = await File('./config.json').readAsString();
  // parse config.json text as array
  var config = json.decode(raw_config);
  // send request to osu beatmap listing website
  http.Response response = await http.get(Uri.parse('https://osu.ppy.sh/beatmapsets'));
  // parse request to html document
  Document document = parser.parse(response.body);
  // parse beatmaps as json
  var beatmaps = json.decode(document.getElementById('json-beatmaps').text);
  // find latest beatmap id
  var id = beatmaps['beatmapsets'][0]['beatmaps'][0]['beatmapset_id'];
  // if the id is different from latest map then continue
  if (id != lastMap) {
    // post message to webhook
    await http.post(Uri.parse(config['webhook']),
    headers: <String, String>{
      'Content-Type': 'application/json',
    },
    body: jsonEncode(<String, String>{
      'content': 'New ranked beatmap added to osu: https://osu.ppy.sh/beatmapsets/${id}',
    }));
    // set latest map variable to current map
    lastMap = id;
  };
}