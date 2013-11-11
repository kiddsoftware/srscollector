ActiveAdmin.register Card do
  belongs_to :user, optional: true

  index do
    column(:id) {|card| link_to(card.id, admin_card_path(card)) } 
    column :user
    column :state
    column :front
    column :back
    column :updated_at
  end

  controller do
    def scoped_collection
      resource_class.includes(:user)
    end
  end
end
