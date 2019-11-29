class ConfirmDeletionOfAdminCallback < ApplicationRecord
  def self.before_destroy(user)
    if user.admin? and User.where(admin: true).count == 1
      throw(:abort)
      
      #下記の書き方はできない。undefined メソッドになる。
      #flash[:alert] = '管理ユーザーが一人しか登録されていないため、削除できません'
      #redirect_to admin_users_path
    end
  end
end
