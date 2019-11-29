FactoryBot.define do
  factory :label do
    name {'test_label1'}
  end

  factory :label2, class: Label do
    name {'test_label2'}
  end

  factory :label3, class: Label do
    name {'test_label3'}
  end

  factory :label4, class: Label do
    name {'test_label4'}
  end

  factory :label5, class: Label do
    name {'test_label5'}
  end
end
