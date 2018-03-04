class CreateCharacteristics < ActiveRecord::Migration[5.1]
  def change
    create_table :characteristics do |t|
      t.string :type, null: false
      t.string :value
      t.references :service, null: false
    end
  end
end
