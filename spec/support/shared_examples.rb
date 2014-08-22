shared_examples "requires sign in" do
  it "redirects to the login_path" do
    clear_current_user
    action
    expect(response).to redirect_to(login_path)
  end
end