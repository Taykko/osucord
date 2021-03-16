import './onNewRanked.dart' as scraper;
void main() {
  try {
    // start interval from main file
    scraper.onNewRanked();
  // error handler
  } catch(e) {
    print(e);
  }
}