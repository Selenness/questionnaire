class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, dependent: :destroy
  validates :text, presence: true

  def to_search_result
    { body: self.text }
  end
end
