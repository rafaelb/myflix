require 'rails_helper'

describe RelationshipsController do
  describe "GET#index" do
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
    
  end
end