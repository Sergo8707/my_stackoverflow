# frozen_string_literal: true
class AddAdminFlagToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :admin, :boolean
  end
end