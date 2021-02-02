class Game {
  int round = 1;
  int month = 1;
  void incrementRound() {
    round++;
  }

  void decrementRound() {
    round--;
  }

  void incrementMonth() {
    month++;
    if (month % 12 == 0) {
      month = 12;
    } else {
      month %= 12;
    }
  }

  void decrementMonth() {
    month--;
    if (month < 1) {
      month = 12;
    }
  }
}
