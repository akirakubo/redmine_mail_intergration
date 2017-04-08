# redmine_mail_intergration

これは[redmine_mail_intergration](https://github.com/YusukeKokubo/redmine_mail_intergration)の改変版です。

動作確認については、以下の環境で行っています(Redmineのインストールには[redmine-centos-ansible](https://github.com/farend/redmine-centos-ansible)を使用)。

* CentOS Linux release 7.3.1611 Minimal
* Redmine 3.33.2.stable.16519
* Ruby 2.3.3-p222 (2016-11-21) [x86_64-linux]
* Rails 4.2.7.1

## インストール方法

1. ```#{RAILS_ROOT}/plugins```(動作確認環境と同一であれば `/var/lib/redmine/plugins`)で

    ```
    git clone https://github.com/akirakubo/redmine_mail_intergration.git
    ```

    を実行

2. ```#{RAILS_ROOT}```(動作確認環境と同一であれば `/var/lib/redmine`)で

    ```
    bundle exec rake redmine:plugins:migrate RAILS_ENV=production
    ```
 
    を実行

3. Redmineを再起動

なお、
```
bundle exec rake redmine:plugins:migrate RAILS_ENV=production NAME=redmine_mail_intergration VERSION=0
```
とし、```#{RAILS_ROOT}/plugins/redmine_mail_intergration```を削除することによりアンインストールが可能です。
