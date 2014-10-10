# Informator

В этом документе описаны шаги, необходимые для запуска приложения, а также пояснения к решениям, используемым в приложении.

## Системные зависимости

* [Ruby](https://www.ruby-lang.org/) version 2.1.2

* Требуемые Gems см. в файле `Gemfile`, для их установки следует использовать команду `bundle install`

* Gem [Feedjira](https://github.com/feedjira/feedjira), применяемый для загрузки и разбора подписок,
использует для запросов Gem [Curb](https://github.com/taf2/curb), который является
привязкой библиотеки [libcurl](http://curl.haxx.se/libcurl/) к языку Ruby.
Следовательно, в системе должна быть установлена библиотека libcurl. Описание установки см. на указанных страницах.

## Пояснения к решениям

### Gem [Rails 4.2.0.beta2](https://github.com/rails/rails)

Предварительная версия Rails 4.2 используется для использования
нового добавленного фреймворка [Active Job](https://github.com/rails/rails/tree/master/activejob).
Он позволяет планировать и запускать отдельные задания - Jobs (например, обновление записей, очистка записей в базе - те, которые следует запускать периодически в фоне),
используя один из предоставленных адаптеров к существующим queue-системам выполнения заданий.
Также предоставлен простейший inline-адаптер, который не требует сторонних систем и дополнительных процессов,
но не является асинхронным, т.е. при вызове Job основное приложение ждет его выполнения.
Для асинхронного выполнения заданий можно использовать Gem [Delayed::Job](https://github.com/collectiveidea/delayed_job), 
который требует доп. таблицу в БД и запущенный фоновый процесс (worker).
При этом для переключения с Inline на Delayed::Job необходимо лишь поменять соответствующую установку в `config/application.rb`,
в приложении ничего менять не следует, благодаря фреймворку.

Подробнее об Active Job:
[edgeguides.rubyonrails.org](http://edgeguides.rubyonrails.org/active_job_basics.html)
[edgeapi.rubyonrails.org](http://edgeapi.rubyonrails.org/classes/ActiveJob.html)

Указания по обновлению до Rails 4.2:
[edgeguides.rubyonrails.org](http://edgeguides.rubyonrails.org/upgrading_ruby_on_rails.html)
[railsapps.github.io](http://railsapps.github.io/updating-rails.html)

### Gem [Clockwork](https://github.com/tomykaira/clockwork)

Для запуска Jobs с определенным интервалом использован данный Gem - альтернатива cron для Ruby.
Для подробностей о работе см. раздел **Use with database events** в описании.


## Конфигурирование

Настройки по умолчанию 

## Сервисы

**Clockwork** использует таблицу Setting (см. Use with database events).
В файле `clock.rb` указано, как часто проверять
`clockwork clock.rb`