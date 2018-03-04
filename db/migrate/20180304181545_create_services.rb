class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.string :type, null: false
      t.boolean :hidden, null: false, default: false
      t.boolean :primary, null: false, default: false
    end
  end
end
