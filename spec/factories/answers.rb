# frozen_string_literal: true
FactoryGirl.define do
  sequence :body do |n|
    "Answer #{n} text"
  end

  factory :answer do
    body
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    association :question, factory: :question, title: 'Text', body: 'MyText'
  end
end
