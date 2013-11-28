/* cufft_functions.c */
#include <cufft.h>
#include<stdio.h>
typedef size_t devptr_t;

int f_cudamalloc_(devptr_t *i, const int *n)
{
  void *tmp=0;
  int ret;
  /* printf("in f_cudamalloc_, before: %p\n", tmp); */
  ret = cudaMalloc(&tmp, *n);
  /* printf("in f_cudamalloc_,  after: %p\n", tmp); */
  *i = (devptr_t)tmp;
  return ret;
}

int f_cudamemcpy_host_to_device_(void *host_source, devptr_t *device_destination, const int *n)
{ 
  /* printf("in f_cudamemcpy_1: %f\n", *(double *)host_source); */
  /* printf("in f_cudamemcpy_2: %ld\n", *device_destination); */
  return cudaMemcpy(*device_destination, host_source, *n, cudaMemcpyHostToDevice);
}

int f_cudamemcpy_device_to_host_(devptr_t *device_source, void *host_destination, const int *n)
{ 
  /* printf("in f_cudamemcpy_3: %ld\n", *device_source); */
  return cudaMemcpy(host_destination, *device_source, *n, cudaMemcpyDeviceToHost);
}

int f_cudafree_(const devptr_t *dev_to_be_free)
{
    return cudaFree (*dev_to_be_free);
}

int f_cufftexecz2z_(const int *plan, devptr_t *idata, devptr_t *odata, const int *direction)
{
  return cufftExecZ2Z(*plan, (cufftDoubleComplex *)*idata, (cufftDoubleComplex *)*odata, *direction);

}
/* Local variables:
   compile-command: "gfortran -Wall -ffree-form -c cufft_module.f && gcc -I/usr/local/cuda/include -c cufft_functions.c && gfortran -Wall -ffree-form -c cufft_check.f && gfortran -Wall -o cufft_check cufft_check.o cufft_functions.o cufft_module.o -L/usr/local/cuda/lib64 -lcufft -lcudart && ./cufft_check"
   End: */
