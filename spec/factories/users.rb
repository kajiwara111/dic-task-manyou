FactoryBot.define do
  factory :user do
    name { 'user1' }
    email { 'user1@gmail.com' }
    password { 'password' }
    password_confirmation {'password'}
    admin { "admin" } #DBにはtrue, falseで登録。デフォルトはfalseなので記載しなければfalseになる。enumで定義した文字列でcreateすればDBにはtrue,falseで入る。    
  end

  factory :user2, class: User do
    name { 'user2' }
    email { 'user2@gmail.com' }
    password { 'password' }
    password_confirmation {'password'}
    admin { "admin" }    
  end

  factory :user3, class: User do
    name { 'user3' }
    email { 'user3@gmail.com' }
    password { 'password' }
    password_confirmation {'password'}
    admin { "not_admin" }   
  end

  factory :user4, class: User do
    name { 'user4' }
    email { 'user4@gmail.com' }
    password { 'password' }
    password_confirmation {'password'}
    admin { "not_admin" }    
  end

  factory :invalid_user1, class: User do
    name { 'u' * 31 }
    email { 'invalid_user1@gmail.com' }
    password { 'password' }
    password_confirmation {'password'}
    admin { true }    
  end

  factory :invalid_user2, class: User do
    name { 'invalid_user2' }
    email { 'invalid_user2@gmail' }
    password { 'password' }
    password_confirmation {'password'}
    admin { false }    
  end

  factory :invalid_user3, class: User do
    name { 'invaid_user3' }
    email { 'invalid_user3@gmail.com' }
    password { 'passw' }
    password_confirmation {'passw'}
    admin { false }    
  end
end
