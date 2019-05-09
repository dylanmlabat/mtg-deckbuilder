class CreateDecksTable < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :name
      t.string :format
      t.string :colors
      t.string :decklist
    end
  end
end
