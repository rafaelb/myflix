def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_admin_user(admin=nil)
  user = Fabricate(:user, admin: true)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def clear_admin
  user = User.find(session[:user_id])
  user.admin = false
  user.save
end

def clear_current_user
  session[:user_id] = nil
end

def current_user
  User.find(session[:user_id])
end

def sign_in_user(a_user=nil)
  user = a_user || Fabricate(:user)
  visit login_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign In'
end

def sign_in_admin(a_user=nil)
  user = a_user || Fabricate(:user, admin: true)
  visit login_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign In'
end

def sign_out
  visit logout_path
end