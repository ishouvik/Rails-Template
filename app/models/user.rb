class User < ActiveRecord::Base
  
  # Add Roles to model
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Tagging
  # acts_as_taggable_on :skills

  # Scopes
  scope :sorted,   lambda { order(updated_at: :desc) }
  scope :visible,  lambda { where.not(id: 1, name: '', username: '', email: '', active: false) }

  # Validations
  USERNAME_REGEX = /\A^[\w&-]+$\Z/

  validates :name, length: { maximum: 250 }

  validates :username,
              uniqueness: true,
              length:   { maximum: 250 }

  # Image uploader
  mount_uploader :avatar, ImageUploader

  # Active Record Callbacks
  after_create :add_user_role_in_registration

  private
  	def add_user_role_in_registration
  		self.add_role 'user'
	end
end
