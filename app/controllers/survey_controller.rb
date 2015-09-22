class SurveyController < ApplicationController
  before_action :find_survey, except: [:create]

  def index
  end

  def create
    @survey = Surveys.new survey_params
    if @survey.save
      flash[:success] = 'アンケート作成しました。'
      respond_to do |fmt|
        fmt.json { render json: {is_success: 1, results: @survey} }
      end
    else
      respond_to do |fmt|
        fmt.json { render json: {is_success: 0} }
      end
    end
  end

  def edit
    set_questions
  end

  def update
    halt 404 if @survey.is_secret && @survey.hash_key != params[:surveys][:hash_key]
    begin
      Surveys.transaction do
        @survey.questions.destroy_all
        @survey.update! survey_params
      end
      par = {:id => @survey.id}
      par[:hash_key] = @survey.hash_key if @survey.is_secret
      redirect_to ({action: 'edit'}), notice: '更新に成功しました。'
    rescue
      set_questions
      render action: 'edit'
    end
  end

  def result
  end

  def destroy
    begin
      Surveys.transaction do
        @survey.destroy!
      end
      redirect_to ({controller: 'welcome', action: 'index'}), :notice => 'アンケートの削除に成功しました。'
    rescue
      gon.questions = @survey.questions.as_json(:methods => [:error_class, :text_error_class, :value_error_class, :value_data])
      flash.now[:alert] = '削除に失敗しました。'
      render action: 'edit'
    end
  end

  private
  def find_survey
    @survey = Surveys.find params[:id]
  end

  def survey_params
    params.require(:surveys).permit(:name, :is_result_secret, :is_secret, questions_attributes: [:text, :type, :value])
  end

  def set_questions
    gon.questions = @survey.questions.as_json(:methods => [:error_class, :text_error_class, :value_error_class, :value_data])
  end
end
