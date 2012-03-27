#include "string.h"
#include "stdlib.h"
#include "stdio.h"
#include <pthread.h>

int threaded(void *arg){
  int i;
  char ** names = (char **)arg;
  for(i = 0; i < 2; i++){
  printf("thread: save name %s to the database\n", names[i]);
  sleep(1);
  // save the names[i] to database
  }
  
return 0;
}

int main(int argc, char *argv[]){
  pthread_t pth;
  
  int i = 9;
  int j;
  int * c = (int *)malloc(sizeof(int));
  char *** array_of_names;
  int arr_length = 3;
  char str[10];
  int slice = 2;
  int uniform_name_length = 10;
  pthread_t *p = (pthread_t *)malloc(arr_length * sizeof(pthread_t));
  array_of_names = (char ***)malloc(arr_length * sizeof(char **));
 
  for(i = 0; i < arr_length; i++) 
  {
    array_of_names[i] = (char **)malloc(slice * sizeof(char *));
 
    for(j = 0; j < slice; j++)
    {
      array_of_names[i][j] = (char *)malloc(uniform_name_length * sizeof(char));
      sprintf(str, "name-%d-%d", i, j);
      strcpy(array_of_names[i][j], str);
    }
  }

  for(i = 0; i < arr_length; i++)
  {   
      *c = i;
      pthread_create(&p[i], NULL, (void *)threaded, array_of_names[i]);
  }
  for(i = 0; i < arr_length; i++)
  {
    pthread_join(p[i], NULL);
  }
  return 0;
}
