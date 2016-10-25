class DowngradeController < ApplicationController


  def create
    # flash[:notice] = "USER WAS: #{current_user}"
    current_user.role = 0
    @wikis = Wiki.all
    @wikis.each do |wiki|
      if wiki.private == true && wiki.user_id == current_user.id
        wiki.private = false
        wiki.save!
      end
    end
    if current_user.save
      flash[:notice] = "Thank you, #{current_user.username}! You have successfully downgraded your account to STANDARD."
    else
      flash[:alert] = "There was a problem updating you account!  Please contact the system admin."
    end
    redirect_to root_path
  end


end
