class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable
  validates :password, length: { minimum: 6, maximum: 100 }, on: :create
  validates :full_name, presence: true

  scope :admin, -> { User.where(role: true) }
  scope :not_admin, -> { User.where(role: false) }

  after_create_commit { broadcast_append_to "users" }
  after_destroy_commit { broadcast_remove_to "users" }
  after_commit :counter, on: %i[create destroy update]

  def counter
    broadcast_update_to("user_all", target: "user_count", html: User.count)
    broadcast_update_to("user_count_admin", target: "count_admin", html: User.admin.count)
    broadcast_update_to("user_count_not_admin", target: "count_not_admin", html: User.not_admin.count)
  end
end
