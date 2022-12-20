class Comment < ApplicationRecord
  belongs_to :creater, class_name: "User"
  belongs_to :board
end
