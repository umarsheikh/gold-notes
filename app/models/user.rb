require 'inline'
class User < ActiveRecord::Base
  validates_uniqueness_of :name
  inline do |builder|
    builder.include "<pthread.h>"

    builder.c "
      long factorial(int max) {
        int i=max, result=1;
        while (i >= 2) { result *= i--; }
        return result;
      }"

  end

  def self.example_threader(list_of_names = [['hello','mellow'],['harry','larry'],['umar','sheikh']])

    threads = []
    puts "usr count #{User.count}"
    list_of_names.each do |name_sub_array|
      threads << Thread.new(name_sub_array) do |names|
        puts "creating #{names.length} records for #{names}"
        names.each do |n|
          User.find_or_create_by_name(n)
        end
      end
    end

    threads.each do |t|
      t.join
    end
    puts "user count #{User.count}"
  end
end
