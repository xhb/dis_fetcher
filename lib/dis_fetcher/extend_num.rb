#!/usr/bin/ruby
# @Author: xhb
# @Date:   2016-07-24 00:32:46
# @Last Modified by:   xhb
# @Last Modified time: 2016-07-24 00:42:26

class Numeric

  def days
    self*24*60*60
  end
  
  def minutes
    self*60
  end
  
  def hours
    self*60*60
  end
  
  alias :hour :hours
  alias :minute :minutes
  alias :day :days

end
