class AnswerController < ApplicationController
  def create
    s = Surveys.current_group(request.subdomain).eager_load(:questions, :collaborators).find_by({
      id: params[:survey_id],
      questions:     {id:   params[:question_id]},
      collaborators: {uuid: session[:uuid]}
    })
    q = s.questions.first
    c = s.collaborators.first

    if params[:answer].present?
      a = c.answers.where(question_id: q.id).first_or_initialize answer_params
      # override text if question is multiple or date
      a.text = params[:answer][:text].to_json if q.multiple? || q.date?
      a.save!
    else
      # if no answer pathed destroy all answers for this question.
      c.answers.where(question_id: q.id).destroy_all
    end

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
