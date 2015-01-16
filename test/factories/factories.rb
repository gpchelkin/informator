FactoryGirl.define do
  factory :admin do
    username ('a'..'z').to_a.shuffle[0,8].join
    encrypted_password Devise.bcrypt(Admin, 'password')
  end


  factory :feed do
    url "http://news.yandex.ru/index.rss"
    use true
  end

end