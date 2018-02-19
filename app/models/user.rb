# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  country_code    :string           default("1"), not null
#  phone_number    :string           not null
#  authy_id        :string
#  verified        :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_authy_id  (authy_id) UNIQUE
#  index_users_on_email     (email) UNIQUE
#

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true,
                    format: {with: /\A.+@.+$\Z/},
                    uniqueness: true
  validates :name, presence: true
  validates :country_code, presence: true
  validates :phone_number, presence: true

  def verify!
    update(verified: true)
  end

  def formatted_phone_number
    country_code + phone_number
  end
end
