class CreateSchools < ActiveRecord::Migration
  def self.up
    create_table :schools do |t|
      t.string :name
    end

    change_table :users do |t|
      t.belongs_to :school
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :school_id
    end

    drop_table :schools
  end
end
