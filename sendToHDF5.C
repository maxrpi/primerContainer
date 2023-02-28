#include <string>
#ifdef OLD_HEADER_FILENAME
#include <iostream.h>
#else
#include <iostream>
#endif

#include "H5Cpp.h"
#include "sendToHDF5.h"

#ifndef H5_NO_NAMESPACE
using namespace H5;
#endif

int sendToHDF5(std::string filename,
              int spacedim,
              int **interior_box,
              int **domain_box,
              double ***xy,
              int ***mask)
{
  try
  {
    Exception::dontPrint();

    H5File* file = new H5File( filename, H5F_ACC_TRUNC );

    // Create dataspace for dataset in file.
    hsize_t dimsize[] = {1};
    DataSpace fspace = DataSpace( 1, dimsize );
    DataSet* dataset = new DataSet( file->createDataSet( "dim", PredType::NATIVE_INT, fspace ) );
    dataset->write( &spacedim, PredType::NATIVE_INT );
    delete dataset;

    hsize_t boxsize[] = {spacedim, 2};
    fspace = DataSpace(1, boxsize);
    dataset = new DataSet( file->createDataSet( "interior_box", PredType::NATIVE_INT, fspace ) );
    dataset->write( interior_box, PredType::NATIVE_INT );
    delete dataset;

    fspace = DataSpace(1, boxsize);
    dataset = new DataSet( file->createDataSet( "domain_box", PredType::NATIVE_INT, fspace ) );
    dataset->write( domain_box, PredType::NATIVE_INT );
    delete dataset;

    int nx = domain_box[1][0] - domain_box[0][0];
    int ny = domain_box[1][1] - domain_box[0][1];
    hsize_t gridsize[] = {nx, ny};
    fspace = DataSpace(spacedim, gridsize);
    dataset = new DataSet( file->createDataSet( "xy", PredType::NATIVE_DOUBLE, fspace ) );
    dataset->write( xy, PredType::NATIVE_DOUBLE );
    delete dataset;

    fspace = DataSpace(spacedim, gridsize);
    dataset = new DataSet( file->createDataSet( "mask", PredType::NATIVE_INT, fspace ) );
    dataset->write( mask, PredType::NATIVE_INT );
    delete dataset;

    delete dataset;
    delete file;
  } 

   // catch failure caused by the DataSet operations
  catch( DataSetIException error )
  {
    error.printErrorStack();
    return -1;
  }

  // catch failure caused by the DataSpace operations
  catch( DataSpaceIException error )
  {
    error.printErrorStack();
    return -1;
  }

  return 0;
}

