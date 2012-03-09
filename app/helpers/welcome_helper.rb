module WelcomeHelper
  def displayfileorder
    $fileorder.collect{|a| a.split("/").last}.join(", ")
  end
end
