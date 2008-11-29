class CreateStudents < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :type
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :type
    end
  end
end
