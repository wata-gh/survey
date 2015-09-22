require 'rails_helper'

RSpec.describe SurveyController, type: :controller do
  describe 'POST #create' do
    context 'パラメータが渡されていない時' do
      it 'ParameterMissingが発生すること' do
        expect{post :create}.to raise_error ActionController::ParameterMissing
      end
    end

    context 'パラメータが渡されている時' do
      it 'ステータスコードが200が返ること' do
        xhr :post, :create, {survey: {name: 'test_survey'}}
        expect(response.status).to eq(200)
        expect(assigns(:survey).name).to eq('test_survey')
        res = JSON.parse response.body
      end
    end
  end
end
