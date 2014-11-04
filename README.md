Informator
==========

Системные зависимости
----------

* [Ruby](https://www.ruby-lang.org/) version 2.0.0 (рекомендуется [rbenv](https://github.com/sstephenson/rbenv) + [ruby-build](https://github.com/sstephenson/ruby-build) 2.1.4)

* Gem [Feedjira](https://github.com/feedjira/feedjira), применяемый для быстрой загрузки и разбора потоков,
использует для загрузки Gem [Curb](https://github.com/taf2/curb), который является
привязкой системной библиотеки [libcurl](http://curl.haxx.se/libcurl/) к языку _Ruby_.
Поэтому в системе перед установкой **Feedjira** должна быть установлена библиотека [libcurl](http://curl.haxx.se/libcurl/).
Описание установки см. на указанных страницах.

Для Ubuntu 14.XX системные зависимости устанавливаются так: 

```
sudo apt-get install ruby libcurl3 libcurl3-gnutls libcurl4-openssl-dev libsqlite3-dev
```

Пояснения к принятым решениям
----------

### Ruby on Rails 4.2

Предварительная версия [Ruby on Rails 4.2.0.beta2](https://github.com/rails/rails) необходима для использования
нового фреймворка [Active Job](https://github.com/rails/rails/tree/master/activejob). 
Он позволяет планировать и запускать отдельные задания (такие, 
которые нужно периодически запускать в фоне, например, обновление записей в базе) — **Jobs** `(app/jobs)`,
используя один из предоставленных адаптеров к существующим queue-системам выполнения заданий. 
Также предоставлен простейший Inline-адаптер, который не требует сторонних queue-систем и дополнительных процессов, 
но не является _асинхронным_, т.е. вызвавший процесс ждет выполнения **Job** и странички не будут загружаться, пока выполняется действие. 
Для асинхронного выполнения заданий можно использовать адаптер и queue-систему [Delayed::Job](https://github.com/collectiveidea/delayed_job) (см. ниже). 

* Подробнее об **Active Job** и адаптерах:
[RoR Guides](http://edgeguides.rubyonrails.org/active_job_basics.html) |
[RoR API](http://edgeapi.rubyonrails.org/classes/ActiveJob.html)

* Указания к обновлению приложения до **Ruby on Rails 4.2**:
[RoR Guides](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html) |
[RailsApps](http://railsapps.github.io/updating-rails.html)

Сервисы
----------

### Сервер Puma

Используется сервер [Puma](http://puma.io), т.к. поддерживает Server-sent events.
Перед первым запуском приложения следует установить Gem `bundler`, необходимые Gems из `Gemfile`,
создать БД, загрузить схему БД и заполнить данные (настройки) по умолчанию, в Rails 4.2 эти действия автоматически выполняет скрипт:
`bin/setup` для среды разработки development или `RAILS_ENV=production bin/setup` для среды production.

Запуск приложения в среде разработки development:

```
ADMIN_NAME=admin ADMIN_PASSWORD=admin bin/rails s -b localhost
```

В среде production:

```
ADMIN_NAME=admin ADMIN_PASSWORD=admin SECRET_KEY_BASE=$(rake secret) bin/rails s -e production -b 0.0.0.0 -p 80
```

### Clockwork

Для запуска Jobs с определенным интервалом используется [Clockwork](https://github.com/tomykaira/clockwork) - удобная альтернатива cron для Ruby.
**Clockwork** использует таблицу настройку `:frequency` таблицы `Setting` и благодаря этому меняет интервал выполнения заданий без перезапуска (см. раздел **Use with database events** в описании расширения).
В файле `config/clock.rb` указаны выполняемые Jobs.
Clockwork включает в себя как обычное консольное приложение, так и daemon - сервисный вариант приложения - clockworkd.
Для управления Clockwork и Clockworkd следует использовать следующие строки:

```
clockwork config/clock.rb
clockworkd --clock=config/clock.rb --dir=. --log --log-dir=log start|stop|restart
```

Для удобства запуска созданы binstubs с уже заданными параметрами командной строки, которые запускаются так:

```
bin/clockwork
bin/clockworkd start|stop|restart
```

### Delayed::Job

Для асинхронного выполнения заданий (jobs) вместо Inline-адаптера Active Job можно использовать адаптер к queue-системе [Delayed::Job](https://github.com/collectiveidea/delayed_job).
Delayed::Job требует дополнительную таблицу в БД и запущенный фоновый процесс (worker). 
Для этого надо раскомментировать соответствующую строку в `Gemfile`: `gem 'delayed_job_active_record'` и произвести установку `bundle install`. 
Затем следует сгенерировать таблицу, необходимую для Delayed::Job, следующим образом:

```
rails generate delayed_job:active_record
rake db:migrate
```

В файле `config/application.rb` нужно установить соответствующий Active Job-адаптер  вместо `:inline`:

`config.active_job.queue_adapter = :delayed_job`

Команды управления daemon'ом:

`bin/delayed_job start|stop|restart`

После этих действий все Jobs, посылаемые Clockwork'ом на выполнение, буду обработаны worker'ом Delayed::Job и выполнены асинхронно с основным приложением.
Никаких других изменений в самом приложении не требуется.

Принцип работы приложения
-------

Настройки приложения содержатся в единственной записи таблицы `Setting`.

`Setting.first.feedlist` - Имя текстового файла (локального, либо _URI файла в сети_) со списком разрешенных источников.
По умолчанию: `"config/feeds.txt"`. Нельзя изменить из интерфейса приложения в целях безопасности.
Можно поменять либо вручную в базе, либо указать в качестве параметра метода `Feed.load_file` в `config/initializers/informator_loader.rb`.
Формат файла: построчный список URL.
При запуске приложения файл считывается в базу источников.

`Setting.first.noticelist` - Имя текстового файла (локального, либо _URI файла в сети_) с объявлениями организации.
По умолчанию: `"config/notices.md"`. Нельзя изменить из интерфейса приложения в целях безопасности.
Можно поменять вручную в базе.
Формат файла: Markdown, каждое объявление начинается с заголовка первого уровня с его названием.

```
# Заголовок объявления 1
Объявление 1 в формате Markdown
# Заголовок объявления 2
Объявление 2 в формате Markdown
```

При запуске приложения файл считывается в базу объявлений.

Другие настройки описаны в административном интерфейсе приложения `/admin/index`.

Данные для входа в административный интерфейс задаются переменными окружения при запуске `ADMIN_NAME=admin ADMIN_PASSWORD=admin`

Отображение новостей доступно по адресу: `/display/index`.


TODO
----------

* Фон
* FeedTable: цветные кнопки
* EntryTable: колонка - цветное устаревание и дата
* Плавное прокручивание
* Поля ввода времени
* Сообщения
* Spritz?