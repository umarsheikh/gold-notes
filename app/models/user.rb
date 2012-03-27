require 'inline'
class User < ActiveRecord::Base
  validates_uniqueness_of :name
  inline do |builder|
    builder.include "<pthread.h>"
    builder.include '<iostream>'
    builder.include '<stdio.h>'
    builder.include '<stdlib.h>'
    builder.include '<string.h>'


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
      static void threaded_func(VALUE x) {
        printf("i am a threaded function");
//        return 0;
      }
    '
    builder.c '
      static void threads2() {
        pthread_t pth;
        int i = 9;
        pthread_create(&pth, NULL, (void *)threaded_func, (int *) i);
        pthread_join(pth, NULL);
//        return 0;
      }
    '
    builder.c '
    static void threads(VALUE name){
        pthread_t pth;

        pthread_create(&pth, NULL, (void *)run_thread, (VALUE *)name );

        pthread_join(pth, NULL);
        return name;
    }'
    	
    builder.c '
      void threaded(VALUE arg){
          int* p = (int *)malloc(sizeof(int));
          int i;
          if(TYPE(arg) == T_RATIONAL) {
            printf("got it, type is rational\n");
          }
          
          printf("i get type %d and potentially value \n", TYPE(arg));

        
      }
    '
    builder.c '
      int create_num_threads(VALUE data) {
        int len, i, j, t, rows, cols, tt, length;
        char ***wholedata;
        char names[24][15] = {"T_NIL", "T_OBJECT", "T_CLASS",	"T_MODULE",	"T_FLOAT", "T_STRING",	
          "T_REGEXP",	"T_ARRAY", "T_HASH", "T_STRUCT", "T_BIGNUM", "T_FIXNUM",	
          "T_COMPLEX", "T_RATIONAL", "T_FILE", "T_TRUE", "T_FALSE", "T_DATA",
          "T_SYMBOL", "T_ICLASS", "T_MATCH", "T_UNDEF", "T_NODE", "T_ZOMBIE"};
        int array[24] = {T_NIL,	T_OBJECT,	T_CLASS,	T_MODULE,	T_FLOAT,	T_STRING,	
          T_REGEXP,	T_ARRAY,	T_HASH,	T_STRUCT,	T_BIGNUM,	T_FIXNUM,	
          T_COMPLEX,	T_RATIONAL,	T_FILE,	T_TRUE,	T_FALSE,	T_DATA,	
          T_SYMBOL, T_ICLASS, T_MATCH, T_UNDEF, T_NODE, T_ZOMBIE};

        char ** mydata;
        int * c = (int *)malloc(sizeof(int));
        VALUE * matrix, *matrixrow, *matrixcol;
        char *p, *q;
        pthread_t *pth;

        for(i = 0; i < 24; i++) {
          printf("%s = %d\t", names[i], array[i]);
        }
        printf("\n");
        t = TYPE(data);
        if(t == T_ARRAY){
          printf("processing array type %d\n", t);
          rows = RARRAY_LEN(data);
          pth = (pthread_t *)malloc(rows * sizeof(pthread_t));
          wholedata = (char ***)malloc(sizeof(char **) * rows);
          matrix = RARRAY_PTR(data);
          
          for(i = 0; i < rows; i++) {

            matrixrow = RARRAY_PTR(matrix[i]);
            len = RARRAY_LEN(matrix[i]);
            printf("type of matrix[%d] entry is %d and its len is %d\n", i, TYPE(matrix[i]), len);
            printf("row %d has columns %d\n", i, len);
            tt = TYPE(matrixrow);
            wholedata[i] = (char **)malloc(sizeof(char *) * len);
            *c = i;
            for(j = 0; j < len; j++) {
              length = RSTRING_LEN(matrixrow[j]);
              printf("length %d name %s\n", length, StringValuePtr(matrixrow[j]));
              wholedata[i][j] = (char *)malloc(sizeof(char) * (1+length));
            }
            pthread_create(&pth[i], NULL, (void *)threaded, c);
          }
          for(i = 0; i < rows; i++) {
            pthread_join(pth[i], NULL);
          }
        }
        return 0;
      }
    '
  end
# Example.new.run_thread 'Adam' now works
# Example.new.simple 'Adam apple' now works
# Example.new.threads('Adam') segfaults!
# Example.new.threads2() works!
#Example.new.create_num_threads([["hello","mellow"],["harry","larry"], ["umar", "sheikh"]])
end

