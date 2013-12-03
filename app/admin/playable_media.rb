ActiveAdmin.register PlayableMedia do
  controller do
    # It's the admin interface, just let everything through.
    def permitted_params
      params.permit!
    end
  end
end
