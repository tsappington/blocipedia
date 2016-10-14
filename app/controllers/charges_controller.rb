class ChargesController < ApplicationController

  class Amount
    def self.default
      15_00
    end
  end

  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Blocipedia Upgrade to Premimum - #{current_user.username}",
      amount: Amount.default
    }
  end

  def create
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      amount: Amount.default,
      description: "Blocipedia Upgrade to Premimum - #{current_user.username}",
      :currency    => 'usd'
    )

    current_user.role = 1
    if current_user.save
      flash[:notice] = "Thank you, #{current_user.username}! You have successfully upgraded your account to PREMIUM.  You can now write Private Wikis!"
    else
      flash[:alert] = "There was a problem updating you account!  Please contact the system admin."
    end

    # redirect_to user_path(current_user.username)
    redirect_to root_path

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
    end

end
