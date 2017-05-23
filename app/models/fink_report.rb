class FinkReport < ActiveRecord::Base

  require 'httparty'

  validates_uniqueness_of :url
  validates_presence_of :url
  validate :check_remote

  private

  def check_remote
    if url.blank?
      errors.add(:url, "cannot be blank")
    end
    if url.split('://').first != 'https' && url.split('://').first != 'http'
      errors.add(:url, "Cannot be local")
    end

    return false if errors.any?

    remote = HTTParty.head(url)
    if remote.response.code.to_i == 200 && remote.response.header['content-length'].to_i > 0
      errors.add(:url, "Remote target exists and is not empty")
      return false
    else
      return true
    end
  end

end
