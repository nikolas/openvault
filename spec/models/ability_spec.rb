require 'spec_helper'
require "cancan/matchers"

describe Ability do
  describe "an logged in scholar" do
    subject { Ability.new(FactoryGirl.create(:user, role: 'scholar'))}
    describe "working on CustomCollections" do
      it { should be_able_to(:index, CustomCollection) }
      it { should be_able_to(:create, CustomCollection) }
      it { should be_able_to(:show, CustomCollection) }
      it { should be_able_to(:new, CustomCollection) }
      it { should be_able_to(:destroy, CustomCollection) }
    end
  end

  describe "a logged in member" do
    subject { Ability.new(FactoryGirl.create(:user))}
    it { should be_able_to(:index, CustomCollection) }
    it { should_not be_able_to(:create, CustomCollection) }
    it { should_not be_able_to(:new, CustomCollection) }
    it { should be_able_to(:show, CustomCollection) }
  end

end