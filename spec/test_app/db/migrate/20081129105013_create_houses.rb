class CreateHouses < ActiveRecord::Migration
  def self.up
    create_table :houses do |t|
      t.string :name
      t.belongs_to :school
      t.belongs_to :head
    end

    change_table :users do |t|
      t.belongs_to :house
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :house_id
    end

    drop_table :houses
  end
end
