class CreateInstances < ActiveRecord::Migration[5.1]
  def change
    create_table :instances do |t|
      t.references :attributable, polymorphic: true
    end
  end
end

