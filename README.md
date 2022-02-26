# CTAProject2022Answer

## セットアップ
Mintでライブラリのバージョン管理をしているため、  
以下のコマンドで`mint`のインストールを済ませておく  
`$ brew install mint`  

Mintのインストールができたらクローンする  
`$ git clone https://github.com/sosuiiii/CTAProject2022Answer.git`  

クローンをしたら  
`$ make setup`  
bundle管理の人は  
`$ make setup-b`  
を実行する

## レビュー観点
- DIしているか
- インターフェスを作っているか
- MVVMになっているか
  - KickStarterのVMデザインパターン
  - Unioを使ったVMデザインパターン
- テストコードを書いているか
 - mockoloを使っているか
 - WatchStackのコード渡しても良さそう
- swiftGenを使っているか

## ソース(限定共有含む)
- [ DI ](https://qiita.com/Sossiii/private/c12bcabc33d5692125f9)
- [ インターフェース ](https://qiita.com/Sossiii/private/3517907127e39dfe00e2)
- [ 今回導入した環境について ](https://www.notion.so/MTG-621838c625a147e3b22f6ba97f940aff)
- [ weak self ](https://www.notion.so/weak-self-807dfd0edd964677baf2f9992478497f)
- [ KickStarterのViewModelデザインパターン ](https://www.notion.so/KickStarter-ViewModel-3928bc79bb514f53bcf465e63a1a4a69)
- [ Unioを使ったViewModelデザインパターン ](https://www.notion.so/Unio-ViewModel-106256b3bbe74bb4bc0904fac52b1631)
- [ RxSwift/Observables ](https://github.com/ReactiveX/RxSwift/tree/main/RxSwift/Observables9)
- [ iOSエンジニアが面接で聞かれそうな質問集100 ](https://nsblogger.hatenablog.com/entry/2016/12/24/ios_interview)
- [ アーキテクチャについてまとめ ](https://www.notion.so/90752906ab5f4b979730f6b18da6bf969)
- [ ビジネスロジックとは ](https://qiita.com/os1ma/items/25725edfe3c2af93d7359)
- [ クリーンアーキテクチャについてわかりやすい記事 ](https://qiita.com/koutalou/items/07a4f9cf51a2d13e4cdc)
