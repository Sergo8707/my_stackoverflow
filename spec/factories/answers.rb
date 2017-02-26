FactoryGirl.define do
  factory :answer do
    body 'MyText'
    association :question, factory: :question, title: 'Text', body: 'MyText'
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    association :question, factory: :question, title: 'Text', body: 'MyText'
  end
end
