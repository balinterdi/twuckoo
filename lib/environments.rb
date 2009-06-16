module TwuckooEnvironment
  def set_testing
    ENV["CUCKOO_ENV"] = "testing"
  end
  def testing?
    ENV["CUCKOO_ENV"] == "testing"
  end
end