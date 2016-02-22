class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    # haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      if user.deactive
        redirect_to :back, notice: 'Your account is frozen, please contact admin'
      else
        reset_session
        session[:user_id] = user.id
        redirect_to user_path(user), notice: 'Welcome back!'
      end
    else
      redirect_to :back, notice: 'Username and/or password mismatch'
    end
  end

  def destroy
    # nollataan sessio
    # session[:user_id] = nil
    reset_session
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end