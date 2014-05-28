require 'spec_helper'
require 'pry'
describe CustomCollectionsController do
  let(:user) { FactoryGirl.create(:user_with_custom_collection) }
  before(:each) { user.save } # TODO: should not be necessary, but it is

  def valid_attributes
    FactoryGirl.attributes_for(:custom_collection, owner: user)
  end

  def invalid_attributes
    FactoryGirl.attributes_for(:custom_collection, owner: user, name: nil)
  end

  describe "as a scholar" do
    let(:custom_collection) { user.owned_collections.first }

    before :each do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    describe "GET index" do
      it "assigns all custom_collections as @custom_collections" do
        get :index, {}
        assigns(:custom_collections).should_not be_nil
      end
    end

    describe "GET show" do
      it "assigns the requested custom_collection as @custom_collection" do
        get :show, {:id => custom_collection.id}
        expect(assigns(:custom_collection)).to eq(custom_collection)
      end
    end

    describe "GET new" do
      it "assigns a new custom_collection as @custom_collection" do
        get :new, {}
        assigns(:custom_collection).should be_a_new(CustomCollection)
      end
    end

    describe "GET edit" do
      it "assigns the requested custom_collection as @custom_collection" do
        get :edit, {:id => custom_collection.id}
        assigns(:custom_collection).should eq(custom_collection)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new CustomCollection" do
          expect {
            post :create, {:custom_collection => valid_attributes}
          }.to change(CustomCollection, :count).by(1)
        end

        it "assigns a newly created custom_collection as @custom_collection" do
          post :create, {:custom_collection => valid_attributes}
          assigns(:custom_collection).should be_a(CustomCollection)
          assigns(:custom_collection).should be_persisted
        end

        it "redirects to the created custom_collection" do
          post :create, {:custom_collection => valid_attributes}
          response.should redirect_to(custom_collection_url(assigns(:custom_collection)))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved custom_collection as @custom_collection" do
          # Trigger the behavior that occurs when invalid params are submitted
          CustomCollection.any_instance.stub(:save).and_return(false)
          post :create, {:custom_collection => invalid_attributes}
          assigns(:custom_collection).should be_a_new(CustomCollection)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          CustomCollection.any_instance.stub(:save).and_return(false)
          post :create, {:custom_collection => invalid_attributes}
          response.should render_template :new
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested custom_collection" do
          # Assuming there are no other custom_collections in the database, this
          # specifies that the CustomCollection created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          CustomCollection.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
          put :update, {:id => custom_collection.id, :custom_collection => { "name" => "MyString" }}
        end

        it "assigns the requested custom_collection as @custom_collection" do
          put :update, {:id => custom_collection.id, :custom_collection => valid_attributes}
          assigns(:custom_collection).should eq(custom_collection)
        end

        it "redirects to the custom_collection" do
          put :update, {:id => custom_collection.id, :custom_collection => valid_attributes}
          response.should redirect_to(custom_collection_url(assigns(:custom_collection)))
        end
      end

      describe "with invalid params" do
        it "assigns the custom_collection as @custom_collection" do
          # Trigger the behavior that occurs when invalid params are submitted
          CustomCollection.any_instance.stub(:save).and_return(false)
          put :update, {:id => custom_collection.id, :custom_collection => invalid_attributes}
          assigns(:custom_collection).should eq(custom_collection)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          CustomCollection.any_instance.stub(:save).and_return(false)
          put :update, {:id => custom_collection.id, :custom_collection => invalid_attributes}
          response.should render_template("edit")
        end
      end
    end

  end

  describe "as a member" do
    let(:member) { FactoryGirl.create(:user)}
    let(:scholar) { FactoryGirl.create(:user, role: 'scholar') }
    let(:cc) { FactoryGirl.create(:custom_collection, owner: scholar) }

    before :each do
      sign_in member
    end

    describe "GET index" do
      it "gets all custom collections" do
        get :index, {}
        expect(assigns(:custom_collections)).to include(cc)
      end
    end

    describe "GET show" do
      it "assigns the requested custom collection to @cc" do
        get :show, {:id => cc.id}
        assigns(:custom_collection).should eq(cc)
      end
    end

    describe "GET new" do
      it "redirects to homepage when trying to create a collection as a member" do
        get :new, {}
        response.should redirect_to root_url
      end
    end

    describe "GET edit" do
      it "redirects to homepage when trying to edit a colleciton as a member" do
        get :edit, {:id => cc.id}
        response.should redirect_to root_url
      end
    end
  end
end
