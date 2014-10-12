Informator
==========

Системные зависимости
----------

* [Ruby](https://www.ruby-lang.org/) version 2.1.2

* Требуемые _Ruby Gem_'ы см. в файле `Gemfile`, для их автоматической установки следует использовать команду `bundle install`

* _Gem_ [Feedjira](https://github.com/feedjira/feedjira), применяемый для загрузки и разбора потоков,
использует для запросов _Gem_ [Curb](https://github.com/taf2/curb), который является
привязкой библиотеки [libcurl](http://curl.haxx.se/libcurl/) к языку _Ruby_.
Следовательно, в системе должна быть установлена библиотека [libcurl](http://curl.haxx.se/libcurl/).
Описание установки см. на указанных страницах.

Пояснения к решениям, используемым в приложении
----------

### _Gem_ [Ruby on Rails 4.2.0.beta2](https://github.com/rails/rails)

Предварительная версия **Ruby on Rails 4.2** необходима для использования
нового фреймворка [Active Job](https://github.com/rails/rails/tree/master/activejob). 
**Active Job** позволяет планировать и запускать отдельные задания - **Jobs** 
(например, обновление записей, очистка записей в базе - те, которые нужно периодически запускать в фоне), 
используя один из предоставленных адаптеров к существующим queue-системам выполнения заданий. 
Также предоставлен простейший **Inline**-адаптер, который не требует сторонних queue-систем и дополнительных процессов, 
но не является асинхронным, т.е. вызвавший процесс ждет выполнения **Job**. 
Для асинхронного выполнения заданий можно использовать _Gem_ [Delayed::Job](https://github.com/collectiveidea/delayed_job), 
который требует доп. таблицу в БД и запущенный фоновый процесс (worker). 
При этом для переключения с **Inline** на **Delayed::Job** необходимо лишь поменять 
соответствующую установку в `config/application.rb`, в приложении ничего менять не понадобится, 
благодаря универсальному фреймворку.

* Подробнее об **Active Job** и его адаптерах:
[edgeguides.rubyonrails.org](http://edgeguides.rubyonrails.org/active_job_basics.html)
[edgeapi.rubyonrails.org](http://edgeapi.rubyonrails.org/classes/ActiveJob.html)

* Указания к обновлению до **Ruby on Rails 4.2**:
[edgeguides.rubyonrails.org](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html)
[railsapps.github.io](http://railsapps.github.io/updating-rails.html)

Сервисы
----------

### [Clockwork](https://github.com/tomykaira/clockwork)

Для запуска Jobs с определенным интервалом использован данный Gem - удобная альтернатива cron для Ruby.
Для подробностей о работе см. раздел **Use with database events** в описании расширения.
**Clockwork** использует таблицу Setting (см. Use with database events).
В файле `config/clock.rb` указано, как часто проверять
`bin/clockd start|stop|restart|run`

Настройки
----------
Хранятся в единственной записи таблицы `Setting` - `Setting.first`.

### mode

Режим работы приложения.
По умолчанию: `true`.

* `true` - Автоматический режим

    * Удалять _все_ устаревшие записи (если автоочистка включена, см. **expiration**)
    * Загружать новые записи и _отмечать_ все загруженные записи как "для отображения"

* `false` - Ручной режим

    * Удалять _только неотмеченные_ устаревшие записи (если автоочистка включена, см. **expiration**)
    * Загружать новые записи и _не отмечать_ все загруженные записи как "для отображения"

### frequency

Частота обновления (очистки и загрузки) записей в базе. Используется в **Clockwork**.
По умолчанию: `14400`

### expiration

Время устаревания записей. При каждом обновлении записи старше, чем это время, будут стерты, в зависимости от режима (см. **mode**)
По умолчанию: `86400`

### style

Стиль отображения новостей.
По умолчанию: `1`.

### feedlist

Имя файла (относительно корневого пути приложения) со списком источников. Список построчный с комментарием `#` для отключенных источников.
По умолчанию: `"config\feeds.txt"`.

Принцип работы приложения
----------

Как запустить
----------