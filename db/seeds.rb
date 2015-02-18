# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Default settings:
Setting.create(mode: false, style: 1, expiration: 86400, frequency: 14400, autocleanup: true, feedlist: 'config/feeds.txt', noticelist: 'config/notices.md', display_frequency: 0.5)
# Default admin with password:
Admin.create(username: "admin", password: "password", password_confirmation: "password")