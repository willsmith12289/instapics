class Post < ActiveRecord::Base
  validates :caption, length: { minimum: 3, maximum: 300 }
  validates :user_id, presence: true
  validates :image, presence: true

  has_attached_file :image, styles: { :medium => "640x"}

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  
  belongs_to :user

  has_many :comments, dependent: :destroy

  paginates_per 3

  acts_as_votable

  
end
