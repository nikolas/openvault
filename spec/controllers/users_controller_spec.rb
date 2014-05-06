require 'spec_helper'

describe UsersController do

  describe "#scholar" do
    it 'responds with 200 success if user is a a scholar' do
      scholar = create(:user, role: "scholar")
      get :scholar, username: scholar.username
      expect(response.code).to eq "200"
    end


    it 'responds with 404 if user is not a scholar' do
      not_scholar = create(:user, role: "member")
      expect{get :scholar, username: not_scholar.username}.to raise_error
    end
  end


  describe 'POST add_orgs' do

    before :each do
      @user = create(:user)
    end

    describe 'with one org' do

      before :each do
        @org = create(:org)
      end

      pending 'saves association between User instance and a the Org instance' do
        # post :add_orgs, id: @user.to_param, org_ids: @orgs.map{ |org| org.id }
        # TODO: verify respose -- see controller for what to expect
      end
    end

    describe 'with multiple orgs' do

      before :each do
        @orgs = create_list(:org, 3)
      end

      pending 'saves assocaition between User instance and multiple Org instances' do
        # post :add_orgs, id: @user.to_param, org_ids: @orgs.map{ |org| org.id }
        # TODO: verify respose -- see controller for what to expect
      end
    end

  end  
end
