class CreateCharacteristics < ActiveRecord::Migration[5.1]
  def change
    create_table :characteristics do |t|
      t.integer :instance_id, null: false
      t.references :accessory, null: false
      t.references :service, null: false
      t.string :type, null: false
      t.string :value
    end
  end
end
