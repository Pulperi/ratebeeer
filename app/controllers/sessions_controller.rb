class SessionsController < ApplicationController
  require 'securerandom'
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

  def create_oauth
    auth = env["omniauth.auth"].info
    user = User.find_by username: auth.nickname, githubpath: auth.urls[:GitHub]
    if user
      if user.deactive
        redirect_to :back, notice: 'Your account is frozen, please contact admin'
      else
        reset_session
        session[:user_id] = user.id
        redirect_to user_path(user), notice: 'Welcome back!'
      end
    else
      pass = gen_pass
      user = User.create(username: auth.nickname, githubpath: auth.urls[:GitHub], password: pass, password_confirmation: pass)
      reset_session
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome #{user.username}! New user account has been created for you. Your password is #{pass}. Change it asap in account control."
    end
  end

  def gen_pass
    pass = ''
    while /[A-Z]/.match(pass).nil? || /[0-9]/.match(pass).nil?
      pass = SecureRandom.urlsafe_base64(10)
    end
    pass
  end
end