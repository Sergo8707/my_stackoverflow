# frozen_string_literal: true
class RatingShouldAlwaysBe < ActiveRecord::Migration[5.0]
  def change
    change_column :votes, :rating, :integer, null: false
  end
end
