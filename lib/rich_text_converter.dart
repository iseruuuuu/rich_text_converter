import 'package:html/dom.dart';
import 'package:html/parser.dart';

String getSimpleText() {
  final document = parseFragment(_richText);
  final children = document.children;
  final buffer = StringBuffer();
  writeBuffer(children, buffer);
  return buffer.toString();
}

var blockquoteCount = 0;

void writeBuffer(List<Element> children, StringBuffer buffer) {
  for (final child in children) {
    if (child.localName == 'br') {
      buffer.write('\n');
    } else {
      final children = child.children;
      if (children.isEmpty) {
        final parent = child.parent;
        countBlockQuote(parent);
        if (blockquoteCount > 0) {
          final blockQuotes = List.filled(blockquoteCount, '\t').join();
          buffer.write(blockQuotes);
        }
        buffer.write(child.text);
        blockquoteCount = 0;
      } else {
        writeBuffer(children, buffer);
      }
    }
  }
}

void countBlockQuote(Element? element) {
  if (element == null) {
    return;
  }
  if (element.localName == 'blockquote') {
    blockquoteCount++;
  }
  countBlockQuote(element.parent);
}

const _richText =
    '''<div><strong>太字</strong><br /></div><div><em>イタリック</em></div><div><span style=\"text-decoration:underline;\">下線</span></div><div>左寄せ</div><div style=\"text-align:center;\">真ん中寄せ</div><div style=\"text-align:right;\">左寄せ</div><div style=\"text-align:left;\"><ol><li>番号リスト</li></ol><div><ul><li>リスト</li></ul><div><span style=\"font-size:xx-large;\">極大</span></div></div><div><span style=\"font-size:medium;font-family:takao_mincho;\">フォント</span></div><p><span style=\"font-size:medium;\">段落</span></p><blockquote><span style=\"font-size:medium;\">引用</span></blockquote><blockquote><span style=\"font-size:medium;\">コード</span></blockquote><pre><span style=\"font-size:medium;\">整形済み</span></pre><h2><span style=\"font-size:medium;\">見出し２</span></h2><h3><span style=\"font-size:medium;\">見出し３</span></h3><div><span style=\"font-size:medium;\"><br /></span></div></div><blockquote style=\"margin:0 0 0 40px;border:none;padding:0px;\"><blockquote style=\"margin:0 0 0 40px;border:none;padding:0px;\"><div style=\"text-align:left;\"><div><span style=\"font-size:medium;\">インデント</span></div></div></blockquote><span style=\"font-size:medium;\">インデント解除</span></blockquote><span style=\"font-size:medium;color:#ff0033;\">文字色</span><div><span style=\"font-size:medium;color:#000000;background-color:rgb(0,255,0);\">文字背景色</span></div><div><span style=\"font-size:medium;color:#000000;background-color:rgb(0,255,0);\"><br /></span></div><div><span style=\"font-size:medium;color:#000000;\"><br /></span></div><div><span style=\"font-size:medium;color:#000000;\"><span style=\"background-color:rgb(255,255,255);\">https://flutter.dev/</span><br /></span></div><br /><br />''';
