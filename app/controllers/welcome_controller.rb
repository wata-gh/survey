class WelcomeController < ApplicationController
  def index
    @surveys = Surveys.page(params[:page]).joins(:group).eager_load(:questions).current_group(request.subdomain).order(:updated_at => :desc)
  end
end
