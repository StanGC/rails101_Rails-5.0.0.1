class Group < ApplicationRecord
	validates :title, presence: true
	belongs_to :uesr
end
