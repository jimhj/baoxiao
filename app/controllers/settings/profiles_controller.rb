class Settings::ProfilesController < Settings::ApplicationController
  def show
  end

  def update
    if current_user.update_attributes params.require(:user).permit(:name, :avatar, :remove_avatar)
      flash[:success] = I18n.t('settings.profiles.flashes.successfully_updated')
      redirect_to settings_profile_url
    else
      render :show
    end
  end
end