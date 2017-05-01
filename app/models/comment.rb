class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, dependent: :destroy
  validates :text, presence: true
end
