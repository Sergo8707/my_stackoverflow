# frozen_string_literal: true
class AddBestFlagToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :best, :boolean, default: false
  end
end
