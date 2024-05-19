class UpdateContents < ActiveRecord::Migration[7.1]
  def change
    add_reference :contents, :user, foreign_key: true
  end
end
