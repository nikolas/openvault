require 'spec_helper'

describe UsersController do

  let(:scholar) { FactoryGirl.create(:scholar_user) }
  let(:member) { FactoryGirl.create(:user) }
  let(:org) { orgs.first }
  let(:orgs) { FactoryGirl.create_list(:org, 3) }
  before(:each) { scholar.save and member.save and org.save }

  describe "#scholar" do
    it 'responds with 200 success if user is a a scholar' do
      get :scholar, username: scholar.username
      expect(response.code).to eq "200"
    end

    it 'responds with 404 if user is not a scholar' do
      expect{get :scholar, username: member.username}.to raise_error
    end
  end

  describe 'POST add_orgs' do
    describe 'with one org' do
      pending 'saves association between User instance and a the Org instance' do
        # post :add_orgs, id: @user.to_param, org_ids: @orgs.map{ |org| org.id }
        # TODO: verify respose -- see controller for what to expect
        fail
      end
    end

    describe 'with multiple orgs' do

      pending 'saves assocaition between User instance and multiple Org instances' do
        # post :add_orgs, id: @user.to_param, org_ids: @orgs.map{ |org| org.id }
        # TODO: verify respose -- see controller for what to expect
        fail
      end
    end

  end
end
