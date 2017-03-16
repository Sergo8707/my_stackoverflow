# frozen_string_literal: true
FactoryGirl.define do
  factory :vote do
    user
    association :votable
    rating 1
  end
end
