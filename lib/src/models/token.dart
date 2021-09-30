enum TokenType {
  word,
  command,
  entryCommand,
  exitCommand,
}

enum Command {
  hp,
  list,
  linebreak,
  footnote,
  blockquote,
}

class Token {
  final String src;
  late final TokenType type;
  late final Command? command;

  Token(this.src) {
    if (src.contains('[hpbegin]') ||
        src.contains('[listbegin]') ||
        src.contains('[bq/]')) {
      type = TokenType.entryCommand;
      command = src.startsWith('[hp')
          ? Command.hp
          : src.startsWith('[list')
              ? Command.list
              : Command.blockquote;
    } else if (src.contains('[hbend]') ||
        src.contains('[listend]') ||
        src.contains('[/bq]')) {
      type = TokenType.exitCommand;
      command = src.startsWith('[hp')
          ? Command.hp
          : src.startsWith('[list')
              ? Command.list
              : Command.blockquote;
    } else if (src.startsWith('[')) {
      type = TokenType.command;
      if (src.contains('hp') ||
          src.contains('li') ||
          src.contains('lb') ||
          src.contains('br') ||
          src.contains('pg')) {
        command = Command.linebreak;
      } else if (src.contains('fn')) {
        command = Command.footnote;
      }
    } else {
      type = TokenType.word;
      command = null;
    }
    assert(type == TokenType.word ? command == null : command != null);
  }

  static List<Token> splitFrom(String string) =>
      string.split(' ').map((e) => Token(e)).toList();
}
