#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <iostream>
#include <cstdlib>
#include <tfhe/tfhe.h>
#include <tfhe/tfhe_io.h>
#include <cassert>
#include <mex.h>


using namespace std;

// encrypt given plaintext, using sec.key previously generated
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    
    if (nrhs != 1){
        cout << "requires 1 parameter: plaintext\n";
        return;
    }


    int plaintext = mxGetScalar(prhs[0]);

//     //
//     //
    //reads the secret key from file
    FILE* secret_key = fopen("secret.key","rb");
    TFheGateBootstrappingSecretKeySet* key = new_tfheGateBootstrappingSecretKeySet_fromFile(secret_key);
    fclose(secret_key);


	//if necessary, the params are inside the key
    const TFheGateBootstrappingParameterSet* params = key->params;
//     const LweParams *in_out_params = params->in_out_params;
    LweSample *ciphertext = new_gate_bootstrapping_ciphertext_array(1,params);
    bootsSymEncrypt(&ciphertext[0], (plaintext>>0)&1, key);
    const int32_t n = params->in_out_params->n;
    
//     //
//     //


// //    
// //     
// //     mxFree(SKfilename);
// //     



//     plhs[0] = mxCreateNumericMatrix(1, n, mxINT32_CLASS, mxREAL);
//     plhs[1] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);
//     plhs[2] = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL);
//     int *b = (int*) mxGetData(plhs[1]);
//     int *a = (int*) mxGetData(plhs[0]);
//     double *var = (double*) mxGetData(plhs[2]);
    
//     for (int j=0; j<n; j++){
//         a[j] = ciphertext[0].a[j];

//     }
//     *b = ciphertext[0].b;
//     *var = ciphertext[0].current_variance;


    //
    //
    plhs[0] = mxCreateNumericMatrix(1, 500, mxINT32_CLASS, mxREAL);
    plhs[1] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);
    plhs[2] = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL);
    int *b = (int*) mxGetData(plhs[1]);
    int *a = (int*) mxGetData(plhs[0]);
    double *var = (double*) mxGetData(plhs[2]);
    
    for (int j=0; j<500; j++){
        a[j] = 1;

    }
    *b = 1;
    *var = 1;

    delete_gate_bootstrapping_secret_keyset(key);
    // delete_gate_bootstrapping_parameters(params);
    delete_gate_bootstrapping_ciphertext_array(1, ciphertext);
    //
    //


    return;


}
