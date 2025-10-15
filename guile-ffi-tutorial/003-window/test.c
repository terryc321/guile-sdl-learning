
#include <stdio.h>
#include <libguile.h>

/*
  essence we can read the bootstrap script from a file and use that to start everything off
  except we cannot use SDL library with libguile apparently?
  can we even make a binary?
 */

SCM hello_from_guile() {

    SCM guileHello;
    //scm_init_guile();

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

