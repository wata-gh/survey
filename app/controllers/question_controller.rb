class QuestionController < ApplicationController
  before_action :find_question, only: :show

  def show
    c = @survey.collaborators.eager_load(:answers).find_by uuid: session[:uuid]
    @answer = c.answers.where(question_id: @question.id).first_or_initialize
  end

  private
  def find_question
    @question = Question.joins(:surveys).includes(:surveys).find params[:id]
    @survey = @question.surveys
  end
end
