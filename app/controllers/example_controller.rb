class ExampleController < ApplicationController
  def cucumber_xml
  end

  def taggings
  end
  
  def with_form
    @example = Object.new
    class << @example
      
    end
  end
end
