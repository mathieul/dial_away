class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      set_user_session(@user)
      create_user_on_authy(@user)
      send_authy_sms(@user)
      redirect_to show_verify_users_path
    else
      render :new
    end
  end

  def show_verify
    return redirect_to new_user_path unless session[:user_id]
  end

  def verify
    @user = current_user
    token = Authy::API.verify(id: @user.authy_id, token: params[:token])

    if token.ok?
      @user.verify!
      send_message("You did it! Signup complete :)", user: @user)
      redirect_to user_path(@user)
    else
      flash.now[:danger] = "Incorrect code, please try again"
      render :show_verify
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:email, :password, :name, :country_code, :phone_number)
  end

  def create_user_on_authy(user)
    Authy::API.register_user(
      email:        user.email,
      cellphone:    user.phone_number,
      country_code: user.country_code
    ).tap do |authy|
      user.update(authy_id: authy.id)
    end
  end

  def send_authy_sms(user)
    Authy::API.request_sms(id: user.authy_id)
  end

  def send_message(content, user:)
    client = Twilio::REST::Client.new(twilio_config[:account_sid], twilio_config[:auth_token])
    client.api.accounts(twilio_config[:account_sid]).messages.create(
      from: twilio_config[:caller],
      to:   user.formatted_phone_number,
      body: content
    )
  end

  def twilio_config
    @twilio_config ||= Rails.application.credentials.twilio
  end
end
