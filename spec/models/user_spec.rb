require 'spec_helper'

# NOTE: FactoryGirl shortcut methods (create, build, attributes_for, etc.) are included in spec_helper.rb

describe User do

  describe "has a factory that" do

    it "creates a valid user (saved to db)" do
      saved_user = create(:user)
      saved_user.should be_valid
      User.where(:email => saved_user.email).count.should == 1
    end

    it "builds a valid user (not saved to db)" do
      unsaved_user = build(:user)
      unsaved_user.should be_valid
      User.where(:email => unsaved_user.email).count.should == 0
    end

    it "returns a hash of fields => values to simulate user input for creating a new user" do
      unsaved_user_attributes = attributes_for(:user)
      unsaved_user_attributes.should be_a Hash
      User.where(:email => unsaved_user_attributes[:email]).count.should == 0
    end

  end

end