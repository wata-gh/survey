# coding: utf-8
require 'rails_helper'

describe QuestionDecorator do
  let(:question) { Question.new.extend QuestionDecorator }
  subject { question }
  it { should be_a Question }
end
