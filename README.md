# 青色申告決算書＆仕訳帳システム 

個人事業主用の「青色申告決算書の作成支援」と「仕訳帳を管理」するシステムです。  
初心者でも扱いやすいように基本的な「仕訳の記入例」を付属しています。
  
DEMO    
[https://www.petitmonte.com/rails-demo/fsjs](https://www.petitmonte.com/rails-demo/fsjs)  
  
主な対象は「広告収入」や「業務請負」など仕訳が単純な方用です。  
※小売業や製造原価には対応していません。   
  
これはライトバージョンです。フルバージョンの開発は検討中です。  
フルバージョンになると勘定科目が一気に増えるので、初心者の方の仕訳や操作が難しくなります。  

## 1. 基本情報

### 前提条件 
・事業で使用する「通帳」は1つとします。  
・事業で利用する「クレジットカード」はその通帳で引き落とされるものとします。  
※通帳、クレジットカードは事業主による私的利用があっても構いません。  

### 青色申告決算書 
システムが出力できるのは次の3つの表です。  
  
・損益計算書  
・貸借対照表   
・月別売上(収入)金額及び仕入金額 ※売上のみ   
  
税務署に提出する際には上記の表を元に  
[国税庁のWebサイト(確定申告書等作成コーナー)](https://www.keisan.nta.go.jp/kyoutu/ky/sm/top#bsctrl)で「正式な書式」の青色申告決算書を作成します。  

### 勘定科目 

損益計算書で対応している科目  ※経費科目に全て対応。
```rb
租税公課、荷造運賃、水道光熱費、旅費交通費、通信費、広告宣伝費、接待交際費、損害保険料、修繕費 
消耗品費、減価償却費、福利厚生費、給料賃金、外注工賃、利子割引料、地代家賃、貸倒金、雑費

```   
貸借対照表で対応している科目  
```rb
現金、その他の預金、前払金、未払金、事業主貸、事業主借、元入金
```   
以下の科目が必要な場合は各自でプログラムを変更する必要があります。  
```rb
当座預金、定期預金、受取手形、売掛金、有価証券、棚卸資産、貸付金、建物、建物附属設備、機械装置、
車両運搬具、工具・器具・備品、土地、支払手形、買掛金、借入金、前受金、預り金、貸倒引当金
```   

## 2. 環境
・Ruby 2.6.5  
・Rails 6.0.2 (2019/12/18版)  
・MariaDB 10.2.2以上 (MySQL5.5.8以上でも可)  
 
 
## 3. インストール方法
  
### database.yml  
config/database.ymlでデータベース設定を行います。  
  
### fsjs_accounts.csv 
勘定科目マスタ(fsjs_accounts)のCSVデータです。phpMyAdminなどを利用してインポートして下さい。  

### bundle  
```rb
bundle install 
```

### マスタキーの生成 
・/config/master.key  
・/config/credentials.yml.enc  
は削除しています。次のコマンドで再生成します。  
```rb
EDITOR=vi bin/rails credentials:edit   
```  
ファイル生成後、credentials.yml.encの編集画面が表示されるので:q!で終了します。

development.rb/production.rbの両方に  
```rb
config.require_master_key = true  
``` 
を定義しているのでマスタキーの生成は必須です。   
  
### Webpackerのインストール  
node_modulesフォルダ及びyarn.lockファイルを削除していますので次のコマンドでインストールします。  
```rb  
bin/rails webpacker:install  
```
### フォルダの生成
```rb  
app/assetsにimagesフォルダを手動で生成する。 
```
※コレを行わないと「Completed 500 Internal Server Error」になりますのでご注意。  
  
### CSS/JSファイルをプリコンパイルする
```rb  
bin/rails assets:precompile  
```  

### 管理ユーザーの作成
```rb  
bin/rails c  
  
user = FsjsUser.new(name: '名前', password: 'パスワード', password_confirmation:'パスワード', admin: true)  
user.save  
exit 
```  

### 一般ユーザーの作成
```rb  
bin/rails c  
  
user = FsjsUser.new(name: '名前', password: 'パスワード', password_confirmation:'パスワード', admin: false)  
user.save  
exit 
```  
※2種類の権限がありますが、今回はどちらも変わりはありません。必要であれば、各自でコーディングして下さい。
  
## 4. Rails6プロジェクトの各種初期設定
その他は次の記事を参照してください。  
  
[Rails6プロジェクトの各種初期設定](https://www.petitmonte.com/ruby/rails6_project.html)  
