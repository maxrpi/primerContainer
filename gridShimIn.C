// =================================================================================
//    Read a grid from a data base and output the data to a plain text file. 
//   
//  This routine can be changed to create an output file with any desired format.
//
// Example:
//     gridShimIn cic.hdf cic.out
//     mpirun -np 2 gridShimIn cic.hdf cic.out
// ==================================================================================

#include "Overture.h"  
#include "PlotStuff.h"
#include "display.h"
#include "ParallelUtility.h"
#include <stdlib.h>
#include "inAndOut.h"

#define FOR_3D(i1,i2,i3,I1,I2,I3) \
    int I1Base =I1.getBase(),   I2Base =I2.getBase(),  I3Base =I3.getBase();  \
    int I1Bound=I1.getBound(),  I2Bound=I2.getBound(), I3Bound=I3.getBound(); \
    for(i3=I3Base; i3<=I3Bound; i3++) \
    for(i2=I2Base; i2<=I2Bound; i2++) \
    for(i1=I1Base; i1<=I1Bound; i1++)

#define FOR_3(i1,i2,i3,I1,I2,I3) \
    I1Base =I1.getBase(),   I2Base =I2.getBase(),  I3Base =I3.getBase();  \
    I1Bound=I1.getBound(),  I2Bound=I2.getBound(), I3Bound=I3.getBound(); \
    for(i3=I3Base; i3<=I3Bound; i3++) \
    for(i2=I2Base; i2<=I2Bound; i2++) \
    for(i1=I1Base; i1<=I1Bound; i1++)


int main(int argc, char *argv[])
{
  Overture::start(argc,argv);  // initialize Overture
  const int np= max(1,Communication_Manager::numberOfProcessors());  // number of processors
  const int myid=max(0,Communication_Manager::My_Process_Number);    // my rank 

  printF(" Usage: gridShimIn gridName.hdf outfile.hdf \n");

  aString nameOfOGFile;
  const char *fileName;
  if( argc==3 )
  {
    nameOfOGFile=argv[1];
    fileName=argv[2];
  }
  else
  {
    printF("Usage: gridShimIn gridName.hdf outfile.hdf \n");
    Overture::abort("error");
  }
  


  // Read in a CompositeGrid
  CompositeGrid cg;
  getFromADataBase(cg,nameOfOGFile);
  const int numberOfDimensions=cg.numberOfDimensions();
  
  const IntegerArray & ni = cg.numberOfInterpolationPoints;
  int grid=0;
  {
    MappedGrid & c = cg[grid];
    c.update(MappedGrid::THEvertex | MappedGrid::THEmask );  // create the vertex and mask arrays

    const IntegerArray & d  = c.dimension();
    const IntegerArray & gir= c.gridIndexRange();
    const IntegerArray & bc  = c.boundaryCondition();  // unused for now


    printf("%i %s (grid and name)\n"
	    "%i %i %i %i %i %i (dimension(0:1,0:2), array dimensions)\n"
	    "%i %i %i %i %i %i (gridIndexRange(0:1,0:2), grid bounds)\n"
	    "%i %i %i %i %i %i (boundaryCondition(0:1,0:2))\n"
	    "%i %i %i          (isPeriodic(0:2), 0=not, 1=deriv, 2=function)\n",
	    grid,(const char*)c.getName(),
	    d(0,0),d(1,0),d(0,1),d(1,1),d(0,2),d(1,2),
	    gir(0,0),gir(1,0),gir(0,1),gir(1,1),gir(0,2),gir(1,2),
	    bc(0,0),bc(1,0),bc(0,1),bc(1,1),bc(0,2),bc(1,2),
	    c.isPeriodic(0),c.isPeriodic(1),c.isPeriodic(2));
    
    

    const intArray & mask = c.mask();
    intSerialArray maskLocal; getLocalArrayWithGhostBoundaries(mask,maskLocal);          // local array on this processor
    const realArray & vertex = c.vertex();
    realSerialArray vertexLocal; getLocalArrayWithGhostBoundaries(vertex,vertexLocal);          // local array on this processor

    int nx = d(1,0) - d(0,0);
    int ny = d(1,1) - d(0,1);
    int k = vertexLocal.getBase(3);

    int **interior_box = (int **) malloc(sizeof(int *) * 2);
    interior_box[0] = (int *) malloc(sizeof(int) * numberOfDimensions);
    interior_box[1] = (int *) malloc(sizeof(int) * numberOfDimensions);
    int **domain_box = (int **) malloc(sizeof(int *) * 2);
    domain_box[0] = (int *) malloc(sizeof(int) * numberOfDimensions);
    domain_box[1] = (int *) malloc(sizeof(int) * numberOfDimensions);

    for (int i=0; i<2; i++)
      for (int j=0; j<numberOfDimensions; j++){
        interior_box[i][j] = gir(i,j)-d(0,j);
        domain_box[i][j] = d(i,j)-d(0,j);
      }

    // Note that k below is just 0, not a real loop index. Only one Z index.
    int  **desc = (int **) malloc( sizeof(int   *) * (d(1,0) - d(0,0) + 1));
    double ***xy = (double ***) malloc( sizeof(double**) * (d(1,0) - d(0,0) + 1));
    for(int i=0; i <= d(1,0) - d(0,0); i++){
      *(desc+i) = (int *) malloc( sizeof(int   *) * (d(1,1) - d(0,1) + 1) );
      *(xy + i) = (double **) malloc( sizeof(double*) * (d(1,1) - d(0,1) + 1) );
      for(int j = 0; j <= d(1,1) - d(0,1); j++){
        desc[i][j] = maskLocal(i + d(0,0), j + d(0,1), k) >= 0 ? 0: 1;
        *(*(xy   + i) + j) = (double *) malloc( sizeof(double) * numberOfDimensions);
        for(int l = 0; l < numberOfDimensions; l++){
          xy[i][j][l] = vertexLocal(i + d(0,0), j + d(0,1), k + d(0,2), l);
        }

      }
    }
    std::cout << interior_box[0][0] << interior_box[0][1] 
      << interior_box[1][0] << interior_box[1][1] 
      << std::endl;
    int status = sendToFile(fileName, numberOfDimensions, interior_box, domain_box, xy, desc);

    c.destroy(MappedGrid::THEvertex | MappedGrid::THEmask );  // destroy arrays to save space

  }
  printF("Output written to file %s\n", fileName);
  
  Overture::finish();          
  return 0;
}