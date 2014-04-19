module ApplicationHelper

  # allow login from everywhere
  def user_resource_name
    :user
  end

  def user_resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
