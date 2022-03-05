use strict;
use warnings;
use utf8;
use feature 'say';
binmode(STDOUT, ':utf8');

sub digraph ($) {
    shift->();
}

sub UNIVERSAL::AUTOLOAD {
    my ($graph) = $UNIVERSAL::AUTOLOAD;

    return if $graph =~ /DESTROY/;
    my ($src, $dst) = map { / / ? qq("$_") : $_ } split /::/, $graph;
    push @Digraph::stash, "    $src -> $dst;";
    Digraph->new;
}

package Digraph {
    our @stash = ();
    our $GRAPH_NAME = '(anonymous)';
    our $AUTOLOAD;

    sub new {
        my ($class) = @_;
        my $self = bless sub {
            say "digraph $GRAPH_NAME {";
            for (@stash) {
                say $_;
            }
            say '}';
        }, $class;
        $self;
    }

    sub AUTOLOAD {
        my ($self) = @_;
        return if $AUTOLOAD =~ /DESTROY/;

        my $name = $AUTOLOAD;
        $name =~ s/\ADigraph\:://;

        $GRAPH_NAME = $name;
        $self;
    }
}

digraph haisen {
    電子レンジラック -> 手前コンセント;
    冷蔵庫 -> 手前コンセント;
    延長コードB -> 電子レンジラック;
    三口タップ -> 電子レンジラック;
    電子レンジ -> 三口タップ;
    炊飯器 -> 三口タップ;
    電気ケトル -> 三口タップ;

    "Nintendo Switchドック" -> 延長コードB;
    延長コードD -> 延長コードB;

    ルーター -> 延長コードD;
    "Google Nest Mini" -> 延長コードD;
    ディスプレイ -> 延長コードD;
    パソコン -> 延長コードD;

    延長コードA -> 奥コンセント;

    ドライヤー -> 延長コードA;
    サーキュレーター -> 延長コードA;
    延長コードC -> 延長コードA;

    洗濯機 -> 延長コードC;

    ベッド -> 奥コンセント;
    USBタップ -> ベッド;

    エアコン -> エアコン用コンセント;
}

__END__
$ perl dot.pl | dot -Tpng -oout.png
$ open out.png
