class ApplicationController < ActionController::Base

# このプロジェクト固有のメソッド名には先頭に"fsjs_"が付与されています。

  helper_method :fsjs_current_user
  before_action :fsjs_login?
  
# -----------------------------
#  ログイン系
# -----------------------------
  # ログイン済みならばユーザー情報を取得する
  def fsjs_current_user
    @fsjs_current_user ||= FsjsUser.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  def fsjs_login?
    if fsjs_current_user.blank?
      redirect_to login_path
    end  
  end
  
# -----------------------------
#  メソッド
# -----------------------------  
  # 対象科目の合計金額を取得する
  def fsjs_get_account_total(yyyy,obj,target_id)

    # 元入金テーブル
    capital = FsjsCapital.where(yyyy: yyyy) 
    
    if capital.blank?
      return 0
    end
    
    # 借方
    sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND debit_account_id = ?"
    debit = FsjsJournal.find_by_sql([sql,yyyy,target_id]) 
    
    # 貸方
    sql = "SELECT IFNULL(SUM(money),0) AS money  FROM fsjs_journals WHERE yyyy = ? AND credit_account_id = ?"
    credit = FsjsJournal.find_by_sql([sql,yyyy,target_id]) 
          
    if(obj == :m4)
      # 未払金
      total = capital[0][obj] + credit[0][:money] - debit[0][:money]
    else
      # 現金、その他の預金、前払金
      total = capital[0][obj] + debit[0][:money] - credit[0][:money]
    end  
  end 
  
end
