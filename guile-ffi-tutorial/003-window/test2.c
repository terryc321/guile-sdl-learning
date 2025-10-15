
#include <stdio.h>
#include <math.h>
#include <SDL2/SDL.h>
#include <libguile.h>


SCM hello_from_guile() {

    SCM guileHello;
    scm_init_guile();

    char code[] = "(display \"Hello from Guile! As simple function.\")";
    char newline[] = "(newline)";

    char filename[] = "hello-guile.scm";

    scm_c_eval_string(code);
    scm_c_eval_string(newline);

    scm_c_primitive_load(filename);

    guileHello = scm_variable_ref(scm_c_lookup("guile-hello"));
    scm_call_0(guileHello);

    return SCM_BOOL_T;
}


int main(){
  hello_from_guile();
  return 0;
}
