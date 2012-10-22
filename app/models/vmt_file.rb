class VmtFile < ActiveRecord::Base
  attr_accessible :filename, :description, :family, :is_locked, :vmtdata, :eco, :in_agile, :oem, :oem_group, :last_update_by, :last_updated, :revision
  validates :filename, :description, :vmtdata, :family, presence: true
  validates :filename, uniqueness: true
  validates :revision, numericality: {greater_than_or_equal_to: 1}
end