site :opscode

metadata

cookbook "chef-sugar"

group :integration do
  cookbook "minitest-handler"
  cookbook "apt"
  cookbook "yum"
  cookbook "build-essential"
  cookbook "python_test", :path => "./test/cookbooks/python_test"
end
