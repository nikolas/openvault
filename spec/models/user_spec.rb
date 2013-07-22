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
    
    # it "returns a contact's full name as a string" do
    #   saved_user = create(:user)
    # end
    it "returns the proper work_string when both title and org or present" do
      saved_user = create(:user)
      saved_user.work_string.should eq("#{saved_user.title} at #{saved_user.organization}")
    end
    
    it "returns the proper work_string when just title is present" do
      saved_user = create(:user, organization: nil)
      saved_user.work_string.should eq("#{saved_user.title}")
    end
    
    it "returns the proper work_string when just org is present" do
      saved_user = create(:user, title: nil)
      saved_user.work_string.should eq("works at #{saved_user.organization}")
    end
    
    it "fails to save when user bio is greater than 500 characters" do
      unsaved_user = build(:user, bio: 'Aenean lacinia bibendum nulla sed consectetur. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Aenean lacinia bibendum nulla sed consectetur. Curabitur blandit tempus porttitor. Lorem ipsum dolor sit amet, consectetur adipiscing elit.Etiam porta sem malesuada magna mollis euismod. Aenean lacinia bibendum nulla sed consectetur. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Vestibulum id ligula porta felis euismod semper. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Vestibulum id ligula porta felis euismod semper. Aenean lacinia bibendum nulla sed consectetur.Vestibulum id ligula porta felis euismod semper. Donec sed odio dui. Donec sed odio dui. Nullam quis risus eget urna mollis ornare vel eu leo.Donec ullamcorper nulla non metus auctor fringilla. Maecenas faucibus mollis interdum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nulla vitae elit libero, a pharetra augue. Nullam id dolor id nibh ultricies vehicula ut id elit.Donec ullamcorper nulla non metus auctor fringilla. Maecenas faucibus mollis interdum. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nulla vitae elit libero, a pharetra augue. Nullam id dolor id nibh ultricies vehicula ut id elit.')
      unsaved_user.should_not be_valid
    end

  end

end