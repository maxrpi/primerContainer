#include <iostream>
#include <fstream>
#include "inAndOut.h"

int sendToFile(const char* fileName, int dim, int **interior_box, int **domain_box, double ***xy, int **mask){
  std::ofstream out;

  std::cout << "Arrived in sendToFile" <<std::endl;
  out.open(fileName);
  if(!out){
    std::cerr << "Error: file '" << fileName << "' could not be opened!" << std::endl;
    std::exit(1);
  }

  out << dim << std::endl;

  std::cout << interior_box[0][0] << "\t" << interior_box[0][1] 
      << "\t" << interior_box[1][0] << "\t" << interior_box[1][1] 
      << std::endl;
  out << interior_box[0][0] << "\t" << interior_box[0][1] 
      << "\t" << interior_box[1][0] << "\t" << interior_box[1][1] 
      << std::endl;
  out << domain_box[0][0] << "\t" << domain_box[0][1] 
      << "\t" << domain_box[1][0] << "\t" << domain_box[1][1] 
      << std::endl;
  
  for (int i=domain_box[0][0]; i<=domain_box[1][0]; i++){
    for (int j=domain_box[0][1]; j<=domain_box[1][1]; j++){
      for (int k=0; k<dim; k++){
        out << xy[i][j][k] << "\t";
      }
    }
  }
  out << std::endl;

  for (int i=domain_box[0][0]; i<=domain_box[1][0]; i++){
    for (int j=domain_box[0][1]; j<=domain_box[1][1]; j++){
      out << mask[i][j] << "\t";
    }
  }
  out << std::endl;

  out.close();
  return 0;
  
}

int getFromFile(const char* fileName, int *dim, int **interior_box, int **domain_box, double ***xy, int **mask){
  std::ifstream in;

  in.open(fileName);
  if(!in){
    std::cerr << "Error: file '" << fileName << "' could not be opened!" << std::endl;
    std::exit(1);
  }

  in >> *dim;
  interior_box = (int **) malloc(sizeof(int *) * 2);
  interior_box[0] = (int *) malloc(sizeof(int) * *dim);
  interior_box[1] = (int *) malloc(sizeof(int) * *dim);
  domain_box = (int **) malloc(sizeof(int *) * 2);
  domain_box[0] = (int *) malloc(sizeof(int) * *dim);
  domain_box[1] = (int *) malloc(sizeof(int) * *dim);

  for (int i=0; i<2; i++){
    for (int j=0; j<*dim; j++){
      in >> interior_box[i][j];
    }
  }

  for (int i=0; i<2; i++){
    for (int j=0; j<*dim; j++){
      in >> domain_box[i][j];
    }
  }

  xy = (double ***) malloc( sizeof(double**) * (domain_box[1][0] - domain_box[0][0] + 1) );
  for(int i=0; i <= domain_box[1][0] - domain_box[0][0]; i++){
    *(xy + i) = (double **) malloc( sizeof(double*) * (domain_box[1][1] - domain_box[0][1] + 1) );
    for(int j = 0; j <= domain_box[1][1] - domain_box[0][1]; j++){
      *(*(xy + i)+j) = (double *) malloc( sizeof(double*) * *dim);
      for(int k = 0; k < *dim; k++){
        in >> xy[i][j][k];
      }
    }
  }

  mask = (int **) malloc( sizeof(int   *) * (domain_box[1][0] - domain_box[0][0] + 1) );
  for(int i=0; i <= domain_box[1][0] - domain_box[0][0]; i++){
    *(mask+i) = (int *) malloc( sizeof(int   *) * (domain_box[1][1] - domain_box[0][1] + 1) );
    for(int j = 0; j <= domain_box[1][1] - domain_box[0][1]; j++){
      in >> mask[i][j];
    }
  }
  in.close();
  return 0;
}