class Server < ActiveRecord::Base
  attr_accessible :account,
                  :base_hardware,
                  :cpus,
                  :custom_parameters,
                  :hdd,
                  :memory,
                  :platform,
                  :pool,
                  :public_keys,
                  :service_code,
                  :status,
                  :transfer,
                  :title,
                  :uuid,
                  :recipe_ids


  serialize :base_hardware, Hash
  serialize :custom_parameters, Hash

  belongs_to :account
  belongs_to :matrix_machine
  belongs_to :platform

  validates_presence_of :account
  validates_numericality_of :cpus, :hdd, :memory
  validates_presence_of :cpus, :hdd, :memory

  scope :not_uninstalled, where('status <> ?', :uninstalled)
  scope :management_by_account, -> { includes(:matrix_machine).where("matrix_machines.management_type = (?)", MANAGEMENT_BY_ACCOUNT) }

  MANAGEMENT_BY_ACCOUNT = 'G0'
end
