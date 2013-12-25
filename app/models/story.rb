# -*- coding: utf-8 -*-
class Story < ActiveRecord::Base
  paginates_per 10

  validates :text, :presence => true,
                   :length => {:minimum => 1, :maximum => 1000}
end
