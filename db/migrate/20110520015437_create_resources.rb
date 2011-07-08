class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.string :username
      t.string :user_id
      t.string :resource_id

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
