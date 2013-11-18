ActiveAdmin.register User do
  index do
    column(:id) {|user| link_to(user.id, admin_user_path(user)) }
    column :email
    column :created_at
    column :admin
    column :supporter
  end  

  show do |user|
    attributes_table do
      row :id
      row :email
      row :created_at
      row :updated_at
      row :api_key
      row :admin
      row :supporter
    end
    active_admin_comments
  end

  sidebar "User Details", only: [:show, :edit] do
    ul do
      li link_to("Cards", admin_user_cards_path(user))
    end
  end

  controller do
    def permitted_params
      params.permit(:user => [:email, :api_key, :admin, :supporter])
    end
  end
end
