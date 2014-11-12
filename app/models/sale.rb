require 'securerandom'
require 'bcrypt'
class Sale < ActiveRecord::Base
  include BCrypt

  after_initialize :apply_defaults

  attr_accessor :generated_password

  def password
    @password ||= Password.new(password_hash)
  end

  private

  def apply_defaults
    if self.password_hash.nil?
      self.generated_password = random_password
      self.password = self.generated_password
    end
  end

  def random_password
    SecureRandom.urlsafe_base64.first(8)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
