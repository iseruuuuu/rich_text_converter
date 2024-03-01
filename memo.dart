/// This file is just a note to help me understand the flow.

import 'package:html/dom.dart';
import 'package:html/parser.dart';

String getSimpleText() {
  /// テキストを解析してドキュメントオブジェクトモデル（DOM）のフラグメントに変換
  /// 【DOMについて】https://developer.mozilla.org/ja/docs/Web/API/Document_Object_Model
  final document = parseFragment(_richText);

  /// 子ノードのリストを取得
  /// ドキュメントのルート要素直下にある全ての子要素にアクセスできる

  final children = document.children;

  /// 処理中に生成されるテキストを効率的に連結するために使用
  /// 複数の文字列を追加する際に、新しい文字列オブジェクトを何度も生成しないようにするためのもの
  final buffer = StringBuffer();
  writeBuffer(children, buffer);
  return buffer.toString();
}

var blockquoteCount = 0;

void writeBuffer(List<Element> children, StringBuffer buffer) {
  /// children（Elementのリスト）をループ処理
  for (final child in children) {
    /// もし現在のchild.localNameが<br>要素である場合は、StringBufferに改行記号\nを追加
    if (child.localName == 'br') {
      /// HTMLの改行要素をテキストの改行に変換する
      buffer.write('\n');
    } else {
      final children = child.children;

      ///　子要素がない場合は、テキストのみを含む要素とみなす。
      if (children.isEmpty) {
        final parent = child.parent;

        ///現在の要素の親要素から始めて、ドキュメントのルートに達するまで遡り、途中にある<blockquote>タグの数をカウント
        countBlockQuote(parent);
        if (blockquoteCount > 0) {
          /// blockquoteCountの数だけ'\t'追加して書き込む
          final blockQuotes = List.filled(blockquoteCount, '\t').join();
          buffer.write(blockQuotes);
        }
        // 文字のみを書き込む（シンプルテキストにする）
        buffer.write(child.text);

        /// 次の要素の処理に影響を与えないようにするため
        blockquoteCount = 0;
      } else {
        writeBuffer(children, buffer);
      }
    }
  }
}

void countBlockQuote(Element? element) {
  /// element(child.parentの親要素)がnullだったら何もしない
  if (element == null) {
    return;
  }

  ///　elementが<blockquote>要素であれば、`blockquoteCount++;`をする。
  if (element.localName == 'blockquote') {
    blockquoteCount++;
  }

  /// element.parentを引数としてcountBlockQuote関数を再度呼び出す
  /// 現在の要素の親要素に対して同じ処理が再帰的に適用され、最終的にはドキュメントのルート要素まで遡る
  /// 与えられた要素からドキュメントのルート要素に至るまでの間にある全ての<blockquote>要素がカウントされる。
  countBlockQuote(element.parent);
}

const _richText =
    '''<div><strong>太字</strong><br /></div><div><em>イタリック</em></div><div><span style=\"text-decoration:underline;\">下線</span></div><div>左寄せ</div><div style=\"text-align:center;\">真ん中寄せ</div><div style=\"text-align:right;\">左寄せ</div><div style=\"text-align:left;\"><ol><li>番号リスト</li></ol><div><ul><li>リスト</li></ul><div><span style=\"font-size:xx-large;\">極大</span></div></div><div><span style=\"font-size:medium;font-family:takao_mincho;\">フォント</span></div><p><span style=\"font-size:medium;\">段落</span></p><blockquote><span style=\"font-size:medium;\">引用</span></blockquote><blockquote><span style=\"font-size:medium;\">コード</span></blockquote><pre><span style=\"font-size:medium;\">整形済み</span></pre><h2><span style=\"font-size:medium;\">見出し２</span></h2><h3><span style=\"font-size:medium;\">見出し３</span></h3><div><span style=\"font-size:medium;\"><br /></span></div></div><blockquote style=\"margin:0 0 0 40px;border:none;padding:0px;\"><blockquote style=\"margin:0 0 0 40px;border:none;padding:0px;\"><div style=\"text-align:left;\"><div><span style=\"font-size:medium;\">インデント</span></div></div></blockquote><span style=\"font-size:medium;\">インデント解除</span></blockquote><span style=\"font-size:medium;color:#ff0033;\">文字色</span><div><span style=\"font-size:medium;color:#000000;background-color:rgb(0,255,0);\">文字背景色</span></div><div><span style=\"font-size:medium;color:#000000;background-color:rgb(0,255,0);\"><br /></span></div><div><span style=\"font-size:medium;color:#000000;\"><br /></span></div><div><span style=\"font-size:medium;color:#000000;\"><span style=\"background-color:rgb(255,255,255);\">https://flutter.dev/</span><br /></span></div><br /><br />''';
