# coding: utf-8
require 'rails_helper'

describe SingleChoiceDecorator do
  let(:single_choice) { SingleChoice.new.extend SingleChoiceDecorator }
  subject { single_choice }
  it { should be_a SingleChoice }
end
