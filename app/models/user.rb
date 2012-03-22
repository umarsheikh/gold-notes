require 'inline'
class User < ActiveRecord::Base
  validates_uniqueness_of :name
  inline do |builder|
    builder.include "<pthread.h>"
    builder.include '<iostream>'
    builder.include '<stdio.h>'
    builder.add_compile_flags '-x c++', '-lstdc++'
    builder.c "
      long factorial(int max) {
        int i=max, result=1;
        while (i >= 2) { result *= i--; }
        return result;
      }"
    builder.c '
      void hello(int i) {
        while (i-- > 0) {
          std::cout << "hello" << std::endl;
        }
      }'
  end


  def self.example_pthread
    list_of_names = [['hello','mellow'],['harry','larry'],['umar','sheikh']]
    u = User.new
    thread = u.create_thread
    thread.execute(['hello', 'mellow'])
  end
  def self.example_hello
    u = User.new
    u.hello 8
  end
  def self.add(n)
    u = User.find_or_create_by_name(n)
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



class Example

  inline :C do |builder|
    builder.include "<pthread.h>"

    builder.c '
      static void run_thread(VALUE name){
          // I added a ruby User class to test posting a variable from thread to db
          VALUE user = rb_const_get( rb_cObject, rb_intern("User") );
          rb_funcall(user, rb_intern("add"), 1, name);
      }'


    builder.c '
    static void simple(VALUE name){
        run_thread(self, name);
    }'      


    builder.c '
    static void threads(VALUE name){
        pthread_t pth;

        pthread_create(&pth, NULL, (void *)run_thread, (VALUE *)name );

        pthread_join(pth, NULL);
    }'              
  end

end
# Example.new.run_thread 'Adam' now works
# Example.new.simple 'Adam apple' now works
# Example.new.threads('Adam') segfaults!
