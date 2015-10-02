# coding: utf-8
require 'rails_helper'

describe MultipleChoiceDecorator do
  let(:multiple_choice) { MultipleChoice.new.extend MultipleChoiceDecorator }
  subject { multiple_choice }
  it { should be_a MultipleChoice }
end
