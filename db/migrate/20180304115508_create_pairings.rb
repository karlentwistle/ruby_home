class CreatePairings < ActiveRecord::Migration[5.1]
  def change
    create_table :pairings do |t|
      t.boolean :admin, default: false, null: false
      t.string :identifier, null: false, index: true
      t.string :public_key, null: false
    end
  end
end
