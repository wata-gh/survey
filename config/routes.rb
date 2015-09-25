Rails.application.routes.draw do
  root to: 'welcome#index'
  get  'survey/finish'     => 'survey#finish',   as: 'finish_survey'
  get  'survey/:id/result' => 'survey#result',   as: 'result_survey'
  resources :survey do
    resources :question, only: :show do
      resources :answer, only: [:create, :update]
    end
  end
end
