class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true, dependent: :destroy, touch: true
  validates :text, presence: true

  def to_search_result
    { body: self.text }
  end
end
