class CreateZohoLeads < ActiveRecord::Migration
  def up
    create_table :zoho_leads do |t|
    	t.string :lead_source
    	t.string :company
    	t.string :firstname
    	t.string :lastname
    	t.string :gender
    	t.string :email
    	t.string :title
    	t.string :phone
    	t.string :mobile
      	t.timestamps
    end
  end

  def down
  	drop_table :zoho_leads
  end
end
