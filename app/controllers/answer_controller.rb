class AnswerController < ApplicationController
  def create
    s = Surveys.eager_load(:questions, :collaborators).find_by({
      id: params[:survey_id],
      questions: {
        id: params[:question_id]
      },
      collaborators: {
        uuid: session[:uuid]
      }
    })
    q = s.questions.first
    c = s.collaborators.first

    if q.date?
      p params
      t = {}
      q.each_date.each {|d| t[d] = params[d]}
      params[:answer] = {
        text: {
          name:    params[:name],
          comment: params[:comment],
          date:    t,
        }.to_json
      }
      p params
    end

    a = c.answers.where(question_id: q.id).first_or_initialize answer_params
    # override text if question is multiple
    a.text = params[:answer][:text].to_json if q.multiple?
    a.text = params[:answer][:text] if q.date?
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

  def save_answer
  end
end
