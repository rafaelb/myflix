shared_examples "requires sign in" do
  it "redirects to the login_path" do
    clear_current_user
    action
    expect(response).to redirect_to(login_path)
  end
end

shared_examples "require guest" do
  it "redirects to the home path" do
    set_current_user
    action
    expect(response).to redirect_to(home_path)
  end
end