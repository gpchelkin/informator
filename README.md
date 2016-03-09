Informator
==========

Приложение _доступно_ [2016.03.09] в интернете:

* [Отображение новостей](http://178.62.56.106/)
* [Панель администратора](http://178.62.56.106/admin)
* Имя пользователя: `admin`, пароль: `password`

TODO
----------

* Показывать сообщения организации
* [Crono](https://rubygems.org/gems/crono) (?)
* [Spritz](https://spritzinc.atlassian.net/wiki/display/jssdk/JavaScript+SDK+Documentation) (?)

Особенности
----------

* Плавная прокрутка
* Фон для отображения
* Две новости на экране
* Время отображения зависит от количества слов, коэффициент в настройках
* Дата в региональном формате (в зависимости от локали)
* Картинки (можно проверить с источником Lenta.ru)
* QR-коды
* /display доступен на корне /
* Вход с Devise по имени пользователя и паролю
* EntryTable: колонка с цветным устареванием и временем
* FeedTable: цветные кнопки
* ZURB Foundation 6

Системные зависимости
----------

* [Ruby](https://www.ruby-lang.org/) version 2.3.0 (рекомендуется [rbenv](https://github.com/rbenv/rbenv) + [ruby-build](https://github.com/rbenv/ruby-build) или [chruby](https://github.com/postmodern/chruby) + [ruby-install](https://github.com/postmodern/ruby-install))

* Gem [Paperclip](https://github.com/thoughtbot/paperclip), применяемый для изменения размера и хранения изображений,
использует системный пакет программ [ImageMagick](http://www.imagemagick.org/).
Описание установки см. на указанной странице.

Для Debian / Ubuntu системные зависимости устанавливаются так:

```
sudo apt install libsqlite3-dev imagemagick
```

Пояснения к принятым решениям
----------

### Ruby on Rails 4.2

Версия [Ruby on Rails 4.2](https://github.com/rails/rails) необходима для использования
нового фреймворка [Active Job](https://github.com/rails/rails/tree/master/activejob). 
Он позволяет планировать и запускать отдельные задания (такие, 
которые нужно периодически запускать в фоне, например, обновление записей в базе) — **Jobs** `(app/jobs)`,
используя один из предоставленных адаптеров к существующим queue-системам выполнения заданий. 
Также предоставлен простейший Inline-адаптер, который не требует сторонних queue-систем и дополнительных процессов, 
но не является _асинхронным_, т.е. вызвавший процесс ждет выполнения **Job** и странички не будут загружаться, пока выполняется действие. 
Для асинхронного выполнения заданий можно использовать адаптер и queue-систему [Delayed::Job](https://github.com/collectiveidea/delayed_job) (см. ниже). 

* Подробнее об **Active Job** и адаптерах:
[RoR Guides](http://guides.rubyonrails.org/active_job_basics.html) |
[RoR API](http://api.rubyonrails.org/classes/ActiveJob.html)

* Указания к обновлению приложения до **Ruby on Rails 4.2**:
[RoR Guides](http://guides.rubyonrails.org/upgrading_ruby_on_rails.html) |
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
bin/rails s
```

В среде production (ключ -d для запуска как службы):

```
SECRET_KEY_BASE=$(rake secret) bin/rails s -e production -b 0.0.0.0 -p 80 [-d]
```

Остановка службы:

```
kill -9 $(cat tmp/pids/server.pid)
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
При первом запуске приложения файл считывается в базу источников.

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

При каждом запуске приложения файл считывается в базу объявлений.

Данные для входа в административный интерфейс задаются созданием пользователя в консоли:

```
bin/rails console -env p
Admin.create!(username: "admin", password: "password", password_confirmation: "password")
```

Смена пароля:

```
bin/rails console -env p
Admin.find_by(username: "admin").update!(password: "newpassword", password_confirmation: "newpassword")
```

Другие настройки описаны в административном интерфейсе приложения `/admin`.

Отображение новостей доступно по корневому адресу.