# coding: utf-8
require 'rails_helper'

describe DateChoiceDecorator do
  let(:date_choice) { DateChoice.new.extend DateChoiceDecorator }
  subject { date_choice }
  it { should be_a DateChoice }
end
