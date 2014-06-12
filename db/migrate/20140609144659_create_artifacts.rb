class CreateArtifacts < ActiveRecord::Migration
  def change
    create_table :artifacts do |t|
      t.string :state
      t.string :solr_document_id
      t.timestamps
    end
  end
end
