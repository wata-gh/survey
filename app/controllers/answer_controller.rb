class AnswerController < ApplicationController
  before_action :find_info, only: [:create, :update]

  def create
    @answer.attributes = answer_params
    # override text if question is multiple or date
    @answer.text = params.fetch(:answer, {})[:text].to_json if @question.multiple_choice? || @question.date_choice?
    @answer.save!

    return redirect_to survey_question_path(@survey, @question.next) if @question.next
    @collaborator.done!
    redirect_to finish_survey_path
  end

  alias_method :update, :create

  private
  def answer_params
    params.fetch(:answer, {text: ''}).permit :text
  end

  def find_info
    @survey = Surveys.current_group(request.subdomain).my_answer params, session[:uuid]
    @question = @survey.questions.first
    @collaborator = @survey.collaborators.first
    @answer = @collaborator.answers.where(question_id: @question.id).first_or_initialize
  end
end
