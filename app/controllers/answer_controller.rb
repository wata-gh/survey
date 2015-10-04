class AnswerController < ApplicationController
  def create
    s = Surveys.current_group(request.subdomain).my_answer params, session[:uuid]
    q = s.questions.first
    c = s.collaborators.first
    a = c.answers.where(question_id: q.id).first_or_initialize

    if params[:answer].present?
      a.attributes = answer_params
      # override text if question is multiple or date
      a.text = params[:answer][:text].to_json if q.multiple? || q.date?
    end
    a.save!

    return redirect_to survey_question_path(s, q.next) if q.next
    c.done!
    redirect_to finish_survey_path
  end

  alias_method :update, :create

  private
  def answer_params
    params.require(:answer).permit :text
  end
end
