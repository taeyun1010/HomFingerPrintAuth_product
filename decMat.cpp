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

// decrypt given plaintext (0 or 1), using sec.key previously generated
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
    
    if (nrhs != 3){
        cout << "requires 3 parameters: a b var\n";
        return;
    }

    //reads the secret key from file
    FILE* secret_key = fopen("secret.key","rb");
    TFheGateBootstrappingSecretKeySet* key = new_tfheGateBootstrappingSecretKeySet_fromFile(secret_key);
    fclose(secret_key);
    int b;

    int plaintext;
    //if necessary, the params are inside the key
    const TFheGateBootstrappingParameterSet* params = key->params;

    //read the 16 ciphertexts of the result
    LweSample* ciphertext = new_gate_bootstrapping_ciphertext_array(1, params);
    const int32_t n = params->in_out_params->n;
    
    int *a = (int*) mxGetPr(prhs[0]);
    b = mxGetScalar(prhs[1]);
    double var = mxGetScalar(prhs[2]);
    
    for (int i =0; i< n ; i++){
        //cout << "a[i] = " << a[i] << "\n";
        ciphertext[0].a[i] = a[i];
    }
 
    
    ciphertext[0].b = b;
    ciphertext[0].current_variance = var;
//    
//     
//     mxFree(SKfilename);
//     


    int ai = bootsSymDecrypt(&ciphertext[0], key)>0;
    int16_t int_answer;
    int_answer |= (ai<<0);

    plhs[0] = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);
    int *answer = (int*) mxGetData(plhs[0]);
    //int *a = (int*) mxGetPr(plhs[0]);
    *answer = int_answer;
    
    
    
    //answer = &ct;
    
    
    //cout << "decrypted = "<< decrypted << "\n";
    
    //plhs[0] = answer;
    
    return;


}
