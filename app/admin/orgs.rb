ActiveAdmin.register Org, as: "Organization" do

  index do
    column :name
    column "Description", :desc do |org|
      truncate(org.desc, :length => 50)
    end
  end
  
end
