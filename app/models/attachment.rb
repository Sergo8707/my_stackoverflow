# frozen_string_literal: true
class Attachment < ApplicationRecord
  belongs_to :attachable, optional: true, polymorphic: true

  mount_uploader :file, FileUploader
end
