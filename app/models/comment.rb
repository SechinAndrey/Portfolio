class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :content,  presence: true, length: { maximum: 10000}
  validates :user_id,  presence: true
  validates :post_id,  presence: true
end
