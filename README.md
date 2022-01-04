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
