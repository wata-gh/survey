# coding: utf-8
require 'rails_helper'

describe FreeChoiceDecorator do
  let(:free_choice) { FreeChoice.new.extend FreeChoiceDecorator }
  subject { free_choice }
  it { should be_a FreeChoice }
end
