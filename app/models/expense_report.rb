class ExpenseReport < ActiveRecord::Base
  has_many :expenses
  belongs_to :user
  
end
