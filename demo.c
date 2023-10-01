// License: CC0 - 2023

#include "ACBrNFeImport.h"
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if defined(WIN32)
#include <windows.h>
#else
#include <dlfcn.h>
#endif

int main() {
  // Load the ACBr NFe library dynamically
#ifdef WIN32
#if defined(ENVIRONMENT32)
  HMODULE libHandle = LoadLibraryW(L"ACBrNFe32.dll");
#else
  HMODULE libHandle = LoadLibraryW(L"ACBrNFe64.dll");
#endif
#else
#if defined(ENVIRONMENT32)
  void *libHandle = dlopen("libacbrnfe32.so", RTLD_LAZY);
#else
  void *libHandle = dlopen("libacbrnfe64.so", RTLD_LAZY);
#endif
#endif

  if (!libHandle) {
    fprintf(stderr, "Failed to load the ACBr NFe library: %s\n", dlerror());
    return 1;
  }

  // Define function pointers
  NFE_Inicializar nfe_Inicializar;
  NFE_Nome nfe_Nome;
  NFE_Versao nfe_Versao;

  // Load the functions
  nfe_Inicializar = (NFE_Inicializar)dlsym(libHandle, "NFE_Inicializar");
  nfe_Nome = (NFE_Nome)dlsym(libHandle, "NFE_Nome");
  nfe_Versao = (NFE_Versao)dlsym(libHandle, "NFE_Versao");

  if (!nfe_Inicializar || !nfe_Nome || !nfe_Versao) {
    fprintf(stderr, "Failed to load ACBr NFe functions: %s\n", dlerror());
    dlclose(libHandle);
    return 1;
  }

  // Call the ACBr NFe functions
  uintptr_t handle = 0; // Initialize the handle
  char nome[15];
  int nome_size = sizeof(nome);
  char versao[8];
  int size_ver = sizeof(versao);

  // nfe_Inicializar(&handle, "config_file_path", "encryption_key")
  if (nfe_Inicializar(&handle, "libacbrnfe64.ini", "") == 0) {
    printf("NFe Initialized\n");
  }

  if (nfe_Nome(handle, nome, &nome_size) == 0) {
    printf("NFe Nome: %s\n", nome);
  }

  if (nfe_Versao(handle, versao, &size_ver) == 0) {
    printf("NFe Versao: %s\n", versao);
  }

  // Unload the ACBr NFe library
  dlclose(libHandle);

  return 0;
}
