require 'spec_helper'

describe CustomCollectionsController do
  
  #create a valid Custom Colleciton object
  def valid_attributes
    attributes_for(:custom_collection)
  end

  describe "as a scholar" do
    before :each do 
      @user = create(:user, role: 'scholar')
      sign_in @user
      @CustomCollection = attributes_for(:custom_collection, :user_id => @user.id)
    end
    describe "GET index" do
      it "assigns all custom_collections as @custom_collections" do
        custom_collection = CustomCollection.create! @CustomCollection
        get :index, {}
        assigns(:custom_collections).should eq([custom_collection])
      end
    end

    describe "GET show" do
      it "assigns the requested custom_collection as @custom_collection" do
        custom_collection = CustomCollection.create! @CustomCollection
        get :show, {:id => custom_collection.to_param}
        assigns(:custom_collection).should eq(custom_collection)
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
        custom_collection = CustomCollection.create! @CustomCollection
        get :edit, {:id => custom_collection.to_param}
        assigns(:custom_collection).should eq(custom_collection)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new CustomCollection" do
          expect {
            post :create, {:custom_collection => @CustomCollection}
          }.to change(CustomCollection, :count).by(1)
        end

        it "assigns a newly created custom_collection as @custom_collection" do
          post :create, {:custom_collection => @CustomCollection}
          assigns(:custom_collection).should be_a(CustomCollection)
          assigns(:custom_collection).should be_persisted
        end

        it "redirects to the created custom_collection" do
          post :create, {:custom_collection => @CustomCollection}
          response.should redirect_to("/me")
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved custom_collection as @custom_collection" do
          # Trigger the behavior that occurs when invalid params are submitted
          CustomCollection.any_instance.stub(:save).and_return(false)
          post :create, {:custom_collection => { "name" => "invalid value" }}
          assigns(:custom_collection).should be_a_new(CustomCollection)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          CustomCollection.any_instance.stub(:save).and_return(false)
          post :create, {:custom_collection => { "name" => "invalid value" }}
          response.should render_template :new
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested custom_collection" do
          custom_collection = CustomCollection.create! @CustomCollection
          # Assuming there are no other custom_collections in the database, this
          # specifies that the CustomCollection created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          CustomCollection.any_instance.should_receive(:update_attributes).with({ "name" => "MyString" })
          put :update, {:id => custom_collection.to_param, :custom_collection => { "name" => "MyString" }}
        end

        it "assigns the requested custom_collection as @custom_collection" do
          custom_collection = CustomCollection.create! @CustomCollection
          put :update, {:id => custom_collection.to_param, :custom_collection => @CustomCollection}
          assigns(:custom_collection).should eq(custom_collection)
        end

        it "redirects to the custom_collection" do
          custom_collection = CustomCollection.create! @CustomCollection
          put :update, {:id => custom_collection.to_param, :custom_collection => @CustomCollection}
          response.should redirect_to("/me")
        end
      end

      describe "with invalid params" do
        it "assigns the custom_collection as @custom_collection" do
          custom_collection = CustomCollection.create! @CustomCollection
          # Trigger the behavior that occurs when invalid params are submitted
          CustomCollection.any_instance.stub(:save).and_return(false)
          put :update, {:id => custom_collection.to_param, :custom_collection => { "name" => "invalid value" }}
          assigns(:custom_collection).should eq(custom_collection)
        end

        it "re-renders the 'edit' template" do
          custom_collection = CustomCollection.create! @CustomCollection
          # Trigger the behavior that occurs when invalid params are submitted
          CustomCollection.any_instance.stub(:save).and_return(false)
          put :update, {:id => custom_collection.to_param, :custom_collection => { "name" => "invalid value" }}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested custom_collection" do
        custom_collection = CustomCollection.create! @CustomCollection
        expect {
          delete :destroy, {:id => custom_collection.to_param}
        }.to change(CustomCollection, :count).by(-1)
      end

      it "redirects to the custom_collections list" do
        custom_collection = CustomCollection.create! @CustomCollection
        delete :destroy, {:id => custom_collection.to_param}
        response.should redirect_to(custom_collections_url)
      end
    end
  end
  
  describe "as a member" do
    before :each do
      @member = create(:user)
      @scholar = create(:user, role: 'scholar')
      @cc = create(:custom_collection, user_id: @scholar.id)
      sign_in @member
    end
    
    describe "GET index" do
      it "gets all custom collections" do
        get :index, {}
        assigns(:custom_collections).should eq([@cc])
      end
    end

    describe "GET show" do
      it "assigns the requested custom collection to @cc" do
        get :show, {:id => @cc.id}
        assigns(:custom_collection).should eq(@cc)
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
        get :edit, {:id => @cc.id}
        response.should redirect_to root_url
      end
    end
    
  end
end
