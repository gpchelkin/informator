Informator
==========

Системные зависимости
----------

* [Ruby](https://www.ruby-lang.org/) version 2.1.3 (

* Gem [Feedjira](https://github.com/feedjira/feedjira), применяемый для быстрой загрузки и разбора потоков,
использует для запросов Gem [Curb](https://github.com/taf2/curb), который является
привязкой системной библиотеки [libcurl](http://curl.haxx.se/libcurl/) к языку _Ruby_.
Поэтому в системе перед установкой **Feedjira** должна быть установлена библиотека [libcurl](http://curl.haxx.se/libcurl/).
Описание установки см. на указанных страницах.

* Остальные требуемые расширения- **Ruby Gems** см. в файле `Gemfile`. Для их автоматической установки следует использовать Gem Bundler: установка `gem install bundler`, затем выполнить `bundle install`


Пояснения к принятым решениям
----------

### Ruby on Rails 4.2

Предварительная версия Gem [Ruby on Rails 4.2.0.beta2](https://github.com/rails/rails) необходима для использования
нового фреймворка [Active Job](https://github.com/rails/rails/tree/master/activejob). 
Он позволяет планировать и запускать отдельные задания (такие, 
которые нужно периодически запускать в фоне, например, обновление записей в базе) — **Jobs** `(app/jobs)`,
используя один из предоставленных адаптеров к существующим queue-системам выполнения заданий. 
Также предоставлен простейший Inline-адаптер, который не требует сторонних queue-систем и дополнительных процессов, 
но не является _асинхронным_, т.е. вызвавший процесс ждет выполнения **Job**. 
Для асинхронного выполнения заданий можно использовать адаптер и queue-систему [Delayed::Job](https://github.com/collectiveidea/delayed_job), 
который требует доп. таблицу в БД и запущенный фоновый процесс (worker). 
При этом для переключения с **Inline** на **Delayed::Job** необходимо лишь поменять 
соответствующую установку в `config/application.rb`, в самом приложении изменений не требуется.

* Подробнее об **Active Job** и адаптерах:
[edgeguides.rubyonrails.org](http://edgeguides.rubyonrails.org/active_job_basics.html)
[edgeapi.rubyonrails.org](http://edgeapi.rubyonrails.org/classes/ActiveJob.html)

* Указания к обновлению приложения до **Ruby on Rails 4.2**:
[edgeguides.rubyonrails.org](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html)
[railsapps.github.io](http://railsapps.github.io/updating-rails.html)

Сервисы
----------

### Сервер Unicorn

Используется сервер [Unicorn](http://unicorn.bogomips.org/)

Запуск:

`unicorn_rails`

### Clockwork

Для запуска Jobs с определенным интервалом используется Gem [Clockwork](https://github.com/tomykaira/clockwork) - удобная альтернатива cron для Ruby.
**Clockwork** использует таблицу настройку `:frequency` таблицы `Setting` и меняет частоту выполнения заданий без перезапуска (см. раздел **Use with database events** в описании расширения).
В файле `config/clock.rb` указаны выполняемые Jobs.

Команды управления daemon'ом:

`bin/clockd start|stop|restart`

### Delayed::Job

Если требуется асинхронное выполнение заданий (jobs), можно использовать queue-систему [Delayed::Job](https://github.com/collectiveidea/delayed_job).
Для этого надо раскомментировать соответствующую строку в `Gemfile`: `gem 'delayed_job_active_record'` и произвести установку `bundle install`. 
Затем следует сгенерировать таблицу, необходимую для Delayed::Job, следующим образом:

```
rails generate delayed_job:active_record
rake db:migrate
```

В файле `config/application.rb` нужно установить соответствующий адаптер вместо `:inline`:

`config.active_job.queue_adapter = :delayed_job`

Команды управления daemon'ом:

`bin/delayed_job start|stop|restart`


Настройки
----------
Настройки содержатся в единственной записи таблицы `Setting` - `Setting.first`.

### :mode

Режим отбора записей.
По умолчанию: `false`.

* `true` - Автоматическое отображение загруженных новостей
* `false` - Ручной отбор новостей

### :frequency

Частота обновления (очистки и загрузки) записей в базе секундах. Используется в **Clockwork**.
По умолчанию: `14400` (4 часа)

### :expiration

Время устаревания записей. При каждом обновлении записи старше, чем это время, будут стерты, в зависимости от режима (см. **mode**)
По умолчанию: `86400` (24 часа)

### :style

Стиль отображения новостей.
По умолчанию: `1`.

### :feedlist

Имя файла (относительно корневого пути приложения) со списком источников. Список построчный с комментарием `#` для отключенных источников.
По умолчанию: `"config/feeds.txt"`.
Нельзя изменить из интерфейса в целях безопасности.
Формат файла:
```
#http://выключенный.источник
http://включенный.источник
```


TODO
----------

* Настройки доделать (модель Setting исправить без first везде?)
* Страница для введенных администратором новостей
* Картинки сохранять в базу(?)
* Аутентификация администратора
* Отображение новостей с использованием [WebSockets](https://developer.mozilla.org/en-US/docs/WebSockets) и [DOM Storage](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Storage)
* Тесты