Informator
==========

Системные зависимости
----------

* [Ruby](https://www.ruby-lang.org/) version 2.1.3 (рекомендуется [rbenv](https://github.com/sstephenson/rbenv))

* Gem [Feedjira](https://github.com/feedjira/feedjira), применяемый для быстрой загрузки и разбора потоков,
использует для загрузки Gem [Curb](https://github.com/taf2/curb), который является
привязкой системной библиотеки [libcurl](http://curl.haxx.se/libcurl/) к языку _Ruby_.
Поэтому в системе перед установкой **Feedjira** должна быть установлена библиотека [libcurl](http://curl.haxx.se/libcurl/).
Описание установки см. на указанных страницах.

* Все используемые расширения _Ruby Gems_ см. в файле `Gemfile`. Для их автоматической установки следует использовать Gem [Bundler](http://bundler.io/): установка: `gem install bundler`, затем выполнить `bundle install` в каталоге приложения.


Пояснения к принятым решениям
----------

### Ruby on Rails 4.2

Предварительная версия Gem [Ruby on Rails 4.2.0.beta2](https://github.com/rails/rails) необходима для использования
нового фреймворка [Active Job](https://github.com/rails/rails/tree/master/activejob). 
Он позволяет планировать и запускать отдельные задания (такие, 
которые нужно периодически запускать в фоне, например, обновление записей в базе) — **Jobs** `(app/jobs)`,
используя один из предоставленных адаптеров к существующим queue-системам выполнения заданий. 
Также предоставлен простейший Inline-адаптер, который не требует сторонних queue-систем и дополнительных процессов, 
но не является _асинхронным_, т.е. вызвавший процесс ждет выполнения **Job** и странички не будут загружаться, пока выполняется действие. 
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

Используется сервер [Unicorn](http://unicorn.bogomips.org/). Запуск:

`unicorn_rails`

### Clockwork

Для запуска Jobs с определенным интервалом используется [Clockwork](https://github.com/tomykaira/clockwork) - удобная альтернатива cron для Ruby.
**Clockwork** использует таблицу настройку `:frequency` таблицы `Setting` и благодаря этому меняет интервал выполнения заданий без перезапуска (см. раздел **Use with database events** в описании расширения).
В файле `config/clock.rb` указаны выполняемые Jobs.

В комплекте с Clockwork идёт daemon (сервисный вариант приложения) clockworkd.
Для управления daemon'ом следует использовать следующую строку:

`bin/clockworkd --clock config/clock.rb --dir=. --log --log-dir=log start|stop|restart`

Для удобства запуска в корне приложения создан скрипт `jobsender` с этой строчкой, который запускается так:

`./jobsender start|stop|restart`

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

После этих действий все Jobs, посылаемые Clockwork'ом на выполнение, буду обработаны worker'ом Delayed::Job и выполнены асинхронно с основным приложением.

Принцип работы приложения
-------

Настройки приложения содержатся в единственной записи таблицы `Setting`.
`Setting.first.feedlist` - Имя текстового файла (локального, либо _URI файла в сети_) со списком разрешенных источников.
По умолчанию: `"config/feeds.txt"`. Нельзя изменить из интерфейса приложения в целях безопасности.
Можно поменять либо вручную в базе, либо указать в качестве параметра метода `Feed.load_file` в `config/initializers/informator_loader.rb`.
Формат файла: построчный список URL.
При запуске приложения файл считывается в базу источников.

Другие настройки описаны в административном интерфейсе приложения `/admin/index`.

TODO
----------

* Загрузка объявлений. Так как разрешенные источники берутся из внешнего файла ради безопасности, то и объявления организации имеет смысл брать из внешнего источника, представленного RSS-лентой.
* Отображение новостей с [WebSockets](https://developer.mozilla.org/en-US/docs/WebSockets) либо [Server-sent events](https://developer.mozilla.org/en-US/docs/Server-sent_events) и [DOM Storage](https://developer.mozilla.org/en-US/docs/Web/Guide/API/DOM/Storage).
* Поля времени заменить на удобные.
* Тесты.