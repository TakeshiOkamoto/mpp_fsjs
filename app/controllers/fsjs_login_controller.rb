class FsjsLoginController < ApplicationController
  skip_before_action:fsjs_login?
  
  def new
    # ログイン済み    
    if fsjs_current_user
      redirect_to root_path
    end   
  end
  
  def create
    user = FsjsUser.find_by(name: login_params[:name])
 
    # パスワードの認証
    if user&.authenticate(login_params[:password])
      session[:user_id] = user.id
      session[:user_name] = user.name
      redirect_to root_path, notice: 'ログインしました。'
    else
      redirect_to login_path, alert: '名前またはパスワードが違います。'
    end
  end
    
  def destroy
    reset_session
    redirect_to login_path, notice: 'ログアウトしました。'      
  end
    
  private
 
  def login_params
    params.require(:login).permit(:name, :password)
  end    
end
