class CreateServices < ActiveRecord::Migration[5.1]
  def change
    create_table :services do |t|
      t.boolean :hidden, null: false, default: false
      t.boolean :primary, null: false, default: false
      t.integer :instance_id, null: false
      t.references :accessory, null: false
      t.string :type, null: false
    end
  end
end
