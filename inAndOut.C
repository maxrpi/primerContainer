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

  std::cout << interior_box[0][0] << interior_box[0][1] 
      << interior_box[1][0] << interior_box[1][1] 
      << std::endl;
  out << interior_box[0][0] << interior_box[0][1] 
      << interior_box[1][0] << interior_box[1][1] 
      << std::endl;
  out << domain_box[0][0] << domain_box[0][1] 
      << domain_box[1][0] << domain_box[1][1] 
      << std::endl;
  
  for (int i=domain_box[0][0]; i<=domain_box[0][1]; i++){
    for (int j=domain_box[1][0]; j<=domain_box[1][1]; j++){
      for (int k=0; k<dim; k++){
        out << xy[i][j][k];
      }
    }
  }
  out << std::endl;

  for (int i=domain_box[0][0]; i<=domain_box[0][1]; i++){
    for (int j=domain_box[1][0]; j<=domain_box[1][1]; j++){
      out << mask[i][j];
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

  in >> interior_box[0][0] >> interior_box[0][1]
     >> interior_box[1][0] >> interior_box[1][1] ;
  in >> domain_box[0][0] >> domain_box[0][1]
     >> domain_box[1][0] >> domain_box[1][1] ;
  
  for (int i=domain_box[0][0]; i<=domain_box[0][1]; i++){
    for (int j=domain_box[1][0]; j<=domain_box[1][1]; j++){
      for (int k=0; k<*dim; k++){
        in >> xy[i][j][k];
      }
    }
  }

  for (int i=domain_box[0][0]; i<=domain_box[0][1]; i++){
    for (int j=domain_box[1][0]; j<=domain_box[1][1]; j++){
      in >> mask[i][j];
    }
  }

  in.close();
  return 0;
}