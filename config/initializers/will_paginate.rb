# WillPaginate configuration
require 'will_paginate'
require 'will_paginate/active_record'

if defined?(WillPaginate)
  WillPaginate.per_page = 20
end
