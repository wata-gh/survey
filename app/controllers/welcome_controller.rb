class WelcomeController < ApplicationController
  def index
    @surveys = Surveys.page(params[:page]).eager_load(:questions).order(:updated_at => :desc)
  end
end
