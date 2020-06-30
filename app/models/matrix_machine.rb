 # -*- coding: utf-8 -*-
 class MatrixMachine < ActiveRecord::Base
  CODES = %w(cpanel_linux debian ubuntu centos windows redhat fedora plesk
             plesk_windows opensuse archlinux)

  attr_accessible :name, :uuid, :platform_id, :management_type

  default_scope order: "matrix_machines.name asc"
end
