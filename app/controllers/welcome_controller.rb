class WelcomeController < ApplicationController
  def index
    puts '=' * 100
    @surveys = Surveys.page(params[:page]).references(:questions).includes(:questions).order(:updated_at => :desc)
  end
end
