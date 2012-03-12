module WelcomeHelper
  def displayfileorder
    $fileorder.collect{|a| a.split("/").last} * ", "
  end
end
